slop=.2;

//english sizes - 6-32 - for graber i3 clamp
632_dia = 3.5;
632_rad = 632_dia/2+slop;
bolt_rad = 632_rad;
632_nut_rad = 8.25/cos(45)/2;
nut_rad = 632_nut_rad;
632_cap_dia = 6.5+.5;
632_cap_rad = 632_cap_dia/2+slop;
632_cap_height = 2+slop;
632_nut_height = 5;


m3_nut_rad = 6.01/2+slop;
m3_nut_height = 2.4;
m3_rad = 3/2+slop;
m3_cap_rad = 4.25;


wall=4;
motor_w = 42;
motor_r = 52/2;

mount_sep = 35;  //needs to match ext_offset from x-carriage.scad

$fn=60;

extruder_mount(offset=-3, mount_screw_rad=m3_rad, fan_mount=1);

//attaches the motor with one or two screws.
module extruder_mount(screws = 1, flip=0, fan_mount=0, mount_screw_rad = 632_rad, angle=0, height=15, offset=-1, motor_offset=1){
	echo(height);
	wall=4;
	lower_hole_sep = 47.5;
	lower_hole_rad = 6+slop;
	lower_hole_height = -7.5;
	lower_hole_depth = 6;

	hole_sep=30;
	fan_hole_sep = 32;
	fan_offset= 5;
	
