# Ultimate-Drawer-System
Intended to be the ultimate drawer system that is
* backwards-compatible with MarcElbichon's Ultimate Drawer System
* printable with FDM printing
* optimizable for anything you store in drawers
* compatible with Thingiverse's Customizer
* written for ease of improvement (which could use some improvement)


## The System
* Drawers and complementary shelving units are sized in units called "Us".
* If only one dimension is given, it is assumed to be the height and the width and depth are assumed to be 1U.
* A 1U drawer is 120 mm wide by 120 mm deep by 19 mm high.
* A 2U drawer is 120 mm wide by 120 mm deep by 39 mm high.
* Actual drawer width is 131 * Us wide - 10 mm
* Actual drawer depth is 130 * Us deep - 10 mm
* Actual drawer height is 20 * Us high - 1 mm
* A 2U shelf (or cabinet) is 131 mm wide by 130 deep by 50 mm high. (You can't (currently) make a 1U shelf.)
* Walls are 5 mm (W_t). Slots are 20 mm apart. 0.5 mm gap (g) between side wall and drawer. 
  So the height of a shelf is U.z*(19+1)+W_t*2 = 20U.z+10, width is U.x*120+5*2+1, depth is U.y*120+5*2.
* A double-wide shelf (2-U.x), to stack nicely with a single wide, should be 
  120U.z+11. With 5 mm walls, 2*(120+11)=D.x+2*W_t+2*g=D.x+11 => D.x (2U drawer width) = 262 - 11 = 251.
* A one-and-a-half wide drawer is (1.5-U.x) is 131+65.5 = 196.5-11 = 185.5.

### Inserts
Trays that fit inside basic drawers. 
Inside dimensions of 1U drawer: 131-10-1-2=118 wide, 120-2 deep, 18 high, 3 mm corner radius
Inside dimensions of 1.5U wide drawer =195.5-10-1-2 = 182.5
Inside dimensions of 2 wide drawer: 262-13 = 249
Inside dimensions of 1.5U deep drawer =195-10-2 = 183
Inside dimensions of 2 deep drawer: 260-10-2 = 247
I think the least common denominator of those widths is 0.5 mm, and 1 mm for depth. 1 mm for height also, since heights are 19, 39, 59, etc.



## Contributors and Contributing
This is an OpenSCAD copy then enchancement of [The Ultimate Drawer System by MarcElbichon](https://www.thingiverse.com/thing:2302575) and others to come. Contributors are welcome.

## License
This work is originally licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 (CC-BY-NC-SA 4.0) but may be distributed under the GPLv3 in accordinance with the former's one-way GPLv3 compatibility declaration.

## Features
Compared to MarcElbichon's version
* Produces faithful replicas
* Add an ergonomic drawer pull
* Adds a drawer locking mechanism
* Adds a stops to help keep drawers from pulling all the way out (needs testing)
* Adds 1.5U and 2U widths and depths to the standard 1U width and 1U depth.
* The option to clip shelving units together instead of (or in addition to) screwing them together.

## Roadmap
Planned enhancements include (in no particular order)
* Drawers with dividers
* Handles for portable storage units
* Custom inserts for specialty storage
* Bumpers for increased ruggedness
* Sturdier versions of the drawers for increased ruggedness
* Custom label inserts
* Bosses and recesses to aid in stacking units

## Coding conventions
* Generally follow OpenSCAD conventions
* Customerizer parameters capitalized first letters with words separated by underscores.

## More information
You may find additional information, discussion, and resources at
* (Thingiverse drawer)[https://www.thingiverse.com/thing:2302575]
* (Thingiverse shelf)[https://www.thingiverse.com/thing:3796410]
* (Thingiverse MarcElbichon version)[https://www.thingiverse.com/thing:2302575]
* (Parametric drawers by _WG_)[https://www.thingiverse.com/thing:2552468]
