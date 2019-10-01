// Copyright 2015, Mike Hord, SparkFun with the statement
//
//    Code is open source so please feel free to do anything you want with it;
//    you buy me a beer if you use this and we meet someday (Beerware license).
//
// Developed by SparkFun and available via their github repo,
//
//   https://github.com/sparkfun/L6470-AutoDriver/
//
// July 2016 C++ conversions to support multiple driver chips contributed by Polar 3D LLC.
// For Polar 3D's purposes, this library was actually working better than SparkFun's
// later C++ AutoDriver library.

#include <SPI.h>
#include "L6470.h"

// Bill: you can try direct SPI code and none of the Arduino SPI
#define SPI_DIRECT 1

#if SPI_DIRECT == 1
#include <util/delay.h>
#endif

static void spiConfig(void);

//L6470_commands.ino - Contains high-level command implementations- movement
//   and configuration commands, for example.

// Realize the "set parameter" function, to write to the various registers in
//  the dSPIN chip.
void L6470::setParam(byte param, unsigned long value)
{
	xfer(L6470_SET_PARAM | param);
	paramHandler(param, value);
}

// Realize the "get parameter" function, to read from the various registers in
//  the dSPIN chip.
unsigned long L6470::getParam(byte param)
{
	xfer(L6470_GET_PARAM | param);
	return paramHandler(param, 0);
}

