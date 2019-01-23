//Design for an add-on conveyor belt for I3 3D printers.

//The belt attaches to the heated bed front and rear, reducing the build height a smidge.
//Hopefully not too much.

slop = .2;

//bed variables
bed_width = 214;
bed_screw_sep = 209;
bed_thick = 3;
bed_lift = 6.5; //6.5mm spacers under the bed.  This will likely replace them.

//screw variables
m3_rad = (3+slop)/2;

//bearing variables - 625, 5x16x5
bearing_rad = 16/2;
m5_rad = (5+slop)/2;
bearing_thick = 5;
bearing_rotary_rad = 8/2;

//roller variables
roller_rad = bearing_rad;
roller_big_rad = bearing_rad+2;
roller_len = bed_width;

%bed();

translate([-bed_screw_sep/2,-bed_screw_sep/2,0 ])
roller_mount();

//total length of roller is 214
roller();

module roller(){
    part_len = roller_len/3-slop;
    
    //angled ends
    for(i=[0:1]) translate([roller_rad*3*i,0,0]) difference(){
        cylinder(r2=roller_rad, r1=roller_big_rad, h=part_len);
        
        translate([0,0,-.1]) cylinder(r=m5_rad, h=part_len+1);
    }
    
    //straight middle
    translate([roller_rad*3*-1,0,0])
    difference(){
        cylinder(r=roller_big_rad, h=part_len);
        
        translate([0,0,-.1]) cylinder(r=m5_rad, h=part_len+1);
    }
    
}

module bed(){
    difference(){
        union(){
            translate([0,0,bed_thick/2]) cube([bed_width, bed_width, bed_thick], center=true);
        }
        for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0]) translate([bed_screw_sep/2, bed_screw_sep/2, 0]) cylinder(r=m3_rad, h=bed_thick*3, center=true);
    }
}

//first try: one mount per corner, using the heated bed itself to square things up.
//Need to make two of these able to tension the belt, and one or two to hold a motor.
module roller_mount(){
    wall = 3;
    
    mount_width = 15;
    
    roller_drop = 1;    //distance roller is below the bed
    mount_thick = bearing_rad*2+roller_drop+slop;
    
    bed_corner  = (bed_width-bed_screw_sep)/2-slop; //the distance from screwhole center to edge of bed
    
    difference(){
        union(){
            //bed mount, + lift
            translate([0,0,(mount_thick+bed_thick)/2]) cube([mount_width, mount_width, mount_thick+bed_thick], center=true);
            
            //the bearing mount
            translate([-bearing_thick/2-bed_corner-wall/2,-bearing_rad*2, mount_thick-bearing_rad-roller_drop]) rotate([0,90,0]) cylinder(r=bearing_rad+wall, h=bearing_thick+wall, center=true);
        }
        //bed mounting hole
        cylinder(r=m3_rad, h=mount_thick*4, center=true);
        
        //cut out the bed corner
        translate([10 - bed_corner,10 - bed_corner,mount_thick+10]) cube([20,20,20], center=true);
        
        //the bearing
        translate([-bearing_thick-bed_corner,-bearing_rad*2, mount_thick-bearing_rad-roller_drop]) rotate([0,90,0]) cylinder(r=bearing_rad, h=bearing_thick+mount_thick);
        //center of bearing cutout
        translate([-bearing_thick/2-bed_corner,-bearing_rad*2, mount_thick-bearing_rad-roller_drop]) rotate([0,90,0]) cylinder(r=bearing_rad-wall/2, h=bearing_thick*3, center=true);
        
        //lop off the bottom
        translate([0,0,-50]) cube([100,100,100], center=true);
    }
}
