in = 25.4;

wall = 3;
leg = 15/16*in;

hole1 = 3/32*in/2;
hole2 = 3/16*in/2;

thick = 1/2*in;

mount();
$fn=32;

module mount(){
	mrad = 2;
	difference(){
		union(){
			cube([leg+wall*4,leg+wall*3,thick]);
			translate([-wall*2,0,0]) cube([wall*2+.1,leg+wall*3,thick]);
		}

		translate([wall*2+mrad,wall+mrad,-.1]) minkowski(){
			cube([leg+wall*3, leg+wall*3, thick]);
			cylinder(r=mrad, h=.2);
		}

		translate([-wall*4-wall*2,wall+wall*2,-.1]) minkowski(){
			cube([wall*4, leg+wall*3, thick]);
			cylinder(r=wall*2, h=.2);
		}

		//hole1
		translate([0,leg, thick/2]) rotate([0,90,0]) cylinder(r=hole1, h=20, center=true);

		//hole2
		translate([leg,0, thick/2]) rotate([90,0,0]) cylinder(r=hole2, h=20, center=true);
	}
}