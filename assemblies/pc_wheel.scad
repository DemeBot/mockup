//cylinder(h=10.25, d=24, $fn=50, center=true);

wheel_width = 10.25;
wheel_diameter = 25;
wheel_bevel_leftover_width = 6;
bevel_size = (wheel_width-wheel_bevel_leftover_width)/2;
bearing_diameter=16;
bearing_hole_diameter=5;
bearing_width=5;

smoothness=50;

PC_WHEEL();

module PC_WHEEL(){
    rotate([0,90,0]){
    PC_WHEEL_RIM();

    translate([0,0,bearing_width/2+.5])
    PC_WHEEL_BEARING(bearing_diameter, bearing_width, bearing_hole_diameter, smoothness);

    translate([0,0,-bearing_width/2-.5])
    PC_WHEEL_BEARING(bearing_diameter, bearing_width, bearing_hole_diameter, smoothness);
    }
}

module PC_WHEEL_RIM(){
    %color("LightGrey",0.75)
    rotate_extrude(convexity = 10, $fn = smoothness)
    rotate([0,0,-90])
    polygon(
        [
            [wheel_width/2, bearing_diameter/2],
            [wheel_width/2, wheel_diameter/2-bevel_size],
            [wheel_width/2-bevel_size, wheel_diameter/2],
            [-wheel_width/2+bevel_size, wheel_diameter/2],
            [-wheel_width/2, wheel_diameter/2-bevel_size],
            [-wheel_width/2, bearing_diameter/2]
        ]
    );  
}
module PC_WHEEL_BEARING(bearing_diameter, bearing_width, bearing_hole_diameter, smoothness){
    color("grey")
    difference(){
        cylinder(d=bearing_diameter, h=bearing_width, $fn=smoothness/2, center=true);
        cylinder(d=bearing_hole_diameter, h=bearing_width+1, $fn=smoothness/4, center=true);
    }
}