include <configuration.scad>
use <herringbone_gears.scad>
use <functions.scad>

//gear variables

motor_shaft_rad = 5/2+.2;
//drive_shaft_rad = 12/2+.2;

drive_shaft_rad = 25.4/2/2+.2;

small_teeth = 8;
big_teeth = 59;
gear_thick = 13;
distance_between_axles = 59;


circular_pitch = 360*distance_between_axles/(small_teeth+big_teeth);

part = 2;


if(part == 1){
   mirror([0,0,1]) motor_drive_gear();
}

if(part == 2){
    mirror([0,0,1]) roller_drive_gear();
}

if(part == 100){
    assembled();
}

module assembled(){
    difference(){
        union(){
            mirror([0,0,1]) motor_drive_gear();
            mirror([0,0,1]) rotate([0,0,180/59]) roller_drive_gear();
        }
        translate([0,100,0]) cube([200,200,200], center=true);
    }
}

module motor_drive_gear(){
    translate([distance_between_axles+1,0,0]) gear1(gear1_teeth = small_teeth, circular_pitch=circular_pitch, gear_height=gear_thick, gear1_base_height=6);
}

module roller_drive_gear(wall = 3){
    %motor_drive_gear();
    
    radius = gear_radius(big_teeth, circular_pitch);
    outer_radius = gear_outer_radius(big_teeth, circular_pitch);
    
    gear_chamfer_radius = (outer_radius - radius) / tan(45);
    
    cylinder_rad = (2 * 25.4 + 0.3)/2;
    cylinder_inner_rad = (45-.5)/2;
    
    bushing_rad = 15.33/2;
    bushing_flange_rad = 18.3/2;
    bushing_thick = 11;
    bushing_flange_thick = 1.5;
    
    lift = gear_thick+1;
    
    difference(){
        union(){
            //gear
            chamfered_herring_gear(height=gear_thick, number_of_teeth=big_teeth, circular_pitch=circular_pitch, teeth_twist=-1);
            
            //meat for mounting it to the roller
            translate([0,0,gear_thick-.1]) cylinder(r1=cylinder_rad+20, r2=cylinder_rad + 10, h=10.1);
        }
        
        //cutout slot for the roller itself
        translate([0,0,gear_thick-4]) difference(){
            cylinder(r=cylinder_rad, h=gear_thick+10.2);
            cylinder(r=cylinder_inner_rad, h=gear_thick+10.3);
        }
        //chamfer it
        translate([0,0,gear_thick+10]) rotate_extrude(){
            translate([(cylinder_rad+cylinder_inner_rad)/2,0,0]) circle(r=(cylinder_rad-cylinder_inner_rad)*.75, $fn=4);
        }
        
        //cutout for the shaft & bronze bushing
        translate([0,0,-.1]) {
            cylinder(r=bushing_rad, h=bushing_thick+.2);
            cylinder(r=bushing_flange_rad, h=bushing_flange_thick+.2);
            cylinder(r=drive_shaft_rad+.5, h=gear_thick*2);
        }
        
        //nut traps to fasten the gear to the roller
        translate([0,0,gear_thick+5]) for(i=[0:120:359]) rotate([0,0,i]) {
            translate([0,cylinder_rad+5-.6,0]) rotate([-90,0,0]) cap_cylinder(r=m5_rad, h=25);
            translate([0,cylinder_rad+10,0]) rotate([-90,0,0]) cap_cylinder(r=m5_cap_rad, h=25);
            //nut trap
            translate([0,cylinder_rad+5-.5,0]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r2=8.135/cos(180/4)/2,r1=8.135/cos(180/4)/2+.3, h=5, $fn=4);
            translate([0,cylinder_rad+5-.5,5]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r2=8.135/cos(180/4)/2,r1=8.135/cos(180/4)/2+.3, h=5, $fn=4);
        }
        
        //hollow out the gear a bit
        translate([0,0,-.1]) {
            for(i=[60:120:359]) rotate([0,0,i]) {
                translate([0, (outer_radius+bushing_rad)/2, 0]) cylinder(r=17, h=gear_thick+10+1);
            }
        }
    }
}
