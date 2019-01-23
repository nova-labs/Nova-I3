hole_sep = 30;
hole_sep_2 = 20;
slop = .1;
lower_hole_sep = 50;
lower_hole_rad = 5.5+slop;
lower_hole_height = -7.5;



%cube([9,9,100],center=true);

wall=4;
m_thickness = wall*2+1+1;
hotend_attachment_rad = 23;  

//hotend stuff
hotend_rad = 8+slop+slop;

//standard stuff
bolt_slop = .5;
nut_slop = .85;
bolt_dia = 5+bolt_slop;
bolt_rad = bolt_dia/2;
bolt_cap_dia = 10+bolt_slop;
bolt_cap_rad = bolt_cap_dia/2;
nut_dia = 9+nut_slop;
nut_rad = nut_dia/2;
nut_height = 3.25;
lock_nut_height = 5.25;

m3_nut_rad = 6/cos(30)/2;
m3_nut_height = 3;
m3_rad = 1.8;
m3_cap_rad = 3.25;
m3_cap_height = 2;

632_dia = 3.5;
632_rad = 632_dia/2+slop;
632_nut_rad = 8.25/cos(45)/2;
632_cap_dia = 7;
632_cap_rad = 632_cap_dia/2+slop;
632_cap_height = 2+slop;
632_nut_height = 5;

//the radius of the induction sensor
ind_rad = 18/2+slop*2;
ind_offset = -30;
ind_height = 12;

fan_offset = -15;

//not sure why these are needed
arm_rad = wall*1.75;
nut_mount = wall+nut_height/2;	//thickness behind cone
arm_sep = 54;

e3d_fin_rad = 23/2;  //////////23 for the e3d V6; the V5 is 26 
echo("Nozzle Sep = ", e3d_fin_rad*2);
extruder_sep = e3d_fin_rad*2;


//bowden_mount2(hole_sep=30);
bowden_mount2_inline();
//translate([0,25,0]) nut_trap();
//translate([0,50,0]) fan_duct(clip_height=25); 
//translate([0,50,0]) fan_duct_induction(clip_height=35, e3d_fin_rad = 26/2); //v5
//translate([0,50,0]) fan_duct_induction(clip_height=25, e3d_fin_rad = 23/2); //v6

//translate([0,-50, 0])
//mirror([1,0,0]) cyclops_mount();

//inline_mount(left_inset=0, mount_sep = 20);


$fn=32;

module nut_trap(){
	difference(){
		union(){
			translate([0,0,wall/6]) cube([hole_sep,wall*2,wall/3], center=true);
			for(i=[0:1]) mirror([i,0,0]) translate([hole_sep/2,0,0]) cylinder(r=632_nut_rad+wall/2,h=632_nut_height, $fn=4);
		}
		for(i=[0:1]) mirror([i,0,0]) translate([hole_sep/2,0,0]){
			translate([0,0,1]) cylinder(r=632_nut_rad,h=632_nut_height, $fn=4);
			translate([0,0,-1]) cylinder(r=632_rad,h=632_nut_height);
		}
	}
}

module fan_duct_induction(clip_height = 40, wire_offset = 4){
        extruder_sep = e3d_fin_rad*2;
    
    	height = 40;
	fan_w = 40;
	fan_screwhole = 32/2;
	fan_rad = 36/2;

	ductwall = 3.5;

	cutoff = 45;
    
        unclip_height = 40-clip_height;
    
