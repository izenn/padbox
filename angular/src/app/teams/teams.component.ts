import { Component, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource } from '@angular/material';

export interface CardImg {
  frame: string,
  sub: string,
  src: string,
  name: string
}

export interface TeamData {
  number: string,
  leader: CardImg,
  sub1: CardImg,
  sub2: CardImg,
  sub3: CardImg,
  sub4: CardImg,
  helper: CardImg,
  badge: string
}

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

    // Assign the data to the data source for the table to render
    this.dataSource = new MatTableDataSource(teams);
  }

  ngOnInit() {}

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }
}


function parseTeamData() {
  const baseUrl = "https://raw.githubusercontent.com/izenn/padbox/master/images/";
  const cardUrl = `${baseUrl}cards/`;
  const frameUrl = `${baseUrl}frames/`;
  const teamData = [];
  let teamNumber = 1;
  for(let deck of padJson.decksb.decks) {
    let teamDataElement: TeamData = {number: null, leader: null, sub1: null, sub2: null, sub3: null, sub4: null, helper: null, badge: null};
    teamDataElement.number = teamNumber.toString();
    teamDataElement.leader = mappedCards[deck[0]] ? {
      frame: "",
      sub: "",
      src: `${cardUrl}card_${mappedCards[deck[0]][5].toString().padStart(5, "0")}.png`,
      name: ""
    } : null;
    teamDataElement.sub1 = mappedCards[deck[1]] ? {
      frame: "",
      sub: "",
      src: `${cardUrl}card_${mappedCards[deck[1]][5].toString().padStart(5, "0")}.png`,
      name: ""
    } : null;
    teamDataElement.sub2 = mappedCards[deck[2]] ? {
      frame: "",
      sub: "",
      src: `${cardUrl}card_${mappedCards[deck[2]][5].toString().padStart(5, "0")}.png`,
      name: ""
    } : null;
    teamDataElement.sub3 = mappedCards[deck[3]] ? {
      frame: "",
      sub: "",
      src: `${cardUrl}card_${mappedCards[deck[3]][5].toString().padStart(5, "0")}.png`,
      name: ""
    } : null;
    teamDataElement.sub4 = mappedCards[deck[4]] ? {
      frame: "",
      sub: "",
      src: `${cardUrl}card_${mappedCards[deck[4]][5].toString().padStart(5, "0")}.png`,
      name: ""
    } : null;
    teamDataElement.helper = mappedCards[deck[6]] ? {
      frame: "",
      sub: "",
      src: `${cardUrl}card_${mappedCards[deck[6]][5].toString().padStart(5, "0")}.png`,
      name: ""
    } : null;
    teamDataElement.badge = deck[5] ? deck[5].toString() : null;
    teamData.push(teamDataElement);
    teamNumber++;
  }
  return teamData;
}
