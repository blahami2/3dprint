function smallRadius(radius) = radius * sqrt(3)/2;

module hex(diameter, height) {
  linear_extrude(height=height) {
    circle(d=diameter, $fn=6);
  }
}

module connector(
    height,
    connector_neck_width,  // width of the "neck" part of the connector
    connector_neck_length, // length of the "neck" part of the connector
    connector_head_width,  // width of the "head" part of the connector -> this will "click" inside
    connector_head_length, // length of the "head" part of the connector -> this will "click" inside
) {
    cube([connector_neck_length+connector_head_length, connector_neck_width, height]);
    single_connector_side_width = (connector_head_width - connector_neck_width) / 2;
    translate([connector_neck_length, -single_connector_side_width, 0])
        cube([connector_head_length, connector_head_width, height]);
}

module connectorMale(
    height,
    connector_neck_width,  // width of the "neck" part of the connector
    connector_neck_length, // length of the "neck" part of the connector
    connector_head_width,  // width of the "head" part of the connector -> this will "click" inside
    connector_head_length, // length of the "head" part of the connector -> this will "click" inside
) {
    connector(height, connector_neck_width, connector_neck_length, connector_head_width, connector_head_length);
}

module connectorFemale(
    height,
    connector_neck_width,  // width of the "neck" part of the connector
    connector_neck_length, // length of the "neck" part of the connector
    connector_head_width,  // width of the "head" part of the connector -> this will "click" inside
    connector_head_length, // length of the "head" part of the connector -> this will "click" inside
) {
    translate([0, connector_neck_width, 0])
        rotate([0,0,180])
            connector(height, connector_neck_width, connector_neck_length, connector_head_width, connector_head_length);
}

module hexTile(height, longest_width, inner_ring_width, outer_ring_width, ring_dig_height) {
    // longest width + borders
    full_width = longest_width + 2 * outer_ring_width;
    difference() {
        hex(full_width, height);
        // remove inner hex
        translate([0,0,-0.5])
            hex(longest_width - 2 * inner_ring_width, height*2);
        // "dig" into the remaining hex 
        translate([0,0,height - ring_dig_height])
            hex(longest_width, height+1);  
    }
}

module tileStand(
    height,            // height of the whole stand
    longest_width,     // width at the widest part
    inner_ring_width,  // width of the bottom ring
    outer_ring_width,  // width of the upper (smaller, outer) ring
    outer_ring_height, // height of the upper (smaller, outer) ring
    connector_neck_width,  // width of the "neck" part of the connector
    connector_neck_length, // length of the "neck" part of the connector
    connector_head_width,  // width of the "head" part of the connector -> this will "click" inside
    connector_head_length, // length of the "head" part of the connector -> this will "click" inside
    connector_space,       // space between male and female connector
) {
    rad = smallRadius((long_width+2*outer_ring_width)/2);
    connector_height = height - outer_ring_height;
    
    // used to join two neighboring parts (to create overlap)
    overlap = 1;
    // male connectors
    connector_width_shift = -(connector_neck_width/2);
    // top right
    rotate([0,0,30])
        translate([rad-overlap,connector_width_shift,0])
            connectorMale(
                connector_height,
                connector_neck_width, 
                connector_neck_length+overlap, 
                connector_head_width, 
                connector_head_length
            );
    // top left
    rotate([0,0,150])
        translate([rad-overlap,connector_width_shift,0])
            connectorMale(
                connector_height,
                connector_neck_width, 
                connector_neck_length+overlap, 
                connector_head_width, 
                connector_head_length
            );
    // bottom
    rotate([0,0,-90])
        translate([rad-overlap,connector_width_shift,0])
            connectorMale(
                connector_height,
                connector_neck_width, 
                connector_neck_length+overlap, 
                connector_head_width, 
                connector_head_length
            );
    
    // female connectors
    
    // - larger for overlap
    fem_height = connector_height + height * 2 + overlap;
    fem_length_shift = rad + overlap; 
    // - add connector space to make the connector "bigger" in all dimensions
    fem_neck_length = connector_neck_length + overlap - connector_space;
    fem_neck_width = connector_neck_width + connector_space * 2;
    fem_width_shift = -(fem_neck_width/2);
    fem_head_length = connector_head_length + connector_space * 2;
    fem_head_width = connector_head_width + connector_space * 2;
    
    difference() {
        hexTile(height, longest_width, inner_ring_width, outer_ring_width, outer_ring_height);
        // bottom right
        rotate([0,0,-30])
            translate([fem_length_shift,fem_width_shift,-overlap])
                connectorFemale(
                    fem_height,
                    fem_neck_width, 
                    fem_neck_length, 
                    fem_head_width, 
                    fem_head_length
                );
        // bottom left
        rotate([0,0,-150])
            translate([fem_length_shift,fem_width_shift,-overlap])
                connectorFemale(
                    fem_height,
                    fem_neck_width, 
                    fem_neck_length, 
                    fem_head_width, 
                    fem_head_length
                );
        // top
        rotate([0,0,90])
            translate([fem_length_shift,fem_width_shift,-overlap])
                connectorFemale(
                    fem_height,
                    fem_neck_width, 
                    fem_neck_length, 
                    fem_head_width, 
                    fem_head_length
                );
    }
}

module holder(length, width) {
    translate([0,-width/2,0])
      cube([length,7,1.5]);
}

long_width = 117.2;

tileStand(3, long_width, 12, 1, 1.5, 10, 3, 16, 3, 0.2);

// real tile:
// hexTile(116, 1.5);



