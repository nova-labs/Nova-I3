use <pins2.scad>
in = 25.4;
part = 0;

if(part == 0)
    top_shaft();

if(part == 1)
    top_base();

if(part == 2){
    difference(){
        union(){
            pinpeg(r=pin_rad,l=pin_len,d=3,nub=pin_nub,t=pin_thick,space=slop);
            rotate([90,0,0]) cylinder(r1=pin_rad-slop, r2=pin_rad-1, h=30, $fn=36);
            translate([0,-30,0]) sphere(r=pin_rad-1, $fn=80);
            rotate([-90,0,0]) hull(){
                translate([0,0,0]) cylinder(r=pin_rad, h=2);
                translate([0,0,.5]) cylinder(r=pin_rad+2, h=2);
                translate([0,0,8.75]) sphere(r=pin_rad-slop);
            }
        }
        hull(){
            for(i=[-1,1]) translate([0,i*8,0]){
                cylinder(r=1.35, h=10, center=true);
            }
        }
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,pin_rad+25-1.2]) cube([100,100,50], center=true);
    }
    
    %translate([0,-.3,0]) difference(){
        rotate([90,0,0]) top_shaft();
        translate([0,0,50]) cube([100,100,100], center=true);
    }
}
    
if(part == 3)
    laser_template();

if(part == 4)
    printable_arena();

if(part == 5)
    carveable_arena();

if(part == 10)
    assembled();



shaft_rad = 8;
shaft_length = 30;
base_rad = 27;
base_height = 19;

font = "Futura Heavy:style=Regular";


module assembled(){
    difference(){
        union(){
            rotate([180,0,0]) top_base();
            translate([0,0,.98]) rotate([-90,0,0]) top_shaft();
            translate([0,0,.49]) rotate([90,0,0]) pinpeg(r=pin_rad,l=pin_len,d=3,nub=pin_nub,t=pin_thick,space=slop);
            
            //disc for coloring
            %cylinder(r=25.4, h=1);
        }
        translate([0,50,0]) cube([100,100,100], center=true);
    }
}

pin_rad = 3.5;
pin_len = 13;
pin_nub = .4;
pin_thick = 1.9;
pin_pre = .1;

spin_rad = 3;

gap = 0;

slop = .25;

$fn=60;

module laser_template(){
    projection() difference(){
        cylinder(r=in*1.5, h=1, center=true);
        rotate([90,0,0]) hull(){
            pinpeg(r=pin_rad,l=pin_len,d=3,nub=pin_nub,t=pin_thick,space=slop);
        }
    }
}

module gear_text(gear_h = 7){
    gear_outer_rad = 27;
    
    teeth = 13; // n o v a - l a b s . o r g
    
    words = "NOVA-Labs.org";
    
    tooth_rad = 3;
    tooth_stretch = 1.3;
    min_rad = .5;
    font_size = gear_h-1;
    
    difference(){
        union(){
            //make the nova labs gear
            minkowski(){
                difference(){
                    cylinder(r=gear_outer_rad, h=gear_h, $fn=teeth, center=true);
                
                    //cut out the teeth
                    for(i=[0:360/teeth:359]) rotate([0,0,i]) translate([gear_outer_rad, 0, 0]) {
                        scale([tooth_stretch,1,1]) rotate([0,0,30]) cylinder(r=tooth_rad, h=gear_h+1, $fn=6, center=true);
                    }
                }
                sphere(r=min_rad, $fn=8);
            }
        }
            
            //put some text in
            for(i=[0:teeth]) rotate([0,0,180/teeth+i*360/teeth]) translate([gear_outer_rad*cos(180/teeth)+.0, 0, 0]) {
                //minkowski(){
                    rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=1){
                        text(words[i], font = font, halign="center", valign="center", size=font_size);
                    }
                //    sphere(r=min_rad, $fn=8);
                //}
            }
        
    }
}

