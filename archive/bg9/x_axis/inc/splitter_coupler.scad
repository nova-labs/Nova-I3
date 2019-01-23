slop=.2;

height = 40;

outer_rad = 47/2;
tooth_outer_rad = 38/2+slop;
tooth_inner_rad = 32/2+slop;

num_teeth = 12;

screw_rad = 3/2+slop;
screw_cap_rad = 6/2+slop;
screw_cap_height = 1.7+slop;
nut_rad = 7/2+slop; //using square nuts
nut_height = 2+slop;

num_screws = num_teeth/4;

gap = 1;

tooth_width = 4.8+slop;
tooth_angle = 18;

coupler(0);


$fn=90;

module coupler(screws = 1){
    difference(){
        union(){
            cylinder(r=outer_rad, h=height);
        }
        
        //hollow center
        rotate([0,0,90/num_teeth]) translate([0,0,-.1]) cylinder(r=tooth_inner_rad, h=height+1, $fn=num_teeth*2);
        
        difference(){
            translate([0,0,-.1]) cylinder(r=tooth_outer_rad, h=height+1);
            
            //center divider
            translate([0,0,height/2]) cylinder(r=outer_rad+1, h=gap, $fn=num_teeth, center=true);
            
            //teeth
            for(i=[0:360/num_teeth:359]) rotate([0,0,i]) tooth();
        }
        
        //several screw stiffeners
        if(screws == 1){
            for(i=[0:360/num_screws:359]) rotate([0,0,i]) translate([outer_rad-screw_rad*2,0,-.1]) screwhole();
        }
    }
}

module tooth(){
    intersection(){
        translate([-tooth_width/2,-tooth_outer_rad,-.1]) cube([tooth_width, tooth_outer_rad, height+1]);
        translate([-tooth_width/2,-tooth_outer_rad,-.1]) rotate([0,0,-tooth_angle]) cube([tooth_width, tooth_outer_rad, height+1]);
        translate([tooth_width/2,-tooth_outer_rad,-.1]) rotate([0,0,tooth_angle]) mirror([i,0,0]) cube([tooth_width, tooth_outer_rad, height+1]);
    }
}

module screwhole(){
    union(){
        cylinder(r1=screw_cap_rad, r2=screw_rad, h=screw_cap_height);
        cylinder(r=screw_rad, h=height+1);
        translate([0,0,height-nut_height-.1]) cylinder(r1=nut_rad, r2=nut_rad+slop, h=nut_height+1, $fn=4);
    }
}