x_sep = 50;
y_sep = 150;

hole_dia = 5;
hole_rad = hole_dia/2;

side_spacer = 40;

wall=4;

template();

module template(){
	difference(){
		union(){
			hull(){
				cylinder(r=hole_rad, h=wall/2);
				translate([x_sep,0,0]) cylinder(r=hole_rad, h=wall/2);	
			}
            translate([0,y_sep,0]) hull(){
				cylinder(r=hole_rad, h=wall/2);
				translate([x_sep,0,0]) cylinder(r=hole_rad, h=wall/2);	
			}
			hull(){
				cylinder(r=hole_rad, h=wall/2);
				translate([0,y_sep,0]) cylinder(r=hole_rad, h=wall/2);
			}

			//side spacers
			hull(){
				cylinder(r=hole_rad, h=wall/2);
				translate([-side_spacer,-wall/2,0]) cube([wall,wall,wall/2]);
			}
			hull(){
				translate([0,y_sep,0]) cylinder(r=hole_rad, h=wall/2);
				translate([-side_spacer,y_sep-wall/2,0]) cube([wall,wall,wall/2]);
			}
		
			cylinder(r=hole_rad+wall/2, h=wall);
			translate([x_sep,0,0]) cylinder(r=hole_rad+wall/2, h=wall);
            translate([x_sep,y_sep,0]) cylinder(r=hole_rad+wall/2, h=wall);
			translate([0,y_sep,0]) cylinder(r=hole_rad+wall/2, h=wall);
		}
		
		translate([0,0,-.1]){
			cylinder(r=hole_rad, h=wall+1);
			translate([x_sep,0,0]) cylinder(r=hole_rad, h=wall+1);
            translate([x_sep,y_sep,0]) cylinder(r=hole_rad, h=wall+1);
			translate([0,y_sep,0]) cylinder(r=hole_rad, h=wall+1);
		}
	}
}

