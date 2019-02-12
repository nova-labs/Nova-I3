use <pins2.scad>
part = 10;

if(part == 0)
    top_shaft();

if(part == 1)
    top_base();

if(part == 10)
    assembled();



shaft_rad = 4;
shaft_length = 30;
base_rad = 13;
base_height = 17;


module assembled(){
    difference(){
        union(){
            rotate([180,0,0]) top_base();
            rotate([-90,0,0]) top_shaft();
        }
        translate([0,50,0]) cube([100,100,100], center=true);
    }
}

pin_rad = 3.5;
pin_len = 13;
pin_nub = .25;
pin_thick = 1.9;
pin_pre = .1;

slop = .25;

module top_base(){
    difference(){
        hull(){
            cylinder(r1=base_rad-2, r2=base_rad, h=base_height/4);
            translate([0,0,base_height-2]) sphere(r=2, $fn=90);
        }
        
        //pin hole
        pinhole(r=pin_rad,l=pin_len,nub=pin_nub,fixed=true,fins=true);
    }
}

module top_shaft(){
    difference(){
        union(){
            pinpeg(r=pin_rad,l=pin_len,d=3,nub=pin_nub,t=pin_thick,space=slop);
            translate([0,-3,0]) rotate([90,0,0]) rotate([0,0,15]) cylinder(r=pin_rad, h=shaft_length, $fn=12);
            translate([0,-shaft_length-3,0]) sphere(r=pin_rad, $fn=12);
        }
        hull(){
            cylinder(r=1.4, h=19, center=true, $fn=12);
            translate([0,-pin_len/2,0]) cylinder(r=1.4, h=19, center=true, $fn=12);
        }
        
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,50+pin_rad-.75]) cube([100,100,100], center=true); 
    }
}