Compiler can be found at: http://www.arduino.cc/en/Main/Software
As described here (https://reprap.org/wiki/Rambo_firmware#Compiling_Marlin_Instructions) you add the Rambo board profile by adding the following URL to "Additional Board Manager URLs" section.
https://raw.githubusercontent.com/ultimachine/ArduinoAddons/master/package_ultimachine_index.json
The Arduino sketch is called Marlin.ino and can be found in the git directory that starts with "Source"
To get things to compile you need to add one library as described here: https://github.com/teemuatlut/TMC2130Stepper