	scale_slop = 1.02;
	scale_size = (motor_w+wall+wall)/motor_w;
	difference(){
		union(){
			hull(){
				//strap
				scale([scale_size,scale_size,1]) motor_base(h=height);

				//clamp
				translate([0,motor_w/2+wall+632_rad+wall,height/2]) rotate([0,90,0]) clamp(height=height, 1);			
			}

			//mount base
			hull(){
				scale([scale_size,scale_size,1]) motor_base(h=height);
				translate([-motor_w/2-wall-wall/2+.05+1+offset,0,height/2]) rotate([0,0,angle]) cube([wall+1,motor_w+wall/2,height], center=true);

				if(screws == 2){
					translate([-motor_w/2-wall-wall,0,height/2+hole_sep]) rotate([0,0,angle]) rotate([0,90,0]) cylinder(r=632_cap_rad+wall-.75, h=wall+1);
				}
			}

			//strengthen the vertical mount
			if(screws == 2){
				difference(){
					hull(){
						translate([-motor_w/2-wall/2+.05+1,0,height/2]) cube([wall+2,motor_w,height], center=true);

						translate([-motor_w/2-wall,0,height/2+hole_sep]) rotate([0,90,0]) cylinder(r=632_cap_rad+wall-.75, h=wall+2);
					}

					hull(){
						translate([-motor_w/2-wall+1+wall,0,height+wall]) rotate([90,0,0]) scale([1,1,1]) cylinder(r=wall, h=motor_w+wall*2, center=true, $fn=90);
                                                translate([-motor_w/2-wall+10+wall,0,height+wall]) rotate([90,0,0]) scale([1,1,1]) cylinder(r=wall, h=motor_w+wall*2, center=true, $fn=90);
						translate([-motor_w/2-wall+1+wall,0,height+wall*2+hole_sep]) rotate([90,0,0]) cylinder(r=wall, h=motor_w+wall, center=true);
					}
				}
			}

			//add a fan mount
			if(fan_mount==1){
				for(i=[-1,1]) translate([fan_hole_sep/2*i, -motor_w/2-wall, 0]) hull(){
					cylinder(r=wall+m3_rad, h=wall*2);
					translate([0, -fan_offset, 0]) cylinder(r=wall+m3_rad, h=wall*2);
				}
			}
		}

		//slit
		translate([0,motor_w/2,height/2]) cube([wall,motor_w,height+1],center=true);

		//clamp holes
		render() translate([0,motor_w/2+wall+mount_screw_rad+wall,height/2]) rotate([0,90,0]) clamp(height=height, solid=0);
		
		//mounting holes
        for(i=[-mount_sep/2, 0, mount_sep/2])
            #translate([-motor_w/2-wall*2+.5+offset,i,height/2]) rotate([0,0,angle]) {
                rotate([0,90,0]) rotate([0,0,-90]) translate([0,0,offset*2]) cap_cylinder(r=mount_screw_rad, h=200, center=true);
		
                translate([wall/2,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=mount_screw_rad*2.5, h=wall*4);
            }
	

		if(screws == 2) {
			translate([-motor_w/2-wall*2-.05,0,height/2+hole_sep]) rotate([0,0,angle]) {
                            rotate([0,90,0]) rotate([0,0,-90]) translate([0,0,offset*2]) cap_cylinder(r=mount_screw_rad, h=200, center=true);
		
                            translate([wall/2,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=mount_screw_rad*2, h=wall*3);
		}
		
			//make the screwholes, and avoid the other screws
			translate([-motor_w/2-wall-wall,0,height/2+hole_sep/2])
			for(i=[-1,1]) rotate([0,90,0]) rotate([0,0,-90]) {
				mirror([flip,0,0]) translate([lower_hole_height, lower_hole_sep/2*i, -.25]) cap_cylinder(r=lower_hole_rad, h=lower_hole_depth+.5, point=1);
			}
		}

		if(fan_mount==1){
			for(i=[-1,1]) translate([fan_hole_sep/2*i, -motor_w/2-wall-fan_offset, -.1]) {
				translate([0,0,wall]) cylinder(r1=m3_nut_rad+.1, r2=m3_nut_rad+.7, h=wall*2, $fn=6);
				cylinder(r=m3_rad, h=wall*3);
			}
		}

		//motor hole
		scale([scale_slop,scale_slop,1]) translate([0,0,-.05]) motor_base(h=height+wall);
	}
}

module clamp(solid = 1, mount_screw_rad = 632_rad, m5=0){
	len = wall*5;
	facets = 6;
	if(solid==1){
		rotate([0,0,180/facets]) cylinder(r=height/2/cos(180/facets), h=len, center=true, $fn=facets);	
	}else{
		//screwhole
		rotate([0,0,-90]) cap_cylinder(r=mount_screw_rad, h=len*2, center=true); 

		//nut is on the inside
		if(m5 == 1){
			mirror([0,0,1]) translate([0,0,wall*1.5]) rotate([0,0,-90]) cylinder(r1=m5_nut_rad, r2=m5_nut_rad+1, h=len, $fn=6);
		}else{
			mirror([0,0,1]) translate([0,0,wall*1.5]) rotate([0,0,-90]) cylinder(r1=632_nut_rad, r2=632_nut_rad+.5, h=len, $fn=4);
		}
		

		//screw is on the outside
		translate([0,0,wall*1.5]) rotate([0,0,-90]) cap_cylinder(r=mount_screw_rad*2.5, h=len);
	}
}

module cap_cylinder(r=1, h=1, center=false, point = 0){
	render() union() {
		cylinder(r=r, h=h, center=center);
		if(point==0){
			intersection(){
				rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
				translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
			}
		}else{
			intersection(){
				rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
				translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
			}
		}
	}
}

//base plate
module base(solid=1, h=wall){
	if(solid==1){
		intersection(){
			motor_base(h);
			translate([0,0,h]) cube([motor_w,motor_w,h*2], center=true);
		}
        //pegs for the screws
        for(i=[0,90,180]){
            rotate([0,0,i]){
                translate([31/2+slop,31/2+slop,0]) cylinder(r=m3_cap_rad-.1, h=h*2, $fn=18);
                translate([31/2-slop,31/2-slop,0]) cylinder(r=m3_cap_rad-.1, h=h*2, $fn=18);
		    }
		}
	}else{
		motor_mount(h);
	}
}

//motor cutout and mount
module motor_mount(h=wall, h2=6.5){
	ridge_r = 12;
	ridge_h1 = 2.5;
	ridge_h2 = 8-ridge_h1; //2.3

	hull(){
		for(i=[0,wall/2]) {
			#translate([i,0,-.05]) cylinder(r=ridge_r, h=ridge_h1+.1, $fn=36);
		}
		translate([0,0,ridge_h1-.05]) cylinder(r1=ridge_r, r2=gear_rad, h=ridge_h2+.1, $fn=36);
	}

	for(i=[0,90,180]){
		rotate([0,0,i]){
			hull(){
				translate([31/2+slop,31/2+slop,0]) cylinder(r=m3_rad, h=20, $fn=18, center=true);
				translate([31/2-slop,31/2-slop,0]) cylinder(r=m3_rad, h=20, $fn=18, center=true);
			}
			translate([0,0,h2]) hull(){
				translate([31/2+slop,31/2+slop,0]) cylinder(r=m3_cap_rad, h=height*2, $fn=18);
				translate([31/2-slop,31/2-slop,0]) cylinder(r=m3_cap_rad, h=height, $fn=18);
			}
		}
	}
}

module motor_base(h=wall){
	intersection(){
		translate([0,0,h/2]) cube([motor_w, motor_w, h], center=true);
		cylinder(r=motor_r+slop, h=h, $fn=64);
	}
}