// Much of the functionality between "get parameter" and "set parameter" is
//  very similar, so we deal with that by putting all of it in one function
//  here to save memory space and simplify the program.
unsigned long L6470::paramHandler(byte param, unsigned long value)
{
	unsigned long ret_val = 0;   // This is a temp for the value to return.
	// This switch structure handles the appropriate action for each register.
	//  This is necessary since not all registers are of the same length, either
	//  bit-wise or byte-wise, so we want to make sure we mask out any spurious
	//  bits and do the right number of transfers. That is handled by the param()
	//  function, in most cases, but for 1-byte or smaller transfers, we call
	//  xfer() directly.
	switch (param)
	{
		// ABS_POS is the current absolute offset from home. It is a 22 bit number expressed
		//  in two's complement. At power up, this value is 0. It cannot be written when
		//  the motor is running, but at any other time, it can be updated to change the
		//  interpreted position of the motor.
    case L6470_ABS_POS:
		ret_val = paramXfer(value, 22);
		break;
		// EL_POS is the current electrical position in the step generation cycle. It can
		//  be set when the motor is not in motion. Value is 0 on power up.
    case L6470_EL_POS:
		ret_val = paramXfer(value, 9);
		break;
		// MARK is a second position other than 0 that the motor can be told to go to. As
		//  with ABS_POS, it is 22-bit two's complement. Value is 0 on power up.
    case L6470_MARK:
		ret_val = paramXfer(value, 22);
		break;
		// SPEED contains information about the current speed. It is read-only. It does
		//  NOT provide direction information.
    case L6470_SPEED:
		ret_val = paramXfer(0, 20);
		break;
		// ACC and DEC set the acceleration and deceleration rates. Set ACC to 0xFFF
		//  to get infinite acceleration/decelaeration- there is no way to get infinite
		//  deceleration w/o infinite acceleration (except the HARD STOP command).
		//  Cannot be written while motor is running. Both default to 0x08A on power up.
		// AccCalc() and DecCalc() functions exist to convert steps/s/s values into
		//  12-bit values for these two registers.
    case L6470_ACC:
		ret_val = paramXfer(value, 12);
		break;
    case L6470_DEC:
		ret_val = paramXfer(value, 12);
		break;
		// MAX_SPEED is just what it says- any command which attempts to set the speed
		//  of the motor above this value will simply cause the motor to turn at this
		//  speed. Value is 0x041 on power up.
		// MaxSpdCalc() function exists to convert steps/s value into a 10-bit value
		//  for this register.
    case L6470_MAX_SPEED:
		ret_val = paramXfer(value, 10);
		break;
		// MIN_SPEED controls two things- the activation of the low-speed optimization
		//  feature and the lowest speed the motor will be allowed to operate at. LSPD_OPT
		//  is the 13th bit, and when it is set, the minimum allowed speed is automatically
		//  set to zero. This value is 0 on startup.
		// MinSpdCalc() function exists to convert steps/s value into a 12-bit value for this
		//  register. setLSPDOpt() function exists to enable/disable the optimization feature.
    case L6470_MIN_SPEED:
		ret_val = paramXfer(value, 12);
		break;
		// FS_SPD register contains a threshold value above which microstepping is disabled
		//  and the dSPIN operates in full-step mode. Defaults to 0x027 on power up.
		// FSCalc() function exists to convert steps/s value into 10-bit integer for this
		//  register.
    case L6470_FS_SPD:
		ret_val = paramXfer(value, 10);
		break;
		// KVAL is the maximum voltage of the PWM outputs. These 8-bit values are ratiometric
		//  representations: 255 for full output voltage, 128 for half, etc. Default is 0x29.
		// The implications of different KVAL settings is too complex to dig into here, but
		//  it will usually work to max the value for RUN, ACC, and DEC. Maxing the value for
		//  HOLD may result in excessive power dissipation when the motor is not running.
    case L6470_KVAL_HOLD:
		ret_val = xfer((byte)value);
		break;
    case L6470_KVAL_RUN:
		ret_val = xfer((byte)value);
		break;
    case L6470_KVAL_ACC:
		ret_val = xfer((byte)value);
		break;
    case L6470_KVAL_DEC:
		ret_val = xfer((byte)value);
		break;
		// INT_SPD, ST_SLP, FN_SLP_ACC and FN_SLP_DEC are all related to the back EMF
		//  compensation functionality. Please see the datasheet for details of this
		//  function- it is too complex to discuss here. Default values seem to work
		//  well enough.
    case L6470_INT_SPD:
		ret_val = paramXfer(value, 14);
		break;
    case L6470_ST_SLP:
		ret_val = xfer((byte)value);
		break;
    case L6470_FN_SLP_ACC:
		ret_val = xfer((byte)value);
		break;
    case L6470_FN_SLP_DEC:
		ret_val = xfer((byte)value);
		break;
		// K_THERM is motor winding thermal drift compensation. Please see the datasheet
		//  for full details on operation- the default value should be okay for most users.
    case L6470_K_THERM:
		ret_val = xfer((byte)value & 0x0F);
		break;
		// ADC_OUT is a read-only register containing the result of the ADC measurements.
		//  This is less useful than it sounds; see the datasheet for more information.
    case L6470_ADC_OUT:
		ret_val = xfer(0);
		break;
		// Set the overcurrent threshold. Ranges from 375mA to 6A in steps of 375mA.
		//  A set of defined constants is provided for the user's convenience. Default
		//  value is 3.375A- 0x08. This is a 4-bit value.
    case L6470_OCD_TH:
		ret_val = xfer((byte)value & 0x0F);
		break;
		// Stall current threshold. Defaults to 0x40, or 2.03A. Value is from 31.25mA to
		//  4A in 31.25mA steps. This is a 7-bit value.
    case L6470_STALL_TH:
		ret_val = xfer((byte)value & 0x7F);
		break;
		// STEP_MODE controls the microstepping settings, as well as the generation of an
		//  output signal from the dSPIN. Bits 2:0 control the number of microsteps per
		//  step the part will generate. Bit 7 controls whether the BUSY/SYNC pin outputs
		//  a BUSY signal or a step synchronization signal. Bits 6:4 control the frequency
		//  of the output signal relative to the full-step frequency; see datasheet for
		//  that relationship as it is too complex to reproduce here.
		// Most likely, only the microsteps per step value will be needed; there is a set
		//  of constants provided for ease of use of these values.
    case L6470_STEP_MODE:
		ret_val = xfer((byte)value);
		break;
		// ALARM_EN controls which alarms will cause the FLAG pin to fall. A set of constants
		//  is provided to make this easy to interpret. By default, ALL alarms will trigger the
		//  FLAG pin.
    case L6470_ALARM_EN:
		ret_val = xfer((byte)value);
		break;
		// CONFIG contains some assorted configuration bits and fields. A fairly comprehensive
		//  set of reasonably self-explanatory constants is provided, but users should refer
		//  to the datasheet before modifying the contents of this register to be certain they
		//  understand the implications of their modifications. Value on boot is 0x2E88; this
		//  can be a useful way to verify proper start up and operation of the dSPIN chip.
    case L6470_CONFIG:
		ret_val = paramXfer(value, 16);
		break;
		// STATUS contains read-only information about the current condition of the chip. A
		//  comprehensive set of constants for masking and testing this register is provided, but
		//  users should refer to the datasheet to ensure that they fully understand each one of
		//  the bits in the register.
    case L6470_STATUS:  // STATUS is a read-only register
		ret_val = paramXfer(0, 16);
		break;
    default:
		ret_val = xfer((byte)(value));
		break;
	}
	return ret_val;
}

