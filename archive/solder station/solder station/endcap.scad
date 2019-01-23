/*
 * This is a simple dual-iron solder station.
 * 
 * It has a regular outlet recess in the middle, and two swtches
 * to control the indivifual irons.  The middle outlet is intended to
 * house a timer, to have the irons auto-shutdown. 
 */

include <../configuration.scad>
include <../functions.scad>
use <../connectors.scad>

//frame vars
frame_x = 400;
frame_y = 200;
box_x = 120;
box_y = 120;
box_z = 50;

foot_x = 125;
foot_y = frame_y-40;
foot_offset = 50;

outlet_x = 44;
outlet_y = 70;
outlet_screw_rad = 2;
outlet_screw_sep = 83.3;

switch_x = 12.5;
switch_y = 18.5;

//soldering iron vars
iron_rad = m5_rad;
iron_nut_rad = 9/2;
floss_rad = 68/2;
cord_rad = 3;

//render everything
part=4;

//parts for laser cutting
if(part == 0)
    base_plate_projected();
if(part == 1)
    foot_plate_projected();
if(part == 2)
    side_plate_projected();
if(part == 3)
    front_plate_projected();
if(part == 4)
    top_plate_projected();

//view the assembly
if(part == 10){
    assembled_endcap();
}

//assemble
module assembled_endcap(){
    base_plate_connected();
    foot_plate_connected();
    side_plates_connected();
    top_plate_connected();
    front_plate_connected();
}

/************* Layout Section ***************
 * The plate files don't have cutouts for their intersections
 * with other plates - those are added here, in the layout.
 */
module base_plate_projected(){
    projection(){
        base_plate_connected();
    }
}

module foot_plate_projected(){
    projection(){
        foot_plate();
    }
}

module side_plate_projected(){
    projection(){
        rotate([0,-90,0]) side_plate();
    }
}

module top_plate_projected(){
    projection(){
        top_plate_connected();
    }
}

module front_plate_projected(){
    projection(){
        rotate([-90,0,0]) front_plate();
    }
}

module base_plate_connected(){
    difference(){
        //the bottom.  Stuff mounts to this guy.
        base_plate();     
            
        //holes for the box sides
        translate([-box_x/2+mdf_wall/2,frame_y/2-box_y/2,box_z/2+mdf_wall/2]) rotate([0,90,0]) side_plate_connectors(gender=FEMALE);
        mirror([1,0,0]) translate([-box_x/2+mdf_wall/2,frame_y/2-box_y/2,box_z/2+mdf_wall/2]) rotate([0,90,0]) side_plate_connectors(gender=FEMALE);
        
        //holes for the front and back
        translate([0,frame_y/2-mdf_wall/2,box_z/2+mdf_wall/2]) rotate([90,0,0]) front_plate_connectors(gender=FEMALE);
        translate([0,frame_y/2+mdf_wall/2-box_y,box_z/2+mdf_wall/2]) rotate([90,0,0]) front_plate_connectors(gender=FEMALE);
    }
}

//there aren't any connectors sticking out
module base_plate_connectors(gender=MALE, solid=1){
}

module top_plate_connected(){
    difference(){
        //the top.
        top_plate();     
            
        //holes for the box sides
        translate([-box_x/2+mdf_wall/2,frame_y/2-box_y/2,box_z/2+mdf_wall/2]) rotate([0,90,0]) side_plate_connectors(gender=FEMALE);
        mirror([1,0,0]) translate([-box_x/2+mdf_wall/2,frame_y/2-box_y/2,box_z/2+mdf_wall/2]) rotate([0,90,0]) side_plate_connectors(gender=FEMALE);
        
        //holes for the front and back
        translate([0,frame_y/2-mdf_wall/2,box_z/2+mdf_wall/2]) rotate([90,0,0]) front_plate_connectors(gender=FEMALE);
        translate([0,frame_y/2+mdf_wall/2-box_y,box_z/2+mdf_wall/2]) rotate([90,0,0]) front_plate_connectors(gender=FEMALE);
    }
}

