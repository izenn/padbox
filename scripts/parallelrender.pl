#!/usr/bin/perl  

use strict;
 
my @pids;
my $max = 10;
my $children = 0;

my @binarray = `cd data/USA/bin/; ls mons_*`;
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
      my $pid;

      if($children == $max) {
            $pid = wait();
            $children--;
      }
       
      if(defined($pid = fork())) {
            if($pid) {
                  $children++;
                  print "Rendering $item\n";
                  push @pids, $pid;
            } else {
                  child($item);
                  exit;
            }
      } else {
            print "Error: failed to fork\n";
            exit;
      }
}


for my $pid(@pids) {
      waitpid $pid, 0;
}
print "DONE.\n";


sub child() {
      my $id = $_[0];
      my $render = "yarn render --bin data/USA/bin/mons_$id.bin --out extracted/MONS_" . sprintf("%05d",$id) . ".png --nobg";
  `$render`;
  my $mogrify = "mogrify -trim +repage extracted/MONS_" . sprintf("%05d",$id) . ".png";
  `$mogrify`; 
      exit;
}
