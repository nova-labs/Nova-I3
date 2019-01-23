

hot_rad = 30/2/cos(30);
hotend_x=25;
fan_x = 15+5;

hotend_y=-5;

thickness = 10;
wall=2;
slop=.2;

fan_hole = (40-wall-wall)/2;
mount_drop = 10;
fan_z = fan_hole+wall;

//fan_mount();
bowden_fan();

%cylinder(r=hot_rad, h=20, center=true);
%translate([-23,0,0]) cylinder(r=hot_rad, h=20, center=true);

m3_cap_rad = 4;
m3_rad = 2;
m3_nut_rad = 6.01/2+.1;

facets = 6;

duct_angle=-5;
duct_jut = -5;

module bowden_fan(){
    duct_w = 15+slop;
    duct_h = 20+slop;
    duct_offset=38;
    
    mount_height = 46;
    
    offset = -20;
    difference(){
        union(){
            //core
            hull(){
                cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
                translate([offset,0,0]) cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
            }
            
            //connection to duct
            hull(){
                intersection(){
                    cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
                    translate([hot_rad+wall*2,0,0]) cube([1,200,200], center=true);
                }
                translate([duct_offset,duct_jut,duct_h/2+wall]) rotate([0,0,duct_angle]) cube([1,duct_w+wall*2, duct_h+wall*2], center=true);
            }
            
            //the duct connector
            translate([duct_offset,duct_jut,0]) rotate([0,0,duct_angle]) duct();
            
            //mounting lugs
           for(i=[10,-20,-40]) difference(){
                translate([i,hot_rad+wall*2,0]) hull(){
                    translate([5,0,thickness]) rotate([90,0,0]) cylinder(r=m3_cap_rad+wall*2, h=wall, center=true);
                    translate([0,0,mount_height]) rotate([90,0,0]) cylinder(r=m3_cap_rad+wall, h=wall, center=true);
                }
                
                //mounting holes up top
                translate([i,hot_rad+wall*2,mount_height]) rotate([90,0,0]) cylinder(r=m3_rad+slop, h=20, center=true);
            }
        }
        
        //connection to duct airflow
        hull(){
            intersection(){
                translate([0,0,wall]) cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2, h=thickness-wall, $fn=facets);
                translate([hot_rad+wall*3,0,0]) cube([1,200,200], center=true);
            }
            translate([duct_offset,duct_jut,duct_h/2+wall]) rotate([0,0,duct_angle]) cube([1.2,duct_w, duct_h], center=true);
        }
        
        //center cutout
        translate([0,0,-.5]) hull(){
            cylinder(r1=hot_rad+wall, r2=hot_rad+wall*3, h=thickness+wall+1, $fn=facets);
            translate([2*offset,0,0]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall*3, h=thickness+wall+1, $fn=facets);
        }
        
        //air path
        difference(){
            //core
            translate([0,0,-.1]) hull(){
                cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                translate([offset+wall,0,0]) cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
            }
            
            //keep the center walls in place
            translate([0,0,-.5]) hull(){
                cylinder(r1=hot_rad+wall*2, r2=hot_rad+wall*4, h=thickness+wall+1, $fn=facets);
                translate([2*offset,0,0]) cylinder(r1=hot_rad+wall*2, r2=hot_rad+wall*4, h=thickness+wall+1, $fn=facets);
            }
            
            //bottom on the near side
            translate([10,0,-.5]) cylinder(r1=hot_rad+wall*2, r2=hot_rad+wall*2.5, h=wall+.5, $fn=facets);
        }
    }
}

module duct(){
    duct_w = 15+slop;
    duct_h = 20+slop;
    rad = 20;
    
    translate([0,0,rad+wall+duct_h/2]) rotate([-90,0,0]) union(){
        intersection(){
            rotate_extrude(angle = 90, convexity = 2){
                translate([rad,0,0])
                difference(){
                    square([duct_h+wall*2, duct_w+wall*2], center=true);
                    square([duct_h, duct_w], center=true);
                }
            }
            translate([0,0,-100]) cube([200,200,200]);
        }
        
        translate([rad,0,0]) rotate([90,0,0]) translate([0,0,8]) difference(){
            hull(){
                translate([0,0,-8]) cube([duct_h+wall*2,duct_w+wall*2,.1], center=true);
                #translate([duct_h/2+wall/2,0,8]) cube([wall,duct_w+wall*2,.1], center=true);
            }
            
            //hollow center
            cube([duct_h,duct_w,16.3], center=true);
            
            //slot for the clip
            translate([wall+1,0,(12-16)/2]) cube([duct_h+wall*2,2,12], center=true);
        }
        
    }
    
}

