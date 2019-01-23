
wall = 2;
slop = .2;

bearing_rad = 14/2;
bearing_thick=5;

flange_rad = bearing_rad+wall*2;

belt_thick = 6;

idler_flange_inner();

translate([25,0,0]) idler_flange_outer();

module idler_flange_inner(){
    difference(){
        union(){
            cylinder(r=flange_rad, h=wall/4);
            translate([0,0,wall/4]) cylinder(r1=flange_rad, r2=flange_rad-wall, h=wall/4);
            cylinder(r1=bearing_rad+wall/2, r2=bearing_rad+wall/2-slop, h=wall/2+bearing_thick);
        }
        translate([0,0,wall/2]) cylinder(r=bearing_rad+slop, h=bearing_thick+1);
        translate([0,0,-1]) cylinder(r=bearing_rad-wall/2, h=bearing_thick);
    }
}

module idler_flange_outer(){
    difference(){
        union(){
            cylinder(r=flange_rad, h=wall/4);
            translate([0,0,wall/4]) cylinder(r1=flange_rad, r2=flange_rad-wall, h=wall/4);
            cylinder(r=bearing_rad+wall, h=wall/2+bearing_thick);
        }
        translate([0,0,wall/2]) cylinder(r1=bearing_rad+wall/2, r2=bearing_rad+wall/2+slop, h=bearing_thick+1);
        translate([0,0,-1]) cylinder(r=bearing_rad-wall/2, h=bearing_thick);
    }
}