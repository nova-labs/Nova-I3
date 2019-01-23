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

layer_height=.15;

$fn=32;

////////////standard variables.  Shouldn't need to change 'em.  Except maybe slop.
motor_w = 42;
motor_r = 52/2;	//this is the rounding on the motor face.

m3_nut_rad = 6.01/2+slop;
m3_nut_height = 2.4;
m3_rad = 3/2+slop;
m3_cap_rad = 3.25;

m4_nut_rad = 7.66/2+slop;
m4_nut_height = 3.2;
m4_rad = 4/2+slop;
m4_cap_rad = 7/2+slop;

m5_nut_rad = 8.79/2+slop;
m5_nut_height = 4.7;
m5_rad = 5/2+slop;
m5_cap_rad = 8/2+slop;

//english sizes - 6-32 - for graber i3 clamp
632_dia = 3.5;
632_rad = 632_dia/2+slop;
bolt_rad = 632_rad;
632_nut_rad = 8.25/cos(45)/2;
nut_rad = 632_nut_rad;
632_cap_dia = 6.5;
632_cap_rad = 632_cap_dia/2+slop;
632_cap_height = 2+slop;
632_nut_height = 5;

bowden_tap_rad = 9.2/2;
bowden_tube_rad = 2.1;


/////////////////////////////////////////
//  Only the variables in here should need to be changed.
/////////////////////////////////////////
motor_mount_h = wall;  //this is the thickness of the motor mount plate

filament_rad = 1.25;	 //1.25 for 1.75mm filament, 2.25 for 3mm
filament_height = 14; //distance from motor to center of filament.  Adjust to suit.

//these are for the drive gear, aka hobbed pulley
gear_dia = 9;  //13 for Mark 7, 9 for Mark 8
gear_rad = gear_dia/2+slop;

//the eff gear rad is the radius of the hobbed part of your gear, 
eff_gear_rad = 6.8/2; //11/2 for mark 7, 7/2 for Mark 8
idler_offset = filament_rad*4/3;  //adjust to increase/decrease tension

//hotend attachment types
bowden_tap = 0;
bowden_clamp = 1; //clamp tends to snap... not recommended.
groovemount = 2;
groovemount2 = 3;

//extruder attachment types
none = 0;  //there is no attachment - clamp motor in place.  This is for bowden.
graber = 1;    //screw directly onto i3
wade = 2;  //bolt to a wade platform
i3 = 3;  //basically the graber mount, but with 30mm wide holes.
			//Should work with the graber too.
kossel = 4;	//this mounts to the horizontal rail at the bottom of a kossel clear.  Should work for other kossels, but that is untested.

//idler options
m3 = 0;
m5 = 1;

tensioner_rad = 3;
tensioner_cap_rad = 4.5;


//translate([motor_r*2+wall, 0, 0]) mirror([1,0,0]) extruder(bowden_tap, none, m3);
//translate([motor_r*2+wall, motor_r*2+wall, 0]) extruder(groovemount, graber, m3);

//**********BUILD GROUP 6 SPECS***********//
//ind_rad = 18/2+slop*2;
//ind_height = 12;

//translate([0, 0, 0]) extruder(groovemount, none, m5, motor_mount_h=4.5, e3d=1);
//extruder_mount(screws=2, flip=1, fan_mount=1, mount_screw_rad=632_rad, angle=0, height=16, offset=0);
//translate([filament_offset, 33, 0]) rotate([0,0,180]) grooveclamp(induction=0);


//**********BUILD GROUP 7 SPECS***********//
ind_rad = 18/2+slop*2;
ind_height = 12;

//extruder(groovemount2, none, m5, motor_mount_h=4.5, e3d=1);
//extruder_mount(screws=2, flip=1, fan_mount=1, mount_screw_rad=632_rad, angle=0, height=16, offset=0);
//translate([filament_offset, 33, 0]) rotate([0,0,180]) grooveclamp2(induction=0);

//bowden versions for bg8
mirror([1,0,0])		//I use this to make a left and right version for dualstrusion :-)
extruder(bowden_tap, none, m5, motor_mount_h=4.5);


