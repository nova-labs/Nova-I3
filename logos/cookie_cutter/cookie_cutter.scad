cutter();

base_height = 2;
cutter_height = 13;

module cutter(){
    difference(){
        union(){
            hull(){
                scale([1.05,1.05,1]) linear_extrude(height=base_height){
                    import("nova-labs-cutter.dxf", layer = "outside_edge");
                }
            }
            minkowski(){
                linear_extrude(height=base_height){
                    import("nova-labs-cutter.dxf", layer = "outside_edge");
                }
                cylinder(r1=2, r2=0, h=cutter_height, $fn=6);
            }
        }
        
        translate([0,0,-.1]) linear_extrude(height=base_height+cutter_height+1){
            import("nova-labs-cutter.dxf", layer = "inside_edge");
        }
    }
}