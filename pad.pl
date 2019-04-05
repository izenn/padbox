#!/usr/bin/perl
use strict;
use warnings;
use JSON qw( decode_json );
use Data::Dumper qw( Dumper );
binmode STDOUT, ":encoding(UTF-8)";

my $boxjson;
my $monsterjson;
my $output;

{
  local $/=undef;
  open FILE, "pad.json" or die "Couldn't open file: $!";
  $boxjson = <FILE>;
  close FILE;
}

{
  local $/=undef;
  open FILE, "paddata_processed_na_cards.json" or die "Couldn't open file: $!";
  $monsterjson = <FILE>;
  close FILE;
}

my $decodedbox = decode_json($boxjson);
my $decodedmonster = decode_json($monsterjson);

my $friendcount = keys $decodedbox->{'friends'};

$output = '<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
 <!-- CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- dataTables -->
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js "></script>

<!-- Bootstrap -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<style>
.tooltip-inner {
    max-width: 1280px;
}
table, tbody, tfoot, thead, tr, th, td {
  font-size: 100%;
}
td, th {
  padding: 1;
}
button {
  width: 33%;
}
.card {
  border: none;
  padding: 0px;
  vertical-align: top;
  position: relative;
  width: 98px;
  height: 98px;
}

.card img {
  position: absolute;
  display: block;
  width: 98px;
  height: 98px;
}

.tooltip-inner {
   text-align:left;
 }
</style>
</head>
<body>
<button type="button" class="collapsed" role="button" data-toggle="collapse" data-parent="#accordian1" href="#collapseOne"> Friend List </button> <button type="button" class="collapsed" role="button" data-toggle="collapse" data-parent="#accordian2" href="#collapseTwo"> Rem Plus </button>  <button type="button" class="collapsed" role="button" data-toggle="collapse" data-parent="#accordian3" href="#collapseThree"> Mats </button></p>';

$output .= "<div id='collapseOne' class='panel-collapse collapse'>
<table style='width: 100%'>
<tr>";

my @friendarray;
push @friendarray, "<td style='width:40%;'>
  <table id='friends'>
    <thead>
     <tr><th>ID</th><th>Name</th><th>Level</th><th>Active</th><th>Slot 1</th><th>Slot 2</th></tr></thead>\n    <tbody>";

for (my $i = 0; $i < $friendcount; $i++ ) {
  my $friendline;
  $friendline .= "      <tr>";
  $friendline .= "<td>$decodedbox->{'friends'}[$i][1]</td>";
  $friendline .= "<td>$decodedbox->{'friends'}[$i][2]</td>";
  $friendline .= "<td>$decodedbox->{'friends'}[$i][3]</td>";
  if ($decodedbox->{'friends'}[$i][14] == 1) {
    $friendline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='images/cards/card_0" . $decodedbox->{'friends'}[$i][16] . ".png' title='<img src=&quot;images/monster/MONS_0" . $decodedbox->{'friends'}[$i][16] . ".png&quot;>'/></td>";
    $friendline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='images/cards/card_0" . $decodedbox->{'friends'}[$i][31] . ".png' title='<img src=&quot;images/monster/MONS_0" . $decodedbox->{'friends'}[$i][31] . ".png&quot;>'/></td>";
    $friendline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='images/cards/card_0" . $decodedbox->{'friends'}[$i][46] . ".png' title='<img src=&quot;images/monster/MONS_0" . $decodedbox->{'friends'}[$i][46] . ".png&quot;>'/></td>";
  } else {
    $friendline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='images/cards/card_0" . $decodedbox->{'friends'}[$i][16] . ".png' title='<img src=&quot;images/monster/MONS_0" . $decodedbox->{'friends'}[$i][16] . ".png&quot;>'/></td>";
    $friendline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='images/cards/card_0" . $decodedbox->{'friends'}[$i][31] . ".png' title='<img src=&quot;images/monster/MONS_0" . $decodedbox->{'friends'}[$i][31] . ".png&quot;>'/></td>";
    $friendline .= "<td>&nbsp</td>";
  };
  $friendline .= "</tr>";
  push @friendarray, $friendline;
}
push @friendarray, "    </tbody>\n  </table></td>\n";

