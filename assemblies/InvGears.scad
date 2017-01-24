// Involute gear libray
// Trevor Moseley 13/06/2012
// OpenSCAD version 2015.03-2
// re-visit, calculate tooth as centred polygon

// For involute gear tooth ring creation see
//   http://www.cartertools.com/involute.html by Nick Carter
// For gear descriptions see:
//   http://www.engineersedge.com/gears/gear_types.htm

// yes Spur (standard)
// no  Rack & Pinion (Rack is teeth in a row, usually flat)
// yes helical gears (teeth at an angle)
// no  Face gear (circular disc with teeth on circumference to mate with spur gear)
// yes bevel gear (cone shaped, axles not parallel)
// yes Spiral bevel gear (cone shaped, teeth at angle)
// no  worm gear set (one way, downgear)
// yes hypoid gears (2 Spiral Bevel with differet tooth angles)
// yes herringbone gears (double helix)

iShowC = 0;     // 1=Show all calculation circles
iShowT = 0;     // 1=Show all calculation tangents
iDemo = 0;      // include demo code

//-----------------------------------------------------------------------------------
// User Function prototypes

//SpurGear(teeth,pitch,angle,thk,rim,edge,adj)
//  teeth: number of teeth
//  pitch: varies size of teeth, smaller pitch = larger teeth
//  angle: pressure angle lower = squarer
//  thk:   thickness of gear
//  rim:   thickness of rim (0 = no rim)
//  edge:  bevelled edge size (0=no edge)
//  adj:   adjustment (small amounts to make under/over sized)
//    Spur gears are the most common type used. Tooth contact is primarily rolling, 
//    with sliding occurring during engagement and disengagement. 
//    Some noise is normal, but it may become objectionable at high speeds

//HelicalGear(teeth,pitch,pressure,thk,angle=0,rim=1,edge=0,adj=0)
//  teeth: number of teeth
//  pitch: varies size of teeth, smaller pitch = larger teeth
//  pressure: pressure angle lower = squarer
//  thk:   thickness of gear
//  rim:   thickness of rim (0 = no rim)
//  edge:  bevelled edge size (0=no edge)
//  adj:   adjustment (small amounts to make under/over sized)
//  angle: angle of teeth (typical 14.5 or 20 degrees)
//    Helical gear  is a cylindrical shaped gear with helicoid teeth.
//    Helical gears operate with less noise and vibration than spur gears.
//    At any time, the load on helical gears is distributed over several teeth,
//    resulting in reduced wear. Due to their angular cut, teeth meshing results in
//    thrust loads along the gear shaft. This action requires thrust bearings to
//    absorb the thrust load and maintain gear alignment. They are widely
//    used in industry. A negative is the axial thrust force the helix
//    form causes.

//HerringboneGear(teeth,pitch,pressure,thk,angle=0,rim=1,adj=0)
//  teeth: number of teeth
//  pitch: varies size of teeth, smaller pitch = larger teeth
//  pressure: pressure angle lower = squarer
//  thk:   thickness (z) of gear
//  rim:   thickness of rim (0 = no rim)
//  adj:   adjustment (small amounts to make under/over sized)
//  angle: angle of teeth
//    Herringbone or Double helical gear have both left-hand and right-hand
//    helical teeth. The double helical form is used to balance the 
//    thrust forces and provide additional gear shear area.

//BevelGear(teeth,pitch,pressure,bevel,thk,rim=1,adj=0)
//  teeth: number of teeth
//  pitch: varies size of teeth, smaller pitch = larger teeth
//  pressure: pressure angle lower = squarer
//  thk:   thickness (z) of gear
//  rim:   thickness of rim (0 = no rim)
//  adj:   adjustment (small amounts to make under/over sized)

