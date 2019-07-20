big_stamp(size = 100);

/** Small stamp **/
//mirror([1,0,0]) scale([2,2,2]) stamp_base(base_thick = 1.5);
//mirror([1,0,0]) scale([2,2,2]) stamp_text(base_thick = 3);
//mirror([1,0,0]) scale([2,2,2]) stamp_border(base_thick = 3);
//mirror([1,0,0]) scale([2,2,2]) stamp_bulb(base_thick = 3);
//mirror([1,0,0]) scale([2,2,2]) stamp_all(base_thick = 3);

//DXFs for lasercutting
//projection() mirror([1,0,0]) scale([2,2,2]) stamp_base(base_thick = 1.5);
//projection(cut=true) mirror([1,0,0]) scale([2,2,2]) translate([0,0,-8]) stamp_all(base_thick = 3);

*scale([1.5,1.5,1]) logo();

sc = .1;

stamp_base_thick = 6;
base_thick = 1.5;
gear_thick = 2;
thread_thick = 2.5;
inner_thick = 2;

module big_stamp(gray=true, orange=true, size = 100){
    width = 681.214;
    scale([size/width, size/width, size/width]){
        import("NovaLabsTmStampWebsite.dxf", layer="border");
        
        
    }
}

module stamp_base(){
    sphere_rad = 1;
    minkowski(){
        translate([0,0,stamp_base_thick-base_thick+sphere_rad/2-.25]) hull() linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="border");
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="bulb");
        }
        
        //cylinder(r1=1, r2=.5, h=base_thick/2, $fn=12);
        scale([2,2,1]) sphere(r=sphere_rad/2, $fn=6);
    }
    
    hull() {
        minkowski(){
            translate([0,0,stamp_base_thick-base_thick+sphere_rad/2-.25]) hull() linear_extrude(height=base_thick-sphere_rad){
                scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="border");
                scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="bulb");
            }
        
            //cylinder(r1=1, r2=.5, h=base_thick/2, $fn=12);
            scale([2,2,1]) sphere(r=sphere_rad/2, $fn=6);
        }
        
        minkowski(){
            translate([2.25,3,0]) scale([.75,.75,1]) translate([0,0,sphere_rad/2-.25]) hull() linear_extrude(height=base_thick-sphere_rad){
                scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="border");
                scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="bulb");
            }
        }
    }
    
    minkowski(){
        translate([2.25,3,0]) scale([.75,.75,1]) translate([0,0,sphere_rad/2-.25]) hull() linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="border");
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="bulb");
        }
        scale([2,2,1]) sphere(r=sphere_rad, $fn=6);
    }
}

module stamp_all(){
    sphere_rad = .25;
    stamp_base();
    translate([0,0,stamp_base_thick-.5]) minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="border");
        }
        
        scale([1,1,1]) sphere(r=sphere_rad/2, $fn=6);
    }
    
    translate([0,0,stamp_base_thick-.5]) minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="text");
        }
        
        scale([1,1,1]) sphere(r=sphere_rad/2, $fn=6);
    }
    
    translate([0,0,stamp_base_thick-.5]) minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="bulb");
        }
        
        scale([1,1,1]) sphere(r=sphere_rad/2, $fn=6);
    }
}

module stamp_border(){
    sphere_rad = .333;
    stamp_base();
    translate([0,0,stamp_base_thick-.5]) minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="border");
        }
        
        scale([1,1,1]) sphere(r=sphere_rad/2, $fn=6);
    }
}

module stamp_text(){
    sphere_rad = .25;
    stamp_base();
    translate([0,0,stamp_base_thick-.5]) minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="text");
        }
        
        scale([1,1,1]) sphere(r=sphere_rad/2, $fn=6);
    }
}

module stamp_bulb(){
    sphere_rad = .25;
    stamp_base();
    translate([0,0,stamp_base_thick-.5]) minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs-stamp.dxf", layer="bulb");
        }
        
        scale([1,1,1]) sphere(r=sphere_rad/2, $fn=6);
    }
}

module logo(){
    union(){
        base();
        
        inner();
        threads();
        gear();
    }
}

module base(){
    sphere_rad = 1;
    minkowski(){
        linear_extrude(height=base_thick-sphere_rad){
            scale([sc,sc,sc]) import("nova-labs_icon.dxf");
        }
        //cylinder(r1=1, r2=.5, h=base_thick/2, $fn=12);
        scale([2,2,1]) sphere(r=sphere_rad/2, $fn=6);
    }
}

module gear(){
    minkowski(){
        linear_extrude(height=gear_thick*8/9){
            scale([sc,sc,sc]) import("nova-labs_icon.dxf", layer="gear");
        }
        cylinder(r1=.25, r2=.125, h=gear_thick*1/9, $fn=12);
    }
}

module threads(){
    intersection(){
        linear_extrude(height=thread_thick){
            scale([sc,sc,sc]) import("nova-labs_icon.dxf", layer="threads");
        }
        
        translate([-1,0,0]) rotate([0,0,-27]) scale([.9,.9,.75]) rotate([90,0,0]) cylinder(r=3, h=31, center=true, $fn=60);
    }
}

module inner(){
    minkowski(){
        linear_extrude(height=inner_thick*9/10){
            scale([sc,sc,sc]) import("nova-labs_icon.dxf", layer="inner");
        }
        cylinder(r1=.125, r2=.125/2, h=inner_thick*1/10, $fn=12);
    }
}


