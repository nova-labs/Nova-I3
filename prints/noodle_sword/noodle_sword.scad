use <threads.scad>
in = 25.4;

noodle_rad = 2.5*in/2;


//fancy noodle has a smaller hole
//noodle_hole_rad = (in*.9)/2;

//regular noodles are half-inch
noodle_hole_rad = (in*1.0)/2;

part = 3;

if(part == 0)
    sword_holder();

if(part == 1)
    noodle_sword();

if(part == 2){
        %cylinder(r=noodle_hole_rad, h=100);
    difference(){
        2_part_sword(part = 1);
        //translate([0,-50,0]) cube([100,100,100], center=true);
    }
}

if(part == 3){
        %cylinder(r=noodle_hole_rad, h=100);
    difference(){
        rotate([180,0,0]) 2_part_sword(part = -1);
        //translate([0,-50,0]) cube([100,100,100], center=true);
    }

}

handle_len = 4.5*in;
screw_len = 4.25*in;

handle_rad = 15;

pitch = 1.5*in;
flat = 1;

screw_rad = noodle_hole_rad*1.3;
taper = 5;
facets = 13;

side = 83;
bumps = 4;

%translate([0,20,0]) rotate([0,0,45]) cube([200,200,.1], center=true);



magnet_rad = 13/2;
magnet_height = 3.5;

$fn=36;

module 2_part_sword(part = 0){
    screw_rad = noodle_hole_rad;
    thread_dia = screw_rad*2+7;
    taper = 1/15;
    wall = 2;
    
    in =25.4;
    
    stiff_rad = 3/8*in/2+.25;
    stiff_len = in*6+2;
    
    guard_rad = thread_dia/2+11;
    handle_rad = 11;
    handle_len = 73;
    
    pommel_len = 23;
    pommel_rad = 17;
    
    
    
    //noodle insert
    //translate([0,0,9])
    if (part >= 0) difference(){
        union(){
            metric_thread(diameter=thread_dia, pitch=3, length=in/2, internal=false, angle=45, taper=-taper, leadin=0, leadfac=1.0);
            translate([0,0,in/2-.1]) ball_screw(taper = -7, ball_rad = 5);
        }
        
        //stiffener
        cylinder(r=stiff_rad, h=stiff_len, center=true);
    }
    
    if (part <= 0) difference(){
        union(){
            //guard
            difference(){
                intersection(){
                    cylinder(r=guard_rad, h=in, center=true);
                    translate([0,0,in/4]) scale([1,1,in/(guard_rad+3)]) sphere(r=guard_rad);
                }
                translate([0,0,.1]) metric_thread(diameter=thread_dia+.25, pitch=3, length=in/2, internal=true, angle=45, taper=-taper, leadin=0, leadfac=1.0);
            }
        
            //handle
            rotate([180,0,0]) cylinder(r=handle_rad, h=handle_len+in);
            rotate([180,0,0]) for(i=[0:handle_len/4:handle_len]){
                translate([0,0,i+in/2]) scale([1,1,.5]) sphere(r=handle_rad+wall);
            }
        
            //pommel
            rotate([180,0,0]) translate([0,0,handle_len+in/2]) {
                hull(){
                    cylinder(r=handle_rad, h=.1);
                    minkowski(){
                        translate([0,0,pommel_len*3/4]) cylinder(r=pommel_rad, h=.1, $fn=6);
                        sphere(r=3);
                    }
                }
                hull(){
                    minkowski(){
                        translate([0,0,pommel_len*3/4]) cylinder(r=pommel_rad, h=.1, $fn=6);
                        sphere(r=3);
                    }
                    minkowski(){
                        translate([0,0,pommel_len]) cylinder(r=handle_rad, h=.1, $fn=8);
                        sphere(r=3);
                    }
                }
            }
        }
        
        //stiffener
        cylinder(r=stiff_rad, h=stiff_len, center=true);
    }
}

module sword_holder(wall_height = 7){
    grip_angle = 140;
    
