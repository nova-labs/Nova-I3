fan_size = 40;
hole_sep = 32;
hole_rad = 2;
center_rad = 38;

wall=2;

anglefan(angle=15);

module anglefan(angle=20){
    difference(){
        union(){
            fanMount();
        }
        
        fanHoles();
    }
}

module fanMount(){
    rad = (fan_size-hole_sep)/2;
    hull(){
        for(i=[-1, 1])
            for(j=[-1,1])
                translate([i*(fan_size/2-rad), j*(fan_size/2-rad), wall/2]) cylinder(r=rad, h=wall, center=true, $fn=32);
    }
}

module fanHoles(){
    for(i=[-1, 1])
        for(j=[-1,1])
            translate([i*hole_sep/2, j*hole_sep/2, -.1]) cylinder(r=hole_rad, h=wall*3, center=true, $fn=32);
    
    cylinder(r=center_rad, h=wall*3, center=true, $fn=64);
        
}