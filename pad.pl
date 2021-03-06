#!/usr/bin/perl
use strict;
use warnings;
use JSON qw( decode_json );
use Data::Dumper qw( Dumper );

my $boxjson;
my $monsterjson;
my $output;
my $upload = $ARGV[0];
my $userid = $ARGV[1];
my $reference = $ARGV[2];

my $refurl;

if ( $reference eq "ilmina" ) {
  $refurl = "https://ilmina.com/#/CARD/";
} elsif ( $reference eq "pdx" ) {
  $refurl = "http://www.puzzledragonx.com/en/monster.asp?n=";
} else {
  print "select reference source\n";
  exit(0);
}

#print "importing box json\n";
{
  local $/=undef;
  open FILE, "$upload" or die "Couldn't open file: $!";
  $boxjson = <FILE>;
  close FILE;
}

#print "importing monster json\n";
{
  local $/=undef;
  open FILE, "paddata_processed_na_cards.json" or die "Couldn't open file: $!";
  $monsterjson = <FILE>;
  close FILE;
}

my $decodedbox = decode_json($boxjson);
my $decodedmonster = decode_json($monsterjson);

my $friendcount = scalar(@{$decodedbox->{'friends'}});

$output = '<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
 <!-- CSS -->
<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.18/fh-3.1.4/datatables.min.css"/>


<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- dataTables -->
<script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.18/fh-3.1.4/datatables.min.js"></script>

<!-- Bootstrap -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>

<!-- Lozad -->
<script src="https://cdn.jsdelivr.net/npm/lozad"></script>

<style>
body {
  background-image: url("/images/background.webp");
  background-repeat: no-repeat;
  background-attachment: fixed;
}
table td, table tr, table th {
  background: transparent !important;
}
table, tbody, tfoot, thead, tr, th, td {
  font-size: 100%;
}
td, th {
  padding: 1;
}
button {
  width: 33%;
  box-shadow:inset 0px 1px 0px 0px #54a3f7;
  background:linear-gradient(to bottom, #007dc1 5%, #0061a7 100%);
  background-color:#007dc1;
  border-radius:3px;
  border:1px solid #124d77;
  display:inline-block;
  cursor:pointer;
  color:#ffffff;
  padding:6px 24px;
  text-decoration:none;
  text-shadow:0px 1px 0px #154682;
}
button:hover {
  background:linear-gradient(to bottom, #0061a7 5%, #007dc1 100%);
  background-color:#0061a7;
}
.card {
  border: none;
  padding: 0px;
  vertical-align: top;
  position: relative;
  width: 98px;
  height: 98px;
  display: table-cell;
}

.card img {
  position: absolute;
  display: block;
  width: 98px;
  height: 98px;
}

.tooltip-inner {
  background: rgba(255, 255, 255, 0.90);
  max-width: 600px;
  color: #000;
}

.tooltip.show {
  opacity: 1;
}

pre {
  text-align: left;
}

.teamslot {
  height: 98px;
}

.awoken {
  width: 290px;
  display: flex;
}

.assist {
  width: 196px;
  display: flex;
}

.noassist {
  width: 98px;
}

.column {
  flex: 33%;
}

.tamacolumns {
  column-count: 3;
  width: 200px;
}

#topbutton {
  display: none;
  position: fixed;
  bottom: 20px;
  right: 30px;
  z-index: 99;
  cursor: pointer;
  width: 100px;
}

table#mats th:nth-child(9) {display: none;}
table#mats td:nth-child(9) {display: none;}
table#mats th:nth-child(10) {display: none;}
table#mats td:nth-child(10) {display: none;}
table#mats th:nth-child(11) {display: none;}
table#mats td:nth-child(11) {display: none;}

</style>
</head>
<body>
<div id=buttonGroup>
<p>
<button type="button" class="collapsed" role="button" data-toggle="collapse" href="#collapseOne"> Friends/Teams </button>
<button type="button" class="collapsed" role="button" data-toggle="collapse" href="#collapseTwo"> Rem Plus </button>
<button type="button" class="collapsed" role="button" data-toggle="collapse" href="#collapseThree"> Mats </button>
<button onclick="topFunction()" id="topbutton" title="Go to top">Top</button>
</p>';
$output .= "\n<div id='collapseOne' class='panel-collapse collapse' data-parent='#buttonGroup'>
<table style='width: 100%'>
<tr>";

#print "generating friend list\n";
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
    my $cardone = sprintf("%05d", $decodedbox->{'friends'}[$i][16]);
    my $cardtwo = sprintf("%05d", $decodedbox->{'friends'}[$i][31]);
    my $cardthree = sprintf("%05d", $decodedbox->{'friends'}[$i][46]);
    $friendline .= "<td><img class='lozad' data-src='/images/cards/card_" . $cardone . ".png' /></td>";
    $friendline .= "<td><img class='lozad' data-src='/images/cards/card_" . $cardtwo . ".png' /></td>";
    $friendline .= "<td><img class='lozad' data-src='/images/cards/card_" . $cardthree . ".png' /></td>";
  } else {
    my $cardone = sprintf("%05d", $decodedbox->{'friends'}[$i][16]);
    my $cardtwo = sprintf("%05d", $decodedbox->{'friends'}[$i][31]);
    $friendline .= "<td><img class='lozad' data-src='/images/cards/card_" . $cardone . ".png' /></td>";
    $friendline .= "<td><img class='lozad' data-src='/images/cards/card_" . $cardtwo . ".png' /></td>";
    $friendline .= "<td>&nbsp;</td>";
  };
  $friendline .= "</tr>";
  push @friendarray, $friendline;
}
push @friendarray, "    </tbody>\n  </table></td>\n";

