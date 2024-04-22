//sketch for resistering new products 
// read the uid of each rfid card and post it to the website/api you made

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN D8
#define RST_PIN D0

#define USE_SERIAL Serial

#define SERVER_IP "192.168.137.31:8090"
#define SERVER_API "message"

#ifndef STASSID
#define STASSID "SHASHANK 4418"
#define STAPSK  "12345678"
#endif


//instance for rfid reader
MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class

byte nuidPICC[4];
char UID[9];

//UID[0] = '\0';

//DATA HERE 
  int ID_NO = 10000;
  float CO_NO = 0.009403;
  float humidity = 76.91;
  float lpg = 0.05768;
  float smoke = 0.018475;
  float temp = 28.5;

void setup() {
  USE_SERIAL.begin(115200);
  USE_SERIAL.println();
  USE_SERIAL.println();
  USE_SERIAL.println();

  WiFi.begin(STASSID, STAPSK);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    USE_SERIAL.print(".");
  }
  USE_SERIAL.println("");
  USE_SERIAL.print("Connected! IP address: ");
  USE_SERIAL.println(WiFi.localIP());

  // I DUNNO WHAT ARE THESE FOR 
//    pinMode(D8, OUTPUT);
// digitalWrite(D8, HIGH);
// digitalWrite(D4, LOW);

  //init spi and reader
  SPI.begin(); // Init SPI bus
  rfid.PCD_Init(); // Init MFRC522
    Serial.println();
  Serial.print(F("Reader :"));
  rfid.PCD_DumpVersionToSerial();

}

void loop() {


  // attention
//   for now i'm returning the main loop that means if no card is present then further code won't be run





  

if (RFID_valid()){
  // we know that the card is there: no error handling ahead
    Serial.println(F("The NUID tag is:"));
    Serial.print(F("In hex: "));
    printHex(rfid.uid.uidByte, rfid.uid.size);
    Serial.println();

  // Halt PICC
  rfid.PICC_HaltA();

  // Stop encryption on PCD
  rfid.PCD_StopCrypto1();
    
   // Store NUID into nuidPICC array
//    as we not caring for the previous card, we dont need to write this
    for (byte i = 0; i < 4; i++) {
      nuidPICC[i] = rfid.uid.uidByte[i];
//      sprintf(&niudstring[i*2], "%02X", rfid.uid.uidByte[i]);
sprintf(UID + strlen(UID), "%02X", nuidPICC[i]);
    }



  
// wait for WiFi connection
  if ((WiFi.status() == WL_CONNECTED)) {

    WiFiClient client;
    HTTPClient http;

    USE_SERIAL.print("[HTTP] begin...\n");
    // configure traged server and url
    http.begin(client, "http://" SERVER_IP "/" SERVER_API); //HTTP
    http.addHeader("Content-Type", "application/json");

    USE_SERIAL.print("[HTTP] POST...\n" );
    // start connection and send HTTP header and body
    USE_SERIAL.print("the uid is-> "+ String(UID));
//    comment this line to stop auto posting to flask
//data: reader id, card uid, time stamp? -> don't 
    int httpCode = http.POST("{ \"uid\": \""+ String(UID)+"\"  ,\"device\" : 0 }");
//    ,\"humidity\": "+ String(humidity)+" ,\"id\": \"" + String(ID_NO) +"\" ,\"lpg\" : "+ String(lpg)+" ,\"smoke\" : "+ String(smoke)+" ,\"temp\" : "+ String(temp)+" 

    // httpCode will be negative on error
    if (httpCode > 0) {
      // HTTP header has been send and Server response header has been handled
      USE_SERIAL.printf("[HTTP] POST... code: %d\n", httpCode);

      // file found at server . usefull to show anything from api to esp serial monitor
      if (httpCode == HTTP_CODE_OK) {
        const String& payload = http.getString();
        USE_SERIAL.println("received payload:\n<<");
        USE_SERIAL.println(payload);
        USE_SERIAL.println(">>");
      }
    } else {
      USE_SERIAL.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpCode).c_str());
    }

    http.end();
    // Clearing the hexString array
  memset(UID, '\0', sizeof(UID));

  }
}
 
  delay(1000);  //repeat each second

}

/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

/*
  define a func for all things that stop the main loop from the rfid reader code
*/
int RFID_valid(){
//  return 0 if bad or 1 if good

  ////useful for knowing the reader type. FOR now, we know it works!
//  Serial.print(F("PICC type: "));
  MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);
//  Serial.println(rfid.PICC_GetTypeName(piccType));

  // is there a card on the reader?
  if ( ! rfid.PICC_IsNewCardPresent())
    return 0;

  // Verify if the NUID has been readed
  if ( ! rfid.PICC_ReadCardSerial())
    return 0;

    // Check is the PICC of Classic MIFARE type
//    this is useless as we know all our cards are mifarebut still as a precaution
  if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI &&
      piccType != MFRC522::PICC_TYPE_MIFARE_1K &&
      piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
    Serial.println(F("Your tag is not of type MIFARE Classic."));
    return 0;
  }

  Serial.println(F("A new card has been detected."));
  return 1;
}
