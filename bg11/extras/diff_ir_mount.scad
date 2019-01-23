slop = .2;
wall = 3;

m3_nut_rad = 6.01/2+slop;
m3_nut_height = 2.4;
m3_rad = 3/2+slop*2;
m3_cap_rad = 3.25;
m3_wash_rad = 8.5/2;

m4_nut_rad = 7.66/2+slop;
m4_nut_height = 3.2;
m4_rad = 4/2+slop;
m4_cap_rad = 7/2+slop;

m5_nut_rad = 8.79/2;
m5_nut_height = 4.7;
m5_rad = 5/2+slop;
m5_cap_rad = 8/2+slop;

//english sizes - 6-32 - for graber i3 clamp
632_dia = 3.5;
632_rad = 632_dia/2+slop;
bolt_rad = 632_rad;

screw_mount_screw_sep = 25;
screw_mount_rad = 632_rad+wall+2;

screw_mount_screw_rad = m3_rad;

hotend_rad  = 23;
fan_screw_sep = 24;
thin_wall = 2;

rotate([90,0,0]) diffir_drop_mount();
//groovemount_fan_ir_clamp();

$fs = 1;

%translate([0,0,-20]) cylinder(r=5, h=40, center=true);

module diffir_drop_mount(adjust_height = 29, mount_drop = 39){
    difference(){
        hull(){
            translate([0,wall/2,0]) cube([wall*2+m3_wash_rad*2, wall*4, adjust_height], center=true);
            
            translate([0,-wall/2,-mount_drop]) rotate([90,0,0]) diff_ir_mount(solid=1);
        }
        
        //cutout for the sensor mount
        translate([wall+50,wall*2+50,0]) cube([wall*2+m3_wash_rad+100, wall*3+100, adjust_height+100], center=true);
        
        //screw adjust slot
        translate([wall/2,-wall/2,0]) {
             hull() for(i=[0,1]) mirror([0,0,i]) translate([0,0,(adjust_height-wall*2-m3_wash_rad)/2]) {
                rotate([90,0,0]) cylinder(r=m3_wash_rad, h=10);
            }
            
            hull() for(i=[0,1]) mirror([0,0,i]) translate([0,0,(adjust_height-wall*2-m3_wash_rad)/2]) {
                translate([0,10.2,0]) rotate([90,0,0]) cylinder(r=m3_rad+slop, h=10);
            }
        }
        
        //sensor mount
        translate([0,-wall/2,-mount_drop]) rotate([90,0,0]) diff_ir_mount(solid=0, adjust=0);
    }
}

module groovemount_fan_ir_clamp(){
    difference(){
        union(){
            //mount the hotend
            groovemount_screw_clamp(back_wall = 9+5, solid=1);
            
            echo(fan_screw_sep+4+m3_rad*2);
            
            //mount the fan
            translate([0,-fan_screw_sep/2-m3_rad+.1+2,0])
            fan_mount(solid=1, inset = 9+5);
            
            //mount the sensor
            translate([0,-fan_screw_sep-m3_rad*2+1,0])
            diff_ir_mount(solid=1);
        }
        
        //mount the hotend
        groovemount_screw_clamp(back_wall = 9+5, solid=0);
            
        echo(fan_screw_sep+4+m3_rad*2);
            
        //mount the fan
        translate([0,-fan_screw_sep/2-m3_rad+.1+2,0])
        fan_mount(solid=0, inset = 9+5);
            
        //mount the sensor
        translate([0,-fan_screw_sep-m3_rad*2+1,0])
        diff_ir_mount(solid=0);
    }
}

module diff_ir_mount(solid=1, adjust=5){
    sensor_lift = 0;    //get it away from the hotend a little
    
    board_width = 24.25;
    board_sides = 6;
    board_inset = 12;
    
    hole_drop = -3;
    screw_sep = 19;
    
    mount_len = board_width+wall;
    
    thick = sensor_lift+wall;
    
    if(solid == 1){
        translate([0,-board_inset/2,thick/2]) cube([mount_len, board_inset, thick], center=true);
    }else{
        translate([0,-board_inset/3-.5,thick*1.5-wall*1]) cube([board_width/2, board_inset*.666, thick*3], center=true);
        
        for(i=[0,1]) mirror([i,0,0]) translate([screw_sep/2,hole_drop,0]) hull(){
            cylinder(r=m3_rad, h=20, center=true);
            translate([0,-adjust,0]) cylinder(r=m3_rad, h=20, center=true);
        }
        
        for(i=[0,1]) mirror([i,0,0]) translate([screw_sep/2,hole_drop,-20+.5]) hull(){
            rotate([0,0,30]) cylinder(r2=m3_nut_rad, r1=m3_nut_rad+.5, h=20, $fn=6);
            translate([0,-adjust,0]) rotate([0,0,30]) cylinder(r2=m3_nut_rad, r1=m3_nut_rad+.5, h=20, $fn=6);
        }
    }
}

