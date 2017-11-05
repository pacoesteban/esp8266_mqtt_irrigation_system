#include <ESPHelper.h>
#include <DHT.h>
#include <myNetworks.h>

#define INFO_LED 12
#define WATER_VALVE 14
#define DHTPIN 4
#define DHTTYPE DHT22
#define GPIO_PIN 13

#define DEBUG 0
#define CHECK_INTERVAL 300000

netInfo homeNet = {.mqttHost = MQTT_BROKER,
                   .mqttUser = "",
                   .mqttPass = "",
                   .mqttPort = 1883,
                   .ssid = WIFI_SSID,
                   .pass = WIFI_PASSWD
                  };

ESPHelper myESP( &homeNet );
DHT dht( DHTPIN, DHTTYPE );

// Connect to the WiFi
float temperature = 0;
int humidity = 0;
float moisture = 0.0;
int onTime = 0;
const char *irr01Topic = "/sensors/irr01";
const char *sensorsTopic = "/sensors/info";
unsigned long currentMillis = 0;
unsigned long previousMillis = 0;

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

void collectData()
{
    bool dht_ok = false;
    int readCount = 5;
    moisture = 0;
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
    myESP.publish( sensorsTopic, message );
}

void irrigate( int seconds )
{
    char message[16];
    yield();

    if ( DEBUG ) {
        Serial.print( "Regant: " );
        Serial.println( seconds );
    }

    digitalWrite( INFO_LED, HIGH );
    digitalWrite( WATER_VALVE, HIGH );

    while ( seconds > 0 ) {
        delay( 1000 );
        seconds--;
    }

    digitalWrite( WATER_VALVE, LOW );
    digitalWrite( INFO_LED, LOW );
}

void setup()
{
    yield();
    Serial.begin( 115200 );
    delay( 10 );
    myESP.OTA_enable();
    myESP.OTA_setPassword( OTA_PASSWD );
    myESP.OTA_setHostnameWithVersion( "IRR01" );
    myESP.addSubscription( irr01Topic );
    myESP.begin();
    myESP.setCallback(
        callback ); //can only set callback after begin method. Calling before begin() will not set the callback (return false)
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
    Serial.println( homeNet.ssid );
    delay( 5000 );
    Serial.println( "IP address: " );
    Serial.println( myESP.getIP() );
    delay( 250 );

    // flash to indicate boot process.
    for ( int i = 0; i < 3; i++ ) {
        digitalWrite( INFO_LED, HIGH );
        delay( 200 );
        digitalWrite( INFO_LED, LOW );
        delay( 200 );
    }

    yield();
}

void loop()
{
    yield();
    myESP.loop();
    currentMillis = millis();

    if ( ( unsigned long )( currentMillis - previousMillis ) > CHECK_INTERVAL ) {
        previousMillis = currentMillis;
        collectData();
        sendData();
        onTime = 0;
    }
}