// Enable or disable the low-speed optimization option. If enabling,
//  the other 12 bits of the register will be automatically zero.
//  When disabling, the value will have to be explicitly written by
//  the user with a setParam() call. See the datasheet for further
//  information about low-speed optimization.
void L6470::setLSPDOpt(boolean enable)
{
	xfer(L6470_SET_PARAM | L6470_MIN_SPEED);
	if (enable) paramXfer(0x1000, 13);
	else paramXfer(0, 13);
}

// RUN sets the motor spinning in a direction (defined by the constants
//  FWD and REV). Maximum speed and minimum speed are defined
//  by the MAX_SPEED and MIN_SPEED registers; exceeding the FS_SPD value
//  will switch the device into full-step mode.
// The SpdCalc() function is provided to convert steps/s values into
//  appropriate integer values for this function.
void L6470::run(unsigned long spd)
{
	xfer(L6470_RUN | last_dir);
	if (spd > 0xFFFFF) spd = 0xFFFFF;
	xfer((byte)(spd >> 16));
	xfer((byte)(spd >> 8));
	xfer((byte)(spd));
}

void L6470::run(byte dir, unsigned long spd)
{
	last_dir = dir;
	run(spd);
}

// STEP_CLOCK puts the device in external step clocking mode. When active,
//  pin 25, STCK, becomes the step clock for the device, and steps it in
//  the direction (set by the FWD and REV constants) imposed by the call
//  of this function. Motion commands (RUN, MOVE, etc) will cause the device
//  to exit step clocking mode.
void L6470::stepClock(byte dir)
{
	last_dir = dir;
	xfer(L6470_STEP_CLOCK | dir);
}

// MOVE will send the motor n_step steps (size based on step mode) in the
//  direction imposed by dir (FWD or REV constants may be used). The motor
//  will accelerate according the acceleration and deceleration curves, and
//  will run at MAX_SPEED. Stepping mode will adhere to FS_SPD value, as well.
void L6470::move(unsigned long n_step)
{
	xfer(L6470_MOVE | last_dir);
	if (n_step > 0x3FFFFF) n_step = 0x3FFFFF;
	xfer((byte)(n_step >> 16));
	xfer((byte)(n_step >> 8));
	xfer((byte)(n_step));
}

void L6470::move(byte dir, unsigned long n_step)
{
	last_dir = dir;
	move(n_step);
}

// GOTO operates much like MOVE, except it produces absolute motion instead
//  of relative motion. The motor will be moved to the indicated position
//  in the shortest possible fashion.
void L6470::goTo(unsigned long pos)
{

	xfer(L6470_GOTO);
	if (pos > 0x3FFFFF) pos = 0x3FFFFF;
	xfer((byte)(pos >> 16));
	xfer((byte)(pos >> 8));
	xfer((byte)(pos));
}

// Same as GOTO, but with user constrained rotational direction.
void L6470::goToDir(byte dir, unsigned long pos)
{
	last_dir = dir;
	xfer(L6470_GOTO_DIR | dir);
	if (pos > 0x3FFFFF) pos = 0x3FFFFF;
	xfer((byte)(pos >> 16));
	xfer((byte)(pos >> 8));
	xfer((byte)(pos));
}

// goUntil will set the motor running with direction dir (REV or
//  FWD) until a falling edge is detected on the SW pin. Depending
//  on bit SW_MODE in CONFIG, either a hard stop or a soft stop is
//  performed at the falling edge, and depending on the value of
//  act (either RESET or COPY) the value in the ABS_POS register is
//  either RESET to 0 or COPY-ed into the MARK register.
void L6470::goUntil(byte act, byte dir, unsigned long spd)
{
	last_dir = dir;
	xfer(L6470_GO_UNTIL | act | dir);
	if (spd > 0x3FFFFF) spd = 0x3FFFFF;
	xfer((byte)(spd >> 16));
	xfer((byte)(spd >> 8));
	xfer((byte)(spd));
}