$output .= join "\n", @friendarray;
$output .= "<td style='width:4%'>&nbsp;</td>\n";

my @teamarray;
my $teamcount = keys $decodedbox->{'decksb'}{'decks'};
my $cardcount = keys $decodedbox->{'card'};

push @teamarray, "  <td style='width:55%; vertical-align:top'><table id='teams'>
    <thead>
      <tr><th>Team</th><th>Lead</th><th>Sub 1</th><th>Sub 2</th><th>Sub 3</th><th>Sub 4</th><th>Helper</th><th>Badge</th></tr>
    </thead>
    <tbody>";

for (my $t = 0; $t < $teamcount; $t++) {
  my $teamrow;
  my @teamlist = ("<td>&nbsp;</td>") x 6;
  my $teamnum = $t + 1;
  $teamrow = "      <tr><td>" . $teamnum . "</td>";
  for (my $x = 0; $x < $cardcount; $x++) {
    if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][0] ) {
      my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
      my $cardnum = $decodedbox->{'card'}[$x][5];
      my $framedata;
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
      } else {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
      };
        $teamlist[0] = "<td class='card'><img src='images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
    }
  }
  for (my $x = 0; $x < $cardcount; $x++) {
    if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][1] ) {
      my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
      my $cardnum = $decodedbox->{'card'}[$x][5];
      my $framedata;
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
      } else {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
      };
        $teamlist[1] = "<td class='card'><img src='images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
    }
  }
  for (my $x = 0; $x < $cardcount; $x++) {
    if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][2] ) {
      my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
      my $cardnum = $decodedbox->{'card'}[$x][5];
      my $framedata;
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
      } else {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
      };
        $teamlist[2] = "<td class='card'><img src='images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
    }
  }
  for (my $x = 0; $x < $cardcount; $x++) {
    if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][3] ) {
      my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
      my $cardnum = $decodedbox->{'card'}[$x][5];
      my $framedata;
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
      } else {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
      };
        $teamlist[3] = "<td class='card'><img src='images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
    }
  }
  for (my $x = 0; $x < $cardcount; $x++) {
    if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][4] ) {
      my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
      my $cardnum = $decodedbox->{'card'}[$x][5];
      my $framedata;
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
      } else {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
      };
        $teamlist[4] = "<td class='card'><img src='images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
    }
  }
  for (my $x = 0; $x < $cardcount; $x++) {
    if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][6] ) {
      my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
      my $cardnum = $decodedbox->{'card'}[$x][5];
      my $framedata;
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
      } else {
        $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
      };
        $teamlist[5] = "<td class='card'><img src='images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
    }
  }
  $teamrow .= join("", @teamlist);
  $teamrow .= "<td>" . $decodedbox->{'decksb'}{'decks'}[$t][5] . "</td>";
  $teamrow .= "</tr>";
  push @teamarray, $teamrow; 
};

push @teamarray, "    </tbody>
  </table></td></tr>\n";

$output .= join "\n", @teamarray;

$output .= "</table>
</div>\n\n";

my @monsterarray;

