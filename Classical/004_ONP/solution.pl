use 5.024;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

# 
# ONP - Transform the Expression
#
# Transform the algebraic expression with brackets into RPN form
# (Reverse Polish Notation). Two-argument operators: +, -, *, /, ^
# (priority from the lowest to the highest), brackets ( ). Operands:
# only letters: a,b,...,z. Assume that there is only one RPN form (no
# expressions like a*b*c).
# 
# INPUT
# 
#      t [the number of expressions <= 100]
#      expression [length <= 400]
#      [other expressions]
#
# Text grouped in [ ] does not appear in the input file.
#
# OUTPUT
# 
# The expressions in RPN form, one per line.
# 
# EXAMPLE
#
#     Input:
#     3
#     (a+(b*c))
#     ((a+b)*(z+x))
#     ((a+t)*((b+(a+c))^(c+d)))
#     
#     Output:
#     abc*+
#     ab+zx+*
#     at+bac++cd+^*
#

my $group = qr /(?<group> \( (?<inner> [^()]* (?: (?&group) [^()]* )* ) \))/x;

#
# Recursively transform the expression:
#    - For each group, strip the outer parens, and recurse
#    - For each operator, lowest to highest priority:
#          - Find the first occurance of the operator
#          - Recurse each operand
#          - Add a place holder, which will be processed during post processing
#
sub rpn;
sub rpn ($expression) {
    $expression =~ s {$group} {rpn $+ {inner}}ge;

    $expression =~ s {^(?<term>[^+]+) \+ (?<rest>.*)}
                     {rpn ($+ {term}) . rpn ($+ {rest}) . "A"}xe;
    $expression =~ s {^(?<term>[^-]+) \- (?<rest>.*)}
                     {rpn ($+ {term}) . rpn ($+ {rest}) . "S"}xe;
    $expression =~ s {^(?<term>[^*]+) \* (?<rest>.*)}
                     {rpn ($+ {term}) . rpn ($+ {rest}) . "M"}xe;
    $expression =~ s {^(?<term>[^*]+) \/ (?<rest>.*)}
                     {rpn ($+ {term}) . rpn ($+ {rest}) . "D"}xe;
    $expression =~ s {^(?<term>[^*]+) \^ (?<rest>.*)}
                     {rpn ($+ {term}) . rpn ($+ {rest}) . "P"}xe;

    $expression;
}

#
# Replace place holders with operators
#
sub post ($expression) {
    $expression =~ tr!ASMDP!+\-*/^!;
    $expression;
}


<>;  # Throw away the first line

while (<>) {
    chomp;
    say post rpn $_;
}


__END__
