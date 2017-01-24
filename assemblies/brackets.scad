

1010GantryBracket(2.5); 
//1010MotorMount(2.5);

module 1010GantryBracket(thickness=2.5){
    translate([0,0,thickness/2])
    difference(){
    union(){
        translate([30/2,0,0])
        cube([30,20,thickness], center=true);


        rotate([0,0,90])
        translate([30/2,0,0])
        cube([30,20,thickness], center=true);

        cylinder(d=20, h=thickness, $fn=4*30, center=true);
    }

    translate([20,0,0])
    cylinder(d=5.5, h=thickness+.5, $fn=4*8, center = true);
    translate([0,20,0])
    cylinder(d=5.5, h=thickness+.5, $fn=4*8, center = true);
    cylinder(d=5.5, h=thickness+.5, $fn=4*8, center = true);
    }
}

module 1010MotorMount(thickness=1){
    translate([-(42+20+5.4)/2,0,0])
    linear_extrude(thickness){
        union(){
            difference(){
                square([42,42],center=true);
                
                for(i=[0:1]){
                    rotate([0,0,90+45+90*i])
                    translate([10+53/2,0,0])
                    square([20,20],center=true);
                }
                for(i=[0:3]){
                    
                    rotate([0,0,45+90*i])
                    translate([(41+47)/4,0,0])
                    circle(d=4, center=true, $fn=4*10);
                }
                
                circle(d=25, center=true, $fn=4*25);
            }
            
        }
        
        
        translate([42/2+5.4/4,0,0])
        square([5.4/2,42], center=true);
        
            translate([(42+20+5.4)/2,0,0])
        difference(){
            square([20,42],center=true);
            for(i=[-1,1]){
                translate([0,i*42/4,0])
                circle(d=5.5, $fn=4*25);
                
                translate([(42+20+20+2.2)/2,0,0])
                for(i=[0:1]){
                    rotate([0,0,90+45+90*i])
                    translate([10+53/2,0,0])
                    square([20,20],center=true);
                }
            }
        }
    }
}