for (my $c = 0; $c < $cardcount; $c++ ) {
  my $monsterline;
  my $cardnum = sprintf("%05d", $decodedbox->{'card'}[$c][5]);
  my $framedata;
  if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
    $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img src='images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
  } else {
    $framedata = "<img src='images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
  };
  $monsterline .= "      <tr><td class='card'><a href='http://www.puzzledragonx.com/en/monster.asp?n=$decodedbox->{'card'}[$c][5]'><img src='images/cards/card_" . $cardnum . ".png' alt='$cardnum'>$framedata</a></td>";
  $monsterline .= "<td style='display:none'>$decodedmonster->[$cardnum]{'card'}{'attr_id'}</td>";

  my $subattr;
  if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} == -1 ) {
    $subattr = 5;
  } else {
    $subattr = $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'}
  };
  $monsterline .= "<td style='display:none'>$subattr</td>";
  $monsterline .= "<td>$decodedmonster->[$cardnum]{'card'}{'name'}</td>";
  $monsterline .= "<td>$decodedmonster->[$cardnum]{'card'}{'rarity'}</td>";
  $monsterline .= "<td>$decodedbox->{'card'}[$c][2]</td>";
  
  my @types;
  push @types, $decodedmonster->[$cardnum]{'card'}{'type_1_id'};
  if ( $decodedmonster->[$cardnum]{'card'}{'type_2_id'} > -1 ) {
    push @types, $decodedmonster->[$cardnum]{'card'}{'type_2_id'};
  };
  if ( $decodedmonster->[$cardnum]{'card'}{'type_3_id'} > -1 ) {
    push @types, $decodedmonster->[$cardnum]{'card'}{'type_3_id'};
  };
  for (@types) {
    s/^0$/<img src='images\/badges\/evo.png' alt='Evo'>/;
    s/^1$/<img src='images\/badges\/balanced.png' alt='Balanced'>/;
    s/^2$/<img src='images\/badges\/physical.png' alt='Physical'>/;
    s/^3$/<img src='images\/badges\/healer.png' alt='Healer'>/;
    s/^4$/<img src='images\/badges\/dragon.png' alt='Dragon'>/;
    s/^5$/<img src='images\/badges\/god.png' alt='God'>/;
    s/^6$/<img src='images\/badges\/attacker.png' alt='Attacker'>/;
    s/^7$/<img src='images\/badges\/devil.png' alt='Devil'>/;
    s/^8$/<img src='images\/badges\/machine.png' alt='Machine'>/;
    s/^12$/<img src='images\/badges\/awoken.png' alt='Awoken'>/;
    s/^14$/<img src='images\/badges\/enhance.png' alt='Enhance'>/;
    s/^15$/<img src='images\/badges\/redeemable.png' alt='Redeemable'>/;
  }
  my $typelist = join '', @types;
  $monsterline .= "<td class='type'>$typelist</td>";
  my $paddedfamily = sprintf("%05d", $decodedmonster->[$cardnum]{'card'}{'base_id'});
  my $evotree;
  open(my $fh, '<', "evotrees/" . $paddedfamily . ".txt");
  $evotree = do { local $/; <$fh> };
  close($fh);
  $evotree =~ s/\>/&gt;/g;
  $monsterline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='images/misc/evobutton.png' title='<pre>" . $evotree . "</pre>'</td>";
  my $skillmax;
  my $skilllevel;
  if ( ! defined $decodedmonster->[$cardnum]{'active_skill'}{'levels'} ) {
    $skillmax = 0;
  } else {
    $skillmax = $decodedmonster->[$cardnum]{'active_skill'}{'levels'};
  };
  if ( $skillmax == 0 ) {
    $skilllevel = 0;
  } else {
    $skilllevel = $decodedbox->{'card'}[$c][3]
  };
  $monsterline .= "<td>$skilllevel/$skillmax</td>";
  my $awakenings = keys $decodedmonster->[$cardnum]{'card'}{'awakenings'};
  $monsterline .= "<td>$decodedbox->{'card'}[$c][9]/$awakenings</td>";
  my $latents = sprintf("%049b", $decodedbox->{'card'}[$c][10]);
  my $latentcell;
  if ( $latents =~ m/1111$/ ) {
    my $latentstring = $latents . "a";;
    $latentstring =~ s/1101111a//;
    my @latentarray = ( $latentstring =~ m/......./g );
    @latentarray = grep ! /0000000/, @latentarray;
    my $latentlength = scalar(@latentarray);
    for (my $l = 0; $l < $latentlength; $l++) {
      if ( ! defined $latentarray[$l] ) {
        next;
      } elsif ( $latentarray[$l] =~ m/0000010/ ) {
        $latentarray[$l] = "<img src='images/latents/imphp.png' alt='Imp. HP'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/impatk.png' alt='Imp. ATK'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/imprcv.png' alt='Imp. RCV'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/autoheal.png' alt='Auto-Heal'>";
      } elsif ( $latentarray[$l] =~ m/0001000/ ) {
        $latentarray[$l] = "<img src='images/latents/exttime.png' alt='Ext. Move Time'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/firedr.png' alt='Fire Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/waterdr.png' alt='Water Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/wooddr.png' alt='Wood Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/lightdr.png' alt='Light Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/darkdr.png' alt='Dark Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/0010110/ ) {
        $latentarray[$l] = "<img src='images/latents/sdr.png' alt='Skill Delay Resist.'>";
      } elsif ( $latentarray[$l] =~ m/0011000/ ) {
        $latentarray[$l] = "<img src='images/latents/impall.png' alt='Imp. All Stats'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101000/ ) {
        $latentarray[$l] = "<img src='images/latents/godkiller.png' alt='God Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101010/ ) {
        $latentarray[$l] = "<img src='images/latents/dragonkiller.png' alt='Dragon Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000000/ ) {
        $latentarray[$l] = "<img src='images/latents/devilkiller.png' alt='Devil Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101110/ ) {
        $latentarray[$l] = "<img src='images/latents/machinekiller.png' alt='Machine Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/balancedkiller.png' alt='Balanced Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0110010/ ) {
        $latentarray[$l] = "<img src='images/latents/attackerkiller.png' alt='Attacker Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0110100/ ) {
        $latentarray[$l] = "<img src='images/latents/physicalkiller.png' alt='Physical Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/healerkiller.png' alt='Healer Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111000/ ) {
        $latentarray[$l] = "<img src='images/latents/imphpplus.png' alt='Imp. HP+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111010/ ) {
        $latentarray[$l] = "<img src='images/latents/impatkplus.png' alt='Imp. ATK+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111100/ ) {
        $latentarray[$l] = "<img src='images/latents/imprcvplus.png' alt='Imp. RCV+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111110/ ) {
        $latentarray[$l] = "<img src='images/latents/exttimeplus.png' alt='Ext. Move Time+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/evokiller.png' alt='Evo Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/awokenkiller.png' alt='Awoken Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0100100/ ) {
        $latentarray[$l] = "<img src='images/latents/enhancedkiller.png' alt='Enhanced Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/aaaaaaa/ ) {
        $latentarray[$l] = "<img src='images/latents/redeemablekiller.png' alt='Redeemable Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101100/ ) {
        $latentarray[$l] = "<img src='images/latents/firedrplus.png' alt='Fire Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000010/ ) {
        $latentarray[$l] = "<img src='images/latents/waterdrplus.png' alt='Water Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000100/ ) {
        $latentarray[$l] = "<img src='images/latents/wooddrplus.png' alt='Wood Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000110/ ) {
        $latentarray[$l] = "<img src='images/latents/lightdrplus.png' alt='Light Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1001000/ ) {
        $latentarray[$l] = "<img src='images/latents/darkdrplus.png' alt='Dark Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      }
    }
    $latentcell = join(" ", @latentarray);
    
  } elsif ( $latents == 0 ) {
    $latentcell = "";
  } else {
    $latentcell = "old style";
  }
  if ($typelist =~ m/Evo|Awoken|Enhance/) {
    $latentcell = $decodedbox->{'card'}[$c][1];
  }
  $monsterline .= "<td>$latentcell</td>";
  $monsterline .= "<td>$decodedbox->{'card'}[$c][6]</td>";
  $monsterline .= "<td>$decodedbox->{'card'}[$c][7]</td>";
  $monsterline .= "<td>$decodedbox->{'card'}[$c][8]</td>";
  $monsterline .= "<td>$decodedmonster->[$cardnum]{'card'}{'sell_mp'}</td>";
  $monsterline .= "</tr>";  
  push @monsterarray, $monsterline;
}

