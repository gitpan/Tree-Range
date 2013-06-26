### base.pm --- Tree::Range::base: base class for the range trees  -*- Perl -*-

### Copyright (C) 2013 Ivan Shmakov

## Permission to copy this software, to modify it, to redistribute it,
## to distribute modified versions, and to use it for any purpose is
## granted, subject to the following restrictions and understandings.

## 1.  Any copy made of this software must include this copyright notice
## in full.

## 2.  I have made no warranty or representation that the operation of
## this software will be error-free, and I am under no obligation to
## provide any services, by way of maintenance, update, or otherwise.

## 3.  In conjunction with products arising from the use of this
## material, there shall be no use of my name in any advertising,
## promotional, or sales literature without prior written consent in
## each case.

### Code:

package Tree::Range::base;

use strict;

use vars qw ($VERSION);

$VERSION = "0.1";

require Carp;

use Scalar::Util qw (refaddr);

sub safe_eq {
    ## return true if either both are undef, or the same ref
    my ($a, $b) = @_;
    ## .
    return (defined ($a)
            ?  (ref ($a) && ref ($b)
                && refaddr ($a) == refaddr ($b))
            : ! defined ($b));
}

sub del_range {
    my ($obj, $left, $cmp, $high) = @_;
    my ($last_ref, @delk);
    for (my $e = $left;
         (defined ($e) && &$cmp ($e->key (), $high) <= 0);
         $e = $e->successor ()) {
        # print STDERR ("-g: ", scalar (Data::Dump::dump ({ $e->key () => $e->val () })), "\n");
        $last_ref
            = [ $e->key, $e->val () ];
        last
            if (&$cmp ($e->key (), $high) >= 0);
        ## FIXME: shouldn't there be a better way?
        push (@delk, $e->key ());
    }
    # print STDERR ("-g: ", scalar (Data::Dump::dump (\@delk)), "\n");
    foreach my $k (@delk) {
        $obj->delete ($k)
            or Carp::croak ($k, ": failed to delete key");
    }
    ## .
    return $last_ref;
}

sub get_range {
    my ($self, $key) = @_;
    my $left
        = $self->lookup_leq ($key);
    my $v
        = (defined ($left)
           ? $left->val ()
           : $self->leftmost_value ());
    ## .
    return $v
        unless (wantarray ());
    unless (defined ($left)) {
        my $right
            = $self->lookup_geq ($key);
        ## .
        return (defined ($right)
                ? ($v, undef, $right->key ())
                : ($v));
    }
    my ($l_k, $right)
        = ($left->key (), $left->successor ());
    ## .
    return (defined ($right)
            ? ($v, $l_k, $right->key ())
            : ($v, $l_k));
}

sub range_set {
    my ($self, $low, $high, $value) = @_;
    my $cmp
        = $self->cmp_fn ();
    Carp::croak ("Upper bound (", $high,
                 ") must be greater than the lower (", $low,
                 ") one")
        unless (&$cmp ($high, $low) > 0);

    ##  |      min      |       |       |      max      |
    ## .. Left  a   A   b   B   c   C   d   D   e   E   ..

    my $left
        = $self->lookup_geq ($low);
    if (! defined ($left)) {
        ## $low, and thus $high, are higher than max
        # print STDERR ("-g: ", scalar (Data::Dump::dump ({ $low => $value, $high => $self->leftmost_value () })), "\n");
        $self->put ($low,   $value);
        $self->put ($high,  $self->leftmost_value ());
    } else {
        ## preserve the value, if any
        my $pre
            = $left->predecessor ();
        my $pre_v
            = (defined ($pre)
               ? $pre->val ()
               : $self->leftmost_value ());
        ## remove everything up to the boundary at $high
        my $last_ref
            = del_range ($self, $left, $cmp, $high);
        my $last
            = (defined ($last_ref)
               ? $last_ref->[1]
               : $pre_v);
        ## there either already is a boundary at $low,
        ## or we add it now
        my $eq_u
            = $self->value_equal_p_fn ();
        my $eq_l
            = (safe_eq ($value, $pre_v) || $eq_u->($value, $pre_v));
        my $eq_h
            = (safe_eq ($value, $last)  || $eq_u->($value, $last));
        # print STDERR ("-g: ", scalar (Data::Dump::dump ({ (! $eq_l ? ($low => $value) : ()), (! $eq_h ? ($high => $last) : ()) })), "\n");
        if (! $eq_l) {
            $self->put ($low,   $value);
        } else {
            ## merge the segments
            $self->delete ($low);
        }
        if (! $eq_h) {
            $self->put ($high,  $last);
        } else {
            ## merge the segments
            $self->delete ($high);
        }
    }

    ## .
}

1;

### Emacs trailer
## Local variables:
## coding: us-ascii
## fill-column: 72
## indent-tabs-mode: nil
## ispell-local-dictionary: "american"
## End:
### base.pm ends here
