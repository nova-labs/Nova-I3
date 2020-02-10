/*
 * SailfishRGB_LED.h
 *
 *  Created on: Jan 7, 2019
 *      Author: mikes
 */

#pragma once

#ifndef SAILFISHRGB_LED_H_
#define SAILFISHRGB_LED_H_

#include <Arduino.h>

#define ENABLE_I2C_PULLUPS

#define SET_COLOR(r,g,b,c) RGB_LED::setColor((r),(g),(b),(c))

// LED control registers
#define LED_REG_PSC0	0b00000001
#define LED_REG_PWM0	0b00000010
#define LED_REG_PSC1	0b00000011
#define LED_REG_PWM1	0b00000100
#define LED_REG_SELECT  0b00000101

// LED output types
#define LED_BLINK_PWM0 0b10101010
#define LED_BLINK_PWM1 0b11111111
#define LED_ON 	0b01010101
#define LED_OFF	0b00000000

// RBG IDs
#define LED_RED 0b00110000
#define LED_GREEN 0b00000011
#define LED_BLUE 0b00001100

// Channel IDs
#define LED_CHANNEL1	0
#define LED_CHANNEL2	1

enum LEDColors {
	LED_DEFAULT_WHITE = 0,
	LED_DEFAULT_RED,
	LED_DEFAULT_ORANGE,
	LED_DEFAULT_PINK,
	LED_DEFAULT_GREEN,
	LED_DEFAULT_BLUE,
	LED_DEFAULT_PURPLE,
	LED_DEFAULT_OFF,
	LED_DEFAULT_CUSTOM
};


//#include "Types.hh"

extern bool LEDEnabled;
void RGBinit();
void RGBclear();
void RGBerrorSequence();
void RGBsetColor(uint8_t red, uint8_t green, uint8_t blue, bool clearOld = true);
void RGBsetDefaultColor(uint8_t c = 0xff);
void RGBsetCustomColor(uint8_t red, uint8_t green, uint8_t blue);


#endif /* SAILFISHRGB_LED_H_ */
