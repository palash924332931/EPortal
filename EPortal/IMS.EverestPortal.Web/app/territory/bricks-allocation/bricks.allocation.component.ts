import { Component, OnInit, OnChanges, Input, Output, EventEmitter } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Http } from '@angular/http';
import { TerritoryDefinitionService } from '../../shared/services/territorydefinition.service';
import { OutletBrick, OutletBrickAllocation, OutletBrickAllocationCount } from '../../shared/models/territory/brick-allocation';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../../security/auth.service';

declare var jQuery: any;

@Component({
    selector: 'bricks-allocation',
    templateUrl: '../../../app/territory/bricks-allocation/bricks.allocation.component.html',
    styleUrls: ['../../../app/territory/bricks-allocation/bricks.allocation.component.css']

})
export class BricksAllocationComponent implements OnInit {
    @Input() territoryCurrentNodes: OutletBrickAllocationCount[] = [];
    @Input() levelName: string = "";
    @Input() brickOutletType: string;
    @Input() brickDetailsUnderTerritory: OutletBrickAllocation[] = [];
    @Input() territory: any;
    @Input() territoryNodes: OutletBrickAllocationCount[] = [];
    @Input() availbleBricks: OutletBrick[] = [];
    @Input() isEditTerritoryDef: boolean = false;
    @Input() isNewBrickCreation: boolean = true;
    @Input() isIMSStandardStructure: boolean = false;
    @Input() isInternalClientAccess: boolean = false;
    @Output() fnTerritoryCallBack: EventEmitter<any> = new EventEmitter<any>() || null;
    public tempAvailableBricks: OutletBrick[] = [];
    public tempBrickDetailsUnderTerritory: OutletBrickAllocation[] = [];
    public tempTerritoryNodes: OutletBrickAllocationCount[] = [];

    public availableBricksTableBind: any;
    public availableOutletTableBind: any;
    public brickDetailsTableBind: any;
    public territoryListTableBind: any;
    public enabledReallocateBtn: boolean = false;
    public enableBrickAllocationBtn: boolean = false;
    public enabledBrickSection: boolean = true;
    public ddReallocationData: OutletBrickAllocationCount[] = [];

    public selectedTerritoryRecord: OutletBrickAllocationCount[] = [];
    public selectedTerritoryRecordToShowTable: OutletBrickAllocationCount[] = [];
    public territoryListData: OutletBrickAllocationCount[];
    public selectedAvailableBricks: OutletBrick[] = [];
    public newTerritoryDefId: number = 0;
    //public brickDetailsUnderTerritory:OutletBrickAllocation[]=[];      

    public bricksDetailsOfSelectedTerritory: OutletBrickAllocation[] = [];
    //for modal
    public modalID: string = "modalBrickAllocation";
    public modalSaveBtnVisibility: boolean = false;
    public modalSaveFnParameter: string = "";
    public modalTitle: string = "Modal Title";

    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Close";

    public modalID_OK: string = "modalAllocationOK";
    public modalSaveBtnVisibility_OK: boolean = false;
    public modalSaveFnParameter_OK: string = "";

    public modalTitle_OK: string = "Modal Title";
    public modalBtnCapton_OK: string = "Save";
    public modalCloseBtnCaption_OK: string = "Close";
    public territoryTableColumnDef: any[] = []

    //for user role info
    public userRole: string = '';

    constructor(private _cookieService: CookieService, private territoryService: TerritoryDefinitionService, private router: Router, private authService: AuthService) { }

