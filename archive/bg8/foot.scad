foot(taper = true);

wall=2;
bolt_rad = 2.1;
nut_rad = 10.9/2;  //6-32 square nut

foot_rad = nut_rad+wall*4;

foot_height = 25.4*3/4-(foot_rad-wall)/2;

$fn=30;

module foot(){
	difference(){
		union(){
			cylinder(r1=foot_rad, r2=foot_rad-wall, h=foot_height, $fn=36);
			translate([0,0,foot_height]) scale([1,1,.5]) sphere(r=foot_rad-wall, $fn=36);
		}
		
		translate([0,0,-.1]) cylinder(r=bolt_rad, h=25);
		translate([0,0,wall*2]) cylinder(r1=nut_rad, r2=nut_rad+1, h=foot_height, $fn=4);
		translate([0,0,wall*2+wall*2]) cylinder(r1=nut_rad, r2=nut_rad+4, h=foot_height*2);
		

		//scallop the edges, to put cables through the etrusion
		//for(i=[0:1]) mirror([i,0,0]) translate([foot_rad,0,-.1]) scale([1,1,1.5]) sphere(r=foot_rad-wall);
	}
}