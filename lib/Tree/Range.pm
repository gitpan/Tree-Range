### Range.pm --- Provide the Tree::Range->new () wrapper  -*- Perl -*-

### Ivan Shmakov, 2013

## To the extent possible under law, the author(s) have dedicated all
## copyright and related and neighboring rights to this software to the
## public domain worldwide.  This software is distributed without any
## warranty.

## You should have received a copy of the CC0 Public Domain Dedication
## along with this software.  If not, see
## <http://creativecommons.org/publicdomain/zero/1.0/>.

### Code:

package Tree::Range 0.21;

use strict;

sub new {
    my ($class, $variety, @args) = @_;
    ## .
    ("Tree::Range::" . ${variety})->new (@args);
}

1;

### Emacs trailer
## Local variables:
## coding: us-ascii
## End:
### Range.pm ends here
