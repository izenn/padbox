import { Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator, MatTableDataSource, PageEvent } from '@angular/material';
import { constructCardImg, getCardData, RemData } from '../../utils/utils';

import * as padJson from '../../assets/pad.json';

@Component({
  selector: 'app-rem-plus',
  templateUrl: './rem-plus.component.html',
  styleUrls: ['./rem-plus.component.css']
})
export class RemPlusComponent implements OnInit {

  displayedColumns: string[] = ['img', 'name', 'rarity', 'level', 
    'type', 'evo', 'skill', 'awoken', 'latent', 'hp', 'atk', 'rcv', 'mp'];
  dataSource: MatTableDataSource<RemData>;

  @ViewChild(MatPaginator) paginator: MatPaginator;

  constructor() {
    const rem = parseRemData();

    // Assign the data to the data source for the table to render
    this.dataSource = new MatTableDataSource(rem);
  }

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
    this.paginator.page.subscribe((event: PageEvent) => this.pageChanged(event));
    for(let i = 0; i < 5; i++) {
      loadRemData(this.dataSource.data[i]);
    }
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  pageChanged(event?: PageEvent) {
    const start = event.pageIndex * event.pageSize;
    const end = start + event.pageSize; 
    for(let i = start; i < end; i++) {
      loadRemData(this.dataSource.data[i]);
    }
  }
}

function parseRemData() {
  const remData = [];
  for(let card of padJson.card) {
    let remDataElement: RemData = {};
    remDataElement.id = card[5].toString().padStart(5, "0");
    remDataElement.level = card[2].toString();
    remDataElement.skillLevel = card[3] ? card[3].toString() : "0";
    remDataElement.awokenLevel = card[9] ? card[9].toString() : "0";
    remDataElement.hp = card[6].toString();
    remDataElement.atk = card[7].toString();
    remDataElement.rcv = card[8].toString();
    remData.push(remDataElement);
  }
  return remData;
}

const baseUrl = "https://raw.githubusercontent.com/izenn/padbox/master/images/";
const cardUrl = `${baseUrl}cards/`;
const frameUrl = `${baseUrl}frames/`;
const badgeUrl = `${baseUrl}badges/`;
const badgeTypes = ['evo', 'balanced', 'physical', 'healer', 'dragon', 'god', 
  'attacker', 'devil', 'machine', 'awoken', 'enhance', 'redeemable'];

function loadRemData(card: RemData) {
  getCardData(card.id).then(cardData => {
    card.img = constructCardImg(card.id);
    card.name = cardData.card.name;
    card.rarity = cardData.card.rarity;
    card.type = [];
    if(cardData.card.type_1_id > -1) {
      card.type.push(cardData.card.type_1_id);
    }
    if(cardData.card.type_2_id > -1) {
      card.type.push(cardData.card.type_2_id);
    }
    if(cardData.card.type_3_id > -1) {
      card.type.push(cardData.card.type_3_id);
    }
    card.type = card.type.map(num => {
      return `${badgeUrl}${badgeTypes[num]}.png`;
    });
    card.evo = "Not implemented";
    card.skillMax = cardData.active_skill.levels ? cardData.active_skill.levels : "0";
    card.awokenMax = cardData.card.awakenings ? cardData.card.awakenings.length.toString() : "0";
    card.mp = cardData.card.sell_mp;
  });
}