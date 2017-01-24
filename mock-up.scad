use <assemblies/TSlot.scad>;
use <assemblies/PVC.scad>;
use <assemblies/6IN_LAZY_SUSAN.scad>;
use <assemblies/z-axis_assembly.scad>;
use <assemblies/wheel_assembly.scad>;
use <assemblies/1010Holder.scad>;
use <assemblies/gantry.scad>;

if(false){
    translate([-500,-500,0])
    scale([60,60,60])
    import("Human_Waving.stl");
}

// 360

// Model dimentions (All dimentions in metric)

    // Arm
    arm_length = 1150-152.4-500;
    arm_ground_clearance = 300;
    arm_inner_clearance = 150;
    arm_outer_clearance = 150;
    arm_tool_tray_extension=150;
    
    arm_angle = $t*360;
    
    wheel_clearance=42.5;
    wheel_base = 525;
    
    // Gantry 
    gantry_height = 25+$t*150;
    gantry_offset = arm_inner_clearance+0.5*(arm_length-arm_inner_clearance);
    
    // Center Pivot
    pipe_underground_depth = 0;
    
    // Soil & Container
    soil_depth = 100;
    
    // Global Variable set up
    v_slot_thickness = 25.4;
    6IN_LAZY_SUSAN_HEIGHT = 6.35;
    6IN_LAZY_SUSAN_WIDTH = 142+v_slot_thickness;

/* -- Main Model Begins Here! -- */
// DO NOT EDIT BELOW THIS LINE

complete_model();

module complete_model(){
    container();
    coverage_highlight();
    center_pivot(arm_angle);
    
    rotate([0,0,arm_angle]){
        arm();
        tool_gantry();
    }
    
    rotate([0,0,arm_angle])
    translate([0,gantry_offset+v_slot_thickness/2+5,75+gantry_height])
    z_axis_assembly(300);
    
    rotate([0,0,arm_angle])
    motor_assembly();
}


// Circle smoothness 

// Soil & Container
module container(){
    base_width = 2 * arm_length;
    base_depth = soil_depth;
    
    // Soil
    color("sienna")
    translate([-base_width/2, -base_width/2, -base_depth])
        cube([base_width, base_width, soil_depth]);
}

module coverage_highlight(){
    // Arm coverage area
    color("red")
    cylinder(r=arm_length, h=.75, $fn=100, center=true);
    
    color("green")
    difference(){
        cylinder(r=arm_length-arm_outer_clearance, h=2, center=true, $fn=100);
        cylinder(r=arm_inner_clearance, h=1.5, center=true);
    }
}

// Main arm
module arm(){
    color("Gainsboro")
    translate([6IN_LAZY_SUSAN_WIDTH/2-v_slot_thickness/2,(arm_tool_tray_extension+arm_length-6IN_LAZY_SUSAN_WIDTH/2)/2,arm_ground_clearance + v_slot_thickness/2 + 6IN_LAZY_SUSAN_HEIGHT/2])
    rotate([-90,0,0])
    1010Profile(arm_tool_tray_extension+arm_length+6IN_LAZY_SUSAN_WIDTH/2);
    
    color("Gainsboro")
    translate([-6IN_LAZY_SUSAN_WIDTH/2+v_slot_thickness/2,(arm_tool_tray_extension+arm_length-6IN_LAZY_SUSAN_WIDTH/2)/2,arm_ground_clearance + v_slot_thickness/2 + 6IN_LAZY_SUSAN_HEIGHT/2])
    rotate([-90,0,0])
    1010Profile(arm_tool_tray_extension+arm_length+6IN_LAZY_SUSAN_WIDTH/2);
    
    color("Gainsboro")
    translate([0,arm_tool_tray_extension+arm_length + v_slot_thickness/2,arm_ground_clearance + v_slot_thickness/2 + 6IN_LAZY_SUSAN_HEIGHT/2])
    rotate([0,90,0])
    1010Profile(6IN_LAZY_SUSAN_WIDTH);
    
    color("Gainsboro")
    translate([0,-6IN_LAZY_SUSAN_WIDTH/2-v_slot_thickness/2,arm_ground_clearance + v_slot_thickness/2 + 6IN_LAZY_SUSAN_HEIGHT/2])
    rotate([0,90,0])
    1010Profile(6IN_LAZY_SUSAN_WIDTH);
}

// Tool Platform Gantry
module tool_gantry(){
    translate([0,gantry_offset,arm_ground_clearance + v_slot_thickness/2 + v_slot_thickness + 6IN_LAZY_SUSAN_HEIGHT/2])
        rotate([0,0,-90])
    GANTRY_ASSEMBLY();
    /*
    gantry_width = 6IN_LAZY_SUSAN_WIDTH + 10;
    
    gantry_gap = 75;

    color("Gainsboro"){
        translate([0,gantry_offset,arm_ground_clearance + v_slot_thickness/2 + v_slot_thickness + 6IN_LAZY_SUSAN_HEIGHT/2])
        rotate([0,-90,0])
        1010Profile(gantry_width);
        
        
        translate([0,gantry_offset+gantry_gap,arm_ground_clearance + v_slot_thickness/2 + v_slot_thickness + 6IN_LAZY_SUSAN_HEIGHT/2])
        rotate([0,-90,0])
        1010Profile(gantry_width);
    }
    */
}


