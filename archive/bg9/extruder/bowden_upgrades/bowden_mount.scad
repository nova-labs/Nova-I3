slop = .1;
lower_hole_sep = 50;
lower_hole_rad = 5.5+slop;

%cube([9,9,100],center=true);

wall=4;
m_thickness = wall*2+1+1;

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
ind_height = 12;

//hotend stuff
hotend_rad = 8+slop+slop;
e3d_fin_rad = 23/2;  //////////23 for the e3d V6; the V5 is 26 

mirror([1,0,0]) cyclops_mount(); //for one Cyclops or Chimeara hotend

translate([0,-40, 0])
bowden_mount_inline();  //for two e3d V6 hotends
//this fan mount is required, you can't fit e3d's 30mm mounts with the hotends this close.
translate([0,-70,0])
fan_duct(clip_height=25); 

$fn=32;


module fan_duct(clip_height = 40, wire_offset = 8){
    extruder_sep = e3d_fin_rad*2;
	height = 40;
	fan_w = 40;
	fan_screwhole = 32/2;
	fan_rad = 36/2;

	ductwall = 3.5;

	cutoff = 40+10;
    inset = .5; //this is how much closer together to make the walls.
    
        unclip_height = 40-clip_height;

        echo(unclip_height);
    
	translate([0,0,height/2]) rotate([90,0,0])
	difference(){
                union(){
                    hull(){
			//fan
			translate([0,0,wall/2]) cube([fan_w, fan_w, wall], center=true);

			for(i=[-1,1]) for(j=[0,wire_offset]) translate([i*(extruder_sep/2-inset),0,extruder_sep/2+wall+j]) rotate([90,0,0]) cylinder(r=e3d_fin_rad+ductwall/2, h=height, center=true);
                            
                    }
		}
                //the hotends
                for(i=[-1,1]) translate([i*(extruder_sep/2-inset),0,extruder_sep/2+wall+wire_offset]) rotate([90,0,0]) cylinder(r=e3d_fin_rad, h=height+2, center=true);
                
                //space for the wires
                for(i=[-1,1]) translate([i*extruder_sep/2-wire_offset/2*i,0,extruder_sep/2+wall-wire_offset/2]) rotate([90,0,0]) cylinder(r=e3d_fin_rad-wire_offset/2, h=height+ductwall*2, center=true);
                    
                //cutout around the hotend clamps
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

//this is the bowden hotends+induction inline.
module bowden_mount_inline(height=14, induction = 1, hole_sep=20){
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
    
    for(i=[-25,-5,25]){
        translate([i,-wall,attach_height]) rotate([-90,0,0]){
            if(solid>=0)
                cylinder(r=632_rad+wall, h=wall);
            if(solid<=0) translate([0,0,-.1]) {
                #cap_cylinder(r=632_rad, h=wall*2);
                //translate([0,0,wall-632_cap_height]) 
                translate([0,0,1.5]) 
                cap_cylinder(r=632_cap_rad, h=632_cap_height+wall);
            }
        }
    }
}

module cyclops_mount(induction=1){
    mount_height = 20+5;
    e3d_mount_height = wall+1;
    e3d_mount_offset = 14;
    ind_offset=(16-18)/2;
    ind_x_offset = 21+1;
    wall=4;
    
    difference(){
        union(){
            hull(){
                for(i=[0,1]) mirror([i,0,0])
                    translate([e3d_mount_offset,0,e3d_mount_height]) cyclops_holes(1, wall=wall);
                translate([0,0,mount_height]) i3_holes(1, wall=wall);
            }
            if(induction==1){
                translate([-ind_x_offset,ind_rad+ind_offset,0]) rotate([0,0,90]) extruder_mount(1, m_height=ind_height, hotend_rad=ind_rad, wall=wall);
            }
            
            translate([e3d_mount_offset,0,e3d_mount_height]) cyclops_holes(1, jut=1, wall=wall);
        }
        
        translate([e3d_mount_offset,0,e3d_mount_height]) cyclops_holes(-1, wall=wall);
        translate([0,0,mount_height]) i3_holes(-1, wall=wall);
        if(induction==1){
            translate([-ind_x_offset,ind_rad+ind_offset,0]) rotate([0,0,90]) extruder_mount(0, m_height=ind_height, hotend_rad=ind_rad, wall=wall);
        }
        
        //cut off back and base
        translate([0,-50-wall,0]) cube([100,100,100], center=true);
        translate([0,0,-50]) cube([100,100,100], center=true);
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
				translate([hotend_rad+bolt_rad+2,-wall*2.5,m_height/2]) rotate([-90,0,0]) cylinder(r1=632_nut_rad+.5, r2=632_nut_rad, h=wall*1.5, $fn=4);

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