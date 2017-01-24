use <utilities/fillet.scad>

local_render_pvc_od=90;

total_thickness = 20;

total_height = 25;
base_height = 10;

screw_distance = 170/2;
screw_diameter = 5;

main_plate_thickness = 3;
main_plate_radius = 150;

pvc_screw_offset = 15;

local_render_smoothness=16*8;

SUSAN_ADAPTER(smoothness=32);

module SUSAN_ADAPTER(pvc_od = local_render_pvc_od, smoothness = local_render_smoothness){
    difference(){
        union(){
            fillet(r=10, steps=smoothness/16){
            //union(){
                hull(){
                    cylinder(d=main_plate_radius, h=main_plate_thickness, $fn=smoothness);
                    
                    for(i=[0:3]){
                        rotate([0,0,45+90*i])
                        translate([screw_distance,0,0])
                        cylinder(d=screw_diameter+10, h=main_plate_thickness, $fn=smoothness/2);
                    }
                cylinder(d=pvc_od+total_thickness,h=base_height, $fn=smoothness);
                }
                
                translate([0,0,base_height])
                cylinder(d1=pvc_od+total_thickness, d2=pvc_od+total_thickness/2, h=total_height-base_height, $fn=smoothness);
            }
            
            intersection(){
                for(i=[0:3]){
                    fillet(r=20, steps=smoothness/8){
                        rotate([0,0,90*i])
                        translate([pvc_od/2-1,0,total_height])
                        rotate([0,90,0])
                        translate([0,0,-2.5])
                        hull(){
                            cylinder(d1=20, d2=15,h=10, $fn=smoothness/8);
                            translate([-pvc_screw_offset,0,0])
                            cylinder(d1=20, d2=15,h=10, $fn=smoothness/4);
                        }
                        
                        translate([0,0,base_height])
                        cylinder(d1=pvc_od+total_thickness, d2=pvc_od+total_thickness/2, h=total_height-base_height, $fn=smoothness);
                    }
                }
                    cylinder(d=pvc_od+total_thickness/2,h=100, $fn=smoothness);
            }
        }
        
            translate([0,0,-5])
            cylinder(d=pvc_od, h=150, $fn=smoothness);
            
        
        for(i=[0:3]){
                    rotate([0,0,45+90*i]){
                        translate([screw_distance,0,-5]){
                            cylinder(d=screw_diameter, h=50, $fn=smoothness/2);
                            
                            translate([0,0,5+main_plate_thickness])
                                cylinder(d=screw_diameter+5, h=50, $fn=smoothness/2);
                        }
                        
                        
                    }
                    
                    for(j=[0,1])
                    translate([0,0,pvc_screw_offset*j])
                    rotate([0,0,90*i]){
                        translate([pvc_od/2-1,0,total_height])
                        rotate([0,90,0])
                        cylinder(d=screw_diameter,h=10, $fn=smoothness);
                        
                        translate([pvc_od/2+4,0,total_height])
                        rotate([0,90,0])
                        cylinder(d=screw_diameter+5,h=10, $fn=smoothness);
                    }
        }
    }
}
