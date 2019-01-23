// Box size
boxwidth = 50;
boxlength = 111;
boxheight = 50;
boxwall = 2;
facewall = 3;

// Plug outlet hole

plugholesep = 40;
plugholerad = 2.4;
plugnut_rad = 5.7;
plugwidth= 28.5;
pluglength = 48.5;
plugheight = 5;
plugbevel = 6;

offsetx = 10.75+5;
offsety = 55;
offsetz = 1.6;
clearance = 1.5;

// Clip ridges

clipdiameter = 3;
clipspacing = 4;
clipfirst = 3;
cliptop = 12.5;
clipbottom = 36.5;

// Cable exit 
cutoutoffsetx = 18;
cutoutoffsety = 8;
cableoutwidth = 45;
cableoutheight = 10;
cableoffsety = 5;
cableoffsetx = 45;

slop = .2;
m5bolt_dia = 5;
m5bolt_rad = m5bolt_dia/2+slop;
m5bolt_cap_dia = 10+slop;
m5bolt_cap_rad = m5bolt_cap_dia/2;
m5nut_dia = 9.2;
m5nut_rad = m5nut_dia/2+slop;
m5nut_height = 3.25;
lock_nut_height = 5.25;

$fn=32;

translate([80,0,0]) snap_cover();

//half_cover();


module clip(height,diameter,spacing)
{
	translate ([0,-.25,0]) scale([1,.75,1]) rotate ([0,90,0]) cylinder (r=diameter/2, h=height);
	translate ([0,-.25,spacing]) scale([1,.75,1]) rotate ([0,90,0]) cylinder (r=diameter/2, h=height);
}

module slot(height,diameter,spacing, solid=1)
{
    translate([boxwidth/2,0,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing])
	if(solid==1){
        hull(){
            translate([-plugnut_rad*3/2,-5.3,0]) cube([plugnut_rad*3,5,height]);
            translate([-plugnut_rad*3/2,-.3,-10])  cube([plugnut_rad*3,.25,height]);
        }
    }else{
        hull(){
            rotate([90,0,0]) cylinder(r=plugholerad+slop, h=15, center=true);
            translate([0,0,height+5]) rotate([90,0,0]) cylinder(r=plugholerad+slop, h=15, center=true);
        }
        translate([0,-boxwall,0]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r1=plugnut_rad+slop, r2=plugnut_rad+slop*2, h=5, $fn=4);
        translate([0,-boxwall,0]) hull(){
            translate([0,0,plugnut_rad]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r1=plugnut_rad+slop, r2=plugnut_rad+slop*2, h=5, $fn=4);
            translate([-1,0,height]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r1=plugnut_rad+slop+2, r2=plugnut_rad+slop*2+2, h=5, $fn=4);
        }
    }
}

module bevelbox(width,length,height,bevel, solid=0)
{
    wall=2.5;
    if(solid==0){
        translate([0,0,-.1]) linear_extrude (height = height+.1) polygon([[0,bevel],[bevel,0],[length,0],[length,width],[bevel,width],[0,width-bevel]], convexity=1);

	*   translate ([0,0,offsetz]) linear_extrude (height = height) polygon([[0-clearance,bevel-clearance],[bevel-clearance,0-clearance],[length+clearance,0-clearance],[length+clearance,width+clearance],[bevel-clearance,width+clearance],[0-clearance,width-bevel+clearance]], convexity=1);

        for(i=[0,1]) translate([0,width/2,0]) mirror([0,i,0]) translate([length/2+1,plugholesep/2,-.1]) {
            cylinder(r=plugholerad, h=height+1);
            hull(){
                translate([0,0,offsetz]) rotate([0,0,45]) cylinder(r=plugnut_rad, h=height, $fn=4);
                translate([0,10,offsetz]) rotate([0,0,45]) cylinder(r=plugnut_rad+.5, h=height, $fn=4);
            }
        }
    }else{
        //extra nut support
        for(i=[0,1]) translate([0,width/2,0]) mirror([0,i,0]) translate([length/2+1,plugholesep/2,-.1]) {
            translate([0,0,offsetz]) rotate([0,0,45]) cylinder(r=plugnut_rad+wall, h=height, $fn=4);
        }
    }
}

