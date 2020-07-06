// Customizable Ultimate Drawer System Drawer
// Remixed from MarcElbichon's Ultimate Drawer System https://www.thingiverse.com/thing:2302575 (CC-BY 4.0)
// Copyright (C) 2019 by Brian Alano (and possibly others)
// Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 (CC-BY-NC-SA 4.0)

/* Release Notes 
 * Version 1.1
 * Made label slots optional, and removed them entirely for 0.5U wide drawers.
 * Added 0.5U wide and 0.5U deep options
 */
 
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

/* [Size] */
// units wide (actual drawer width is 131*U_wide - 10)
U_wide=1; // [0.5, 1, 1.5, 2]
// units deep (actual drawer depth is 130*U_deep - 10)
U_deep=1; // [0.5, 1, 1.5]
// units high (actual drawer height is 20*U_high - 1)
U_high=3; // [1:15]

/* [Features] */
// Include slots for labels? 
labels = "yes"; //[yes, no]
// What kind of drawer pull?
pull_style = "original"; // [original, ergonomic, ring]
// the flange is what keeps the drawer in the slot. "catch" leaves a bump for holding the drawer in the a shelf with snaps. 
flange_style = "normal"; // [normal, catch, none]
// include slots on the back of the drawer for the locking mechanism
rear_lock_slot = "no"; // [yes, no]

/* [Hidden] */
// utility variables
epsilon = 0.01;
$fs=1;
$fa=5;

drawerUnit=[120, 120, 19];
shelfPadding=[11, 10, 1];

wallThickness = 1;
shelfUnit = [131, 130, 30];
shelf = [shelfUnit.x * U_wide, shelfUnit.y * U_deep, (shelfUnit.z - wallThickness*2) * U_high - wallThickness*2]; // reference dimension from shelf .scad file.
echo("shelf dimensions", shelf);
drawer = [shelf.x - shelfPadding.x, shelf.y - shelfPadding.y, shelf.z - shelfPadding.z];
echo("drawer dimensions", drawer);

cornerR = 4;
cornerD = cornerR * 2;
flange = [flange_style == "catch" 
    ? 3*0.6 
    : flange_style == "none" 
        ? 0
        : 3, d_to_y(U_deep)-shelfPadding.y, 1];
flangeR = flange.x - epsilon;
flangeD = flangeR * 2;
catchFlange = 10;
pullD = 24.38;
pull = [2, pullD/2 + 2.8, 16];
label = [51, 2, 16];
labelSlot = [49, 1, 15];
labelWindow = [46, 1, 14];
catch = [3, 4, flange.z];
rearLockSlot = [26, 3.5, 8];
includeLabels = labels == "yes" && U_wide > 0.5;

// the spacing between drawings is 20, or drawerUnit.z + 1. so a 1U drawer is 19, a 2U drawer is 39, etc.
//FIXME replace with drawer[]
//FIXME put lock on bottom, not top.
function u_to_z(u) = (drawerUnit.z + shelfPadding.z) * u - shelfPadding.z;
function w_to_x(w) = (drawerUnit.x + shelfPadding.x) * w - shelfPadding.x;
function d_to_y(d) = (drawerUnit.y + shelfPadding.y) * d - shelfPadding.y;

module drawer(U_wide = U_wide, U_deep = U_deep, U_high = U_high, includeLabels = includeLabels) {
    module add() {
        // main body
        linear_extrude(u_to_z(U_high))
            roundtangle(width=w_to_x(U_wide), length=d_to_y(U_deep), radius=cornerR);
        // flanges
        reflect([1, 0, 0]) {
            linear_extrude(flange.z) 
            translate([w_to_x(U_wide)/2, -(d_to_y(U_deep) - flange.y)/2]) {
                roundtangle(flange.x*2, flange.y, flangeR);
            }
            translate([w_to_x(U_wide)/2, -(d_to_y(U_deep) - catch.y)/2, 0]) {
                linear_extrude(flange.z) roundtangle(catch.x*2, catch.y, flangeR);
            }
        }

        // pull
        translate([0, d_to_y(U_deep)/2, pull.z/2]) pull(style=pull_style);

