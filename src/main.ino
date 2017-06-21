#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
#include <myNetworks.h>

#define INFO_LED 12
#define WATER_VALVE 14
#define DHTPIN 4
#define DHTTYPE DHT22
#define GPIO_PIN 13

#define DEBUG 0
#define CHECK_INTERVAL 300000

// Connect to the WiFi
const char *ssid     = WIFI_SSID;
const char *password = WIFI_PASSWD;
const char *mqtt_server = MQTT_BROKER;
float temperature = 0;
int humidity = 0;
float moisture = 0.0;
int onTime = 0;
const char *irr01Topic = "/sensors/irr01";
const char *sensorsTopic = "/sensors/info";
volatile float freq = 0.0;
volatile unsigned long pulseDuration;
volatile unsigned long lastpulse;
unsigned long currentMillis = 0;
unsigned long previousMillis = 0;

WiFiClient espClient;
PubSubClient client( espClient );
DHT dht( DHTPIN, DHTTYPE );

void callback( char *topic, byte *payload, unsigned int length )
{
    yield();

    if ( payload[0] == '#' && payload[3] == '#' ) {
        yield();
        onTime = ( payload[1] - '0' ) * 10;
        onTime += ( payload[2] - '0' );
        yield();

        if ( onTime > 0 ) {
            irrigate( onTime * 60 );
        }
    }

    Serial.println();
}

void reconnect()
{
    // Loop until we're reconnected
    while ( !client.connected() ) {
        yield();
        Serial.print( "Attempting MQTT connection..." );

        // Attempt to connect
        if ( client.connect( "ESP8266 Irrig. Sensor." ) ) {
            Serial.println( "connected" );
            // ... and subscribe to topic
            client.subscribe( irr01Topic );
        } else {
            Serial.print( "failed, rc=" );
            Serial.print( client.state() );
            Serial.println( " try again in 5 seconds" );
            // Wait 5 seconds before retrying
            delay( 5000 );
        }
    }
}

void collectData()
{
    bool dht_ok = false;
    int readCount = 5;
    moisture = freq;
    yield();

    while ( !dht_ok && readCount > 0 ) {
        temperature = dht.readTemperature();
        yield();
        humidity = dht.readHumidity();
        readCount--;

        if ( isnan( temperature ) || isnan( humidity ) ) {
            delay( 1000 );
        } else {
            dht_ok = true;
        }
    }

    yield();

    if ( isnan( temperature ) || isnan( humidity ) ) {
        temperature = 0;
        humidity = 0;
    }

    if ( DEBUG ) {
        Serial.println( humidity );
        Serial.println( moisture );
        Serial.println( temperature );
    }
}

void sendData()
{
    char message[27];
    char char_t[7];
    dtostrf( temperature, 5, 2, char_t );
    yield();
    sprintf( message, "SR01-IRR1|%s|%i|%i|%i",
             char_t, humidity, ( int )moisture, onTime );
    yield();

    if ( DEBUG ) {
        Serial.print( "Sending data: " );
        Serial.println( message );
    }

    yield();
    client.publish( sensorsTopic, message );
}

void irrigate( int seconds )
{
    yield();
    Serial.print( "Regant: " );
    Serial.println( seconds );
    digitalWrite( INFO_LED, HIGH );
    digitalWrite( WATER_VALVE, HIGH );

    while ( seconds > 0 ) {
        delay( 1000 );
        seconds--;
    }

    digitalWrite( WATER_VALVE, LOW );
    digitalWrite( INFO_LED, LOW );
}

void _spdint()
{
    unsigned long time = micros();
    pulseDuration = time - lastpulse;
    lastpulse = time;
}

void setup()
{
    yield();
    Serial.begin( 115200 );
    attachInterrupt( GPIO_PIN, _spdint, RISING );
    pulseDuration = 0;
    delay( 10 );
    client.setServer( mqtt_server, 1883 );
    client.setCallback( callback );
    yield();
    pinMode( INFO_LED, OUTPUT );
    pinMode( WATER_VALVE, OUTPUT );
    pinMode( GPIO_PIN, INPUT );
    delay( 5 );
    // reset, just in case.
    yield();
    digitalWrite( WATER_VALVE, LOW );
    yield();
    digitalWrite( INFO_LED, LOW );
    delay( 5 );
    dht.begin();
    delay( 5 );
    // We start by connecting to a WiFi network
    Serial.println();
    Serial.println();
    Serial.print( "Connecting to " );
    Serial.println( ssid );
    WiFi.begin( ssid, password );

    while ( WiFi.status() != WL_CONNECTED ) {
        delay( 500 );
        Serial.print( "." );
    }

    Serial.println( "" );
    Serial.println( "WiFi connected" );
    Serial.println( "IP address: " );
    Serial.println( WiFi.localIP() );
    delay( 250 );

    // flash to indicate boot process.
    for (int i = 0; i < 3; i++) {
        digitalWrite(INFO_LED, HIGH);
        delay(200);
        digitalWrite(INFO_LED, LOW);
        delay(200);
    }
    yield();
}

void loop()
{
    if ( !client.connected() ) {
        reconnect();
    }

    yield();
    client.loop();

    if ( ( micros() - lastpulse ) > 1000000 ) pulseDuration = 0;

    freq =  1000000.0 / pulseDuration;

    if ( pulseDuration > 0 ) {
        yield();

        if ( DEBUG ) {
            Serial.print( ( int )freq );
            Serial.println( " Hz" );
            delay( 200 );
        }
    } else {
        yield();

        if ( DEBUG ) {
            Serial.println( "No signal" );
            delay( 200 );
        }

        freq = 0;
    }

    currentMillis = millis();

    if ( ( unsigned long )( currentMillis - previousMillis ) > CHECK_INTERVAL ) {
        previousMillis = currentMillis;
        collectData();
        sendData();
        onTime = 0;
    }
}
