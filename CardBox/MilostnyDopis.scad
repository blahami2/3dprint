use <CardBox.scad>;
// - edit to change size
CARD_SIZE_LONG_EDGE = 91; // single card length ~ 91 
CARD_SIZE_SHORT_EDGE = 66; // single card width ~ 66
CARD_STACK_HEIGHT = 15;
WALL_THICKNESS = 2;
TAB_WIDTH = 10; // tab width
EXTRA_SPACE = 0.25; // space between the walls (of bottom and top piece when clicked together)
TAB_SHIFT = 0; // tab shift, can be negative, 0 is in the middle
TAB_FLAT_HEIGHT = 1; // tab height of the "flat" part
FINGER_SPACE_HEIGHT = 7;
FINGER_SPACE_WIDTH = 20;
SEPARATOR_TOP_SPACE = 5; // space above the separators
TITLE="Milostný dopis";
TITLE_FONT="Franklin Gothic Book:style=Regular";
TITLE_ROTATION=0;
$fn=100;

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
    separators=[],
    display="both"
);