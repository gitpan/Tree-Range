### 10-rb.t --- Test cmp-based Tree::Range::RB  -*- Perl -*-

use strict;
use warnings;

use Test::More qw (tests 12);

require_ok ("Tree::Range::RB");

foreach my $m ("new",
               qw (get_range range_set),
               qw (backend),
               qw (cmp_fn value_equal_p_fn leftmost_value),
               qw (put lookup_leq lookup_geq delete)) {
    can_ok ("Tree::Range::RB", $m);
}

## Local variables:
## indent-tabs-mode: nil
## End:
### 10-rb.t ends here
