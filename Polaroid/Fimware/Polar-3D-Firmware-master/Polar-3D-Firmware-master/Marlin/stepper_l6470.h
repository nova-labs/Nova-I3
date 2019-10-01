// Declare per-axis L6470 objects
//   Assumes information from pins.h has been loaded already

#ifndef STEPPER_L6470_H
#define STEPPER_L6470_h

#include "L6470.h"

extern uint8_t l6470_khold[4];

// Assumes pins.h info is loaded

#if defined(X_L6470_CS_PIN) && (X_L6470_CS_PIN > -1)
extern L6470 l6470_x;
#endif
#if defined(Y_L6470_CS_PIN) && (Y_L6470_CS_PIN > -1)
extern L6470 l6470_y;
#endif
#if defined(Z_L6470_CS_PIN) && (Z_L6470_CS_PIN > -1)
extern L6470 l6470_z;
#endif
#if defined(E0_L6470_CS_PIN) && (E0_L6470_CS_PIN > -1)
extern L6470 l6470_e0;
#endif
#if (EXTRUDERS > 1) && defined(E1_L6470_CS_PIN) && (E1_L6470_CS_PIN > -1)
extern L6470 l6470_e1;
#endif
#if (EXTRUDERS > 2) && defined(E2_L6470_CS_PIN) && (E2_L6470_CS_PIN > -1)
extern L6470 l6470_e2;
#endif

#endif
