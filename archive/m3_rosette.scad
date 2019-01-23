slop = .25;

m3_dia = 3;
m3_rad = m3_dia/2+slop;

m3_cap_dia = 5.7;
m3_cap_rad = m3_cap_dia/2+slop;
m3_cap_thick = 1.65+slop/2;
m3_cap_hex_rad = (2/cos(30))/2;

m3_nut_dia = 6.5;
m3_nut_rad = m3_nut_dia/2+slop;
m3_nut_thick = 2.4;


lm8uu_dia = 15;
lm8uu_rad = lm8uu_dia/2+slop;
lm8uu_len = 24+slop;

lm8uu_inset = 2;  //inset into frame

wall = 3;
height = 2;
switch = 4;
shaft = 6;

$fn=32;
translate([20,20,0]) rosette();

module rosette(){
	thick = 3;
	rad = 6.25;
	D = 4.5;
	mrad=1;
	difference(){
		minkowski(){
			union(){
				for(i=[0:30:60]) rotate([0,0,i]) cylinder(r=rad, h=thick-mrad, $fn=3);
			}
			intersection(){
				sphere(r=mrad, $fn=9);
				translate([0,0,10]) cube([20,20,20],center=true);
			}
		}

		//shaft
		translate([0,0,-.1]) cylinder(r=m3_rad-.1, h=20);
		translate([0,0,1]) cylinder(r=m3_nut_rad, h=20, $fn=6);
	}
}