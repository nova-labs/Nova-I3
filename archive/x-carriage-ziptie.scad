// X carriage for Prusa Mendel
// for use with Aleph Objects boltable PLA bushings
// and groovemount extruder
// includes belt tightener with ram
// optional fan mount, optional LED mounting holes
//
// raised extruder mount area allows extruder to overlap bushing mount screws
// for a narrower carriage
//
// John Ridley
// First revision September 8 2012

include <LM8UU_holder_ziptie.scad>

// m3
screw_thread_diameter = 3.5;
nut_wrench_size = 6.1;
nut_height = 3.2;

//m4
groovemount_screw_diameter = 4.2;

// metric
//screw_thread_diameter = 3.5;
//nut_wrench_size = ??;
//nut_height = 3.5;

nut_diameter = nut_wrench_size / cos(30);

// options
FANMOUNT_left = false;
FANMOUNT_right = false;

LEDMOUNT = false;

// fanmount parameters
FanHingeW=15;
FanHingeL=9;
FanHingeT=7;
M3NutD = nut_diameter;

$fn = 90;




// belt parameters
	belt_width = 6.5;
	belt_height = 2; // for belt clearance on tightener
	belt_clamp_width = 12;
	belt_clamp_height = 6;
	belt_to_screw_space = 2;
	belt_teeth_size = 1; // 1/2 of tooth pitch
	belt_teeth_height = 1;

// carriage parameters
	x_rod_separation = 50;
	belt_offset_from_center = 40;
	belt_clamp_spacing = 40;
	groovemount_screw_spacing = 56;
	groovemount_center_hole_dia = 48;
	groovemount_diameter =70;
	groovemount_elevation = 6; // to fit screw heads underneath
	bushing_hole_spacing = 24; // actually 23 but at 23 you can't fit two #6 nuts in there.
	bushing_hole_edge_clearance = 6;

	base_x = 70;
	base_y = x_rod_separation + body_width;
	base_z = 4;

// LED parameters
LED_diameter1  = 5.5; // diameter of main body (leave it a bit loose)
LED_height1 = 5; // length to extend diameter1
LED_diameter2 = 7.5; // diameter of base of LED
LED_height2 = 5; // length to extend diameter2;
LED_wall = 1.5; // wall width in excess of diameter2
LED_rotation = -10; // tip towards extruder
LED_sep = 10;

if (true)
{
	!union(){
		x_carriage();
	
		mirror([1,0,0]) intersection(){
			translate([base_x/2+6,0,0])
				rotate([0,0,90])
					fan_bracket(thickness = 6, boost_height = base_z-1.5, extension=15);
		
			for (x=[-1,1])
				translate([(base_x/2+10)*x, -20, 0])
					rotate([0,0,10*x])
						translate([-10,0,0])
						cube([20,base_y-17, 50]);
		}
	}


	translate([-9,0,0]) belt_clamp(height=base_z);
	translate([9,0,0]) belt_clamp(height=base_z, teeth = false);
	translate([0,50,0]) rotate([0,0,-90]) belt_tightener(teeth = true);

	translate([35,50,0]) ram();

	//if (FANMOUNT_left || FANMOUNT_right)

}

module x_carriage()
{

	difference()
	{
		x_carriage_solids();
		x_carriage_holes();
		
		for (i=[-1,1])
		{
			translate([i*(base_x/2 - body_length/2),-x_rod_separation/2,base_z])
				LM8UU_holder_null();
		}
		translate([0,x_rod_separation/2,base_z])
			LM8UU_holder_null();		

	}

	for (i=[-1,1])
	{
		translate([i*(base_x/2 - body_length/2),-x_rod_separation/2,base_z])
			LM8UU_holder();
	}
	translate([0,x_rod_separation/2,base_z])
		LM8UU_holder();

	if (LEDMOUNT) 
	{
		for (i=[-1,1])
		{
			translate([(LED_sep/2)*i,-base_y/2 + LED_diameter2*2,0])
				LED_holder(xrotation = LED_rotation);
		}
	}

	module x_carriage_solids()
	{
		union()
		{
			translate([0,0,base_z/2]) cube([base_x, base_y, base_z], center=true);
			cylinder(r=groovemount_diameter/2, h=groovemount_elevation);
		}