// Similar in nature to goUntil, releaseSW produces motion at the
//  higher of two speeds: the value in MIN_SPEED or 5 steps/s.
//  The motor continues to run at this speed until a rising edge
//  is detected on the switch input, then a hard stop is performed
//  and the ABS_POS register is either COPY-ed into MARK or RESET to
//  0, depending on whether RESET or COPY was passed to the function
//  for act.
void L6470::releaseSW(byte act, byte dir)
{
	last_dir = dir;
	xfer(L6470_RELEASE_SW | act | dir);
}

// goHome is equivalent to goTo(0), but requires less time to send.
//  Note that no direction is provided; motion occurs through shortest
//  path. If a direction is required, use goToDir().
void L6470::goHome()
{
	xfer(L6470_GO_HOME);
}

// goMark is equivalent to goTo(MARK), but requires less time to send.
//  Note that no direction is provided; motion occurs through shortest
//  path. If a direction is required, use goToDir().
void L6470::goMark()
{
	xfer(L6470_GO_MARK);
}

// Sets the ABS_POS register to 0, effectively declaring the current
//  position to be "HOME".
void L6470::resetPos()
{
	xfer(L6470_RESET_POS);
}

// Reset device to power up conditions. Equivalent to toggling the STBY
//  pin or cycling power.
void L6470::resetDev()
{
	xfer(L6470_RESET_DEVICE);
}

// Bring the motor to a halt using the deceleration curve.
void L6470::softStop()
{
	xfer(L6470_SOFT_STOP);
}

// Stop the motor with infinite deceleration.
void L6470::hardStop()
{
	xfer(L6470_HARD_STOP);
}

// Decelerate the motor and put the bridges in Hi-Z state.
void L6470::softHiZ()
{
	xfer(L6470_SOFT_HIZ);
}

// Put the bridges in Hi-Z state immediately with no deceleration.
void L6470::hardHiZ()
{
	xfer(L6470_HARD_HIZ);
}

void L6470::setDir(byte dir)
{
	last_dir = dir;
}

// Fetch and return the 16-bit value in the STATUS register. Resets
//  any warning flags and exits any error states. Using getParam()
//  to read STATUS does not clear these values.
int L6470::getStatus()
{
	int temp = 0;
	xfer(L6470_GET_STATUS);
	temp = xfer(0)<<8;
	temp |= xfer(0);
	return temp;
}

// The value in the ACC register is [(steps/s/s)*(tick^2)]/(2^-40) where tick is
//  250ns (datasheet value)- 0x08A on boot.
// Multiply desired steps/s/s by .137438 to get an appropriate value for this register.
// This is a 12-bit value, so we need to make sure the value is at or below 0xFFF.
unsigned long L6470::accCalc(float stepsPerSecPerSec)
{
	float temp = stepsPerSecPerSec * 0.137438;
	if( (unsigned long) long(temp) > 0x00000FFF) return 0x00000FFF;
	else return (unsigned long) long(temp);
}

// The calculation for DEC is the same as for ACC. Value is 0x08A on boot.
// This is a 12-bit value, so we need to make sure the value is at or below 0xFFF.
unsigned long L6470::decCalc(float stepsPerSecPerSec)
{
	float temp = stepsPerSecPerSec * 0.137438;
	if( (unsigned long) long(temp) > 0x00000FFF) return 0x00000FFF;
	else return (unsigned long) long(temp);
}

// The value in the MAX_SPD register is [(steps/s)*(tick)]/(2^-18) where tick is
//  250ns (datasheet value)- 0x041 on boot.
// Multiply desired steps/s by .065536 to get an appropriate value for this register
// This is a 10-bit value, so we need to make sure it remains at or below 0x3FF
unsigned long L6470::maxSpdCalc(float stepsPerSec)
{
	float temp = stepsPerSec * .065536;
	if( (unsigned long) long(temp) > 0x000003FF) return 0x000003FF;
	else return (unsigned long) long(temp);
}

