//clip for misumi extrusion
slop = .25;
ext_width = 20;
slot_width = 6;

wall = 3;
length = 10;
extra_width = 25;
nub = 1.5;

//change for screw holder - this is for m3
screw_dia = 3 + slop;
screw_rad = screw_dia/2;

%cube([ext_width-4, ext_width, ext_width], center=true);


translate([0,0,0]) rotate([0,0,0]) clip();
$fn=32;
module clip()
{
	rad = 1;
	difference(){
		union(){
			//clip
			translate([0,ext_width/4-wall/2,length/2])
			minkowski(){
				union(){
					cube([ext_width+wall+wall-rad*2,ext_width/2+wall+slot_width-rad*2,length-.2], center=true);
					translate([extra_width/2,ext_width/2-wall+rad,0]) cube([ext_width+extra_width,wall-rad*2,length-.2], center=true);
				}

				cylinder(r=rad, h=.1);
			}
		}

		//hollow out the inside
		difference(){
			translate([0,ext_width/4-wall-wall,length/2]) cube([ext_width+slop,ext_width/2+wall+wall+slot_width,length+.1],center=true);
	
			//nubs
			for(i=[0,1]) mirror([i,0,0]) translate([ext_width/2+slop,-slop,-.1]) scale([nub/(slot_width/2),1,1]) cylinder(r=slot_width/2-slop, h=length+.2);
		}

		for(i=[0,1]) mirror([i,0,0]) translate([ext_width/2-rad/2,ext_width/2-rad/2,-.1]) cylinder(r=rad, h=length+.2);

		//fixing screw
		translate([0,0,length/2]) rotate([90,0,0]) cylinder(r=screw_rad/cos(30), h=100, $fn=6, center=true);
	}
}

