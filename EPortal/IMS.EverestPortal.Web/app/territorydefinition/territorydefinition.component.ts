import { Component, OnInit, OnChanges } from '@angular/core';
import { Http } from '@angular/http';
import { NgForm } from '@angular/forms';
import { TerritoryDefinitionService } from '../shared/services/territorydefinition.service';
import { Territory, Level, Group, Allocation } from './territorydefinition.model';


@Component({
    selector: 'territorydefinition',
    templateUrl: '../../app/territorydefinition/territorydefinition.component.html',
    providers: [TerritoryDefinitionService],
    styleUrls: ['../../app/territorydefinition/territorydefinition.component.css']

})
export class TerritoryDefinitionComponent implements OnInit, OnChanges {


    territory: Territory = new Territory(0, '', 0, new Level(0, '', null, null), new Group(0, '', 0, 0));
    errorMessage: string;    
    title: string = "Create new Territory ";

    GroupId(group: Group): string { return group.GroupIdPrefix.toString(); }

    constructor(private _territoryService: TerritoryDefinitionService) {

    }

    ngOnInit(): void {
        this.getTerritory();
    }
    ngOnChanges(changes: any) {
        
    }
    onSave() {
        
    };

    
    getTerritory(): void {

        this._territoryService.getTerritoryDefinition()
            .subscribe(territory => { this.territory = territory; console.dir(this.territory);}, error => this.errorMessage = <any>error);
    
    }

    private assign(territory: Territory): void {
        alert(territory);
        this.territory = territory;
    }

    
}