$output .= join "\n", @friendarray;
$output .= "<td style='width:4%'>&nbsp;</td>\n";

#print "generating team list\n";
my @teamarray;
my $teamcount = scalar(@{$decodedbox->{'decksb'}{'decks'}});
my $cardcount = scalar(@{$decodedbox->{'card'}});

push @teamarray, "  <td style='width:55%; vertical-align:top'><table id='teams'>
    <thead>
      <tr><th>Team</th><th>Lead</th><th>Sub 1</th><th>Sub 2</th><th>Sub 3</th><th>Sub 4</th><th>Helper</th><th>TA</th><th>Badge</th></tr>
    </thead>
    <tbody>";

for (my $t = 0; $t < $teamcount; $t++) {
  my @team_awoken_array;
  my %team_awoken_hash;
  my $teamrow;
  my @teamlist = ("<td>&nbsp;</td>") x 6;
  my $teamnum = $t + 1;
  $teamrow = "      <tr><td>" . $teamnum . "</td>";
  for (my $s = 0; $s < 7; $s++) {
    for (my $x = 0; $x < $cardcount; $x++) {
      if ( $decodedbox->{'card'}[$x][0] == $decodedbox->{'decksb'}{'decks'}[$t][$s] ) {
        my $foundcard = sprintf("%05d", $decodedbox->{'card'}[$x][5]);
        my $assistnum;
        for (my $a = 0; $a < $cardcount; $a++) {
          if ( $decodedbox->{'card'}[$a][0] ==  $decodedbox->{'card'}[$x][11]) {
            $assistnum = $decodedbox->{'card'}[$a][5]
          }
        }
        my $assistcard;
        my $assistslots;
        my $assisttooltip;
        my $assistflag = 0;
        if ( defined $assistnum ) {
          my $paddedassist = sprintf("%05d", $assistnum);
          $assistcard = "<div class='card'><img src='/images/cards/card_" . $paddedassist . ".png'>";
          if ( $decodedmonster->[$assistnum]{'card'}{'sub_attr_id'} > -1 ) {
            $assistcard .= "<img src='/images/frames/frame_" . $decodedmonster->[$assistnum]{'card'}{'attr_id'} . ".png'><img src='/images/frames/sub_" . $decodedmonster->[$assistnum]{'card'}{'sub_attr_id'} . ".png'></div>";
          } else {
            $assistcard .= "<img src='/images/frames/frame_" . $decodedmonster->[$assistnum]{'card'}{'attr_id'} . ".png'></div>";
          }
          my $awakenings = scalar(@{$decodedmonster->[$assistnum]{'card'}{'awakenings'}});
          if ($awakenings > 0) {
            if ( @{$decodedmonster->[$assistnum]{'card'}{'awakenings'}}[0] == 49 ) {
              my $assistslots;
              for ( my $a = 0; $a < $awakenings; $a++ ) {
                push @team_awoken_array, @{$decodedmonster->[$assistnum]{'card'}{'awakenings'}}[$a];
                $assistslots .= "<img src='/images/awakenings/" . @{$decodedmonster->[$assistnum]{'card'}{'awakenings'}}[$a] . ".png' alt='" . @{$decodedmonster->[$assistnum]{'card'}{'awakenings'}}[$a] . "'>";
                $assistflag = 2;
              }
              $assisttooltip = "<div class='column'>" . $assistcard . "</div><div class='column'>" . $assistslots . "</div></div>";
            } else {
              $assisttooltip = "<div class='column'>" . $assistcard . "</div></div>";
              $assistflag = 1;
            }
          }
        }
        my $cardnum = $decodedbox->{'card'}[$x][5];
        my $awakenings = scalar(@{$decodedmonster->[$cardnum]{'card'}{'awakenings'}});
        my $awoken = $decodedbox->{'card'}[$x][9];
        my $slots;
        if ($awakenings > 0) {
          for ( my $a = 0; $a < $awakenings; $a++ ) {
            if ( $a < $awoken ) {
                push @team_awoken_array, @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a];
              $slots .= "<img src='/images/awakenings/" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . ".png' alt='" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . "'>";
            } else {
              $slots .= "<img src='/images/awakenings/unawoken/" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . ".png' alt='" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . "'>";
            }
          }
        }
        my $tooltip;
        if ( $assistflag == 2 ) {
	  $tooltip = "<div class='teamslot awoken'><div class='column'>" . $slots . "</div>" . $assisttooltip;
        } elsif ( $assistflag == 1 ) {
	  $tooltip = "<div class='teamslot assist'><div class='column'>" . $slots . "</div>" . $assisttooltip;
        } else {
	  $tooltip = "<div class='teamslot noassist'>" . $slots . "</div>";
        }
        my $framedata;
        if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
          $framedata = "<img class='lozad' data-src='/images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img class='lozad' data-src='/images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
        } else {
          $framedata = "<img class='lozad' data-src='/images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
        };
        if ( $s == 6 ) {
            $teamlist[5] = "<td class='card' data-toggle='tooltip' data-html='true' data-placement='bottom' title=\"$tooltip\"><img class='lozad' data-src='/images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
        } else {
          $teamlist[$s] = "<td class='card' data-toggle='tooltip' data-html='true' data-placement='bottom' title=\"$tooltip\"><img class='lozad' data-src='/images/cards/card_" . $foundcard . ".png' alt='" .  $decodedmonster->[$cardnum]{'card'}{'name'}. "'>$framedata</td>";
        }
      }
    }
  }
  $teamrow .= join("", @teamlist);
  map($team_awoken_hash{$_}++, @team_awoken_array);
  my $team_awakenings = join(' ',map("<img src='/images/awakenings/" . $_ . ".png'>x" . $team_awoken_hash{$_} . "<br>", sort {$team_awoken_hash{$a}<=>$team_awoken_hash{$b}} keys %team_awoken_hash));
  $teamrow .= "<td><img class='lozad' data-src='/images/misc/tama.png' data-toggle='tooltip' data-html='true' data-placement='left' title=\"<div class='tamacolumns'>$team_awakenings</div>\">";
  $teamrow .= "<td><img class='lozad' data-src='/images/team/" . $decodedbox->{'decksb'}{'decks'}[$t][5] . ".png'></td>";
  $teamrow .= "</tr>";
  push @teamarray, $teamrow; 
};
push @teamarray, "    </tbody>
  </table></td></tr>\n";

