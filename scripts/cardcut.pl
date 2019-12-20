#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

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
`convert cards/CARDS_058.PNG -resize 1014x96 -background transparent -gravity west -extent 1014x96 cards/temp.png`;
`convert cards/temp.png -resize 1014x810 -background transparent -gravity south -extent 1014x810 cards/output.png`;
`mv cards/output.png cards/CARDS_058.PNG`;
`rm cards/temp.png`;

my @cardarray = `ls cards/CARDS*.PNG`;
chomp @cardarray;

my $filename = "checksum.md5";
my @input;
if (-e $filename) {
  open my $handle, '<', $filename;
  chomp(@input = <$handle>);
  close $handle;
}

foreach my $filename (@cardarray) {
  my ($newchecksum, $newmd5, $undef, $oldchecksum, $oldmd5, @oldchecksum);
  $newchecksum = `md5sum $filename`;
  ($newmd5, $undef) = split(/[\s]/, $newchecksum);
  if (@input) {
    @oldchecksum = grep(/$filename/, @input);
  } else {
    @oldchecksum = (0, "none");
  }
  $oldchecksum = join(" ", @oldchecksum);
  ($oldmd5, $undef) = split(/[\s]/, $oldchecksum);
  if ($oldmd5 eq $newmd5) {
    print "$filename unchanged, skipping\n";
  } else {
    print $filename . "\n";
    my $numcalc = $filename;
    $numcalc =~ s/cards\/CARDS_[0]+//;
    $numcalc =~ s/.PNG//;
    $numcalc = ($numcalc - 1) * 100 + 1;
    for (my $y=0; $y < 10; $y++) {
      my $yoffset = 96*$y+6*$y;
      for (my $x=0; $x < 10; $x++) {
        my $xoffset = 96*$x+6*$x;
        my $cardnum = sprintf("%05d",$numcalc);
        print $cardnum . "\n";
        my $cmd = "convert $filename -crop 96x96+$xoffset+$yoffset cards/card_$cardnum.png";
        `$cmd`;
        $numcalc++
      }
    }
  }
}
  `find cards/ -type f -size -512c -delete`;
  `mv checksum.md5 oldsum.md5`;
  `md5sum cards/CARDS* > checksum.md5`;
#  `rm cards/CARDS*`;

