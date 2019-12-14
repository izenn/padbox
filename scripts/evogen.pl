#!/usr/bin/perl
use warnings;
use JSON qw( decode_json );
use Data::Dumper qw( Dumper );

my $monsterjson;

{
  local $/=undef;
  open FILE, "../paddata_processed_na_cards.json" or die "Couldn't open file: $!";
  $monsterjson = <FILE>;
  close FILE;
}

my $decodedmonster = decode_json($monsterjson);
my $count = keys $decodedmonster;

my %evohash;

for (my $i = 1; $i < $count; $i++) {
  next if $decodedmonster->[$i]{'card'}{'card_id'} > 9999; 
  
    $evohash{$decodedmonster->[$i]{'card'}{'base_id'}}{$decodedmonster->[$i]{'monster_no'}}{'name'} = $decodedmonster->[$i]{'card'}{'name'},
    $evohash{$decodedmonster->[$i]{'card'}{'base_id'}}{$decodedmonster->[$i]{'monster_no'}}{'ancestor'} = $decodedmonster->[$i]{'card'}{'ancestor_id'},
    $evohash{$decodedmonster->[$i]{'card'}{'base_id'}}{$decodedmonster->[$i]{'monster_no'}}{'id'} = $decodedmonster->[$i]{'monster_no'},
    $evohash{$decodedmonster->[$i]{'card'}{'base_id'}}{$decodedmonster->[$i]{'monster_no'}}{'family'} = $decodedmonster->[$i]{'card'}{'base_id'},
};

# Convert each top-level group into a tree of evo...
for my $group (values %evohash) {
    for my $card (sort {$a <=> $b} keys %{$group}) {
        # What is this card's ancestor_id???
        my $ancestor_id = $group->{$card}{'ancestor'};
        # Nothing to do if card doesn't have a ancestor_id...
        next if $ancestor_id == 0;

        # Record that this card is a subordinate of their ancestor_id...
        push @{$group->{$ancestor_id}{'evo'}}, $group->{$card};
    }
}

# Draw each group's org-tree (horizontally), 
# starting with ancestor_id-less cards...
for my $group (values %evohash) {
  my @output;
  my $family;
  for my $card (values %{$group}) {
    # Ignore cards who have a 0 ancestor_id...
    next if $card->{'ancestor'};

    # Draw the org tree for cards that don't have a ancestor_id...
    my $out;
    open SUBOUT, '>', \$out;
    select SUBOUT;
      draw_tree($card);
    select STDOUT;
    my $paddedfamily = sprintf("%05d", $card->{'family'});
    open(my $fh, '>:encoding(UTF-8)', "../evotrees/" . $paddedfamily . ".txt");
      print $fh $out; 
    close $fh;
  }
}

# Draw each card and their evo tree...
sub draw_tree {
  my ($root_node, $level) = @_;
  $level //= 0;

  # Report the card...
  if ( $level == 0 ) {
    print "   ", $root_node->{'id'} . " " .  $root_node->{'name'} . "\n";
  } else {
    print "   |" x $level, "-> ", $root_node->{'id'} . " " .  $root_node->{'name'} . "\n";
  }

  # Recursively report their evo...
  for my $subordinate (@{$root_node->{'evo'}}) {
    draw_tree($subordinate, $level+1);
  }
}

