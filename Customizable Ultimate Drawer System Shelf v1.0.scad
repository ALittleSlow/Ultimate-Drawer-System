// Customizable Ultimate Drawer System Shelf
// Remixed from MarcElbichon's Ultimate Drawer System https://www.thingiverse.com/thing:2302575 (CC-BY 4.0)
// Copyright (C) 2019 by Brian Alano (and possibly others)
// Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 (CC-BY-NC-SA 4.0) and
// sharable under the GPLv3.

/* Design notes
// width is x dimension, across the face of the drawer
// depth is y dimension, front to back of the drawer
// height is z dimension
*/

/* Coding Style Guide 
 * User parameters and modules use underscores between words.
 * Other variable names use camel case.
 * Separate features into their own modules if they are more than a couple lines long.
 * All dimensions should be assigned to variables, usually global ones so they can be found easily.
 * Keep local modules local.
 * Keep local variables local.
 * Maintain Thingiverse Customizer compatibility.
 * Maintain backwards compatibility with MarcElbichon's Ultimate Drawer System 
   (https://www.thingiverse.com/thing:2302575). This means a 1Ux1Ux1U drawer 
   made with this program will work in MarcElbichon's shelf. 
*/

// Walls are 5 mm (W_t). Slots are 20 mm apart. 0.5 mm gap (g) between side wall and drawer. 
// So the height of a shelf is U.z*(19+1)+W_t*2 = 20U.z+10, width is U.x*120+5*2+1, depth is U.y*120+5*2.
// A double-wide shelf (2-U.x), to stack nicely with a single wide, should be 
// 120U.z+11. With 5 mm walls, 2*(120+11)=D.x+2*W_t+2*g=D.x+11 => D.x (2U drawer width) = 262 - 11 = 251.
// A one-and-a-half wide drawer is (1.5-U.x) is 131+65.5 = 196.5-11 = 185.5.
//which part to render

//TO-DO add stacking aligners

/* [General] */
// which part of the shelf to render. Customizer will generate one of each.
part="shelf"; //[shelf, clip, rear_lock] 
//one U wide is 131 mm. Total width is 131*U.
U_Wide=1; //[1,1.5,2]
//one U high 20 mm for the drawer and 10 mm for the shelf, or 30 mm. In general, total height is 20*U + 10.
U_High=2; //[2:15]
//one U deep is 130 mm. Total depth is 130*U.
U_Deep=1; //[1,1.5,2]
/* [Features] */
// enable using clips to hold shelves together [not implemented]
clips="no"; // [yes, no]
// add retaining clip?
retaining_clip="no"; // [yes, no]
// add a drawer locking mechanism in the rear?
rear_lock="no"; // [yes, no]
/* [Rendering] */
// 3d printing layer height (optimizes some spacing
layer_height = 0.2; // [0.1:0.05:0.3]
// set this to printing before pressing Create Thing for best results
orientation = "printing"; // [printing, viewing]
/* [Advanced] */
/* [Hidden] */
hole_diameter=5;
backThickness=2;

//shelfWidth = 131;
//shelfDepth = 130; //z direction
wallThickness = 5;
shelfUnit = [130, 131, 30];
shelf = [shelfUnit.x * U_Deep, shelfUnit.y * U_Wide, (shelfUnit.z - wallThickness*2) * U_High + wallThickness*2];
shelfCut = [shelf.x, shelf.y - wallThickness*2, shelf.z - wallThickness*2];
/* We want 1 - 2W shelf to be the same dimension as 2 - 1W shelves. This means the drawer will be wider than 120*2 since there are no walls in between. Similarly, we want 2 - 1.5W shelves to be the same dimension as 3 - 1W shelves.
    so
    1W = 131 shelf, 131-10 = 121 cut, 131-11 = 120 drawer
    1.5W=131+65.5=196.5shelf,186.5cut,196.5-11=185.5drawer
    2W = 262 shelf, 262-10 = 252 cut, 262-11 = 251 drawer
    1D = 130 shelf, 130  = 130 cut, 130-10 = 120 drawer
    2D = 260 shelf, 260  = 260 cut, 260-10 = 250 drawer
    1U = (30-walls)*U+walls=30 shelf, 30-10  =  20 cut, 30-10-1=  19 drawer
    2U =  50 shelf, 50-10  =  40 cut, 50-10-1=  39 drawer
    W=
    Front to back we can do the same thing, though it's less useful.
   The same does not apply to the height. 2 - 2U shelves will be 100mm, but 1 - 4U shelf is only 90mm.
*/    

