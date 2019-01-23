$fn=36;

holder_switch();

angle = 130;
wall = 2;
slop = .2;
hole_height = 2.75;
hole_sep = 19.25;

height = 8;
length = hole_sep+wall*2;

endstop_width = 7.5;

m8_dia = 8;
m8_rad = m8_dia/2+slop;

m3_nut_rad = 6/cos(30)/2;
m3_nut_height = 3;
m3_rad = 1.8;
m3_cap_rad = 3.25;


module holder(){
	clamp_offset = 5;
	length = length+clamp_offset;
	difference(){
		hull(){
			translate([-m8_rad,0,height/2]) cube([length, m8_rad*2+wall*3, height],center=true);
			translate([length/2,0,height/2]) cylinder(r=m8_rad+wall/2, h=height, center=true);

			//screwholes
			
		}
		
		translate([length/2,0,height/2]) cylinder(r=m8_rad, h=height+1, center=true);
		
		//clamp
		translate([length/2-clamp_offset,0,height/2]) cylinder(r=m8_rad, h=height+1, center=true);
	
		translate([-clamp_offset,0,height/2]) cube([length, m8_rad*2, height+1],center=true);

		//screwholes
		for(i=[-1,1]) translate([i*hole_sep/2-m8_rad/2-wall, 0, height-hole_height]) rotate([-90,0,0]) {
			cap_cylinder(r=m3_rad, h=length, center=true);
			translate([0,0,m8_rad+wall*2/3]) cap_cylinder(r=m3_cap_rad, h=wall);
			translate([0,0,-m8_rad-wall*2]) cylinder(r=m3_nut_rad, h=wall*1.3333, $fn=6);
		}
	}
}

module holder_switch(){
    width=22;
    thick = 7;
    wire = 5;
    
    switch_height=8;
    
    difference(){
        union(){
            //rod clamp
            translate([0,0,height/2]) rotate([0,90,0]) round_clip(rad = m8_rad, height = height, wall = wall, angle=angle, support = 0, clamp=1, solid = 1);
            
            //endstop holder
            translate([-thick/2,0,switch_height/2+wall/2]) cube([thick+wall*2, width+wall*2,switch_height+wall], center=true);
        }
        
        //hollow out the rod
        translate([0,0,height/2]) rotate([0,90,0]) round_clip(rad = m8_rad, height = height, wall = wall, angle=angle, support = 0, clamp=1, solid = 0);
        
        difference(){
            union(){
                //endstop
                translate([-thick/2,0,switch_height/2+wall]) cube([thick, width,switch_height+wall], center=true);
                //wire pass
                translate([-thick/2-(thick-wire)/2,0,switch_height/2-.1]) cube([wire, width,switch_height], center=true);
            }
            
            //retainer bump
            translate([-thick-wall/5,0,switch_height*3/4]) scale([1,1,2]) sphere(r=wall/2);
        }
        
        //flatten bottom
        for(i=[-1,-1]) translate([0,0,25*i+height/2+height/2*i]) cube([50,50,50], center=true);
    }
}

module holder_old(){
	difference(){
		union(){
			#translate([0,0,height/2]) rotate([0,90,0]) round_clip(rad = m8_rad, height = height, wall = wall, angle=angle, support = 0, clamp=1, solid = 1);
			translate([wall/2,0,height/2]) cube([wall,hole_sep+m3_rad*2+wall*2.5,height],center=true);

			for(i=[-1,1]) translate([wall/2,hole_sep/2*i,hole_height]) rotate([0,90,0]) rotate([0,0,0]) cylinder(r1=wall+m3_nut_rad, r2=wall/2+m3_nut_rad, h=m3_nut_height+.1, $fn=6);
		}

		for(i=[-1,1]) translate([wall,hole_sep/2*i,hole_height]) rotate([0,90,0]) {
			cylinder(r=m3_nut_rad, h=m3_nut_height+.5, $fn=6);
			rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=height*2, center=true);
		}

		translate([0,0,height/2]) rotate([0,90,0]) round_clip(rad = m8_rad, height = height, wall = wall, angle=angle, support = 0, clamp=1, solid = 0);

		//clean top and bot
		for(i=[-1,1]) translate([0,0,25*i+height/2+height/2*i]) cube([50,50,50], center=true);
	}
}

