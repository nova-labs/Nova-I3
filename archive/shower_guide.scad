in = 25.4;

wall = .08*in;
base_wall = .08*in;

x = .22*in;
y = 1*in+base_wall;
z = 3*in;

hole_sep = 2*in;
hole_y = y - .25*in;
hole_r = .2*in/2;

rotate([0,-90,0])
guide();

module guide(){
	difference(){
		union(){
			cube([wall, y, z]);
			cube([x, base_wall, z]);
		}
	
		//holes
		translate([-.1,hole_y,z/2]) for(i=[-1,1]) translate([0,0,i*hole_sep/2]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=hole_r, h=wall+1);
	}
}


module cap_cylinder(r=1, h=1, center=false){
	render() union(){
		cylinder(r=r, h=h, center=center);
		intersection(){
			rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
			translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
		}
	}
}