//K. Toppenberg
//11/23/18

//Uses switches below to allow rendering in 2 parts.  I am doing this for sand casting into metal object

show_as_2_parts       = 1;
  show_top_half       = 1;
  show_bottom_half    = 0;
  use_connecting_pin  = 1;
  show_pin            = 0;
show_debug_points     = 0;



//==================== 

y_scale = 10;
pin_diam = 3;
pin_height = 5;
tolerance = 0.5;

//Construct array of points for each of the parts of the top's curves
sig_pts = sigmoid_pts([], -3, 0.1, 6, y_scale, [3,-0.4]);
//the center
curve_1_pts = circum_pts(pts = [], angle = -90, rad=1.2, angle_step=1, end_angle=90, offset = [9,10.57+0.2]);
//bottom
curve_2_pts = one_over_x_pts(pts=[], x=8, step_x = -0.01, end_x = 0.4, y_scale=4, offset=[1, y_scale+1.47]);
//top
curve_3_pts = circum_pts(pts = [], angle = 0, rad=1.35, angle_step=1, end_angle=90, offset = [0,19.2 + 7]);

//Combine array of points into 1 composite array
all_pts = concat(sig_pts, curve_1_pts, , curve_2_pts, curve_3_pts, [[0,0]]);


if (show_debug_points) debug_points();
  
if (show_as_2_parts) {
  diam = 22;
  ht=33;
  transition_z = 12;
  gap=1;
  if (show_top_half) {
    difference() {
      intersection() {
        rotate_extrude($fn=200) 
          polygon(points=all_pts);
        translate([-diam/2, -diam/2, transition_z+gap])
          cube([diam,diam,ht-transition_z]);
      }
      union() {
        if (use_connecting_pin) {
          translate([0,0,transition_z - 0.1])
            cylinder(d=pin_diam + tolerance, h=pin_height/2 + tolerance, $fn=50);
        }  
      }  
      
    }  
  }  
  if (show_bottom_half) {
    difference() {
      intersection() {
        rotate_extrude($fn=200) 
          polygon(points=all_pts);
        translate([-diam/2, -diam/2, 0])
            cube([diam,diam,transition_z]);
      }
      union() {
        if (use_connecting_pin) {
          translate([0,0,transition_z - pin_height/2 - tolerance+ 0.1])
            cylinder(d=pin_diam + tolerance, h=pin_height/2 + tolerance, $fn=50);
        }  
      }  
    }  
  }  
  if (show_pin) {
    translate([30,0,0])
      cylinder(d=pin_diam, h=pin_height, $fn=50);  
  }  
  
} else {  
  rotate_extrude($fn=200) 
    polygon(points=all_pts);
}  

//============================================

function one_over_x_pts(pts, x, step_x, end_x, y_scale=10, offset=[0,0]) =
  let(y=y_scale * 1/x)
  x > end_x ?
    concat(pts, [[x,y]+offset], one_over_x_pts(pts, x+step_x, step_x, end_x, y_scale, offset))
  :
    pts;  
//-- End function ------------

function sigmoid_pts(pts, x, step_x = 0.1, end_x=6, y_scale=10, offset=[0,0]) =
  let(y = y_scale * 1 / (1 + exp(-x)))
  x < end_x ?
    concat(pts, [[x,y]+offset], sigmoid_pts(pts, x+step_x, step_x, end_x, y_scale, offset))
  :
    pts;  
//-- End function ------------

function circum_pts(pts, angle, rad, angle_step = 1, end_angle=360, offset = [0,0]) = 
  let(x =rad * cos(angle))
  let(y =rad * sin(angle))  
  angle < (end_angle+1) ? 
    concat(pts, [[x,y]+offset], circum_pts(pts, angle+angle_step, rad, angle_step, end_angle, offset)) 
  : 
    pts;
//-- End function ------------

//===========================================

module debug_points() {
  for (i=[0:1:len(sig_pts)-1]) {
    x = sig_pts[i].x;
    y = sig_pts[i].y - sig_pts[0].y;
    translate([x,y]) sphere(r=0.1, $fn=50);
  }  
  
  for (i=[0:1:len(curve_1_pts)-1]) {
    translate(curve_1_pts[i]) sphere(r=0.1, $fn=50);
  }  
  
  for (i=[0:1:len(curve_2_pts)-1]) {
    translate(curve_2_pts[i]) sphere(r=0.1, $fn=50);
  }  
  
  for (i=[0:1:len(curve_3_pts)-1]) {
    x = curve_3_pts[i].x;
    y = curve_3_pts[i].y;
    translate([x,y]) sphere(r=0.1, $fn=50);
  }  
  
  for (i=[0:1:len(all_pts)-1]) {
    x = all_pts[i].x;
    y = all_pts[i].y;
    translate([x,y]) sphere(r=0.1, $fn=50);
  }  
  
}  
