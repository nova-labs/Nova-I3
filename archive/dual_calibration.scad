

dual_box(-1);

$fn=64;

module dual_box(nozzle = 0){
    if(nozzle >= 0){
        difference(){
            color([.8,.8,.8]) union(){
                translate([0,0,1]) cube([25,25,2], center=true);
                translate([0,0,3]) cube([10,10,6], center=true);
                translate([-10,-10,0]) cylinder(r=2, h=3);
            }
            dual_box(nozzle=-1);
        }
    }
    
    if(nozzle <= 0){
        color([.2,.2,.2]) difference(){
            translate([0,0,3]) cube([20,20,6], center=true);
            translate([0,0,3]) cube([15,15,8], center=true);
        }
    }
}