    difference(){
        union(){
            //wall plate
            hull(){
                linear_extrude(height=wall_height/2, center=true) guitar_pick();
                linear_extrude(height=wall_height, center=true) guitar_pick(side = side-wall_height/2);
            }
            
            //grabber
            translate([0,0,handle_rad+5+6]) rotate([-90,0,0]) {
                rotate([0,0,-90+grip_angle/2]) rotate_extrude(angle = 360-grip_angle){
                    translate([handle_rad+9,0,0]) scale([1,2,1]) circle(r=5);
                }
            
                for(i=[0:1]) mirror([i,0,0]) rotate([0,0,-(180-grip_angle)/2]) hull(){
                    translate([handle_rad+9,0,0]) scale([1,1,2]) sphere(r=5);
                    rotate([0,0,(180-grip_angle)/2]) translate([31,handle_rad+9,17]) scale([1,1,2]) sphere(r=5);
                }
            }
        }
        
        //snug sword
        translate([0,handle_len-9,in/2+wall_height]) rotate([0,0,180]) noodle_sword(handle_rad = handle_rad+1);
        
        //attach to the wall with a screw
        cylinder(r=2.5, h=20, center=true);
        translate([0,0,wall_height/2]) cylinder(r1=2.5, r2=11, h=11-2.5);
        
        //attach with a magnet
        translate([0,23,-wall_height/2+1]) {
            cylinder(r=magnet_rad, h=magnet_height+1);
            intersection(){
                cylinder(r1=magnet_rad, r2=magnet_rad+2, h=magnet_height*6);
                cube([magnet_rad*3, magnet_rad*1.75, magnet_height*12], center=true);
            }
        }
    }
}

module guitar_pick(side=side){
    intersection() {
        translate([-1*side/2,0,0]) circle(side);
        translate([side/2,0,0]) circle(side);
        translate([0,tan(60)*side/2,0]) circle(side);
    }
}

module noodle_sword(){
    difference(){
        rotate([atan((taper*.71+.25)/screw_len),0,0]) rotate([90,0,0]) union(){
            render() minkowski(){
                union(){
                    rotate([0,0,0]) hex_screw();
                    rotate([0,0,180]) hex_screw();
                }
                *sphere(r=.75, $fn=6);
            }
        
            //guard
            scale([.8,.66,.05]) sphere(r=3*in, $fn=45);
        
            //handle        
            mirror([0,0,1])
                difference(){
                    for(i=[.5:.5:bumps-.5]) translate([0,0,i*handle_len/bumps]){
                        sphere(r=handle_rad+i);
                    }
                    for(i=[1:1:bumps-.5]) translate([0,0,i*handle_len/bumps-1]){
                        rotate_extrude(){
                            translate([handle_rad+i-.5+3,0,0]) scale([.666,1,1]) circle(r=10);
                        }
                    }
                }
        
            //pommel
            translate([0,0,-handle_len]) scale([.35,.35,.2]) sphere(r=3*in, $fn=36);
            translate([0,0,0]) scale([1,1,1]) sphere(r=noodle_hole_rad, $fn=36);
        }
    
        //stiffen the center a bit
        rotate([atan((taper*.71)/screw_len),0,0]) rotate([90,0,0]) cylinder(r1=8, r2=4, h=200, center=true, $fn=4);
    
        translate([0,0,-200-screw_rad+1.2+.75]) cube([400,400,400], center=true);
    
        rotate([atan((taper*.71)/screw_len)+2,0,0]) 
        translate([0,0,200+screw_rad-1.75]) cube([400,400,400], center=true);
    
        //%rotate([atan((taper*.71)/screw_len),0,0]) rotate([90,0,0]) cylinder(r1=noodle_hole_rad, r2=noodle_hole_rad, h=screw_len, $fn=9);
    }
}


//%rotate([90,0,0]) cylinder(r=screw_rad, h=1);
//%rotate([90,0,0]) cylinder(r=noodle_hole_rad, h=200);

module hex_screw(){
    s=.75;
    pitch_taper = taper / (screw_len / pitch);
    
    taper_per_mm = taper/screw_len;
    taper_per_step = taper_per_mm/facets;
    echo(taper_per_step);
    
