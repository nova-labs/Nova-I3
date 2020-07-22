sc = .6;

minkowski(){
    linear_extrude(height=3){
        scale([sc,sc,sc]) import("novalabs_ppe_circular.dxf");
    }
    
    hull(){
        cylinder(r=.125, h=1, $fn=6, center=true);
        cylinder(r=.25, h=.5, $fn=6, center=true);
    }
}
