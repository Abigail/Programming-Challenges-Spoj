use 5.024;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

#
# PRIME1 - Prime Generator
#
# Peter wants to generate some prime numbers for his cryptosystem.
# Help him! Your task is to generate all prime numbers between two
# given numbers!
# 
# INPUT
# 
# The input begins with the number t of test cases in a single line
# (t<=10). In each of the next t lines there are two numbers m and n
# (1 <= m <= n <= 1000000000, n-m<=100000) separated by a space.
# 
# OUTPUT
# 
# For every test case print all prime numbers p such that m <= p <= n,
# one number per line, test cases separated by an empty line.
# 
# EXAMPLE
# 
#    Input:
#    2
#    1 10
#    3 5
#
#    Output:
#    2
#    3
#    5
#    7
#    
#    3
#    5
#


#
# First, create a list of all odd primes <= sqrt (1_000_000_000);
#
my $MAX    = 1_000_000_000;
my @primes = (2, 3);
NUMBER:
for (my $number = 5; $number <= sqrt ($MAX); $number += 2) {
  PRIME:
    foreach my $prime (@primes) {
        last PRIME  if $prime  * $prime >  $number;
        next NUMBER if $number % $prime == 0;
    }
    push @primes => $number;
}

#
# Check whether a given number is prime. It's prime if none of the
# primes less than its square root divide the number evenly.
#
sub is_prime ($number) {
    my $sqrt = int sqrt $number;
    foreach my $prime (@primes) {
        return 1 if $prime > $sqrt;
        return 0 if $number % $prime == 0;
    }
    return 1;
}

<>;  # We don't need the first line.

#
# Read the input; store it in a todo list.
#
my @todo;
while (<>) {
    chomp;
    push @todo => [split];
}

while (@todo) {
    my ($from, $to) = @{shift @todo};

    #
    # Special case for 2.
    #
    if ($from <= 2) {
        say 2;
        $from = 3;
    }
    elsif ($from % 2 == 0) {   # Start from an odd number.
        $from ++;
    }

    #
    # We will only consider odd numbers.
    #
    for (my $number = $from; $number <= $to; $number += 2) {
        say $number if is_prime $number;
    }

    #
    # Test cases are separated by empty lines, so no line
    # after the last test case.
    #
    say "" if @todo;
}


__END__