//-----------------------------------------------------------------------------------
//demo/test
if (iDemo > 0)
{
    //  chose view|animate values Steps:180 FPS:30 to see in action
    //  teeth numbers are usually odd (as opposed to even)
    $fn         =  50;      // standard circle quality
    Teeth1      =  21;      // Number of teeth on gear1 (left)    
    Teeth2      =  7;      // Number of teeth on gear2 (right)
    Pitch       =   0.7;    // see above
    Pressure    =  18;      // Pressure Angle   
    Angle       =  14.5;    // Teeth Angle (for helical, Herringbone)
    Bevel       =  90;      // Bevel gear pitch line angle
    Thk         =  5;      // Thickness (z) of gears
    Edge        =   0;      // Bevelled edge
    Rim         =   0;      // Rim thickness
    Base        =   0.5;    // tapered base
    Adj         =   0;      // Adjust for gears
    Typ         =   0;      // which gear type
                            // 0=Spur,1=Heli,2=Herring,3=Bevel
    G2Angle     =   0;      // may need to adjust this for different teeth
                            // combinations to get initial mesh

    rotate([0,0,360*$t])    // this animates gear1 (if on)
    {
        // this causes gear1 choice to be drawn
        if (Typ==0) SpurGear(Teeth1,Pitch,Pressure,Thk,Rim,Edge,Adj);
        if (Typ==1) HelicalGear(Teeth1,Pitch,Pressure,Thk,Angle,Rim,Edge,Adj);
        if (Typ==2) HerringboneGear(Teeth1,Pitch,Pressure,Thk,-Angle,Rim,Edge,Adj);
        if (Typ==3) BevelGear(Teeth1,Pitch,Pressure,Bevel,Thk,Rim,Adj);
        if (Typ==4) SpiralGear(Teeth1,Pitch,Pressure,Bevel,Angle,Thk,Rim,Adj);
    }
    if (Typ == 3 || Typ == 4)
    {
        translate([0,0,Thk/2])  circ(pitchD(Teeth1,Pitch),0.1); // show pitch diameter
        translate([pitchD(Teeth1,Pitch)/2,0,Thk/2])
            rotate([0,-Bevel,0])
                translate([pitchD(Teeth2,Pitch)/2,0,0])
                {
                    if (iShowC == 0)
                        circ(pitchD(Teeth2,Pitch),0.1); // show pitch diameter
                    translate([0,0,-Thk/2])
                        rotate([0,0,G2Angle-360*$t*Teeth1/Teeth2]) // this animates gear2 (if on)
                        {
                            if (Typ == 3)
                                BevelGear(Teeth2,Pitch,Pressure,Bevel,Thk,Rim,Adj);
                            if (Typ == 4)
                                SpiralGear(Teeth2,Pitch,Pressure,Bevel,-Angle,Thk,Rim,Adj);
                        }
                }
    }
    else
    {
        if (iShowC == 0)
            circ(pitchD(Teeth1,Pitch),0.1); // show pitch diameter
        // move into position for drawing gear2
        translate([(pitchD(Teeth1,Pitch)/2)+(pitchD(Teeth2,Pitch)/2),0,0])
        {
            rotate([0,0,G2Angle-360*$t*Teeth1/Teeth2]) // this animates gear2 (if on)
            {
                if (Typ==0) SpurGear(Teeth2,Pitch,Pressure,Thk,Rim,Edge,Adj);
                if (Typ==1) HelicalGear(Teeth2,Pitch,Pressure,Thk,-Angle,Rim,Edge,Adj);
                if (Typ==2) HerringboneGear(Teeth2,Pitch,Pressure,Thk,Angle,Rim,Edge,Adj);
            }
            circ(pitchD(Teeth2,Pitch),0.1);
        }
    }
}

//-----------------------------------------------------------------------------------
// Functions
//   P= Diametral Pitch
//   N = Number of teeth
//   PA = Pressure Angle
Pi=3.14159;		// 3.1415926535897932384626433832795
function pitchD(N,P)	=N/P;
    // gives pitch diameter (circle of contact between gears)
function baseDB(N,P,PA)	=N/P*cos(PA);
    // gives base diameter (circle of base of involute part of teeth)
function addendum(P)	=1/P;
    // gives length of involute part of each tooth
function dedendum(P)	=1.157/P;
    // gives length of root part of each tooth
function outDO(N,P)		=(N/P)+(2*addendum(P));
    // gives maximum diameter of gear
function rootDR(N,P)	=(N/P)-(2*dedendum(P));
    // gives root diameter (circle of teeth mounting)
function baseCB(N,P)	= Pi*baseDB(N,P);
    // gives circumference of base circle

//----------------------------------------------------------------------------------
// User gear modules (described above)

