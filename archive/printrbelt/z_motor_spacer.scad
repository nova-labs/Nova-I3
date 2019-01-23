in = 25.4;

screw_sep = in*(1+1/8);
screw_rad = 2.125;

width = screw_sep + screw_rad*6;
length = in;
height = in/2;

screw_len = 25;
// 20 - 12.5 = 7 - 3 = 4

z_motor_spacer();

$fn=32;

module z_motor_spacer(){
    min_rad = in/8;
    
    difference(){
        union(){
            hull() for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0]) translate([width/2-min_rad, length/2-min_rad, 0]){
                cylinder(r=min_rad, h=height);
            }
        }
        
        for(i=[0:1]) mirror([i,0,0]) translate([screw_sep/2, 0, -.1]){
            cylinder(r=screw_rad, h=height+.2);
        } 
    }
}