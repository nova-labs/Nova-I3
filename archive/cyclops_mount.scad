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


//not sure where this is used.
e3d_fin_rad = 23/2;  //////////23 for the e3d V6; the V5 is 26 

//translate([0,-50, 0])
mirror([1,0,0]) cyclops_mount();
$fn=32;

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
    e3d_mount_height = wall+1;
    e3d_mount_offset = 14;
    ind_offset=(16-18)/2;
    ind_x_offset = 18;
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