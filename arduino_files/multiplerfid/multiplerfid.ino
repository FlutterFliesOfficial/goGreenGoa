

#include <SPI.h>
#include <MFRC522.h>

#define SERVER_IP "192.168.137.31:8090"
#define SERVER_API "message"

#ifndef STASSID
#define STASSID "SHASHANK 4418"
#define STAPSK  "12345678"
#endif

// PIN Numbers : RESET + SDAs
#define RST_PIN         4
#define SS_1_PIN        25
#define SS_2_PIN        13
//#define SS_3_PIN        7
//#define SS_4_PIN        6

// Led and Relay PINS
//#define GreenLed        2
//#define relayIN         3
//#define RedLed          5


// List of Tags UIDs that are allowed to open the puzzle
byte tagarray[][4] = {
  {0x33, 0xD7, 0xE9, 0x0B},
  {0xC3, 0xE3, 0xF9, 0x0B}, 
//  {0x81, 0x29, 0xBC, 0x79},
//  {0xE6, 0xDF, 0xBB, 0x79},
//      


};

// Inlocking status :
int tagcount = 0;
bool accessone = false;

#define NR_OF_READERS   2

byte ssPins[] = {SS_1_PIN, SS_2_PIN};   //Slave Select (SS)

// Create an MFRC522 instance :
MFRC522 mfrc522[NR_OF_READERS];

/**
   Initialize.
*/
void setup() {

  Serial.begin(115200);           // Initialize serial communications with the PC
  while (!Serial);              // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)
  WiFi.begin(STASSID, STAPSK);
  SPI.begin();                  // Init SPI bus for rfid readers

  /* Initializing Inputs and Outputs */
//  pinMode(GreenLed, OUTPUT);
//  digitalWrite(GreenLed, LOW);
//  pinMode(relayIN, OUTPUT);
//  digitalWrite(relayIN, HIGH);
//  pinMode(RedLed, OUTPUT);
//  digitalWrite(RedLed, LOW);


  /* looking for MFRC522 readers */
  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++) {
    mfrc522[reader].PCD_Init(ssPins[reader], RST_PIN);
    Serial.print(F("Reader "));
    Serial.print(reader);
    Serial.print(F(": "));
    mfrc522[reader].PCD_DumpVersionToSerial();
    //mfrc522[reader].PCD_SetAntennaGain(mfrc522[reader].RxGain_max);
  }
}

/*
   Main loop.
*/
//
void loop() {

  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++) {

    // Looking for new cards 
//     &&mfrc522[reader].PICC_ReadCardSerial()
    if ( mfrc522[reader].PICC_IsNewCardPresent()) {
      Serial.print(F("Reader "));
      Serial.print(reader);

      // Show some details of the PICC (that is: the tag/card)
      Serial.print(F(": Card UID:"));
      dump_byte_array(mfrc522[reader].uid.uidByte, mfrc522[reader].uid.size);
      Serial.println();

//      for (int x = 0; x < sizeof(tagarray); x++)                  // tagarray's row
//      {
//        for (int i = 0; i < mfrc522[reader].uid.size; i++)        //tagarray's columns
//        {
//          if ( mfrc522[reader].uid.uidByte[i] != tagarray[x][i])  //Comparing the UID in the buffer to the UID in the tag array.
//          {
//            DenyingTag();
//            break;
//          }
//          else
//          {
//            if (i == mfrc522[reader].uid.size - 1)                // Test if we browesed the whole UID.
//            {
//              AllowTag();
//            }
//            else
//            {
//              continue;                                           // We still didn't reach the last cell/column : continue testing!
//            }
//          }
//        }
//        if (accessone) break;                                        // If the Tag is allowed, quit the test.
//      }
//
//
//      if (accessone)
//      {
//        if (tagcount == NR_OF_READERS)
//        {
//          OpenDoor();
//        }
//        else
//        {
//          MoreTagsNeeded();
//        }
//      }
//      else
//      {
//        UnknownTag();
//      }
      /*Serial.print(F("PICC type: "));
        MFRC522::PICC_Type piccType = mfrc522[reader].PICC_GetType(mfrc522[reader].uid.sak);
        Serial.println(mfrc522[reader].PICC_GetTypeName(piccType));*/
      // Halt PICC
      mfrc522[reader].PICC_HaltA();
      // Stop encryption on PCD
      mfrc522[reader].PCD_StopCrypto1();
    } //if (mfrc522[reader].PICC_IsNewC..
    else
    Serial.print("    there's no card on reader: "+ String(reader));
  } //for(uint8_t reader..
  Serial.println();
  delay(500);
}




/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void dump_byte_array(byte * buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

void printTagcount() {
  Serial.print("Tag n°");
  Serial.println(tagcount);
}

void DenyingTag()
{
  tagcount = tagcount;
  accessone = false;
}

void AllowTag()
{
  tagcount = tagcount + 1;
  accessone = true;
}

void Initialize()
{
  tagcount = 0;
  accessone = false;
}

void OpenDoor()
{
  Serial.println("Welcome! the door is now open");
  Initialize();
//  digitalWrite(relayIN, LOW);
//  digitalWrite(GreenLed, HIGH);
//  delay(2000);
//  digitalWrite(relayIN, HIGH);
//  delay(500);
//  digitalWrite(GreenLed, LOW);
}

void MoreTagsNeeded()
{
  printTagcount();
  Serial.println("System needs more cards");
//  digitalWrite(RedLed, HIGH);
//  delay(1000);
//  digitalWrite(RedLed, LOW);
  accessone = false;
}

void UnknownTag()
{
  Serial.println("This Tag isn't allowed!");
  printTagcount();
//  for (int flash = 0; flash < 5; flash++)
//  {
//    digitalWrite(RedLed, HIGH);
//    delay(100);
//    digitalWrite(RedLed, LOW);
//    delay(100);
//  }
}