module top_base(){
    torus_rad = 17;
    gear_h = 7;
    difference(){
        union(){
            translate([0,0,gear_h/2]) rotate([180,0,0]) gear_text(gear_h = gear_h);
            hull(){
                cylinder(r1=base_rad-2, r2=base_rad, h=gear_h);
                translate([0,0,base_height-2]) sphere(r=2, $fn=90);
            }
        }
        
        //torus
        translate([0,0,base_height-2])  scale([1,1,(base_height-gear_h-2.5)/torus_rad]) rotate_extrude(){
            translate([3+torus_rad, 0, 0]) circle(r=torus_rad);
        }
        
        //pin hole
        pinhole(r=pin_rad,l=pin_len,nub=pin_nub,fixed=true,fins=true);
        //flange the pinhole for easy entry
        translate([0,0,-.5-.1]) sphere(r=pin_rad+.5, $fn=6);
    }
}

module top_shaft(){
    torus_rad = 11;
    gear_h = 7;
    rotate([-90,0,0]) difference(){
        union(){
            //pinpeg(r=pin_rad,l=pin_len,d=3,nub=pin_nub,t=pin_thick,space=slop);
            translate([0,-gap/2,0]) rotate([90,0,0]) rotate([0,0,15]) cylinder(r=shaft_rad, h=shaft_length);
            translate([0,-shaft_length-gap/2,0]) sphere(r=spin_rad);
            
            rotate([90,0,0]) translate([0,0,gear_h/2]) rotate([0,0,0]) gear_text(gear_h = gear_h);
        }
        
        //cutout a torus
        translate([0,-shaft_length*.6-gap/2+gear_h/2+2,0]) rotate([90,0,0])  rotate_extrude() hull(){   //scale the torus? scale([1,1,(shaft_length*.6+gap/2)/torus_rad])
            translate([spin_rad+torus_rad, 0, 0]) circle(r=torus_rad);
            translate([spin_rad+torus_rad, shaft_length, 0]) circle(r=torus_rad);
        }
        
        rotate([90,0,0]) pinhole(r=pin_rad,l=pin_len,nub=pin_nub,fixed=true,fins=true);
        rotate([-90,0,0]) pinhole(r=pin_rad,l=pin_len,nub=pin_nub,fixed=true,fins=true);
        
        //flange the pinhole for easy entry
        hull(){
            translate([0,-.5,0])rotate([-90,0,0]) pinhole(r=pin_rad,l=pin_len,nub=pin_nub,fixed=true,fins=true);
            translate([0,1,0]) rotate([-90,0,0]) pinhole(r=pin_rad+2,l=pin_len,nub=pin_nub,fixed=true,fins=true);
            
        }
        
        //bore through for the shaft
        //rotate([90,0,0]) cylinder(r=pin_rad, h=100, center=true);
        
        //cut off the top
        rotate([90,0,0]) translate([0,0,gear_h]) cylinder(r=pin_rad*2, h=100);
        
        //for(i=[0,1]) mirror([0,0,i]) translate([0,0,50+pin_rad-.75]) cube([100,100,100], center=true); 
        
        //cut in half to view how the hole looks
        //translate([0,0,50]) cube([100,100,100], center=true);
    }
}


module printable_arena() {
    
    x = 225;
    y = 175;
    z = 15;
    
    wall = 5;
    %cube([300,300,.1], center=true); 
    difference(){
        union(){
            hull() for(i=[0,1]) mirror([i,0,0]) translate([x-y,0,0]) 
                cylinder(r=y/2, h=z);
        }
        
        hull() {
            for(i=[0,1]) mirror([i,0,0]) translate([x-y,0,z+wall]) 
                intersection(){
                    scale([(y/2)/(z),(y/2)/(z),1]) sphere(r=z);
                    cylinder(r=y/2-wall/2, h=50, center=true);
                }
            //center dip
            translate([0,0,z+wall]) sphere(r=z+1);
        }
        
        //cutoff the base
        cube([300,300,wall], center=true);
    }
}

module carveable_arena() {
    x = 20*in;
    y = 16*in;
    z = .75*in;
    
    extra_top = 2.5*in;
    
    wall = .25*in;
    
    difference(){
        union(){
            hull() {
                for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) translate([x-y,extra_top*j,0]) 
                    cylinder(r=y/2, h=z);
            }
        }
        
        hull() {
            for(i=[0,1]) mirror([i,0,0]) translate([x-y,0,z+wall]) 
                intersection(){
                    scale([(y/2)/(z),(y/2)/(z),1]) sphere(r=z);
                    cylinder(r=y/2-wall/2, h=50, center=true);
                }
            //center dip
            translate([0,0,z+wall]) sphere(r=z+1);
        }
    }
}