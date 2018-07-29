import { Component, Input } from '@angular/core';

@Component({
    selector: 'components',
    templateUrl: '../../app/components/components.component.html',
    providers: []
})
export class ComponentsComponent {
    atc4Selected: any[] = [];

    onSelected(atc4: any) {
        if (atc4 != undefined && atc4.ATC4_Code != undefined) {
            this.atc4Selected.push(atc4);
        }
    }

    constructor() { }
}