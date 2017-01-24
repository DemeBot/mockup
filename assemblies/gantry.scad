use <pc_wheel.scad>;
use <TSlot.scad>;
use <nema17.scad>;
use <brackets.scad>;

length=125;
width=60;
TSlot_width=25.4;
wheel_offset=20;

GANTRY_ASSEMBLY();

echo("width",get_nema17_width());

module GANTRY_ASSEMBLY(){
    for(j=[-1,1]){
        rotate([0,90,0])
        translate([0,j*(width+TSlot_width)/2,0])
        1010Profile(length);

        rotate([90,0,0])
        translate([j*(length-TSlot_width)/2,0,0])
        1010Profile(width);
    
        rotate([j*90+90,0,0])
        for(i=[-1,1]){
            translate([i*((width)/2+TSlot_width),(length-TSlot_width)/2+wheel_offset,0])
            rotate([0,0,90])
            PC_WHEEL();
        }
        
        color("dimgrey")
        translate([0,j*((width)/2+TSlot_width),(TSlot_width+get_nema17_width())/2])
        rotate([j*-90,0,0])
        nema17(39.5);
        
        color("blue")
        translate([0,j*-((width)/2+TSlot_width),0])
        rotate([j*90,90,0])
        1010MotorMount(2.5);
    
        for(i=[-1,1]){
            rotate([90+90*i,0,0])
            translate([j*(length-TSlot_width)/2,j*-((width+TSlot_width)/2),TSlot_width/2])
            rotate([0,0,90*j])
            color("blue")
            1010GantryBracket();
                
            rotate([90+90*i,0,0])
            translate([-j*(length-TSlot_width)/2,j*-((width+TSlot_width)/2),TSlot_width/2])
            rotate([0,0,90-90*j])
            color("blue")
            1010GantryBracket();
        }
        
    }
    
}