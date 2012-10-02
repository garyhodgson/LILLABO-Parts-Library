/**
Parts Library for Lillabo Train Set from Ikea.
(Also compatible with Brio sets)

by Gary Hodgson

*/

/* indexes */
l=0;
w=1;
h=2;
d=0;

/* Track Dimensions*/
track_height = 12;
track_width = 40;
rut_spacing = 20;
rut_width = 6;
rut_depth = 4;
track_length_short = 50;
track_length_medium = 150;
track_length_long = 202;
double_tracks = [[16,3],[10,3],[10,6],[-10,6],[-10,3],[-16,3],[-16,6],[-20,6],[-20,-6],[-16,-6],[-16,-3],[-10,-3],[-10,-6],[10,-6],[10,-3],[16,-3],[16,-6],[20,-6],[20,6],[16,6]];
single_tracks = [[16,3],[10,3],[10,6],[-10,6],[-10,3],[-16,3],[-16,6],[-20,6],[-20,-6],[20,-6],[20,6],[16,6]];

/* Curved Track Dimensions*/
track_inner_circumference = 135*8;
track_inner_diameter = track_inner_circumference/ 3.1415;
track_inner_radius = track_inner_diameter/2;
track_center_radius = track_inner_radius + track_width/2;
track_outer_radius = track_inner_radius + track_width;
track_cutout_height = 20;
track_cutout_width = 10;

/* Other Dimensions*/
peg_pin_dia = 12;
peg_dims = [16, peg_pin_dia, track_height];
block_dims = [56,33,63];
tolerance = 0.1;

lightweight_default=true;

//buffer();
//set();
//curved_track();
short_track();
//medium_track();
//long_track();
//track_set();
//peg();
//hole();
//block();

module buffer() {
	post_height=25;
	post_diameter=10;

	translate([0, 0, post_diameter/2])
	rotate([0,-90,0]) {

		track(10, ruts=false, b="none", lightweight=false);
		
		translate([0, track_width/4, post_height/2])
			cylinder(r=post_diameter/2, h=post_height, center=true);

		translate([0, -track_width/4, post_height/2])
			cylinder(r=post_diameter/2, h=post_height, center=true);

		translate([0, 0, post_height])
			cube([10, track_width, 10], center=true);

		translate([7, 0, post_height])
		rotate([0,90,0])
			cylinder(r=post_diameter/2, h=5, center=true);
		translate([11, 0, post_height])
		rotate([0,90,0])
			cylinder(r1=post_diameter/2,r2=post_diameter/1.5, h=3, center=true);
	}
}

module set() {
	translate([-track_width*2, 0, 0])
		curved_track(lightweight=true);
	translate([0, -track_width*2, 0])
		short_track();
	translate([0, -track_width*4, 0])
		medium_track();
	translate([0, -track_width*6, 0])
		long_track();
	translate([0, -track_width*8, 0])
		track(50, a="peg", b="peg", lightweight=true);
	translate([0, -track_width*10, 0])
		track(50, a="hole", b="hole", lightweight=true);
	translate([track_width, 0, 0])
		peg();
	translate([track_width*2, 0, 0])
		hole();
	translate([track_width, track_width*2, 0])
		block();
}

module track_set() {
	xx = 50;
	track(xx, a="peg", b="peg", lightweight=true);
	translate([0,50,0])
	track(xx, a="hole", b="hole", lightweight=true);
	translate([0,100,0])
	track(xx, a="peg", b="hole", lightweight=true);
	translate([0,150,0])
	track(xx, a="hole", b="peg", lightweight=true);
}

/**
* a/b = connectors, either: peg, hole, or none
*/
module curved_track(a="hole", b="hole", lightweight=lightweight_default) {
	
	function a_offset(peg_or_hole) = peg_or_hole=="hole" ? -7 : -3;
	function b_offset(peg_or_hole) = peg_or_hole=="hole" ? -7 : -3;

