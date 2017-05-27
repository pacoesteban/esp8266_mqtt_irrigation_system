#!/usr/bin/env perl
#
# test irrigation controller
#
# Version 0.1
# Copyright (C) 2016 Paco Esteban <paco@onna.be>
# License MIT

use strict;
use warnings;
use v5.20;
use local::lib;
use Mojolicious::Lite;
use Mojo::Log;
use Mojolicious::Plugin::Config;
use Mojo::UserAgent;
use FindBin;
use Net::MQTT::Simple;
use List::MoreUtils qw(each_array);
use InfluxDB::LineProtocol qw( data2line );
use POSIX qw( strftime );

app->config( hypnotoad => { workers => 2 } );

my $config = plugin Config => { file => "$FindBin::Bin/app.conf" };
my $log = Mojo::Log->new( level => $config->{log}->{level} );
my $ua = Mojo::UserAgent->new;

get '/' => sub {
    my $c    = shift;
    my $data = getDetailedData( { node => 'SR01-IRR1', hours => 24 } );
    my $irr  = getLastIrr( { node => 'SR01-IRR1' } );
    $c->stash( mydata => $data, lastirr => $irr );
    $c->render( template => 'index' );
};

under '/api/v1';

get '/:deviceID' => sub {
    my $c    = shift;
    my @data = getLastData( $c->param('deviceID') );
    my $rain = rainForecast();

    $c->render(
        json => {
            status => "ok",
            sensor => $c->param('deviceID'),
            data   => {
                rainF         => $rain,
                temperature   => $data[0],
                humidity      => $data[1],
                soil_moisture => $data[2]
            }
        }
    );
};

post '/irrigate/:deviceID' => sub {
    my $c      = shift;
    my $onTime = 0;
    unless ( $c->req->json ) {
        $c->render(
            status => 400,
            json =>
              { status => "error", data => { message => "No JSON found" } }
        );
        return undef;
    }
    if ( $c->req->json->{onTime} ) {
        $onTime = $c->req->json->{onTime};
        $log->debug("Received onTime $onTime");
    }
    my $msg = '';

    if ( $onTime > 0 && $onTime < 20 ) {
        $log->debug("Sending to MQTT onTime $onTime");
        $msg = "Sent onTime: $onTime minutes";
        sendData( $onTime, 'SR01-IRR1' );
    }
    else {
        $msg = "onTime 0 or out of range.";
        $log->debug("onTime 0 or out of range.");
    }
    $c->render( json => { status => "ok", data => { message => $msg } } );
};

sub getLastData {
    my $node_name = shift;
    my @result;
    my @data = qw{temperature humidity soil_moisture};
    foreach my $p (@data) {
        my $res
          = $ua->get( "http://"
              . $config->{influxdb}->{host}
              . ":8086/query?q=SELECT+mean(%22value%22)+FROM+"
              . $p
              . "++WHERE+%22node_function%22%3D'irrigation_controller'+AND+%22node_name%22%3D'"
              . $node_name
              . "'+AND+time+%3E+now()+-+3h&db="
              . $config->{influxdb}->{dbname} )
          ->res->json('/results/0/series/0/values/0/1');
        if ($res) {

            push @result, $res;
        }
        else {
            push @result, 0;
        }
    }
    return @result;
}

sub getDetailedData {
    my $a = shift;
    my @raw_result;
    my @result;
    my @data = qw{temperature humidity soil_moisture};
    foreach my $p (@data) {
        my $res
          = $ua->get( "http://"
              . $config->{influxdb}->{host}
              . ":8086/query?q=SELECT+time,value+FROM+"
              . $p
              . "++WHERE+%22node_function%22%3D'irrigation_controller'+AND+%22node_name%22%3D'"
              . $a->{node}
              . "'+AND+time+%3E+now()+-+"
              . $a->{hours} . "h&db="
              . $config->{influxdb}->{dbname} )
          ->res->json('/results/0/series/0/values');
        if ($res) {
            push @raw_result, $res;
        }
        else {
            push @raw_result, 0;
        }
    }
    if ( $raw_result[0] != 0 ) {
        my $ea = each_array(
            @{ $raw_result[0] },
            @{ $raw_result[1] },
            @{ $raw_result[2] }
        );
        while ( my ( $a, $b, $c ) = $ea->() ) {
            push @result, [ $a->[0], $a->[1], $b->[1], $c->[1] ];
        }
    }
    return \@result;
}

