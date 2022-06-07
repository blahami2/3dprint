// SOURCE: https://www.thingiverse.com/thing:92518
// ********************* PARAMETERS *********************
// - edit to change size
CARD_SIZE_LONG_EDGE = 165; // single card length ~ 91 
CARD_SIZE_SHORT_EDGE = 91; // single card width ~ 66
CARD_STACK_HEIGHT = 66;
WALL_THICKNESS = 2;
TAB_WIDTH = 10; // tab width
EXTRA_SPACE = 0.25; // space between the walls (of bottom and top piece when clicked together)
TAB_SHIFT = 9; // tab shift, can be negative, 0 is in the middle
TAB_FLAT_HEIGHT = 1; // tab height of the "flat" part
FINGER_SPACE_HEIGHT = 7;
FINGER_SPACE_WIDTH = 20;
SEPARATOR_TOP_SPACE = 5; // space above the separators
TITLE="BANG!";
TITLE_FONT="Times New Roman";
TITLE_ROTATION=4;

// ********************* HELPER CONSTANTS *********************
function tab_thickness (wall_thickness) = wall_thickness / 2;
function tab_x_shift (long_inside_space, tab_width, tab_shift) = (long_inside_space - tab_width) / 2 + tab_shift;
// ********************* MAIN *********************
// - display options: { "both", "top", "bottom" }
card_box(
    [CARD_SIZE_LONG_EDGE, CARD_SIZE_SHORT_EDGE, CARD_STACK_HEIGHT],
    WALL_THICKNESS,
    TAB_WIDTH,
    TAB_FLAT_HEIGHT,
    TAB_SHIFT,
    EXTRA_SPACE,
    FINGER_SPACE_WIDTH,
    FINGER_SPACE_HEIGHT,
    TITLE,
    TITLE_FONT,
    TITLE_ROTATION,
    SEPARATOR_TOP_SPACE,
    separators=[
        [60,0,60,1000],
        [81,0,81,1000],
        [102,0,102,1000],
        [123,0,123,1000],
        [144,0,144,1000]
    ],
    display="both"
);

// ********************* MODULES *********************
module card_box(
    size, 
    wall_thickness, 
    tab_width, 
    tab_flat_height, 
    tab_shift,
    extra_space,
    finger_space_width,
    finger_space_height,
    title, 
    title_font,
    title_rotation=0,
    separator_top_space=0,
    separators=[],
    display="both"
) {
    TOP_DISTANCE_X = size[0] + 2*extra_space + 6*wall_thickness;
    if (display=="bottom"){
        box_bottom(size, wall_thickness, tab_width, tab_flat_height, tab_shift, extra_space);
        create_separators(size, wall_thickness, extra_space, separator_top_space, separators);
    } else if (display=="top"){
        box_top(size, wall_thickness, tab_width, tab_flat_height, tab_shift, extra_space, finger_space_width, finger_space_height, title, title_font, title_rotation);
    } else if(display=="both"){
        box_bottom(size, wall_thickness, tab_width, tab_flat_height, tab_shift, extra_space);
        create_separators(size, wall_thickness, extra_space, separator_top_space, separators);
        translate ([TOP_DISTANCE_X, 0, 0]) 
            box_top(size, wall_thickness, tab_width, tab_flat_height, tab_shift, extra_space, finger_space_width, finger_space_height, title, title_font, title_rotation);
    }
}

module create_separators(size, wall_thickness, extra_space, separator_top_space, separators=[]){
    for(s = separators){
        separator(size, wall_thickness, extra_space, separator_top_space, s[0],s[1],s[2],s[3]);
    }
}

module box_bottom(
    size, 
    wall_thickness, 
    tab_width, 
    tab_flat_height, 
    tab_shift,
    extra_space
){
    x = size[0];
    y = size[1];
    z = size[2];
    x_outer = x + wall_thickness * 2;
    y_outer = y + wall_thickness * 2;
    z_outer = z + wall_thickness;
    
    tab_thickness = tab_thickness(wall_thickness);
    tab_wedge_z = z_outer - tab_thickness * 2 - tab_flat_height;
    tab_x = tab_x_shift(x_outer, tab_width, tab_shift);
    wall_with_space = wall_thickness + extra_space;
    
    // main body
    difference() 
    {
        // - base
        cube ([x_outer, y_outer, z_outer]);

        // - tab cutout
        translate([tab_x + tab_width, -.5, z / 4 + wall_thickness])
            cube ([2, y_outer + 2, z_outer]);
        
        // - tab cutout
        translate([tab_x - 2, -.5, z / 4  + wall_thickness]) 
            cube ([2, y_outer + 2, z_outer ]);

        // - hole
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube ([x, y, z+1]);
        
    }
    
    // bottom plate
    translate ([-wall_with_space, -wall_with_space, 0 ])
        rounded_cube ([x_outer + wall_with_space * 2, y_outer + wall_with_space * 2, wall_thickness], wall_thickness);
    
    // tab wedges
    translate ([tab_x, -tab_thickness, tab_wedge_z])
        tab_wedge(tab_width, tab_thickness, tab_flat_height);
        
    translate ([tab_x + tab_width, y_outer + tab_thickness, tab_wedge_z])
        rotate([0,0,180])
            tab_wedge(tab_width, tab_thickness, tab_flat_height);


}

