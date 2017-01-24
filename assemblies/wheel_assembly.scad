use <motor_gears.scad>

motorized_wheel();


module motorized_wheel(){
    translate([0,0,127/2])
    rotate([90,0,0])
    wheel();
    
    
    rotate([90,0,0])
    translate([0,127/2+127/4,-15-(2.5+29.3+21.5+3.8+17)])
    rotate([0,0,60])
    KG37B2_motor();
    
    color("blue")
    translate([0,29/2+7.5,127/2])
    rotate([90,180+45+32,0])
    gear_assembly();
}

module wheel(){
    color("grey")
    difference(){
        union(){
            translate([0,0,12.7/2+2])
            cylinder(14, 38.2/2, 34.5/2, $fn=50);
            translate([0,0,-12.7/2-2])
            rotate([0,180,0])
            cylinder(14, 38.2/2, 34.5/2, $fn=50);
            difference(){
                cylinder(d=127-30, h=29.3, center=true, $fn=50);
                translate([0,0,29.3/2])
                cylinder(d=84,h=12.7, center=true, $fn=50);
                translate([0,0,-29.3/2])
                cylinder(d=84,h=12.7, center=true, $fn=50);
            }
        }
        cylinder(d=8, h=45, center=true, $fn=50);
    }
    color("red")
    difference(){
        cylinder(d=127,h=29, center=true, $fn=100);
        cylinder(d=127-30, h=30, center=true, $fn=100);
        
    }
}

module KG37B2_motor(){
    color("silver"){
        cylinder(h=29.3, d=34);
        translate([0,0,2.5+29.3])
        cylinder(h=21.5, d=37);
        translate([0,37/2-5-6/2,2.5+29.3+21.5])
        cylinder(h=3.8, d=12);
        translate([0,37/2-5-6/2,2.5+29.3+21.5+3.8])
        cylinder(h=17, d=6);
    }
}