use <InvGears.scad>

//HerringboneGear(teeth,pitch,pressure,thk,angle=0,rim=1,adj=0)

gear_assembly();

module gear_assembly(){
    pitch = 0.475;
    thickness = 5;
    gear_root = 6;
    
    cone_height = 5;
    cone_thickness = 2;
    
    //echo("root diameter",rootDR(21,pitch));
    //echo("outer diameter",outDO(21,pitch));

    HerringboneGear(teeth=21,pitch=pitch,pressure=20,thk=thickness,angle=14.5,rim=1,adj=0);
    
    translate([0,0,thickness])
    difference(){
        union(){
            cylinder(14, cone_thickness+34.5/2, cone_thickness+38.2/2, $fn=50);
            translate([0,0,-thickness])
            cylinder(d=rootDR(21,pitch), h=thickness);
        }
        cylinder(14, 34.5/2, 38.2/2, $fn=50);
            translate([0,0,-thickness-0.5])
            cylinder(d=rootDR(21,pitch)-gear_root, h=thickness+1);
        
    }


    //echo("root diameter",rootDR(14,pitch));
    //echo("outer diameter",outDO(14,pitch));

    translate([10+38,0,thickness])
    rotate([0,180,19])
    difference(){
        union(){
        HerringboneGear(teeth=14,pitch=pitch,pressure=20,thk=thickness,angle=14.5,rim=1,adj=0);
            cylinder(d=rootDR(14,pitch)-1, h=thickness);
        }
        
        translate([0,0,-.5])
        difference(){
            cylinder(d=6.5, h=thickness+1, $fn= 25);
            translate([0,3.25,3])
            cube([6.5,1.4,6], center=true);
        }
    }
}