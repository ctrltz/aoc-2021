#!/usr/bin/perl

use feature ':5.28';
use Switch;

$argc = @ARGV;
if ($argc != 1)
{
    say "Usage: perl $0 filename";
    exit;
}
$filename = @ARGV[0];

open(DATA, "<$filename") or die "Couldn't open file $filename, $!";

say "Processing file $filename";
@lines = <DATA>;

# Combined loop for part 1 and part 2
$p1_dx = 0;
$p1_dy = 0;
$p2_dx = 0;
$p2_dy = 0;
$p2_aim = 0;
foreach $l (@lines)
{
    @tokens = split / /, $l;
    my $dir = @tokens[0];
    my $val = @tokens[1];
    switch ($dir)
    {
        case "forward"
        {
            $p1_dx += $val;

            $p2_dx += $val;
            $p2_dy += $val * $p2_aim;
        }
        case "up"
        {
            $p1_dy -= $val;
            if ($p1_dy < 0)
            {
                die "Depth is below 0";
            }

            $p2_aim -= $val;
        }
        case "down"
        {
            $p1_dy += $val;

            $p2_aim += $val;
        }
    }
}

# Part 1
my $p1_result = $p1_dx * $p1_dy;
say "Answer to Part 1: dx=$p1_dx, dy=$p1_dy, result=$p1_result";

# Part 2
my $p2_result = $p2_dx * $p2_dy;
say "Answer to Part 2: dx=$p2_dx, dy=$p2_dy, result=$p2_result";
