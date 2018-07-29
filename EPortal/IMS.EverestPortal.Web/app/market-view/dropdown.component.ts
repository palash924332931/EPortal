import {Component, Input, Output, EventEmitter} from '@angular/core';
export class DropdownValue {
    value: string;
    label: string;

    constructor(value: string, label: string) {
        this.value = value;
        this.label = label;
    }
}
declare var jQuery: any;

@Component({
    selector: 'dropdown',
    template: `
      <div class="btn-group">
          <button class="btn dropdown-toggle" data-toggle="dropdown">Select <span class="caret"></span></button>
          <ul class="dropdown-menu">
            <li  *ngFor="let value of values"><a href="#" id="action-1" class="{{value.value}}" (click)="selectItem(value)">{{value.label}}</a></li>
          </ul>
     </div>
  `
})
//declare var jQuery: any;
export class DropdownComponent {
    @Output()
    ddOnChange: EventEmitter<string> = new EventEmitter<string>();
    @Input()
    values: DropdownValue[];

    

    //constructor() {
    //    this.ddOnChange = new EventEmitter();
    //}

    selectItem(value: any) {
        if (value == "select") {
            jQuery("button.dropdown-toggle").html("Select <span class='caret'></span>");
            return false;
        } else {
            jQuery("button.dropdown-toggle").html(value.label + " <span class='caret'></span>");
        }
        this.ddOnChange.emit(value);
        return false;
    }
}