/*
 * Copyright 2011 by Alison Leonard  <alison@makerbot.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

#include "SailfishRGB_LED.h"
#include <Wire.h>

const static int LEDAddress = 0x62;
uint8_t LEDSelect = 0;
bool LEDEnabled = true;

static void setBrightness(uint8_t Channel, uint8_t level, uint8_t LEDs);
static void setBlinkOff(uint8_t Channel, uint8_t LEDs);
static void setBlinkRate(uint8_t Channel, uint8_t LEDs, uint8_t rate);

void RGBinit() {
  Wire.begin();
  RGBclear();
}

// channel 3 sets LEDs on or off
// LEDs:  {bits: XXBBGGRR : BLUE: 0b110000, Green:0b1100, RED:0b11}
//      ones indicate on, zeros indicate off
static void toggleLEDNoPWM(bool enable, uint8_t LEDs) {
  uint8_t data[2] = { LED_REG_SELECT, 0 };

  if (enable)
    // clear past select data and turn LEDs full on
    data[1] = (LEDSelect & ~LEDs) | (LED_ON & LEDs);
  else
    // clear past select data and turn LEDs full off
    data[1] = (LEDSelect & ~LEDs) | (LED_OFF & LEDs);

  Wire.beginTransmission(LEDAddress);
  Wire.write(data, 2);
  Wire.endTransmission();
}

// channel : 1,2 select PWM channels, 3 is a pure on / off channel
// level : duty cycle (brightness) for channels 1,2,
//      for Channel 3, level is on if not zero
// LEDs:  {bits: XXBBGGRR : BLUE: 0b110000, Red:0b1100, Green:0b11}
//      ones indicate on, zeros indicate off
static void setBrightness(uint8_t Channel, uint8_t level, uint8_t LEDs) {
  //uint8_t data[4] = {LED_REG_SELECT, 0, 0 , level};
  uint8_t data1[2] = { LED_REG_SELECT, 0 };
  uint8_t data2[2] = { 0, level };

  // set pwm for select channel
  if (Channel == LED_CHANNEL1) {
    data2[0] = LED_REG_PWM0;
    // clear past select data and apply PWM0
    data1[1] = (LEDSelect & ~LEDs) | (LED_BLINK_PWM0 & LEDs);
  } else if (Channel == LED_CHANNEL2) {
    data2[0] = LED_REG_PWM1;
    // clear past select data and apply PWM1
    data1[1] = (LEDSelect & ~LEDs) | (LED_BLINK_PWM1 & LEDs);
  } else {
    toggleLEDNoPWM((level != 0), LEDs);
    return;
  }

  Wire.beginTransmission(LEDAddress);
  Wire.write(data1, 2);
  Wire.endTransmission();
  delayMicroseconds(1);
  Wire.beginTransmission(LEDAddress);
  Wire.write(data2, 2);
  Wire.endTransmission();
  delayMicroseconds(1);

  LEDSelect = data1[1];

}

// channel : 1,2 select PWM channels, channel 3 does nothing
// level : blink rate for channels 1,2,  channel 3 ignores this
// LEDs:  {bits: XXBBGGRR : BLUE: 0b110000, Green:0b1100, RED:0b11}
//      ones indicate on, zeros indicate off
static void setBlinkOff(uint8_t Channel, uint8_t LEDs) {
  setBlinkRate(Channel, LEDs, 0);
}

static void setBlinkRate(uint8_t Channel, uint8_t LEDs, uint8_t rate) {
  uint8_t data1[2] = { LED_REG_SELECT, 0 };
  uint8_t data2[2] = { 0, rate };

  // set pwm for select channel
  if (Channel == LED_CHANNEL1) {
    data2[0] = LED_REG_PSC0;
    // clear past select data and apply PWM0
    data1[1] = (LEDSelect & ~LEDs) | (LED_BLINK_PWM0 & LEDs);
  } else if (Channel == LED_CHANNEL2) {
    data2[0] = LED_REG_PSC1;
    // clear past select data and apply PWM1
    data1[1] = (LEDSelect & ~LEDs) | (LED_BLINK_PWM1 & LEDs);
  } else
    return;

  Wire.beginTransmission(LEDAddress);
  Wire.write(data1, 2);
  Wire.endTransmission();
  delayMicroseconds(1);
  Wire.beginTransmission(LEDAddress);
  Wire.write(data2 , 2);
  Wire.endTransmission();
  delayMicroseconds(1);

  LEDSelect = data1[1];
}

void RGBclear() {

  // clear LEDs
  setBrightness(3, 0, LED_RED | LED_GREEN | LED_BLUE);
}

void RGBerrorSequence() {

  RGBclear();

  // set blinking red lights
  setBrightness(1, 200, LED_RED);
  setBlinkRate(1, LED_RED, 130);
}

void RGBsetDefaultColor(uint8_t LEDColor) {

  RGBclear();

  // set frequency to slowest and duty cyle to zero (off)
//   if (LEDColor == 0xff) LEDColor = eeprom::getColor();

// blink rate has to be set first in order for color to register,
// so set blink before each color
  LEDEnabled = true;

  uint8_t color;
  uint8_t intensity = 100;

  switch (LEDColor) {
  default:
  case LED_DEFAULT_WHITE:
    color = LED_RED | LED_GREEN | LED_BLUE;
    break;
  case LED_DEFAULT_BLUE:
    color = LED_BLUE;
    break;
  case LED_DEFAULT_RED:
    color = LED_RED;
    break;
  case LED_DEFAULT_GREEN:
    color = LED_GREEN;
    break;
  case LED_DEFAULT_ORANGE:
    setBlinkOff(1, LED_GREEN);
    setBrightness(1, 50, LED_GREEN);
    color = LED_RED;
    intensity = 200;
    break;
  case LED_DEFAULT_PINK:
    color = LED_BLUE | LED_RED;
    intensity = 70;
    break;
  case LED_DEFAULT_PURPLE:
    color = LED_BLUE | LED_RED;
    intensity = 200;
    break;
//     case LED_DEFAULT_CUSTOM:
//     {
//    uint32_t CustomColor = eeprom::getEeprom32(
//         eeprom_offsets::LED_STRIP_SETTINGS +
//         blink_eeprom_offsets::CUSTOM_COLOR_OFFSET,
//         0xFFFFFFFF);
//    RGBsetColor(CustomColor >> 24, CustomColor >> 16, CustomColor >> 8, true);
//    return;
//     }
  case LED_DEFAULT_OFF:
    LEDEnabled = false;
    return;
  }
  setBrightness(1, intensity, color);
}

// set LED color and store to EEPROM "custom" color area
void RGBsetCustomColor(uint8_t red, uint8_t green, uint8_t blue) {
//     eeprom::setCustomColor(red, green, blue);
  LEDEnabled = true;
  RGBsetColor(red, green, blue, true);
}

#ifdef PCA9533
struct LEDColor;
typedef LEDColor LEDColor;

void pca9533_set_led_color(const LEDColor &color) {
  RGBsetColor(color.r , color.g, color.r, true);
}
#endif
// wiggly: set a three value color using a 2 value driver (+ ON/OFF channel)
void RGBsetColor(uint8_t red, uint8_t green, uint8_t blue, bool clearOld) {

  if (!LEDEnabled)
    return;

  if (clearOld)
    RGBclear();

  int count;
  count = 0;
  uint8_t leds_on = 0;

  // if any color is all on, set it to ON
  if (red == 255)
    leds_on |= LED_RED;
  if (green == 255)
    leds_on |= LED_GREEN;
  if (blue == 255)
    leds_on |= LED_BLUE;

  setBrightness(3, 1, leds_on);

  // find number of distict color values
  if (!((red == 0) || (red == 255)))
    count++;

  if (!((green == 0) || (green == 255)))
    count++;

  if (!((blue == 0) || (blue == 255)))
    count++;

  // we have two channels for brightness, if we have two settings
  // or less, just set the channels to the requested values
  int channel = 0;
  if (count < 3) {
    if ((red > 0) && (red < 255)) {
      setBlinkOff(channel, LED_RED);
      setBrightness(channel++, red, LED_RED);
    }
    if ((green > 0) && (green < 255)) {
      setBlinkOff(channel, LED_GREEN);
      setBrightness(channel++, green, LED_GREEN);
    }
    if ((blue > 0) && (blue < 255)) {
      setBlinkOff(channel, LED_BLUE);
      setBrightness(channel++, blue, LED_BLUE);
    }
  }
  // if three different values are requested, set the two closest
  // values to be equal and use the same channel
  else {
    int distRB = abs(red - blue);
    int distRG = abs(red - green);
    int distBG = abs(blue - green);

    if (distRB < distRG) {
      /// red and blue closest
      if (distRB < distBG) {
        setBlinkOff(0, LED_GREEN);
        setBrightness(0, green, LED_GREEN);
        setBlinkOff(1, LED_RED | LED_BLUE);
        setBrightness(1, red, LED_RED | LED_BLUE);
      }
      /// blue and green closest
      else {
        setBlinkOff(0, LED_RED);
        setBrightness(0, red, LED_RED);
        setBlinkOff(1, LED_GREEN | LED_BLUE);
        setBrightness(1, green, LED_GREEN | LED_BLUE);
      }
    } else {
      /// red and green closest
      if (distRG < distBG) {
        setBlinkOff(0, LED_BLUE);
        setBrightness(0, blue, LED_BLUE);
        setBlinkOff(1, LED_GREEN | LED_RED);
        setBrightness(1, green, LED_GREEN | LED_RED);
      }
      /// blue and green closest
      else {
        setBlinkOff(0, LED_RED);
        setBrightness(0, red, LED_RED);
        setBlinkOff(1, LED_GREEN | LED_BLUE);
        setBrightness(1, green, LED_GREEN | LED_BLUE);
      }
    }
  }
}

