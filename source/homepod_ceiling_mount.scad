/*
 Parametric Apple HomePod mini ceiling mount prototype
 Units: mm. Ceiling datum: Z=0; hanging structure extends into negative Z.

 PART SELECTOR:
   "assembled", "ceiling_plate", "upper_ring", "lower_ring",
   "arm", "cable_clip", "locking_pin", "layout"

 Prototype only. Dimensions and fit must be checked against the actual speaker,
 cord/connector and intended ceiling substrate before use. Not load-rated.
*/
$fn = 96;
part = "assembled";
is_locked = true;

// Main dimensions
speaker_d = 97.9;
fit_clearance = 2.0;
print_clearance = 0.25;
plate_d = 86;
plate_t = 6;
plate_centre_hole = 26;
track_pcd = 52;
lock_travel_angle = 25;
keyhole_large_d = 9.5;
keyhole_small_d = 4.6;
upper_ring_id = 64;
upper_ring_od = 84;
ring_thickness = 8;
lower_ring_id = speaker_d + fit_clearance;
lower_ring_od = lower_ring_id + 13;
arm_count = 3;
arm_width = 14;
arm_depth = 6.5;
arm_height = 112;
arm_curve = 13;
tab_l = 6;
pin_diameter = 3;
pin_length = arm_width + 4;
pin_radial_top = (upper_ring_id + upper_ring_od)/4;
pin_radial_bottom = (lower_ring_id + lower_ring_od)/4;
cable_d = 5.5;
clip_wall = 2.4;
clip_outer_d = cable_d + 2*clip_wall;
clip_gap = 4.2;

module annulus(od,id,h) {
  difference() {
    cylinder(d=od,h=h);
    translate([0,0,-0.1]) cylinder(d=id,h=h+0.2);
  }
}

// Plate slots use a large entry hole followed by a swept narrow channel.
module keyhole_slot(angle=0) {
  rotate([0,0,angle]) {
    translate([track_pcd/2,0,-0.1]) cylinder(d=keyhole_large_d,h=plate_t+0.2);
    hull() {
      translate([track_pcd/2,0,-0.1]) cylinder(d=keyhole_small_d,h=plate_t+0.2);
      rotate([0,0,-lock_travel_angle])
        translate([track_pcd/2,0,-0.1]) cylinder(d=keyhole_small_d,h=plate_t+0.2);
    }
  }
}

module ceiling_plate() {
  difference() {
    cylinder(d=plate_d,h=plate_t);
    translate([0,0,-0.1]) cylinder(d=plate_centre_hole,h=plate_t+0.2);
    for (a=[0:120:240]) keyhole_slot(a);
  }
}

// Upper ring main body is Z=-ring_thickness..0; bayonet lugs occupy Z=0..plate_t+0.5.
module upper_ring() {
  lug_h = plate_t + 0.5;
  difference() {
    union() {
      translate([0,0,-ring_thickness]) annulus(upper_ring_od,upper_ring_id,ring_thickness);
      // Three shallow radial bridges sit below the plate and connect the inner
      // ring wall to each bayonet lug. This is necessary because the track radius
      // (26 mm) is inside the ring's 32 mm inner radius.
      for (a=[0:120:240]) {
        rotate([0,0,a-lock_travel_angle+2])
          translate([track_pcd/2-2.2, -2.2, -4]) cube([upper_ring_id/2-(track_pcd/2-2.2)+0.2, 4.4, 2.5]);
        // Constant-section arc, extended slightly below Z=0 to join the bridge.
        rotate([0,0,a])
          rotate_extrude(angle=-lock_travel_angle+2)
            translate([track_pcd/2-2.2,-2]) square([4.4,lug_h+2]);
      }
    }
    // Tab pockets and cross-pin bores, centred at Z=-ring_thickness/2.
    for (a=[0:120:240]) rotate([0,0,a]) {
      translate([pin_radial_top-tab_l/2-1,
                 -(arm_width+print_clearance)/2,-ring_thickness-0.1])
        cube([tab_l+2,arm_width+print_clearance,ring_thickness+0.2]);
      translate([pin_radial_top,-pin_length/2,-ring_thickness/2])
        rotate([-90,0,0]) cylinder(d=pin_diameter+print_clearance,h=pin_length);
    }
  }
}

module lower_ring() {
  difference() {
    translate([0,0,-arm_height]) union() {
      annulus(lower_ring_od,lower_ring_id,ring_thickness);
      // Raised inner support lip; its inner face slopes outward toward the top.
      translate([0,0,ring_thickness]) difference() {
        cylinder(d=lower_ring_id+0.1,h=4);
        translate([0,0,-0.1])
          cylinder(r1=(lower_ring_id-8)/2,r2=lower_ring_id/2,h=4.2);
      }
    }
    for (a=[0:120:240]) rotate([0,0,a]) {
      translate([pin_radial_bottom-tab_l/2-1,
                 -(arm_width+print_clearance)/2,-arm_height-0.1])
        cube([tab_l+2,arm_width+print_clearance,ring_thickness+0.2]);
      translate([pin_radial_bottom,-pin_length/2,-arm_height+ring_thickness/2])
        rotate([-90,0,0]) cylinder(d=pin_diameter+print_clearance,h=pin_length);
    }
  }
}