tolerance = 0.2;
slotSpacing = shelfUnit.z - wallThickness*2;

rearLockSlot = [3.5, 26, 8]; // copied from the drawer as a reference dimension
rearLockWallThickness = 1;
// tab is "tongue" part of the rear latch mechanism
tabSize = [1.5, rearLockSlot.y - rearLockWallThickness*2 - tolerance,
    rearLockSlot.z]; 
// bar is the main part of the rear_lock mechanism
barSize = [6.5 - tolerance, tabSize.y, slotSpacing];
snapHead = 4.4;
snapInset = 3;

holeOffset = [20, 12.5, 16]; // positions of the holes from the outside edges of the respective sides
slotBottomWidth = 1.25;
slotSideLength = shelfCut.x - 18;
slotTaperLength = 15;
clipCut = [10, 5, 8];
clip_bar_diameter = 2;
clipThickness = 1.2;
slotDepth = 3;

// Convenience definitions
X = [1, 0, 0]; // x-coordinate unit vector 
Y = [0, 1, 0]; // y-coordinate unit vector 
Z = [0, 0, 1]; // y-coordinate unit vector 
epsilon = 0.01; // mainly used to avoid non-manifold surfaces

$fa=1;
$fs=.4;


//module shelf() {
//    module add() {
//    }
//    module subtract() {
//    }
//    difference() {
//    }
//
//}

// the spacing between drawings is 20, or unit.z + 1. so a 1U drawer is 19, a 2U drawer is 39, etc.
function zU(u) = slotSpacing * u - 1;

// extrude a given length of rear latch bar
module bar_stock(h) {
     reflect(Y) // double the profile half
        linear_extrude(h) 
        polygon([
            [-epsilon, epsilon], [-epsilon, -barSize.y/2],
            [1.35, -barSize.y/2],
            [barSize.x/2, -(barSize.y/2 - barSize.x/2 + 1.35)],
            [barSize.x - 1.35, -barSize.y/2],
            [barSize.x, -barSize.y/2],
            [barSize.x, epsilon]
        ]);
}

module shelf() {
    //yOffset = 13; // for the front latch. Needs work. wide enough to clear any drawer pulls. Otherwise as narrow as possible.
    topSlotSpacing = 20.17; // measured from the original
 
    // h - height of inside of shelf
    // w - weidth of inside of shelf

    // make one of four wall mount plates for the back wall
    module back() {
        r= slotSpacing;
        offset=holeOffset.z - hole_diameter/2;
        module add() {
            translate([wallThickness, wallThickness])
                rotate_extrude2(angle=90)
                square(size=[r, backThickness]);
        }
        module subtract() {
            translate([offset, offset]) 
                cylinder(d=hole_diameter, h=backThickness*4, center=true);
        }
        rotate([0, -90, 0]) // move it from the XY to YZ plane
            difference() {
                add();
                subtract();
        }
    }

    module countersink() {
        counterbore_h = 0.5;
        countersink_h = 2.3;
        counterbore_d = 9;
        through_d = 4.4;
        // counterbore
        translate([0, 0, -epsilon]) cylinder(d=counterbore_d, h=counterbore_h + epsilon*2);
        // countersink
        translate([0, 0, counterbore_h]) cylinder(d1=counterbore_d, d2=through_d, h=countersink_h);
        // through
        translate([0, 0, counterbore_h + countersink_h - epsilon]) cylinder(d=through_d, h=wallThickness);
    }

