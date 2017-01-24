use <v-slot.scad>
use <nema17.scad>

// 

z_axis_assembly(250);

module z_axis_assembly(z_main=500){
    
    rotate([0,0,90])
    translate([-45,0,0]){
        stepper_height=34;

        color("silver")
        v_slot(z_main+stepper_height+10);
        
        color("black")
        translate([10+42.3/2,0,z_main+10])
        rotate([0,180,0])
        nema17(stepper_height);
        
        color("silver")
        translate([10+42.3/2,0,75])
        cylinder(d=6.35, h=z_main-75, $fn=25);
        
        color("blue")
        translate([81,-35,-2.5])
        rotate([90,0,180])
        import("UTM Base.stl");

        color("blue")
        translate([81,-35,20])
        rotate([90,0,180])
        import("UTM Cover.stl");
    }
}