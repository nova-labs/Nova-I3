<h1>Prusinante!</h1>

Prusinante is running:
 * MKS 1.5
 * Capacitance sensor
 * aluminum PCB bed
 * PCB heater
 * E3D V6 hotend
 * Brass nozzle

Errata:
E0 driver is dead - remapped pins from the E1 driver.
pins_RAMPS.h and pins_MKS_15.h are updated.

To BUILD:
Open the /base in platform.io within vscode, copy in the Configiuration.h and Configuration_adv.h, copy the pins into the Marlin/src/pins/ramps folder, build

To INSTALL:
platform.io can upload firmware as well.


