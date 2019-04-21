import { Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator, MatSort, MatTableDataSource } from '@angular/material';
import { constructCardImg, UserData } from '../../utils/utils';

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
  const promises = [];
  for(let friend of padJson.friends) {
    const newFriend = {
      id: friend[1].toString(),
      name: friend[2].toString(),
      level: friend[3].toString(),
      active: null,
      slot1: null,
      slot2: null
    };
    newFriend.active = constructCardImg(friend[16].toString().padStart(5, "0"));
    newFriend.slot1 = constructCardImg(friend[31].toString().padStart(5, "0"));
    if(friend[14] === 1) {
      newFriend.slot2 = constructCardImg(friend[46].toString().padStart(5, "0"));
    } 
    friendsData.push(newFriend);
  };

  return friendsData;
}