// The value in the MIN_SPD register is [(steps/s)*(tick)]/(2^-24) where tick is
//  250ns (datasheet value)- 0x000 on boot.
// Multiply desired steps/s by 4.1943 to get an appropriate value for this register
// This is a 12-bit value, so we need to make sure the value is at or below 0xFFF.
unsigned long L6470::minSpdCalc(float stepsPerSec)
{
	float temp = stepsPerSec * 4.1943;
	if( (unsigned long) long(temp) > 0x00000FFF) return 0x00000FFF;
	else return (unsigned long) long(temp);
}

// The value in the FS_SPD register is ([(steps/s)*(tick)]/(2^-18))-0.5 where tick is
//  250ns (datasheet value)- 0x027 on boot.
// Multiply desired steps/s by .065536 and subtract .5 to get an appropriate value for this register
// This is a 10-bit value, so we need to make sure the value is at or below 0x3FF.
unsigned long L6470::fsCalc(float stepsPerSec)
{
	float temp = (stepsPerSec * .065536)-.5;
	if( (unsigned long) long(temp) > 0x000003FF) return 0x000003FF;
	else return (unsigned long) long(temp);
}

// The value in the INT_SPD register is [(steps/s)*(tick)]/(2^-24) where tick is
//  250ns (datasheet value)- 0x408 on boot.
// Multiply desired steps/s by 4.1943 to get an appropriate value for this register
// This is a 14-bit value, so we need to make sure the value is at or below 0x3FFF.
unsigned long L6470::intSpdCalc(float stepsPerSec)
{
	float temp = stepsPerSec * 4.1943;
	if( (unsigned long) long(temp) > 0x00003FFF) return 0x00003FFF;
	else return (unsigned long) long(temp);
}

// When issuing RUN command, the 20-bit speed is [(steps/s)*(tick)]/(2^-28) where tick is
//  250ns (datasheet value).
// Multiply desired steps/s by 67.106 to get an appropriate value for this register
// This is a 20-bit value, so we need to make sure the value is at or below 0xFFFFF.
unsigned long L6470::spdCalc(float stepsPerSec)
{
	float temp = stepsPerSec * 67.106;
	if( (unsigned long) long(temp) > 0x000FFFFF) return 0x000FFFFF;
	else return (unsigned long)temp;
}

// Generalization of the subsections of the register read/write functionality.
//  We want the end user to just write the value without worrying about length,
//  so we pass a bit length parameter from the calling function.
unsigned long L6470::paramXfer(unsigned long value, byte bit_len)
{
	unsigned long ret_val=0;        // We'll return this to generalize this function
	//  for both read and write of registers.
	byte byte_len = bit_len/8;      // How many BYTES do we have?
	if (bit_len%8 > 0) byte_len++;  // Make sure not to lose any partial byte values.
	// Let's make sure our value has no spurious bits set, and if the value was too
	//  high, max it out.
	unsigned long mask = 0xffffffff >> (32-bit_len);
	if (value > mask) value = mask;
	// The following three if statements handle the various possible byte length
	//  transfers- it'll be no less than 1 but no more than 3 bytes of data.
	// dSPIN_xfer() sends a byte out through SPI and returns a byte received
	//  over SPI- when calling it, we typecast a shifted version of the masked
	//  value, then we shift the received value back by the same amount and
	//  store it until return time.
	if (byte_len == 3) {
		ret_val |= (unsigned long)xfer((byte)(value>>16)) << 16;
		//Serial.println(ret_val, HEX);
	}
	if (byte_len >= 2) {
		ret_val |= xfer((byte)(value>>8)) << 8;
		//Serial.println(ret_val, HEX);
	}
	if (byte_len >= 1) {
		ret_val |= xfer((byte)value);
		//Serial.println(ret_val, HEX);
	}
	// Return the received values. Mask off any unnecessary bits, just for
	//  the sake of thoroughness- we don't EXPECT to see anything outside
	//  the bit length range but better to be safe than sorry.
	return (ret_val & mask);
}

