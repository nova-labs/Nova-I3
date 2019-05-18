in = 25.4;
hole_rad = 75/2;
hole_height = 20;

noodle_hole();


%cylinder(r=hole_rad,h=50, center=true);


$fn = 90;
module noodle_hole(){
    difference(){
        union(){
            rotate_extrude(){
                translate([hole_rad+hole_height/4,0,0]) scale([1,2.125,2]) circle(r=hole_height/4);
            }
            
            rotate([90,0,0]) translate([hole_rad+hole_height/4,0,0]) scale([1,2.125,2]) cylinder(r=hole_height/4, h=hole_rad, center=true);
            
            for(i=[0,1]) mirror([0,i,0]) translate([hole_rad+hole_height/4,hole_rad,0]) scale([1,1,2.125]) sphere(r=hole_height/4);
        }
        
        //flatten ttop and bottom
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,hole_height/2+100]) cube([200,200,200], center=true);
            
        //zip tie slot
        for(i=[0,1]) mirror([0,i,0]) translate([hole_rad+hole_height/4,hole_rad-5,0]) scale([1,1,2.75]) rotate([90,0,0]) rotate_extrude(){
            translate([5.75,0,0]) scale([1,1.5,1]) rotate([0,0,30]) circle(r=2, $fn=6);
        }
        
        //flatten the end
        rotate([90,0,0]) translate([hole_rad+hole_height/4+hole_height/2+1.75,0,0]) {
            scale([1,2.125,2]) cube([hole_height, hole_height,hole_rad*2], center=true);
            translate([1,0,0]) cylinder(r=in/2, h=hole_rad*3, center=true);
        }
    }
}