    module hex_hole() { 
        hex_w = 7.4;
       
        hex_h = 3.5;
        through_h = 1.5;
        through_d = 4.4;
        // hex head
        boxWidth = hex_w/1.75;
        translate([0, 0, hex_h/2-epsilon])
            for (r = [-60, 0, 60])
                rotate([0,0,r])
                cube([boxWidth, hex_w, hex_h+epsilon*2], true);
        // through hole
        translate([0, 0, hex_h - epsilon])
            cylinder(d=through_d, h=through_h + epsilon*2);
    }
    // make the slot and catch that the rear slot slides into
    module rear_slot() {
        blockSize = [barSize.x, barSize.y + tabSize.y/2, shelfCut.z];
        
        // add a block of material to enclose the slot
        module add() {
            translate([-shelf.x/2 + blockSize.x/2, 0, 0])
                cube(blockSize, center=true);
        }
        
        module subtract() {
            // detents for the snap
            reflect(Y) {
                translate([-shelf.x/2 + blockSize.x/2 , barSize.y/2]) {
                    // one to hold it up
                    translate([0, 0, shelf.z/2 - slotSpacing/2 + snapHead/2])
                        cube([blockSize.x + epsilon *2, snapHead, snapHead], center=true);
                    // one to hold it down
                    translate([0, 0, shelf.z/2 - slotSpacing + snapHead/2])
                        cube([blockSize.x + epsilon *2, snapHead, snapHead], center=true);
                }
            }
        }

        difference() {
            add();
            subtract();
        }
    }
    
    module side_slots(h, w) {
    module half_side_slot() {
        w = 11.5;
        slot_w = 1.5;
        module add() {
            translate([-epsilon, 0]) square(size=[w/2+epsilon, slotTaperLength]);
            translate([-epsilon, -slotSideLength]) square(size=[slot_w/2+epsilon, slotSideLength]);
        }
        
        module subtract() {
            // tapered lead-in
            r=31.86927424; // measured from original
            translate([r + slot_w/2, 0]) circle(r=r);
        }
        
        translate([shelf.x/2 - slotTaperLength, 0])
        rotate([0, 90, -90])
            linear_extrude(slotDepth)
                difference() {
                    add();
                    subtract();
                }
        }

        reflect(Y) {
            //bottom slot
            translate([epsilon, -w/2+epsilon, -shelfCut.z/2 + slotBottomWidth] )          
                mirror(Z)
                half_side_slot();
            for (k=[1:U_High-1]) {
                translate([epsilon, -w/2+epsilon, -shelfCut.z/2 + slotBottomWidth + slotSpacing*k] )          
                    reflect(Z)
                    half_side_slot();
            }
        }
    } // half_side_slot

    module top_slot() {
        length = shelf.x - 4; // measured from the original
        width = 1.5; // measured from the original
        cube([length, width, slotDepth], center=true);
    } 

    module add() {
        cube(shelf, center=true);
//      latch bosses. Needs work.
//        translate([(shelf.x - wallThickness)/2, yOffset, shelf.z/2]) 
//            rotate([0, 0, -90]) 
//            latch_boss();
    }

