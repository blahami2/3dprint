

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

bit_box(11, 7, BIT_RADIUS, BIT_SPACING, BOX_HEIGHT, ["-", "PH", "PZ", "H", "S", "T", "/"]);

// ********************* MODULES *********************
module bit_box(
    bits_per_row,
    bits_per_col,
    bit_radius,
    bit_spacing,
    box_height,
    titles = []
) {
    y_shift = bit_radius + 2 * bit_spacing;
    y_base = (bits_per_col - 1) * y_shift;
    for (i = [0:bits_per_col-1]) {
        translate([0,y_base + -i * y_shift,0])
            bit_line(bits_per_row, bit_radius, bit_spacing, box_height, titles[i]);
    }
    // enumerate
    x_shift = bit_radius + bit_spacing;
    font_height = box_height / 4;
    for (i = [0:bits_per_row - 1]) {
        translate([x_shift / 2 + x_shift * i, 0, 3 * box_height / 8])
            rotate([90,0,0])
                linear_extrude(1)
                    text(str(i+1), size = font_height, font = FONT, halign = "center", valign = "bottom", $fn = 100);
    }
    for (i = [0:bits_per_row - 1]) {
        translate([x_shift / 2 + x_shift * i, y_base + y_shift, 3 * box_height / 8])
            rotate([90,0,180])
                linear_extrude(1)
                    text(str(floor(1+i/2)), size = font_height, font = FONT, halign = "center", valign = "bottom", $fn = 100);
    }
}

module bit_line(
    bit_count,
    bit_radius,
    bit_spacing,
    box_height,
    title=undef
) {
    x_increment = bit_radius + bit_spacing;
    for (x_shift = [0: x_increment : x_increment * (bit_count - 1)]){
        translate([x_shift, 0, 0])
            single_bit_box(bit_radius, bit_spacing, box_height);
    }
    // title
    if (title) {
        font_height = box_height / 4;
        translate([0, (bit_radius + 2 * bit_spacing) / 2, 3 * box_height / 8])
            rotate([90,0,-90])
                linear_extrude(1)
                    text(title, size = font_height, font = FONT, halign = "center", valign = "bottom", $fn = 100);
    }
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