module SpurGear(teeth,pitch,pressure,thk,rim=1,edge=0,adj=0)
// standard gear
{
    if (edge == 0)
        Gear1(teeth,pitch,pressure,thk,rim,adj);
    else
    {
        Pb=(teeth+2)/(outDO(teeth,pitch)-edge);
        translate([0,0,edge+0.1]) rotate([0,180,0]) 
            Gear2(teeth,Pb,pressure,40,edge+0.1,rim,adj,0);
        translate([0,0,edge]) 
        {
            if (rim>0)
                Gear1(teeth,pitch,pressure,thk-(edge*2),rim+edge,adj); 
            else
                Gear1(teeth,pitch,pressure,thk-(edge*2),0,adj); 
        }
        translate([0,0,thk-edge-0.1]) 
            Gear2(teeth,Pb,pressure,40,edge+0.1,rim,adj,0);
    }
}

module HelicalGear(teeth,pitch,pressure,thk,angle=0,rim=1,edge=0,adj=0)
// spur gear with angled teeth
{
    if (edge ==0)
    {
        intersection()
        {
            cylinder(d=outDO(teeth,pitch),h=thk);
            translate([0,0,-thk/2]) Gear1(teeth,pitch,pressure,thk*2,rim,adj,angle);
        }
    }
    else
    {
        dia=outDO(teeth,pitch);
        df=sin(40)*edge;
        Pb=(teeth+2)/(dia-df);
        rd=rootDR(teeth,pitch);
        difference()
        {
            union()
            {
                intersection()
                {
                    union()
                    {
                        cylinder(d1=dia-edge,d2=dia,h=edge+0.01);
                        translate([0,0,edge]) cylinder(d=dia,h=thk-(edge*2));
                        translate([0,0,thk-edge-0.01]) cylinder(d1=dia,d2=dia-edge,h=edge+0.01);
                    }
                    translate([0,0,-thk/2]) Gear1(teeth,pitch,pressure,thk*2,0,adj,angle);
                }
                if (rim>0)
                {
                    cylinder(d1=rd-df,d2=rd,h=edge+0.01);
                    translate([0,0,edge])   cylinder(d=rd,h=thk-(edge*2));
                    translate([0,0,thk-edge-0.01])  cylinder(d1=rd,d2=rd-df,h=edge+0.01);
                }
            }
            if (rim>0)
                translate([0,0,-0.1])   cylinder(d=rd-(rim*2),h=thk+0.2);
        }
    }
}

module HerringboneGear(teeth,pitch,pressure,thk,angle=0,rim=1,edge=0,adj=0)
// 2 helical gears stuck together
{
    half=thk/2;
    DO=outDO(teeth,pitch);
    rd=rootDR(teeth,pitch);
    if (edge==0)
    {
        intersection()
        {
            cylinder(d=DO,h=half+0.01);
            translate([0,0,-half/2]) Gear1(teeth,pitch,pressure,thk,rim,adj,angle);
        }
        translate([0,0,half]) intersection()
        {
            cylinder(d=DO,h=half);
            translate([0,0,-half/2]) Gear1(teeth,pitch,pressure,thk,rim,adj,-angle);
        }
    }
    else
    {
        df=sin(40)*edge;
        difference()
        {
            union()
            {
                intersection()
                {
                    union()
                    {
                        cylinder(d1=DO-edge,d2=DO,h=edge+0.01);
                        translate([0,0,edge]) cylinder(d=DO,h=half-edge+0.01);
                    }
                    translate([0,0,-half/2]) Gear1(teeth,pitch,pressure,thk,0,adj,angle);
                }
                translate([0,0,half]) intersection()
                {
                    union()
                    {
                        cylinder(d=outDO(teeth,pitch),h=half-edge);
                        translate([0,0,half-edge-0.01]) cylinder(d1=DO,d2=DO-edge,h=edge+0.01);
                    }
                    translate([0,0,-half/2]) Gear1(teeth,pitch,pressure,thk,0,adj,-angle);
                }
                if (rim>0)
                {
                    cylinder(d1=rd-df,d2=rd,h=edge+0.01);
                    translate([0,0,edge]) cylinder(d=rd,h=thk-(edge*2));
                    translate([0,0,thk-edge-0.01]) cylinder(d1=rd,d2=rd-df,h=edge+0.01);
                }
            }
            translate([0,0,-0.1])   cylinder(d=rd-(rim*2),h=thk+0.2);
        }
    }
}

module BevelGear(teeth,pitch,pressure,bevel,thk,rim=1,adj=0)
{
    Gear2(teeth,pitch,pressure,bevel,thk,rim,adj,0);
}