module round_clip(rad=8, height=10, wall=3, angle=45, support=0, clamp=0, solid=0){
	translate([0,0,wall+rad])
	rotate([0,90,0])
	if(solid == 1){
		union(){
			translate([0,0,height/2]) rotate([0,0,30]) cylinder(r=(wall/2+rad)/cos(30), h=height*2, center=true);

			if(clamp==1){
				for(i=[-1,1]) rotate([0,0,i*angle/2]) translate([-rad-wall/2,0,0]) rotate([0,0,-i*angle/2]) rotate([i*90,0,0]) hull(){
					translate([wall*3, 0, 0]) cylinder(r1=wall+m3_nut_rad, r2=wall/2+m3_nut_rad, h=m3_nut_height+.1, $fn=6, center=true);
					translate([-m8_rad, 0, 0]) cylinder(r1=wall+m3_nut_rad, r2=wall/2+m3_nut_rad, h=m3_nut_height+.1, $fn=6, center=true);
				}
			}
		}
	}else{
		//hollow
		cylinder(r=rad, h=height*4, center=true);
		hull(){
			if(support==1){
				translate([0,0,rad+wall+height/2]) rotate([90,0,0]) cylinder(r=rad+wall, h=height*3, center=true);
			}else{
				translate([rad*2,0,rad+wall+height/2]) rotate([90,0,0]) cylinder(r=rad+wall, h=height*3, center=true);
			}
			translate([-rad,0,rad+wall+height/2]) rotate([90,0,0]) cylinder(r=rad+wall, h=height*3, center=true);
		}

		//zip tie slot
		*translate([-1,0,0]) difference(){
			cylinder(r=(wall/2+rad+2)/cos(30), h=3, center=true);
			cylinder(r=(wall/2+rad)/cos(30), h=4, center=true);
		}
		
		//clip cutout
		difference(){
			for(i=[-1,0,1]) rotate([0,0,i*(angle/2-30)]) translate([-rad*2,0,0]) cylinder(r=rad*2, h=height*3, center=true, $fn=3);
			for(i=[-1,1]) rotate([0,0,i*angle/2]) translate([-rad-wall/2,0,0]) cylinder(r=wall/2, h=height*3, center=true);
			if(clamp == 1){
				for(i=[-1,1]) rotate([0,0,i*angle/2]) translate([-rad-wall/2,0,0]) rotate([0,0,-i*angle/2]) rotate([i*90,0,0]) hull(){
					cylinder(r1=wall+m3_nut_rad, r2=wall/2+m3_nut_rad, h=m3_nut_height+.1, $fn=6, center=true);
					translate([-m8_rad, 0, 0]) cylinder(r1=wall+m3_nut_rad, r2=wall/2+m3_nut_rad, h=m3_nut_height+.1, $fn=6, center=true);
				}
			}
		}

		if(clamp == 1){
			rotate([0,0,1*angle/2]) translate([-rad-wall/2,0,0]) rotate([0,0,-1*angle/2]) rotate([i*90,0,0]) rotate([90,0,0]) translate([-m8_rad, 0, -m8_rad*4]) cylinder(r=m3_rad, h=m8_rad*6);
			rotate([0,0,1*angle/2]) translate([-rad-wall/2,0,0]) rotate([0,0,-1*angle/2]) rotate([i*90,0,0]) rotate([90,0,0]) translate([-m8_rad, 0, 0]) cylinder(r=m3_cap_rad, h=wall);
			rotate([0,0,-1*angle/2]) translate([-rad-wall/2,0,0]) rotate([0,0,1*angle/2]) rotate([i*90,0,0]) rotate([90,0,0]) translate([-m8_rad, 0, -wall]) cylinder(r=m3_nut_rad, h=wall, $fn=6);
		}
	}
}


module tear(r, h) {
  union() {
    cylinder(r=r, h=h);
    rotate([0, 0, 135]) cube([r, r, h]);
  }
}

module crap(){
difference() {
  union() {
		translate([1,.5,0])
		cube([15, 11.2, 7]);

		translate([-13, 17, 0])
		cube([28, 2.5, 7]);

		translate([8.4, 11.2, 0])
		cylinder(r=16 / 2, h=7);
  }

	translate([-0.1, 4.9, 3.3])
	rotate([0, 90, 0])
	tear(r=3.1 / 2, h=23);

	translate([8.4, 11.2, -1])
	cylinder(r=4.2, h=10);

	translate([4.7, -1, -1])
	cube([7.2, 11.2, 10]);

		translate([-9.25, 21, 4.5])
		rotate([90, 0, 0])
		cylinder(r=1.8, h=9);

		translate([-9.25, 18, 4.5])
		rotate([90, 0, 0])
		rotate([0,0,30]) cylinder(r=3/cos(30), h=3, $fn=6);	

		translate([10, 18, 4.5])
		rotate([90, 0, 0])
		rotate([0,0,30]) cylinder(r=3.2, h=3, $fn=6);
		translate([10, 18, 6])
		rotate([90, 0, 0])
		rotate([0,0,30]) cylinder(r=3.2, h=3, $fn=6);
		
		translate([10,19.6, 4.5])
		rotate([90, 0, 0])
		cylinder(r=1.8, h=9);

  translate([3.9, -5, -1])
  cylinder(r=1.5, h=6);
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