	translate([track_center_radius, 0, 0]) {
		difference(){
			rotate_extrude($fn=200)
				translate([track_center_radius, 0, 0])
					polygon(double_tracks);

			translate([0, -track_outer_radius, -(track_height+1)/2])
				cube([track_outer_radius+1, (track_outer_radius+1)*2, track_height+2]);

			translate([-track_outer_radius, -track_outer_radius, -(track_height+1)/2])
				cube([track_outer_radius+1, track_outer_radius, track_height+2]);

			rotate([0,0,180+45])			
			translate([-track_outer_radius, -track_outer_radius, -(track_height+1)/2])
				cube([track_outer_radius+1, track_outer_radius, track_height+2]);

			if (b=="hole"){
				translate([-track_center_radius, -tolerance, -(track_height+2)/2])
				rotate([0,0,90])
					hole();
			}
			if (a == "hole"){
				rotate([0,0,45])
				translate([0, track_center_radius, -track_height/2])
				rotate([0,0,180])
					hole();
			}

			if (lightweight){
				
				difference(){
					rotate_extrude($fn=200)
						translate([track_center_radius, 0, 0])
							square(size=[track_cutout_width, track_cutout_height], center=true);

					translate([0, -track_outer_radius, -(track_cutout_height+1)/2])
						cube([track_outer_radius+1, (track_outer_radius+1)*2, track_cutout_height+2]);

					rotate([0,0,b_offset(b)])
					translate([-track_outer_radius, -track_outer_radius, -(track_cutout_height+1)/2])
						cube([track_outer_radius+1, track_outer_radius+1, track_cutout_height+2]);

					rotate([0,0,180+(45-a_offset(a))])
					translate([-track_outer_radius, -track_outer_radius, -(track_cutout_height+1)/2])
						cube([track_outer_radius+1, track_outer_radius+1, track_cutout_height+2]);

				}
			}
		}

		if (a == "peg"){
			rotate([0,0,45.5])
				translate([0, track_center_radius, -track_height/2]) 
					peg();
		}

		if (b == "peg"){			
			translate([-track_center_radius, 0, -track_height/2]) 
			rotate([0,0,-90])
					peg();
		}
	}
}

module long_track(lightweight=lightweight_default) {
	track(track_length_long, lightweight=lightweight);
}

module medium_track(lightweight=lightweight_default) {
	track(track_length_medium, lightweight=lightweight);
}

module short_track(lightweight=lightweight_default) {
	track(track_length_short, lightweight=lightweight);
}

/**
* a/b = connectors, either: peg, hole, or none
*/
module track(length, a="peg", b="hole", lightweight=lightweight_default, ruts=true) {

	function a_offset(peg_or_hole) = peg_or_hole=="hole" ? -peg_dims[l] + 8 : 0;
	function b_offset(peg_or_hole) = peg_or_hole=="hole" ? peg_dims[l] - 8 : 0;
	function lw_offset(peg_or_hole) = peg_or_hole=="hole" ? peg_dims[l] + 6 : 6;

	difference(){
		translate([0,0,track_height/2])
			cube(size=[length, track_width, track_height], center=true);

		if (ruts){
			translate([0,rut_spacing/2+rut_width/2,track_height+1-rut_depth/2])
				cube(size=[length+2, rut_width, rut_depth+2], center=true);

			translate([0,-(rut_spacing/2+rut_width/2),track_height+1-rut_depth/2])
				cube(size=[length+2, rut_width, rut_depth+2], center=true);
		}

		if (b=="hole"){
			translate([-(length/2)-0.1,0,-1])
				hole();
		}
		if (a == "hole"){
			rotate([0,0,180])
			translate([-((length+0.5)/2), 0, -1]) 
				hole();
		}

		if (lightweight){
			translate([0+a_offset(a)+b_offset(b), 0,track_height/2])
				cube([length-(lw_offset(a)+lw_offset(b)), rut_spacing/1.5, track_height+2], center=true);
		}
	}

	if (a=="peg"){
		translate([length/2,0,0])
			peg();
	}
	if (b=="peg"){
		translate([-length/2,0,0])
		rotate([0,0,180])
			peg();
	}
	
}

module hole() {
	scale([1 + tolerance,1 + tolerance,1 + (tolerance*2)])
		peg();
}

module peg() {
	
	pin_connector_dims = [peg_dims[l]-(peg_pin_dia/2), 5, peg_dims[h]];

	translate([pin_connector_dims[l],0,0])
		cylinder(r=peg_pin_dia/2, h=peg_dims[h]);

	translate([0,-(pin_connector_dims[w]/2),0])
		cube(size=pin_connector_dims);
}

module block(lightweight=lightweight_default) {
	top_cutout_dims = [8, block_dims[w], 11];
	bottom_cutout_dims = [42, block_dims[w], 11];

	translate([0,0,block_dims[w]/2])
	rotate([-90,0,0])
	difference(){
		cube(size=block_dims, center=true);
		
		translate([block_dims[l]/2 - top_cutout_dims[l]/2, 0, block_dims[h]/2 - top_cutout_dims[h]/2])
			cube(size=top_cutout_dims, center=true);

		translate([-block_dims[l]/2 + top_cutout_dims[l]/2, 0, block_dims[h]/2 - top_cutout_dims[h]/2])
			cube(size=top_cutout_dims, center=true);

		translate([0, 0, -block_dims[h]/2 + bottom_cutout_dims[h]/2])
			cube(size=bottom_cutout_dims, center=true);	


		if (lightweight){
			translate([0, 0, 5]) 
				cube([block_dims[l]-30,block_dims[w]+2,block_dims[h]-25], center=true);

			translate([0, 0, 0]) 
				cube([block_dims[l]-12, block_dims[w]+2,block_dims[h]-34], center=true);

		}
	}
}