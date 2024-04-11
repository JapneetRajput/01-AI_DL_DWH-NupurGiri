#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <Adafruit_ADS1X15.h>
#include <FirebaseESP32.h>
#include <TinyGPSPlus.h>

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define I2C_bno 0x28
#define I2C_ads 0x48

#define ADC_VREF_mV   5000
#define ADC_RESOLUTION 4096
#define PIN_LM35  34
#define currentpin 35

 int adc0;
 float volts0;
 int calib = 7; // Value of calibration of ADS1115 to reduce error
 float voltage1 = 0; // used to store voltage value
 float Radjust =  0.0909090909;      //0.043421905; 0.1875// Voltage divider factor ( R2 / R1+R2 )
 float vbat = 0; 

#define WIFI_SSID "Moteepur"
#define WIFI_PASSWORD "12345678"
#define API_KEY "AIzaSyDFPYVeNg9KQMGsYjgBJPWesklXkmKNxkw"
#define USER_EMAIL "akyuridarkspace2110@gmail.com"
#define USER_PASSWORD "manalin1go"
#define DATABASE_URL "https://evproject2esp32-default-rtdb.asia-southeast1.firebasedatabase.app"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
Adafruit_BNO055 bno = Adafruit_BNO055(I2C_bno);
Adafruit_ADS1115 ads;

String initial1;
String initial;


float orientation_x, orientation_y, orientation_z, acceleration_x, acceleration_y, acceleration_z, magnetometer_x, magnetometer_y, magnetometer_z;
float gyroscope_x, gyroscope_y, gyroscope_z, gravity_x, gravity_y, gravity_z;

const char* serverName = "http://40.81.232.173:3001/server";

unsigned long lastTime = 0;
unsigned long timerDelay = 5000;

TinyGPSPlus gps;

void displayInfo()
{
  Serial.print(F("Location: "));
  if (gps.location.isValid()) {
    Serial.print("Lat: "); 
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.print("Lng: ");
    Serial.print(gps.location.lng(), 6);
    Serial.println();
  }
  else
  {
    Serial.print(F("INVALID"));
  }
}
void setup() {
  Serial.begin(115200);
  Serial2.begin(9600);
  pinMode(PIN_LM35,INPUT);
  pinMode(currentpin,INPUT);
  delay(3000);
  
  if (!bno.begin()) 
  {
    Serial.println("Could not find a valid BNO055 sensor, check wiring!");
    while (1);
  
  }

  if (!ads.begin())
  {
    Serial.println("Failed to initialize ADS.");
    while (1);
  }

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }

  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  Serial.println("Connecting to Firebase...");
  Firebase.begin(&config, &auth);
  Serial.println("Firebase connection established!");

  Firebase.setDoubleDigits(5);

  Serial.println("Timer set to 5 seconds (timerDelay variable), it will take 5 seconds before publishing the first reading.");

}

void loop() 
{
// GPS Programm
    while (Serial2.available() > 0)
    if (gps.encode(Serial2.read()))
      displayInfo();
  if (millis() > 5000 && gps.charsProcessed() < 10)
  {
    Serial.println(F("No GPS detected: check wiring."));
    while (true);
  }
// Internal Dignosis and BNO data generate program
  
    //Voltage Code  
   adc0 = ads.readADC_SingleEnded(0);
   voltage1 = ((adc0 + calib) * 0.1875)/100;
   vbat = voltage1/Radjust-1.61;
   if (vbat < 0.1)
   {
    vbat = 0.01;
   }  
   Serial.print("Voltage:");
   Serial.println( vbat);


//Current code
   float adcv  = analogRead(currentpin);
   float voltage = adcv * 5 / 1025.0;
   float current = (voltage - 2.5)/0.66;
   float current1 = current - 18;
  
   if(current1<0.1)
   {
    current1 = 0;
   }
   Serial.print("Current:");
   Serial.println( current1);
  
//Temprature Code
   float adcVal = analogRead(PIN_LM35);
  
   float milliVolt = adcVal * (ADC_VREF_mV / ADC_RESOLUTION);
   float tempC = (milliVolt / 10)+10;

   Serial.print("Temprature:");
   Serial.println( tempC);

// Read BNO055 sensor data
    sensors_event_t event;
    bno.getEvent(&event);
    sensors_event_t eventGravity;
    bno.getEvent(&eventGravity);

    orientation_x = event.orientation.x;
    orientation_y = event.orientation.y;
    orientation_z = event.orientation.z;
    acceleration_x = event.acceleration.x;
    acceleration_y = event.acceleration.y;
    acceleration_z = event.acceleration.z;
    magnetometer_x = event.magnetic.x;
    magnetometer_y = event.magnetic.y;
    magnetometer_z = event.magnetic.z;
    gyroscope_x = event.gyro.x;
    gyroscope_y = event.gyro.y;
    gyroscope_z = event.gyro.z;
    gravity_x = eventGravity.acceleration.x;
    gravity_y = eventGravity.acceleration.y;
    gravity_z = eventGravity.acceleration.z;
    
  if ((millis() - lastTime) > timerDelay) {
    if (WiFi.status() == WL_CONNECTED) {
      // Check GPS data
      if (gps.location.isValid()) {
        // Create JSON payload with GPS data
        JSONVar postData;
        postData["latitude"] = String(gps.location.lat(), 6);
        postData["longitude"] = String(gps.location.lng(), 6);
        postData["orientation_x"] = orientation_x;
        postData["orientation_y"] = orientation_y;
        postData["orientation_z"] = orientation_z;
        postData["acceleration_x"] = acceleration_x;
        postData["acceleration_y"] = acceleration_y;
        postData["acceleration_z"] = acceleration_z;
        postData["magnetometer_x"] = magnetometer_x;
        postData["magnetometer_y"] = magnetometer_y;
        postData["magnetometer_z"] = magnetometer_z;
        postData["gyroscope_x"] = gyroscope_x;
        postData["gyroscope_y"] = gyroscope_y;
        postData["gyroscope_z"] = gyroscope_z;
        postData["gravity_x"] = gravity_x;
        postData["gravity_y"] = gravity_y;
        postData["gravity_z"] = gravity_z;
        postData["voltage"] = vbat;
        postData["current"] = current1;
        postData["temprature"] = tempC;

        // Convert JSON to String
        String jsonString = JSON.stringify(postData);

        // Send HTTP POST request
        WiFiClient client;
        HTTPClient http;
        http.begin(client, serverName);
        http.addHeader("Content-Type", "application/json");
        int httpResponseCode = http.POST(jsonString);

        Serial.print("HTTP Response code: ");
        Serial.println(httpResponseCode);
        displayInfo();

        // Free resources
        http.end();
      } else {
        Serial.println("Invalid GPS data.");
      }
    } else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }

  Serial.println("Data Send Succsesfully!");
  Serial.println();

  delay(500);  
  
}