import { Component, OnInit, ViewChild } from '@angular/core';
import {MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

export interface UserData {
  id: string;
  name: string;
  level: string,
  active: string,
  slot1: string,
  slot2: string,
}

/** Constants used to fill up our data base. */
const NAMES: string[] = ['Maia', 'Asher', 'Olivia', 'Atticus', 'Amelia', 'Jack',
  'Charlotte', 'Theodore', 'Isla', 'Oliver', 'Isabella', 'Jasper',
  'Cora', 'Levi', 'Violet', 'Arthur', 'Mia', 'Thomas', 'Elizabeth'];

import * as padJson from '../../assets/pad.json';
console.log(padJson);

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
    console.log(friend);
    friendsData.push({
      id: friend[1].toString(),
      name: friend[2].toString(),
      level: friend[3].toString(),
      active: "",
      slot1: "",
      slot2: ""
    });
  };

  return friendsData;
}