    module subtract() {
        // chamfer edges, 2mm, 45 degrees, so the chamfer face is the sqrt.
        chamfer = sqrt(2);
        reflect(Y)
            reflect(Z)
            translate([0, shelf.y/2, shelf.z/2]) 
            rotate([45, 0, 0]) 
              cube([shelf.x + epsilon *2, chamfer + epsilon, chamfer + epsilon], center=true); 
        // drawer opening
        translate([-epsilon*20, 0, 0]) cube([shelfCut.x + epsilon*100, shelfCut.y, shelfCut.z], center=true);
        // top slots, presumably for strengthening when infill = 0
        reflect(Z)
            reflect(Y)
            for(y=[0 : topSlotSpacing : shelfCut.y/2])
                translate([0, y, shelfCut.z/2 + slotDepth/2 - epsilon])
                top_slot(); 
        // bottom extra slot for bottom drawer
        reflect(Y)
            translate([shelf.x/2 - slotTaperLength - slotSideLength + epsilon, -shelfCut.y/2 - slotDepth + epsilon, -shelfCut.z/2])
            cube([slotTaperLength + slotSideLength, slotDepth, slotBottomWidth]);
        // side slots
        side_slots(h=shelfCut.z, w=shelfCut.y);
        reflect(X) {
            reflect(Y) {
                // bottom holes
                translate([shelf.y/2 - holeOffset.x, shelf.y/2 - holeOffset.y, -shelfCut.z/2]) 
                    rotate([180, 0, 0]) 
                    countersink();
                // top holes
                translate([shelf.x/2 - holeOffset.x, shelf.y/2 - holeOffset.y, shelfCut.z/2]) 
                    hex_hole();
            }
            reflect(Z) {
                // left side holes
                translate([shelf.x/2 - holeOffset.x, shelfCut.y/2, shelf.z/2 - holeOffset.z]) 
                    rotate([-90, 0, 0]) 
                    countersink();
                // right side holes
                translate([shelf.x/2 - holeOffset.x, -shelfCut.y/2, shelf.z/2 - holeOffset.z]) 
                    rotate([90, 0, 0]) 
                    hex_hole();
            }
        }
    }
    
    module add2() {
        retainer = [slotTaperLength/3, 1.5, 8]; // size of drawer retaining stop
        bottom_retainer = [4, retainer.y, retainer.y]; // stop of bottom drawer retainer
        
        // back corners for wall mounting
        reflect(Y) reflect(Z)
            translate([-shelf.x/2 + backThickness, -shelf.y/2, -shelf.z/2]) 
            back();
        
        // material for the slot in the rear. We'll carve it up later.
        if (rear_lock=="yes") rear_slot();
        
        // fill in the back of the middle slot in case we need to
        // add the rear latch. If we don't we need to print with supports there.
        // "10" is the space between the drawer and the back of the shelf.
        translate([-shelf.x/2 + wallThickness/2 + 10, 0, shelf.z/2 - wallThickness/2])
            cube(wallThickness, center=true);
        }

    module subtract2() {
 
        module clip_cut(short=false) {
            // creates a negative of the cut to be subracted
            // if short, don't make additional space to install the clip
            module add() {
               if (short) {
                    translate([clipCut.x/4, 0, 0]) cube([clipCut.x/2, clipCut.y+epsilon*2, clipCut.z], center=true);
                } else {
                    cube([clipCut.x, clipCut.y+epsilon*2, clipCut.z], center=true);
                }
            }
            module subtract() {
                translate([clipCut.x/2 - clipCut.y/2, 0, 0]) 
                    rotate([0, 0, 0]) 
                    cylinder(d=clip_bar_diameter, h=clipCut.x+epsilon*2, center=true);
            }
            difference() {
                add();
                subtract();
            }
        }       
        

       if (rear_lock == "yes") {
            barStockTolerance = 0.05; // 5%
            // cut the slot and grooves for the bar
            translate([-shelf.x/2 - barSize.x*barStockTolerance/2, 0, -shelfCut.z/2]) 
                scale([1+barStockTolerance, 1+barStockTolerance, 1]) 
                bar_stock(shelf.z);
            // cut a hole for the tabs
            // 10 is shelf.x - drawer.x
            tabHoleSize = [10 - barSize.x, barSize.y*(1+barStockTolerance), wallThickness + epsilon*2];       
            translate([-shelf.x/2 + barSize.x + tabHoleSize.x/2, 0, shelf.z/2 - tabHoleSize.z/2 + epsilon]) 
                cube(tabHoleSize, center=true);       
        }

