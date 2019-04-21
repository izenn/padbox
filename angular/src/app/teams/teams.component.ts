import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { constructCardImg, TeamData } from '../../utils/utils';

import * as padJson from '../../assets/pad.json';
const mappedCards = {}; 
for(let card of padJson.card) {
  mappedCards[card[0]] = card;
}

@Component({
  selector: 'app-teams',
  templateUrl: './teams.component.html',
  styleUrls: ['./teams.component.css']
})
export class TeamsComponent implements OnInit {

  displayedColumns: string[] = ['team', 'leader', 'sub1', 'sub2', 'sub3', 'sub4', 'helper', 'badge'];
  dataSource: MatTableDataSource<TeamData>;

  constructor() {
    const teams = parseTeamData();
    this.dataSource = new MatTableDataSource(teams);
  }

  ngOnInit() {}

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }
}

function parseTeamData() {
  const teamData = [];
  let teamNumber = 1;
  for(let deck of padJson.decksb.decks) {
    let teamDataElement: TeamData = {};
    teamDataElement.number = teamNumber.toString();
    if(mappedCards[deck[0]]) {
      const cardId = mappedCards[deck[0]][5].toString().padStart(5, "0");
      teamDataElement.leader = constructCardImg(cardId);
    }
    if(mappedCards[deck[1]]) {
      const cardId = mappedCards[deck[1]][5].toString().padStart(5, "0");
      teamDataElement.sub1 = constructCardImg(cardId);
    }
    if(mappedCards[deck[2]]) {
      const cardId = mappedCards[deck[2]][5].toString().padStart(5, "0");
      teamDataElement.sub2 = constructCardImg(cardId);
    }
    if(mappedCards[deck[3]]) {
      const cardId = mappedCards[deck[3]][5].toString().padStart(5, "0");
      teamDataElement.sub3 = constructCardImg(cardId);
    }
    if(mappedCards[deck[4]]) {
      const cardId = mappedCards[deck[4]][5].toString().padStart(5, "0");
      teamDataElement.sub4 = constructCardImg(cardId);
    }
    if(mappedCards[deck[6]]) {
      const cardId = mappedCards[deck[6]][5].toString().padStart(5, "0");
      teamDataElement.helper = constructCardImg(cardId);
    }
    teamDataElement.badge = deck[5] ? deck[5].toString() : null;
    teamData.push(teamDataElement);
    teamNumber++;
  }
  return teamData;
}

