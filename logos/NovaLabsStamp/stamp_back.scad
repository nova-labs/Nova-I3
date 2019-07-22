


part = 2;

base_thick = 3;

if(part == 1){
    square_stamp(size = [78,38.25]);
}

if(part ==2){
    square_stamp(size = [113, 55.5]);
}

module square_stamp(size = [50,50]){
    min_rad = 1;
    x = size[0];
    y = size[1];
    difference(){
        union(){
            //the stamp!
            translate([0,0,base_thick/2]) minkowski(){
                cube([x, y, base_thick-min_rad], center=true);
                sphere(r=min_rad, $fn=6);
            }
            
            //a handle!
            for(i=[0,1]) mirror([i,0,0]) translate([x/4,0,base_thick]) sphere(r=y/4, $fn=6);
                
            hull(){
                for(i=[0,1]) mirror([i,0,0]) translate([x/4,0,base_thick+y*.4]) intersection(){
                    sphere(r=y/4, $fn=36);
                    cube([y/2-2, y/2-2, y/2-2], center=true);
                }
            }
        }
        
        translate([0,0,-100]) cube([200,200,200], center=true);
    }
}