        // side clip cuts
        if (clips == "yes") {
            reflect(Y) 
            {
               // front side clips
               for(k=[0:U-1]) {
                   translate([(shelf.x-clipCut.x)/2+epsilon, (shelf.y-clipCut.y+epsilon)/2, -shelfCut.z/2 + slotBottomWidth + slotSpacing/2 + slotSpacing*k]) 
                   clip_cut(short=true);
                   // back side clips
                   translate([-(shelf.x-clipCut.x)/2-epsilon, (shelf.y-clipCut.y+epsilon)/2, -shelfCut.z/2 + slotBottomWidth + slotSpacing/2 + slotSpacing*k]) 
                    rotate([0, 0, 180]) clip_cut();
               }
               // top and bottom front clip cutouts
               reflect(Z) { 
                   // front
                   translate([shelf.x/2 - clipCut.x/2+epsilon, shelf.y/2-holeOffset.y, (shelf.z-clipCut.y)/2]) 
                    rotate([90, 0, 0]) 
                    clip_cut(short=true);
                   // back
                   translate([-shelf.x/2 + clipCut.x/2-epsilon, shelf.y/2-holeOffset.y, (shelf.z-clipCut.y)/2]) 
                    rotate([90, 0, 180]) 
                    clip_cut();
               }
           }
        }
    }
    difference() {
        union() {
            difference() {
                add();
                subtract();
            }
            add2();
        }
        subtract2();
    }
}


// create the bar that locks the drawers
module rear_lock() {
    tabSupportDepth = 2;
    knobHeight = 10.5;
    knobInnerDiameter = barSize.x/2;
    knobOuterDiameter = knobInnerDiameter + .4;
    
    module bar_segment() {
        // decided to face it down instead of up, there here's turning it upside down
        translate([0, 0, tabSize.z + tabSize.x + tolerance])
            mirror([0, 0, 1]) {
             // joint between tab and bar
             tabJointSize = [tabSupportDepth + tabSize.x, tabSize.y, tabSize.x];
             tabJointPosition = [barSize.x + tabSupportDepth/2 + tabSize.x/2, 0, tabSize.x/2];
             translate(tabJointPosition) 
                cube(tabJointSize, center=true);
            // tab, made from a set of points
            // TO-DO: chamfer the top in the x-axis
            tabPosition = [barSize.x + tabJointSize.x -tabSize.x, -tabSize.y/2, tabSize.x];
            chamfer = 4;
            translate(tabPosition) 
                rotate([90, 0, 90]) 
                linear_extrude(tabSize.x) {
                    translate([0, 0]) polygon([[0, 0], [0, tabSize.z - chamfer], 
                    [chamfer, tabSize.z], [tabSize.y - chamfer, tabSize.z],
                    [tabSize.y, tabSize.z - chamfer], [tabSize.y, 0]
                    ]);
                }
            }
    }
    
    // make a snap arm for the lock
    module snap() {
        linear_extrude(barSize.x - tabSize.x -tolerance*2) {
            union() {
                difference() {
                    // outer profile
                    resize([slotSpacing, tabSize.y/2 - snapHead/4])
                        circle(d=slotSpacing);
                    // inner profile
                    translate([0, tabSize.y*.7/24]) 
                        resize([slotSpacing*0.7, tabSize.y*0.7/2 - snapHead/4])
                        circle(d=slotSpacing);
                    translate([0, -slotSpacing/2]) square(slotSpacing);
                }
                // detent
                translate([-snapHead/2, barSize.y/4 - snapHead*3/8]) difference() {
                    circle(d=snapHead);
                    translate([0, -snapHead/2]) square(snapHead, center=true);
                }
            }
        }
    }

    module add() {
        // add the tabs
        for (k=[1:U_High]) {
            translate([0, 0, (k-1)*slotSpacing])
            bar_segment();
        }
        // bar
        translate([0, 0, 0]) 
            bar_stock(shelfCut.z - slotSpacing + wallThickness);