        translate([0,0,height/2]) rotate([90,0,0])
	difference(){
                union(){
                    hull(){
			//fan
			translate([0,0,wall/2]) rotate([0,45,0]) translate([0,0,fan_offset]) cube([fan_w, fan_w, wall], center=true);
                        //translate([0,height/2-unclip_height/2,extruder_sep+wall/2+wire_offset]) cube([extruder_sep+e3d_fin_rad*2+ductwall,unclip_height,wall], center=true);

                        //the e3d body, with a gap for the wires to pop up
			for(i=[-1,1]) for(j=[0,wire_offset]) translate([i*extruder_sep/2,0,extruder_sep/2+wall+j]) rotate([90,0,0]) cylinder(r=e3d_fin_rad+ductwall/2, h=height, center=true);
                            
                        
                    }
                    //the induction sensor mount
                    translate([extruder_sep/2,-height/2,extruder_sep/2+wall+wire_offset+ind_offset]) rotate([-90,0,0]) extruder_mount(1, m_height=ind_height, hotend_rad=ind_rad);
                    
		}
                //induction mount
                translate([extruder_sep/2,-height/2,extruder_sep/2+wall+wire_offset+ind_offset]) rotate([-90,0,0]) extruder_mount(0, m_height=ind_height,  hotend_rad=ind_rad);
                
                //the e3d holes
                #for(i=[-1,1]) translate([i*extruder_sep/2,0,extruder_sep/2+wall+wire_offset]) rotate([90,0,0]) cylinder(r=e3d_fin_rad, h=height+2, center=true);
                
                hull()
                    for(i=[-1,1]) translate([i*extruder_sep/2-wire_offset/2*i+5*i,0,wall+wire_offset/2]) {
                        rotate([90,0,0]) cylinder(r=wire_offset/2, h=height+ductwall*2, center=true);
                        translate([0,0,5]) rotate([90,0,0]) cylinder(r=wire_offset/2, h=height+ductwall*2, center=true);
                    }
                    
                //cutout around the hotend clamps
                hull(){
                    translate([0,height/2-unclip_height+wall/2,wall+wall]) rotate([0,90,0]) cylinder(r=wall/2, h=100, center=true);
                    translate([0,height/2-unclip_height+wall/2,wall+wall+height]) rotate([0,90,0]) cylinder(r=wall/2, h=100, center=true);
                    translate([0,height,wall+wall]) rotate([0,90,0]) cylinder(r=wall/2, h=100, center=true);
                }

		//cutout for clipping on
                for(i=[0,1]) mirror([i,0,0]) translate([extruder_sep/2,-height/2-.1,extruder_sep/2+wall+wire_offset]){
                     rotate([0,-90+cutoff,0]) difference(){
                        cube([extruder_sep,height+1, extruder_sep]);
                        rotate([-90,0,0]) translate([e3d_fin_rad+ductwall/4,0,-.1]) cylinder(r=ductwall/4, h=height+3, $fn=16);
                    }
                }
                
		//translate([0,0,50+cutoff]) cube([100,100,100], center=true);
		//cutoff the center
		translate([0,0,50+wall]) cube([extruder_sep,100,100], center=true);

		//fan
                difference(){
                    hull(){
                        translate([0,0,wall/2]) rotate([0,45,0]) translate([0,0,fan_offset-wall/2-.1]) cylinder(r=fan_rad,h=wall);
                        translate([0,0,wall]) cylinder(r=fan_rad,h=.1);
                    }
                     translate([extruder_sep/2,-height/2,extruder_sep/2+wall+wire_offset+ind_offset]) rotate([-90,0,0]) extruder_mount(0, m_height=ind_height,  hotend_rad=ind_rad+1);
                }
                translate([0,0,wall]) cylinder(r=fan_rad,h=wall);
                
                //fan mount
                translate([0,0,wall/2]) rotate([0,45,0]) translate([0,0,fan_offset]) {
                    for(i=[0:90:359]) rotate([0,0,i]) translate([fan_screwhole, fan_screwhole, -.1]){
                            cylinder(r=m3_rad, h=wall*4, center=true);
                            translate([0,0,wall/2-.1]) cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=wall*3, $fn=6);
                    }
                }
	}
}

module fan_duct(clip_height = 40, wire_offset = 8){
	height = 40;
	fan_w = 40;
	fan_screwhole = 32/2;
	fan_rad = 36/2;

	ductwall = 3.5;

	cutoff = 40;
    inset = .25;
    
        unclip_height = 40-clip_height;

        echo(unclip_height);
    
