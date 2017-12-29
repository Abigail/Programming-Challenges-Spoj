use 5.024;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

#
# ARITH - Simple Arithmetics
# 
# One part of the new WAP portal is also a calculator computing
# expressions with very long numbers. To make the output look better,
# the result is formated the same way as is it usually used with
# manual calculations.
# 
# Your task is to write the core part of this calculator. Given two
# numbers and the requested operation, you are to compute the result
# and print it in the form specified below. With addition and
# subtraction, the numbers are written below each other. Multiplication
# is a little bit more complex: first of all, we make a partial result
# for every digit of one of the numbers, and then sum the results
# together.
# 
# INPUT
# 
# There is a single positive integer T on the first line of input
# (equal to about 1000). It stands for the number of expressions to
# follow. Each expression consists of a single line containing a
# positive integer number, an operator (one of +, - and *) and the
# second positive integer number. Every number has at most 500 digits.
# There are no spaces on the line. If the operation is subtraction,
# the second number is always lower than the first one. No number
# will begin with zero.
# 
# OUTPUT
# 
# For each expression, print two lines with two given numbers, the
# second number below the first one, last digits (representing unities)
# must be aligned in the same column. Put the operator right in front
# of the first digit of the second number. After the second number,
# there must be a horizontal line made of dashes (-).
# 
# For each addition or subtraction, put the result right below the
# horizontal line, with last digit aligned to the last digit of both
# operands.
# 
# For each multiplication, multiply the first number by each digit
# of the second number. Put the partial results one below the other,
# starting with the product of the last digit of the second number.
# Each partial result should be aligned with the corresponding digit.
# That means the last digit of the partial product must be in the
# same column as the digit of the second number. No product may begin
# with any additional zeros. If a particular digit is zero, the product
# has exactly one digit -- zero. If the second number has more than
# one digit, print another horizontal line under the partial results,
# and then print the sum of them.
# 
# There must be minimal number of spaces on the beginning of lines,
# with respect to other constraints. The horizontal line is always
# as long as necessary to reach the left and right end of both numbers
# (and operators) directly below and above it. That means it begins
# in the same column where the leftmost digit or operator of that two
# lines (one below and one above) is. It ends in the column where is
# the rightmost digit of that two numbers. The line can be neither
# longer nor shorter than specified.
# 
# Print one blank line after each test case, including the last one.
# 
# EXAMPLE
#
#     Sample Input:
# 
#     4
#     12345+67890
#     324-111
#     325*4405
#     1234*4
#     
#     Sample Output:
#     
#      12345
#     +67890
#     ------
#      80235
#     
#      324
#     -111
#     ----
#      213
#     
#         325
#       *4405
#       -----
#        1625
#          0
#      1300
#     1300
#     -------
#     1431625
#     
#     1234
#       *4
#     ----
#     4936
#


use List::Util    qw [max];
use Math::BigInt;

<>;  # Throw away the number of tests

#
# Handle adding/subtracting numbers
#
sub add_sub ($op, $first, $second) {
    my $total = $op eq '+' ? $first + $second
                           : $first - $second;

    $second = "$op$second";

    #
    # $width is the maximum width of a line of output; this
    # determines the margins.
    #
    my $width = max map {length "$_"} $first, $second, $total;

    #
    # Length of the dashed line.
    #
    my $l1    = max map {length "$_"}         $second, $total;

    #
    # Format each line -- without a newline.
    #
    map {sprintf "%${width}s" => $_} $first,
                                     $second,
                                     "-" x $l1,
                                     $total;
}


#
# Handle multiplying numbers
#
sub mul ($first, $second) {
    #
    # We need to multiply each digit, starting from the end.
    #
    my @digits = reverse split // => $second;

    #
    # Get the list of products ($first * digit); add trailing zeros.
    #
    my @products;
    foreach my $i (keys @digits) {
        my $digit    = $digits [$i];
        my $product  = $first * $digit;
           $product .= '0' x $i;
        push @products => $product;
    }

    #
    # Sum the products for the final answer
    #
    my $sum  = Math::BigInt:: -> new (0);
       $sum += $_ for @products;

    #
    # Replace trailing 0s with spaces
    #
    foreach my $i (keys @products) {
        $products [$i] =~ s/0{$i}$/" " x $i/e;
    }


    $second = "*$second";

    #
    # Find the overall width, and the lengths of the dashed lines.
    #
    my $width = max map {length} $first, $second, @products, $sum;
    my $l1    = max map {length} $second, $products [0];
    my $l2    = max map {length} $sum,    $products [-1];

    #
    # Final formatting. Note that we special case $second contains
    # just one digit -- then we do not have a second dashed line,
    # nor a total sum (the one product is the answer).
    #
    map {sprintf "%${width}s" => $_} $first,
                                     $second,
                                     "-" x $l1,
                                     @products,
                                    (@products > 1) ? ("-" x $l2, $sum)
                                                    : ();
}


while (<>) {
    chomp;

    #
    # Parse input.
    #
    /^([0-9]+)([-+*])([0-9]+)$/ or die "Failed to parse '$_'";

    my $first  = Math::BigInt:: -> new ($1);
    my $op     =                        $2;
    my $second = Math::BigInt:: -> new ($3);

    #
    # Call the right method, and collect the output.
    #
    my @out;
    if ($op eq '+' || $op eq '-') {
        @out = add_sub $op, $first, $second;
    }
    else {
        @out = mul $first, $second;
    }

    #
    # Remove trailing whitespace, and print.
    #
    say s/\s+$//r for @out;

    #
    # Newline after each case.
    #
    say "";
}


__END__