		for (i=[-1, 1])
			translate([i * belt_clamp_spacing/2,belt_offset_from_center, 0])
				belt_clamp(teeth=0);
	}

	module fan_mount()
	{
		translate([0,0, FanHingeT/2]) // bring up to the plane
		difference()
		{
			cube([FanHingeW, FanHingeL, FanHingeT], center=true);
			translate([FanHingeW/2-screw_thread_diameter,FanHingeL/2+0.05,0])
				rotate([90,0,0])
					cylinder(r=screw_thread_diameter/2, h=FanHingeW + 0.1);
			for (i=[-1,1])
			{
					translate([FanHingeW/2, 0, 0])
				rotate([0,i*45,0])
				translate([FanHingeW/2+1,0,0])
						cube([FanHingeW, FanHingeL, FanHingeT+1], center=true);
			}
		}
	}

	module x_carriage_holes()
	{
		// center hole for hotend
		difference()
		{
			cylinder(r=groovemount_center_hole_dia/2, h=base_z+groovemount_elevation+.1);
			// lay in some fill on the center hole
			translate([-(base_x/2), -(base_y/2), 0])
				cube([base_x,body_width, base_z]);
			translate([-(body_length/2), (base_y/2 - body_width), 0])
				cube([body_length,body_width, base_z]);
		}

		// place 3 clocked groovemount holes
		for (z=[-20,0,20])
			rotate([0,0,z])
				groovemount_holes();

		for (x=[-1,1])
			translate([belt_clamp_spacing/2*x, belt_offset_from_center - (belt_width+screw_thread_diameter)/2 - belt_to_screw_space, 0])
				cylinder(r=screw_thread_diameter/2, h=base_z);

		for (x=[-1,1])
			translate([(base_x/2+10.5)*x, -13, 0])
				rotate([0,0,10*x])
					translate([-10,0,0])
					cube([20,base_y-17, base_z+groovemount_elevation]);

		if (LEDMOUNT) // if these will be dropped in, make room for them
		{
			for (i=[-1,1])
				translate([(LED_sep/2)*i,-base_y/2 + LED_diameter2*2,0])
					LED_holder(voidobject=true);
		}
	}

	module groovemount_holes()
	{
		for (x=[-1,1])
		translate([x*(groovemount_screw_spacing/2), 0, 0])
		cylinder(r=groovemount_screw_diameter/2, h=base_z+groovemount_elevation);
		translate([0,0,groovemount_elevation]) cylinder(r=groovemount_screw_diameter, h=base_z+groovemount_elevation);
	}
}


module fan_bracket(thickness = 5, boost_height = 0, extension = 8) 
{
	fan_hole_separation=32;
	fan_diameter=36;
	fan_width = 41;

	height = nut_diameter * 1.1;

	difference()
	{
		union ()
		{
			translate([0,(thickness+extension)/2, (height + boost_height)/2])
				cube([fan_width, thickness+extension, height + boost_height], center=true);
		}
		for (i=[-1,1])
		{
			// screw holes
			translate([fan_hole_separation/2 * i, -0.05, nut_diameter/2 + boost_height])
				rotate([-90,0,0])
					cylinder(r=screw_thread_diameter / 2, h=thickness*2);

			// nut traps
			translate([fan_hole_separation/2 * i, thickness+.05-nut_height, nut_diameter/2 + boost_height])
				rotate([-90,0,0])
				hull() {
					rotate([0,0,30]) cylinder(r=nut_diameter/2, h=nut_height, $fn=6);
					translate([0,10,0]) rotate([0,0,30]) cylinder(r=nut_diameter/2, h=nut_height, $fn=6);
				}
		}
		// fan airspace
		translate([0,-0.05,fan_diameter/2+4])
		rotate([-90,0,0])
		cylinder(r=fan_diameter/2, h=thickness+extension+0.1);
	}

}