    //%cylinder(r1=screw_rad, r2=screw_rad-taper, h=screw_len, $fn=9);
    
    intersection(){
        union(){
            cylinder(r1=noodle_hole_rad-2, r2=noodle_hole_rad-2-taper/2, h=screw_len, $fn=4);
            for(j=[-pitch:pitch:screw_len+pitch]) translate([0,0,j]) {
                echo(2*(screw_rad/2-taper_per_mm*(j/pitch*facets)));
                for(i=[0:facets-1]) hull() rotate([0,0,i*360/facets]) translate([0,0,pitch/facets*i]) {
                    for(k=[0:flat]) translate([0,0,k]) {
                        rotate([90,0,0]) translate([screw_rad/2-taper_per_mm*(i+j/pitch*facets),0,0]) scale([1,s*.9,1]) cylinder(r=screw_rad/2, h=.1, $fn=3, center=true);
                        rotate([0,0,360/facets]) translate([0,0,pitch/facets]) rotate([90,0,0]) translate([screw_rad/2-taper_per_mm*(i+1+j/pitch*facets),0,0]) scale([1,s*.95,1]) cylinder(r=screw_rad/2, h=.1, $fn=3, center=true);
                    }
                }
            }
        }
        cylinder(r1=screw_rad, r2=screw_rad-taper*.75, h=screw_len, $fn=facets);
    }
}

module ball_screw(length = 3, starts = 3, screw_rad = noodle_hole_rad, step = 18, taper = 0, extra_steps = 0, ball_rad = 5){
    pitch = ball_rad*2*3.25;
    true_pitch = pitch*starts;
    
    screw_ball_rad = ball_rad;
    inset = -1;
    echo("RAD");
    echo(screw_ball_rad);
    
    true_taper = taper / (360*length-step-1);
    
    angle_offset = 60;
    
    difference(){
        union(){        
            //main tube
            cylinder(r1=screw_rad-.5, r2=screw_rad-.5+taper/2, h=length*pitch, $fn=720/step);
            for(j=[1:starts]) rotate([0,0,j*(360/starts)+angle_offset]) translate([0,0,0]) {
                for(i=[step*extra_steps:step:360*length/starts-step-1]) {
                    hull(){
                        rotate([0,0,i]) translate([screw_rad+inset + (i-step*extra_steps)*true_taper, 0, i/360*true_pitch]) sphere(r=screw_ball_rad);
                        rotate([0,0,i+step]) translate([screw_rad+inset + (i-step*extra_steps+step)*true_taper, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
                    }
                }
            }
        }
        
        //cut paths into the underside - leading up to the screw for one turn
        for(j=[1:starts]) rotate([0,0,j*(360/starts)]) translate([0,0,-pitch*starts]) {
            for(i=[0:step:360-1+step*extra_steps]) {
                hull(){
                    rotate([0,0,i]) translate([screw_rad-inset, 0, i/360*true_pitch]) sphere(r=screw_ball_rad);
                    rotate([0,0,i+step]) translate([screw_rad-inset, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
                }
            }
        }
        
        //cut paths into the side - trying to make it bind less
        for(j=[1:starts]) rotate([0,0,j*(360/starts)]) translate([0,0,0]) {
            for(i=[step*extra_steps:step:360*length/starts-step-1]) {
                hull(){
                    rotate([0,0,i]) translate([screw_rad-inset + (i-step*extra_steps)*true_taper, 0, i/360*true_pitch]) sphere(r=screw_ball_rad);
                    rotate([0,0,i+step]) translate([screw_rad-inset + (i-step*extra_steps+step)*true_taper, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
                }
            }
        }
        
        //flatten the base
        translate([0,0,-50]) cube([50,50,100], center=true);
        
        //flatten the top
        translate([0,0,-pitch]) difference(){
            translate([0,0,pitch*length+50]) cube([50,50,100], center=true);
            translate([0,0,pitch*length]) scale([(screw_rad+ball_rad)/pitch,(screw_rad+ball_rad)/pitch,1]) sphere(r=pitch);
        }
        
        //cut in half
        *translate([150,0,0]) cube([300,300,300], center=true);
    }
}