//fan_shroud(length = 30, hotend_offset = 32, hotend_rad = 14);

/////////////////////////////////////////
//  Feel free to change more stuff.  Just don't whine as much if you break it :-)
/////////////////////////////////////////
filament_offset = eff_gear_rad+filament_rad/2;
height = filament_height+wall;

//40mm fan shroud.  Attaches between fan and extruder_mount tabs, with two holes to clamp the bottom to the fan as well.
module fan_shroud(length = 20, hotend_offset = 20, hotend_rad = 10){
	//This is sized for 40mm fan only.
	fan_hole_sep = 32;
	rad = (40-fan_hole_sep)/2;
	screw_rad = m3_rad+.1;
	center_rad = 40/2-wall/2;

	top_rad = 8;
	top_offset=7;
    
	difference(){
		union(){
			hull(){
				for(i=[-1,1]) for(j=[-1,1]) translate([i*fan_hole_sep/2,j*fan_hole_sep/2, 0])
					cylinder(r=rad, h=wall/2);
			}

			cylinder(r=center_rad+wall/2, h=length);
		}

		//screw holes
		for(i=[-1,1]) for(j=[-1,1]) translate([i*fan_hole_sep/2,j*fan_hole_sep/2, -.1]) {
			cylinder(r=m3_rad, h=wall);
			translate([0,0,wall/2]) cylinder(r1=m3_nut_rad+.1, r2=m3_nut_rad, h=wall*2, $fn=6);
		}
		//center hole
		translate([0,0,-.1]) cylinder(r=center_rad, h=50);

		//hollow out top
		translate([0,0,top_rad+wall/2]) hull(){
			translate([center_rad-top_offset,0,0]) rotate([90,0,0]) cylinder(r=top_rad, h=50, center=true);
			translate([center_rad+top_offset,0,0]) rotate([90,0,0]) cylinder(r=top_rad, h=50, center=true);
			translate([center_rad-top_offset,0,length]) rotate([90,0,0]) cylinder(r=top_rad, h=50, center=true);
		}

		//hotend clearance hole
		hull(){
			translate([0,0,hotend_offset]) rotate([0,90,0]) cylinder(r=hotend_rad, h=50, center=true);
			translate([0,0,hotend_offset*2]) rotate([0,90,0]) cylinder(r=hotend_rad, h=50, center=true);
		}
	}
}

//attaches the motor with one or two screws.
module extruder_mount(screws = 1, flip=0, fan_mount=0, mount_screw_rad = 632_rad, angle=0, height=15, offset=0, motor_offset=1){
	echo(height);
	wall=4;
	lower_hole_sep = 47.5;
	lower_hole_rad = 6+slop;
	lower_hole_height = -7.5;
	lower_hole_depth = 6;

	hole_sep=30;
	fan_hole_sep = 32;
	fan_offset= 5;
	
	scale_slop = 1.025;
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
				//translate([-motor_w/2+.05,0,height/2]) cube([.1,motor_w,height], center=true);
				translate([-motor_w/2-wall-wall/2+.05+1+offset,0,height/2]) rotate([0,0,angle]) cube([wall+1,motor_w,height], center=true);

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
		render() translate([0,motor_w/2+wall+mount_screw_rad+wall,height/2]) rotate([0,90,0]) clamp(height=height, 0, mount_screw_rad, 0);
		
		//mounting holes
		#translate([-motor_w/2-wall*2-.05,0,height/2]) rotate([0,0,angle]) {
			rotate([0,90,0]) rotate([0,0,-90]) translate([0,0,offset*2]) cap_cylinder(r=mount_screw_rad, h=200, center=true);
		
			translate([wall/2,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=mount_screw_rad*2, h=wall*3);
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
				translate([0,0,wall]) cylinder(r1=m3_nut_rad+.1, r2=m3_nut_rad+.4, h=wall*2, $fn=6);
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
			mirror([0,0,1]) translate([0,0,wall*1.5]) rotate([0,0,-90]) cylinder(r=632_nut_rad, h=len, $fn=4);
		}
		