module casing(w,l,h,t)
{
	walls = t*2;
        minrad = 2;
        outer_minrad = 3;
	difference () {
                //cube ([w,l,h]);
                union(){
                    minkowski(){
                        translate([outer_minrad,outer_minrad,0]) cube ([w-outer_minrad*2,l-outer_minrad*2,h-outer_minrad/2]);
                        intersection(){
                            cylinder(r=outer_minrad,h=outer_minrad/2);
                            sphere(r=outer_minrad);
                        }
                    }
                    *hull(){
                        translate ([boxwidth-offsetx+4,offsety,0]) rotate ([0,0,90]) bevelboxoutline(plugwidth,pluglength,plugheight,plugbevel);
                    }
                }
                //translate ([t,t,facewall]) cube ([w-walls,l-walls,h]);
                minkowski(){
                    translate ([t+minrad,t+minrad,facewall+minrad]) cube ([w-walls-minrad*2,l-walls-minrad*2,h-minrad*2]);
                    sphere(r=minrad);
                }
	}
}

module vent(w, l, h, r, n=5){
	ws = w/n;
	ls = l/n;
	for(i=[0:n-1]) hull(){
		translate([ws/2+i*ws, ls/2, -.1]) cylinder(r=r, h=h+1);
		translate([ws/2, ls/2+i*ls, -.1]) cylinder(r=r, h=h+1);
	}
	for(i=[1:n-1]) hull(){
		translate([ws/2+i*ws, l-ls/2, -.1]) cylinder(r=r, h=h+1);
		translate([w-ws/2, ls/2+i*ls, -.1]) cylinder(r=r, h=h+1);
	}
}

module clearance(w,l,h,o)
{
	translate ([-1,-1,o]) cube([w+2,l+2,h]);
}

module snap_cover(){
    mount_offset = 8;
    difference () {
        union(){
            casing (boxwidth,boxlength,boxheight,boxwall);
            translate ([mount_offset,boxlength,0]) slot (boxheight-(clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing),clipdiameter,clipspacing+clipdiameter, 1);
            translate([mount_offset,0,0]) mirror ([0,1,0]) slot (boxheight-(clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing),clipdiameter,clipspacing+clipdiameter, 1);
            intersection(){
                translate ([boxwidth-offsetx+5,offsety,0]) rotate ([0,0,90]) bevelbox(plugwidth,pluglength,plugheight/2,plugbevel,1);
                cube ([boxwidth,boxlength,boxheight]);
            }
        }

        translate ([boxwidth-offsetx+5,offsety,0]) rotate ([0,0,90]) bevelbox(plugwidth,pluglength,plugheight,plugbevel);
        translate ([cableoffsety+1,boxlength/2-(cableoutheight/2)-cableoffsetx+1,-.1]) minkowski(){
            cube([cableoutheight-2,cableoutwidth-2,boxwall+2]);
            cylinder(r=1);
        }
        clearance (cutoutoffsety,boxlength,boxheight,boxheight-cutoutoffsetx);

        translate([cableoffsety+boxwall+cableoutheight-1.5,-1,0]) vent(34-boxwall,58,5,3.5,3);
        
        //////////slots!
        translate([mount_offset,boxlength,0]) slot (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter, 0);
        translate([mount_offset,0,0]) mirror([0,1,0]) slot (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter, 0);
        
        ////strain relief lines
        translate([0,boxlength/2,boxheight/2])
        for(i=[0,1]) mirror([0,i,0]) translate([0,boxlength/4,0]) hull(){
            rotate([0,90,0]) cylinder(r=3, h=20, center=true);
            translate([0,0,-boxheight/4]) rotate([0,90,0]) cylinder(r=3, h=20, center=true);
        }
        
        translate([boxwidth,boxlength/2,boxheight/2])
        for(i=[0,1]) mirror([0,i,0]) translate([0,boxlength/4,0]) hull(){
            translate([0,0,boxheight/4]) rotate([0,90,0]) cylinder(r=3, h=20, center=true);
            translate([0,0,-boxheight/4]) rotate([0,90,0]) cylinder(r=3, h=20, center=true);
        }
    }
}

module half_cover(){
    difference () {
        casing (boxwidth,boxlength,boxheight,boxwall);

        #translate ([boxwidth,offsety,boxheight-plugnut_rad*2]) rotate([0,-90,0]) rotate([0,0,90]) bevelbox(plugwidth,pluglength,plugheight,plugbevel);
        translate ([cableoffsety,boxlength/2-(cableoutheight/2)-cableoffsetx,-.1]) cube([cableoutheight,cableoutwidth,boxwall+2]);
        clearance (cutoutoffsety,boxlength,boxheight,boxheight-cutoutoffsetx);

        translate([cableoffsety+boxwall+cableoutheight,boxwall,0]) vent(34.75-boxwall,52.5,5,1.75,5);
    }

    translate ([boxwidth-clipbottom,0,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing]) clip (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter);

    translate ([boxwidth-clipbottom,boxlength,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing]) clip (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter);
}
