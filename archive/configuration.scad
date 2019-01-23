////////////////////////////
//  This is a Delta printer design by Paul Chase.
////////////////////////////


slop = .2;
wall = 5;



////////////////////////////
//Standard Sizes
////////////////////////////
m3_nut_rad = 6.05/2+slop;
m3_nut_height = 2.4+slop;
m3_rad = 3/2+slop;
m3_cap_rad = 3.25;
m3_washer_rad = 7/2+slop;

m4_nut_rad = 7.66/2+slop;
m4_nut_height = 3.2;
m4_rad = 4/2+slop;
m4_cap_rad = 7/2+slop;
m4_washer_rad = 2*m4_rad;

m5_nut_rad = 9.05/2+slop;
m5_nut_height = 4.7;
m5_rad = 5/2+slop;
m5_cap_rad = 8/2+slop;
m5_washer_rad = 2.1*m5_rad;
m5_cap_height = 2;

//for the tiny m3 bearings
623_width = 4;
623_rad = 10.05/2+slop;
623_bore = m3_rad;
623_inner_shoulder = 623_bore+(623_rad-m3_rad)/3;
623_outer_shoulder = 623_rad-(623_rad-m3_rad)/3;

//spacers
spacer_rad = 6/2+slop;
spacer_len = 2-slop/2;

eccentric_rad = 7.2/2+slop;
eccentric_washer_rad = 15/2+slop;
eccentric_screw_rad = 7/2+slop;
eccentric_height = 2.5;



//////////////////////////////
//Useful global functions
//////////////////////////////
module cap_cylinder(r=1, h=1, center=false){
	render() union() {
		cylinder(r=r, h=h, center=center);
		intersection(){
			rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
			translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
		}
	}
}

module 623_bearing(){
	union(){
		//outer
		color([.75,.75,.75]) difference(){
			cylinder(r=623_rad, h=623_width);
			translate([0,0,-.1]) cylinder(r=623_outer_shoulder, h=623_width+.2);
		}
		//middle
		color([.25,.25,.25]) difference(){
			translate([0,0,.25]) cylinder(r=623_outer_shoulder, h=623_width-.5);
			translate([0,0,-.1]) cylinder(r=623_inner_shoulder, h=623_width+.2);
		}
		//inner
		color([.75,.75,.75]) difference(){
			cylinder(r=623_inner_shoulder, h=623_width);
			translate([0,0,-.1]) cylinder(r=623_bore, h=623_width+.2);
		}
	}
}

module 623_bearing_cone(rad = 623_rad, height = 5, solid=1, nut_trap=0){
	cone_h = rad-623_inner_shoulder;
	if(nut_trap==1){
		if(solid==1){
			union(){
				echo("cone_height", cone_h);
				cylinder(r1=623_inner_shoulder, r2=rad, h=cone_h);
				translate([0,0,cone_h]) cylinder(r=rad, h=height-cone_h);
			}
		}else{
			//bore
			translate([0,0,-.1]) rotate([0,0,90]) cap_cylinder(r=623_bore, h=height+.5);
			//nut trap
			#translate([0,0,height-m3_nut_height]) hull(){
				cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=m3_nut_height+.5, $fn=6);
				translate([30,0,0]) cylinder(r1=m3_nut_rad, r2=m3_nut_rad+.5, h=m3_nut_height+.5, $fn=6);
			}
		}
	}else{
		if(solid==1){
			cylinder(r1=623_inner_shoulder, r2=rad, h=height);
		}else{
			translate([0,0,-.1]) rotate([0,0,90]) cap_cylinder(r=623_bore, h=height+.5);
		}
	}
}

module 623_bearing_mount(rad = 623_rad+2, height=5, solid=1){
	if(solid==1){
		union(){
			cylinder(r=rad, h=height);
		}
	}else{
		translate([0,0,height-623_width+slop]) cap_cylinder(r=623_rad, h=623_width*2);
		//translate([0,0,height-623_width]) cap_cylinder(r=623_outer_shoulder, h=623_width*2);
		translate([0,0,-height]) cap_cylinder(r=m3_cap_rad+.25, h=height*3);
	}
}

module barbell (x1,x2,r1,r2,r3,r4)
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
		difference(){
			union(){
				translate(x1) circle (r=r1);
				translate(x2) circle(r=r2);
				polygon (points=[x1,x3,x2,x4]);
			}
		translate(x3) circle(r=r3,$fa=5);
		translate(x4) circle(r=r4,$fa=5);
	}
}

function triangulate (point1, point2, length1, length2) =
point1 + length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b));

function rotated(a)=[cos(a),sin(a),0];
function rotate_vec(v,a)=[cos(a)*v[0]-sin(a)*v[1],sin(a)*v[0]+cos(a)*v[1]];