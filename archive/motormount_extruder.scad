////////////////////////////
//  This is a new extruder design by Paul Chase.
//
//  WHY?!  Because I'm very particular.
//
//  1) it fits on a motor
//  2) it's modular - can adapt to wade or i3 mounts, bowden or wade
//  3) Minimal part count
//  4) Easy access to drive gear, you can even clean while printing!
//  5) Fully guided filament path
//  6) Super clamping power!
//
//  If you have any issues with it, let me know - paenian on thingiverse.
////////////////////////////


slop = .2;
wall = 3;

////////////standard variables.  Shouldn't need to change 'em.  Except maybe slop.
motor_w = 42;
motor_r = 50/2;

gear_dia = 13;
gear_rad = gear_dia/2;

m3_nut_rad = 6/cos(30)/2;
m3_nut_height = 3;
m3_rad = 1.8;
m3_cap_rad = 3.25;

m4_rad = 2+slop;
m4_nut_rad = 7.8/2+slop;
m4_nut_height = 3.2;
m4_cap_rad = 7/2+slop;

m5_nut_rad = 8.4/cos(30)/2+slop;
m5_nut_height = 4+slop;
m5_rad = 2.8;

//english sizes - 6-32 - for graber i3 clamp
632_dia = 3.5;
632_rad = 632_dia/2+slop;
632_nut_rad = 8.25/cos(45)/2;
632_cap_dia = 6.5;
632_cap_rad = 632_cap_dia/2+slop;
632_cap_height = 2+slop;
632_nut_height = 5;

bowden_tap_rad = 9.55/2;
bowden_tube_rad = 2.1;

$fn=32;

/////////////////////////////////////////
//  Only the variables in here should need to be changed.
/////////////////////////////////////////
motor_mount_h = wall;  //this is the thickness of the motor mount plate

filament_rad = 2.25;	 //1.25 for 1.75mm filament, 2.25 for 3mm
filament_height = 12; //distance from motor to center of filament.  Adjust to suit.

//hotend attachment types
bowden_tap = 0;
bowden_clamp = 1; //clamp tends to snap... not recommended.
groovemount = 2;

//extruder attachment types
none = 0;  //there is no attachment - clamp motor in place.  This is for bowden.
i3 = 1;    //screw directly onto i3
wade = 2;  //bolt to a wade platform


//mirror([1,0,0])		//I use this to make a left and right version for dualstrusion :-)
extruder(bowden_tap,none);
//extruder_mount(1);	


/////////////////////////////////////////
//  Feel free to change more stuff.  Just don't whine as much if you break it :-)
/////////////////////////////////////////

filament_offset = 11/2+filament_rad/2;
height = filament_height+wall;

lower_hole_sep = 30;
lower_hole_rad = 5.5+slop;
lower_hole_height = -7.5;


//////this is for m5 idler & bearing
idler_dia = 16;
idler_thick = 6;
idler_flat_rad = 4;
idler_nut_rad = m5_nut_rad;
idler_nut_height = m5_nut_height;
idler_bolt_rad = m5_rad;


//////this is for an m3 idler & bearing
idler_dia = 10;
idler_thick = 4;
idler_flat_rad = 3;
idler_nut_rad = m3_nut_rad;
idler_nut_height = m3_nut_height+1;
idler_bolt_rad = m3_rad;

////misc idler vars
idler_rad = idler_dia/2;
idler_offset = filament_rad/2;  //adjust to increase/decrease tension

slit_offset = gear_rad+idler_rad/2;
slit_l = 12;
slit_w = 2;

hole_sep = 47.5;

