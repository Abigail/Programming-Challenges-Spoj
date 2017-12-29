use 5.024;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

# 
# PALIN - The Next Palindrome
# 
# A positive integer is called a palindrome if its representation in
# the decimal system is the same when read from left to right and
# from right to left. For a given positive integer K of not more than
# 1000000 digits, write the value of the smallest palindrome larger
# than K to output. Numbers are always displayed without leading
# zeros.
# 
# INPUT
# 
# The first line contains integer t, the number of test cases. Integers
# K are given in the next t lines.
# 
# OUTPUT
# 
# For each K, output the smallest palindrome larger than K.
# 
# EXAMPLE
# 
#     Input:
#     2
#     808
#     2133
#     
#     Output:
#     818
#     2222
#

<>;  # Throw away the number of test cases

while (<>) {
    chomp;

    #
    # Special case of all 9s.
    #
    if (/^9+$/) {
        y/9/0/;
        s/0/1/;
        $_ .= 1;
        say;
        next;
    }

    my $length = length;
    my $mid    = int ($length / 2) + ($length % 2);

    #
    # Find out whether we can just reverse the first half, or
    # whether we need some fixing.
    #
    my $needs_fixing = 1;
    for (my $i = $mid - 1; $i >= 0; $i --) {
        my $j = $length - 1 - $i;

        my $left  = substr $_, $i, 1;
        my $right = substr $_, $j, 1;

        if ($left != $right) {
            if ($left > $right) {
                $needs_fixing = 0;
            }
            last;
        }
    }

    #
    # Get the first half, and the middle (if any)
    #
    my $is_odd     = $length % 2;
    my $left_part  = substr $_, 0, $mid - $is_odd;
    my $middle     = $length % 2 ? substr ($_, $mid - 1, 1) : "";

    #
    # Fix up -- increment to the next palindrome. If there's a 
    # middle, increment it. Else, or if the middle is a 9, 
    # turn all trailing 9's into 0's, and increment the digit
    # before the 9's. Note that we've dealt with full sequence
    # of 9's further up.
    #
    if ($needs_fixing) {
        if (length $middle) {
            if ($middle == 9) {
                $middle = 0;
            }
            else {
                $middle ++;
                $needs_fixing = 0;
            }
        }
        if ($needs_fixing) {
            $left_part =~ s/([^9])(9*)$/($1 + 1) . ("0" x length $2)/e;
        }
    }

    say $left_part, $middle, scalar reverse $left_part;
}


__END__
