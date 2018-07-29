/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { MarketbasePacksComponent } from './marketbase-packs.component';

describe('MarketbasePacksComponent', () => {
  let component: MarketbasePacksComponent;
  let fixture: ComponentFixture<MarketbasePacksComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MarketbasePacksComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MarketbasePacksComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
