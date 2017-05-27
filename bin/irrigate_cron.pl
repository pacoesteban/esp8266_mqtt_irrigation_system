#!/usr/bin/env perl
#
# Short description for irrigate_cron.pl
#
# Version 0.1
# Copyright (C) 2017 Paco Esteban <paco@onna.be>
# Created  2017-04-08 16:46
# License MIT

use strict;
use warnings;
use autodie;
use v5.20;
use local::lib;
use Mojo::Log;
use Mojo::UserAgent;
use FindBin;
use POSIX;

# loading config
my $config = eval(
    do { local ( @ARGV, $/ ) = "$FindBin::Bin/app.conf"; <> }
);

my $log    = Mojo::Log->new( level => "debug" );
my $ua     = Mojo::UserAgent->new;
my $onTime = 0;

my $res = $ua->get("localhost:8080/api/v1/SR01-IRR1")->res;

if ( $res->code == 200 ) {
    if ( $res->json->{data}->{rainF} < $config->{rainThreshold} ) {
        $onTime = 5 - $res->json->{data}->{rainF};
        $log->debug( "Rain forecast is "
              . $res->json->{data}->{rainF}
              . ", onTime is now $onTime" );

        if ( $res->json->{data}->{temperature} > 20 ) {
            $onTime = $onTime
              + ( ( $res->json->{data}->{temperature} - 20 ) * 0.35 );
            $log->debug( "Temperature is "
                  . $res->json->{data}->{temperature}
                  . ", onTime is now $onTime" );
        }

        $onTime
          = $onTime + ( ( 100 - $res->json->{data}->{humidity} ) * 0.025 );
        $log->debug( "Humidity is "
              . $res->json->{data}->{humidity}
              . ", onTime is now $onTime" );

        if ( $onTime > 1 ) {
            $log->info( "Sending command to irrigate: "
                  . floor($onTime)
                  . " minutes" );
            $ua->post( "localhost:8080/api/v1/irrigate/SR01-IRR1" => json =>
                  { onTime => floor($onTime) } );
        }
        else {
            $log->info("onTime less than 0");
        }
    }
    else {
        $log->debug(
            "Rain Forecast is too high: " . $res->json->{data}->{rainF} );
    }
}
else {
    $log->error("Error connecting to controller");
}