sub getLastIrr {
    my $a = shift;
    my $res
      = $ua->get( "http://"
          . $config->{influxdb}->{host}
          . ":8086/query?q=SELECT+last(%22value%22)+FROM+onTime"
          . "++WHERE+%22node_function%22%3D'irrigation_controller'+AND+%22node_name%22%3D'"
          . $a->{node} . "'&db="
          . $config->{influxdb}->{dbname} )
      ->res->json('/results/0/series/0/values/0');
    if ($res) {
        if ( $res->[0]
            =~ m/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.(\d{4,6})Z/ )
        {
            my $hour = $4;
            my $tz = strftime( "%Z", localtime() );
            if ( $tz eq "CEST" ) {
                $hour += 2;
            }
            else {
                $hour += 1;
            }
            $res->[0] = "$3/$2/$1 $hour:$5:$6";
        }
        return $res;
    }
    return 0;
}

sub rainForecast {
    my $rainTomorrow = 0;
    my $conf         = $config->{openweathermap};
    my $res
      = $ua->get( "http://api.openweathermap.org/data/2.5/forecast?appid="
          . $conf->{api_key}
          . "&mode=json&cnt="
          . $conf->{count_3h}
          . "&units=metric&id="
          . $conf->{location} )->res;

    if ( $res->code == 200 ) {
        my $forecast = $res->json;
        foreach my $h ( @{ $forecast->{list} } ) {
            if ( $h->{rain}->{'3h'} ) {
                $rainTomorrow += $h->{rain}->{'3h'};
            }
        }
    }
    else {
        $rainTomorrow = 100;
    }

    return $rainTomorrow;
}

sub sendData {
    my $onTime = shift;
    my $ssr    = shift;
    my $mqtt   = Net::MQTT::Simple->new( $config->{mqtt}->{host} );
    my $line   = data2line(
        'onTime', $onTime,
        {   node_name     => $ssr,
            node_type     => 'esp8266',
            node_function => 'irrigation_controller'
        }
    );

    if ( $onTime < 10 ) {
        $onTime = '0' . $onTime;
    }

    $mqtt->publish( "/sensors/irr01" => "#$onTime#" );

    $ua->post( "http://"
          . $config->{influxdb}->{host}
          . ":8086/write?db="
          . $config->{influxdb}->{dbname} => { Accept => '*/*' } => $line );
}

app->start;
__DATA__

@@ index.html.ep
  <html>
  <head>
      <meta charset="utf-8">
      <title>Sensor Data</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">

      <link href="//fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css">
      <link rel="stylesheet" href="https://c.onna.be/dist_css/normalize.css">
      <link rel="stylesheet" href="https://c.onna.be/dist_css/skeleton.css">

    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Date', 'Temperature', 'Humidity', 'Soil Moisture'],
        <% foreach my $t (@{$mydata}) {%>
        [new Date('<%= $t->[0] %>'), <%= $t->[1] %>, <%= $t->[2] %>, <%= $t->[3] %>],
        <% } %>
        ]);

        var options = {
          title: 'Sensor Data',
          curveType: 'function',
          legend: { position: 'bottom' },
          vAxis: {
            minValue: 0
          },
          series: {
          0: {targetAxisIndex: 0},
          1: {targetAxisIndex: 1},
          2: {targetAxisIndex: 1}
        },
        vAxes: {
          // Adds titles to each axis.
          0: {title: 'Temp (Celsius)'},
          1: {title: 'Percent'}
        }
        };

        var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <!-- <div id="curve_chart" style="width: 900px; height: 700px"></div> -->
    <div class="container">
        <div class="row">
            <div class="eleven columns">&nbsp;</div>
        </div>
        <div class="row">
            <div class="two-thirds column" id="curve_chart" style="height: 400px"></div>
            <div class="one-third column" id="info_text">
                <h5>Last irrigation info.</h5>
                <p>Last irrigation performed at <strong><%= $lastirr->[0] %></strong> for <strong><%= $lastirr->[1] %></strong> minutes.</p>
                <h5>Irrigate Manually.</h5>
                <form action="#" id="irrForm">
                    <label for="onTimeInput">Time in minutes</label>
                    <input class="u-full-width" type="text" placeholder="5" value="5" name="onTimeInput" id="onTimeInput" />
                    <input class="button-primary" type="submit" value="Submit" />
                </form>
                <div id="result"></div>
            </div>
        </div>
    </div>
    <script>
        // Attach a submit handler to the form
        $( "#irrForm" ).submit(function( event ) {
            // Stop form from submitting normally
            event.preventDefault();
            var onValue = $("#irrForm").find('input[name="onTimeInput"]').val();
            // Send the data using post
            $.post( "/api/v1/irrigate/SR01-IRR01", JSON.stringify({"onTime": onValue}),
                function(resp) {
                    var content = resp.data.message;
                    $( "#result" ).empty().append( content );
                }, 'json'
            );
        });
    </script>
  </body>
</html>
