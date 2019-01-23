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
height = 8;
switch = 4;
shaft = 6.0+slop;

$fn=32;
//for(i=[0:360/7:350]) rotate([0,0,i]) translate([12,0,0]) 
//	spacer();

stop_button();
translate([24,0,0]) knob();

module knob(){
	thick = 13;
	rad = 14;
	D = 5;
	mrad=4;
	difference(){
		minkowski(){
			union(){
				for(i=[0:20:40]) rotate([0,0,i]) cylinder(r=rad-mrad, h=thick-mrad, $fn=6);
			}
			intersection(){
				sphere(r=mrad, $fn=9);
				translate([0,0,10]) cube([20,20,20],center=true);
			}
		}

		//d shaft
		translate([0,0,-.1]) difference(){
			cylinder(r=(shaft+slop)/2, h=thick-2);
			translate([D+slop,0,0]) cube([shaft, shaft, (thick-2)*2],center=true);
		}
	}
}

module stop_button(){
	dia = 8;
	rad = dia/2-slop;
	base_rad = rad+wall/2;
	union(){
		cylinder(r=base_rad, h=1.5);
		cylinder(r=rad, h=height-switch+6);
	}
}

module spacer(h=8){
	difference(){
		cylinder(r=m3_rad+wall, h=h, $fn=6);
		
		cylinder(r=m3_rad, h=h*2.2, center=true);
	}
}

module cap_screw(len = 10){
	color([.25,.25,.25])
	difference(){
		union(){
			translate([0,0,-len/2]) rotate([0,0,-90]) cap_cylinder(r=screw_rad, h=len, center=true);
			translate([0,0,len/2-.1]) difference(){
				scale([1,1,.75]) sphere(r=cap_rad);
				translate([0,0,-cap_dia/2]) cube([cap_dia+1, cap_dia+1, cap_dia],center=true);
				translate([0,0,cap_dia/2+.1+cap_thick]) cube([cap_dia+1, cap_dia+1, cap_dia],center=true);
			}
		}
		
		translate([0,0,len/2+slop]) cylinder(r=cap_hex_rad, h=cap_thick, $fn=6);
	}
}

module cap_cylinder(r=1, h=1, center=false){
	cylinder(r=r, h=h, center=center);
	intersection(){
		rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
		translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
	}
}