        // add support for the top tab
        translate([barSize.x - tabSize.x, -tabSize.y/2, shelfCut.z - slotSpacing])
            cube([tabSize.x, tabSize.y, tabSize.z + tabSize.x ]);

        // add the snaps
        reflect(Y) 
            rotate([0, 90, 0])
            translate([-shelfCut.z/2 - slotSpacing*(U_High - 2)/2 - wallThickness, 
                    tabSize.y/4 - snapHead/8, 
                    0])
            snap();
    }
    
    module subtract() {
        // create a finger hole
        holeFraction = 0.5; // how much space to give to the hole
        translate([barSize.x/2-epsilon, 0, shelfCut.z - slotSpacing - barSize.y/2*(1-holeFraction)])
            cube([barSize.x + epsilon*4, barSize.y*holeFraction, barSize.y*holeFraction], center=true);
        
        // make some room for the snap to move
        reflect(Y)
            translate([barSize.x/2 - epsilon, -barSize.y/2 - epsilon, shelfCut.z - slotSpacing + wallThickness + epsilon ]) 
            rotate([0, 90, 0]) linear_extrude(barSize.x+epsilon*4, center=true) 
            polygon([[0, 0], [0, snapHead], [snapHead, 0]]);
            
    }
    
    difference() {
        add();
        subtract();
    }
} 

/* UTILITY FUNCTIONS */

/*
https://www.thingiverse.com/thing:2479342/files
Customizable Clip for storage box
by jrd3n Aug 30, 2017j
*/
module clip(ZExtrude, topdia, bottomDiam, spacebetween, Thickness) {

    linear_extrude(ZExtrude) {

    Clip(topdia,bottomDiam,spacebetween,Thickness);

    }
    module Clip(topdia,bottomDiam,spacebetween,Thickness) {
        
        union(){
            click(topdia , Thickness);
            
            click(bottomDiam , Thickness, [0,-spacebetween],-90, false);
        
       
            Line([(topdia+Thickness)/2,0],[(bottomDiam+Thickness)/2,-spacebetween],Thickness);
            Line([(bottomDiam+Thickness)/2,-spacebetween],[(bottomDiam+Thickness)/2, -spacebetween-bottomDiam],Thickness);

        }
    }
    module click(size,thickness, XY = [0,0],Angle = 0, full = true) {
        
        YMovement = -size*0.7;
        CentrePoint = [0,YMovement/2];
        OuterDiameter = size+(thickness*2);
        ConstantDistance = (size+thickness)/2;
        
        
        translate (XY) {
            rotate ([0,0,Angle]) {
                
                difference() {

                    union() {
                        // point ();
                        
                        circle(d = OuterDiameter, $fn=50);
                        
                        translate(CentrePoint) {
                            square([OuterDiameter,-YMovement], center = true);
                        }
                    
                        point ([ConstantDistance,YMovement], thickness);
                        point ([-ConstantDistance,YMovement], thickness);					
                    
                    }
                                
                    union() {
                        // point ();
                        
                        circle(d = size, $fn=50);
                        
                        translate([0,YMovement]) {
                            circle(d = size, $fn=50);
                        }	
                        
                        if (full!=true){
                            
                            translate([-ConstantDistance,YMovement/2]) {
                                square([ConstantDistance*2,ConstantDistance*4], center = true);
                            }
                                                
                        }
                                        
                    }	
                }
            }
        }
    }		
    module Line( XY1 , XY2 , Thickness ) {
        
        Ad = XY1 [0] - XY2[0];
        Op = XY1 [1] - XY2[1];
        Hyp = sqrt(pow(Op,2) + pow(Ad,2) );
        Angle = atan(Op/Ad);
        
        translate (Mid (XY1,XY2)){
            rotate([0,0,Angle]){
                square ([Hyp,Thickness], center = true);
            }		
        }
        
        point(XY1,Thickness);
        point(XY2,Thickness);
    }

    function Mid (XYstart,XYfin) = (XYstart + XYfin) / 2;
    module point (XY = [0,0] , Size = 1) {

