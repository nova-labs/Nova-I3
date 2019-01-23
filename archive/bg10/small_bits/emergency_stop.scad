$fn=36;

emergency_stop();

stop_rad = 7.5/2;
stop_height = 10;
flange_height = 1;
flange_rad = stop_rad+2;

module emergency_stop(){
    union(){
        cylinder(r=flange_rad, h=flange_height, $fn=8);
        cylinder(r=stop_rad, h=stop_height);
    }
}