my @mats;
my @remplus;
foreach my $line (@monsterarray) {
  if ($line =~ m/<td>[0-9]{1,2}<\/td><\/tr>/ ) {
    if ($line =~ m/<td>(1[01][0-9]|99)<\/td><td class='type'/) {
      push @remplus, $line;
    } else {
      push @mats, $line;
    }
  } elsif ( $line =~ m/evo.png/ ) {
    push @mats, $line;
  } elsif ( $line =~ m/enhange.png/ ) {
    push @mats, $line;
  } elsif ( $line =~ m/awoken.png/ ) {
    push @mats, $line;
  } else {
    push @remplus, $line;
  };
};

$output .= "<div id='collapseTwo' class='panel-collapse collapse'>\n";
$output .= "  <table id='box' style='width:100%'>
    <thead>
      <tr><th>ID</th><th style='display:none'>Main Attr</th><th style='display:none'>Sub Attr</th><th>Name</th><th>Rarity</th><th>Level</th><th>Type</th><th>Evo Tree</th><th>Skill</th><th>Awoken</th><th>Latent</th><th>HP</th><th>ATK</th><th>RCV</th><th>MP</th></tr></thead>\n    <tbody>";

$output .= join "\n", @remplus;

$output .= "    </tbody>
  </table>
</div>\n\n";

