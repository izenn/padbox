#!/usr/bin/perl
use strict;
use warnings;

#depends on https://github.com/codywatts/Puzzle-and-Dragons-Texture-Tool

`mkdir cards`;

my @bcarray = `ls data/USA/bc/cards_*.bc`;
chomp @bcarray;

foreach my $bc (@bcarray) {
  print $bc . "\n";
  `python ./PADTextureTool.py $bc`;
}

`mv data/USA/bc/CARD*.PNG cards`;

#Fix USA image weirdness
`convert cards/CARDS_014.PNG -resize 1014x1014 -background transparent -gravity north -extent 1014x1014 cards/output.png`;
`mv cards/output.png cards/CARDS_014.PNG`;
`convert cards/CARDS_015.PNG -resize 1014x810 -background transparent -gravity south -extent 1014x810 cards/output.png`;
`mv cards/output.png cards/CARDS_015.PNG`;
`convert cards/CARDS_019.PNG -resize 1014x1014 -background transparent -gravity south -extent 1014x1014 cards/output.png`;
`mv cards/output.png cards/CARDS_019.PNG`;
`convert cards/CARDS_020.PNG -resize 1014x1014 -background transparent -gravity south -extent 1014x1014 cards/output.png`;
`mv cards/output.png cards/CARDS_020.PNG`;

my @cardarray = `ls cards/CARDS*.PNG`;
chomp @cardarray;

my $num=1;

foreach my $filename (@cardarray) {
  my $front = $filename;

  print $filename . "\n";
  for (my $y=0; $y < 10; $y++) {
    my $yoffset = 96*$y+6*$y;
    for (my $x=0; $x < 10; $x++) {
      my $xoffset = 96*$x+6*$x;
      my $cardnum = sprintf("%05d",$num);
      print $cardnum . "\n";
      my $cmd = "convert $filename -crop 96x96+$xoffset+$yoffset cards/card_$cardnum.png";
      `$cmd`;
      $num++
    }
  }
  `rm $filename`;
}