		//screw is on the outside
		translate([0,0,wall*1.5]) rotate([0,0,-90]) cap_cylinder(r=mount_screw_rad*2, h=len);
	}
}

module extruder(type=0, mount = 0, idler = 0, e3d=0){
	difference(){
		union(){
			base(solid=1, h=motor_mount_h);
			body(solid=1, type=type, mount=mount, idler=idler, motor_mount_h=motor_mount_h, e3d=e3d);
		}

		base(solid=0, h=motor_mount_h-.5);
		body(solid=0, type=type, mount=mount, idler=idler, e3d=e3d);
	}
}

module body(solid = 0, type=0, mount=0, idler=0){
	rad = 3;
	h=50;
	fillet = 7;

	width = motor_w/2-rad*2+filament_rad;

	if(solid==1){
		intersection(){
			translate([motor_w/4,0,height/2]) minkowski(){
				cube([width,motor_w-rad*2,height], center=true);
				cylinder(r=rad, h=.1);
			}
			
			translate([0,0,h/2]) cube([motor_w, motor_w, h], center=true);
			cylinder(r=motor_r+slop, h=h, $fn=64);
		}
		translate([motor_w/4-width-rad/2-.3, 0, motor_mount_h]) difference(){
			translate([0,-(motor_w-rad*2)/2,0]) cube([fillet, motor_w-fillet, fillet]);
			translate([0,0,fillet]) rotate([90,0,0]) cylinder(r=fillet, h=motor_w-rad, center=true);
		}
		//hotend attachment
		translate([filament_offset,motor_w/2,filament_height]) rotate([-90,0,0]){
			if(type == 0)
				bowden_tap(1);
			if(type == 1)
				bowden_clamp(1);
			if(type == 2)
				groovemount(1,e3d=e3d);
                        if(type == 3)
				groovemount2(1,e3d=e3d);
			if(mount == 1)
				graber_i3_mount(1);
			if(mount == 2)
				wade_mount(1);
			if(mount == 3)
				i3_mount(1);
			if(mount == 4)
				kossel_mount(1);
		}

	}else{
	//hollow bits
		//drive gear
		hull(){
			%cylinder(r=eff_gear_rad, h=100, center=true); //idler dia
			//%cylinder(r=gear_rad, h=100, center=true); //idler dia
			cylinder(r=gear_rad+slop, h=100, center=true);
			//#translate([idler_offset,0,0]) cylinder(r=gear_rad+slop, h=100, center=true);
		}

		//filament
		translate([filament_offset,0,filament_height]) rotate([90,0,0]) rotate([0,0,180/8]) cylinder(r=filament_rad, h=100, center=true, $fn=8);

		//idler bolt
		//translate([5,0,0])	  //uncomment to check placement
		if(idler == m3){
			idler(idler_dia = 10, idler_thick = 4, idler_flat_rad = 3, idler_nut_rad = m3_nut_rad+.1, idler_nut_height = m3_nut_height+2, idler_bolt_rad = m3_rad);
		}else{
			idler(idler_dia = 16, idler_thick = 6, idler_flat_rad = 4, idler_nut_rad = m5_nut_rad, idler_nut_height = m5_nut_height, idler_bolt_rad = m5_rad);
		}

		//cone to guide/unguide filament
		translate([filament_offset,-1,filament_height]) for(i=[0,1]) mirror([0,i,0]) translate([0,-wall-1+2.5,0]) rotate([90,0,0]) rotate([0,0,180/8]) cylinder(r1=filament_rad*2, r2=filament_rad, h=3, $fn=8);

		//hotend attachment
		render() translate([filament_offset,motor_w/2,filament_height]) rotate([-90,0,0]){
			if(type == 0)
				bowden_tap(0);
			if(type == 1)
				bowden_clamp(0);
			if(type == 2)
				groovemount(0,e3d=e3d);
                        if(type == 3)
				groovemount2(0,e3d=e3d);
			if(mount == 1)
				graber_i3_mount(0);
			if(mount == 2)
				wade_mount(0);
			if(mount == 3)
				i3_mount(0);
			if(mount == 4)
				kossel_mount(0);
		}
		
		//flatten bottom
		translate([0,0,-20]) cube([100,100,40],center=true);
	}
}