// Pivot mechanism
module center_pivot(arm_angle){
    pipe_length = arm_ground_clearance + pipe_underground_depth;
    
    color("Ivory")
    translate([0,0,-pipe_underground_depth])
    3_IN_PVC(pipe_length);
    
    translate([0,0,arm_ground_clearance])
    6IN_LAZY_SUSAN(arm_angle);
    
    
    // Imported because the scad model is slow to render due to fillet use
    color("blue")
    translate([0,0,arm_ground_clearance-6IN_LAZY_SUSAN_HEIGHT/2])
    rotate([0,180,0])
    import("stl/pivot.low-res.stl");
}

// Full motor assembly unit. Includes motorized wheel assembly, wheel assembly mounts, and aluminum frame.
module motor_assembly(){
    
    rotate([0,0,((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14])
    translate([0,arm_length-arm_outer_clearance/2+10,0])
    motorized_wheel();
    
    rotate([0,0,-((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14])
    translate([0,arm_length-arm_outer_clearance/2+10,0])
    motorized_wheel();
    
    translate([0,arm_length-arm_outer_clearance/2-v_slot_thickness,0])
    end_frame(wheel_well_width=6IN_LAZY_SUSAN_WIDTH-v_slot_thickness*2);
}

module end_frame(wheel_well_width=6IN_LAZY_SUSAN_WIDTH){
    
    translate([0,-wheel_well_width/2,0])
    end_frame_layer();
    
    translate([0,wheel_well_width/2,0])
    end_frame_layer();
    
    for(i=[1,-1]){
    
        translate([0,0,wheel_clearance+20])
        rotate([0,90+90*i,0])
        translate([((6IN_LAZY_SUSAN_WIDTH-v_slot_thickness)/2+sin(((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14)*(arm_length)/2)-15,-wheel_well_width/2+v_slot_thickness/2,0])
        rotate([0,90,0])
        1010RodHolder(height=50, rod_holder_angle=((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14, rod_diameter=10);
        
        color("blue")
        translate([0,0,wheel_clearance+20])
        rotate([0,90+90*i,0])
        translate([((6IN_LAZY_SUSAN_WIDTH-v_slot_thickness)/2+sin(((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14)*(arm_length)/2)+6.5,+wheel_well_width/2+v_slot_thickness/2,0])
        rotate([180,180+90*i,0])
        1010MotorizedRodHolder(height=50, rod_holder_angle=-i*((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14, rod_diameter=10);
        
    }
    
    translate([(6IN_LAZY_SUSAN_WIDTH+300+v_slot_thickness)/2,v_slot_thickness/2,127/2])
    rotate([90,0,0])
    1010Profile(wheel_well_width+v_slot_thickness);
    
    translate([-(6IN_LAZY_SUSAN_WIDTH+300+v_slot_thickness)/2,v_slot_thickness/2,127/2])
    rotate([90,0,0])
    1010Profile(wheel_well_width+v_slot_thickness);
    
    translate([6IN_LAZY_SUSAN_WIDTH/2-v_slot_thickness/2-v_slot_thickness,v_slot_thickness+arm_tool_tray_extension/2,127/2+v_slot_thickness])
    rotate([90,0,0])
    1010Profile(6IN_LAZY_SUSAN_WIDTH+arm_tool_tray_extension);
    
    translate([-(6IN_LAZY_SUSAN_WIDTH/2-v_slot_thickness/2-v_slot_thickness),v_slot_thickness+arm_tool_tray_extension/2,127/2+v_slot_thickness])
    rotate([90,0,0])
    1010Profile(6IN_LAZY_SUSAN_WIDTH+arm_tool_tray_extension);
}

module end_frame_layer(){
    
    translate([6IN_LAZY_SUSAN_WIDTH/2-v_slot_thickness/2,v_slot_thickness/2,arm_ground_clearance/2+wheel_clearance/2+6IN_LAZY_SUSAN_HEIGHT+v_slot_thickness/2])
    rotate([0,0,0])
    1010Profile(arm_ground_clearance-wheel_clearance-v_slot_thickness);
    
    translate([-6IN_LAZY_SUSAN_WIDTH/2+v_slot_thickness/2,v_slot_thickness/2,arm_ground_clearance/2+wheel_clearance/2+6IN_LAZY_SUSAN_HEIGHT+v_slot_thickness/2])
    rotate([0,0,0])
    1010Profile(arm_ground_clearance-wheel_clearance-v_slot_thickness);
    
    translate([0,v_slot_thickness/2,wheel_clearance+20])
    rotate([0,90,0])
    1010Profile(6IN_LAZY_SUSAN_WIDTH+300);
    
}

// accessory functions
function INCH_TO_MM(x) = x*304.8;