module tab_wedge(tab_width, tab_thickness, tab_flat_height){
    // - bottom
    difference (){
        cube([tab_width, tab_thickness, tab_thickness]);
        translate([-3, tab_thickness,0])
            rotate ([135,0,0])
                cube([(tab_width*2), tab_thickness * sqrt(2), tab_thickness * sqrt(2)]);
    }
    // - middle
    translate ([0, 0, tab_thickness])
        cube ([tab_width, tab_thickness, tab_flat_height]); 
    // - top
    translate([tab_width,0,tab_thickness*2+tab_flat_height])
    rotate([0,180,0])
    difference (){
        cube([tab_width, tab_thickness, tab_thickness]);
        translate([-3, tab_thickness,0])
            rotate ([135,0,0])
                cube([(tab_width*2), tab_thickness * sqrt(2), tab_thickness * sqrt(2)]);
    }
}

module box_top(
    size,
    wall_thickness,, 
    tab_width, 
    tab_flat_height, 
    tab_shift,
    extra_space,
    finger_space_width,
    finger_space_height,
    title, 
    title_font,
    title_rotation=0
){
    x = size[0];
    y = size[1];
    z = size[2];
    x_outer = x + 2 * (2 * wall_thickness + extra_space);
    y_outer = y + 2 * (2 * wall_thickness + extra_space);
    z_outer = z + wall_thickness;
    tab_thickness = tab_thickness(wall_thickness);
    tab_wedge_z = z - tab_thickness * 2 - tab_flat_height;
    tab_x = tab_x_shift(x, tab_width, tab_shift);
    wall_with_space = wall_thickness + extra_space;
    
    // main body
    difference() 
    {
        // - base
        rounded_cube([x_outer, y_outer, z_outer], wall_thickness);
        // - tab cutout
        tab_hole_width = tab_width + 1; // + 1 space
        translate([wall_with_space + tab_x - 0.5, wall_thickness / 2, wall_thickness])
            cube ([tab_width + 1, y_outer - wall_thickness, 2 * tab_thickness + tab_flat_height + 0.3]);
        
        // - hole
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube ([x_outer - 2 * wall_thickness, y_outer - 2 * wall_thickness, z_outer]);
        
        // - finger space
        translate([-1,(y_outer-finger_space_width) / 2, z_outer - finger_space_height])
            cube ([x_outer + 2, finger_space_width, finger_space_height + 2]);
    }
    
    // title
    font_height = z_outer / 2;
    translate([x_outer/2, 0, wall_thickness + (z_outer+font_height)/2])
        rotate([90,180+title_rotation,0])
            linear_extrude(1)
                text(title, size = font_height, font = title_font, halign = "center", valign = "bottom", $fn = 100);
}

module rounded_cube(size, radius){
    
    x = size[0];
    y = size[1];
    z = size[2];
    d = radius * 2;
    r = radius;
    
    difference(){
        union(){
            difference(){
                // + body
                cube ([x, y, z]);        
                // - corners sides
                translate([-1,-1,-1])
                cube([r+1, r+1, z+2]);
                translate([x-r, y-r, -1])
                cube([r+1, r+1, z+2]);
                translate([x-r, -1, -1])
                cube([r+1, r+1, z+2]);
                translate([-1, y-r, -1])
                cube([r+1, r+1, z+2]);
                
                // - corners bottom
                translate([-1,-1,-1])
                cube([x+2, r+1, r+1]);
                translate([-1,y-r,-1])
                cube([x+2, r+1, r+1]);
                translate([-1,-1,-1])
                cube([r+1, y+2, r+1]);
                translate([x-r,-1,-1])
                cube([r+1, y+2, r+1]);
            }
            // + round corners sides
            translate([r, r, r])
            cylinder(h=z-r, d=d);
            translate([x-r, r, r])
            cylinder(h=z-r, d=d);
            translate([x-r, y-r, r])
            cylinder(h=z-r, d=d);
            translate([r, y-r, r])
            cylinder(h=z-r, d=d);
            // + round corners bottom
            translate([r, r, r])
            rotate([0,90,0])
            cylinder(h=x-r*2,d=d);
            translate([r, y-r, r])
            rotate([0,90,0])
            cylinder(h=x-r*2,d=r*2);
            translate([r, r, r])
            rotate([-90,0,0])
            cylinder(h=y-r*2,d=d);
            translate([x-r, r, r])
            rotate([-90,0,0])
            cylinder(h=y-r*2,d=d);
            // + vertices
            translate([r, r, r])
            sphere(r=r);
            translate([r, y-r, r])
            sphere(r=r);
            translate([x-r, r, r])
            sphere(r=r);
            translate([x-r, y-r, r])
            sphere(r=r);
        }
        // - top
        translate([0,0,z])
        cube([x, y, r]);
    }
}

/**
* start_x = start X relative to inside of box bottom
* start_y = start Y relative to inside of box bottom
* end_x = end X relative to inside of box bottom
* end_y = end Y relative to inside of box bottom
*/
module separator(size, wall_thickness, extra_space, top_space, start_x, start_y, end_x, end_y){
    x = size[0];
    y = size[1];
    z = size[2];
    // - validate input
    start_x = start_x < 0 ? 0 : start_x;
    end_x = end_x > x ? x : end_x;
    start_y = start_y < 0 ? 0 : start_y;
    end_y = end_y > y ? y : end_y;
    // - print
    basic_shift = wall_thickness * 2 + extra_space;
    if (start_x == end_x){
        translate([wall_thickness + start_x, wall_thickness + start_y, wall_thickness])
            cube([wall_thickness/2, end_y - start_y, z-top_space]);
    } else if (start_y == end_y){
        translate([wall_thickness + start_x, wall_thickness + start_y, wall_thickness])
            cube([end_x - start_x, wall_thickness/2, z-top_space]);
    } else {
        echo ("INVALID SEPARATOR: X or Y must match!");
    }
}