module idler(idler_dia = 16, idler_thick = 6, idler_flat_rad = 4, idler_nut_rad = m5_nut_rad, idler_nut_height = m5_nut_height, idler_bolt_rad = m5_rad){

	idler_rad = idler_dia/2;

	slit_offset = filament_offset+filament_rad/2+(filament_rad/2+idler_rad-idler_bolt_rad)/2+.1;
	slit_l = 10;
	slit_w = 2;

	//idler mounting
	//translate([8,0,0]) //uncomment to check idler path
	translate([eff_gear_rad+idler_rad+idler_offset,0,0]){
		rotate([0,0,30]) translate([0,0,-wall/2]) cylinder(r1=idler_nut_rad+.5, r2 = idler_nut_rad, h=idler_nut_height+wall, $fn=6);
		translate([0,0,-wall/2+idler_nut_height+wall+layer_height]) cylinder(r=idler_bolt_rad, h=height);
		
		difference(){
			hull(){
				%translate([0,0,filament_height]) cylinder(r=idler_rad, h=idler_thick, center=true);//idler actual
				translate([0,0,filament_height+1]) cylinder(r=idler_rad+.75, h=idler_thick+4, center=true);
				translate([-idler_offset/2,0,filament_height+1]) cylinder(r=idler_rad+.75, h=idler_thick+4, center=true);
			}
		
			translate([0,0,filament_height-idler_thick/2-.5]) cylinder(r1=idler_rad+.75, r2=idler_flat_rad, h=2.5, center=true);
		}
	}

	//cut the slit
	translate([slit_offset,slit_l,0]) cylinder(r=slit_w/2, h=100, center=true);
	translate([slit_offset,slit_l-motor_w/2,0]) cube([slit_w,motor_w,100],center=true);

	//widen the slit bottom
	hull() {
		translate([slit_offset,0,0]) cylinder(r=slit_w/2, h=100, center=true);
		translate([slit_offset+slit_w/2,-motor_w/2,0]) cylinder(r=slit_w, h=100, center=true);	
	}

