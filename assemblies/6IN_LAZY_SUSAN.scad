6IN_LAZY_SUSAN();

6IN_LAZY_SUSAN_HEIGHT = 6.35;
6IN_LAZY_SUSAN_WIDTH = 152.4;

module 6IN_LAZY_SUSAN(rotation = 0){
    color("silver")
    translate([0,0,-6IN_LAZY_SUSAN_HEIGHT/2]){
    rotate_extrude(convexity = 10, $fn = 100)
    translate([117.475/2+6IN_LAZY_SUSAN_HEIGHT/2, 6IN_LAZY_SUSAN_HEIGHT/2, 0])
    circle(d = 6IN_LAZY_SUSAN_HEIGHT, $fn = 100);
    
    translate([0,0,0.8/2])
    6_IN_LAZY_SUSAN_PLATE();
    translate([0,0,6IN_LAZY_SUSAN_HEIGHT-0.8/2])
    rotate([0,0,rotation])
    6_IN_LAZY_SUSAN_PLATE();
    }
}

module 6_IN_LAZY_SUSAN_PLATE(){
    difference(){
        cube([6IN_LAZY_SUSAN_WIDTH,6IN_LAZY_SUSAN_WIDTH,0.8], center=true);
        cylinder(d=117.475+6IN_LAZY_SUSAN_HEIGHT/2+1, h=1, $fn=100, center=true);
    }
}