static void spiConfig(void)
{
#if !defined(SPI_DIRECT) || SPI_DIRECT == 0
	SPI.begin();
	SPI.setBitOrder(MSBFIRST);
	SPI.setClockDivider(SPI_CLOCK_DIV2); // or 2, 8, 16, 32, 64
	SPI.setDataMode(SPI_MODE3);
#else
	// Bill SPI can be sped up by changing spi_rate.  Might try 2 -> 2.0 MHz
	static uint8_t spi_rate = 0;

// Set SCK rate to F_CPU / 2^(1 + spi_rate), 0 <= spi_rate <= 6

// spi_rate = 0 ==> F_CPU /   2 =  8.0 MHz
//            1 ==> F_CPU /   4 =  4.0 MHz
//            2 ==> F_CPU /   8 =  2.0 MHz
//            3 ==> F_CPU /  16 =  1.0 MHz
//            4 ==> F_CPU /  32 =  0.5 MHz
//            5 ==> F_CPU /  64 =  250 KHz
//            6 ==> F_CPU / 128 =  125 HHz
//
// MODE3 = 0x0C == (1 << CPOL) | (1 << CPHA)
	 SPCR = (1 << SPE) | (1 << MSTR) | (1 << CPOL) | (1 << CPHA) | \
		 (spi_rate >> 1);
     SPSR = (spi_rate & 1) || (spi_rate == 6) ? 0 : (1 << SPI2X);
#endif
}

// This simple function shifts a byte out over SPI and receives a byte over
//  SPI. Unusually for SPI devices, the dSPIN requires a toggling of the
//  CS (slaveSelect) pin after each byte sent. That makes this function
//  a bit more reasonable, because we can include more functionality in it.
byte L6470::xfer(byte data)
{
	byte data_out;

#if !defined(SPI_DIRECT) || SPI_DIRECT == 0

	digitalWrite(cs_pin, LOW);
	// SPI.transfer() both shifts a byte out on the MOSI pin AND receives a
	//  byte in on the MISO pin.
	data_out = SPI.transfer(data);
	digitalWrite(cs_pin, HIGH);

#else

	/* select the device */
	digitalWrite(cs_pin, LOW);

	/* ensure 350ns delay - a bit extra is fine */
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz

	/* send the data */
	SPDR = data;

    /* wait for byte to be shifted out */
    // while (!(SPSR & (1 << SPIF)) && (tries++ < 100)) _delay_us(1);
    while (!(SPSR & (1 << SPIF))) { /* intentionally blank */ };

    // SPSR &= ~(1 << SPIF);

	data_out = SPDR;

	/* deselect the device */
	digitalWrite(cs_pin, HIGH);

	/* ensure 800ns delay - a bit extra is fine */
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
#if 0
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
	asm("nop"); //50ns on 20Mhz, 62.5ns on 16Mhz
#endif

	/*
	 *   Bill clever code to signal a timeout can go here
	 *  if (tries >= 100) {
	 *    do something clever like light an LED
	 *  }
	 */

#endif
	
	return data_out;
}

// This is the generic initialization function to set up the Arduino to
//  communicate with the dSPIN chip.
L6470::L6470(uint8_t cs_pin_, uint8_t rs_pin_, uint8_t bs_pin_) :
	cs_pin(cs_pin_), rs_pin(rs_pin_), bs_pin(bs_pin_), last_dir(L6470_FWD)
{
}

void L6470::init()
{
	static int setup_done = 0;

	if (!setup_done)
	{
		pinMode(MOSI, OUTPUT);
		pinMode(MISO, INPUT);
		pinMode(SCK, OUTPUT);
		setup_done = 1;
	}

	pinMode(cs_pin, OUTPUT);
	digitalWrite(cs_pin, HIGH);

	pinMode(rs_pin, OUTPUT);
	if (bs_pin != 0xFF)
		pinMode(bs_pin, INPUT);

	// reset the dSPIN chip. This could also be accomplished by
	//  calling the "dSPIN_ResetDev()" function after SPI is initialized.
	digitalWrite(rs_pin, HIGH);
	delay(1);
	digitalWrite(rs_pin, LOW);
	delay(1);
	digitalWrite(rs_pin, HIGH);
	delay(1);

	// initialize SPI for the dSPIN chip's needs:
	//  most significant bit first,
	//  SPI clock not to exceed 5MHz,
	//  SPI_MODE3 (clock idle high, latch data on rising edge of clock)
	spiConfig();
}
