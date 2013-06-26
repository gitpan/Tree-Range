### 20-rb-cmp.t --- Test cmp-based Tree::Range::RB  -*- Perl -*-

use strict;
use warnings;

use Test::More qw (tests 22);

require_ok ("Tree::Range::RB");

sub cmp {
    ## .
    $_[0] cmp $_[1];
}

my ($cmp, $leftmost)
    = (\&cmp, [ "*leftmost*" ]);
my $rat_options = {
    "cmp"       => $cmp,
    "leftmost"  => $leftmost
};
my $rat
    = new_ok ("Tree::Range::RB", [ $rat_options ],
              "Tree::RB-based range tree");

isa_ok ($rat->backend (), "Tree::RB",
        "associated backend tree object");
is ($rat->cmp_fn, $cmp,
    "associated comparison function");
is ($rat->leftmost_value, $leftmost,
    "associated leftmost value");

is_deeply ([ $rat->get_range ("cherry") ],
           [ $leftmost ],
           "unbounded range retrieved from the still empty range tree");

foreach my $r ("apple, strawberry, 1",
               "banana, cherry, 2",
               "appricot, blackcurrant, 3") {
    my ($l, $u, $v)
        = split (/, */, $r, 3);
    my $prev
        = $rat->get_range ($u);
    $rat->range_set ($l, $u, $v);
    my ($lv, $uv)
        = (scalar ($rat->get_range ($l)),
           scalar ($rat->get_range ($u)));
    is ($lv, $v,
        ("new value retrieved"
         . " after range_set (" . $r . ")"))
        or diag ("tried to set ", $l, " .. ", $u, " to ", $v,
                 " but retrieved ", $lv, " at ", $l, " instead");
    is ($uv, $prev,
        ("old value retrieved from the adjacent range"
         . " after range_set (" . $r . ")"));
}

my @tree_keys;
## NB: accessing Tree::RB->iter () directly
my $iter
    = $rat->backend ()->iter ();
while (my $node = $iter->next ()) {
    push (@tree_keys, $node->key ());
}
## NB: banana is removed in the process
is_deeply (\@tree_keys,
           [ qw (apple appricot blackcurrant),
             qw (cherry strawberry) ],
           "tree has all the expected keys")
    or diag ("the tree keys are: ",
             join (", ", @tree_keys));

my $ranges = {
    "almond"    => [ $leftmost, undef,  "apple" ],
    "apple"         => [ qw (1  apple    appricot) ],
    "appricot"      => [ qw (3  appricot blackcurrant) ],
    "banana"        => [ qw (3  appricot blackcurrant) ],
    "blackcurrant"  => [ qw (2  blackcurrant cherry) ],
    "blueberry"     => [ qw (2  blackcurrant cherry) ],
    "cherry"        => [ qw (1  cherry   strawberry) ],
    "mango"         => [ qw (1  cherry   strawberry) ],
    "strawberry"  => [ $leftmost, "strawberry" ]
};
foreach my $k (sort { $a cmp $b } (keys (%$ranges))) {
    my @got
        = $rat->get_range ($k);
    is_deeply (\@got,
               $ranges->{$k},
               ("the value and the range for the " . $k . " key"))
        or diag ("got: ", join (", ", @got),
                 " vs. expected: ", join (", ", @{$ranges->{$k}}));
}

## Local variables:
## indent-tabs-mode: nil
## End:
### 20-rb-cmp.t ends here
