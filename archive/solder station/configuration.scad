mdf_wall = 6.5;
mdf_tab = 15;

wall = 5;

screw_slop = .2;
slop = .2;
laser_slop = -.1;

smooth_rod_rad = 10/2+laser_slop+.1;

//these can't change - measured values.
beam = 20;
bed_screw_sep = 309;
bed = 300;

layer_height=.2;

//this is for using the big idlers
//idler_rad = 17.5/2;
//idler_flange_rad = 22/2;

//this is using flanged bearings, and no plastic
idler_rad = 10/2;
idler_flange_rad = 15/2;

pulley_rad = 13/2;
pulley_flange_rad = 18/2;

//using the mini V-wheels
wheel_rad = 11.5/2;
wheel_clearance = 18;
wheel_height = 9;
wheel_flange_rad = 16/2;

eccentric_rad = 7.3/2;
eccentric_flange_rad = 11/2;

//frame lengths - may be dependent on wall above.
frame_x = 500;  //we lose more in X because of the endcaps - it's where all the motors etc. will hide.
frame_y = 420;  //(420-300)/2-beam=40mm clearance on either side of the printer.
frame_z = 420;  //because square is nice.

foot_height = 60;       //tall foot, cuz the Z motor will be underneath.

echo("BOM: 4, reg rail, 2020", frame_x, "Frame");

//motor size and placement variables
motor_w = 42;
motor_r = 52/2;
motor_y = frame_y/2-beam-pulley_rad; //distance motors are from the center.

belt_thick = 6;
belt_width = 2;


//gantry - might want to make it bigger
echo("BOM: 1, v-rail, 2020", frame_y, "Gantry");

//bed lengths
bed_x = 300+beam*2;
bed_y = 300;  //the screwholes on the bed should line up with the long_bed rails.
echo("BOM: 2, reg rail, 2020", bed_x, "Bed mount");
echo("BOM: 3, reg rail, 2020", bed_y, "Bed mount");  //might want more than three - to hold insulation well.

//standard screw variables
m3_nut_rad = 6.01/2+slop;
m3_nut_height = 2.4;
m3_rad = 3/2+slop;
m3_cap_rad = 3.25;
m3_cap_height = 2;

m4_nut_rad = 7.66/2+slop;
m4_nut_height = 3.2;
m4_rad = 4/2+slop;
m4_cap_rad = 7/2+slop;
m4_cap_height = 2.5;

m5_nut_rad = 8.79/2;
m5_nut_rad_laser = 8.79/2-.445;
m5_nut_height = 4.7;
m5_rad = 5/2;
m5_cap_rad = 10/2+slop;
m5_cap_height = 3;


//some enums
MALE = 1;
FEMALE = -1;

//makes all the holes have lots of segments
$fs=.5;
$fa=.1;
