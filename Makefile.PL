### Makefile.PL --- Build the Tree::Range package  -*- Perl -*-

## FIXME: just don't know how portable this code is
require 5.010;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile (
    NAME => 'Tree::Range',
    VERSION_FROM => 'lib/Tree/Range/base.pm',
    # ABSTRACT_FROM => 'lib/Tree/Range/base.pm',
    ## FIXME: insists on a hyphen in the NAME section
    ABSTRACT => 'Map values belonging to non-overlapping ranges using a tree',
    AUTHOR => 'Ivan Shmakov <oneingray@gmail.com>',
    LICENSE => "bsd",
    ## FIXME: just don't know how portable this code is
    MIN_PERL_VERSION => 5.010,
    ## FIXME: Tree::RB is only useful for Tree::Range::RB
    PREREQ_PM => {
        "Carp"      => 1.26,
        "Tree::RB"  => 0.500003
    },
    TEST_REQUIRES => {
        "Test::More"    => 0.98
    }
);

## Local variables:
## indent-tabs-mode: nil
## End:
### Makefile.PL ends here