//attaches the motor with one or two screws.
module extruder_mount(screws = 1){
	scale_slop = 1.025;
	scale_size = (motor_w+wall+wall)/motor_w;
	difference(){
		union(){
			hull(){
				//strap
				scale([scale_size,scale_size,1]) motor_base(h=height);

				//clamp
				translate([0,motor_w/2+wall+632_rad+wall,height/2]) rotate([0,90,0]) clamp(1);			
			}

			//mount base
			hull(){
				intersection(){
					translate([-motor_w/2-wall-wall/2+.05+.5,0,height/2]) cube([wall+1,motor_r*2,height], center=true);
					scale([scale_size,scale_size,1]) cylinder(r=motor_r+slop, h=height);
				}

				if(screws == 2){
					translate([-motor_w/2-wall-wall,0,632_cap_rad+wall/2+hole_sep]) rotate([0,90,0]) cylinder(r=632_cap_rad+wall/2, h=wall+1);
				}
			}
		}

		//slit
		translate([0,motor_w/2,height/2]) cube([wall,motor_w,height+1],center=true);

		//clamp holes
		render() translate([0,motor_w/2+wall+632_rad+wall,height/2]) rotate([0,90,0]) clamp(0);
		
		//bolt hole
		translate([-motor_w/2-wall-wall-.05,0,632_cap_rad+wall/2]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=632_rad, h=wall+1+motor_r*2);
		translate([-motor_w/2-632_nut_height+.05,0,632_cap_rad+wall/2]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=632_cap_rad, h=632_nut_height);

		if(screws == 2) {
			translate([0,0,hole_sep]) translate([-motor_w/2-wall-wall-.05,0,632_cap_rad+wall/2]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=632_rad, h=wall+1);
			translate([0,0,hole_sep]) translate([-motor_w/2-632_nut_height+.05,0,632_cap_rad+wall/2]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=632_cap_rad, h=632_nut_height);
		
			//make the screwholes, and avoid the other screws
			for(i=[0,1]) translate([-motor_w/2-wall-wall,0,632_cap_rad+wall/2+hole_sep*i]) rotate([0,90,0]) rotate([0,0,-90]) {
				cap_cylinder(r=632_rad, h=wall+1);
				translate([0,0,wall-632_cap_height]) cap_cylinder(r=632_cap_rad, h=wall+1);
	
				//hollows for other screws on mount
				mirror([0,i,0]) translate([lower_hole_sep/2-hole_sep/2, lower_hole_height, -.1]) cap_cylinder(r=lower_hole_rad, h=wall-1);
			}
		}

		//motor hole
		scale([scale_slop,scale_slop,1]) translate([0,0,-.05]) motor_base(h=height+.1);
	}
}

module clamp(solid = 1){
	len = wall*5;
	if(solid==1){
		cylinder(r=height/2, h=len, center=true);	
	}else{
		//screwhole
		rotate([0,0,-90]) cap_cylinder(r=632_rad, h=len*2, center=true); 

		//nut is on the inside
		mirror([0,0,1]) translate([0,0,wall*1.5]) rotate([0,0,-90]) cylinder(r=632_nut_rad, h=len, $fn=4);

		//screw is on the outside
		translate([0,0,wall*1.5]) rotate([0,0,-90]) cap_cylinder(r=632_cap_rad, h=len);
	}
}

module extruder(type=0, mount = 0){
	difference(){
		union(){
			base(solid=1, h=motor_mount_h);
			body(solid=1, type=type, mount=mount);
		}

		base(solid=0, h=motor_mount_h);
		body(solid=0, type=type, mount=mount);
	}
}