	translate([0,0,height/2]) rotate([90,0,0])
	difference(){
                union(){
                    hull(){
			//fan
			translate([0,0,wall/2]) cube([fan_w, fan_w, wall], center=true);
                        //translate([0,height/2-unclip_height/2,extruder_sep+wall/2+wire_offset]) cube([extruder_sep+e3d_fin_rad*2+ductwall,unclip_height,wall], center=true);

			for(i=[-1,1]) for(j=[0,wire_offset]) translate([i*(extruder_sep/2-inset),0,extruder_sep/2+wall+j]) rotate([90,0,0]) cylinder(r=e3d_fin_rad+ductwall/2, h=height, center=true);
                            
                    }
                    *hull(){
                         #translate([0,height/2-unclip_height/2,extruder_sep+wall/2+wire_offset]) cube([extruder_sep+e3d_fin_rad*2+ductwall,unclip_height,wall], center=true);
                         #for(i=[-1,1]) translate([i*extruder_sep/2,height/2,extruder_sep/2+wall+wire_offset]) rotate([90,0,0]) cylinder(r=e3d_fin_rad+ductwall/2, h=unclip_height+wall);
                    }
		}
                
                for(i=[-1,1]) translate([i*(extruder_sep/2-inset),0,extruder_sep/2+wall+wire_offset]) rotate([90,0,0]) cylinder(r=e3d_fin_rad, h=height+2, center=true);
                
                for(i=[-1,1]) translate([i*extruder_sep/2-wire_offset/2*i,0,extruder_sep/2+wall-wire_offset/2]) rotate([90,0,0]) cylinder(r=e3d_fin_rad-wire_offset/2, h=height+ductwall*2, center=true);
                    
                //cutout around the hotend clamps
                //translate([0,height/2-unclip_height/2,wall+height/2+wall/2]) cube([extruder_sep+e3d_fin_rad*3,unclip_height+.1,height], center=true);
                hull(){
                    translate([0,height/2-unclip_height+wall/2,wall+wall/2]) rotate([0,90,0]) cylinder(r=wall/2, h=100, center=true);
                    translate([0,height/2-unclip_height+wall/2,wall+wall+height]) rotate([0,90,0]) cylinder(r=wall/2, h=100, center=true);
                    translate([0,height,wall+wall/2]) rotate([0,90,0]) cylinder(r=wall/2, h=100, center=true);
                }

		//cutout for clipping on
                for(i=[0,1]) mirror([i,0,0]) translate([extruder_sep/2,-height/2-.1,extruder_sep/2+wall+wire_offset]){
                     rotate([0,-90+cutoff+5,0]) difference(){
                        cube([extruder_sep,height+1, extruder_sep]);
                        rotate([-90,0,0]) translate([e3d_fin_rad+ductwall/4-inset*3/4,0,-.1]) cylinder(r=ductwall/4, h=height+3, $fn=16);
                    }
                }
                
                
                    
                
		//translate([0,0,50+cutoff]) cube([100,100,100], center=true);
		//cutoff the center
		translate([0,0,50+wall]) cube([extruder_sep,100,100], center=true);

		//fan
		cylinder(r=fan_rad,h=height*2, center=true);
		for(i=[0:90:359]) rotate([0,0,i]) translate([fan_screwhole, fan_screwhole, -.1]){
			cylinder(r=m3_rad, h=wall*4);
			translate([0,0,wall/2-.1]) cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=wall*4, $fn=6);
		}
	}
}

//mounting holes for the cyclops
module cyclops_holes(solid=0, jut=0){
    hole_sep = 9;
    hole_zsep = 10;
    ind_jut = 2;
    
    for(i=[0,1]) mirror([i,0,0]){
        translate([hole_sep/2,-wall,hole_zsep]) rotate([-90,0,0]){
            if(solid>=0){
                cylinder(r=m3_rad+wall, h=wall);
                if(jut==1){
                    translate([0,0,wall-.1]) cylinder(r1=m3_rad+wall, r2=m3_rad+wall/2, h=ind_jut+.1);
                }
            }
            if(solid<=0) translate([0,0,-.1]) {
                cap_cylinder(r=m3_rad, h=wall*2);
                cap_cylinder(r=m3_cap_rad, h=m3_cap_height);
            }
        }
    }
    
    translate([0,-wall,0]) rotate([-90,0,0]){
        if(solid>=0){
            cylinder(r=m3_rad+wall, h=wall);
            if(jut==1){
                translate([0,0,wall-.1]) cylinder(r1=m3_rad+wall, r2=m3_rad+wall/2, h=ind_jut+.1);
            }
        }
        if(solid<=0) translate([0,0,-.1]) {
            %translate([0,-5,9+wall+ind_jut+.1]) cube([30,30,18], center=true);
            %translate([0,-5,6+wall+ind_jut+.1]) rotate([90,0,0]) cylinder(r=1, h=50, center=true);
            cap_cylinder(r=m3_rad, h=wall*2);
            cap_cylinder(r=m3_cap_rad, h=m3_cap_height);
        }
    }
}

module i3_holes(solid=0){
    attach_height=0;
    for(i=[0,1]) mirror([i,0,0]){
        translate([lower_hole_sep/2,-wall,attach_height]) rotate([-90,0,0]){
            if(solid>=0)
                cylinder(r=632_rad+wall, h=wall);
            if(solid<=0) translate([0,0,-.1]) {
                cap_cylinder(r=632_rad, h=wall*2);
                //translate([0,0,wall-632_cap_height]) 
                translate([0,0,1.5]) 
                cap_cylinder(r=632_cap_rad, h=632_cap_height+wall);
            }
        }
    }
}

