import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { BrowserModule } from '@angular/platform-browser';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatPaginatorModule } from '@angular/material/paginator'; 
import { MatSortModule } from '@angular/material/sort';
import { MatTableModule } from '@angular/material/table'; 
import { MatTabsModule } from '@angular/material/tabs';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { FriendsComponent } from './friends/friends.component';
import { RemPlusComponent } from './rem-plus/rem-plus.component';
import { MatsComponent } from './mats/mats.component';

@NgModule({
  declarations: [
    AppComponent,
    FriendsComponent,
    RemPlusComponent,
    MatsComponent
  ],
  imports: [
    BrowserModule, // This needs to be first.
    AppRoutingModule,
    BrowserAnimationsModule,
    MatFormFieldModule,
    MatInputModule,
    MatPaginatorModule,
    MatSortModule,
    MatTableModule,
    MatTabsModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
