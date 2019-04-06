import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RemPlusComponent } from './rem-plus.component';

describe('RemPlusComponent', () => {
  let component: RemPlusComponent;
  let fixture: ComponentFixture<RemPlusComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RemPlusComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RemPlusComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
