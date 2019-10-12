/* insert designer 
 let's you set up inserts for a whole drawer
 */
 use <drawer.scad>;
 use <insert.scad>;
 
 U_wide = 1;
 U_deep = 1;
 U_high = 1;
 labels = "no";
 grid_size = [3,3];
 inserts = [[1,1], [2, 1]];
 /* [Hidden] */
 includeLabels = labels == "yes" ? true : false;
 drawer(U_wide = U_wide, U_deep = U_deep, U_high = U_high, includeLabels = includeLabels);
 
module main() {
    for (insert=inserts) {
        translate([drawer.x/2, 1]) insert([insert.x, insert.y, U_high/2]);
    }
}
 main();
 