        translate(XY) {
        
        circle(d = Size, $fn=50);
        
        }
    }
}


/* render both the child object and its mirror 
    usage: otherwise operates just like mirror()
*/
module reflect(v) {
    children();
    mirror(v) children();
}

// create a hollow cylinder, or tube
module tube(od, id, h=1, center=false) {
    epsilon = 0.01;
    difference() {
        cylinder(d=od, h=h, center=center);
        translate([0, 0, -epsilon]) 
            cylinder(d=id, h=h+epsilon*2, center=center);
    }
}
        
/* MAIN  */

//color("yellow", .5) 
//back();
//half_side_slot();
//countersink();
//fhex_hole();
//rotate([0, 0, 180]) translate([-435 , 198, -12.5+shelf.z]) color("orange", .3) import("Shelf_2U.stl");
//clip_cut();
//module clip(ZExtrude, topdia, bottomDiam, spacebetween, Thickness) {
if (part == "shelf") {
    if (orientation == "viewing") {
        %if (rear_lock == "yes") translate([-shelf.x/2, 0, -shelfCut.z/2]) rear_lock();
        shelf();
    } else {
        rotate([0, -90, 0]) shelf();
    }
} else if (part == "clip") {
    if (orientation == "viewing") {
        %shelf();
        // front side clips
        reflect(X) {
            for(k=[0:U-1]) {
                // right side
                translate([(shelf.x-clipCut.x/2)/2, 
                    (shelf.y-clipCut.y)/2, 
                    -shelfCut.z/2 + slotBottomWidth + slotSpacing/2 + slotSpacing*k + clipCut.z/2 - tolerance]) 
                    rotate([180, 0, 0]) 
                    clip(clipCut.z - tolerance*2, clip_bar_diameter+tolerance, clip_bar_diameter+tolerance, clipCut.y, clipThickness);
                // top clip cutouts
                reflect(Y) { 
                    // front
                    translate([shelf.x/2 - clipCut.x/4, 
                        shelf.y/2 - holeOffset.y - clipCut.z/2 + tolerance, 
                        (shelf.z-clipCut.y)/2]) 
                        rotate([-90, 0, 0]) 
                        clip(clipCut.z - tolerance*2, clip_bar_diameter+tolerance, clip_bar_diameter+tolerance, clipCut.y, clipThickness);
                }
            }
        }
    } else {
        clip(clipCut.x - tolerance*2, clip_bar_diameter+tolerance, clip_bar_diameter+tolerance, clipCut.y, clipThickness);
    }
} else if (part == "rear_lock") {
    if (orientation == "viewing") {
        %shelf();
        translate([-shelf.x/2, 0, -shelfCut.z/2]) rear_lock();
    } else {
        rotate([90, 0, 0]) rear_lock();
    }
}

/* rotate_extrude2 contributed by thehans 
 * http://forum.openscad.org/rotate-extrude-angle-always-360-td19035.html
 */
module rotate_extrude2(angle=360, convexity=2, size=1000) {


    module angle_cut(angle=90,size=1000) {
        x = size*cos(angle/2);
        y = size*sin(angle/2);
       translate([0,0,-size])
            linear_extrude(2*size) polygon([[0,0],[x,y],[x,size],[-size,size],[-size,-size],[x,-size],[x,-y]]);
    }

    // support for angle parameter in rotate_extrude was added after release 2015.03
    // Thingiverse customizer is still on 2015.03
//    angleSupport = (version_num() > 20150399) ? true : false; // Next openscad releases after 2015.03.xx will have support angle parameter
    // Using angle parameter when possible provides huge speed boost, avoids a difference operation

//    if (angleSupport) {
//        rotate_extrude(angle=angle,convexity=convexity)
//            children();
//    } else {
        rotate([0,0,angle/2]) difference() {
            rotate_extrude(convexity=convexity) children();
            angle_cut(angle, size);
        }
//    }
}

