use <threads.scad>
in = 25.4;

noodle_rad = 2.5*in/2;


//fancy noodle has a smaller hole
//noodle_hole_rad = (in*.9)/2;

//regular noodles are half-inch
noodle_hole_rad = (in*1.0)/2;

part = 8;

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

if(part == 22){
        //%cylinder(r=noodle_hole_rad, h=100);
    difference(){
        //%2_part_sword(part = 1);
        //translate([0,-50,0]) cube([100,100,100], center=true);
        noodle_clip();
    }
}

if(part == 3){
        %cylinder(r=noodle_hole_rad, h=100);
    *translate([45,0,-in/2]) 2_part_sword(part = 1);
    difference(){
        rotate([180,0,0]) 2_part_sword(part = -1, hollow = false);
        //translate([0,-50,0]) cube([100,100,100], center=true);
    }
}

if(part == 33){
    difference(){
        //cylinder(r=50, h=in/2);
        translate([0,0,in/2-.025]) rotate([180,0,0]) 2_part_sword(part = -1, hollow = true);
    }
}

if(part == 4){
    screw_ring(finger_rad = 13/2, screw_dia = 7);
}

if(part == 41){
    screw_ring(finger_rad = 15.5/2, screw_dia = 7);
}

if(part == 42){
    screw_ring(finger_rad = 18/2, screw_dia = 7);
}

if(part == 5){
    screw_ring_star(screw_dia = 7);
}

if(part == 6){
    screw_ring_star(screw_dia = 7, points = 6);
}

if(part == 7){
    screw_ring_thread(screw_dia = 7);
}

if(part == 77){
    squirrel_tail_thread(screw_dia = 30);
}

if(part == 8){
    peg_ring(finger_rad = 18/2, peg_dia = 10, ring_thick = 8);
}

if(part == 9)
    noodle_rocket();

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




magnet_rad = 13/2;
magnet_height = 3.5;

$fn=36;


module noodle_rocket(){
    noodle_rad = 30;
    %cylinder(r=noodle_rad, h=100);
    
    wall = 2.5;
    height = 90;
    fin_w = 30;
    
    difference(){
        union(){
            //lower stabilization ring
            difference(){          
                hull() translate([0,0,wall*1.5]) rotate_extrude(convexity = 10)
                    translate([noodle_rad+wall/2, 0, 0]) scale([1,1.5,1]) rotate([0,0,22.5])
                    circle(r = wall, $fn=8);
                
                translate([0,0,wall/2]) cylinder(r=noodle_rad, h=wall*4);
                translate([0,0,-wall/2]) cylinder(r=noodle_rad-wall, h=wall*4);
            }
            
            //upper stabilization ring            
            translate([0,0,height]) rotate_extrude(convexity = 10, $fn=6)
            translate([(noodle_rad)/cos(28), 0, 0])
            scale([1,1.5,1]) rotate([0,0,22.5]) circle(r = wall, $fn=8);
            
            //support the ring
            for(i=[0:60:359]) rotate([0,0,i]) translate([noodle_rad+wall/2,0,0]) hull(){
                cylinder(r=wall, h=wall, $fn=6);
                translate([wall,0,height-wall*1.5]) cylinder(r=wall, h=wall, $fn=6);
            }
            
            //Fins!
            for(i=[0:120:359]) rotate([0,0,i]) translate([noodle_rad+wall/2,0,wall]){
                //gotta hold the rubber band on
                translate([-noodle_rad/2-wall/2,0,-wall/2]) cube([noodle_rad,wall,wall], center=true);
                
                //these are the fins proper
                hull(){
                    rotate([90,0,0]) cylinder(r=wall, h=wall/2, $fn=6, center=true);
                    rotate([90,0,0]) cylinder(r=wall/2, h=wall, $fn=6, center=true);
                    
                    translate([wall,0,height-wall]){
                        rotate([90,0,0]) cylinder(r=wall, h=wall/2, $fn=6, center=true);
                        rotate([90,0,0]) cylinder(r=wall/2, h=wall, $fn=6, center=true);
                    }
                    
                    translate([fin_w,0,height*1/3]){
                        rotate([90,0,0]) sphere(r=wall/2, $fn=6, center=true);
                        //rotate([90,0,0]) cylinder(r=wall/2, h=wall, $fn=6, center=true);
                    }
                    
                    translate([fin_w,0,height*2/3]){
                        rotate([90,0,0]) sphere(r=wall/2, $fn=6, center=true);
                        //rotate([90,0,0]) cylinder(r=wall/2, h=wall, $fn=6, center=true);
                    }
                }
            }
        }
        
        //flatten the bottom
        translate([0,0,-100+.5]) cube([200,200,200], center=true);
    }
}