	//slit clamper
	render() translate([slit_offset,-(motor_w/2+gear_rad)/2,filament_height-wall-1.1]){
		hull(){	//this little bit lets the screw rotate with extreme clamp angles
			rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=wall*4+.1, center=true);
			translate([0,slit_w/2,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=.1, center=true);
			translate([0,-slit_w/2,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=.1, center=true);
		}
			
		translate([-wall*2-wall*4,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(tensioner_rad+slop, wall*4);
			
		translate([wall*2,0,0]) rotate([0,90,0]) cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=idler_nut_height*2, $fn=6);
	}
}

module bowden_tap(solid=1){
	thick = 6;
        inset=2;
	translate([0,0,-5]){
		if(solid==1){
			hull(){
				cylinder(r=bowden_tap_rad+thick, h=14, $fn=36);
				translate([0,(bowden_tap_rad+thick),-inset]) cylinder(r=bowden_tap_rad+thick, h=thick+inset, $fn=36);
			}
		
		}else{
			//slit
			translate([0,-10,thick/2+1-.01]) cube([bowden_tap_rad*2,20,thick+2], center=true);
                        translate([0,-10-wall-.1,-thick/2+1-.01]) cube([bowden_tap_rad*2,20,thick+2], center=true);
                        cylinder(r1=bowden_tap_rad, r2=bowden_tap_rad+.5, h=.5);
			translate([0,0,.5]) cap_cylinder(bowden_tap_rad+.5, thick+1.5);
			//for pass-through; bowden tube goes in a bit
			translate([0,0,-thick]) cap_cylinder(bowden_tube_rad, 10);
			//tap this to hold the bowden.
			cap_cylinder(bowden_tap_rad, 15);
                        //crop the top
                        translate([0,-25-wall-bowden_tap_rad,0]) cube([50,50,50],center=true);
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

module hotend_mount(solid = 1, induction = 0){
    fudge=15;
    ind_offset = -30;
    if(induction==1){
        translate([0,ind_offset,-wall]) mirror([0,1,0]) extruder_mount(solid, m_height=ind_height,  hotend_rad=ind_rad);
        if(solid==1) rotate([0,0,180]) translate([0,rad+wall+1.5,-wall]) cylinder(r=8+1, h=inset);
    }
    
    for(i=[180,90-fudge,270+fudge]) rotate([0,0,i]) translate([0,rad+wall+1.5,-wall]){
        if(solid==1){
            cylinder(r=632_nut_rad, h=inset);
        }
        if(solid==0){
            translate([0,0,-wall]) rotate([0,0,-i]) cap_cylinder(r=632_rad, h=inset+wall+.1);
            translate([0,0,inset]) rotate([0,0,-i]) cap_cylinder(r=632_cap_rad, h=inset+wall*2);
            translate([0,0,-632_nut_height])  hull() {
                echo(inset);
                rotate([0,0,45]) cylinder(r=632_nut_rad, h=632_nut_height, $fn=4);
                translate([0,wall,0])  rotate([0,0,45]) cylinder(r=632_nut_rad, h=632_nut_height, $fn=4);
            }

        }
    }
}

module extruder_mount(solid = 1, m_height = 10, fillet = 8, tap_height=0, width=20){
        wall=5;
        m_thickness = wall*2+1+1;
	gap = 2;
	tap_dia = 9.1;
	tap_rad = tap_dia/2;

	if(solid){		
		//clamp material
		if(m_height > nut_rad*2){
			cylinder(r=(hotend_rad+wall)/cos(30), h=m_height, $fn=6);
			translate([hotend_rad+bolt_rad+1,gap,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
			translate([hotend_rad+bolt_rad+1,-wall-1,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
		}
	}else{
		union(){
			//hotend hole
			translate([0,0,-.05]) cylinder(r=hotend_rad/cos(180/18)+.1, h=m_height+40, $fn=36);

			//bolt slots
			if(m_height > nut_rad*2){
				render() translate([hotend_rad+bolt_rad+1,-m_thickness-.05,m_height/2]) rotate([-90,0,0]) cap_cylinder(r=632_rad, h=m_thickness+10);
				translate([hotend_rad+bolt_rad+1,-wall*2-1,m_height/2]) rotate([-90,0,0]) cylinder(r=632_nut_rad, h=wall, $fn=4);

				//mount tightener
				translate([hotend_rad+bolt_rad+1,wall+gap+1,m_height/2]) rotate([-90,0,0]) cylinder(r=632_cap_rad, h=10);
				translate([0,0,-.05]) cube([wall*5, gap, m_height+.1]);
			}
		}
	}
}

module grooveclamp(solid=1, induction=0){
    dia = 16;
    groove_dia = 12;
    rad = dia/2+slop;
    groove_rad = groove_dia/2+slop;
    height = 4.25;
    inset = height;
    difference(){
        union(){
            hull(){
                translate([0,0,wall]) hotend_mount(1, rad=rad, inset=inset);
            }
            if(induction==1){
                translate([0,0,wall]) hotend_mount(1, rad=rad, inset=inset, induction=induction);
            }
        }
        
        translate([0,0,wall]) hotend_mount(0, rad=rad, inset=inset, induction=induction);
        
        %translate([0,0,-.1]) cylinder(r=22/2+slop, h=.2);
        
        //hotend cutout
        translate([0,0,-.1]) {
            cylinder(r=groove_rad, h=inset+1);
            translate([0,6,0]) hull(){
                cylinder(r=groove_rad, h=inset+1);
                translate([0,10,0]) cylinder(r=groove_rad, h=inset+1);
            }
        }
    }
}

module groovemount(solid=1, e3d=0){
	dia = 16;
	rad = dia/2+slop;
	mink = 1;
	inset = 3;
	groove = 7;
    
        frad = 1.5;
        flen = 9.3;

	screw_inset = 4.2;
	screw_offset = rad-.5;
	screw_height = rad+m3_nut_height+wall;
	

	width = filament_height*2+wall/2+mink/2;
	
	screw_baserad = screw_inset/cos(180/4)-1.5;
	
	motor_angle=0;
	
	if(solid==1){
                //fillet
                translate([0,-wall-.1,-wall*2-2]) rotate([0,90,0]) difference(){
                    cylinder(r=frad, h=flen, $fn=4, center=true);
                    translate([frad,frad,0]) cylinder(r=frad, h=flen+1, $fn=32, center=true);
                    translate([frad,-frad,0]) cylinder(r=frad, h=flen+1, $fn=32, center=true);
                }
                hull(){
                    minkowski(){
                            translate([0,0,-wall*2-mink]) rotate([0,0,180/16]) cylinder(r=(wall+rad-mink+1)/cos(180/16), h=inset+wall*1, $fn=16);
                            sphere(r=mink, $fn=18);
                    }
                    
                       
                    //three hotend mounting lugs
                    hotend_mount(1, rad=rad, inset=inset);
                }
	}else{
		translate([0,0,-wall]) cap_cylinder(rad, inset+.1, $fn=90);
            
                
                if(e3d==1){  //tube insets for e3d
                    translate([0,0,-wall-1]) cap_cylinder(r=4.1, h=1.2);
                    translate([0,0,-wall-wall]) cap_cylinder(r=bowden_tube_rad, h=wall+1);
                }
		//backstop
		translate([0,0,-wall]) cylinder(r=rad+slop*2, h=slop*2);
                
                //three hotend mounting lugs
                hotend_mount(0, rad=rad, inset=inset);
	}
}

module groovemount2(solid=1,e3d=1){
    dia = 16;
    rad = dia/2+slop;
    mink = 1;
    inset = 3;
    groove = 9;
    thick = 5;
    length = 10;
    
    screw_inset = 4.2;
    screw_offset = rad+1;
    screw_height = rad+m3_nut_height+wall;

    if(solid){
        hull(){
            minkowski(){
                translate([0,0,-wall*2-mink]) rotate([0,0,180/16]) cylinder(r=(wall+rad-mink+1)/cos(180/16), h=inset+wall+groove, $fn=16);
                sphere(r=mink, $fn=18);
            }
            
            minkowski(){
                translate([0,-(-rad-wall*2)/2,-wall+groove/2]) cube([(rad+wall+1)*2-mink*2, rad+wall*2, groove+2-mink*2], center=true);
                sphere(r=mink, $fn=18);
            }
           
            translate([0,filament_height,0]) rotate([90,0,0])  cylinder(r=4, h=.1, center=true);
            }
    }else{
        //hotend holes
       render(){
           translate([0,0,-inset-wall*2]) hull(){
               cap_cylinder(r=bowden_tube_rad, h=wall*3);
               translate([0,-3,0]) cap_cylinder(r=bowden_tube_rad, h=wall*3);
           }
           translate([0,0,-inset-2]) hull(){
               cap_cylinder(r=4+slop, h=wall);
               translate([0,-3,0]) cap_cylinder(r=4+slop, h=wall);
           }
           
           //the groove
           translate([0,0,-inset]) hull(){
               cap_cylinder(r=12/2+slop*3, h=13, $fn=90);
               translate([0,-3,0]) cap_cylinder(r=12/2+slop*3, h=13, $fn=90);
           }
           
           translate([0,0,-inset]) difference(){
               cap_cylinder(r=rad, h=13, $fn=90);
               translate([0,0,4.25]) cylinder(r=rad+1, h=6-slop*3);
           }
       }
        
        //backstop
        translate([0,0,-inset]) cylinder(r=rad+slop*2, h=slop*2);
        
        //clamp cutout
        translate([0,-rad-1.5,-inset+20]) cube([rad*2+wall*3+20,rad*2,40+12], center=true);
        
        //hotend screwholes/nut traps
        *for(i=[0,1]) mirror([i,0,0]) translate([screw_offset,0,-wall+groove]) rotate([90,0,0]){
            translate([0,0,0]) cylinder(r=m3_rad, h=rad*3, center=true);
            translate([0,0,m3_nut_height+.3]) cylinder(r=m3_rad, h=rad);
            //translate([0,0,m3_nut_height+wall/2+.3]) cylinder(r=m3_cap_rad, h=rad);
            hull(){
                rotate([0,0,30]) cylinder(r=m3_nut_rad+slop, h=m3_nut_height+slop*2, $fn=6);
                translate([0,wall*3,0]) rotate([0,0,30]) cylinder(r=m3_nut_rad+slop, h=m3_nut_height+slop*2, $fn=6);
           }
       }
       
       //zip tie slot!  WHAT YOU SAY!?  MORE ZIP TIES!?  I'm outta control, yo.
       translate([0,0,1.75]) difference(){
           cylinder(r=rad+2+.5, h=4.5, $fn=60);
           translate([0,0,-.05]) cylinder(r=rad+.5, h=5.1, $fn=60);
       }
       translate([0,0,-inset-6]) difference(){
           cylinder(r=5+2, h=4, $fn=60);
           translate([0,0,-.05]) cylinder(r=5, h=4.1, $fn=60);
       }
    }
}

module groovescrewmount(solid=1){
	dia = 16;
	rad = dia/2+slop;
	mink = 1;
	inset = 11.5;
	groove = 7;

	screw_inset = 4.2;
	screw_offset = rad-.5;
	screw_height = rad+m3_nut_height+wall;
	

	width = filament_height*2+wall/2+mink/2;
	
	screw_baserad = screw_inset/cos(180/4)-1.5;
	
	motor_angle=0;
	
	if(solid==1){
                hull(){
                    minkowski(){
                            translate([0,0,-wall*2-mink]) rotate([0,0,180/16]) cylinder(r=(wall+rad-mink+1)/cos(180/16), h=inset+wall*1, $fn=16);
                            sphere(r=mink, $fn=18);
                    }
                    
                    translate([0,filament_height,0]) rotate([90,0,0])  cylinder(r=4, h=.1, center=true);
                }
		
		//bolts to hold hotend in
                minkowski(){
                    translate([0,(-rad-wall*2)/2,-wall+groove]) cube([(rad+wall+1)*2-mink*2, rad+wall*2-mink*2, groove+2-mink*2], center=true);
                    sphere(r=mink, $fn=18);
                }
		
		//translate([0,0,wall/2]) mount_plate(1, motor_angle);
	}else{
		translate([0,0,-wall]) cap_cylinder(rad, inset+.1, $fn=90);
		//backstop
		translate([0,0,-wall]) cylinder(r=rad+slop*2, h=slop*2);
		//hotend bolts
		for(i=[0,1]) mirror([i,0,0]) translate([screw_offset,-rad-1,-wall+groove]) rotate([90,0,0]){
			translate([0,0,-rad-1]) cylinder(r=m3_rad, h=rad+1.2);
			translate([0,0,m3_nut_height+.3]) cylinder(r=m3_rad, h=rad);
			translate([0,0,m3_nut_height+wall/2+.3]) cylinder(r=m3_cap_rad, h=rad);
			hull(){
				rotate([0,0,30]) cylinder(r=m3_nut_rad+slop, h=m3_nut_height+slop*2, $fn=6);
				translate([0,wall*3,0]) rotate([0,0,30]) cylinder(r=m3_nut_rad+slop, h=m3_nut_height+slop*2, $fn=6);
			}
		}

		//translate([0,0,wall/2]) mount_plate(0,motor_angle);
	}
}

module graber_i3_mount(solid=1){
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
				translate([0,0,-wall-.1]) cap_cylinder(r=632_cap_rad, h=wall+.15);
				translate([0,0,-wall*5-.1]) cylinder(r2=632_cap_rad, r1=632_rad, h=wall*4);
			}

			//hollows for other screws on carriage
			translate([filament_height+wall,-width/2+upper_hole_sep/2-bolt_width/2,ext_height-upper_hole_height]) translate([-wall-1,bolt_width/2,0]) rotate([0,90,0]) cylinder(r=upper_hole_rad+slop, h=wall*3);
			translate([filament_height+wall,-width/2-upper_hole_sep/2-bolt_width/2,ext_height-upper_hole_height]) translate([-wall-1,bolt_width/2,0]) rotate([0,90,0]) cylinder(r=upper_hole_rad+slop, h=wall*3);
		
		}
	}
}

module i3_mount(solid=1){
	rad = 1;
	bolt_width = 30;
	width = bolt_width+632_rad*2+wall*2;
	ext_height = 8;

	upper_hole_sep = 47.5;
	upper_hole_rad = -5.25;
	upper_hole_height = 7.5;

	//uses m3 instead of 6-32.

	base_height = filament_height;

	if(solid==1){
		translate([-wall,base_height,0]) 
		union(){
			hull(){
				translate([filament_height+wall,-width/2,ext_height]) {
					for(i=[0,1]) mirror([0,i,0])  translate([0,bolt_width/2,0]) rotate([0,90,0]) {
						cylinder(r=m3_rad+wall, h=wall*2, center=true);
					}
					translate([0,bolt_width/2,-ext_height]) rotate([0,90,0]) cylinder(r=m3_rad+wall*2, h=wall*2, center=true);
				}
			}
			//bottom little plate
			//translate([filament_offset,motor_w/2,filament_height])
			*intersection(){
				translate([-filament_offset+wall/2,-wall/2,0]) cube([motor_w+wall,wall,wall*3], center=true);
				hull(){
					translate([-filament_offset, 0, -motor_w/2-wall/2]) rotate([90,0,0]) cylinder(r=motor_r+slop, h=wall, $fn=64);
				translate([motor_r, 0, -motor_w/2+wall*2]) rotate([90,0,0]) cylinder(r=motor_r+wall/2, h=wall, $fn=64);
				}
			}
		}
	}else{
		translate([-wall,base_height,0]) {
			translate([filament_height+wall,-width/2,ext_height]) for(i=[-1,1]) translate([0,i*bolt_width/2,0]) rotate([0,90,0]) {
				cap_cylinder(m3_rad, 100, center=true);
				translate([0,0,-wall-.1]) cap_cylinder(r=m3_cap_rad, h=wall+.15);
				translate([0,0,-wall*5-.1]) cylinder(r2=m3_cap_rad, r1=m3_rad, h=wall*4);
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

module kossel_mount(solid = 1){
	offset = 13.25;
	h1 = 15/2+2.25;
	chan = 4; //the channel depth
	screw = 8;	//screw length for the attachment
	washer_rad = 7/2+slop;
	rotate([0,90,0]){
		for(i=[offset, motor_w-offset]){
			translate([i, filament_height,motor_w/2-filament_offset])
			rotate([90,0,0]){
				if(solid==1){
					hull(){
						translate([0,h1,0]) cylinder(r=m3_cap_rad+wall, h=wall*2, $fn=6);
						cylinder(r=m3_cap_rad+wall, h=wall*2, $fn=6);
					}
					translate([-(m3_cap_rad+wall),0,wall*2-.1]) cube([m3_cap_rad*2+wall*2,5,5]);
				}else{
					translate([0,h1,-.1]) cylinder(r=m3_rad, h=wall*2);
                    translate([0,h1,screw-chan]) cylinder(r=washer_rad, h=wall*10, $fn=32);
					translate([-(m3_cap_rad+wall)-.1,0,wall*2-.1]) rotate([0,90,0]) translate([-5,5,0]) cylinder(r=5,h=m3_cap_rad*2+wall*2+.2);
				}
			}
		}
	}
/*ddddd	}else{
		rotate([0,90,0]){
			translate([offset,-height+filament_height,motor_w/2-filament_offset-wall*2])
			translate([0,-h1,-.1]) cap_cylinder(r=m3_rad, h=wall*3);
			translate([motor_w-offset,-height+filament_height,motor_w/2-filament_offset-wall*2])
			translate([0,-h2,-.1]) cap_cylinder(r=m3_rad, h=wall*3);
		}	
	}*/	
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
