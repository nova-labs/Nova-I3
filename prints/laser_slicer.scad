/*
 * Pick an STL and a layer height, and this will slice
 * it into DXFs ready for lasering.
 */

stl_file = "C:/Users/NovaLabs/Documents/paenian/Nova-I3/logos/octocat.stl";
layer_height = 2;

part = 0;


if(part == 0){
    project() import(stl_file);
}