#include <Servo.h>
#include <WString.h>
#include "Wire.h"
#include "Arduino.h"

#define TRUE 1
#define FALSE 0

int pinServoIndex;
int pinServoOthers;
Servo servoIndex; // range 0 to 180
Servo servoOthers; // range 0 to 180

int SerialData = 0;
String inString = "";
bool serial_input = FALSE;
int serial_command_index = 180;
int serial_command_others = 180;

void setup() {
    Serial.begin(115200);

    // Pin Configuration
    pinServoIndex  = 10;
    pinServoOthers  = 11;
    servoIndex.attach(pinServoIndex);//fingers
    servoOthers.attach(pinServoOthers);//fingers

    // Go to 180 degrees position
    servoIndex.write(serial_command_index);
    servoOthers.write(serial_command_others);
}

void loop() {
      // Control from serial communication -start, Jumpei 20190618
      if(Serial.available() > 0){ // When there is a signal
          SerialData = Serial.read(); // Read the input from PC
          if ( SerialData == 'a'){

              serial_command_index = map(Serial.parseInt(), -100, 0, 0, 180);
              if (serial_command_index>180) {serial_command_index = 180;}
              if (serial_command_index<0) {serial_command_index = 0;}

              serial_command_others = map(Serial.parseInt(), -100, 0, 180, 0);
              if (serial_command_others>180) {serial_command_others = 180;}
              if (serial_command_others<0) {serial_command_others = 0;}

              serial_input = TRUE;
          }
      }
      if (serial_input){
        servoIndex.write(serial_command_index);
        servoOthers.write(serial_command_others);
        serial_input = FALSE;
        delay(5); // wait to move the figners
      }
}
