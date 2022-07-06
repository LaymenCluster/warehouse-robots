#include <ESP8266WiFi.h>
#include <WiFiUdp.h>

#define WIFI_SSID "********"
#define WIFI_PASSWORD "********"

WiFiUDP Udp;
unsigned int localUdpPort = 4210;  // local port to listen on
char incomingPacket[255];  // buffer for incoming packets
int packetSize;

//Motor A
const int motor1pin1  = D2;
const int motor1pin2  = D3;

//Motor B
const int motor2pin1  = D5;
const int motor2pin2  = D4;

int en1 = D1;
int en2 = D6;

int w, d = 1, len;

void setup()
{
  pinMode(en1, OUTPUT);
  pinMode(en2, OUTPUT);
  pinMode(motor1pin1, OUTPUT);
  pinMode(motor1pin2, OUTPUT);
  pinMode(motor2pin1, OUTPUT);
  pinMode(motor2pin2, OUTPUT);

  Serial.begin(9600);

  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());

  Udp.begin(localUdpPort);

  //  analogWriteFreq(2000);
  analogWriteRange(1000);
}

void stp() {
  analogWrite(en1, 0);
  analogWrite(en2, 0);
  digitalWrite(motor1pin1, LOW);
  digitalWrite(motor1pin2, LOW);
  digitalWrite(motor2pin1, LOW);
  digitalWrite(motor2pin2, LOW);
}

void loop()
{
  packetSize = Udp.parsePacket();
  if (packetSize)
  {
    len = Udp.read(incomingPacket, 255); // read instruction
    if (len > 0)
    {
      incomingPacket[len] = 0;
    }

    w = atoi(incomingPacket);	// convert string to text

    if ((w/10) == 4) {		// forward direction
      d = 1;
    }

    if ((w/10) == 5) {		// reverse direction
      d = -1;
    }

    if (w == 3) {		// stop robot
      stp();
    }

    if ((w%10) == 0) {		// move both wheels
      analogWrite(en1, 700);
      analogWrite(en2, 700);
    }

    if ((w%10) == 1) {		// move left wheel only
      analogWrite(en1, 50);
      analogWrite(en2, 700);
    }

    if ((w%10) == 2) {		// move right wheel only
      analogWrite(en1, 700);
      analogWrite(en2, 50);
    }

    digitalWrite(motor1pin1, d < 0);
    digitalWrite(motor1pin2, d > 0);
    digitalWrite(motor2pin1, d < 0);
    digitalWrite(motor2pin2, d > 0);
  }
}
