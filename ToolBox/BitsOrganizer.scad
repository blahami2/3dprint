

// ********************* PARAMETERS *********************
// - note: all sizes are in mm
BIT_RADIUS = 7; // radius of a single bit
BIT_SPACING = 1; // spacing between two bits
BOX_HEIGHT = 15; // height of the organizer
BITS_PER_LINE = 5; // number of bits per single line
LINES_PER_BOX = 5; // number of lines
FONT="Arial";
$fn = 100;
// ********************* HELPER CONSTANTS *********************
// ********************* MAIN *********************
bit_line(3, BIT_RADIUS, BIT_SPACING, BOX_HEIGHT);


// ********************* MODULES *********************
module bit_line(
    bit_count,
    bit_radius,
    bit_spacing,
    box_height
) {
    x_increment = bit_radius + bit_spacing;
    for (x_shift = [0: x_increment : x_increment * (bit_count - 1)]){
        translate([x_shift, 0, 0])
            single_bit_box(bit_radius, bit_spacing, box_height);
    }
    // title
    font_height = box_height / 4;
    translate([0, (bit_radius + 2 * bit_spacing) / 2, 3 * box_height / 8])
        rotate([90,0,-90])
            linear_extrude(1)
                text("PH", size = font_height, font = FONT, halign = "center", valign = "bottom", $fn = 100);
}

module single_bit_box(
    bit_radius,
    bit_spacing,
    box_height
) {
    difference(){
        x = bit_radius + 2 * bit_spacing;
        y = x;
        z = box_height;
        cube([x, y, z]);
        translate([x/2, y/2, -1])
            cylinder(h=box_height + 2,d=bit_radius);

    }
}