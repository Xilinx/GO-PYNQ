#define BLYNK_PRINT Serial


#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = " 56e530c72a2d495eb0c182116a7ac531";

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "AAALINK";
char pass[] = "aaa9502547922";

// Bridge widget on virtual pin 1
WidgetBridge bridge1(V23);
uint8_t powerLDR=D5;
// Timer for blynking
BlynkTimer timer;
void blynkAnotherDevice() // Here we will send HIGH or LOW once per second
{
  // Send value to another device
  if (digitalRead(powerLDR)) {
    digitalWrite(D7, LOW);  // Digital Pin 9 on the second board will be set HIGH
    bridge1.virtualWrite(V23, 0); // Sends 1 value to BLYNK_WRITE(V5) handler on receiving side.
  Serial.println("OK");
  digitalWrite(D4, LOW);
  
  } else {
    digitalWrite(D7, HIGH); // Digital Pin 9 on the second board will be set LOW
    bridge1.virtualWrite(V23, 1); // Sends 0 value to BLYNK_WRITE(V5) handler on receiving side.
     Serial.println("PROBLEM AT POLE 3");
     digitalWrite(D4, HIGH);
  }
  // Toggle value
}

BLYNK_CONNECTED() {
  bridge1.setAuthToken("89d16523c0514b6f98742ae3f6fb0767"); // Place the AuthToken of the second hardware here
}

void setup()
{
  // Debug console
  Serial.begin(115200);
  pinMode(D5,INPUT);
  pinMode(D4,OUTPUT);
  pinMode(D7,OUTPUT);
  //Blynk.begin(auth, ssid, pass);
  // You can also specify server:
  //Blynk.begin(auth, ssid, pass, "blynk-cloud.com", 80);
  Blynk.begin(auth, ssid, pass, IPAddress(192,168,0,107), 8082);
Serial.println("POLE 3");
  // Call blynkAnotherDevice every second
  timer.setInterval(1000L, blynkAnotherDevice);
}

void loop()
{
  Blynk.run();
  timer.run();
}