module fan_mount(solid=1, inset = 9){
    if(solid == 1) difference(){
        union() {
                //body
                hull() for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([fan_screw_sep/2, fan_screw_sep/2, 0])
                cylinder(r=m3_rad+2, h=wall);
                
                //air guide
                hull(){
                    for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([fan_screw_sep/2, fan_screw_sep/2, 0])
                cylinder(r=m3_rad+2, h=wall);
                    
                    translate([0,0,8+inset]) rotate([90,0,0]) cylinder(r=hotend_rad/2+wall/2, h=fan_screw_sep, center=true);
                }
            }
            
            //fan airhole
            translate([0,0,-.1]) cylinder(r1=30.1/2, r2=25/2, h=15);
            
            //screwholes
            for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([fan_screw_sep/2, fan_screw_sep/2, 0]) {
                cylinder(r=m3_rad-slop, h=100, center=true);
                hull(){
                    translate([0,0,wall+2]) cylinder(r=m3_nut_rad, h=100, $fn=6);
                    translate([5,0,wall+2]) cylinder(r=m3_nut_rad+.25, h=100, $fn=6);
                }
            }
            
            //around the hotend
            hull() {
                translate([0,0,8+inset]) rotate([90,0,0]) cylinder(r=hotend_rad/2+.25, h=fan_screw_sep*2, center=true);
                translate([0,0,23+inset]) rotate([90,0,0]) cylinder(r=hotend_rad/2+1, h=fan_screw_sep*2, center=true);
            }
            
            //flatten the back
            translate([0,0,-100]) cube([200,200,200], center=true);
           
           //flatten the front
           translate([0,0,100+8+inset]) cube([200,200,200], center=true);  
    }else{
        //reiterate the screw holes
        //screwholes
            for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([fan_screw_sep/2, fan_screw_sep/2, 0]) {
                cylinder(r=m3_rad-slop, h=100, center=true);
                hull(){
                    translate([0,0,wall+2]) cylinder(r=m3_nut_rad, h=100, $fn=6);
                    translate([5,0,wall+2]) cylinder(r=m3_nut_rad+.25, h=100, $fn=6);
                }
            }
    }
}

module groovemount_screw_clamp(back_wall = 1, solid=1){
    groove_lift = back_wall;
    
    dia = 16;
    rad = dia/2+slop;
    mink = 1;
    inset = 3;
    groove = 9+2;
    thick = wall*2+groove_lift;
    length = 10;
    
    
    if(solid == 1){
        hull(){
            //screwhole mounts
            for(i=[0,1]) mirror([i,0,0]){
                translate([screw_mount_screw_sep/2-screw_mount_rad,7,0]) cylinder(r=screw_mount_rad, h=thick);
                translate([screw_mount_screw_sep/2,7,screw_mount_rad]) cylinder(r=screw_mount_rad, h=thick-screw_mount_rad);
            }
        }
    }else{    
        //screwholes
        for(i=[0,1]) mirror([i,0,0]) translate([screw_mount_screw_sep/2,7,-1]){     translate([0,0,groove_lift+.2]) cylinder(r=m3_rad+slop, h=wall*10);
           cylinder(r=m3_rad+2, h=groove_lift);
        }
        
       //hotend inset
       render() translate([0,3,rad+groove_lift]) rotate([-90,0,0]) {           
           //top part
           translate([0,0,-inset-2]) hull(){
               cap_cylinder(r=4+slop, h=wall);
               translate([0,-3,0]) cap_cylinder(r=4+slop, h=wall);
           }
           
           //the groove
           translate([0,0,-inset]) hull(){
               cap_cylinder(r=12/2+slop*3, h=13, $fn=90);
               translate([0,-3,0]) cap_cylinder(r=12/2+slop*3, h=13, $fn=90);
           }
           
           translate([0,0,-inset]) difference(){
               cap_cylinder(r=rad, h=4+groove+.2, $fn=90);
               translate([0,0,4.25]) cylinder(r=rad+1, h=6-slop*3);
           }
       }
    }
}

module cap_cylinder(r=1, h=1, center=false, point = 0){
	render() union() {
		cylinder(r=r, h=h, center=center);
		if(point==0){
			intersection(){
				rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
				translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
			}
		}else{
			intersection(){
				rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
				translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
			}
		}
	}
}