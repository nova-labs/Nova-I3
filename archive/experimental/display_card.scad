in = 25.4;

//good for a half-sheet of paper
width = in*4;
height = in*1.75;
depth = in*4;
slit =1.5;

wall = 4;

slit_rad = in*5;
slit_angle = -12;

base_thick = wall;

side_rad = depth/2;

text_inset = .3;

//%cube([width, depth, height], center=true);

$fn = 90;
stand(logo = nl);

//translate([width,0,0]) stand(logo=text, text="github.com/paenian");

none = 0;
nl = 1; //nova labs
text = 2; //free text logo

module stand(logo = none, text=""){
    difference(){
        union(){
            intersection(){
                scale([width, depth, height]) sphere(r=.5, $fn=180);
                translate([0,slit_rad-wall*1.5,0]) rotate([slit_angle,0,0]) cylinder(r=slit_rad+wall, h=100, center=true);
            }
        }
        
        //slit
        translate([0,slit_rad-wall*1.5,0]) rotate([slit_angle,0,0]) difference(){
            cylinder(r=slit_rad, h=100, center=true);
            cylinder(r=slit_rad-slit, h=101, center=true);
        
            //raise the base
            rotate([-slit_angle,0,0]) translate([0,0,-slit_rad*1.5+base_thick]) cube([slit_rad*3,slit_rad*3,slit_rad*3], center=true);
        }
        
        //cut some meat off the back, leaving a manta ray kind of thing
        difference(){
            //cut off behind the slit
            translate([0,slit_rad-wall*1.5,0]) rotate([slit_angle,0,0]) cylinder(r=slit_rad-wall*1.5, h=100, center=true); 
            
            //leave behind some scallops
            for(i=[0:1]) mirror([i,0,0]) translate([side_rad-wall/2,side_rad+base_thick,0]) difference(){
                cylinder(r=side_rad, h=height*2, center=true);
                cylinder(r=side_rad - wall, h=height*3, center=true);
            }
        }
        
        //cut off the bottom
        translate([0,0,-100]) cube([200,200,200], center=true);
        
        //cut a logo into the front
        if(logo == nl){
            intersection(){
                nl_logo();
                
                //only cut in a bit
                translate([0,slit_rad-wall*1.5,0]) rotate([slit_angle,0,0]) difference(){
                    cylinder(r=slit_rad*2, h=50, center=true); 
                    cylinder(r=slit_rad+wall-text_inset, h=100, center=true);
                }
            }
        }
    }
}

//stand with Nova Labs logo
module nl_stand(){
    
}

module nl_logo(){
    rotate([90,0,0]) translate([0,-7,0]) 
    linear_extrude(in){
        import("nova-labs_text.dxf");
    }
}

module business_card(){
}