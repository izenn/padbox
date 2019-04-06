import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatsComponent } from './mats.component';

describe('MatsComponent', () => {
  let component: MatsComponent;
  let fixture: ComponentFixture<MatsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
