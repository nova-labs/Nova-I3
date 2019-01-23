use <bearing.scad>;

wall = 5;
outer_rad = 28+wall*2;
bearing_rad = 28-wall;
thickness = 12;
slop = .25;
gear_slop = .2;

fn = 60;


//these are the radii of the filament spools, in order.
filament_rads = [28, 15, 8];

mount_offset = 35;

hole_rad = 6;

translate([70,0,0]) bearing_mount();

difference(){
    !bearing();

    //translate([100,0,0]) cube([200,200,200], center=true);

}

//%cylinder(r=15, h=50, center=true);

module bearing_mount(width = 30){
    top_height = 40;
    top_length = 33.5;
    
    difference(){
        union(){
            cube([top_length+wall*2,top_height+wall*2,width], center=true);
            
            //the arm
            hull(){
                translate([mount_offset/2,-top_height/2-wall/2,0]) cube([top_length+mount_offset, wall, width], center=true);
                translate([0,-top_height/2,0]) cube([top_length, wall*2, width], center=true);
            }
            
            //the bearing mount
            translate([top_length/2+mount_offset,-top_height/2,0]) rotate([90,0,0]){
               cylinder(r=width*.666, h=wall+.1); 
               translate([0,0,wall]) cylinder(r1=width*.666, r2=hole_rad+3, h=wall+1);
               translate([0,0,wall*2]) cylinder(r1=hole_rad, r2=hole_rad-slop*2, h = thickness, $fn=6);
            }
        }
        
        cube([top_length, top_height, width+1], center=true);
        
        //cut out the insert slot
        translate([wall+.1, wall+.1, 0]) cube([top_length, top_height, width+1], center=true);
        
        //chamfer the top, easier clamping
        translate([wall/2, -1,0]) scale([.85,.85,1]) hull(){
            cube([top_length, top_height, width+1], center=true);
            translate([wall+.1, wall+.1, 0]) cube([top_length, top_height, width+1], center=true);
        }
        
        //cut off the top and bottom
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,100+width/2]) cube([200,200,200], center=true);
    }
}

module bearing(){
    //set variables
    // bearing diameter of ring
    D=bearing_rad*2;
    // thickness
    T=thickness;
    // clearance
    tol=gear_slop;
    number_of_planets=5;
    number_of_teeth_on_planets=8;
    approximate_number_of_teeth_on_sun=13;
    ring_outer_teeth = 71;
    // pressure angle
    P=45;//[30:60]
    // number of teeth to twist across
    nTwist=1;
    // width of hexagonal hole
    w=hole_rad*2;

    DR=0.5*1;// maximum depth ratio of teeth
    
    //derived variables
    m=round(number_of_planets);
    np=round(number_of_teeth_on_planets);
    ns1=approximate_number_of_teeth_on_sun;
    k1=round(2/m*(ns1+np));
    k= k1*m%2!=0 ? k1+1 : k1;
    ns=k*m/2-np; //actual number of teeth on the sun
    echo(ns);
    nr=ns+2*np; //number of teeth on the inside of the ring gear
    pitchD=0.9*D/(1+min(PI/(2*nr*tan(P)),PI*DR/nr));
    pitch=pitchD*PI/nr;
    //echo(pitch);
    helix_angle=atan(2*nTwist*pitch/T);
    //echo(helix_angle);
    phi=$t*360/m;
    
    
    translate([0,0,T/2]){
        //ring gear
        difference(){
            union(){
                cylinder(r=outer_rad, h=T, center=true);
                
                //spool holder cylinders - various diameters
                for(i=[0:len(filament_rads)-1]) translate([0,0,T/2-.01]) 
                    cylinder(r1=filament_rads[i], r2=filament_rads[i]-2, h=wall*(i+1));
            }
            
            //inner ring
            herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
            
            //cut out the center hole - stepped as well
            for(i=[0:len(filament_rads)-2]) hull(){
                translate([0,0,T/2-.01+i*wall]) 
                    cylinder(r=filament_rads[i]-wall, h=.1, $fn = 12);
                translate([0,0,T/2-.01+(i+1)*wall]) 
                    cylinder(r=filament_rads[i+1]-wall, h=.1, $fn = 12);
            }
            
            //cut out the outer ring
        }
        

        
        //sun gear
        rotate([0,0,(np+1)*180/ns+phi*(ns+np)*2/ns])
        difference(){
            mirror([0,1,0])
                herringbone(ns,pitch,P,DR,tol,helix_angle,T);
            cylinder(r1=hole_rad+slop*2, r2=hole_rad, h = T+1, center=true, $fn=6);
        }
        
        //planets
        for(i=[1:m])rotate([0,0,i*360/m+phi])translate([pitchD/2*(ns+np)/nr,0,0])
            rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi]){
                difference(){
                    herringbone(np,pitch,P,DR,tol,helix_angle,T);
                    
                    //slot to free the gears
                    cube([1.5,5.5,100], center=true);
                }
            }
        }
}