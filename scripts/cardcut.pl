#!/usr/bin/perl
use strict;
use warnings;

#depends on https://github.com/codywatts/Puzzle-and-Dragons-Texture-Tool

`mkdir cards`;

my @bcarray = `ls data/HT/bc/cards_*.bc`;
chomp @bcarray;

foreach my $bc (@bcarray) {
  `python PADTextureTool.py $bc`;
}

`mv data/HT/bc/CARD*.PNG cards`;

my @cardarray = `ls cards/CARDS*.PNG`;
chomp @cardarray;

foreach my $filename (@cardarray) {
  my $front = $filename;
  $front =~ s/cards\/CARDS_[0]+//;
  $front =~ s/.PNG$//;
  $front = $front - 1;

  for (my $y=0; $y < 10; $y++) {
    my $yoffset = 96*$y+6*$y;
    for (my $x=0; $x < 10; $x++) {
      my $xoffset = 96*$x+6*$x;
      my $end = $x;
      my $num = "$front$y$end";
      $num = $num + 1;
      my $cardnum = sprintf("%05d",$num);
      my $cmd = "convert $filename -crop 96x96+$xoffset+$yoffset cards/card_$cardnum.png";
      `$cmd`;
    }
  }
  `rm $filename`;
}