module SpiralGear(teeth,pitch,pressure,bevel,angle,thk,rim=1,adj=0)
{
	D = pitchD(teeth,pitch);    // pitch diameter of gear
    df = sin(bevel)*thk;        // difference needed
	DOb = outDO(teeth,teeth/(D+df));
	DOt = outDO(teeth,teeth/(D-df));
    
    intersection()
    {
        cylinder(d1=DOb,d2=DOt,h=thk);
        translate([0,0,-thk/2]) Gear2(teeth,pitch,pressure,bevel,thk*2,rim,adj,angle);
    }
}

module WormGear(teeth,pitch,pressure,thk,len,adj)
{
    cylinder(d=thk,h=len);
}

//----------------------------------------------------------------------------------
// General User Modules

module bevelCube(x,y,z,edge)
{
    if (edge==0)
        cube([x,y,z]);
    else
    {
        polyhedron(
            points=[
        [edge,edge,0],[x-edge,edge,0],[x-edge,y-edge,0],[edge,y-edge,0],    //0-3
        [0,0,edge],   [x,0,edge],     [x,y,edge],       [0,y,edge],         //4-7
        [0,0,z-edge], [x,0,z-edge],   [x,y,z-edge],     [0,y,z-edge],       //8-11
        [edge,edge,z],[x-edge,edge,z],[x-edge,y-edge,z],[edge,y-edge,z]],   //12-15
            faces=[
        [0,1,2,3], // bottom
        [4,5,1,0],[5,6,2,1],[6,7,3,2],[7,4,0,3], // low bevel
        [8,9,5,4],[9,10,6,5],[10,11,7,6],[11,8,4,7], // middle
        [12,13,9,8],[13,14,10,9],[14,15,11,10],[15,12,8,11], // hi bevel
        [15,14,13,12]
        ]);
        
    }
}

//----------------------------------------------------------------------------------
// Primitives - low level (not really meant for user use)

module Gear1(teeth,pitch,pressure,thk,rim,adj,tangle=0)
{
    D = pitchD(teeth,pitch);
	DO = outDO(teeth,pitch);
	RO = DO/2;
	DB = baseDB(teeth,pitch,pressure);
	RB = DB/2;
	DR = rootDR(teeth,pitch);
	RR = DR/2;
	A = 90/teeth;
	mA = acos(RB/(RO+adj))+A;	// max angle for involute curve points
	ACB = mA / 10;
	FCB = tan(ACB)*RB;
	//echo("DB=",DB,"RO=",RO,"mA=",mA,"FCB=",FCB,"ACB=",ACB);

