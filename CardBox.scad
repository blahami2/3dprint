// ********************* PARAMETERS *********************
// - edit to change size
CARD_SIZE_LONG_EDGE = 165; // single card length ~ 91 
CARD_SIZE_SHORT_EDGE = 91; // single card width ~ 66
CARD_STACK_HEIGHT = 66;
WALL_THICKNESS = 2;
TAB_WIDTH = 10; // tab width
EXTRA_SPACE = 0.25; // space between the walls (of bottom and top piece when clicked together)
TAB_SHIFT = 0; // tab shift, can be negative, 0 is in the middle
TAB_FLAT_HEIGHT = 1; // tab height of the "flat" part
FINGER_SPACE_HEIGHT = 7;
FINGER_SPACE_WIDTH = 20;
SEPARATOR_TOP_SPACE = 5; // space above the separators
TITLE="BANG!";
TITLE_FONT="Times New Roman";
TITLE_ROTATION=0;

// ********************* HELPER CONSTANTS *********************
TAB_THICKNESS = WALL_THICKNESS / 2;
CARD_LONG_EDGE = CARD_SIZE_LONG_EDGE + (WALL_THICKNESS*2);
CARD_SHORT_EDGE = CARD_SIZE_SHORT_EDGE + (WALL_THICKNESS*2);
ALL_EXTRA_SPACE = (EXTRA_SPACE *2);
WALL_WITH_SPACE = WALL_THICKNESS + EXTRA_SPACE;

LID_OUTSIDE_LONG_THICKNESS = CARD_LONG_EDGE + (WALL_THICKNESS*2);
LID_OUTSIDE_SHORT_THICKNESS = CARD_SHORT_EDGE + (WALL_THICKNESS*2);

SPACE_BETWEEN_BOTTOM_AND_LID = LID_OUTSIDE_LONG_THICKNESS + (WALL_THICKNESS*2)+ 2;

HEIGHT = CARD_STACK_HEIGHT + WALL_THICKNESS;
TAB_X = (CARD_LONG_EDGE/2) - (TAB_WIDTH/2) + TAB_SHIFT;

// ********************* MAIN *********************
box_bottom();
create_separators();
translate ([SPACE_BETWEEN_BOTTOM_AND_LID, 0, 0]) 
box_top(TITLE, TITLE_FONT, TITLE_ROTATION);
module create_separators(){
    separator(60,0,60,1000);
    separator(81,0,81,1000);
    separator(102,0,102,1000);
    separator(123,0,123,1000);
    separator(144,0,144,1000);
}

// ********************* MODULES *********************
module box_bottom(){
    tab_wedge_z = HEIGHT - TAB_THICKNESS * 2 - TAB_FLAT_HEIGHT;
    
    // main body
    difference() 
    {
        // - base
        cube ([CARD_LONG_EDGE,CARD_SHORT_EDGE,HEIGHT]);

        // - tab cutout
        translate([TAB_X + TAB_WIDTH, -.5, HEIGHT / 4 + WALL_THICKNESS])
            cube ([2, CARD_SHORT_EDGE + 2, HEIGHT]);
        
        // - tab cutout
        translate([TAB_X - 2, -.5, HEIGHT / 4  + WALL_THICKNESS]) 
            cube ([2, CARD_SHORT_EDGE + 2, HEIGHT ]);

        // - hole
        translate([WALL_THICKNESS,WALL_THICKNESS,WALL_THICKNESS]) cube ([CARD_LONG_EDGE - (WALL_THICKNESS*2),CARD_SHORT_EDGE - (WALL_THICKNESS*2),HEIGHT]);
    }
    
    // bottom plate
    translate ([-WALL_THICKNESS-EXTRA_SPACE, -WALL_THICKNESS-EXTRA_SPACE, 0 ])
        cube ([CARD_LONG_EDGE + WALL_WITH_SPACE*2, CARD_SHORT_EDGE + WALL_WITH_SPACE*2, WALL_THICKNESS]);
    
    translate ([TAB_X, -TAB_THICKNESS, tab_wedge_z])
        tab_wedge(TAB_WIDTH, TAB_THICKNESS);
        
    translate ([TAB_X + TAB_WIDTH, CARD_SHORT_EDGE + TAB_THICKNESS,tab_wedge_z])
        rotate([0,0,180])
            tab_wedge(TAB_WIDTH, TAB_THICKNESS);


}