$output .= join "\n", @teamarray;

$output .= "</table>
</div>\n\n";

#print "generating box list\n";
my @monsterarray;
my %mobilehash;
for (my $c = 0; $c < $cardcount; $c++ ) {
  my $monsterline;
  my $cardnum = sprintf("%05d", $decodedbox->{'card'}[$c][5]);
  my $framedata;
  if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
    $framedata = "<img class='lozad' data-src='/images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'><img class='lozad' data-src='/images/frames/sub_" . $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} . ".png'>";
  } else {
    $framedata = "<img class='lozad' data-src='/images/frames/frame_" . $decodedmonster->[$cardnum]{'card'}{'attr_id'} . ".png'>";
  };
  $monsterline .= "      <tr><td class='card'><a href='$refurl$decodedbox->{'card'}[$c][5]'><img class='lozad' data-src='/images/cards/card_" . $cardnum . ".png' alt='$cardnum'>$framedata</a></td>";
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
    s/^0$/<img class='lozad' data-src='\/images\/badges\/evo.png' alt='Evo'>/;
    s/^1$/<img class='lozad' data-src='\/images\/badges\/balanced.png' alt='Balanced'>/;
    s/^2$/<img class='lozad' data-src='\/images\/badges\/physical.png' alt='Physical'>/;
    s/^3$/<img class='lozad' data-src='\/images\/badges\/healer.png' alt='Healer'>/;
    s/^4$/<img class='lozad' data-src='\/images\/badges\/dragon.png' alt='Dragon'>/;
    s/^5$/<img class='lozad' data-src='\/images\/badges\/god.png' alt='God'>/;
    s/^6$/<img class='lozad' data-src='\/images\/badges\/attacker.png' alt='Attacker'>/;
    s/^7$/<img class='lozad' data-src='\/images\/badges\/devil.png' alt='Devil'>/;
    s/^8$/<img class='lozad' data-src='\/images\/badges\/machine.png' alt='Machine'>/;
    s/^12$/<img class='lozad' data-src='\/images\/badges\/awoken.png' alt='Awoken'>/;
    s/^14$/<img class='lozad' data-src='\/images\/badges\/enhance.png' alt='Enhance'>/;
    s/^15$/<img class='lozad' data-src='\/images\/badges\/redeemable.png' alt='Redeemable'>/;
  }
  my $typelist = join '', @types;
  $monsterline .= "<td class='type'>$typelist</td>";

  my $types = $decodedmonster->[$cardnum]{'card'}{'type_1_id'};
  if ( $decodedmonster->[$cardnum]{'card'}{'type_2_id'} > -1 ) {
    $types .= " " . $decodedmonster->[$cardnum]{'card'}{'type_2_id'};
  };
  if ( $decodedmonster->[$cardnum]{'card'}{'type_3_id'} > -1 ) {
    $types .= " " . $decodedmonster->[$cardnum]{'card'}{'type_3_id'};
  };
  if ($types !~ m/(0|12|14|15)/) {
    if ( $decodedmonster->[$cardnum]{'card'}{'sell_mp'} >= 100 || $decodedbox->{'card'}[$c][2] >= 99 ) {
      if ( $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'} > -1 ) {
        $mobilehash{$c}->{'mainattr'} = $decodedmonster->[$cardnum]{'card'}{'attr_id'};
        $mobilehash{$c}->{'subattr'} = $decodedmonster->[$cardnum]{'card'}{'sub_attr_id'};
      } else {
        $mobilehash{$c}->{'mainattr'} = $decodedmonster->[$cardnum]{'card'}{'attr_id'};
        $mobilehash{$c}->{'subattr'} = 5;
      };

      $mobilehash{$c}->{'name'} = $decodedmonster->[$cardnum]{'card'}{'name'};
      $mobilehash{$c}->{'name'} =~ s/"/'/g;
      $mobilehash{$c}->{'rarity'} = $decodedmonster->[$cardnum]{'card'}{'rarity'};
      $mobilehash{$c}->{'id'} = $decodedbox->{'card'}[$c][5];
      $mobilehash{$c}->{'paddedid'} = $cardnum;
    }
  }


  my $paddedfamily = sprintf("%05d", $decodedmonster->[$cardnum]{'card'}{'base_id'});
  my $evotree;
  open(my $fh, '<', "evotrees/" . $paddedfamily . ".txt");
  $evotree = do { local $/; <$fh> };
  close($fh);
  $evotree =~ s/\>/&gt;/g;
  my $number = $cardnum;
  $number += 0;
  $evotree =~ s/($number .*)/<strong>$1<\/strong>/;
  $evotree =~ s/"/'/g;
  $monsterline .= "<td><input type='image' data-toggle='tooltip' data-html='true' data-placement='right' src='/images/misc/evobutton.png' title=\"<pre>" . $evotree . "</pre>\"</td>";
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
  my $awakenings = scalar(@{$decodedmonster->[$cardnum]{'card'}{'awakenings'}});
  my $awoken = $decodedbox->{'card'}[$c][9];
  if ( $awoken > $awakenings ) {
    $awoken = $awakenings;
  }
  my $awokenskills;
  if ( $awakenings > 0 ) {
    for ( my $a = 0; $a < $awakenings; $a++ ) {
      if ( $a < $awoken ) {
        $awokenskills .= "<img src='/images/awakenings/" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . ".png' alt='" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . "'>";
      } else {
        $awokenskills .= "<img src='/images/awakenings/unawoken/" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . ".png' alt='" . @{$decodedmonster->[$cardnum]{'card'}{'awakenings'}}[$a] . "'>";
      }
    }
    $monsterline .= "<td>$awokenskills</td>";
  } else {
    $monsterline .= "<td>&nbsp;</td>";
  }
  if ($decodedbox->{'card'}[$c][13] > 0 ) {
    $monsterline .= "<td><img class='lozad' data-src='/images/awakenings/" . $decodedbox->{'card'}[$c][13] . ".png' alt='" . $decodedbox->{'card'}[$c][13] . "'></td>";
  } else {
    $monsterline .= "<td>&nbsp;</td>";
  }
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
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/imphp.png' alt='Imp. HP'>";
      } elsif ( $latentarray[$l] =~ m/0000100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/impatk.png' alt='Imp. ATK'>";
      } elsif ( $latentarray[$l] =~ m/0000110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/imprcv.png' alt='Imp. RCV'>";
      } elsif ( $latentarray[$l] =~ m/0001010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/autoheal.png' alt='Auto-Heal'>";
      } elsif ( $latentarray[$l] =~ m/0001000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/exttime.png' alt='Ext. Move Time'>";
      } elsif ( $latentarray[$l] =~ m/0001100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/firedr.png' alt='Fire Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/0001110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/waterdr.png' alt='Water Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/0010000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/wooddr.png' alt='Wood Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/0010010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/lightdr.png' alt='Light Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/0010100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/darkdr.png' alt='Dark Dmg. Red.'>";
      } elsif ( $latentarray[$l] =~ m/0010110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/sdr.png' alt='Skill Delay Resist.'>";
      } elsif ( $latentarray[$l] =~ m/0011000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/impall.png' alt='Imp. All Stats'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/godkiller.png' alt='God Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/dragonkiller.png' alt='Dragon Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/devilkiller.png' alt='Devil Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/machinekiller.png' alt='Machine Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0110000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/balancedkiller.png' alt='Balanced Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0110010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/attackerkiller.png' alt='Attacker Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0110100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/physicalkiller.png' alt='Physical Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0110110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/healerkiller.png' alt='Healer Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/imphpplus.png' alt='Imp. HP+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/impatkplus.png' alt='Imp. ATK+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/imprcvplus.png' alt='Imp. RCV+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0111110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/exttimeplus.png' alt='Ext. Move Time+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0100000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/evokiller.png' alt='Evo Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0100010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/awokenkiller.png' alt='Awoken Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0100100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/enhancedkiller.png' alt='Enhanced Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0100110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/redeemablekiller.png' alt='Redeemable Material Killer'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/0101100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/firedrplus.png' alt='Fire Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000010/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/waterdrplus.png' alt='Water Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000100/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/wooddrplus.png' alt='Wood Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1000110/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/lightdrplus.png' alt='Light Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      } elsif ( $latentarray[$l] =~ m/1001000/ ) {
        $latentarray[$l] = "<img class='lozad' data-src='/images/latents/darkdrplus.png' alt='Dark Dmg. Red.+'>";
        splice @latentarray, $l+1, 1;
      }
    }
    $latentcell = join(" ", @latentarray);
    
  } elsif ( $latents == 0 ) {
    $latentcell = "";
  } else {
    $latentcell = "old style";
  }
  if ($typelist =~ m/Redeemable/) {
    $latentcell = "";
  } elsif ($decodedmonster->[$cardnum]{'card'}{'name'} =~ m/Moltdra|Pengdra/) {
    $latentcell = "";
  } elsif ($typelist =~ m/Evo|Awoken|Enhance/) {
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
  if ( $line =~ m/evo.png/ ) {
    push @mats, $line;
  } elsif ( $line =~ m/enhance.png/ ) {
    push @mats, $line;
  } elsif ( $line =~ m/awoken.png/ ) {
    push @mats, $line;
  } elsif ( $line =~ m/redeemable.png/ ) {
    push @mats, $line;
  } elsif ($line =~ m/<td>[0-9]{1,2}<\/td><\/tr>/ ) {
    if ($line =~ m/<td>(1[01][0-9]|99)<\/td><td class='type'/) {
      push @remplus, $line;
    } else {
      push @mats, $line;
    }
  } else {
    push @remplus, $line;
  };
};