    ngOnInit(): void {

        this.territoryService.fnSetLoadingAction(true);
        this._getUserRole();

        //to bind available Bricks table
        this.fnBindAvailableBricksTable();

        //to bind available outlet table
        this.fnBindAvailableOutletsTable();

        //for territory list table

        //to bind dynamic column of territory node table
        this.fnBindTerritoryNodesTable();

        //to bind assigned bricks/outlets table
        this.fnBindAssignedBricksOutletsTable();


        //territory node compare with previous state

        // if (this.territoryNodes.length > 0) {
        if (this.isEditTerritoryDef) {//to check old or new territory
            //console.log("Edit territory Def.....");
            this.fnReassignBricksOutletsForTerritoryNodes();
            this.fnAssignInTempVaiable();//to assign in temp
        } else if (this.isIMSStandardStructure) {
            this.fnPullBricksOutlets();
            //to assign in temp
            this.fnAssignInTempVaiable();

            //to assign nodes
            this.territoryNodes = JSON.parse(JSON.stringify(this.territoryCurrentNodes));
            //brick count to 
            this.territoryNodes.forEach((record: OutletBrickAllocationCount) => {
                record.BrickOutletCount = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation) => { if (record.NodeCode == rec.NodeCode) { return true } else { return false } }).length || 0;
            });
        }
        else {
            //console.log("reset all nodes type:" + this.brickOutletType);
            this.territoryNodes = JSON.parse(JSON.stringify(this.territoryCurrentNodes));
            this.fnPullBricksOutlets();
            //to assign in temp
            this.fnAssignInTempVaiable();

            //console.log("this.territoryNodes 2" + JSON.stringify(this.territoryNodes));
            this.territoryService.isChangeDetectedInTerritoryDef = this.fnChangeDetectedInBrickAllocation();
            this.authService.hasUnSavedChanges = true;
        }

    }

    private _getUserRole() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            this.userRole = usrObj.RoleName;
        }
    }

    fnTerritoryListTableRadioButtonClick(event: any) {
        if (jQuery(".checkbox-available-bricks-table:checked").length > 0 && jQuery(".radio-territory-list-table:checked").length > 0) {
            this.enableBrickAllocationBtn = true;
        } else {
            this.enableBrickAllocationBtn = false;
        }
        this.selectedTerritoryRecord = event.record || [];
        this.selectedTerritoryRecordToShowTable = event.record || [];
        this.bricksDetailsOfSelectedTerritory = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation, index: any) => {
            if (rec.NodeCode == event.record.NodeCode) {
                return true;
            } else {
                return false;
            }
        });

        //console.log(this.bricksDetailsOfSelectedTerritory);
    }

    fnTerritoryListTableCheckboxClick(event: any) {
        //console.log(event);
        //console.log("values checkbox :" + JSON.stringify(event) + " checkbox length" + jQuery(".checkbox-available-bricks-table:checked").length + " radio button checked: " + jQuery(".radio-territory-list-table:checked").length);
        if (jQuery(".checkbox-available-bricks-table:checked").length > 0 && jQuery(".radio-territory-list-table:checked").length > 0) {
            this.enableBrickAllocationBtn = true;
        } else {
            this.enableBrickAllocationBtn = false;
        }
    }

    fnBackToTerritoryViewPage() {
        if (JSON.stringify(this.territoryNodes) == JSON.stringify(this.tempTerritoryNodes) && JSON.stringify(this.brickDetailsUnderTerritory) == JSON.stringify(this.tempBrickDetailsUnderTerritory)) {
            this.fnTerritoryCallBack.emit({ AssignedNodes: this.territoryNodes, enabledBrickCreation: true, brickDetailsUnderTerritory: this.brickDetailsUnderTerritory, availbleBricks: this.availbleBricks, isEditTerritoryDef: this.isEditTerritoryDef, newTerritoryDefId: this.newTerritoryDefId });
        } else {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "Save Territory Def from Back Btn";
            this.modalTitle = "Changes have been made to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation, please save these.";
            this.modalBtnCapton = "Save";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#" + this.modalID).modal("show");
        }


    }

    fnAllocateBricks() {
        //console.log("allocation brickes");
        let selectedAvaialbeBricks: any[] = [];
        //selected items pushed in array
        jQuery("#available-bricks-table tbody tr .checkbox-available-bricks-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                //console.log("selected ID" + jQuery(this).attr("data-sectionvalue"));
                selectedAvaialbeBricks.push(jQuery(this).attr("data-sectionvalue"));
            }
        });

        //assign bricks in territory
        //console.log(this.selectedTerritoryRecord);
        selectedAvaialbeBricks.forEach((rec: any) => {
            this.availbleBricks.every((record: OutletBrick, index: any) => {
                //console.log("record.Code" + record.Code + ":: rec" + rec);
                if (record.Code == rec) {
                    /*this.brickDetailsUnderTerritory.push({
                        NodeCode: this.selectedTerritoryRecord["NodeCode"], NodeName: this.selectedTerritoryRecord["NodeName"], BrickOutletCode: record.Code, Address: record.Address, BrickOutletName: record.Name, LevelName: this.selectedTerritoryRecord["LevelName"],
                        CustomGroupNumberSpace: this.selectedTerritoryRecord["CustomGroupNumberSpace"], Type: this.brickOutletType
                    });*/
                    this.brickDetailsUnderTerritory.push({
                        NodeCode: this.selectedTerritoryRecord["NodeCode"], NodeName: this.selectedTerritoryRecord["NodeName"], BrickOutletCode: record.Code, Address: record.Address, BannerGroup: record.BannerGroup, State: record.State, Panel: record.Panel, BrickOutletName: record.Name, LevelName: this.selectedTerritoryRecord["LevelName"], BrickOutletLocation: record.BrickOutletLocation,
                        CustomGroupNumberSpace: this.selectedTerritoryRecord["CustomGroupNumberSpace"], Type: this.brickOutletType
                    });
                    this.availbleBricks.splice(this.availbleBricks.indexOf(record), 1);// to remove selected record
                    this.territoryNodes.every((trritoryRecord: OutletBrickAllocationCount, index: any) => {
                        if (trritoryRecord.NodeCode == this.selectedTerritoryRecord["NodeCode"]) {
                            trritoryRecord.BrickOutletCount = trritoryRecord.BrickOutletCount + 1;//to increment bricks number
                        } else {
                            return true;
                        }
                    });
                    return false;
                } else {
                    return true;
                }

            });
        });

        // repopulate brick details array
        this.selectedTerritoryRecordToShowTable = JSON.parse(JSON.stringify(this.selectedTerritoryRecord));
        this.bricksDetailsOfSelectedTerritory = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation, index: any) => {
            //console.log("rec.TerritoryCode" + rec.BrickOutletCode + ": event.Code" + this.selectedTerritoryRecord["NodeCode"]);
            if (rec.NodeCode == this.selectedTerritoryRecord["NodeCode"]) {
                return true;
            } else {
                return false;
            }
        });

        //disabled allocate brick btn
        this.enableBrickAllocationBtn = false;

        this.territoryService.isChangeDetectedInTerritoryDef = this.fnChangeDetectedInBrickAllocation();
        this.authService.hasUnSavedChanges = true;
    }


    fnDeleteAllocatedBricks() {
        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "Delete Bricks From BricksDetails Table";
        this.modalTitle = "Deleting the selected " + this.brickOutletType.toLowerCase() + "(s) will move the " + this.brickOutletType.toLowerCase() + "(s) to the Available " + this.brickOutletType + "s list. Do you want to proceed?";
        this.modalBtnCapton = "Yes";
        this.modalCloseBtnCaption = "Cancel";
        jQuery("#" + this.modalID).modal("show");
    }

    fnReallocateBricks() {
        this.ddReallocationData = this.territoryNodes.filter((rec: OutletBrickAllocationCount) => {
            if (rec.NodeName == this.selectedTerritoryRecordToShowTable["NodeName"]) {
                return false;
            } else {
                return true;
            }
        });
        jQuery("#reallocate").modal("show");
    }

    fnModalConfirmationClick(event: any) {
        if (event == "Delete Bricks From BricksDetails Table") {
            jQuery("#" + this.modalID).modal("hide");
            this.territoryService.fnSetLoadingAction(true);
            let selectedTerritoryBrickDetails: any[] = [];
            //selected items pushed in array
            jQuery("#brick-details-table tbody tr .checkbox-brick-details-table").each(function () {
                if (jQuery(this).prop("checked") == true) {
                    //console.log("selected ID" + jQuery(this).attr("data-sectionvalue"));
                    selectedTerritoryBrickDetails.push(jQuery(this).attr("data-sectionvalue"));
                }
            });

            //remove from the details table
            selectedTerritoryBrickDetails.forEach((rec: any) => {
                this.brickDetailsUnderTerritory.every((record: OutletBrickAllocation, index: any) => {
                    if (record.BrickOutletCode == rec && record.NodeCode == this.selectedTerritoryRecordToShowTable["NodeCode"]) {
                        //this.availbleBricks.push({ Code: record.BrickOutletCode, Name: record.BrickOutletName, Address: record.Address, Type: this.brickOutletType });
                        this.availbleBricks.push({ Code: record.BrickOutletCode, Name: record.BrickOutletName, Address: record.Address, BannerGroup: record.BannerGroup, State: record.State, Panel: record.Panel, BrickOutletLocation: record.BrickOutletLocation, Type: this.brickOutletType });
                        this.brickDetailsUnderTerritory.splice(this.brickDetailsUnderTerritory.indexOf(record), 1);// to remove selected record
                        this.territoryNodes.every((trritoryRecord: OutletBrickAllocationCount, index: any) => {//to decrement bricks number
                            if (trritoryRecord.NodeCode == this.selectedTerritoryRecordToShowTable["NodeCode"]) {
                                trritoryRecord.BrickOutletCount = trritoryRecord.BrickOutletCount - 1;
                            } else {
                                return true;
                            }
                        });
                        return false;
                    } else {
                        return true;
                    }
                });
            });

            // repopulate brick details array
            this.bricksDetailsOfSelectedTerritory = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation, index: any) => {
                if (rec.NodeCode == this.selectedTerritoryRecordToShowTable["NodeCode"]) {
                    return true;
                } else {
                    return false;
                }
            });
            this.enabledReallocateBtn = false;
            this.territoryService.fnSetLoadingAction(false);
        } else if (event == "Back to Previous State") { //back to previous state            
            jQuery("#" + this.modalID).modal("hide");
            this.territoryService.fnSetLoadingAction(true);
            this.availbleBricks = JSON.parse(JSON.stringify(this.tempAvailableBricks)) || [];
            this.brickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.tempBrickDetailsUnderTerritory)) || [];
            this.territoryNodes = JSON.parse(JSON.stringify(this.tempTerritoryNodes)) || [];
            this.selectedTerritoryRecord = [];
            this.selectedTerritoryRecordToShowTable = [];
            this.territoryService.fnSetLoadingAction(false);

        } else if (event == "Save Territory Def") {
            if (this.isEditTerritoryDef) {
                jQuery("#" + this.modalID).modal("hide");
                this.territoryService.fnSetLoadingAction(true);
                this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
                this.tempBrickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.brickDetailsUnderTerritory)) || [];
                this.tempTerritoryNodes = JSON.parse(JSON.stringify(this.territoryNodes)) || [];
                this.territory.OutletBrickAllocation = this.brickDetailsUnderTerritory;
                this.territoryService.editTerritory(this.territory.Client_Id, this.territory.Id, this.territory).subscribe((data: any) => {
                    this.territoryService.fnSetLoadingAction(false);
                    if (this.isIMSStandardStructure) {//message for IMS standard structure
                        // this.modalSaveBtnVisibility = false;
                        // this.modalSaveFnParameter = "";
                        // this.modalTitle = "<b>IMS Standard " + this.brickOutletType + "  Structure</b> has been saved successfully.";
                        // this.modalCloseBtnCaption = "Ok";
                        // jQuery("#" + this.modalID).modal("show");
                    } else {
                        this.modalSaveBtnVisibility_OK = false;
                        this.modalSaveFnParameter_OK = "";
                        // this.modalTitle_OK = "Changes made to the " + this.brickOutletType.toLowerCase() + " allocation have been applied.";
                        this.modalTitle_OK = "Changes have been saved for the territory.";
                        this.modalCloseBtnCaption_OK = "Ok";

                        jQuery("#" + this.modalID_OK).modal("show");
                        // alert("Changes have been saved for the territory.");
                    }

                    this.newTerritoryDefId = data[0].Id;
                    this.territory.Id = data[0].Id;
                    this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + '/Edit Lock']);
                    //TerritoryComponent.territoryNodes=

                },
                    (err: any) => {
                        this.territoryService.fnSetLoadingAction(false);
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalTitle = "System has been failed to save territory information. Please try again.";
                        this.modalCloseBtnCaption = "Ok";
                        jQuery("#" + this.modalID).modal("show");
                        console.log(err);
                    }
                );
            } else {
                jQuery("#" + this.modalID).modal("hide");
                this.territoryService.fnSetLoadingAction(true);
                this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
                this.tempBrickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.brickDetailsUnderTerritory)) || [];
                this.tempTerritoryNodes = JSON.parse(JSON.stringify(this.territoryNodes)) || [];
                this.territory.OutletBrickAllocation = this.brickDetailsUnderTerritory;
                this.territoryService.postTerritory(this.territory.Client_Id, this.territory).subscribe((data: any) => {
                    this.territoryService.fnSetLoadingAction(false);
                    if (this.isIMSStandardStructure) {//message for IMS standard structure
                        // this.modalSaveBtnVisibility = false;
                        // this.modalSaveFnParameter = "";
                        // this.modalTitle = "<b>IMS Standard " + this.brickOutletType + "  Structure</b> has been saved successfully.";
                        // this.modalCloseBtnCaption = "Ok";
                        // jQuery("#" + this.modalID).modal("show");
                    } else {
                        this.modalSaveBtnVisibility_OK = false;
                        this.modalSaveFnParameter_OK = "";
                        // this.modalTitle_OK = "Changes made to the " + this.brickOutletType.toLowerCase() + " allocation have been applied.";
                        this.modalTitle_OK = "Changes have been saved for the territory.";
                        this.modalCloseBtnCaption_OK = "Ok";

                        jQuery("#" + this.modalID_OK).modal("show");
                        // alert("Changes have been saved for the territory.");
                    }
                    this.isEditTerritoryDef = true;
                    this.newTerritoryDefId = data[0].Id;
                    this.territory.Id = data[0].Id;
                    this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + '/Edit Lock']);

                },
                    (err: any) => {
                        this.territoryService.fnSetLoadingAction(false);
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalTitle = "System has been failed to save territory information. Please try again.";
                        this.modalCloseBtnCaption = "Ok";
                        jQuery("#" + this.modalID).modal("show");
                        console.log(err);
                    }
                );
            }

        }
        else if (event == "Save Territory Def from Back Btn") {
            //jQuery("#" + this.modalID).modal("hide");
            this.territoryService.fnSetLoadingAction(true)
            let everyNodeHasBrick: boolean = true;
            this.territoryNodes.every((record: OutletBrickAllocationCount, index: any) => {//to check node has brick
                if (record.BrickOutletCount > 0) {
                    everyNodeHasBrick = true;
                    return true;
                } else {
                    everyNodeHasBrick = false;
                    return false;
                }
            });

            if (!everyNodeHasBrick) {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "At least one " + this.brickOutletType.toLowerCase() + " needs to be allocated to each lowest level nodes.";
                this.modalCloseBtnCaption = "Ok";
                jQuery("#" + this.modalID).modal("show");
                this.territoryService.fnSetLoadingAction(false)
                return false;
            } else {
                jQuery("#" + this.modalID).modal("hide");
                //this.fnModalConfirmationClick("Save Territory Def");//save territory def
                this.fnSaveTerritoryDefOnClickBack("Save Territory Def", "Save territory using back button");
                //this.territoryService.fnSetLoadingAction(false)
                return false;
            }
        } else if (event == "back to territory tiles page") {
            jQuery("#" + this.modalID).modal("hide");
            if (this.authService.selectedTerritoryModule == "" || this.authService.selectedTerritoryModule == null) {
                this.router.navigate(['territory/My-Client/' + this.territory.Client_Id]);
            } else {
                if (this.authService.selectedTerritoryModule == "myterritories") {
                    this.router.navigate(['territories/' + this.authService.selectedTerritoryModule + '/' + this.territory.Client_Id]);
                } else {
                    //this.router.navigate(['territory/' + this.authService.selectedTerritoryModule + '/' + this.editableClientID]);
                    this.router.navigate(['territory/My-Client/' + this.territory.Client_Id]);
                }

            }
            //this.router.navigate(['territory/My-Client/' + this.territory.Client_Id]);
        } else if (event == "back to territory tiles page with data save") {
            //jQuery("#" + this.modalID).modal("hide");
            this.territoryService.fnSetLoadingAction(true)
            let everyNodeHasBrick: boolean = true;
            this.territoryNodes.every((record: OutletBrickAllocationCount, index: any) => {//to check node has brick
                if (record.BrickOutletCount > 0) {
                    everyNodeHasBrick = true;
                    return true;
                } else {
                    everyNodeHasBrick = false;
                    return false;
                }
            });

            if (!everyNodeHasBrick) {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "At least one " + this.brickOutletType.toLowerCase() + " needs to be allocated to each lowest level nodes.";
                this.modalCloseBtnCaption = "Ok";
                jQuery("#" + this.modalID).modal("show");
                this.territoryService.fnSetLoadingAction(false)
                return false;
            } else {
                jQuery("#" + this.modalID).modal("hide");
                //this.fnModalConfirmationClick("Save Territory Def");//save territory def
                this.fnSaveTerritoryDefOnClickBack("Save Territory Def", "Back to territory tiles");
                //this.territoryService.fnSetLoadingAction(false)
                return false;
            }
        }

        this.territoryService.isChangeDetectedInTerritoryDef = this.fnChangeDetectedInBrickAllocation();
        this.authService.hasUnSavedChanges = true;
    }

    fnSaveTerritoryDefOnClickBack(event: any, type: string = "") {//new method to avoid async and await
        if (event == "Save Territory Def") {
            if (this.isEditTerritoryDef) {
                //jQuery("#" + this.modalID).modal("hide");
                this.territoryService.fnSetLoadingAction(true);
                this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
                this.tempBrickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.brickDetailsUnderTerritory)) || [];
                this.tempTerritoryNodes = JSON.parse(JSON.stringify(this.territoryNodes)) || [];
                this.territory.OutletBrickAllocation = this.brickDetailsUnderTerritory;
                this.territoryService.editTerritory(this.territory.Client_Id, this.territory.Id, this.territory).subscribe((data: any) => {
                    this.territoryService.fnSetLoadingAction(false);
                    this.newTerritoryDefId = data[0].Id;
                    this.territory.Id = data[0].Id;
                    if (type == "Back to territory tiles") {
                        this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + '/Edit Lock']);
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "Back to territory tiles after saving data";
                        this.modalTitle = "Changes made to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation have been applied.";
                        this.modalCloseBtnCaption = "Ok";
                        jQuery("#" + this.modalID).modal("show");
                    } else {
                        this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + "/Edit Lock"]);
                        this.fnTerritoryCallBack.emit({ AssignedNodes: this.territoryNodes, enabledBrickCreation: true, brickDetailsUnderTerritory: this.brickDetailsUnderTerritory, availbleBricks: this.availbleBricks, isEditTerritoryDef: true, newTerritoryDefId: this.newTerritoryDefId });

                    }
                },
                    (err: any) => {
                        this.territoryService.fnSetLoadingAction(false);
                        console.log(err);
                    }
                );
            } else {
                jQuery("#" + this.modalID).modal("hide");
                this.territoryService.fnSetLoadingAction(true);
                this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
                this.tempBrickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.brickDetailsUnderTerritory)) || [];
                this.tempTerritoryNodes = JSON.parse(JSON.stringify(this.territoryNodes)) || [];
                this.territory.OutletBrickAllocation = this.brickDetailsUnderTerritory;
                this.territoryService.postTerritory(this.territory.Client_Id, this.territory).subscribe((data: any) => {
                    this.territoryService.fnSetLoadingAction(false);
                    //this.modalSaveBtnVisibility = false;
                    //this.modalSaveFnParameter = "";
                    //this.modalTitle = "Changes made to the " + this.brickOutletType.toLowerCase() + " allocation have been applied.";
                    //this.modalCloseBtnCaption = "Ok";
                    //jQuery("#" + this.modalID).modal("show");
                    this.isEditTerritoryDef = true;
                    this.newTerritoryDefId = data[0].Id;
                    this.territory.Id = data[0].Id;

                    if (type == "Back to territory tiles") {
                        this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + '/Edit Lock']);
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "Back to territory tiles after saving data";
                        this.modalTitle = "Changes made to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation have been applied.";
                        this.modalCloseBtnCaption = "Ok";
                        jQuery("#" + this.modalID).modal("show");
                    } else {
                        this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + '/Edit Lock']);
                        this.fnTerritoryCallBack.emit({ AssignedNodes: this.territoryNodes, enabledBrickCreation: true, brickDetailsUnderTerritory: this.brickDetailsUnderTerritory, availbleBricks: this.availbleBricks, isEditTerritoryDef: true, newTerritoryDefId: this.newTerritoryDefId });

                    }

                },
                    (err: any) => {
                        this.territoryService.fnSetLoadingAction(false);
                        console.log(err);
                    }
                );
            }

        }

        this.territoryService.isChangeDetectedInTerritoryDef = this.fnChangeDetectedInBrickAllocation();
        this.authService.hasUnSavedChanges = true;
    }

    fnSaveReallocateInfo() {
        let selectedTerritoryBrickDetails: any[] = [];
        let destinationGroupID = jQuery("#destinationGroupDetailsDD").val();
        //selected items pushed in array
        jQuery("#brick-details-table tbody tr .checkbox-brick-details-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                //console.log("selected ID" + jQuery(this).attr("data-sectionvalue"));
                selectedTerritoryBrickDetails.push(jQuery(this).attr("data-sectionvalue"));
            }
        });

        //remove from the details table
        selectedTerritoryBrickDetails.forEach((rec: any) => {
            this.brickDetailsUnderTerritory.every((record: OutletBrickAllocation, index: any) => {
                if (record.BrickOutletCode == rec && record.NodeCode == this.selectedTerritoryRecordToShowTable["NodeCode"]) {
                    this.brickDetailsUnderTerritory.splice(this.brickDetailsUnderTerritory.indexOf(record), 1);// to remove selected record
                    /* this.brickDetailsUnderTerritory.push({
                         NodeCode: destinationGroupID, NodeName: record.NodeName, BrickOutletCode: record.BrickOutletCode, BrickOutletName: record.BrickOutletName, Address: record.Address, LevelName: record.LevelName,
                         CustomGroupNumberSpace: record.CustomGroupNumberSpace, Type: this.brickOutletType
             });*/
                    this.brickDetailsUnderTerritory.push({
                        NodeCode: destinationGroupID, NodeName: record.NodeName, BrickOutletCode: record.BrickOutletCode, BrickOutletName: record.BrickOutletName, Address: record.Address, BannerGroup: record.BannerGroup, State: record.State, Panel: record.Panel, LevelName: record.LevelName,
                        BrickOutletLocation: record.BrickOutletLocation, CustomGroupNumberSpace: record.CustomGroupNumberSpace, Type: this.brickOutletType
                    });
                    this.territoryNodes.every((trritoryRecord: OutletBrickAllocationCount, index: any) => {
                        if (trritoryRecord.NodeCode == this.selectedTerritoryRecordToShowTable["NodeCode"]) {//to decrement bricks number
                            trritoryRecord.BrickOutletCount = trritoryRecord.BrickOutletCount - 1;
                        } else {
                            return true;
                        }
                    });

                    //increment 1 in destination group
                    this.territoryNodes.every((trritoryRecord: OutletBrickAllocationCount, index: any) => {
                        if (trritoryRecord.NodeCode == destinationGroupID) {
                            trritoryRecord.BrickOutletCount = trritoryRecord.BrickOutletCount + 1;//to decrement bricks number
                        } else {
                            return true;
                        }
                    });
                    return false;
                } else {
                    return true;
                }
            });
        });

        // repopulate brick details array
        this.bricksDetailsOfSelectedTerritory = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation, index: any) => {
            if (rec.NodeCode == this.selectedTerritoryRecordToShowTable["NodeCode"]) {
                return true;
            } else {
                return false;
            }
        });

        jQuery("#reallocate").modal("hide");
        this.enabledReallocateBtn = false;

        this.territoryService.isChangeDetectedInTerritoryDef = this.fnChangeDetectedInBrickAllocation();
        this.authService.hasUnSavedChanges = true;
    }

    fnBrickDetailsCheckboxClick(event: any) {
        if (jQuery(".checkbox-brick-details-table:checked").length > 0) {
            this.enabledReallocateBtn = true;
        } else {
            this.enabledReallocateBtn = false;
        }

    }

    fnBackToPreviousState() {
        if (JSON.stringify(this.tempTerritoryNodes) == JSON.stringify(this.territoryNodes) && JSON.stringify(this.tempAvailableBricks) == JSON.stringify(this.availbleBricks) && JSON.stringify(this.tempBrickDetailsUnderTerritory) == JSON.stringify(this.brickDetailsUnderTerritory)) {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "Back to Previous State";
            this.modalTitle = "No Changes have been made to the Territory Definition.";
            this.modalCloseBtnCaption = "Ok";
            jQuery("#" + this.modalID).modal("show");
        } else {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "Back to Previous State";
            this.modalTitle = "Changes made to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation will not apply. Would you like to proceed?";
            this.modalBtnCapton = "Yes";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#" + this.modalID).modal("show");
        }

    }

    fnBackToClientTiles() {
        //to compare any changes there
        if (JSON.stringify(this.tempTerritoryNodes) != JSON.stringify(this.territoryNodes) || JSON.stringify(this.tempAvailableBricks) != JSON.stringify(this.availbleBricks) || JSON.stringify(this.tempBrickDetailsUnderTerritory) != JSON.stringify(this.brickDetailsUnderTerritory)) {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "back to territory tiles page with data save";
            this.modalTitle = "Changes made to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation, Would you like to save?";
            this.modalBtnCapton = "Yes";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#" + this.modalID).modal("show");
        } else {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "back to territory tiles page";
            this.modalTitle = "<span >Do you want to return back to <b>Territory Definition</b> view?</span>";
            this.modalBtnCapton = "Yes";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#" + this.modalID).modal("show");
        }

    }

    fnSaveTerritoryInfo() {
        let everyNodeHasBrick: boolean = true;
        this.territoryNodes.every((record: OutletBrickAllocationCount, index: any) => {//to check node has brick
            if (record.BrickOutletCount > 0) {
                everyNodeHasBrick = true;
                return true;
            } else {
                everyNodeHasBrick = false;
                return false;
            }
        });

        if (!everyNodeHasBrick) {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "At least one " + this.brickOutletType.toLowerCase() + " needs to be allocated to each lowest level nodes.";
            this.modalCloseBtnCaption = "Ok";
            jQuery("#" + this.modalID).modal("show");
            return false;
        } else {
            if (this.isIMSStandardStructure) {//message for IMS structure
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "Save Territory Def";
                this.modalTitle = "Would you like to save <b> IMS Standard " + this.brickOutletType + " Structure</b>?";
                this.modalBtnCapton = "Yes";
                this.modalCloseBtnCaption = "Cancel";
                jQuery("#" + this.modalID).modal("show");
                return false;
            } else {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "Save Territory Def";
                this.modalTitle = "Changes have been made to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation. Would you like to save these?";
                this.modalBtnCapton = "Yes";
                this.modalCloseBtnCaption = "Cancel";
                jQuery("#" + this.modalID).modal("show");
                return false;
            }

        }

    }

    fnModalCloseClick(event: any) {
        if (event == "Save Territory Def from Back Btn") {//backe with previous data
            jQuery("#" + this.modalID).modal("hide");
            this.territoryService.fnSetLoadingAction(true);
            this.availbleBricks = JSON.parse(JSON.stringify(this.tempAvailableBricks)) || [];
            this.brickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.tempBrickDetailsUnderTerritory)) || [];
            this.territoryNodes = JSON.parse(JSON.stringify(this.tempTerritoryNodes)) || [];
            this.selectedTerritoryRecord = [];
            this.fnTerritoryCallBack.emit({ AssignedNodes: this.territoryNodes, enabledBrickCreation: true, brickDetailsUnderTerritory: this.brickDetailsUnderTerritory, availbleBricks: this.availbleBricks, isEditTerritoryDef: this.isEditTerritoryDef, newTerritoryDefId: this.newTerritoryDefId });
            this.territoryService.fnSetLoadingAction(false);
        } else if (event == "back to territory tiles page with data save") {
            jQuery("#" + this.modalID).modal("hide");
            this.fnModalConfirmationClick("back to territory tiles page");
        } else if (event == "Back to territory tiles after saving data") {
            jQuery("#" + this.modalID).modal("hide");
            this.fnModalConfirmationClick("back to territory tiles page");
        }
        jQuery("#" + this.modalID).modal("hide");

        this.territoryService.isChangeDetectedInTerritoryDef = this.fnChangeDetectedInBrickAllocation();
        this.authService.hasUnSavedChanges = true;
    }

    fnModalCloseClick_OK(event: any) {
        jQuery("#" + this.modalID_OK).modal("hide");
    }

    fnTerritoryTableCellClick(event: any) {
        if (event.cellName == "BrickOutletCount") {
            this.enabledReallocateBtn = false;
            this.selectedTerritoryRecordToShowTable = event.record || [];
            this.bricksDetailsOfSelectedTerritory = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation, index: any) => {
                if (rec.NodeCode == event.record.NodeCode) {
                    return true;
                } else {
                    return false;
                }
            });
        }
    }

    fnChangeDetectedInBrickAllocation(): boolean {
        if (JSON.stringify(this.tempTerritoryNodes) != JSON.stringify(this.territoryNodes) || JSON.stringify(this.tempAvailableBricks) != JSON.stringify(this.availbleBricks) || JSON.stringify(this.tempBrickDetailsUnderTerritory) != JSON.stringify(this.brickDetailsUnderTerritory)) {
            return true;
        } else {
            return false;
        }
    }

    fnBindAvailableBricksTable() {
        this.availableBricksTableBind = {
            tableID: "available-bricks-table",
            tableClass: "table table-border ",
            tableName: "Available Bricks",
            enableSerialNo: false,
            tableRowIDInternalName: "Code",
            tableColDef: [
                { headerName: 'Brick', width: '20%', internalName: 'Code', className: "available-brick-code", sort: true, type: "", onClick: "", alwaysVisible: true, visible: true },
                { headerName: 'Name', width: '40%', internalName: 'Name', className: "available-brick-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'State', width: '20%', internalName: 'State', className: "available-brick-State", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Brick Location', width: '20%', internalName: 'BrickOutletLocation', className: "available-brick-location", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Type', width: '20%', internalName: 'Panel', className: "available-brick-Panel", sort: true, type: "", onClick: "", visible: true }
            ],
            enableSearch: true,
            enableCheckbox: true,
            enablePagination: true,
            checkboxColumnHeader: " ",
            enableRecordCreateBtn: false,
            pageSize: 500,
            displayPaggingSize: 3,
            enablePTableDataLength: false,
            enabledStaySeletedPage: true,
            enabledColumnFilter: true,
            DisabledTableReset: true,
            enabledColumnSetting: true,
            enabledReflow: true,
            enabledFixedHeader: true,
            pTableStyle: {
                tableOverflowY: true,
                overflowContentHeight: '488px'
            }
        };
    }

    fnBindAvailableOutletsTable() {
        this.availableOutletTableBind = {
            tableID: "available-bricks-table",
            tableClass: "table table-border ",
            tableName: "Available Outlets",
            enableSerialNo: false,
            tableRowIDInternalName: "Code",
            tableColDef: [
                { headerName: 'Outlet', width: '15%', internalName: 'Code', className: "available-brick-code", sort: true, type: "", onClick: "", alwaysVisible: true, visible: true },
                { headerName: 'Name', width: '20%', internalName: 'Name', className: "available-brick-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Address', width: '25%', internalName: 'Address', className: "available-brick-address", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'State', width: '12%', internalName: 'State', className: "available-brick-State", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Type', width: '12%', internalName: 'Panel', className: "available-brick-Panel", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Banner', width: '15%', internalName: 'BannerGroup', className: "available-brick-BannerGroup", sort: true, type: "", onClick: "", visible: true }
            ],
            enableSearch: true,
            enableCheckbox: true,
            checkboxColumnHeader: " ",
            enablePagination: true,
            enableRecordCreateBtn: false,
            pageSize: 500,
            displayPaggingSize: 3,
            enablePTableDataLength: false,
            enabledStaySeletedPage: true,
            enabledColumnFilter: true,
            DisabledTableReset: true,
            enabledColumnSetting: true,
            enabledReflow: true,
            enabledFixedHeader: true,
            pTableStyle: {
                tableOverflowY: true,
                overflowContentHeight: '488px'
            }
        };
    }

    fnBindTerritoryNodesTable() {
        //to make dynamic columns 
        console.log("this.territory.Levels", this.territory.Levels, this.territory.Levels.length - 1)
        if (this.territory.Levels.length > 0) {
            // let colWidth = Number(8 * (7 - this.territory.Levels.length)) + "%"
            let colWidth = (100 / (this.territory.Levels.length + 1)) + "%"
            //this.territoryTableColumnDef = [{ headerName: 'Code', width: '20%', internalName: 'CustomGroupNumberSpace', className: "territory-list-code", sort: true, type: "", onClick: "", alwaysVisible: true }]
            this.territoryTableColumnDef = [{ headerName: 'Code', width: colWidth, internalName: 'CustomGroupNumberSpace', className: "territory-list-code", sort: true, type: "", onClick: "", alwaysVisible: true, visible: true }]

            /* for (let i = 1; i < this.territory.Levels.length; i++) {
                 if (i == 1 && i != this.territory.Levels.length - 1) {
                     this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelOne', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                 } else if (i == 2 && i != this.territory.Levels.length - 1) {
                     this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelTwo', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                 } else if (i == 3 && i != this.territory.Levels.length - 1) {
                     this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelThree', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                 } else if (i == 4 && i != this.territory.Levels.length - 1) {
                     this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelFour', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                 } else if (i == this.territory.Levels.length - 1) {
                     this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'NodeName', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                 }
 
             }
             
             this.territoryTableColumnDef.push({ headerName: this.brickOutletType + " #", width: '15%', internalName: 'BrickOutletCount', className: "territory-list-bricks", sort: false, type: "hyperlink", onClick: "true", visible: true });*/

            for (let i = this.territory.Levels.length - 1; i > 0; i--) {
                if (i == 1 && i != this.territory.Levels.length - 1) {
                    this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelOne', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                } else if (i == 2 && i != this.territory.Levels.length - 1) {
                    this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelTwo', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                } else if (i == 3 && i != this.territory.Levels.length - 1) {
                    this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelThree', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                } else if (i == 4 && i != this.territory.Levels.length - 1) {
                    this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'ParentNodeLevelFour', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                } else if (i == this.territory.Levels.length - 1) {
                    this.territoryTableColumnDef.push({ headerName: this.territory.Levels[i].Name, width: colWidth, internalName: 'NodeName', className: "territory-list-territory", sort: true, type: "", onClick: "", visible: true });
                    //this.territoryTableColumnDef.push({ headerName: this.brickOutletType + " #", width: '15%', internalName: 'BrickOutletCount', className: "territory-list-bricks", sort: true, type: "hyperlink", onClick: "true", visible: true });
                    this.territoryTableColumnDef.push({ headerName: this.brickOutletType + " #", width: colWidth, internalName: 'BrickOutletCount', className: "territory-list-bricks", sort: true, type: "hyperlink", onClick: "true", visible: true });
                }
            }
        }

        //bind territory table
        this.territoryListTableBind = {
            tableID: "territory-list-table",
            tableClass: "table table-border ",
            tableName: this.levelName + " List",
            enableSerialNo: false,
            tableRowIDInternalName: "NodeCode",
            tableColDef: this.territoryTableColumnDef,
            enableSearch: true,
            enableCheckbox: false,
            enableRadioButton: true,
            pageSize: 500,
            displayPaggingSize: 3,
            enablePTableDataLength: false,
            enabledCellClick: true,
            enabledStaySeletedPage: true,
            enablePagination: true,
            enabledColumnFilter: true,
            enabledColumnSetting: true,
            enabledReflow: true,
            enabledFixedHeader: true,
            pTableStyle: {
                tableOverflow: this.territory.Levels.length > 2 ? true : false,
                tableOverflowY: this.territory.Levels.length <= 2 ? true : false,
                overflowContentWidth: this.territory.Levels.length > 2 ? "140%" : "",
                overflowContentHeight: '488px'
            }
        };
    }

    fnBindAssignedBricksOutletsTable() {
        let columnDef = [];
        if (this.brickOutletType.toLowerCase() == 'outlet') {
            columnDef = [
                { headerName: this.brickOutletType, width: '15%', internalName: 'BrickOutletCode', className: "brick-code", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Name', width: '25%', internalName: 'BrickOutletName', className: "brick-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Address', width: '20%', internalName: 'Address', className: "bricks-address", sort: true, type: "", onClick: "", visible: this.brickOutletType.toLowerCase() == 'outlet' ? true : false },
                { headerName: 'State', width: '15%', internalName: 'State', className: "bricks-state", sort: true, type: "", onClick: "", visible: true },
                //{ headerName: 'Brick Location', width: '22%', internalName: 'BrickOutletLocation', className: "available-brick-location", sort: true, type: "", onClick: "", visible: this.brickOutletType.toLowerCase() == 'brick' ? true : false },
                { headerName: 'Type', width: '10%', internalName: 'Panel', className: "bricks-type", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Banner Group', width: '15%', internalName: 'BannerGroup', className: "bricks-banner-group", sort: true, type: "", onClick: "", visible: this.brickOutletType.toLowerCase() == 'outlet' ? true : false }
            ];
        } else {
            columnDef = [
                { headerName: this.brickOutletType, width: '18%', internalName: 'BrickOutletCode', className: "brick-code", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Name', width: '30%', internalName: 'BrickOutletName', className: "brick-name", sort: true, type: "", onClick: "", visible: true },
                //{ headerName: 'Address', width: '20%', internalName: 'Address', className: "bricks-address", sort: true, type: "", onClick: "", visible: this.brickOutletType.toLowerCase() == 'outlet' ? true : false },
                { headerName: 'State', width: '15%', internalName: 'State', className: "bricks-state", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Location', width: '25%', internalName: 'BrickOutletLocation', className: "available-brick-location", sort: true, type: "", onClick: "", visible: this.brickOutletType.toLowerCase() == 'brick' ? true : false },
                { headerName: 'Type', width: '12%', internalName: 'Panel', className: "bricks-type", sort: true, type: "", onClick: "", visible: true },
                //{ headerName: 'Banner Group', width: '20%', internalName: 'BannerGroup', className: "bricks-banner-group", sort: true, type: "", onClick: "", visible: this.brickOutletType.toLowerCase() == 'outlet' ? true : false }
            ]
        }

        this.brickDetailsTableBind = {
            tableID: "brick-details-table",
            tableClass: "table table-border ",
            tableName: this.brickOutletType + " Details"+this.selectedTerritoryRecordToShowTable,
            tableRowIDInternalName: "BrickOutletCode",
            tableColDef: columnDef,  
            enableSearch: false,
            enableCheckbox: true,
            enabledCellClick: true,
            enabledStaySeletedPage: true,
            enablePagination: true,
            enabledColumnFilter: true,
            checkboxColumnHeader: " ",
            tableHeaderFooterVisibility: true,
            enabledFixedHeader: true,
            pageSize: 500,
            displayPaggingSize: 3,
            enabledColumnSetting: true,
            enabledReflow: true,
            pTableStyle: {
                tableOverflow: this.brickOutletType.toLowerCase() == 'outlet' ? true : false,
                tableOverflowY: this.brickOutletType.toLowerCase() == 'outlet' ? false : true,
                overflowContentWidth: this.brickOutletType.toLowerCase() == 'outlet' ? "130%" : "",
                overflowContentHeight: '440px'
            }
        };
    }

    fnReassignBricksOutletsForTerritoryNodes() {
        let newNode: boolean = true;
        this.territoryCurrentNodes.forEach((currentRecord: OutletBrickAllocationCount, index: any) => {//latest territory node
            newNode = true;
            this.territoryNodes.every((preRecord: OutletBrickAllocationCount, index: any) => {//previous territory nodes
                if (currentRecord.GroupNumber == preRecord.GroupNumber) {//to update previous record
                    preRecord.CustomGroupNumberSpace = currentRecord.CustomGroupNumberSpace;
                    preRecord.LevelName = currentRecord.LevelName;
                    preRecord.NodeCode = currentRecord.NodeCode;
                    preRecord.NodeName = currentRecord.NodeName;

                    preRecord.ParentNodeLevelOne = currentRecord.ParentNodeLevelOne;
                    preRecord.ParentNodeLevelTwo = currentRecord.ParentNodeLevelTwo;
                    preRecord.ParentNodeLevelThree = currentRecord.ParentNodeLevelThree;
                    preRecord.ParentNodeLevelFour = currentRecord.ParentNodeLevelFour;
                    newNode = false;
                    return false;
                } else {
                    return true;
                }
            });

            if (newNode == true) {//to insert new node
                this.territoryNodes.push({ NodeCode: currentRecord.NodeCode, NodeName: currentRecord.NodeName, GroupNumber: currentRecord.GroupNumber, BrickOutletCount: 0, LevelName: currentRecord.LevelName, CustomGroupNumberSpace: currentRecord.CustomGroupNumberSpace, Type: this.brickOutletType, ParentNodeLevelOne: currentRecord.ParentNodeLevelOne, ParentNodeLevelTwo: currentRecord.ParentNodeLevelTwo, ParentNodeLevelThree: currentRecord.ParentNodeLevelThree, ParentNodeLevelFour: currentRecord.ParentNodeLevelFour });
                newNode = false;
            }
        });


        //find out deleted nodes and remove bricks
        let nodeIsPresent: boolean = false;
        this.territoryNodes.slice().reverse().forEach((record: OutletBrickAllocationCount, index: any, object: any) => {
            this.territoryCurrentNodes.every((curRecord: OutletBrickAllocationCount, curIndex: any) => {
                if (record.GroupNumber == curRecord.GroupNumber) {
                    nodeIsPresent = true;
                    return false;
                } else {
                    nodeIsPresent = false;
                    return true;
                }

            });

            if (nodeIsPresent == false) {//this node is deleted from view page
                this.territoryNodes.splice(this.territoryNodes.indexOf(record), 1);//delete from territory nodes
                this.brickDetailsUnderTerritory.slice().reverse().forEach((brickDetails: OutletBrickAllocation, index: any) => {
                    if (record.NodeCode == brickDetails.NodeCode && record.NodeName == brickDetails.NodeName) {
                        this.availbleBricks.push({ Code: brickDetails.BrickOutletCode, Name: brickDetails.BrickOutletName, Address: brickDetails.Address, BannerGroup: brickDetails.BannerGroup, State: brickDetails.State, Panel: brickDetails.Panel, BrickOutletLocation: brickDetails.BrickOutletLocation, Type: this.brickOutletType });
                        //this.availbleBricks.push({ Code: brickDetails.BrickOutletCode, Name: brickDetails.BrickOutletName, Address: brickDetails.Address, Type: this.brickOutletType });
                        this.brickDetailsUnderTerritory.splice(this.brickDetailsUnderTerritory.indexOf(brickDetails), 1);
                    }
                });
                nodeIsPresent = true;
            }
        });

        //brick count to 
        this.territoryNodes.forEach((record: OutletBrickAllocationCount) => {
            record.BrickOutletCount = this.brickDetailsUnderTerritory.filter((rec: OutletBrickAllocation) => { if (record.NodeCode == rec.NodeCode) { return true } else { return false } }).length || 0;
        });

        this.territoryNodes = this.territoryNodes.sort((a, b) => {
            if (a.CustomGroupNumberSpace > b.CustomGroupNumberSpace) { return 1; }
            if (a.CustomGroupNumberSpace < b.CustomGroupNumberSpace) { return -1; }
            return 0;
        });

    }

    async fnPullBricksOutlets() {
        this.territoryService.fnSetLoadingAction(true);
        this.territoryService.getBrickOutlet(this.brickOutletType.toLowerCase(), this.userRole, this.territory.Client_Id).subscribe((data: any) => {
            this.availbleBricks = data || [];
            this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
            //for standard structure && non editable mode
            if (this.isIMSStandardStructure && this.isEditTerritoryDef == false) {
                this.fnRemoveBricksOutletFromAvailableList();
            }
            this.territoryService.fnSetLoadingAction(false)
        },
            (err: any) => {
                this.territoryService.fnSetLoadingAction(false);
                console.log(err);
            });
    }

    fnAssignInTempVaiable() {
        this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
        this.tempBrickDetailsUnderTerritory = JSON.parse(JSON.stringify(this.brickDetailsUnderTerritory)) || [];
        this.tempTerritoryNodes = JSON.parse(JSON.stringify(this.territoryNodes)) || [];
        this.territoryService.fnSetLoadingAction(false);
    }

    fnRemoveBricksOutletFromAvailableList() {
        this.brickDetailsUnderTerritory.forEach((rec: any) => {
            let selectedRecord = this.availbleBricks.filter((record: any) => { if (record.Code == rec.Code) { return true; } else { return false } })[0];
            this.availbleBricks.splice(this.availbleBricks.indexOf(selectedRecord), 1);
        });

        this.tempAvailableBricks = JSON.parse(JSON.stringify(this.availbleBricks)) || [];
    }
}
