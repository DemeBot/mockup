inner_width=25.8;
slot_width=6;
slot_depth=2;
wall_thickness=5;

screw_hole_diameter = 6.5;
screw_hole_count = 2;

use <MCAD/2dshapes.scad>

6IN_LAZY_SUSAN_WIDTH = 152.4;
arm_length=1150-152.4-500;

color("blue")
1010MotorizedRodHolder(73.11);
//1010MotorizedRodHolder(rod_holder_angle=((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14);

translate([inner_width+4*wall_thickness,0,0])
color("blue")
1010RodHolder(73.11);
//1010RodHolder(rod_holder_angle=((6IN_LAZY_SUSAN_WIDTH+150)/arm_length)/2*180/3.14);

smoothness = 8*2;

//1010Holder(5);

module 1010MotorizedRodHolder(height=50, rod_holder_angle=10, rod_diameter=10,motor_angle=10, mount_depth=inner_width){
    difference(){
        union(){
            1010RodHolder(height=50, rod_holder_angle=rod_holder_angle, rod_diameter=10);
            translate([-(inner_width)/2,0,0])
            intersection(){
                rotate([90+rod_holder_angle,0,0])
                motor_mount();
            translate([-(inner_width),0,0])
                cube([50+wall_thickness,inner_width+wall_thickness*2,50],center=true);
            }
        }
        translate([0,0,-height])
        linear_extrude(height*2){
            1010_inner_profile();
        }
        /* Removed because base rod holder can place screwholes
        screw_gap = (height)/(screw_hole_count+1);
        translate([0,0,-height/2])
        rotate([90,0,0])
        for(i=[1:screw_hole_count]){
                translate([0,i*screw_gap,0])
                cylinder(d=screw_hole_diameter, h= 50, $fn=smoothness);
        }*/
    }
}

module motor_mount(mount_depth=inner_width/2){
    
    for(i=[0,1]){
        rotate([180*i,0,0])
        linear_extrude(mount_depth)
        motor_mount_profile();
    }
    
}

module motor_mount_profile(motor_diameter=37.5){
    translate([-motor_diameter/2-wall_thickness,0,0])
    difference(){
        union(){
            circle(d=motor_diameter+wall_thickness*2, $fn=smoothness*2);
            translate([(motor_diameter+wall_thickness*2)/4+50,0,0])
            square([(motor_diameter+wall_thickness*2)/2+100,motor_diameter+wall_thickness*2], center=true);
        }
        circle(d=motor_diameter, $fn=smoothness*2);
        //translate([-motor_diameter/2,0])
        //square([wall_thickness*2,.5],center=true);
    }
}

module 1010RodHolder(height=50, rod_holder_angle=10, rod_diameter=10){
    rod_holder_diameter=20;
    rod_holder_height=5;
    rod_hole_depth=10;
    
    color("blue")
    translate([0,0,-height/2])
    difference(){
        hull(){
            linear_extrude(height)
                1010_outer_profile();
            
            translate([0,rod_holder_height+(inner_width+wall_thickness*2)/2,height/2])
            rotate([-90+rod_holder_angle,0,0])
            cylinder(d=rod_holder_diameter,$fn=smoothness);
        }
        
        translate([0,0,-0.5])
        linear_extrude(height+1)
            1010_inner_profile();
        
        translate([0,rod_holder_height+(inner_width+wall_thickness*2)/2,height/2])
        rotate([-90+rod_holder_angle,0,0])
        translate([0,0,1.5])
        cylinder(d=rod_diameter,h=rod_hole_depth*2,center=true, $fn=smoothness);
       
        
        screw_gap = (height)/(screw_hole_count+1);
        rotate([90,0,0])
        for(i=[1:screw_hole_count]){
                translate([0,i*screw_gap,0])
                cylinder(d=screw_hole_diameter, h= 50, $fn=smoothness);
        }
    }
}

module RodMount(rod_holder_angle=10, rod_diameter=10){
    
    difference(){
        hull(){
            roundedBox([width, height, .1], 5, sidesonly=true, $fn=smoothness);
            rotate([rod_holder_angle,0,0])
            translate([0,0,10])
            cylinder(d=rod_holder_diameter, h=.1, $fn=smoothness);
        }
        
        translate([0,0,10])
        rotate([rod_holder_angle,0,0])
        cylinder(d=rod_diameter, h=15, center=true, $fn=smoothness);
    }
}

module 1010Holder(height=50){
    translate([0,0,-height/2])
    linear_extrude(height)
    difference(){
        1010_outer_profile();
        1010_inner_profile();
    }
}

module 1010_inner_profile(){
    difference(){
        roundedSquare(pos=[inner_width,inner_width],r=2, $fn=smoothness);
        for(i=[0:3]){
            rotate([0,0,90*i])
            translate([0,(inner_width-slot_depth)/2,0]){
                square([slot_width,slot_depth],center=true);
                for(j=[-1,1]){
            difference(){
                translate([j*(slot_width/2+.5),.5,0])
                square([1,1],center=true);
                translate([j*(slot_width/2+1),0,0])
                circle(r=1, $fn=smoothness);
            }
        }
        }
        }
    }
}

module 1010_outer_profile(thickness=5){
    roundedSquare(pos=[inner_width+thickness*2,inner_width+thickness*2],r=2+thickness,$fn=smoothness);
}