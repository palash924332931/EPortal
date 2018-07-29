import { Component, OnInit } from '@angular/core';
import { LockedDefinition, Client } from '../unlock/unlock.model';
import { UnlockService } from '../unlock/unlock.service';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { AlertService } from '../shared/component/alert/alert.service'
declare var jQuery: any;

@Component({
    selector: 'app-unlock',
    templateUrl: '../../app/unlock/unlock.component.html',
    providers: [UnlockService]
})

export class UnlockComponent implements OnInit {
    unlockTableSetting: any;
    unlockModuleDetails: LockedDefinition[] = [];
    clients: Client[] = [];
    selectedClientID: number = 0;
    isUnlockDisabled: boolean = true;

    constructor(private unlockService: UnlockService, private alertService: AlertService) {

    }

    ngOnInit() {
        //Load clients dropdown list
        this.loadClients();

        //Configure unlock table
        this.configureUnlockTable();

        //Load locked definitions
        this.loadUnlockTable();

    }

    //Load client dropdown
    loadClients() {
        this.unlockService.getAllClients()
            .subscribe(data => {
                if (data != null)
                    this.clients = data;
            }, error => {

            });
    }

    //load locked definitions
    loadUnlockTable() {
        this.isUnlockDisabled = true;
        this.unlockService.getLockedDefinitions(this.selectedClientID)
            .subscribe(data => {
                if (data != null)
                    this.unlockModuleDetails = data;
                else
                    this.unlockModuleDetails = [];
            }, error => {

            });
    }

    //unlock definitions
    unlockDeliverables() {
        let lockHistoriesID: number[] = this.getSelectedHistoriesID();
        if (lockHistoriesID.length > 0) {
            this.unlockService.unlockDefinitions(lockHistoriesID)
                .subscribe((data: boolean) => {
                    if (data) {
                        this.alertService.alert("Successfully Unlocked");
                        this.loadUnlockTable();
                    }
                }, (error: any) => {
                });
        }
    }

    //get selected definition
    getSelectedHistoriesID(): number[] {
        let lockHistoriesID: number[] = [];
        jQuery("#unlock-table tbody tr .p-table-checkbox .checkbox-unlock-table").each((i, ele) => {
            if (jQuery(ele).prop("checked") == true) {
                let historyID = jQuery(ele).attr("data-sectionvalue");
                lockHistoriesID.push(historyID);
            }
        });
        return lockHistoriesID;
    }

    //configure unlock table
    configureUnlockTable() {
        this.unlockTableSetting = {
            tableID: "unlock-table",
            tableClass: "table table-border ",
            tableName: "Unlock Module",
            tableRowIDInternalName: "LockHistoryID",
            tableColDef: [
                { headerName: 'Module', width: '25%', internalName: 'Module', className: "dynamic-module", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
                { headerName: 'Name', width: '25%', internalName: 'Name', className: "dynamic-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'ID', width: '10%', internalName: 'ID', className: "dynamic-id", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Locked By', width: '20%', internalName: 'LockedBy', className: "dynamic-locked-by", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Locked Time', width: '20%', internalName: 'LockedTime', className: "dynamic-locked-time", sort: true, type: "", onClick: "", visible: true },
            ],
            enabledCellClick: true,
            enableSerialNo: false,
            enableSearch: true,
            enablePagination: true,
            pageSize: 500,
            displayPaggingSize: 10,
            enabledStaySeletedPage: true,
            enablePTableDataLength: false,
            enableCheckbox: true
        };
    }
    
    fnIndividualCheckboxAction(event: any) {
        let lockHistoriesID: number[] = this.getSelectedHistoriesID();
        if (lockHistoriesID.length > 0)
            this.isUnlockDisabled = false;
        else
            this.isUnlockDisabled = true;
    }
}