module tab_wedge(tab_width, tab_thickness){
    // - bottom
    difference (){
        cube([tab_width, tab_thickness, tab_thickness]);
        translate([-3, tab_thickness,0])
            rotate ([135,0,0])
                cube([(tab_width*2), tab_thickness * sqrt(2), tab_thickness * sqrt(2)]);
    }
    // - middle
    translate ([0, 0, tab_thickness])
        cube ([tab_width, tab_thickness, TAB_FLAT_HEIGHT]); 
    // - top
    translate([tab_width,0,tab_thickness*2+TAB_FLAT_HEIGHT])
    rotate([0,180,0])
    difference (){
        cube([tab_width, tab_thickness, tab_thickness]);
        translate([-3, tab_thickness,0])
            rotate ([135,0,0])
                cube([(tab_width*2), tab_thickness * sqrt(2), tab_thickness * sqrt(2)]);
    }
}

module box_top(title, title_font, title_rotation=0){
    // main body
    difference() 
    {
        // - base
        cube ([LID_OUTSIDE_LONG_THICKNESS+ALL_EXTRA_SPACE, LID_OUTSIDE_SHORT_THICKNESS+ALL_EXTRA_SPACE, HEIGHT]);
        
        // - tab cutout
        tab_hole_width = TAB_WIDTH + 1; // + 1 space
        translate([WALL_WITH_SPACE + TAB_X - 0.5, WALL_THICKNESS/2, WALL_THICKNESS])
            cube ([(TAB_WIDTH+1), LID_OUTSIDE_SHORT_THICKNESS-WALL_THICKNESS, 2* TAB_THICKNESS + TAB_FLAT_HEIGHT + 0.3]);
        
        // - hole
        translate([WALL_THICKNESS,WALL_THICKNESS, WALL_THICKNESS])
            cube ([LID_OUTSIDE_LONG_THICKNESS - (WALL_THICKNESS*2)+ALL_EXTRA_SPACE,LID_OUTSIDE_SHORT_THICKNESS - (WALL_THICKNESS*2)+ALL_EXTRA_SPACE, HEIGHT]);
        
        // - finger space
        translate([-1,(LID_OUTSIDE_SHORT_THICKNESS-FINGER_SPACE_WIDTH)/2,HEIGHT-FINGER_SPACE_HEIGHT])
            cube ([LID_OUTSIDE_LONG_THICKNESS+2, FINGER_SPACE_WIDTH, FINGER_SPACE_HEIGHT+2]);
    }
    
    // title
    font_height = CARD_STACK_HEIGHT/2;
    translate([LID_OUTSIDE_LONG_THICKNESS/2 + EXTRA_SPACE, 0, WALL_THICKNESS + (CARD_STACK_HEIGHT+font_height)/2])
        rotate([90,180+title_rotation,0])
            linear_extrude(1)
                text(title, size = font_height, font = title_font, halign = "center", valign = "bottom", $fn = 100);
}

/**
* start_x = start X relative to inside of box bottom
* start_y = start Y relative to inside of box bottom
* end_x = end X relative to inside of box bottom
* end_y = end Y relative to inside of box bottom
*/
module separator(start_x, start_y, end_x, end_y){
    // - validate input
    start_x = start_x < 0 ? 0 : start_x;
    end_x = end_x > CARD_SIZE_LONG_EDGE ? CARD_SIZE_LONG_EDGE : end_x;
    start_y = start_y < 0 ? 0 : start_y;
    end_y = end_y > CARD_SIZE_SHORT_EDGE ? CARD_SIZE_SHORT_EDGE : end_y;
    // - print
    basic_shift = WALL_THICKNESS * 2 + EXTRA_SPACE;
    if (start_x == end_x){
        translate([WALL_THICKNESS + start_x, WALL_THICKNESS + start_y, WALL_THICKNESS])
            cube([WALL_THICKNESS/2, end_y - start_y, CARD_STACK_HEIGHT-SEPARATOR_TOP_SPACE]);
    } else if (start_y == end_y){
        translate([WALL_THICKNESS + start_x, WALL_THICKNESS + start_y, WALL_THICKNESS])
            cube([end_x - start_x, WALL_THICKNESS/2, CARD_STACK_HEIGHT-SEPARATOR_TOP_SPACE]);
    } else {
        echo ("INVALID SEPARATOR: X or Y must match!");
    }
}