module body(solid = 0, type=0, mount=0){
	rad = 5;
	h=50;
	if(solid==1){
		intersection(){
			translate([motor_w/4+filament_rad/2,0,height/2]) minkowski(){
				cube([motor_w/2-rad*2+filament_rad,motor_w-rad*2,height], center=true);
				cylinder(r=rad, h=.1);
			}
			
			translate([0,0,h/2]) cube([motor_w, motor_w, h], center=true);
			cylinder(r=motor_r+slop, h=h, $fn=64);
		}
		translate([-rad, 0, motor_mount_h]) difference(){
			translate([0,-(motor_w-rad-rad)/2,0]) cube([rad, motor_w-rad-rad, rad]);
			translate([0,0,rad]) rotate([90,0,0]) cylinder(r=rad, h=motor_w-rad, center=true);
		}
		//hotend attachment
		translate([filament_offset,motor_w/2,filament_height]) rotate([-90,0,0]){
			if(type == 0)
				bowden_tap(1);
			if(type == 1)
				bowden_clamp(1);
			if(type == 2)
				groovemount(1);
			if(mount == 1)
				i3_mount(1);
			if(mount == 2)
				wade_mount(1);
		}

	}else{
	//hollow bits
		//drive gear
		hull(){
			%cylinder(r=11/2, h=100, center=true); //idler dia
			cylinder(r=gear_rad+slop, h=100, center=true);
			translate([idler_offset,0,0]) cylinder(r=gear_rad+slop, h=100, center=true);
		}

		//slit
		translate([slit_offset,slit_l,0]) cylinder(r=slit_w/2, h=100, center=true);
		translate([slit_offset,slit_l-motor_w/2,0]) cube([slit_w,motor_w,100],center=true);

		//filament
		translate([filament_offset,0,filament_height]) rotate([90,0,0]) cylinder(r=filament_rad, h=100, center=true, $fn=8);

		//idler bolt
		//translate([5,0,0])	  //uncomment to check placement
		translate([gear_rad+idler_rad+idler_offset,0,0]){
			rotate([0,0,30]) translate([0,0,-wall/2]) cylinder(r=idler_nut_rad, h=idler_nut_height+wall, $fn=6);
			translate([0,0,idler_nut_height+.3+wall/2]) cylinder(r=idler_bolt_rad, h=height);
			difference(){
				hull(){
					//%translate([0,0,filament_height+1]) cylinder(r=idler_rad+.5, h=idler_thick+2, center=false);//idler actual
					translate([0,0,filament_height+1]) cylinder(r=idler_rad+.5, h=idler_thick+4, center=true);
					translate([-idler_offset,0,filament_height+1]) cylinder(r=idler_rad+.5, h=idler_thick+4, center=true);
				}
		
				translate([0,0,filament_height-idler_thick/2-.5]) cylinder(r1=idler_rad+.5, r2=idler_flat_rad, h=1, center=true);
			}
		}

		//cone to guide/unguide filament
		translate([filament_offset,0,filament_height]) for(i=[0,1]) mirror([0,i,0]) translate([0,-wall/2,0]) rotate([90,0,0]) cylinder(r1=wall, r2=0, h=wall+1.5);

		//hotend attachment
		translate([filament_offset,motor_w/2,filament_height]) rotate([-90,0,0]){
			if(type == 0)
				bowden_tap(0);
			if(type == 1)
				bowden_clamp(0);
			if(type == 2)
				groovemount(0);
			if(mount == 1)
				i3_mount(0);
			if(mount == 2)
				wade_mount(0);
		}

		//m3 clamp
		translate([0,-motor_w/2+m3_nut_rad,filament_height-wall-1.1]){
			rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=50, center=true);
			rotate([0,90,0]) render() rotate([0,0,-90]) cap_cylinder(m3_cap_rad, wall+3, center=true);
			translate([motor_w/2-wall-wall,0,0]) rotate([0,90,0]) cylinder(r=m3_nut_rad, h=30, $fn=6);
		}

		
		//flatten bottom
		translate([0,0,-20]) cube([100,100,40],center=true);
	}
}

module bowden_tap(solid=1){
	thick = 5;
	translate([0,0,-5]){
	if(solid==1){
		hull(){
			cylinder(r=bowden_tap_rad+thick, h=12, $fn=6);
			translate([0,(bowden_tap_rad+thick),0]) cylinder(r=bowden_tap_rad+thick, h=thick, $fn=6);
		}
		
	}else{
		//slit
		translate([0,-10,thick/2-.1]) cube([bowden_tap_rad*2,20,thick], center=true);
		//for pass-through; bowden tube goes in a bit
		translate([0,0,-thick]) cap_cylinder(bowden_tube_rad, 10);
		//tap this to hold the bowden.
		cap_cylinder(bowden_tap_rad, 15);
	}
	}
}

