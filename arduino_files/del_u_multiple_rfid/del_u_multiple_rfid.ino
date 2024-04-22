#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN 4    // Reset pin
#define SS_PIN_1 25   // Slave Select Pin for Reader 1
#define SS_PIN_2 13    // Slave Select Pin for Reader 2

MFRC522 mfrc522_1(SS_PIN_1, RST_PIN ); // Create MFRC522 instance for Reader 1
MFRC522 mfrc522_2(SS_PIN_2, RST_PIN); // Create MFRC522 instance for Reader 2

void setup() {
  Serial.begin(9600); // Initialize serial communications with the PC
  SPI.begin();        // Init SPI bus
  // Init MFRC522 with custom addresses
  mfrc522_1.PCD_Init(SS_PIN_1, RST_PIN); // Address 0x40 for Reader 1
  mfrc522_2.PCD_Init(SS_PIN_2, RST_PIN); // Address 0x30 for Reader 2
  delay(4);           // Optional delay
}

void loop() {


  // Look for new cards on Reader 2
  if (mfrc522_2.PICC_IsNewCardPresent() && mfrc522_2.PICC_ReadCardSerial()) {
    Serial.print("Reader 2 UID: ");
    printUID(mfrc522_2.uid.uidByte, mfrc522_2.uid.size);
    delay(500); // Wait 500 milliseconds before scanning for the next card
    mfrc522_2.PICC_HaltA(); // Halt PICC
    mfrc522_2.PCD_StopCrypto1(); // Stop encryption on PCD
  }

    // Look for new cards on Reader 1
  if (mfrc522_1.PICC_IsNewCardPresent() && mfrc522_1.PICC_ReadCardSerial()) {
    Serial.print("Reader 1 UID: ");
    printUID(mfrc522_1.uid.uidByte, mfrc522_1.uid.size);
    delay(500); // Wait 500 milliseconds before scanning for the next card
    mfrc522_1.PICC_HaltA(); // Halt PICC
    mfrc522_1.PCD_StopCrypto1(); // Stop encryption on PCD
  }
}

void printUID(byte * buffer, byte bufferSize) {
  String UIDStr = "";
  for (byte i = 0; i < bufferSize; i++) {
    UIDStr += String(buffer[i] < 0x10 ? " 0" : " ");
    UIDStr += String(buffer[i], HEX);
  }
  UIDStr.toUpperCase();
  Serial.println(UIDStr);
}