module screw_ring_star(screw_dia = 7, points=5, star_rad = 11){
    point_rad = 2;
    point_flat = .5;
    point_h = in/8;
    difference(){
        union(){
            for(i=[0:360/points:359]) hull(){
                //center cylinder
                cylinder(r=(screw_dia/2+.1)/cos(180/points), h=in/4, $fn=points);
                rotate([0,0,i]) translate([star_rad,0,point_rad-point_flat]) sphere(r=point_rad, $fn=points);
            }
        }
        translate([0,0,-.05]) metric_thread(diameter=screw_dia, pitch=2, length=in/4+.1, internal=true, angle=45, taper=.05, leadin=0, leadfac=0);
        
        translate([0,0,-100]) cube([200,200,200], center=true);
    }
}

module screw_ring_thread(screw_dia = 6, points=5, star_rad = 11){
    point_rad = 2;
    point_flat = .5;
    point_h = in/8;
    
    metric_thread(diameter=screw_dia, pitch=2, length=in/4, internal=true, angle=45, taper=.05, leadin=0, leadfac=0);
}

module squirrel_tail_thread(screw_dia = 6, points=5, star_rad = 11){
    point_rad = 2;
    point_flat = .5;
    point_h = in/8;
    
    metric_thread(diameter=screw_dia, pitch=4, length=in*2, internal=true, angle=45, taper=.05, leadin=0, leadfac=0);
    
    hull(){
        cylinder(r=screw_dia/2+5, h=in/8, $fn=6);
        translate([0,0,in/32]) cylinder(r=screw_dia/2+6, h=in/16, $fn=6);

    }
}

module screw_ring(finger_rad = 10, screw_dia = 6){
    ring_thick = 5.75;
    ring_flat = 1;
    ring_wall_rad = 1.5;
    ring_rad = finger_rad+ring_wall_rad;
    open_angle = 20;
    
    ring_step = 20;
    
    difference(){
        union(){
            for(i=[-180+open_angle:ring_step:180-open_angle-ring_step]){
                hull(){
                    rotate([0,0,i]) translate([ring_rad,0,0]) scale([1,1,(ring_thick/2+ring_flat/2)/ring_wall_rad]) sphere(r=ring_wall_rad, $fn=12);
                    rotate([0,0,i+ring_step]) translate([ring_rad,0,0]) scale([1,1,(ring_thick/2+ring_flat/2)/ring_wall_rad]) sphere(r=ring_wall_rad, $fn=12);
                }
            }
            
            translate([ring_rad+ring_wall_rad-1,0,0]) rotate([0,90,0]) metric_thread(diameter=screw_dia, pitch=2, length=in/4, internal=false, angle=45, taper=.05, leadin=1, leadfac=1.0);
        }
        
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,50+ring_thick/2]) cube([100,100,100], center=true);
    }
}

module peg_ring(finger_rad = 10, peg_dia = 6, ring_thick = 6){
    sc = (peg_dia/2)/108;
    
    
    open_angle = 20;
    ring_flat = 1;
    ring_wall_rad = 1.5;
    ring_rad = finger_rad+ring_wall_rad;
    ring_step = 20;
    ring_flat = 1;
    
