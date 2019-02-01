// The mold used to cast the part

use <boxwall.scad>

// The distance between parts that are supposed to fit snuggly
tight_gap=0.5;

// The bottom of the case needs to fit snuggly against the inner holder so that
// silicone doesn't seep in and also so the cast mid-point is just above the bottom of the case
module case_bottom_void ()

