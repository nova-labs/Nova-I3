

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

module fan_mount(){
    difference(){
        union(){
            //core
            cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
            
            hull(){
                intersection(){
                    difference(){
                        cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
                        translate([0,0,-.5]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall+wall, h=thickness+wall+1, $fn=facets);
                    }
                    translate([50+hot_rad-6.7,50,50]) cube([100,100,100], center=true);
                }
                translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole+wall, h=5);
            }
            
            hull(){
                intersection(){
                    difference(){
                        cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
                        translate([0,0,-.5]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall+wall, h=thickness+wall+1, $fn=facets);
                    }
                    translate([50+hot_rad-6.7,-50,50]) cube([100,100,100], center=true);
                }
                translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole+wall, h=5);
            }
            
            //fan mount
            translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]){
                hull() for(i=[0:90:359]) rotate([0,0,i]) {
                    #translate([20-wall,20-wall,-wall]) cylinder(r=wall,h=wall*2, $fn=16);
                }    
            }
            
            //mounting lugs above fan
            translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]){
                for(i=[-16, 16]) difference(){
                    hull(){
                        translate([-16-mount_drop,i,-fan_x+3]) cylinder(r=m3_rad+wall, h=wall*2, $fn=16);
                        translate([0,i,-fan_x+3]) cylinder(r=m3_cap_rad*2, h=wall);
                    }
                    translate([-16-mount_drop,i,-fan_x+3-.1]) cylinder(r=m3_rad, h=wall*2+1, $fn=16);
                }
            }
        }
        
        //center cutout
        translate([0,0,-.5]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall+wall, h=thickness+wall+1, $fn=facets);
                
        //front cutout
        translate([-(hot_rad+thickness*2+wall),0,0]) cylinder(r=hot_rad+thickness*2+wall, h=thickness+wall*10, center=true, $fn=facets);
        
        //fan holes
        translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]){
            for(i=[-16, 16]) for(j=[-16, 16]) {
                #translate([j,i,-.1]) cylinder(r=m3_rad, h=wall+.2, $fn=16);
                translate([j,i,-wall*2-.1]) cylinder(r2=m3_nut_rad, r1=m3_nut_rad+.25, h=wall*2+.2, $fn=6);
            }
        }
        
        //air path
        translate([0,0,-.1]) difference(){
            union(){
                translate([-wall,0,0]) cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                
                hull(){
                    intersection(){
                        difference(){
                            translate([-wall,0,0]) cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                            translate([0,0,-.5]) cylinder(r1=hot_rad+wall*2, r2=hot_rad+wall*3, h=thickness+wall+1, $fn=facets);
                        }
                        translate([50+hot_rad-6.7,50,50]) cube([100,100,100], center=true);
                    }
                    translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=.3);
                }
                
                hull(){
                    intersection(){
                        difference(){
                            translate([-wall,0,0]) cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                            translate([0,0,-.5]) cylinder(r1=hot_rad+wall+wall, r2=hot_rad+wall+wall+wall, h=thickness+wall+1, $fn=facets);
                        }
                        translate([50+hot_rad-6.7,-50,50]) cube([100,100,100], center=true);
                    }
                    translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=.3);
                }
                
                translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=wall+1+5);
            }
            cylinder(r1=hot_rad+wall+wall, r2=hot_rad+wall+wall+wall, h=thickness+wall, $fn=facets);
            translate([-(hot_rad+thickness*2),0,0]) cylinder(r=hot_rad+thickness*2+wall, h=thickness+wall*10, center=true, $fn=facets);
            translate([0,-5+hotend_y/2,0])cube([100,10,wall]);
        }
    }
}

duct_angle=-5;
duct_jut = -5;

module bowden_fan(){
    duct_w = 15+slop;
    duct_h = 20+slop;
    duct_offset=40;
    
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
            for(i=[0,-30,-50]) difference(){
                translate([i,hot_rad+wall*2,0]) hull(){
                    translate([16,0,thickness]) rotate([90,0,0]) cylinder(r=m3_cap_rad+wall*2, h=wall, center=true);
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

