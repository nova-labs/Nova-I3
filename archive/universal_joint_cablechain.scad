//show the build plate
translate([0,0,-.1])
%cube([200,200,.2], center=true);


outer_rad = 12;				//radius of outer tube
wall = 2; 					//thickness of tube
base = outer_rad/4-5;			//base height, one half
height = outer_rad*2-5;		//overall height, one half
arm_thickness = outer_rad-wall;	//arm thickness
ring_rad = outer_rad-wall-1;		//radius of connector ring
ring_thick = 4.5;				//thickness of connector ring

spike_rad = 2;				//max radius of spike


////////////you probably don't want to change these :-)
base_rad = outer_rad-arm_thickness/2;	//radius on base to arms
upper_rad = arm_thickness/2+2;		//top radius

//these are tricks to make the 'cylinder' angles printable standing up.
//If you print bracket_half instead you can make 'em nice and round.
roundness = 8;		
side_roundness = 4;
top_roundness = 6;

//have to fix the height because of the flatness constraint
//on the top round segment.
delta_h = upper_rad - (upper_rad/2*sqrt(3));

module spike(r, h) {
	cylinder(h=h,r1=r, r2=r/4, center = true, $fn=20);
}

module bracket(){

	translate([0,0,height - delta_h])

	for(j=[0:1]){
		mirror([0,0,j])
		translate([0,0,-.01])
		rotate([0,0,90*j])
		bracket_half();
	}
}

module bracket_half() {
	union(){
		for(k=[0:1]){
			mirror([0,k,0])
			translate([0,outer_rad-wall*2+.1,height-upper_rad])
			rotate([90,0,0])
			spike(r=spike_rad, h=wall+.1);
		}

	difference() {
		difference() {	
			rotate([0,0,180/roundness])
			cylinder(r=outer_rad, h=height, $fn=roundness);
	
			//hollow out the center
			translate([0,0,-.1])
			rotate([0,0,180/roundness])
			cylinder(r=outer_rad-wall, h=height+.2, $fn=roundness);
	
			for(i=[0:1]){
				mirror([i,0,0]){
					//shave off one side
					translate([arm_thickness+outer_rad/2,0,height+base+base_rad])
					cube([arm_thickness+outer_rad,outer_rad*2+1,height*2], center=true);
			
					//round the base corner
					translate([outer_rad,0,base+base_rad])
					rotate([90,0,0])
					cylinder(r=base_rad, h=outer_rad*2+1, center=true, $fn=side_roundness);

			
				}
			}
		}

		//round out the top
		translate([0,0,height-upper_rad])
		difference() {
			cube([outer_rad*2+1,outer_rad*2+1,upper_rad*2+1], center=true);

			rotate([90,0,0])
			cylinder(r=upper_rad, h=outer_rad*2+2, center=true, $fn=top_roundness);	
			
			translate([0,0,-outer_rad/2])
			cube([outer_rad*2+2,outer_rad*2+2,outer_rad], center=true);
		}
	}
}
}

module ring(){
	difference() {
		rotate([0,0,180/roundness])
		cylinder(r=ring_rad, h=ring_thick, $fn=roundness);
		translate([0,0,-.1])
		rotate([0,0,180/roundness])
		cylinder(r=ring_rad-wall, h=ring_thick+.2, $fn=roundness);

		for(i=[0:4]){
			rotate([0,0,90*i])
			translate([ring_rad-wall+.1,0,ring_thick/2])
			rotate([0,-90,0])
			spike(r=spike_rad, h=ring_thick+.2);
		}
	}
}

module joint() {
	bracket();

	translate([0,0,height*2-upper_rad-ring_thick/2-delta_h])
	ring();

	translate([0,0,height*2-upper_rad*2])
	bracket();
}

module plate(x,y){
	translate([-outer_rad*(x+1), -outer_rad*(y+1),0])
	for(i=[1:x]){
		for(j=[1:y]){
			translate([outer_rad*2*i,outer_rad*2*j,0]){
				bracket();
				ring();
			}
		}
	}
}

//joint();

//bracket();
//ring();

plate(1,1);
