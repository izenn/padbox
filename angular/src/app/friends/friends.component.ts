import { Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator, MatSort, MatTableDataSource } from '@angular/material';
import { CardImg, UserData } from '../../utils/utils';

import * as padJson from '../../assets/pad.json';

@Component({
  selector: 'app-friends',
  templateUrl: './friends.component.html',
  styleUrls: ['./friends.component.css']
})
export class FriendsComponent implements OnInit {

  displayedColumns: string[] = ['id', 'name', 'level', 'active', 'slot1', 'slot2'];
  dataSource: MatTableDataSource<UserData>;

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor() {
    const friends = parseFriendData();

    // Assign the data to the data source for the table to render
    this.dataSource = new MatTableDataSource(friends);
  }

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }
}

/** Builds and returns a new User. */
function parseFriendData(): UserData[] {
  const friendsData: UserData[] = [];
  for(let friend of padJson.friends) {
    const newFriend = {
      id: friend[1].toString(),
      name: friend[2].toString(),
      level: friend[3].toString(),
      active: "",
      slot1: "",
      slot2: ""
    };
    const baseUrl = "https://raw.githubusercontent.com/izenn/padbox/master/images/cards/";
    newFriend.active = `${baseUrl}card_0${friend[16]}.png`;
    newFriend.slot1 = `${baseUrl}card_0${friend[31]}.png`;
    if(friend[14] === 1) {
      newFriend.slot2 = `${baseUrl}card_0${friend[46]}.png`;
    } 
    friendsData.push(newFriend);
  };

  return friendsData;
}
