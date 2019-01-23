// PRUSA iteration3
// Y drivetrain (idler and stepper holders)
// GNU GPL v3
// Josef Průša <josefprusa@me.com>
// Václav 'ax' Hůla <axtheb@gmail.com>
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/josefprusa/Prusa3

// ThingDoc entry
/**
 * @id yMotorHolder
 * @name Y Axis Motor Holder
 * @category Printed
 */
 
/**
 * @id yIdler
 * @name Y Axis Belt Idler
 * @category Printed
 */ 
 
include <configuration.scad>
use <inc/bearing-guide.scad>

echo(idler_width);

module motorholder(thickness=10){
    difference(){
        union(){
            // Motor holding part
            translate([29, -21 + 50, 0])
            {
                difference(){
                    union(){
                        translate([-21 + 4.5, 0, 5]) cube([9, 31, thickness], center=true);
                        nema17([0, 1, 1, 0], thickness=thickness, shadow=false);
                        mirror([0, 0, 1]) translate([0, 0, -10]) nema17([0, 1, 1, 0], thickness=thickness, shadow=7);
                        // Parts joining part
                        translate([-29, -21, 0]) cube([14, 30, thickness]);
                    }
                    // Motor mounting holes
                    translate([0, 0, thickness]) mirror([0, 0, 1]) nema17([0, 1, 1, 0], thickness=thickness, holes=true);
                }
            }

            // Front holding part
            translate([0, 10, 0]) cylinder(h = thickness, r=8);
            translate([0, 20, 5]) cube([16, 20, thickness], center=true);
            translate([0, 30, 0]) cylinder(h = thickness, r=8);
        }
        translate([0, 10, -1]) cylinder(h = 12, r=4.5, $fn=32);
        translate([0, 30, -1]) cylinder(h = 12, r=4.5, $fn=32);
    }
}

module oval(r=4, l=14, h=2){
    intersection() {
        union() {
            translate([l / 2, 0, 0]) cylinder(r=r, h=h, $fn=4);
            //translate([-l / 2, 0, 0]) cylinder(r=r, h=h, $fn=4);
            translate([0, 0, h / 2]) cube([l, r * 2, h], center=true);
        }
        translate([0, 0, h / 2]) cube([l + r * 1.2, r * 2, h], center=true);
    }
}

module idlermount(len=45, narrow_len=0, narrow_width=0, rod=threaded_rod_diameter_horizontal / 2, idler_height=16, horizontal=1, oval_height=1, fillet=1){
    
    oval_height = max(oval_height, 2.2);
    
    difference(){
        union(){
            //wide part holding bearing
            translate([- (10 + idler_width) / 2, -25 + narrow_len, 0] ) cube_fillet([10 + idler_width, len + idler_bearing[2] * 1.1 - narrow_len, idler_height]);
            //For X there is narrow part inside the x-idler
            if (narrow_len > 0){
                translate([-narrow_width / 2, -25, 0] ) cube_fillet([narrow_width, len + idler_bearing[2], idler_height], vertical=[0, 0, 2, 2]);
                if(fillet==1){
                    mirror([1, 0, 0]) translate([-narrow_width / 2, narrow_len -25, idler_height / 2 ]) fillet(1.5, idler_height - 0.04, $fn=8);
                    translate([-narrow_width / 2, narrow_len -25, idler_height / 2]) fillet(1.5, idler_height - 0.04, $fn=8);
                }
            }
        }
        if(horizontal==1){
            translate([-12, -12, idler_height / 2]) rotate([90, 0, 90]) oval(r=oval_height, l=12, h=50);
        }
        if(horizontal==0){
            translate([0, -18+len/4, -idler_height / 2]) rotate([0, 0, 90]) oval(r=oval_height, l=len/2, h=50);
        }
        translate([0, -18 - single_wall_width*2, idler_height / 2]) {
            // nut for tensioning screw
           hull(){
                rotate([90, 0, 0]) rotate([0,0,30]) cylinder(r=m3_nut_diameter_horizontal / 2, h=3.1, $fn=6);
                translate([0,.5,20]) rotate([90, 0, 0]) rotate([0,0,30]) cylinder(r=m3_nut_diameter_horizontal / 2+1, h=3.1+1, $fn=6);
            }
            
        }

        // tensioning screw goes here
        translate([0, -19, idler_height / 2]) rotate([90, 90, 0]) cylinder(r=m3_diameter / 2, h=15, $fn=small_hole_segments, center=true);
        // bearing goes there
        translate([0, len + idler_bearing[2] - 35, idler_height/2]){
            difference(){
                union(){
                    rotate([0, 90, 0]) idler_assy(idler_bearing, idler_width=idler_width, $fn=32);
                    translate([0, 10, 0]) cube([idler_width + 1, 20, idler_height + 2], center=true);
                }
                //cube([8,15,5],center=true);
                for(i=[0,1]) mirror([i,0,0]) rotate([0,-90,0]) translate([0,0,idler_width/2-.45]) cylinder(r1=3.25, r2=7, h=1.1);
                
                echo((idler_width+1-5)/2);
            }
            
            echo(1+idler_width);
            translate([(10 + idler_width)/2-3.5,0,0]) rotate([0,90,0]) cylinder(r1=m5_nut_diameter_horizontal/2, r2=m5_nut_diameter_horizontal/2+.5, h=10, $fn=6);
            translate([(10 + idler_width)/2-2,0,0]) rotate([0,90,0]) cylinder(r=m5_diameter/2+.1, h=50,center=true, $fn=32);
            mirror([1,0,0]) translate([(10 + idler_width)/2-3.5,0,0]) rotate([0,90,0]) cylinder(r1=m5_nut_diameter_horizontal/2+.5, r2=m5_nut_diameter_horizontal/2+1, h=10);
        }

    }
}

//the Y tensioner
idlermount(len=40, horizontal=0, oval_height=(idler_width+1)/2);

//modified Y tensioner, for two flanged bearings
*idlermount(len=40, horizontal=0, idler_width=9, oval_height=(idler_width+1)/2);


//motorholder();
*translate([32, 25, 0])  idlermount(len=50, horizontal=0, oval_height=(idler_width+1)/2);

//the X tensioner
translate([40,0,0]) idlermount(len=68, rod=m3_diameter / 2 + 0.5, idler_height=16, narrow_len=47, narrow_width=idler_width +1.5 + 2 - single_wall_width, horizontal=1);

//Modified X tensioner, for two flanged bearings
*translate([70,0,0]) idlermount(len=68, rod=m3_diameter / 2 + 0.5, idler_height=16, idler_width=9, narrow_len=47, narrow_width=idler_width +1.5 + 2 - single_wall_width, horizontal=1);


*if (idler_bearing[3] == 1) {
    translate([0, -12 - idler_bearing[0] / 2, 0]) {
        render() bearing_assy();
    }
}