module bowden_clamp(solid=1){
	thick = 5;
	len = 10;
	translate([0,0,-5]){
	if(solid==1){
		hull(){
			cylinder(r=bowden_tap_rad+thick, h=len, $fn=6);
			translate([0,(bowden_tap_rad+thick)/2,0]) cylinder(r=bowden_tap_rad+thick, h=5, $fn=6);
		}

		translate([0,(-bowden_tap_rad-thick)*cos(30),len/2]) rotate([0,90,0]) cylinder(r=m3_rad+thick/2, h=bowden_tap_rad+thick, center=true, $fn=6);
		
	}else{
		//slits
		translate([-bowden_tap_rad-thick/2,0,.45]) cube([bowden_tap_rad*2+thick,(bowden_tap_rad*2+thick+slop)/cos(30),1], center=true);
		translate([0,-bowden_tap_rad*2,10]) cube([2,bowden_tap_rad*4,20+.05], center=true);
		
		//for pass-through; bowden tube goes in a bit
		translate([0,0,-thick]) cap_cylinder(bowden_tube_rad/cos(180/8), 10);
		//hold the bowden.
		translate([0,0,-.05]) cylinder(r=bowden_tap_rad, h=15);
	
		//clamp bolt
		translate([0,(-bowden_tap_rad-thick)*cos(30),len/2]) rotate([0,90,0]) {
			cylinder(r=m3_rad, h=20, center=true);
			translate([0,0,6]) cylinder(r=m3_nut_rad, h=4, center=true, $fn=6);
			translate([0,0,-6]) cap_cylinder(m3_cap_rad, 4, center=true);
		}
	}
	}
}

module groovemount(solid=1){
	dia = 16+slop;
	rad = dia/2;
	mink = 1;
	inset = 9.5;

	screw_inset = 4.2;
	screw_offset = rad - m3_rad;
	screw_height = rad+m3_nut_height+wall;

	motor_angle=0;
	
	
	if(solid==1){
		minkowski(){
			translate([0,0,-wall*2-mink]) rotate([0,0,180/16]) cylinder(r=(filament_height-mink+1)/cos(180/16), h=inset+wall, $fn=16);
			sphere(r=mink, $fn=18);
		}
		
		//bolts to hold hotend in
		for(i=[0,1]) mirror([i,0,0]) translate([screw_offset,-screw_height/2,inset-wall-screw_inset]) rotate([90,0,0]) scale([1.25,1,1]) rotate([0,0,45]) cylinder(r=screw_inset/cos(180/4), h=screw_height, center=true, $fn=4);
		
		//translate([0,0,wall/2]) mount_plate(1, motor_angle);
	}else{
		translate([0,0,-wall]) cap_cylinder(rad, inset+.1);
		//backstop
		translate([0,0,-wall]) cylinder(r=rad+slop*2, h=slop*2);
		//hotend bolts
		for(i=[0,1]) mirror([i,0,0]) translate([screw_offset,-rad-1,inset-wall-screw_inset]) rotate([90,0,0]){
			translate([0,0,-rad-1]) cylinder(r=m3_rad, h=rad+1.2);
			translate([0,0,m3_nut_height+.3]) cylinder(r=m3_rad, h=rad);
			translate([0,0,m3_nut_height+wall/2+.3]) cylinder(r=m3_cap_rad, h=rad);
			hull(){
				rotate([0,0,30]) cylinder(r=m3_nut_rad, h=m3_nut_height, $fn=6);
				translate([0,wall,0]) rotate([0,0,30]) cylinder(r=m3_nut_rad, h=m3_nut_height, $fn=6);
			}
		}

		//translate([0,0,wall/2]) mount_plate(0,motor_angle);
	}
}

module i3_mount(solid=1){
	rad = 1;
	bolt_width = 47.5;
	width = bolt_width+632_rad*2+wall*2;
	ext_height = 8;

	upper_hole_sep = 30;
	upper_hole_rad = 5.25;
	upper_hole_height = -7.5;

	base_height = filament_height;