module top_plate(){
    translate([0,frame_y/2-box_y/2,box_z+mdf_wall])
    difference(){
        union(){
            //the plate
            cube([box_x, box_y, mdf_wall], center=true);
        }
        
        //outlet cutout
        cube([outlet_x, outlet_y, mdf_wall*2], center=true);
        //screws
        for(i=[0,1]) mirror([0,i,0]) translate([0,outlet_screw_sep/2,0])
            cylinder(r=outlet_screw_rad, h=mdf_wall*2, center=true, $fn=36);
        
        //switch cutouts
        for(i=[0,1]) mirror([i,0,0]) translate([-outlet_x,-outlet_y/2+switch_y/2,0])
            cube([switch_x, switch_y, mdf_wall*2], center=true);
    }
}

module side_plate_connectors(gender=MALE, solid=1){
    translate([box_z/2,0,0]) rotate([0,0,90]) if(gender == MALE){
        pinconnector_male(solid=solid, mdf_tab=30);
    }else{
        pinconnector_female(mdf_tab=30);
    }
    
    mirror([1,0,0]) translate([box_z/2,0,0]) rotate([0,0,90]) if(gender == MALE){
        pinconnector_male(solid=solid, mdf_tab=25);
    }else{
        pinconnector_female(mdf_tab=25);
    }
}

module side_plates_connected(){
    side_plate();
    mirror([1,0,0]) side_plate();
}

module side_plate(){
    translate([-box_x/2+mdf_wall/2,frame_y/2-box_y/2,box_z/2+mdf_wall/2]) rotate([0,90,0])  
    difference(){
        union(){
            //the plate
            cube([box_z, box_y-mdf_wall*2, mdf_wall], center=true);
   
            //connectors around the edge
            side_plate_connectors(solid=1);
        }
        //connectors around the edge
        side_plate_connectors(solid=-1);
    }
}

module front_plate_connectors(gender=MALE, solid=1){
    for(j=[0,1]) mirror([0,j,0])
        //for(i=[0,1]) mirror([i,0,0]) translate([box_y/4,0,0]) 
            translate([0,-box_z/2,0]) rotate([0,0,0])
                if(gender == MALE){
                    pinconnector_male(solid=solid, mdf_tab=25);
                }else{
                    pinconnector_female(mdf_tab=25);
                }
}

module front_plate_connected(){
    front_plate();
    translate([0,mdf_wall-box_y,0]) front_plate();
}

module front_plate(){
    translate([0,frame_y/2-mdf_wall/2,box_z/2+mdf_wall/2]) rotate([90,0,0])  
    difference(){
        union(){
            //the plate
            cube([box_x, box_z, mdf_wall], center=true);
   
            //connectors around the edge
            front_plate_connectors(solid=1);
        }
        
        //holes for the wire along the bottom
        for(i=[0,1]) mirror([i,0,0]) translate([box_x*4/10,-box_z/2,0]) hull(){
            translate([0,cord_rad/2,0]) cylinder(r=cord_rad, h=mdf_wall*3, center=true);
            translate([0,-10,0]) cylinder(r=cord_rad, h=mdf_wall*3, center=true);
        }
        
        //connectors around the edge
        front_plate_connectors(solid=-1);
    }
}

module base_plate(){
    difference(){
        union(){
            //the plate
            cube([frame_x, frame_y, mdf_wall], center=true);
   
            //connectors around the edge
            base_plate_connectors(solid=1);
        }
        //connectors around the edge
        base_plate_connectors(solid=-1);
        
        //mounting holes for the irons
        iron_holes();
        
        //holes for the brass wool floss
        floss_holes();
    }
}

//this just copies the plate, for display
module foot_plate_connected(){
    foot_plate();
    mirror([1,0,0]) foot_plate();
}

module foot_plate(){
    translate([0,0,-mdf_wall]) 
    difference(){
        union(){
            //the plate
            translate([-foot_offset,0,0]) cube([foot_x, foot_y, mdf_wall], center=true);
        }
        
        //mounting holes for the irons
        iron_holes(hex=true);
    }
}

module iron_holes(hex=false){
    for(i=[0,1]) mirror([i,0,0]) translate([box_x/2+30,frame_y/2-30,0]){
       if(hex==false){
           cylinder(r=iron_rad, h=mdf_wall*3, center=true);
       }
       if(hex==true){
           cylinder(r=iron_nut_rad, h=mdf_wall*3, $fn=6, center=true);
       }
    }
}

module floss_holes(){
    for(i=[0,1]) mirror([i,0,0]) translate([box_x/2+30+60,frame_y/2-floss_rad*3,0]) cylinder(r=floss_rad, h=mdf_wall*3, center=true);
}