module cyclops_mount(induction=1){
    mount_height = 20+5;
    e3d_mount_height = wall;
    e3d_mount_offset = 15;
    ind_offset=(16-18)/2;
    wall=4;
    
    difference(){
        union(){
            hull(){
                for(i=[0,1]) mirror([i,0,0])
                    translate([e3d_mount_offset,0,e3d_mount_height]) cyclops_holes(1, wall=wall);
                translate([0,0,mount_height]) i3_holes(1, wall=wall);
            }
            if(induction==1){
                translate([-e3d_mount_offset,ind_rad+ind_offset,0]) rotate([0,0,90]) extruder_mount(1, m_height=ind_height, hotend_rad=ind_rad, wall=wall);
            }
            
            translate([e3d_mount_offset,0,e3d_mount_height]) cyclops_holes(1, jut=1, wall=wall);
        }
        
        translate([e3d_mount_offset,0,e3d_mount_height]) cyclops_holes(-1, wall=wall);
        translate([0,0,mount_height]) i3_holes(-1, wall=wall);
        if(induction==1){
            translate([-e3d_mount_offset,ind_rad+ind_offset,0]) rotate([0,0,90]) extruder_mount(0, m_height=ind_height, hotend_rad=ind_rad, wall=wall);
        }
        
        //cut off back and base
        translate([0,-50-wall,0]) cube([100,100,100], center=true);
        translate([0,0,-50]) cube([100,100,100], center=true);
    }
    
}

$fn=32;
module inline_mount(height=14, left_inset=0, wall=5, mount_sep = 20, induction=true){
    extruder_sep = e3d_fin_rad*2;
    attach_height = height+3;

	echo(e3d_fin_rad);
	echo(hotend_rad);
   
	 x_offset=(mount_sep-extruder_sep)/2;
	 y_offset=left_inset*3/4+2;
     
    difference(){
		  union(){
			  translate([-wall/2+x_offset-3,wall,0]) hull(){
			  	cylinder(r=wall, h=height);
				translate([30+wall,0,0]) cylinder(r=wall, h=height);
			  }

		  	  translate([x_offset,y_offset,0]){
				translate([0,e3d_fin_rad,0]) mirror([1,0,0]) rotate([0,0,60]) extruder_mount(1,height,0,0, wall=wall);
				translate([extruder_sep,e3d_fin_rad,0]) rotate([0,0,60]) extruder_mount(1,height,0,0, wall=wall);
			  }
        }
		  
        translate([x_offset,y_offset,0]) {
			translate([0,e3d_fin_rad,0]) mirror([1,0,0]) rotate([0,0,60]) extruder_mount(0,height,0,0);
        	translate([extruder_sep,e3d_fin_rad,0]) rotate([0,0,60]) extruder_mount(0,height,0,0);
		  }
        
        //mounting holes
        for(i=[0,mount_sep]) translate([i,e3d_fin_rad,height/2]) rotate([90,0,0]) {
            rotate([0,0,180]) cap_cylinder(r=m3_rad, h=50);
			translate([0,0,-y_offset]) rotate([0,0,180]) cap_cylinder(r=m3_cap_rad, h=hotend_rad+wall/2+.5);
            rotate([20,0,0]) translate([0,2,-y_offset-hotend_rad*3]) rotate([0,0,180]) cap_cylinder(r=m3_rad+1, h=hotend_rad*4);
        }
	
		  //flatten the back
		  translate([0,-50,0]) cube([100,100,100], center=true);
    		
		  //cut into the left side - to avoid the induction sensor mount
		  translate([extruder_sep/2+50+x_offset,-50+left_inset,0]) cube([100,100,100], center=true);
	}
}

module bowden_mount(height=14, induction = 1){
        extruder_sep = e3d_fin_rad*2;
        attach_height = height+3;
    
    ind_height = 10;
    
    angle = 15;
    
