// PRUSA iteration3
// X ends
// GNU GPL v3
// Josef Průša <josefprusa@me.com>
// Václav 'ax' Hůla <axtheb@gmail.com>
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/josefprusa/Prusa3

// ThingDoc entry
/**
 * @id xMotorEnd
 * @name X Axis Motor End
 * @category Printed
 */
 
/**
 * @id xIdlerEnd
 * @name X Axis Idler End
 * @category Printed
 */
 
include <configuration.scad>
use <bushing.scad>
use <inc/bearing-guide.scad>
use <y-drivetrain.scad>

//height and width of the x blocks depend on x smooth rod radius
x_box_height = 52 + 2 * bushing_xy[0];
x_box_width = (bushing_xy[0] <= 4) ? 17.5 : bushing_xy[0] * 2 + 9.5;
bearing_height = max ((bushing_z[2] > 30 ? x_box_height : (2 * bushing_z[2] + 8)), x_box_height);
echo(idler_width+10-4);


translate([0, -60, 0]) mirror([0, 0, 0]) x_end_idler(thru=true, spring=11.5);
!translate([-50, 0, 0]) mirror([0, 0, 0]) translate([50, 0, 0])
    x_end_motor(spring=0, leadscrew=true);
    
*translate([-50, 0, 0]) mirror([0, 0, 0]) translate([50, 0, 0])
    x_end_base(leadscrew=true);

m5_nut_height=5;

module x_end_motor(spring=0, leadscrew=false){

    mirror([0, 1, 0]) {

        x_end_base([3, 3, min((bushing_xy[0] - 3) * 2, 3), 2], len=42, offset=-5, thru=false, spring=spring, leadscrew=leadscrew);


        translate([0, -z_delta - 2, 0]) difference(){
            union(){
                intersection() {
                    translate([-15, -34, 30]) cube([20, 60, x_box_height], center = true);
                    union() {
                        translate([-14, -16 + z_delta / 2, 24]) cube_fillet([17.5, 10.5 + z_delta, 55], center = true, vertical=[0, 0, 3, 3], top=[0, 3, 6, 3], $fn=16);
                        //lower arm holding outer stepper screw
                        translate([-10.25, -34, 9]) intersection(){
                            translate([0, 0, -5]) cube_fillet([10, 37, 28], center = true, vertical=[0, 0, 0, 0], top=[0, 3, 5, 3]);
                            translate([-10/2, 10, -26]) rotate([45, 0, 0]) cube_fillet([10, 60, 60], radius=2);
                        }
                    }
                }
                translate([-16, -32, 30.25]) rotate([90, 0, 0])  rotate([0, 90, 0]) nema17(places=[1, 0, 1, 1], h=11);
            }

            // motor screw holes
            translate([21-5, -21-11, 30.25]){
                // belt hole
                    translate([-30, 11, -0.25]) cube_fillet([11, 36, 22], vertical=0, top=[0, 1, 0, 1], bottom=[0, 1, 0, 1], center = true, $fn=4);
                //motor mounting holes
                translate([-29.5, 0, 0]) rotate([0, 0, 0])  rotate([0, 90, 0]) nema17(places=[1, 1, 0, 1], holes=true, shadow=5.5, $fn=small_hole_segments, h=20);
            }
        }
        //smooth rod caps
        //translate([-22, -10, 0]) cube([17, 2, 15]);
        //translate([-22, -10, 45]) cube([17, 2, 10]);
    }
}

module x_end_base(vfillet=[3, 3, 3, 3], thru=true, len=40, offset=0, spring=0, leadscrew=false){
    
    nut_trap_height = 10+spring;

