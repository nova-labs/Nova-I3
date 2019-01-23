include <Write.scad>

height = 60;
rad = 5;
base_rad = 8;

sides=6;

plastic = "abs";
layer_height = ".2";
infill = "10%";
walls = "3";
temp = "235";
printer = "bg7";


ztest(
        plastic = "abs",
        layer_height = ".2L",
        infill = "10%",
        walls = "3w",
        temp = "235c",
        printer="bg7");

module ztest(plastic = "abs", layer_height = ".2", infill = "10%", walls = "3", temp = "235", printer="bg7"){
    union(){
        //caps
        for(i=[0,1]) translate([0,0,i*height]) mirror([0,0,i]){
            //cylinder(r1=(rad*1.5)/cos(180/4), r2=rad/cos(180/4), h=height/4, $fn=4);
            cylinder(r1=base_rad, r2=rad, h=height/3, $fn=sides);
        }
        
        //center
        cylinder(r=rad, h=height, $fn=36*2);
        
        //write some info
        writeBase(plastic, 0, 0);
        writeBase(layer_height, 120, 0);
        writeBase(infill, 240, 0);
        writeBase(walls, 0, 1);
        writeBase(temp, 120, 1);
        writeBase(printer, 240, 1);
    }
}

module writeBase(text = "test", rot = 0, top = 0){
   tilt = -atan((base_rad-rad)/(height/3));
    
    translate([0,0,top*height*10/12])
    //mirror([0,0,top])
    translate([0,0,height/12]) 
    rotate([0,0,rot])
    rotate([tilt*top*-2,0,0])
    rotate([tilt,0,0]) writecylinder(text, [0,0,0], (base_rad+rad)/2, 10, t=1, h=rad-1, rotate=90, font="orbitron.dxf", center=true);
}