module belt_clamp(height=belt_clamp_height, teeth=true)
{
	difference()
	{
		union()
		{
			// square center part
			translate([-belt_clamp_width/2, -(belt_width + screw_thread_diameter + belt_to_screw_space)/2, 0])
				cube([belt_clamp_width, belt_width + screw_thread_diameter+belt_to_screw_space, height]);
			// rounded ends
			for (y=[-1,1])
				translate([0, y*(belt_width+screw_thread_diameter+belt_to_screw_space)/2, 0])
					cylinder(r=belt_clamp_width/2, h=height);
		}
		// screw holes
		for (y=[-1,1])
		{
			translate([0, y*((belt_width+screw_thread_diameter )/2+ belt_to_screw_space), 0])
				cylinder(r=screw_thread_diameter/2, h=height);
		}
		if (teeth)
		{
			// belt teeth
			for (x=[-belt_clamp_width/2 - belt_teeth_size/2: belt_teeth_size*2: belt_clamp_width/2])
				translate([x, -belt_width/2, height-belt_teeth_height])
					cube([belt_teeth_size, belt_width, belt_teeth_height]);
		}
	}
}


module belt_tightener()
{
	height = nut_diameter + belt_height;

	difference()
	{
		union()
		{
			// square center part
			translate([-belt_clamp_width/2, -(belt_width + screw_thread_diameter + belt_to_screw_space)/2, 0])
				cube([belt_clamp_width, belt_width + screw_thread_diameter+belt_to_screw_space, height]);
			// rounded ends
			for (y=[-1,1])
				translate([0, y*(belt_width+screw_thread_diameter+belt_to_screw_space)/2, 0])
					cylinder(r=belt_clamp_width/2, h=height);
		}
		// screw holes
		for (y=[-1,1])
		{
			translate([0, y*((belt_width+screw_thread_diameter )/2+ belt_to_screw_space), 0])
				cylinder(r=screw_thread_diameter/2, h=height);
		}
		// belt slot
		translate([-belt_clamp_width/2,-belt_width/2, 0])
			cube([belt_clamp_width, belt_width, belt_height]);
		//tightener hole
		translate([-belt_clamp_width/2-.001, 0, nut_diameter/2 + belt_height])
			rotate([0,90,0])
				union() 
				{
					cylinder(r=screw_thread_diameter/2, h=belt_clamp_width+.002);
					rotate([0,0,360/12])
					cylinder(r=nut_diameter/2, h=3, $fn=6);
				}

		if (teeth)
		{
		// belt teeth
		for (x=[-belt_clamp_width/2 - belt_teeth_size/2: belt_teeth_size*2: belt_clamp_width/2])
			translate([x, -belt_width/2, height-belt_teeth_height])
				cube([belt_teeth_size, belt_width, belt_teeth_height]);
		}
	}
}


module ram() 
{
	height = screw_thread_diameter*2.5;
	difference() 
	{
		translate([-height/2, 0, height/2])
		rotate([0,90,0])
		union()
		{
			translate([0, -height/2,0])
				cube([height/2, height, height]);
			cylinder(r=height/2, h=height);
		}
		cylinder(r=screw_thread_diameter / 2, h=height/2);
	}
}

// if voidobject, make it a solid thing so that it can be used to subtract a hole for itself out of a larger body
module LED_holder( voidobject = false, xrotation = 0)
{
	rotation_extension = (LED_diameter2/2 + LED_wall) * sin(abs(xrotation));
	difference() // this just chops off anything that hange below the z=0 plane after rotation
	{
		translate([0,0,-rotation_extension]) // pull down to the z=0 plane
			rotate([xrotation,0,0])
				if (voidobject)
				{
					// shrink the void dropout a bit so we don't leave a gap.
					cylinder(r= (LED_diameter2/2 + LED_wall) * 0.9, h=LED_height1 + LED_height2 + rotation_extension );
				}
				else
				{
					difference ()
					{
						cylinder(r= LED_diameter2/2 + LED_wall, h=LED_height1 + LED_height2 + rotation_extension );
						cylinder(r=LED_diameter1/2, h=LED_height1 + LED_height2 + rotation_extension);
						cylinder(r=LED_diameter2/2, h=LED_height2 + rotation_extension);
					}
				}

		translate([-LED_diameter2, -LED_diameter2, -rotation_extension*2])
			cube([LED_diameter2*2, LED_diameter2*2, rotation_extension*2]);
	}
}