        difference(){
        union(){
            for(i=[-180+open_angle:ring_step:180-open_angle-ring_step]){
                hull(){
                    rotate([0,0,i]) translate([ring_rad,0,0]) scale([1,1,(ring_thick/2+ring_flat/2)/ring_wall_rad]) sphere(r=ring_wall_rad, $fn=12);
                    rotate([0,0,i+ring_step]) translate([ring_rad,0,0]) scale([1,1,(ring_thick/2+ring_flat/2)/ring_wall_rad]) sphere(r=ring_wall_rad, $fn=12);
                }
            }
            
            //Nova Labs peg to put the ring onto
            //kinda need it to be pretty big to work at all
            *translate([ring_rad+5,0,0])
            union(){
                minkowski(){
                    rotate([0,-90,0]) translate([.25,0,0]) rotate([0,0,26+90]) linear_extrude(height=1, center=true){
                    scale([sc,sc,sc]) translate([0,-21.5,0]) import("nova-labs_icon.dxf", layer="gear");
                    }
                    sphere(r=.25, $fn=8);
                }
        
                rotate([0,-90,0]) translate([.25,0,0]) rotate([0,0,26+90]) linear_extrude(height=5){
                scale([sc,sc,sc]) translate([0,-21.5,0]) import("nova-labs_icon.dxf", layer="gear");
                }
            }
            
            
            
        }
        
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,50+ring_thick/2]) cube([100,100,100], center=true);
    }
}

clip_rad = 3;

module noodle_clip(){
    stiff_rad = 3/8*in/2+.25;
    
    noodle_rad = 30;
    extra_rad = 7.5;
    
    wall = 2;
    
    %cylinder(r=noodle_rad, h=50);
    
    rotate([0,0,20]) translate([stiff_rad+2,0,in*1.5])
    difference(){
        union(){
            //rod
            rotate([90,0,0]) cylinder(r=clip_rad, h=noodle_rad*2, center=true);
            for(i=[0,1]) mirror([0,i,0]) translate([0,noodle_rad, 0]) sphere(r=clip_rad);
            
            //clip
            intersection(){
                difference(){
                    translate([0,extra_rad-1,0]) cylinder(r=noodle_rad+extra_rad, h=17, center=true);
                    translate([0,extra_rad-1,0]) cylinder(r=noodle_rad+extra_rad-wall, h=17, center=true);
                    
                    //clip slot
                    hull(){
                        translate([3,noodle_rad,2.5]) cube([2.5,noodle_rad,6], center=true);
                        translate([3+2.6/2,noodle_rad,2.5]) rotate([90,0,0]) cylinder(r=2.6, h=noodle_rad, center=true);
                    }
                    translate([-1,noodle_rad,2]) cube([2,20,12], center=true);
                }
                
                hull(){
                    rotate([90,0,0]) cylinder(r=2.5, h=80);
                    translate([50,0,0]) cube([100,100,14], center=true);
                }
            }
        }
        
        //notch the tube
        hull(){
            translate([0,noodle_rad-.5,0]) cylinder(r=1, h=10, center=true);
            translate([-3,noodle_rad-3.5,0]) cylinder(r=1, h=10, center=true);
        }
        
        //flatten the bottom
        translate([0,0,-100-2]) cube([200,200,200], center=true);
    }
}

