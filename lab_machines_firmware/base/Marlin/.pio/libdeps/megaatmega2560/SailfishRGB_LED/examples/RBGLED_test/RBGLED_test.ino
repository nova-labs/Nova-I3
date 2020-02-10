#include "Arduino.h"
#include "SailfishRGB_LED.h"
//The setup function is called once at startup of the sketch

void setup() {
// Add your initialization code here
	RGBinit();

}

// The loop function is called in an endless loop
void loop() {
	RGBsetColor(255, 0, 0, true);
	delay(1000);
	RGBsetColor(0, 255, 0, true);
	delay(1000);
	RGBsetColor(0, 0, 255, true);
	delay(1000);
	RGBsetColor(0, 0, 255, true);
	delay(1000);

//Add your repeated code here
}
