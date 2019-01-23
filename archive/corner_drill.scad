


corner_drill(bore = 17.5/2);


module corner_drill(bore = 10){
	width = 70;
	height = 60;
	wall = 4;

	difference(){
		union(){
			rotate([0,90,0]) cylinder(r=width/2+wall, h=width, center=true, $fn=4);

			for(j=[0:1]) mirror([0,j,0]) for(i=[-width/2+wall:(width-wall*2)/1:width/2]) translate([i,width/2+wall,0]) rotate([45,0,0]) cylinder(r1=wall, r2=wall, h=(width+wall*2+wall*sqrt(2))*cos(45), $fn=4);

			//roof gusset
			translate([0,0,width/2+wall]) rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=wall/cos(180/8), h=width, $fn=8, center=true);

			//center gusset
			for(j=[0:1]) mirror([0,j,0]) translate([0,width/2+wall,0]) rotate([45,0,0]) scale([1,4,1]) cylinder(r1=1, r2=wall, h=53.2, $fn=4);
	
			cylinder(r=bore+wall, h=height);
		}

		rotate([0,90,0]) cylinder(r=width/2, h=width+1, center=true, $fn=4);
		cylinder(r=bore/cos(180/18), h=width+5, $fn=32);

		//ensure a square corner
		translate([0,0,width/2]) rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=.5, h=width+2, $fn=32, center=true);

		//flatten
		translate([0,0,-100]) cube([200,200,200],center=true);
	}
}