module support_arm() {
  union() {
    // Spine segments blend between the upper and lower joint centres.
    for (i=[0:11]) {
      z1=-ring_thickness-(arm_height-2*ring_thickness)*i/12;
      z2=-ring_thickness-(arm_height-2*ring_thickness)*(i+1)/12;
      r1=pin_radial_top+(pin_radial_bottom-pin_radial_top)*i/12+arm_curve*sin(180*i/12);
      r2=pin_radial_top+(pin_radial_bottom-pin_radial_top)*(i+1)/12+arm_curve*sin(180*(i+1)/12);
      hull() {
        translate([r1,0,z1]) cube([arm_depth,arm_width,0.2],center=true);
        translate([r2,0,z2]) cube([arm_depth,arm_width,0.2],center=true);
      }
    }
    // Upper tab: Z=-8..0.
    translate([pin_radial_top-tab_l/2,-(arm_width-print_clearance)/2,-ring_thickness])
      difference() {
        cube([tab_l,arm_width-print_clearance,ring_thickness]);
        translate([tab_l/2,(arm_width-print_clearance)/2-pin_length/2,ring_thickness/2])
          rotate([-90,0,0]) cylinder(d=pin_diameter,h=pin_length);
      }
    // Upper triangular web, extruded across arm width.
    translate([pin_radial_top+tab_l/2-0.05,-arm_width/2,-ring_thickness])
      rotate([90,0,90]) linear_extrude(height=arm_width)
        polygon(points=[[0,0],[0,6],[5,0]]);
    // Lower tab: Z=-112..-104.
    translate([pin_radial_bottom-tab_l/2,-(arm_width-print_clearance)/2,-arm_height])
      difference() {
        cube([tab_l,arm_width-print_clearance,ring_thickness]);
        translate([tab_l/2,(arm_width-print_clearance)/2-pin_length/2,ring_thickness/2])
          rotate([-90,0,0]) cylinder(d=pin_diameter,h=pin_length);
      }
    translate([pin_radial_bottom-tab_l/2+0.05,-arm_width/2,-arm_height+ring_thickness])
      rotate([90,0,-90]) linear_extrude(height=arm_width)
        polygon(points=[[0,0],[0,6],[5,0]]);
  }
}

module cable_clip() {
  difference() {
    union() {
      cylinder(d=clip_outer_d,h=clip_wall);
      translate([clip_outer_d/2,0,clip_wall/2]) cube([4,6,clip_wall],center=true);
    }
    translate([0,0,-0.1]) cylinder(d=cable_d+0.2,h=clip_wall+0.2);
    translate([clip_outer_d/2,0,-0.2]) cube([clip_gap,clip_outer_d*0.6,clip_wall+0.4],center=true);
  }
}

// Pin axis is +Y, centred on the joint. Flange is at the negative-Y end.
module locking_pin() {
  rotate([-90,0,0]) translate([0,0,-pin_length/2]) union() {
    cylinder(d=pin_diameter-0.15,h=pin_length-2);
    cylinder(d=pin_diameter+2.5,h=2);
  }
}

module layout_preview() {
  translate([-100,0,0]) ceiling_plate();
  translate([0,0,0]) upper_ring();
  translate([110,0,0]) lower_ring();
  translate([-50,90,0]) support_arm();
  translate([-10,90,0]) rotate([0,0,120]) support_arm();
  translate([30,90,0]) rotate([0,0,240]) support_arm();
  translate([55,-60,0]) cable_clip();
  translate([70,-60,0]) cable_clip();
  translate([85,-60,0]) cable_clip();
  translate([55,-80,0]) locking_pin();
  translate([70,-80,0]) locking_pin();
  translate([85,-80,0]) locking_pin();
}

module assembled_preview() {
  ceiling_plate();
  rotation_offset=is_locked ? -lock_travel_angle : 0;
  rotate([0,0,rotation_offset]) upper_ring();
  for (a=[0:120:240]) rotate([0,0,a]) support_arm();
  lower_ring();
  for (a=[0:120:240]) rotate([0,0,a]) {
    translate([pin_radial_top,0,-ring_thickness/2]) locking_pin();
    translate([pin_radial_bottom,0,-arm_height+ring_thickness/2]) locking_pin();
  }
}

if (part=="ceiling_plate") ceiling_plate();
else if (part=="upper_ring") upper_ring();
else if (part=="lower_ring") lower_ring();
else if (part=="arm") support_arm();
else if (part=="cable_clip") cable_clip();
else if (part=="locking_pin") locking_pin();
else if (part=="assembled") assembled_preview();
else if (part=="layout") layout_preview();
