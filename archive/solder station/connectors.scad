/* 
 * connectors for the MDF panels.
 * 
 */


include <configuration.scad>
include <functions.scad>
include <write.scad>

//all connectors are centered.

for(i=[-3:3]){
	translate([0,i*52,0]) difference(){
		projection() translate([0,-30,0]) rotate([-90,0,0])
    	translate([-30,0,0]) difference(){
        	rotate([90,0,0]) cube([50,50,mdf_wall], center=true);
      	  	translate([0,mdf_wall/2,0]) pinconnector_female(screw=true, laser_slop=(i*.1));
    		translate([0,0,15]) rotate([90,0,0]) write(str(i),t=wall*3,h=10,center=true, font = "Writescad/orbitron.dxf");
		}
	}
    
    translate([55,i*52,0]) difference(){
		projection()
	    translate([-30,-45,0]) difference(){
	        union(){
	            translate([0,38/2,0]) cube([50,38,mdf_wall], center=true);
	            pinconnector_male(screw=true, solid=1, laser_slop=(i*.1));
	        }
	        pinconnector_male(screw=true, solid=-1, laser_slop=(i*.1));
            translate([0,30,0]) rotate([0,0,0]) write(str(i*2),t=wall*3,h=10,center=true, font = "Writescad/orbitron.dxf");
	    }
    		
		//}
	}
}

module test_female(){
	projection() translate([0,-30,0]) rotate([-90,0,0])
    	translate([-30,0,0]) difference(){
        	rotate([90,0,0]) cube([50,50,mdf_wall], center=true);
      	  	translate([0,mdf_wall/2,0]) pinconnector_female(screw=true, laser_slop=laser_slop);
            
    	}
}

module test_male(){
	//for test lasering
	projection()
	    translate([-30,mdf_wall/2,0]) difference(){
	        union(){
	            translate([0,25,0]) cube([50,50,mdf_wall], center=true);
	            pinconnector_male(screw=true, solid=1, laser_slop=laser_slop);
	        }
	        pinconnector_male(screw=true, solid=-1, laser_slop=laser_slop);
	    }
}






module pinconnector_female(screw = true){
	translate([0,-mdf_wall/2-laser_slop/2,0]) union(){
		if(screw){
			rotate([90,0,0]) cylinder(r=m5_rad, h=mdf_wall+1, center=true);
		}

		for(i=[0,1]) mirror([i,0,0]) translate([mdf_tab, 0, 0]) cube([mdf_tab+laser_slop, mdf_wall+1, mdf_wall+laser_slop], center=true);
	}
}

module pinconnector_male(screw = true, solid=0){
	union(){
		if(screw){
			if(solid<=0){
				cube([m5_rad*2+laser_slop, mdf_wall*5, mdf_wall+2], center=true);
				translate([0,mdf_wall*1.5, 0]) cube([m5_nut_rad_laser*2, m5_nut_height+1, mdf_wall+2], center=true);
			}
		}
	
		if(solid >= 0){
			for(i=[0,1]) mirror([i,0,0]) translate([mdf_tab, 0, 0]) difference(){
                cube([mdf_tab, mdf_wall*2, mdf_wall], center=true);
                for(j=[0,1]) mirror([j,0,0]) translate([mdf_tab/2,-mdf_wall,0]) cylinder(r=mdf_wall/4, h=mdf_wall*2, center=true, $fn=4);
            }
		}
	}
}