	difference(){
		union(){
			for(i=[0,1]) mirror([i,0,0]) translate([extruder_sep/2,e3d_fin_rad-hotend_rad,0]) rotate([0,0,angle]) extruder_mount(1,height,0,0);

			//mount supports
			hull(){
				for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/2,-hotend_rad-wall,attach_height]) rotate([-90,0,0]) cylinder(r=632_rad+wall, h=wall);
				for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/3,-hotend_rad-wall,632_rad+wall]) rotate([-90,0,0]) rotate([0,0,-180/5/2]) cylinder(r=(632_rad+wall)/cos(180/5), h=wall, $fn=5);
			}

			//fillet
			difference(){
				translate([0,-hotend_rad,height+wall/2-.01]) cube([extruder_sep+(hotend_rad/cos(180/18)+.1+wall)/cos(30),wall*2,wall], center=true);
				translate([0, wall/2, wall/2]) translate([0,-hotend_rad+wall/2-.05,height+wall/2-.05]) rotate([0,90,0]) cylinder(r=wall, h=hole_sep+632_rad*2+wall*2+1, center=true);
			}
                        
                        if(induction==1){
                            translate([0,e3d_fin_rad*2-hotend_rad+ind_rad,0]) rotate([0,0,90]) extruder_mount(1, m_height=ind_height, hotend_rad=ind_rad);
                        }
		}
                if(induction==1){
                    translate([0,e3d_fin_rad*2-hotend_rad+ind_rad,0]) rotate([0,0,90]) extruder_mount(0, m_height=ind_height, hotend_rad=ind_rad);
                }
                        
		for(i=[0,1]) mirror([i,0,0]) translate([extruder_sep/2,e3d_fin_rad-hotend_rad,0]) rotate([0,0,angle]) extruder_mount(0,height,0,0);

		//holes
		for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/2,-hotend_rad-wall-.1,attach_height]) rotate([-90,0,0]) {
			cap_cylinder(r=632_rad, h=wall+1);
			//translate([0,0,wall-632_cap_height]) cap_cylinder(r=632_cap_rad, h=wall+1);
	
			//hollows for other screws on mount
			translate([lower_hole_sep/2-hole_sep/2, -lower_hole_height, 0]) cap_cylinder(r=lower_hole_rad, h=wall+1);
		}

	}
}

//this is the current Nova I3 model.
module bowden_mount2(height=14, induction = 1, hole_sep=20){
        extruder_sep = e3d_fin_rad*2;
        attach_height = height+10;
        attach_access = -15*-1;
        mount_jut = wall+wall/2; //the distance the mount sticks out past the hotend radius
        
    
    ind_height = 10;
    ind_jut = e3d_fin_rad*2-hotend_rad+ind_rad + 2.5;
    
    echo("Induction Offset from Extruder 0");
    echo("X:",extruder_sep/2);
    echo("Y:",ind_jut-e3d_fin_rad);
    
    angle = 15;
    
	difference(){
		union(){
			for(i=[0,1]) mirror([i,0,0]) translate([extruder_sep/2,e3d_fin_rad-hotend_rad,0]) rotate([0,0,angle]) extruder_mount(1,height,0,0);

			//mount supports
			//hull(){
				for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/2,-hotend_rad-mount_jut,attach_height]) rotate([-90,0,0]) hull(){
                    cylinder(r=632_rad+wall*1.5, h=wall*2);
                    #translate([0,attach_height,0]) cylinder(r=632_rad, h=wall*2);
                }
				//for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/3,-hotend_rad-wall,632_rad+wall]) rotate([-90,0,0]) rotate([0,0,-180/5/2]) cylinder(r=(632_rad+wall)/cos(180/5), h=wall, $fn=5);
			//}
            if(induction==1){
                translate([0,ind_jut,0]) rotate([0,0,90]) extruder_mount(1, m_height=ind_height, hotend_rad=ind_rad);
            }
		}
        if(induction==1){
            translate([0,ind_jut,0]) rotate([0,0,90]) extruder_mount(0, m_height=ind_height, hotend_rad=ind_rad);
        }
                        
		for(i=[0,1]) mirror([i,0,0]) translate([extruder_sep/2,e3d_fin_rad-hotend_rad,0]) rotate([0,0,angle]) extruder_mount(0,height,0,0);

		//holes
		for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/2,-hotend_rad-mount_jut-.1,attach_height]) rotate([-90,0,0]) {
			cap_cylinder(r=632_rad, h=wall+1);
			translate([0,0,3]) cap_cylinder(r=632_cap_rad, h=wall*2);
            translate([0,0,5]) rotate([attach_access,0,0]) cap_cylinder(r=632_cap_rad, h=wall*10);
		}
        
        //clean the bottle
        translate([0,0,-50]) cube([100,100,100], center=true);
	}
}