$output .= "<div id='collapseThree' class='panel-collapse collapse'>\n";
$output .= "  <table id='mats' style='width:100%'>
    <thead>
      <tr><th>ID</th><th style='display:none'>Main Attr</th><th style='display:none'>Sub Attr</th><th>Name</th><th>Rarity</th><th>Level</th><th>Type</th><th>Evo Tree</th><th>Skill</th><th>Awoken</th><th>Latent/Stacks</th><th>HP</th><th>ATK</th><th>RCV</th><th>MP</th></tr></thead>\n    <tbody>";

$output .= join "\n", @mats;

$output .= "    </tbody>
  </table>
</div>\n\n";


$output .= '<script type="text/javascript">
$(function () {
  $(\'[data-toggle="tooltip"]\').tooltip()
})

$(document).ready(function() {
  $(\'#friends\').DataTable( {
    "paging": false ,
    order: [[ 5, \'asc\' ], [ 2, \'desc\' ]]
  } );
  $(\'#teams\').DataTable( {
    "paging": false ,
    "ordering": false
  } );
  $(\'#box\').DataTable( {
    "paging": false ,
    columnDefs: [ { type: \'alt-string\', targets: 0 } ],
    order: [[ 1, \'asc\' ], [ 4, \'desc\' ], [ 2, \'asc\' ], [ 0, \'desc\' ]]
  } );
  $(\'#mats\').DataTable( {
    "paging": false ,
    columnDefs: [ { type: \'alt-string\', targets: 0 } ],
    order: [[ 1, \'asc\' ], [ 4, \'desc\' ], [ 2, \'asc\' ], [ 0, \'desc\' ]]
  } );
} );

jQuery.extend( jQuery.fn.dataTableExt.oSort, {
  "alt-string-pre": function ( a ) {
    return a.match(/alt="(.*?)"/)[1].toLowerCase();
  },

  "alt-string-asc": function( a, b ) {
    return ((a < b) ? -1 : ((a > b) ? 1 : 0));
  },

  "alt-string-desc": function(a,b) {
    return ((a < b) ? 1 : ((a > b) ? -1 : 0));
  }
} );
</script>
</body>
</html>';

print $output . "\n";
