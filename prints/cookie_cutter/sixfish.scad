skinny_cutter();

module cutter(){
    minkowski(){
        linear_extrude(height=5) import("sixfish.dxf", layer="rim");
        cylinder(r1=2, r2=0, h=4, $fn=6);
    }
}

module skinny_cutter(){
    jitter = .45;
    steps = 6;
    s = 2;
    union(){
        //the cutter
        minkowski(){
            cylinder(r1=2, r2=0, h=5, $fn=6);
            intersection_for(n=[0:360/steps:359]){
                rotate([0,0,n]) translate([jitter,0,0]) rotate([0,0,-n]) scale([s,s,1]) linear_extrude(height=7) import("sixfish.dxf", layer="rim");
            }
        }
        
        //border around the bottom
        minkowski(){
            cylinder(r1=4, r2=2, h=3, $fn=6);
            scale([s,s,1]) linear_extrude(height=2) import("sixfish.dxf", layer="rim");
        }
    }
}