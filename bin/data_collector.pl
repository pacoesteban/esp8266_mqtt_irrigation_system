#!/usr/bin/env perl
#
# Irrigation IoT data collector.
#
# Version 0.1
# Copyright (C) 2017 Paco Esteban <paco@onna.be>
# Created  2017-02-12 18:52
# License MIT

use strict;
use warnings;
use v5.20;
use local::lib;
use Net::MQTT::Simple;
use InfluxDB::LineProtocol qw( data2line );
use Scalar::Util qw( looks_like_number );
use LWP::UserAgent;
use FindBin;

# loading config
my $config = eval(
    do { local ( @ARGV, $/ ) = "$FindBin::Bin/app.conf"; <> }
);

my $mqtt        = Net::MQTT::Simple->new( $config->{mqtt}->{host} );
my $influx_host = $config->{influxdb}->{host};
my $db          = $config->{influxdb}->{dbname};
my $debug       = $ARGV[0] || 0;

$mqtt->run( '/sensors/info' => \&parse_info );

sub parse_info {
    my ( $topic, $message ) = @_;
    my ( $sensor, $temperature, $humidity, $moisture, $onTime )
      = split( /\|/, $message );

    # some sanity checks
    if (   looks_like_number($temperature)
        && looks_like_number($humidity)
        && looks_like_number($moisture) )
    {
        $temperature = 60   if ( $temperature > 60 );
        $temperature = -20  if ( $temperature < -20 );
        $humidity    = 100  if ( $humidity > 100 );
        $humidity    = 0    if ( $humidity < 0 );
        $moisture    = 5000 if ( $moisture > 5000 );
        $moisture    = 0    if ( $moisture < 0 );

        insertData( $sensor, $temperature, $humidity, $moisture );
    }
    else {
        say "Some of the params are not numbers !!";
    }
}

sub insertData {
    my ( $ssr, $t, $h, $m ) = @_;
    my %measurements
      = ( temperature => $t, humidity => $h, soil_moisture => $m );
    my $lines;
    my $ua = LWP::UserAgent->new;

    foreach my $key ( keys %measurements ) {
        $lines .= data2line(
            $key,
            $measurements{$key},
            {   node_name     => $ssr,
                node_type     => 'esp8266',
                node_function => 'irrigation_controller'
            }
        );
        $lines .= "\n";
    }

    say $lines if ($debug);

    my $res = $ua->post( "http://" . $influx_host . ":8086/write?db=" . $db,
        Content => $lines );

    if ( $res->is_success ) {
        say "Data inserted to InfluxDB";
    }
    else {
        say "Error sending data to InfluxDB: " . $res->status_line;
    }
}