    difference(){
        union(){
            translate([-10 - bushing_xy[0], -10 + len / 2 + offset, 30]) cube_fillet([x_box_width, len, x_box_height], center=true, vertical=vfillet, top=[5, 3, 5, 3]);

            translate([0, 0, 4 - bushing_xy[0]]) {
                //rotate([0, 0, 0]) translate([0, -9.5, 0]) 
                translate([z_delta, 0, 0]) render(convexity = 5) linear(bushing_z, bearing_height);
                
                
                // Nut trap
                if(leadscrew == false){
                    translate([-2, 18, nut_trap_height/2]) cube_fillet([20, 14, nut_trap_height], center = true, vertical=[8, 0, 0, 5]);
                }else{
                    translate([-2, 17, nut_trap_height/2]) cube_fillet([20+9, 14+9, nut_trap_height], center = true, vertical=[8, 0, 0, 8]);
                }
            }
        }
        // here are bushings/bearings
        translate([z_delta, 0, 4 - bushing_xy[0]]) linear_negative(bushing_z, bearing_height);

        // belt hole
        translate([-14 - xy_delta / 2, 22 - 9 + offset, 30]) cube_fillet([max(idler_width + 2, 11), 55, 27], center = true, vertical=0, top=[0, 1, 0, 1], bottom=[0, 1, 0, 1], $fn=4);

        //smooth rods
        translate([-10 - bushing_xy[0], offset, 0]) {
            if(thru == true){
                translate([0, -11, 6]) rotate([-90, 0, 0]) pushfit_rod(bushing_xy[0] * 2 + 0.3, 50);
                translate([0, -11, xaxis_rod_distance+6]) rotate([-90, 0, 0]) pushfit_rod(bushing_xy[0] * 2 + 0.3, 50);
            } else {
                translate([0, -7, 6]) rotate([-90, 0, 0]) pushfit_rod(bushing_xy[0] * 2 + 0.3, 50);
                translate([0, -7, xaxis_rod_distance+6]) rotate([-90, 0, 0]) pushfit_rod(bushing_xy[0] * 2 + 0.3, 50);
            }
        }
        
        if(leadscrew == false){
            //threaded rod
            translate([0, 17, 0]) %cylinder(h = 70, r=2.5+0.2);
            
            translate([0, 0, 5 - bushing_xy[0]]) {  // m5 nut insert
                translate([0, 17, 0]) rotate([0, 0, 10]){
                    //rod
                    translate([0, 0, -2]) cylinder(h=(4.1 + nut_trap_height), r=3, $fn=32);
                    //nut
                    translate([0, 0, nut_trap_height-m5_nut_height]) rotate([0,0,-10]) cylinder(r1=m5_nut_diameter_horizontal/2+.1, r2=m5_nut_diameter_horizontal/2+.1+.4, h=m5_nut_height+.1, $fn=6);
                
                    //spring under nut
                    translate([0, 0, -2]) rotate([0,0,-10]) difference(){
                        cylinder(r1=m5_nut_diameter_horizontal/2+.2, r2=m5_nut_diameter_horizontal/2+.2, h=nut_trap_height, $fn=6);
                        translate([0,5+2.8,nut_trap_height-m5_nut_height]) cube([10,10,2], center=true);
                        translate([0,-5-2.8,nut_trap_height-m5_nut_height]) cube([10,10,2], center=true);
                        translate([5+2.8,0,nut_trap_height-m5_nut_height+.25]) cube([10,10,2-.5], center=true);
                        translate([-5-2.8,0,nut_trap_height-m5_nut_height+.25]) cube([10,10,2-.5], center=true);
                    }

                }
            }
        }else{
            leadscrew_rad = 8/2+.2;
            leadscrew_flange_rad = 22/2+.2;
            leadscrew_flange_h = 4;
            leadscrew_nut_rad = 10.3/2+.2;
            leadscrew_nut_h = 14;
            leadscrew_screw_ring_rad = 16/2;
            leadscrew_screw_rad = 3.55/2;
            leadscrew_num_screws = 4;
            m3_nut_rad = 3.125;
            
            //hardware
            translate([0, 17, -.2]) {
                //leadscrew
                cylinder(h = 70, r=leadscrew_rad);
             
                //nut
                %cylinder(r=leadscrew_flange_rad, h=.2);
                cylinder(r=leadscrew_nut_rad, h=leadscrew_nut_h);
                
                //fasteners
                for(i=[0:360/leadscrew_num_screws:359]) rotate([0,0,i-135]) translate([leadscrew_screw_ring_rad,0,-.5]){
                    cylinder(r=leadscrew_screw_rad, h=leadscrew_nut_h, $fn=18);
                    translate([0,0,leadscrew_flange_h]) rotate([0,0,30])cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=7, $fn=6);
                    translate([0,0,leadscrew_flange_h+7-.05]) rotate([0,0,30])cylinder(r2=0, r1=m3_nut_rad+.5, h=7, $fn=6);
                }
            }
            
            
        }
    }
    
}

module x_end_idler(spring=0, leadscrew = false){
    difference() {
        x_end_base(len=48 + z_delta / 3, offset=-10 - z_delta / 3, spring=spring, leadscrew = leadscrew);
        
        // idler hole
        translate([-20, -15 - z_delta / 2, 30]) {
            rotate([0, 90, 0]) cylinder(r=m3_diameter / 2, h=33, center=true, $fn=small_hole_segments);
            translate([15 - 2.5 * single_wall_width, 0, 0]) rotate([90, 0, 90]) cylinder(r=m3_nut_diameter_horizontal / 2, h=3, $fn=6);

        }
        translate([-6 - x_box_width, 11, 29.5 - (max(idler_width, 16) / 2)]) cube([x_box_width + 1, 12, 1.5 + max(idler_bearing[0], 16)]);
    }
        %translate([-14 - xy_delta / 2, -9, 30.5 - (max(idler_width, 16) / 2)]) x_tensioner();
}

module x_tensioner(len=68, idler_height=max(idler_bearing[0], 16)) {
    idlermount(len=len, rod=m3_diameter / 2 + 0.5, idler_height=idler_height, narrow_len=47, narrow_width=idler_width +1.5 + 2 - single_wall_width);
}

module y_tensioner(len=40, idler_height=max(idler_bearing[0], 16)) {
    idlermount(len=len, horizontal=0, oval_height=(idler_width+1)/2);
}

module pushfit_rod(diameter, length){
    %cylinder(h = length, r=diameter/2, $fn=30);
    intersection(){
        cylinder(h = length, r=diameter/2, $fn=30);
        translate([0, diameter/4, length/2]) cube([diameter , diameter, length], center = true);
    }
    
    translate([0, -diameter/4+layer_height, length/2]) cube_fillet([diameter, diameter/2, length], vertical = [0, 0, 1, 1], center = true, fn=4);

    translate([0, -diameter/2-1.2+layer_height, length/2]) cube([diameter - 1, 1, length], center = true);
}


*if (idler_bearing[3] == 1) {  // bearing guides
    translate([-39,  -60 - idler_bearing[0] / 2, 4 - bushing_xy[0]]) rotate([0, 0, 55]) {
        render() bearing_assy();
    }
}