module 2_part_sword(part = 0, hollow = true){
    screw_rad = noodle_hole_rad;
    thread_dia = screw_rad*2+7;
    taper = 1/15;
    wall = 2;
    
    in =25.4;
    echo(thread_dia);
    
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
        
        //blade clip
        rotate([0,0,20]) translate([stiff_rad+clip_rad-.1,0,in*1.5])
        rotate([90,0,0]) cylinder(r=clip_rad+.2, h=60, center=true);
    }
    
    if (part <= 0) difference(){
        union(){
            //guard
            difference(){
                if(hollow == false)
                    intersection(){
                        cylinder(r=guard_rad, h=in, center=true);
                        translate([0,0,in/4]) scale([1,1,in/(guard_rad+3)]) sphere(r=guard_rad);
                    }
                translate([0,0,.1]) metric_thread(diameter=thread_dia+.125, pitch=3, length=in/2, internal=true, angle=45, taper=-taper, leadin=0, leadfac=1.0);
            }
        
            //handle
            if(hollow == false){
                rotate([180,0,0]) cylinder(r=handle_rad, h=handle_len+in);
                rotate([180,0,0]) for(i=[0:handle_len/4:handle_len]){
                    translate([0,0,i+in/2]) scale([1,1,.5]) sphere(r=handle_rad+wall);
                }
            }
        
            //pommel
            if(hollow == false){
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
            }else{
                //inset logo in the pommel
                rotate([180,0,0]) translate([0,0,handle_len+in/2+pommel_len+2.5]) linear_extrude(height = 3) {
                    text("PJ", font = "Impact", size=9, halign="center", valign="center", spacing=1.1);
                    translate([-1,0,0]) text("c", font = "Courier", size=31, halign="center", valign="center");
                }
        
                //stiffener
                rotate([180,0,0]) translate([0,0,-10]) cylinder(r=stiff_rad, h=stiff_len/2+10);
            }
        }
        
        //inset logo in the pommel
        rotate([180,0,0]) translate([0,0,handle_len+in/2+pommel_len+2.5]) linear_extrude(height = 3) {
            text("PJ", font = "Impact", size=9, halign="center", valign="center", spacing=1.1);
            translate([-1,0,0]) text("c", font = "Courier", size=31, halign="center", valign="center");
        }
        
        //stiffener
        if(hollow == false) cylinder(r=stiff_rad, h=stiff_len, center=true);
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

module ball_screw(length = 6, starts = 3, screw_rad = noodle_hole_rad, step = 18, taper = 0, extra_steps = 0, ball_rad = 5, facets = 36, thread_scale = [1,1,1]){
    pitch = ball_rad*2*1.5;
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
            cylinder(r1=screw_rad+.5, r2=screw_rad+.5+taper/2, h=length*pitch, $fn=facets);
            for(j=[1:starts]) rotate([0,0,j*(360/starts)+angle_offset]) translate([0,0,0]) {
                for(i=[step*extra_steps:step:360*length/starts-step-1]) {
                    hull(){
                        rotate([0,0,i]) translate([screw_rad+inset + (i-step*extra_steps)*true_taper, 0, i/360*true_pitch]) scale(thread_scale) cylinder(r=screw_ball_rad, h=.01, $fn=facets);
                        rotate([0,0,i]) translate([screw_rad+inset + (i-step*extra_steps)*true_taper-screw_ball_rad*2, 0, i/360*true_pitch]) scale(thread_scale) sphere(r=screw_ball_rad*2, h=.01, $fn=facets);

                        rotate([0,0,i+step]) translate([screw_rad+inset + (i-step*extra_steps+step)*true_taper, 0, (i+step)/360*true_pitch]) scale(thread_scale) cylinder(r=screw_ball_rad, h=.01, $fn=facets);
                        rotate([0,0,i+step]) translate([screw_rad+inset + (i-step*extra_steps+step)*true_taper-screw_ball_rad*2, 0, (i+step)/360*true_pitch]) scale(thread_scale) sphere(r=screw_ball_rad*2, h=.01, $fn=facets);
                    }
                }
            }
        }
        
        //cut paths into the underside - leading up to the screw for one turn
        *for(j=[1:starts]) rotate([0,0,j*(360/starts)]) translate([0,0,-pitch*starts]) {
            for(i=[0:step:360-1+step*extra_steps]) {
                hull(){
                    rotate([0,0,i]) translate([screw_rad-inset, 0, i/360*true_pitch]) sphere(r=screw_ball_rad);
                    rotate([0,0,i+step]) translate([screw_rad-inset, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
                }
            }
        }
        
        //cut paths into the side - trying to make it bind less
        *for(j=[1:starts]) rotate([0,0,j*(360/starts)]) translate([0,0,0]) {
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