	// calculate tooth points centred on Base circle
	x0=(sin(A)*RR)+adj;		    // root x either side on Root circle
	y0=(cos(A)*RR)-RB-1;	// y offset of points on either side on Root circle
	z=thk/2;			    // height above and below centre
	// for each point:
	//   calculate angle between tooth centre and curve point
	//   calculate hypotenues of point triangle
	ang=[ for(a=[1:9]) [atan((a*FCB)/RB)-(a*ACB)+A,sqrt(pow(RB,2)+pow(a*FCB,2)),0]];
	// use previous values to calculate x & y (opp=x, adj=y, got hyp and angle)
	pt=[ for(a=[1:9]) [sin(ang[a-1].x)*ang[a-1].y,(cos(ang[a-1].x)*ang[a-1].y)-RB,0]];
	// put values into points list
	bp1 = [[-x0,y0,-z],    // left point of tooth on rootDR
		   [ x0,y0,-z]];   // right point of tooth on rootDR
    bp2 = [for(a=[0:8]) [pt[a].x+adj,pt[a].y+adj,-z]];      // right curve to top
    bp3 = [for(a=[0:8]) [-pt[8-a].x-adj,pt[8-a].y+adj,-z]]; // left curve to root
    bp4 = concat(bp1,bp2,bp3);                          // bottom face
    bp5 = [for(a=[0:len(bp4)-1])[bp4[a].x,bp4[a].y,z]]; // top face
    bp = concat(bp4,bp5);
    //echo("bp=",bp);
    // calculate faces
	fc1 = [ [for(a=[0:len(bp4)-1])a] ];                 // bottom face
    fc2 = [ [for(a=[len(bp4)-1:-1:0])a+len(bp4)] ];     // top face
    fc3 = [ for(a=[0:len(bp4)-2])                       // sides
            [a+1,a,len(bp4)+a,len(bp4)+a+1] ];
    fc4 = [ [len(bp)-1,len(bp4),0,len(bp4)-1] ];        // join start to end of side
    fc = concat(fc1,fc2,fc3,fc4);
    //echo("fc=",fc);
	for (t=[0:teeth-1])
	{
		rotate([0,0,t*A*4])	translate([0,RB,thk/2])
		{	
            // uncomment this line and comment next to see points
            if (iShowT > 0)
                for (x=[0:(len(bp)/2)-1]) translate(bp[x])	cylinder(d=0.1,h=1);
            else
                rotate([0,tangle,0]) polyhedron( points = bp, faces = fc, center=true);
		}
	}
    // root ring
    if (rim > 0)
    {
        difference()
        {
            cylinder(d=DR,h=thk);
            translate([0,0,-0.1])   cylinder(d=DR-(rim*2),thk+0.2);
        }
    }
    if (iShowC>0)
    {
        // show working like http://www.cartertools.com/involute.html
        circ(DO,0.1);
        circ(D,0.1);
        circ(DB,0.1);
        circ(DR,0.1);
        rotate([0,0,A]) translate([-0.1,0,0]) cube([0.1,RB,0.1]);
        rotate([0,0,-A]) cube([0.1,RB,0.1]);
    }
    if (iShowT>0)
    {
        for (x=[1:9])
        {
            rotate([0,0,(x*ACB)-A])
            {
                cube([0.05,RB,0.05]);
                translate([0,RB,0])
                    cube([FCB*x,0.05,0.05]);
            }
        }
    }
}

module Gear2(teeth,pitch,pressure,bevel,thk,rim,adj=0,tangle=0)
{
    // figure bottom & top pitches
	D = pitchD(teeth,pitch);    // pitch diameter of gear
    R = D/2;
	RB = baseDB(teeth,pitch,pressure)/2;
    df = sin(bevel)*thk;        // difference needed
    Db = D+df;
    Pb = teeth/Db;
    Dt = D-df;
    Pt = teeth/Dt;
	A = 90/teeth;
	z=thk/2;			        // height above and below centre
    // bottom vales
	DOb = outDO(teeth,Pb);
	ROb = DOb/2;
	DBb = baseDB(teeth,Pb,pressure);
	RBb = DBb/2;
	DRb = rootDR(teeth,Pb);
	RRb = DRb/2;
	mAb = acos(RBb/(ROb+adj))+A;	// max angle for involute curve points
	ACBb = mAb / 10;
	FCBb = tan(ACBb)*RBb;
    // top values
	DOt = outDO(teeth,Pt);
	ROt = DOt/2;
	DBt = baseDB(teeth,Pt,pressure);
	RBt = DBt/2;
	DRt = rootDR(teeth,Pt);
	RRt = DRt/2;
	mAt = acos(RBt/(ROt+adj))+A;	// max angle for involute curve points
	ACBt = mAt / 10;
	FCBt = tan(ACBt)*RBt;
    //echo("D",D,"df",df,"Db",Db,"Dt",Dt);

	// calculate tooth points centred on Base circle for bottom face
	xb=(sin(A)*RRb)+adj;		    // root x either side on Root circle
	yb=(cos(A)*RRb)-R-1;	// y offset of points on either side on Root circle
	// for each point:
	//   calculate angle between tooth centre and curve point
	//   calculate hypotenues of point triangle
	ab=[ for(a=[1:9]) [atan((a*FCBb)/RBb)-(a*ACBb)+A,sqrt(pow(RBb,2)+pow(a*FCBb,2)),0]];
	// use previous values to calculate x & y (opp=x, adj=y, got hyp and angle)
	pb=[ for(a=[1:9]) [sin(ab[a-1].x)*ab[a-1].y,(cos(ab[a-1].x)*ab[a-1].y)-R,0]];
	// put values into points list
	bp1 = [[-xb,yb,-z],    // left point of tooth on rootDR
		   [ xb,yb,-z]];   // right point of tooth on rootDR
    bp2 = [for(a=[0:8]) [pb[a].x+adj,pb[a].y+adj,-z]];      // right curve to top
    bp3 = [for(a=[0:8]) [-pb[8-a].x-adj,pb[8-a].y+adj,-z]]; // left curve to root
    bp4 = concat(bp1,bp2,bp3);                              // bottom face