        // label holders (positive part)
        if (includeLabels) labels("add");

        // rear lock pockets
        if (rear_lock_slot == "yes")
            for(j = [1:U_high])
                translate([0, -d_to_y(U_deep)/2, u_to_z(j)]) 
                    rearLockSlot();
    }
    
    module subtract() {
        // main cut, minus fillets
        cut = [w_to_x(U_wide) - wallThickness*2, d_to_y(U_deep) - wallThickness*2, u_to_z(U_high) - wallThickness - cornerR];
        translate([0, 0, u_to_z(U_high) - cut.z + epsilon]) 
            linear_extrude(cut.z + epsilon) roundtangle(cut.x, cut.y, cornerR);
        // fillet cut
       translate([0, 0, u_to_z(U_high) - cut.z]) 
            minkowski() {
                cube([cut.x - cornerD, cut.y - cornerD, epsilon], center=true);
                sphere(d=cornerD);
            }
        // label holders (positive part)
        if (includeLabels) labels("subtract");

    }
     
    difference() {
        add();  
        subtract();
    }
}

module labels(mode="add") {
    module add() {
        for (i = [1, -1]) {
            translate([w_to_x(U_wide)/4*i, (d_to_y(U_deep) + label.y)/2 - epsilon, label.z/2]) cube([label.x, label.y + epsilon, label.z], center=true);
        }
    }
    
    module subtract() {
        for (i=[1, -1]) {
            // label cuts
            translate([w_to_x(U_wide)/4*i, d_to_y(U_deep)/2 + labelSlot.y/2, labelSlot.z/2 + (label.z - labelSlot.z) + epsilon])
                cube(labelSlot, center=true);
            translate([w_to_x(U_wide)/4*i, d_to_y(U_deep)/2 + label.y - wallThickness/2, labelWindow.z/2 + (label.z - labelWindow.z) + epsilon])
                cube(labelWindow, center=true);
        }
    }
    
    if (mode=="add") add(); else subtract();
}


module pull(style) {
    // drawer pull
    module original() {
        intersection() {
           translate([0, pull.y/2 - epsilon]) cube([pull.x, pull.y + epsilon, pull.z], center = true);
           translate([0, pull.y - pullD/2]) rotate([0, 90, 0]) cylinder(d=pullD, h=pull.x, center = true);
        }
    }

    module ergonomic() {
        difference() {
            original();
            translate([0, pull.y - pullD/2]) rotate([0, 90, 0]) {
                intersection() {
                    cylinder(d=pullD/2, h=pull.x+epsilon*4, center = true);
                    translate([0, pullD/3]) cylinder(d=pullD/2, h=pull.x+epsilon*4, center = true);
                }
            }
        }
        scale([3, 1, 1]) difference() {
            original();
            translate([0, pull.y - pullD/2]) rotate([0, 90, 0]) cylinder(d=pullD-pull.x*2, h=pull.x+epsilon*2, center = true);
        }
    }

    if (style == "original") original();
    if (style == "ergonomic") ergonomic();
}

module rearLockSlot() {    
    module half() {
        translate([rearLockSlot.x/2, -rearLockSlot.y, -drawerUnit.z + rearLockSlot.z/2]) 
        {
            cube([wallThickness, rearLockSlot.y, rearLockSlot.z/2]);
            rotate([0, 90, 0])
                linear_extrude(wallThickness) 
                polygon([[0, 0], [rearLockSlot.y, rearLockSlot.y], [0, rearLockSlot.y]]);
        }
        translate([0, -rearLockSlot.y, -drawerUnit.z + rearLockSlot.z/2]) 
            cube([rearLockSlot.x/2, wallThickness, rearLockSlot.z/2]);
    }
    
    module add() {
        for(i=[0, 1]) 
            mirror([i, 0, 0]) half();
    }
    add();
//    half();
}


/* render both the child object and its mirror 
    usage: otherwise operates just like mirror()
*/
module reflect(v) {
    children();
    mirror(v) children();
}


module roundtangle(width, length, radius) {
    minkowski() {
                square([width - radius*2, length - radius*2], center=true);
                circle(r=radius);
            }
}

drawer();
//pull(style="ergonomic");
//rear_lock();