$output .= "<div id='collapseTwo' class='panel-collapse collapse' data-parent='#buttonGroup'>\n";
$output .= "  <table id='box' style='width:100%'>
    <thead>
      <tr><th>ID</th><th style='display:none'>Main Attr</th><th style='display:none'>Sub Attr</th><th>Name</th><th>Rarity</th><th>Level</th><th>Type</th><th>Evo Tree</th><th>Skill</th><th style='width=98px;'>Awoken</th><th>Super</th><th>Latent</th><th>HP</th><th>ATK</th><th>RCV</th><th>MP</th></tr></thead>\n    <tbody>";

$output .= join "\n", @remplus;

$output .= "    </tbody>
  </table>
</div>\n\n";

$output .= "<div id='collapseThree' class='panel-collapse collapse' data-parent='#buttonGroup'>\n";
$output .= "  <table id='mats' style='width:100%'>
    <thead>
      <tr><th>ID</th><th style='display:none'>Main Attr</th><th style='display:none'>Sub Attr</th><th>Name</th><th>Rarity</th><th>Level</th><th>Type</th><th>Evo Tree</th><th style='display:none'>Skill</th><th style='display:none'>Awoken</th><th style='display:none'>Super</th><th>Count</th><th>HP</th><th>ATK</th><th>RCV</th><th>MP</th></tr></thead>\n    <tbody>";

