
part = 0;

//makey backing for lasercutting
if(part == 0)
    makey_back();

if(part == 1)
    makey_stamp();
    
$fn = 36;

module makey_back(thick = 3, handle = true){
    handle_rad = 9;
    handle_ball = 11;
    handle_height = 7;
    handle_inset = 3;
    
    union(){
        linear_extrude(height = thick){
            import("makey_outlined.dxf", layer="outline");
        }
        
        if(handle == true) translate([0,0,thick-.1]) {
            difference(){
                union(){
                    cylinder(r=handle_rad, h=handle_height);
                    translate([0,0,handle_height]) sphere(r=handle_ball-handle_inset/2);
                }
                translate([0,0,handle_height/2]) scale([1,1,handle_height/(handle_inset*2)]) rotate_extrude(){
                    translate([handle_ball,0,0]) circle(r=handle_inset);
                }
            }
        }
    }
}

module makey_stamp(thick = 3){
    union(){
        makey_back(thick = thick/2, handle = false);
        translate([0,0,thick/2]) minkowski(){
            linear_extrude(height = thick){
                import("makey_outlined.dxf", layer="makey");
            }
            sphere(r=.25, $fn=8);
        }
    }
}