/*
 * Pick an STL and a layer height, and this will slice
 * it into DXFs ready for lasering.
 */

stl_file = "C:/Users/NovaLabs/Documents/paenian/Nova-I3/logos/octocat.stl";
layer_height = 2;
num_layers = 10;

xy_offset = [100,100,0];
stl_scale = [.8,.8,1];
peg_offset = [0,0,0];

project_copies();

peg_rad = 3;

module project_copies(){
    for(i=[0:1:sqrt(num_layers)]){
        for(j=[0:1:sqrt(num_layers)-1]){
            translate([xy_offset[0]*i, xy_offset[0]*j,0]){
                echo(i,j,sqrt(num_layers)*i+j);
                projection(cut = true) translate([0,0, -layer_height*(sqrt(num_layers)*i+j)]){
                    import(stl_file, convexity=10);
                    translate(peg_offset) cylinder(r=peg_rad, h=num_layers*layer_height*3, center=true);
                }
            }
        }
    }
}