$output .= join "\n", @mats;

$output .= "    </tbody>
  </table>
</div>
</div>\n\n";


$output .= '<script type="text/javascript">
$(function () {
  $(\'[data-toggle="tooltip"]\').tooltip()
})

$(document).ready(function() {
  var friends = $(\'#friends\').DataTable( {
    "paging": false ,
    "searching": false ,
    order: [[ 5, \'asc\' ], [ 2, \'desc\' ]]
  } );
  new $.fn.dataTable.FixedHeader( friends );

  var teams = $(\'#teams\').DataTable( {
    "paging": false ,
    "searching": false ,
    "ordering": false
  } );
  new $.fn.dataTable.FixedHeader( teams );

  var box = $(\'#box\').DataTable( {
    "paging": false ,
        fixedColumns: true,
    columnDefs: [ { type: \'alt-string\', targets: 0 } ],
    order: [[ 1, \'asc\' ], [ 4, \'desc\' ], [ 2, \'asc\' ], [ 0, \'desc\' ]]
  });
  new $.fn.dataTable.FixedHeader( box );

  var mats = $(\'#mats\').DataTable( {
    "paging": false ,
    columnDefs: [ { type: \'alt-string\', targets: 0 } ],
    order: [[ 1, \'asc\' ], [ 4, \'desc\' ], [ 2, \'asc\' ], [ 0, \'desc\' ]]
  } );
  new $.fn.dataTable.FixedHeader( mats );

  $(".collapse").on(\'shown.bs.collapse\', function(){
    box.fixedHeader.adjust();
    mats.fixedHeader.adjust();
    friends.fixedHeader.adjust();
    teams.fixedHeader.adjust();
  });

} );

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    document.getElementById("topbutton").style.display = "block";
  } else {
    document.getElementById("topbutton").style.display = "none";
  }
}
  
// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}

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

const observer = lozad();
observer.observe();

</script>
</body>
</html>';

my @mobileordered = sort {
  $mobilehash{$a}->{'mainattr'} <=> $mobilehash{$b}->{'mainattr'}
  or
  $mobilehash{$b}->{'rarity'} <=> $mobilehash{$a}->{'rarity'}
  or
  $mobilehash{$a}->{'subattr'} <=> $mobilehash{$b}->{'subattr'}
  or
  $mobilehash{$b}->{'id'} <=> $mobilehash{$a}->{'id'}
} keys %mobilehash;

my $mobileoutput = "<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'/>
</head>
<style>
.card {
  border: none;
  padding: 5px;
  vertical-align: top;
  position: relative;
  width: 98px;
  height: 98px;
  display: inline-block;
}

.card img {
  position: absolute;
  width: 98px;
  height: 98px;
}
</style>
<body>
<div class='container'>
  <div id='search'>
    <label for='filter-search'>Search : </label>
    <input type='text' placeholder='...' id='filter-search' />
  </div>
  <div id='gallery'>\n";
foreach my $mobileitem ( @mobileordered ) {
my $cleanname = $mobilehash{$mobileitem}->{'name'};
$cleanname =~ s/\"//g;
$mobileoutput .= "    <div class=\"card\" data-number=\"$mobilehash{$mobileitem}->{'id'}\" title=\"$cleanname\">";
$mobileoutput .= "<a href=\"$refurl$mobilehash{$mobileitem}->{'id'}\"><img class='lozad' data-src=\"/images/cards/card_$mobilehash{$mobileitem}->{'paddedid'}.png\" />";
if ( $mobilehash{$mobileitem}->{'subattr'} < 5 ) {
  $mobileoutput .= "<img class='lozad' data-src='/images/frames/frame_" . $mobilehash{$mobileitem}->{'mainattr'} . ".png' /><img class='lozad' data-src='/images/frames/sub_" . $mobilehash{$mobileitem}->{'subattr'} . ".png' /></a></div>\n";
} else {
  $mobileoutput .= "<img class='lozad' data-src='/images/frames/frame_" . $mobilehash{$mobileitem}->{'mainattr'} . ".png' /></a></div>\n";
}
}
$mobileoutput .= '  </div>
</div>

<script src="https://code.jquery.com/jquery-3.4.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lozad"></script>

<script>
(function () {
  var $imgs = $(\'#gallery .card\');
  var $search = $(\'#filter-search\');
  var cache = [];

  $imgs.each(function () {
    cache.push({
      element: this,
      text:  this.getAttribute(\'data-number\').trim().toLowerCase() + " " + this.title.trim().toLowerCase() });
  });

  function filter() {
    var query = this.value.trim().toLowerCase();
    cache.forEach(function (img) {
      var index = 0;
      if (query) {
        index = img.text.indexOf(query);
      }
      img.element.style.display = index === -1 ? \'none\' : \'\';
    });
  }
  if (\'oninput\' in $search[0]) {
    $search.on(\'input\', filter);
  } else {
    $search.on(\'keyup\', filter);
  }
}());

const observer = lozad();
observer.observe();
</script>
</body></html>';

#print "writing to file\n";
open (my $fh, '>:encoding(UTF-8)', "box/$userid.html");
  print $fh $output;
close $fh;

open (my $mobilefile, '>', "m/$userid.html");
  print $mobilefile $mobileoutput;
close $mobilefile;

print "done";
