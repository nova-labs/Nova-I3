//a cylinder with a flat on top - for drawing vertical holes.
module cap_cylinder(r=1, h=1, center=false){
	render() union(){
		cylinder(r=r, h=h, center=center);
		intersection(){
			rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
			translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
		}
	}
}

module screw_hole_m3(cap=false, onion=0, height=wall){
    screw_hole(cap=cap, onion=onion, cap_height=m3_cap_height, rad=m3_rad, cap_rad=m3_cap_rad, height=height);
}

module screw_hole_m4(cap=false, onion=0, height=wall){
    screw_hole(cap=cap, onion=onion, cap_height=m4_cap_height, rad=m4_rad, cap_rad=m4_cap_rad, height=height);
}

module screw_hole_m5(cap=false, onion=0, height=wall){
    screw_hole(cap=cap, onion=onion, cap_height=m5_cap_height, rad=m5_rad, cap_rad=m5_cap_rad, height=height);
}

//screhole with a nice recess for the cap.
module screw_hole(cap=false, onion=0, height=wall){
    translate([0,0,cap_height-.05+onion])
        if(cap==true){
            cap_cylinder(r=rad, h=height);
        }else{
            cylinder(r=rad, h=height);
        }
	translate([0,0,cap_height-height])
        if(cap==true){
            cap_cylinder(r=cap_rad, h=height);
        }else{
            cylinder(r=cap_rad, h=height);
        }
}