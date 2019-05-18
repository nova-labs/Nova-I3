scale([.4,.4,.4]) cutter();
scale([.4,.4,.4]) texture();

*bowl();

base_height = 4;
cutter_height = 17;
bowl_height = 100;

module bowl($fn=90){
    scale([1,1,1]) linear_extrude(height=bowl_height, twist=90, scale=1.5){
        import("nova-labs-cutter.dxf", layer = "outside_edge");
    }
}

module cutter(){
    difference(){
        union(){
            hull(){
                scale([1.1,1.1,1]) linear_extrude(height=base_height){
                    import("nova-labs-cutter.dxf", layer = "outside_edge");
                }
            }
            minkowski(){
                linear_extrude(height=base_height){
                    import("nova-labs-cutter.dxf", layer = "outside_edge");
                }
                cylinder(r1=4, r2=2, h=cutter_height, $fn=6);
            }
        }
        
        translate([0,0,-.1]) linear_extrude(height=base_height+cutter_height+1){
            import("nova-labs-cutter.dxf", layer = "outside_edge");
        }
    }
}

module texture(){
    union(){
        //base
        linear_extrude(height=base_height){
            import("nova-labs-cutter.dxf", layer = "inside_edge");
        }
        
        linear_extrude(height=base_height*3){
            import("nova-labs-cutter.dxf", layer = "gear_bulb");
        }
    }
}