	// calculate tooth points centred on Base circle for top face
	xt=(sin(A)*RRt)+adj;		    // root x either side on Root circle
	yt=(cos(A)*RRt)-R-1;	// y offset of points on either side on Root circle
	// for each point:
	//   calculate angle between tooth centre and curve point
	//   calculate hypotenues of point triangle
	at=[ for(a=[1:9]) [atan((a*FCBt)/RBt)-(a*ACBt)+A,sqrt(pow(RBt,2)+pow(a*FCBt,2)),0]];
	// use previous values to calculate x & y (opp=x, adj=y, got hyp and angle)
	pt=[ for(a=[1:9]) [sin(at[a-1].x)*at[a-1].y,(cos(at[a-1].x)*at[a-1].y)-R,0]];
	// put values into points list
	bp5 = [[-xt,yt,z],    // left point of tooth on rootDR
		   [ xt,yt,z]];   // right point of tooth on rootDR
    bp6 = [for(a=[0:8]) [pt[a].x+adj,pt[a].y+adj,z]];      // right curve to top
    bp7 = [for(a=[0:8]) [-pt[8-a].x-adj,pt[8-a].y+adj,z]]; // left curve to root
    bp8 = concat(bp5,bp6,bp7);                          // bottom face
    
    bp = concat(bp4,bp8);
    //echo("bp=",bp);
    // calculate faces
	fc1 = [ [for(a=[0:len(bp4)-1])a] ];                 // bottom face
    fc2 = [ [for(a=[len(bp4)-1:-1:0])a+len(bp4)] ];     // top face
    fc3 = [ for(a=[0:len(bp4)-2])                       // sides
            [a+1,a,len(bp4)+a,len(bp4)+a+1] ];
    fc4 = [ [len(bp)-1,len(bp4),0,len(bp4)-1] ];        // join start to end of side
    fc = concat(fc1,fc2,fc3,fc4);
    //echo("fc=",fc);
	for (t=[0:teeth-1])
	{
		rotate([0,0,t*A*4])	translate([0,D/2,thk/2])
		{	
            // uncomment this line and comment next to see points
			//for (x=[0:len(bp)-1]) translate(bp[x])	cylinder(d=0.1,h=1);
			rotate([0,tangle,0]) polyhedron( points = bp, faces = fc);
		}
	}
    // root ring
    if (rim > 0)
    {
        difference()
        {
            cylinder(d1=DRb,d2=DRt,h=thk);
            translate([0,0,-0.1])   cylinder(d=DRt-(rim*2),thk+0.2);
        }
    }
	// show working like http://www.cartertools.com/involute.html
    if (iShowC>0)
    {
        circ(DOb,0.1);
        circ(Db,0.1);
        circ(DBb,0.1);
        circ(DRb,0.1);
        rotate([0,0,A]) translate([-0.1,0,0]) cube([0.1,RBb,0.1]);
        rotate([0,0,-A]) cube([0.1,RBb,0.1]);
        translate([0,0,thk])
        {
            circ(DOt,0.1);
            circ(Dt,0.1);
            circ(DBt,0.1);
            circ(DRt,0.1);
            rotate([0,0,A]) translate([-0.1,0,0]) cube([0.1,RBt,0.1]);
            rotate([0,0,-A]) cube([0.1,RBt,0.1]);
        }
    }
    if (iShowT>0)
    {
        for (x=[1:9])
        {
            rotate([0,0,(x*ACBb)-A])
            {
                cube([0.05,RBb,0.05]);
                translate([0,RBb,0])
                    cube([FCBb*x,0.05,0.05]);
            }
        }
        translate([0,0,thk])
        {
            for (x=[1:9])
            {
                rotate([0,0,(x*ACBt)-A])
                {
                    cube([0.05,RBt,0.05]);
                    translate([0,RBt,0])
                        cube([FCBt*x,0.05,0.05]);
                }
            }
        }
    }
}

module circ(dia,thk)
{
	translate([0,0,-thk/2]) difference()
	{
		cylinder(d=dia+thk,h=thk);
		translate([0,0,-0.1])	cylinder(d=dia-thk,h=thk+0.2);
	}
}