//this is the bowden hotends+induction inline.
module bowden_mount2_inline(height=14, induction = 1, hole_sep=20){
        extruder_sep = e3d_fin_rad*2;
        attach_height = m3_cap_rad;
        attach_access = -15;
        mount_jut = wall+wall/2; //the distance the mount sticks out past the hotend radius
        
    
    ind_height = 10;
    ind_jut = e3d_fin_rad*2-hotend_rad+ind_rad + 2.5;
    
    angle = 70;
    
    hole_offsets = [50,0,30];
    mount_offsets = [extruder_sep+37,30,30-extruder_sep];
    mount_heights = [ind_height, height, height];
    mount_rad = [ind_rad, hotend_rad, hotend_rad];
    
    echo("Induction Offset from Extruder 0");
    echo("X:",(extruder_sep+37-30));
    echo("Y:",ind_rad-hotend_rad);
    
	difference(){
		union(){
			for(i=[0:2]) translate([mount_offsets[i],e3d_fin_rad-hotend_rad+(mount_rad[i]-hotend_rad),0]) rotate([0,0,angle]) extruder_mount(1,mount_heights[i],0,0, hotend_rad = mount_rad[i]);

            //Add piece to connect now separated sensor mount
           translate([52,-12.2,0]) rotate([0,0,70]) cube([14.1,20,10]);
            
			//mount supports
			//hull(){
				for(i=[0:2]) translate([hole_offsets[i],-hotend_rad-mount_jut,attach_height]) rotate([-90,0,0]) hull(){
                    cylinder(r=632_rad+wall*1.5, h=wall*2);
                    translate([0,attach_height,0]) cylinder(r=632_rad, h=wall*2);
                }
            }
                        
		for(i=[0:2]) translate([mount_offsets[i],e3d_fin_rad-hotend_rad+(mount_rad[i]-hotend_rad),0]) rotate([0,0,angle]) extruder_mount(0,mount_heights[i],0,0, hotend_rad = mount_rad[i]);

		//holes
		for(i=[0:2]) translate([hole_offsets[i],-hotend_rad-mount_jut-.1,attach_height]) rotate([-90,0,0]) {
			cap_cylinder(r=632_rad, h=wall+1);
			translate([0,0,3]) cap_cylinder(r=632_cap_rad, h=wall*2);
            translate([0,0,5]) rotate([attach_access,0,0]) cap_cylinder(r=632_cap_rad, h=wall*10);
		}
        
        //clean the bottle
        translate([0,0,-100]) cube([200,200,200], center=true);
	}
}

module extruder_mount(solid = 1, m_height = 10, fillet = 8, tap_height=0, width=20, fn=6){
	gap = 3;
	tap_dia = 9.1;
	tap_rad = tap_dia/2;

	if(solid){		
		//clamp material
		if(m_height > nut_rad*2){
			cylinder(r=(hotend_rad+wall)/cos(30), h=m_height, $fn=fn);
			translate([hotend_rad+bolt_rad+1,gap,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
			translate([hotend_rad+bolt_rad+1,-wall-1,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
		}
	}else{
		union(){
			//hotend hole
			translate([0,0,-.05]) cylinder(r=hotend_rad/cos(180/18)+.1, h=m_height+40, $fn=36);

			//bolt slots
			if(m_height > nut_rad*2){
				render() translate([hotend_rad+bolt_rad+2,-m_thickness-.05,m_height/2]) rotate([-90,0,0]) cap_cylinder(r=632_rad, h=m_thickness+10);
				hull(){
                    translate([hotend_rad+bolt_rad+2,-wall*2.5,m_height/2]) rotate([-90,0,0]) rotate([0,0,45]) cylinder(r1=632_nut_rad+.5, r2=632_nut_rad, h=wall*1.5, $fn=4);
                    //translate([hotend_rad+bolt_rad+2+10,-wall*2.5,m_height/2]) rotate([-90,0,0]) rotate([0,0,45]) cylinder(r1=632_nut_rad+.5, r2=632_nut_rad, h=wall*1.5, $fn=4);
                }

				//mount tightener
				translate([hotend_rad+bolt_rad+2,wall+gap-1,m_height/2]) rotate([-90,0,0]) cap_cylinder(r=632_cap_rad+.5, h=10);
				translate([0,0,-.05]) cube([wall*5, gap, m_height+.1]);
			}
		}
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
