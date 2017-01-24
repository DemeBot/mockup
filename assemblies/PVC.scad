module 3_IN_PVC(height = 100){
    color("white")
    difference(){
        cylinder(d=88.9, h=height, $fn=50);
        translate([0,0,-2.5])
        cylinder(d=76.2, h=height+5, $fn=50);
    }
}

3_IN_PVC(500);