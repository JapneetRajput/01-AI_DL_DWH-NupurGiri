#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <FirebaseESP32.h>
#include <TinyGPS++.h>

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define ADC_VREF_mV 3300.0
#define ADC_RESOLUTION 3000.0
// Sensor pin define
#define currentpin 35
#define PIN_LM35 34

#define WIFI_SSID "nt"
#define WIFI_PASSWORD "12345678"
#define API_KEY "AIzaSyCyMCJzkS11k9-lUDkOAPYBMEks7L15Ts4"
#define USER_EMAIL "be.project2.tahd@gmail.com"
#define USER_PASSWORD "beprojectgrp2"
#define DATABASE_URL "https://test-9ce55-default-rtdb.asia-southeast1.firebasedatabase.app"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
Adafruit_BNO055 bno = Adafruit_BNO055();
TinyGPSPlus gps;

float orientation_x, orientation_y, orientation_z, acceleration_x, acceleration_y, acceleration_z, magnetometer_x, magnetometer_y, magnetometer_z;
float gyroscope_x, gyroscope_y, gyroscope_z, gravity_x, gravity_y, gravity_z;

const char* serverName = "http://40.81.232.173:3001/hybrid";
unsigned long lastTime = 0;
unsigned long timerDelay = 5000;
// int counter =0;

void setup() {
  Serial.begin(115200);

  if (!bno.begin()) {
    Serial.println("Could not find a valid BNO055 sensor, check wiring!");
    while (1)
      ;
  }
  delay(2000);

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
}

void loop() {
  if (Firebase.ready()) {
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

    Serial.println(orientation_x);

    Serial.println("Sending data to Firebase...");

    // Send BNO055 sensor data to Firebase
    sendBNODataToFirebase();

    // Check GPS data
    if (gps.location.isValid()) {
      // Create JSON payload with GPS data

      JSONVar postData;
      postData["latitude"] = String(gps.location.lat(), 6);
      postData["longitude"] = String(gps.location.lng(), 6);

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

      // Free resources
      http.end();
   } else {
    JSONVar postData;
      postData["latitude"] = "19.200";
      postData["longitude"] = "71.812";

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

      // Free resources
      http.end();
     Serial.println("Invalid GPS data.");
    }

    // Read LM35 and Current sensor data
    readAndSendSensorData();

    delay(5000);  // Adjust the delay based on your needs
  } else {
    Serial.println("Firebase not ready. Please check your connection.");
  }
}

void sendBNODataToFirebase() {
  // Your existing BNO055 data sending code here
  // ...
}

void readAndSendSensorData() {
  // Read LM35 sensor data
  int adcVal = analogRead(PIN_LM35);
  float milliVolt = adcVal * (ADC_VREF_mV / ADC_RESOLUTION);
  float tempV = milliVolt / 10;
  delay(500);
  Serial.print("Temperature: ");
  Serial.print(tempV);
  Serial.println("°C");
  delay(500);
  Serial.print("  ");

  // Read Current sensor data
  int adcv = analogRead(currentpin);
  float voltage = adcv * 5 / 1025.0;
  float current = (voltage - 2.5) / 0.66;
  float current1 = current - 18;

  if (current1 < 0.16) {
    current1 = 0;
  }

  Serial.print("Current:- ");
  Serial.print(current1);
  Serial.println(" A");
  delay(500);

  JSONVar sensorData;
  FirebaseJson json;
  json.add("temp",tempV);
  json.add("current",current1);
  json.add("orientation_x",orientation_x);
  json.add("orientation_y",orientation_y);
  json.add("orientation_z",orientation_z);
  json.add("acceleration_x",acceleration_x);
  json.add("acceleration_y",acceleration_y);
  json.add("acceleration_z",acceleration_z);
  json.add("magnetometer_x",magnetometer_x);
  json.add("magnetometer_y",magnetometer_y);
  json.add("magnetometer_z",magnetometer_z);
  json.add("gyroscope_x",gyroscope_x);
  json.add("gyroscope_y",gyroscope_y);
  json.add("gyroscope_z",gyroscope_z);
  json.add("gravity_x",gravity_x);
  json.add("gravity_y",gravity_y);
  json.add("gravity_z",gravity_z);
  // Send LM35 and Current sensor data to Firebase
  // counter++;
  String initial = "SensorDataOneDecember/"+String(millis());
  Firebase.pushJSON(fbdo, initial, json);
}