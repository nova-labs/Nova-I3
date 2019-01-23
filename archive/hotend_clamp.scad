include <configuration.scad>

slop = .2;

translate([0,-40,0]) 
hotend_clamp();

hotend_clamp_dual();

translate([0,40,0])
hotend_groovemount_dual();

$fn=90;

inner_holes = 48;
outer_holes = 58;
hotend_height=3.5;	//this must be less than the thickness of the wide, top band of the hotend.
hotend_rad = 16/2+slop;
wall=3;
thickness = hotend_height+wall;
groovemount_thickness = 5.5;	 //thickness of the skinny part of the groove.  I measured my e3d v6 for everything.
groovemount_rad = 12/2+slop;
screw_rad = 2+slop;
pushfit_rad = 6;

hotend_sep = 23;

module hotend_clamp(){
	inner_holes = 35;
	outer_holes = 58;

	big_rad = 360;

	difference(){
		intersection(){
			union(){
				hull(){
					for(i=[-outer_holes/2, outer_holes/2]) translate([i,0,0]) cylinder(r=hotend_rad, h=thickness);
				}

				cylinder(r=hotend_rad+wall, h=hotend_height+wall);
			}
		
			translate([0,0,thickness-big_rad]) rotate([90,0,0]) cylinder(r=big_rad, h=50, center=true, $fn=360);
		}

		//hotend hole
		#translate([0,0,thickness-hotend_height]) cylinder(r=hotend_rad, h=hotend_height+.01);

		//screw slots
		for(i=[-1,1]) hull(){ for(j=[i*outer_holes/2, i*inner_holes/2]) {
				translate([j,0,0]) cylinder(r=screw_rad, h=50, center=true);
			}
		}

		//pushfit hole
		cylinder(r=pushfit_rad, h=50, center=true);
	}
}

module hotend_clamp_dual(){
	difference(){
		union(){
			hull(){
				for(i=[-outer_holes/2, outer_holes/2]) translate([i,0,0]) cylinder(r=hotend_rad, h=thickness);
			}

			for(i=[-hotend_sep/2, hotend_sep/2])
				translate([i,0,0]) cylinder(r=hotend_rad+wall, h=hotend_height+wall);
		}

		for(i=[-hotend_sep/2, hotend_sep/2]) translate([i,0,0]) {
			//hotend hole
			translate([0,0,thickness-hotend_height]) cylinder(r=hotend_rad, h=hotend_height+.01);
	
			//pushfit hole
			cylinder(r=pushfit_rad, h=50, center=true);
		}

		//screw slots
		for(i=[-1,1]) hull(){ for(j=[i*outer_holes/2, i*inner_holes/2]) {
				translate([j,0,0]) cylinder(r=screw_rad, h=50, center=true);
			}
		}

		//central screwhole, for tightening
		translate([0,0,-.1]) cylinder(r=m3_rad, h=50);
	}
}

module hotend_groovemount_dual(){
	difference(){
		union(){
			hull(){
				for(i=[-outer_holes/2, outer_holes/2]) translate([i,0,0]){
					cylinder(r=hotend_rad, h=groovemount_thickness);
					translate([0,wall,0]) cylinder(r=hotend_rad, h=groovemount_thickness);
				}
			}
		}

		//hotend slots
		for(i=[-hotend_sep/2, hotend_sep/2]) translate([i,0,0]) {
			translate([0,0,-.1]) hull(){
				cylinder(r=groovemount_rad, h=50);
				translate([0,-20,0]) cylinder(r=groovemount_rad+.5, h=50);
			}
		}
	
		//screw slots
		for(i=[-1,1]) hull(){ for(j=[i*outer_holes/2, i*inner_holes/2]) {
				translate([j,0,0]) cylinder(r=screw_rad, h=50, center=true);
			}
		}

		//central screwhole, for tightening
		translate([0,0,-.1]) cylinder(r=m3_rad, h=50);
		translate([0,0,groovemount_thickness/2]) cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=50, $fn=6);
	}
}