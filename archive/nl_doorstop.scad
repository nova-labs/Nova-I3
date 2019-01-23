angle=7.5;
rise = 6;

difference(){
	scale([3,3,5]) import("novalabs_fixed.stl");
	
	translate([0,0,50+rise]) rotate([angle,0,0]) cube([100,100,100], center=true);  
}
%translate([0,0,-50]) cube([100,100,100], center=true);