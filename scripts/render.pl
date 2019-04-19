#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

#depends on https://github.com/kiootic/pad-resources

print "do you need to 'yarn update'?\n";

`mkdir extracted`;

my @binarray = `cd data/HT/bin/; ls mons_*`;
chomp @binarray;
my @extractarray = `cd extracted/; ls MONS_*`;
chomp @extractarray;

for (@binarray) {
  s/mons_//;
  s/.bin//;
};

for (@extractarray) {
  s/MONS_//;
  s/.png//;
};

my @fixedarray;
foreach my $entry (@extractarray) {
  push @fixedarray, sprintf("%03d",$entry);
};

my %done = map {($_, 1)} @fixedarray;
my @needed = grep {!$done{$_}} @binarray;

foreach my $item (@needed) {
  my $render = "yarn render --bin data/HT/bin/mons_$item.bin --out extracted/MONS_" . sprintf("%05d",$item) . ".png --nobg";
  `$render`;
  my $mogrify = "mogrify -trim +repage extracted/MONS_" . sprintf("%05d",$item) . ".png";
  `$mogrify`
}