	if(solid==1){
		translate([0,base_height,0]) 
		union(){
			hull(){
				translate([filament_height+wall,-width/2,ext_height]) {
					for(i=[0,1]) mirror([0,i,0])  translate([0,bolt_width/2,0]) rotate([0,90,0]) {
						cylinder(r=632_rad+wall*2, h=wall*2, center=true);
					}
					translate([0,bolt_width/2,-ext_height]) rotate([0,90,0]) cylinder(r=632_rad+wall*2, h=wall*2, center=true);
				}
			}
			//bottom little plate
			//translate([filament_offset,motor_w/2,filament_height])
			intersection(){
				translate([-filament_offset+wall/2,-wall/2,0]) cube([motor_w+wall,wall,wall*3], center=true);
				hull(){
					translate([-filament_offset, 0, -motor_w/2-wall/2]) rotate([90,0,0]) cylinder(r=motor_r+slop, h=wall, $fn=64);
				translate([motor_r, 0, -motor_w/2+wall*2]) rotate([90,0,0]) cylinder(r=motor_r+wall/2, h=wall, $fn=64);
				}
			}
		}
	}else{
		translate([0,base_height,0]) {
			translate([filament_height+wall,-width/2,ext_height]) for(i=[0,1]) mirror([0,i,0])  translate([0,bolt_width/2,0]) rotate([0,90,0]) {
				cap_cylinder(632_rad, 100, center=true);
				translate([0,0,-wall-.1]) rotate([0,0,30]) cylinder(r=632_cap_rad, h=wall+.15);
			}

			//hollows for other screws on carriage
			translate([filament_height+wall,-width/2+upper_hole_sep/2-bolt_width/2,ext_height-upper_hole_height]) translate([-wall-1,bolt_width/2,0]) rotate([0,90,0]) cylinder(r=upper_hole_rad+slop, h=wall*3);
			translate([filament_height+wall,-width/2-upper_hole_sep/2-bolt_width/2,ext_height-upper_hole_height]) translate([-wall-1,bolt_width/2,0]) rotate([0,90,0]) cylinder(r=upper_hole_rad+slop, h=wall*3);
		
		}
	}
}

module wade_mount(solid=1){
	rad = 1;
	bolt_width = 50;
	width = bolt_width+m4_rad*2+wall*2;
	ext_height = 6.5;

	base_height = filament_height;

	thickness = filament_height*2;

	if(solid==1){
		union(){
			hull(){
				for(i=[0,1]) mirror([i,0,0])  translate([bolt_width/2,0,0]) rotate([0,00,0]) {
					cylinder(r=thickness/2/cos(180/6), h=ext_height, center=false, $fn=6);
				}
			}
			//nutholders
			for(i=[0,1]) mirror([i,0,0])  translate([bolt_width/2,0,-m4_nut_height]) rotate([0,00,0]) {
				cylinder(r1=m4_nut_rad+wall/2, r2=m4_nut_rad+wall, h=m4_nut_height+.1, center=false, $fn=6);
			}
		}
	}else{
		//bolt holes, nut traps
			for(i=[0,1]) mirror([i,0,0])  translate([bolt_width/2,0,-m4_nut_height-.1]) rotate([0,00,0]) {
				cylinder(r=m4_nut_rad, h=m4_nut_height+.5, center=false, $fn=6);
				cylinder(r=m4_rad, h=50);
			}
	}
}

module cap_cylinder(r=1, h=1, center=false){
	render() union() {
		cylinder(r=r, h=h, center=center);
		intersection(){
			rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
			translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
		}
	}
}

//base plate
module base(solid=1, h=wall){
	if(solid==1){
		intersection(){
			motor_base(h);
			translate([slit_offset-motor_w/2,0,h]) cube([motor_w,motor_w,h*2], center=true);
		}
	}else{
		motor_mount(h);
	}
}

//motor cutout and mount
module motor_mount(h=wall){
	ridge_r = 12;
	ridge_h1 = 2.3;
	ridge_h2 = 9-ridge_h1; //2.3

	hull(){
		for(i=[0,slit_w/2]) {
			translate([i,0,-.05]) cylinder(r=ridge_r, h=ridge_h1+.1, $fn=36);
		}
		translate([0,0,ridge_h1-.05]) cylinder(r1=ridge_r, r2=gear_rad, h=ridge_h2+.1, $fn=36);
	}

	for(i=[0,90,180]){
		rotate([0,0,i]){
			hull(){
				translate([31/2+slop,31/2+slop,0]) cylinder(r=m3_rad, h=20, $fn=18, center=true);
				translate([31/2-slop,31/2-slop,0]) cylinder(r=m3_rad, h=20, $fn=18, center=true);
			}
			translate([0,0,h]) hull(){
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
