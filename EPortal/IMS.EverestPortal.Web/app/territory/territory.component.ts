import { Component, OnInit, ViewChild, AfterViewInit, HostListener } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Group } from '../shared/models/territory/group';
import { Level } from '../shared/models/territory/level';
import { Territory } from '../shared/models/territory/territory';
import { MOCK_TERRITORY } from '../shared/models/territory/mock-territory';
import { TerritoryDefinitionService } from '../shared/services/territorydefinition.service';
import { CONSTANTS } from '../shared/constants';


import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';
import { ConfigService } from '../config.service';
import { ModalDirective } from 'ng2-bootstrap';
import { OutletBrick, OutletBrickAllocation, OutletBrickAllocationCount } from '../shared/models/territory/brick-allocation';
import { ComponentCanDeactivate, DeactivateGuard } from '../security/deactivate-guard';
import { Observable } from 'rxjs/Observable';

declare var jQuery: any;

@Component({
    selector: 'territory',
    templateUrl: '../../app/territory/territory.html',
    styleUrls: ['../../app/market-view/clients-sidebar.css'],
    providers: [Territory]
})
export class TerritoryComponent implements OnInit {
    @ViewChild('tErrorModal') tErrorModal: ModalDirective

    @HostListener('window:beforeunload')
    canDeactivate(): Observable<boolean> | boolean {
        if (this.territoryService.isChangeDetectedInTerritoryDef == true || this.territoryService.isChangeDetectedInTerritorySetup == true) { // Here add condition to check for any unsaved changes
            if (this.authService.isTimeout == true)
                return true;
            else
                return false; // return false will show alert to the user
        }
        else {//to release lock
            this.territoryService.fnSetLoadingAction(true);
            try {
                this.deactiveGuard.fnReleaseLock(this.loginUserObj.UserID, this.editableTerritoryDefID, 'Territory Module', this.lockType, 'Release Lock').then(result => { this.territoryService.fnSetLoadingAction(false); });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
            }
            this.territoryService.fnSetLoadingAction(false);
            return true;
        }
    }

    public groupDetails: any[] = [];
    public extraLevels: Level[] = [];
    public clickedLevelID: number;
    public clickedLevel: any;
    public static clickedParent: Group;
    public footerHeight: string;
    public static Levels: Level[] = [];
    public static Groups: Group;
    public static GroupIdFlag = false;
    public parentList: Group[];
    public levelModalAction: string;
    public levelModalTitle: string;
    public isEditTerritoryDef = false;
    public editableClientID = 0;
    public editableTerritoryDefID = 0;
    public territoryDefPageTitle: string = "Create New Territory";
    public enabledTerritoryContent: boolean = true;
    public enabledBricksAllocationContent: boolean = false;
    public territoryLastLevelNodes: any[] = [];
    public brickOutletType: string = 'Brick';
    public static staticBrickOutletType: string = 'Brick';
    public static brickDetailsUnderTerritory: OutletBrickAllocation[] = [];
    public static territoryNodes: any = [];
    public isImsTerritory: boolean;
    public enabledBrickCreation: boolean = false;
    public availbleBricks: OutletBrick[] = [];
    public enabledTerritoryHeader: boolean = true;
    //public outletBrickAllocation:OutletBrickAllocation[]=[];
    public initialLengthofLevel: number[] = [1, 1, 2, 2, 2, 1];
    public isNewBrickCreation: boolean = false;
    public savedTerritory: Territory;
    public clientID: number;
    public lastLevelName: string = "";
    public isIMSStandardStructure: boolean = false;
    public groupParentName: string = "";
    public hasNoGroupInLastLevel: boolean;
    public territoryGroupMissingSummary: any = [];
    public isLDADVisible: boolean = false;
    public isEditableSRA: boolean = false;
    public lockType: string = "";
    public loginUserObj: any;
    public tempTerritorySRAInfo: any;
    public IsTerritoryHeaderSectionChanged: boolean = false;
    //for custom modal
    //public modalSaveBtnVisibility: boolean;
    //public modalSaveFnParameter: string = "";
    //public modalTitle: string;
    //public modalBtnCapton: string = "Save";
    //public modalCloseBtnCaption: string = "Close";
    public static modalSaveBtnVisibility: boolean = false;
    public static modalSaveFnParameter: string = "";
    public static modalTitle: string = "Modal";
    public static modalBtnCapton: string = "Save";
    public static modalCloseBtnCaption: string = "Close";


    //forGroup Id Generation
    defaultGroupNumber: string;
    defaultGroupPrefixID: string = "";
    curtLevelMaxGroupId: number = 0;
    MaxGrpIdEachLevel: number[] = [];
    LogMidLevel: boolean[] = [];
    result: boolean = false;
    constantIdLen: number = 8;

    //IMS Standard hierarchy 
    selectedOptionValue: string;
    IsUsedIMSBrickHierarchy: boolean;
    IsUsedIMSOutletHierarchy: boolean;
    optionsForTerritoryBase: string[] = [];
    optionsForBaseFilter: string[] = [];
    isEditTerritoryMode: boolean = false;
    public static globalDisableFlag: boolean = false;
    public listOfGroups: Group[] = [];
    public isMultiGroupAddChecked: boolean = false;


    //Check Height Balance
    IsHeightBalanceCase1Flag: boolean;
    IsHeightBalanceCase2Flag: boolean;

    parentNodeNameOfSelectedNode: string = "";
    isCheckedMultiNodeShift: boolean = false;
    static generateLinkToParentModal: boolean;

    //breadcrumb
    createTerrLink: string;
    canEditTerr: boolean = false;
    toggleTitle: string = '';
    breadCrumbUrl: string = '';
    generatedGroupIdToLinkParent: string;
    IsReferenceStrucute: boolean = false;
    IsPermitedADLDEdit: boolean = false;

    //for collapse expaned 
    static IsChangedInCollapsExpaned: boolean = false;
    static collapseExpanedClickedNode: any;

    //for User Role info
    public userRole: string = '';

    selectedOption: string = 'Custom';
    allTerritoriesList: any[] = [];
    IMSStandardStructureOption: any[] = [];

    constructor(private territory: Territory, public route: ActivatedRoute, private _cookieService: CookieService, private authService: AuthService,
        private router: Router, private territoryService: TerritoryDefinitionService, private deactiveGuard: DeactivateGuard, ) {
        TerritoryComponent.Groups = this.territory.RootGroup;
        TerritoryComponent.Levels = this.territory.Levels;
        this.savedTerritory = jQuery.extend(true, {}, this.territory);
        this.loginUserObj = this._cookieService.getObject('CurrentUser');
    }

    private _getUserRole() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        this.isEditableSRA = false;
        this.isLDADVisible = false;
        if (usrObj) {
            this.userRole = usrObj.RoleName;
            //to hide LD and AD section
            if (this.userRole == 'Client Analyst' || this.userRole == 'Client Manager' || this.userRole == 'Third Party' || this.userRole == 'Internal GTM') {
                this.isLDADVisible = false;
            } else {
                this.isLDADVisible = true;
            }

            //to check edit permission of SRA, LD and AD
            if (this.userRole == 'Internal Admin' || this.userRole == 'Internal Production' || this.userRole == 'Internal Support') {
                this.isEditableSRA = true;
            } else if (this.userRole == "Internal Data Reference") {
                this.isEditableSRA = true;
                TerritoryComponent.globalDisableFlag = true;
            } else if (this.userRole == "Internal GTM") {
                this.isEditableSRA = false;
            } else {
                this.isEditableSRA = false;
            }
        }
    }

    public getBrickDetailsUnderTerritory(): any {
        return TerritoryComponent.brickDetailsUnderTerritory;
    }
    public getTerritoryNodes(): any {
        return TerritoryComponent.territoryNodes;
    }
    public getModalTitle(): string {
        return TerritoryComponent.modalTitle;
    }
    public getModalSaveBtnVisibility(): boolean {
        return TerritoryComponent.modalSaveBtnVisibility;
    }
    public getModalSaveFnParameter(): string {
        return TerritoryComponent.modalSaveFnParameter;
    }
    public getModalBtnCapton(): string {
        return TerritoryComponent.modalBtnCapton;
    }
    public getModalCloseBtnCaption(): string {
        return TerritoryComponent.modalCloseBtnCaption;
    }


    public getLevelFromGroup(groupNumber: string): Level {
        return this.territory.Levels[(+groupNumber.charAt(0)) - 1];
    }

    addLevel(action: string, currentLevel: Level, name: string, idLength: number) {
        jQuery("#inputLevelName").focus();
        if (name.trim() === "") {
            jQuery("#addLevelErrorMessage").html("Level Name Empty!!");
            return false;
        }
        if (name.trim().length > 25) {
            jQuery("#addLevelErrorMessage").html("Name of the level cannot exceed 25 characters.");
            return false;
        } else if (name.match(/^[-\w\s]*$/) == null) {
            //name.search(/[^a-zA-Z ]+/) != -1 for only alphabet
            jQuery("#addLevelErrorMessage").html("Level name only alphanumeric with _ special character allowed.");
            return false;
        }

        if (action == "add") {//to add new level
            /*checking id length*/
            let totalLength: number = idLength || 0;
            this.territory.Levels.forEach((rec: any) => {
                totalLength = Number(totalLength) + Number(rec.LevelIDLength);
            });
            if (totalLength > 8) {
                jQuery("#addLevelErrorMessage").html("Total ID length combining all levels cannot exceed 8. Please adjust ID lengths for existing levels before proceeding.");
                return false;
            } else {
                let currentLevelId = currentLevel.LevelNumber;
                var newLevel: Level = { Id: 1, LevelNumber: currentLevelId + 1, LevelIDLength: idLength, Name: name, LevelColor: '', BackgroundColor: '' };
                this.territory.addLevel(currentLevelId, newLevel);
                this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
                this.clearLevelModal();
                TerritoryComponent.Levels = this.territory.Levels;
                TerritoryComponent.Groups = this.territory.RootGroup;
                if (this.enabledBrickCreation) {
                    this.isNewBrickCreation = true;
                }
            }

            jQuery("#inputLevelName").val("");
        } else if (action == "edit") {//to edit existing level
            let totalLength: number = idLength || 0;
            let numberOfNode = this.territory._levelGroupCount(this.territory.RootGroup, currentLevel.LevelNumber - 1);
            if (numberOfNode < Number(idLength) * 10 - 1) {
                this.territory.Levels.forEach((rec: any) => {
                    if (rec.Id == currentLevel.Id) {

                    } else {
                        totalLength = Number(totalLength) + Number(rec.LevelIDLength);
                    }
                });
                if (totalLength > 8) {
                    jQuery("#addLevelErrorMessage").html("Total ID length combining all levels cannot exceed 8. Please adjust ID lengths for existing levels before proceeding.");
                    return false;
                } else {
                    this.territory.editLevel(currentLevel, { Name: name, LevelIDLength: idLength });
                    jQuery("#addLevelModal").modal('hide');
                }
            } else {
                //jQuery("#addLevelErrorMessage").html("An ID of length '" + idLength + "' cannot be used for this group, please adjust ID length for this level before proceeding");
                jQuery("#addLevelErrorMessage").html("An ID of length '" + idLength + "' cannot be used for level <b>" + currentLevel.Name + "</b> because there are more than " + (Math.pow(10, idLength) - 1) + " groups in this level. Please adjust ID length or Groups for this level before proceeding");
                return false;
            }
        }

        //this.footerHeight = jQuery('#firstColumn').height();
        //console.log(this.footerHeight);

        ///for Group Id generation
        if ((currentLevel.LevelNumber + 1) < (this.territory.Levels.length - 1))//this.territory.Levels.length: level number already increased
        {
            this.MaxGrpIdEachLevel[this.territory.Levels.length] = 0;
            this.AdjustGroupIdForMidLevelAdd(this.territory.Levels.length, currentLevel.LevelNumber);
            var defaultID: number;
            defaultID = idLength;
            defaultID = defaultID++;
            this.defaultGroupNumber = this.zeroFill("1", defaultID, 0);
            this.MaxGrpIdEachLevel[currentLevel.LevelNumber + 1] = 0;
            this.LogMidLevel[currentLevel.LevelNumber + 1] = true;
        }
        else {
            var defaultID: number;
            defaultID = idLength;
            defaultID = defaultID++;
            this.defaultGroupNumber = this.zeroFill("1", defaultID, 0);
            this.MaxGrpIdEachLevel[currentLevel.LevelNumber + 1] = 0; //check//[currentLevel.LevelNumber + 1] 
        }
        //this.IsAvailableGroupNumber = false;
        //this.footerHeight = jQuery('#firstColumn').height();
        //console.log(this.footerHeight);
        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }

    fnTerritoryViewSave() {
        if (this.territory.Name == "" || this.territory.Name == undefined) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "A territory definition name is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            jQuery("#territoryName").focus();
            jQuery("#nextModal").modal("show");
            return false;
        } else {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalSaveFnParameter = "";
            TerritoryComponent.modalTitle = "Changes made to the territory hierarchy and will apply to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            this.btnSave_Click();
        }
    }

    btnSave_Click() {
        this.savedTerritory = jQuery.extend(true, {}, this.territory);
        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }
    async btnNext_Click() {
        this.territory.Name = this.territory.Name || "";
        this.territoryService.fnSetLoadingAction(true);
        let breakExecution: string = "true";
        this.hasNoGroupInLastLevel = true;
        this.territoryGroupMissingSummary = [];
        let len: number = Number(this.territory.Levels.length);
        let validationDetails: Territory[] = [];
        let IsOrphanGroupExists = await this.ifOrphanExistsInTree();

        let isSameAsIMSStandard: any[] = [];
        if (this.territory.Name != this.savedTerritory.Name)
            isSameAsIMSStandard = this.IMSStandardStructureOption.filter(x => x.Name == this.territory.Name);

        //at least one custom level needs to be added
        if (TerritoryComponent.Levels.length < 2) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Please create at least one custom level with groups before proceeding.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territory.Name.trim() == "") {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "A territory definition name is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territory.Name.match(/^[-/+()&/,\w\s]*$/) == null) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Only alphanumeric and special characters +,-,_,&,/,(,) are allowed. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return;
        }
        else if (this.territory.SRA_Client.trim() == "") {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "SRA cilent ID is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territory.SRA_Suffix.trim() == "" && this.isEditTerritoryDef != true && this.isIMSStandardStructure != true) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "SRA suffix is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territory.LD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true) {
            //else if (this.territory.LD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "LD is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (this.territory.AD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "AD is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        //else if (+this.ifOrphanExistsInTree() > 0) {
        else if (+IsOrphanGroupExists > 0) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            //TerritoryComponent.modalTitle = "Please assign parent to parentless Group(s) before proceeding.";
            TerritoryComponent.modalTitle = "The tree has missing connections, please review.";
            TerritoryComponent.modalCloseBtnCaption = "Close";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (isSameAsIMSStandard.length > 0 && this.territory.IsUsed != true) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Territory definition name cannot be same as any of the existing IMS Standard name.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        //to call function to check has last level groups
        await this.fnFindTerritoryTreeSummary(this.territory.RootGroup, len);
        if (this.hasNoGroupInLastLevel) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Level <b>" + this.territory.Levels[len - 1].Name + "</b> has no groups, please add groups or delete level.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territoryGroupMissingSummary.length > 0) {
            let missingTable: string = "";
            let missingGroupsInLevel: any[] = [];
            this.territoryGroupMissingSummary.forEach((rec: any, index: any) => {
                missingTable = missingTable + "<div>" + (index + 1) + ". Group missing under group <b>" + rec.parentGroup.Name + "</b> in level <b>" + this.territory.Levels[rec.level].Name + ".</b></div>"
                missingGroupsInLevel.push(this.territory.Levels[rec.level].Name);
            });
            TerritoryComponent.modalSaveBtnVisibility = false;
            //TerritoryComponent.modalTitle = "<b>Please correct the following errors before continuing.</b><br/> <div class='error-list'>"+missingTable+"</div>";
            TerritoryComponent.modalTitle = "Level <b>" + this.fnFindUniqueColumnWithFlag(missingGroupsInLevel) + "</b> has missing groups, please add groups.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }

        //to check name already exists
        if (this.editableTerritoryDefID > 0) {
            try {
                await this.territoryService.checkEditForTerritoryDefDuplication(this.clientID, this.editableTerritoryDefID, this.territory.Name.trim()).then(result => { breakExecution = result.toString() });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
            }
        } else {
            try {
                await this.territoryService.checkCreateTerritoryDefDuplication(this.clientID, this.territory.Name.trim()).then(result => { breakExecution = result.toString(); });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
                console.log("error new entry");
            }
        }
        jQuery("#territoryNameCheckErrorMessage").html("");
        console.log("breakExecution");
        console.log(breakExecution);
        if (breakExecution == "false" && this.isIMSStandardStructure != true) {
            //jQuery("#territoryNameCheckErrorMessage").html("Territory Definition '" + this.territory.Name.trim() + "' already exists. Please try again with different name. ");
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Territory Definition '" + this.territory.Name.trim() + "' already exists. Please try again with different name. ";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            jQuery("#newsTitle").focus();
            return false;
        }

        //check duplicate SRA Client and SRA SRA_Suffix
        try {
            await this.territoryService.checkSRADuplication(this.clientID, this.editableTerritoryDefID, this.territory.SRA_Client, this.territory.SRA_Suffix, this.territory.LD || "", this.territory.AD || "")
                .then(result => {
                    validationDetails = result;
                });

            if (validationDetails.length > 0) {
                if (validationDetails[0].IsUsed && this.isIMSStandardStructure != true) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "A Territory cannot be created as system cannot suggest an unique suffix for the selected SRA Client.";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].SRA_Client == 'true' && this.isIMSStandardStructure != true) {//uniqueness for combined values of SRA Client and SRA Suffix
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The SRA suffix chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].LD == 'true' && this.isLDADVisible == true) {//uniqueness for LD
                    //else if (validationDetails[0].LD == 'true' && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The <b>LD</b> chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].AD == 'true' && this.isLDADVisible == true) {//uniqueness for AD
                    //else if (validationDetails[0].AD == 'true' && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The <b>AD</b> chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
            }
        } catch (ex) {
            this.territoryService.fnSetLoadingAction(false);
            console.log("error new entry");
        }


        //go to next screen
        if (this.territoryService.isChangeDetectedInTerritorySetup) {
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalSaveFnParameter = "Unsaved Territory Saved";
            TerritoryComponent.modalTitle = "Changes have been made to the Territory Definition. Would you like to apply these?";
            TerritoryComponent.modalBtnCapton = "Ok";
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else {
            //this.HeightBalanceCheck();
            this.territoryService.fnSetLoadingAction(false);
            this.fnGenerateBricks();
        }
        /*if (this.isIMSStandardStructure != true && (JSON.stringify(this.savedTerritory.RootGroup) != JSON.stringify(this.territory.RootGroup) || JSON.stringify(this.savedTerritory.Levels) != JSON.stringify(this.territory.Levels))) {
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalSaveFnParameter = "Unsaved Territory Saved";
            TerritoryComponent.modalTitle = "Changes have been made to the Territory Definition. Would you like to apply these?";
            TerritoryComponent.modalBtnCapton = "Ok";
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else {
            //this.HeightBalanceCheck();
            this.territoryService.fnSetLoadingAction(false);
            this.fnGenerateBricks();
        }*/
    }

    fnFindUniqueColumnWithFlag(objectSet: any[], findKey: any = ""): any[] {
        if (findKey == "") {
            var o = {}, i, l = objectSet.length, r = [];
            for (i = 0; i < l; i++) { o[objectSet[i]] = objectSet[i]; };
            for (i in o) r.push(o[i]);
            return r;
        } else {
            var o = {}, i, l = objectSet.length, r = [];
            for (i = 0; i < l; i++) { o[objectSet[i][findKey]] = objectSet[i][findKey]; };
            for (i in o) r.push({ checked: false, data: o[i] });
            return r;
        }

    }

    fnBackToPreviousState() {
        if (JSON.stringify(this.savedTerritory.RootGroup) == JSON.stringify(TerritoryComponent.Groups) && JSON.stringify(this.savedTerritory.Levels) == JSON.stringify(TerritoryComponent.Levels)) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalSaveFnParameter = "";
            TerritoryComponent.modalTitle = "No Changes have been made to the Territory Definition.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            return false;
        } else {
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalSaveFnParameter = "Back to previous state";
            TerritoryComponent.modalTitle = "Changes made to the territory hierarchy will not apply to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation. Would you like to proceed?";
            TerritoryComponent.modalBtnCapton = "Yes";
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            jQuery("#nextModal").modal("show");
            return false;
        }
    }

    btnCancel_Click() {
        this.territory = jQuery.extend(true, {}, this.savedTerritory);
        TerritoryComponent.Groups = JSON.parse(JSON.stringify(this.savedTerritory.RootGroup));
        TerritoryComponent.Levels = JSON.parse(JSON.stringify(this.savedTerritory.Levels));
        this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }

    AdjustGroupIdForMidLevelAdd(maxLevelNumber: number, curLevelNumber: number): void {
        for (var i = (maxLevelNumber - 1); i >= curLevelNumber + 1; i--) {
            //var temp = this.MaxGrpIdEachLevel[i + 1];
            //this.MaxGrpIdEachLevel[i + 1] = this.MaxGrpIdEachLevel[i];
            //this.MaxGrpIdEachLevel[i + 2] = temp;
            this.MaxGrpIdEachLevel[i + 1] = this.MaxGrpIdEachLevel[i];
        }
    }

    clearLevelModal(): void {
        jQuery("#addLevelModal").modal('hide');
        this.clickedLevelID = null;
        jQuery('#inputLevelName').val("");
        jQuery('#inputIDLength').val("1");
    }

    deleteLevel(deleteLevelId: number): void {
        this.territory.deleteLevel(deleteLevelId);
        this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
        TerritoryComponent.Levels = this.territory.Levels;
        TerritoryComponent.Groups = this.territory.RootGroup;
        //console.log(this.territory);
        ///for Group Id generation
        if (deleteLevelId < (this.territory.Levels.length + 1)) {
            //for (var i = deleteLevelId + 1; i <= (this.territory.Levels.length +1 ); i++) {
            //    //var temp = this.MaxGrpIdEachLevel[i - 1];
            //    this.MaxGrpIdEachLevel[i - 1] = this.MaxGrpIdEachLevel[i];
            //}
            this.AdjustGroupIdForMidLevelDelete(this.territory.Levels.length, deleteLevelId);
            this.MaxGrpIdEachLevel[deleteLevelId] = 0;
        }
        else
            this.MaxGrpIdEachLevel[deleteLevelId] = 0;
        if (this.enabledBrickCreation) {
            this.isNewBrickCreation = true;
        }
        console.log(this.isNewBrickCreation);

        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }

    AdjustGroupIdForMidLevelDelete(maxLevelNumber: number, deleteLevelId: number) {
        for (var i = deleteLevelId + 1; i <= (maxLevelNumber + 1); i++) {
            //var temp = this.MaxGrpIdEachLevel[i - 1];
            this.MaxGrpIdEachLevel[i - 1] = this.MaxGrpIdEachLevel[i];
        }
    }



    generateDefaultGroupId(): boolean {
        var parent: Group = TerritoryComponent.clickedParent;
        this.groupParentName = parent.Name;
        this.defaultGroupPrefixID = parent.CustomGroupNumberSpace;
        var clickedGroup = this.getClickedGroup();
        if (this.territory.Levels.length != +parent.GroupNumber.charAt(0)) {
            if (clickedGroup.Children && !this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1]) {
                //console.log("+parent.GroupNumber.charAt(0)..." + +parent.GroupNumber.charAt(0));
                var currentLevel = this.territory.Levels[+parent.GroupNumber.charAt(0)]; //given current level
                var newId = this.getLevelFromGroup(clickedGroup.GroupNumber);
                this.curtLevelMaxGroupId = 0;
                var defaultId = this.currentLevelMaxGroupId(parent, currentLevel) + 1;
                this.curtLevelMaxGroupId = 0;
                var temp = this.zeroFill(defaultId, currentLevel.LevelIDLength, 0);

                for (var x = 0; x < parent.Children.length; x++) {
                    if (parent.Children[x].CustomGroupNumber == (parent.CustomGroupNumber + temp)) {
                        defaultId = defaultId + 1;
                        temp = this.zeroFill(defaultId, currentLevel.LevelIDLength, 0);
                    }
                }
                // when prepopulated Id len > level Id len, then GroupId box= ''
                if (this.zeroFill(defaultId, currentLevel.LevelIDLength, 0).length > currentLevel.LevelIDLength)
                    this.defaultGroupNumber = '';
                else
                    this.defaultGroupNumber = this.zeroFill(defaultId, currentLevel.LevelIDLength, 0);
                // this.IsAvailableGroupNumber = true;
                return true;
            }

            else {
                var currentLevel = this.territory.Levels[+parent.GroupNumber.charAt(0)];
                //for mid level's 1st group 
                if (this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1] == true) {
                    this.MaxGrpIdEachLevel[currentLevel.LevelNumber] = 1;
                    this.defaultGroupNumber = this.zeroFill(this.MaxGrpIdEachLevel[+parent.GroupNumber.charAt(0) + 1], currentLevel.LevelIDLength, 0);
                }
                //for other 1st groups of level/any parent
                else {
                    var defaultId = 1;//this.MaxGrpIdEachLevel[+parent.GroupNumber.charAt(0) + 1] + 1;
                    //console.log("this.MaxGrpIdEachLevel[currentLevel.LevelNumber]  " + this.MaxGrpIdEachLevel[+parent.GroupNumber.charAt(0) + 1]);
                    this.defaultGroupNumber = this.zeroFill(defaultId, currentLevel.LevelIDLength, 0);
                }
                return true;
            }
        }
        else {
            TerritoryComponent.modalTitle = "Next Level not found!!";
            jQuery("#nextModal").modal("show");
        }


    }

    async fnEnabledMultiGroup(event: any) {
        if (event.target.checked) {
            this.isMultiGroupAddChecked = true;
            this.territory.listOfGroups = [];
            // await this.territory.fnBindDropdownForGroups(this.territory.RootGroup);
            // this.listOfGroups = this.territory.listOfGroups;
            // await this.territory.fnFindGroupUsingGroupId(this.territory.RootGroup, 11);
            // TerritoryComponent.clickedParent = this.territory.selectedGroup;
            // this.territory.selectedGroup = null;
            // this.generateDefaultGroupId();
        } else {
            this.isMultiGroupAddChecked = false;
        }

    }

    async fnChangeGroupListDD(event: any) {
        let selectedGroup = JSON.parse(event.target.value);
        await this.territory.fnFindGroupUsingGroupId(this.territory.RootGroup, selectedGroup.GroupNumber);
        TerritoryComponent.clickedParent = this.territory.selectedGroup;
        this.territory.selectedGroup = null;
        this.generateDefaultGroupId();
    }

    async addMultiGroup(groupName: string, groupID: string) {
        if (groupName.trim() == "") {
            jQuery("#groupIdCheckErrorMessage").html("Group name is required.");
            return false;
        } else if (groupID.trim() == "") {
            jQuery("#groupIdCheckErrorMessage").html("Group ID is required.");
            return false;
        }
        if (groupName.trim().toLocaleLowerCase() == "unassigned") {
            jQuery("#groupIdCheckErrorMessage").html("'unassigned' name is an restricted, try different name");
            return false;
        }

        if (groupName.trim().length > 15) {
            jQuery("#groupIdCheckErrorMessage").html("Name of the Group cannot exceed 15 characters");
            return false;
        }

        if (typeof TerritoryComponent.clickedParent.Children != 'undefined' && TerritoryComponent.clickedParent.Children) {
            for (var i = 0; i < TerritoryComponent.clickedParent.Children.length; i++) {
                if (!TerritoryComponent.clickedParent.Children[i].IsOrphan && TerritoryComponent.clickedParent.Children[i].Name.toLowerCase().trim() == groupName.toLowerCase().trim()) {
                    jQuery("#groupIdCheckErrorMessage").html("Group <b>" + groupName + "</b> already exists under level " + Number(Number(TerritoryComponent.clickedParent.GroupNumber.charAt(0)) + 1) + " <b>" + TerritoryComponent.Levels[Number(TerritoryComponent.clickedParent.GroupNumber.charAt(0))].Name + "</b>.");
                    return false;
                }
            }
        }

        //for ID Generation
        var parent: Group = TerritoryComponent.clickedParent;
        var clickedGroup = this.getClickedGroup();
        if (this.territory.Levels.length != +parent.GroupNumber.charAt(0)) {
            var currentLevel = this.territory.Levels[+parent.GroupNumber.charAt(0)]; //given current level

            //
            if (groupID.length != currentLevel.LevelIDLength) {
                jQuery("#groupIdCheckErrorMessage").html("The group id selected for this new group in level <b>" + currentLevel.Name + "</b> is longer than the current group id length. Please adjust the group ID length of this level <b>" + currentLevel.Name + "</b> or select a valid group id within the current group id length.");
                return false;
            } else if (Number(groupID) == Math.pow(10, currentLevel.LevelIDLength) - 1) {
                jQuery("#groupIdCheckErrorMessage").html("This group ID is restricted, hence cannot be used. Please select another group ID for this group.");
                return false;
            }
            if (await this.ifGroupIdExists(parent, currentLevel, groupID) && !this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1]) {
                jQuery("#groupIdCheckErrorMessage").html("This group ID has already been used for a group in this level. Please select another group ID for this new group.");
                //console.log("----2----");
                this.result = false;
            }
            else {
                if (groupID.length == currentLevel.LevelIDLength) {
                    //console.log("----4----");
                    //console.log(groupName + "--" + groupID);
                    var newGroup: Group = { Id: 1, GroupNumber: groupID, CustomGroupNumber: parent.CustomGroupNumber + groupID, CustomGroupNumberSpace: parent.CustomGroupNumberSpace + ' ' + groupID, Name: groupName, IsOrphan: false, PaddingLeft: 130, ParentId: parent.Id, Children: null, ParentGroupNumber: parent.GroupNumber, TerritoryId: 0 };
                    this.territory.addGroup(this.territory.RootGroup, parent, newGroup);
                    console.log(this.territory);
                    TerritoryComponent.Groups = this.territory.RootGroup;
                    console.log(currentLevel.LevelNumber);
                    this.MaxGrpIdEachLevel[currentLevel.LevelNumber] = +groupID;//need to check; to solve problem of multiple add group click but no save
                    if (this.isMultiGroupAddChecked) {
                        jQuery("#inputGroupName").val("");
                        this.generateDefaultGroupId();
                    } else {
                        this.clearGroupModal();
                    }
                }
                else if (groupID.length < currentLevel.LevelIDLength) {
                    var PaddedGroupId = this.zeroFill(groupID, currentLevel.LevelIDLength, 0);
                    var newGroup: Group = { Id: 1, GroupNumber: groupID, CustomGroupNumber: parent.CustomGroupNumber + PaddedGroupId, CustomGroupNumberSpace: parent.CustomGroupNumberSpace + ' ' + PaddedGroupId, Name: groupName, IsOrphan: false, PaddingLeft: 130, ParentId: parent.Id, Children: null, ParentGroupNumber: parent.GroupNumber, TerritoryId: 0 };
                    this.territory.addGroup(this.territory.RootGroup, parent, newGroup);
                    this.MaxGrpIdEachLevel[currentLevel.LevelNumber] = +groupID;//need to check; to solve problem of multiple add group click but no save                   
                    TerritoryComponent.Groups = this.territory.RootGroup;
                    if (this.isMultiGroupAddChecked) {
                        jQuery("#inputGroupName").val("");
                        this.generateDefaultGroupId();
                    } else {
                        this.clearGroupModal();
                    }
                    //if (this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1])//for 1st group of mid level add
                    //    this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1] = false;
                }
                else if (groupID.length != currentLevel.LevelIDLength) {
                    //jQuery("#groupIdCheckErrorMessage").html("An ID of length (" + currentLevel.LevelIDLength + "+1) cannot be used for this group, please adjust ID length for this level before proceeding");
                    jQuery("#groupIdCheckErrorMessage").html("The group id selected for this new group in level <b>" + currentLevel.Name + "</b> is longer than the current group id length. Please adjust the group ID length of this level <b>" + currentLevel.Name + "</b> or select a valid group id within the current group id length.");

                }


                else if (+(parent.CustomGroupNumber + groupID) == this.constantIdLen)// 8 digit
                {
                    jQuery("#groupIdCheckErrorMessage").html("An ID of length (" + currentLevel.LevelIDLength + "+1) cannot be used for this group, please adjust ID length for this level before proceeding");
                }
            }
        }
        else {
            TerritoryComponent.modalTitle = "Next Level not found!!";
            jQuery("#nextModal").modal("show");
        }

        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }

    async addGroup(groupName: string, groupID: string) {
        if (groupName.trim() == "") {
            jQuery("#groupIdCheckErrorMessage").html("Group name is required.");
            return false;
        } else if (groupID.trim() == "") {
            jQuery("#groupIdCheckErrorMessage").html("Group ID is required.");
            return false;
        }

        if (groupName.trim().length > 15) {
            jQuery("#groupIdCheckErrorMessage").html("Name of the Group cannot exceed 15 characters");
            return false;
        }

        if (typeof TerritoryComponent.clickedParent.Children != 'undefined' && TerritoryComponent.clickedParent.Children) {
            for (var i = 0; i < TerritoryComponent.clickedParent.Children.length; i++) {
                if (!TerritoryComponent.clickedParent.Children[i].IsOrphan && TerritoryComponent.clickedParent.Children[i].Name.toLowerCase().trim() == groupName.toLowerCase().trim()) {
                    jQuery("#groupIdCheckErrorMessage").html("Group <b>" + groupName + "</b> already exists under level " + Number(Number(TerritoryComponent.clickedParent.GroupNumber.charAt(0)) + 1) + " <b>" + TerritoryComponent.Levels[Number(TerritoryComponent.clickedParent.GroupNumber.charAt(0))].Name + "</b>.");
                    return false;
                }
            }
        }

        //for ID Generation
        var parent: Group = TerritoryComponent.clickedParent;
        var clickedGroup = this.getClickedGroup();
        console.log(groupName + "--" + groupID);
        if (this.territory.Levels.length != +parent.GroupNumber.charAt(0)) {
            var currentLevel = this.territory.Levels[+parent.GroupNumber.charAt(0)]; //given current level
            if (await this.ifGroupIdExists(parent, currentLevel, groupID) && !this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1]) {
                jQuery("#groupIdCheckErrorMessage").html("This group ID has already been used for a group in this level. Please select another group ID for this new group.");
                console.log("----2----");
                this.result = false;
            }
            else {
                if (groupID.length == currentLevel.LevelIDLength) {
                    console.log("----4----");
                    console.log(groupName + "--" + groupID);
                    var newGroup: Group = { Id: 1, GroupNumber: groupID, CustomGroupNumber: parent.CustomGroupNumber + groupID, CustomGroupNumberSpace: parent.CustomGroupNumberSpace + ' ' + groupID, Name: groupName, IsOrphan: false, PaddingLeft: 130, ParentId: parent.Id, Children: null, ParentGroupNumber: parent.GroupNumber, TerritoryId: 0 };
                    this.territory.addGroup(this.territory.RootGroup, parent, newGroup);
                    this.clearGroupModal();
                    console.log(this.territory);
                    TerritoryComponent.Groups = this.territory.RootGroup;
                    console.log(currentLevel.LevelNumber);
                    this.MaxGrpIdEachLevel[currentLevel.LevelNumber] = +groupID;//need to check; to solve problem of multiple add group click but no save
                    //if (this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1])//for 1st group of mid level add
                    //    this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1] = false;
                }
                else if (groupID.length < currentLevel.LevelIDLength) {
                    var PaddedGroupId = this.zeroFill(groupID, currentLevel.LevelIDLength, 0);
                    var newGroup: Group = { Id: 1, GroupNumber: groupID, CustomGroupNumber: parent.CustomGroupNumber + PaddedGroupId, CustomGroupNumberSpace: parent.CustomGroupNumberSpace + ' ' + PaddedGroupId, Name: groupName, IsOrphan: false, PaddingLeft: 130, ParentId: parent.Id, Children: null, ParentGroupNumber: parent.GroupNumber, TerritoryId: 0 };
                    this.territory.addGroup(this.territory.RootGroup, parent, newGroup);
                    this.MaxGrpIdEachLevel[currentLevel.LevelNumber] = +groupID;//need to check; to solve problem of multiple add group click but no save
                    this.clearGroupModal();
                    console.log(this.territory);
                    TerritoryComponent.Groups = this.territory.RootGroup;

                    //if (this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1])//for 1st group of mid level add
                    //    this.LogMidLevel[+parent.GroupNumber.charAt(0) + 1] = false;
                }
                else if (groupID.length != currentLevel.LevelIDLength) {
                    //jQuery("#groupIdCheckErrorMessage").html("An ID of length (" + currentLevel.LevelIDLength + "+1) cannot be used for this group, please adjust ID length for this level before proceeding");
                    jQuery("#groupIdCheckErrorMessage").html("The group id selected for this new group in level <b>" + currentLevel.Name + "</b> is longer than the current group id length. Please adjust the group ID length of this level <b>" + currentLevel.Name + "</b> or select a valid group id within the current group id length.");

                }

                else if (+(parent.CustomGroupNumber + groupID) == this.constantIdLen)// 8 digit
                {
                    jQuery("#groupIdCheckErrorMessage").html("An ID of length (" + currentLevel.LevelIDLength + "+1) cannot be used for this group, please adjust ID length for this level before proceeding");
                }
            }
        }
        else {
            TerritoryComponent.modalTitle = "Next Level not found!!";
            jQuery("#nextModal").modal("show");
        }

        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }

    private _getCountSameNameGroupinParent(root: Group, parentNumber: string, groupName: string, selectedGroup: Group): number {
        var tempcount = 0;
        if (root.Name.trim() == groupName.trim() && !root.IsOrphan && root.ParentGroupNumber == parentNumber && root.GroupNumber != selectedGroup.GroupNumber) {
            tempcount = 1;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => tempcount += this._getCountSameNameGroupinParent(x, parentNumber, groupName, selectedGroup));
        }
        return tempcount;
    }


    async editGroup(groupName: string, groupID: string) {
        jQuery("#groupIdEditCheckErrorMessage").html("");
        if (groupName.trim() == "") {
            jQuery("#groupIdEditCheckErrorMessage").html("Group name is required.");
            return false;
        } else if (groupID.trim() == "") {
            jQuery("#groupIdEditCheckErrorMessage").html("Group ID is required.");
            return false;
        }

        if (groupName.trim().length > 15) {
            jQuery("#groupIdEditCheckErrorMessage").html("Name of the Group cannot exceed 15 characters");
            return false;
        }

        if (this._getCountSameNameGroupinParent(this.territory.RootGroup, TerritoryComponent.clickedParent.ParentGroupNumber, groupName, TerritoryComponent.clickedParent) > 0) {
            jQuery("#groupIdEditCheckErrorMessage").html("Group <b>" + groupName + "</b> already exists under level " + Number(Number(TerritoryComponent.clickedParent.GroupNumber.charAt(0))) + " <b>" + TerritoryComponent.Levels[Number(TerritoryComponent.clickedParent.GroupNumber.charAt(0)) - 1].Name + "</b>.");
            return false;
        }



        //for ID generation
        jQuery("#groupIdEditCheckErrorMessage").html("");
        var parent: Group = TerritoryComponent.clickedParent;
        var clickedGroup = this.getClickedGroup();
        var currentLevel = this.territory.Levels[+parent.GroupNumber.charAt(0) - 1]; //given current level
        var preFix = parent.CustomGroupNumber.substr(0, (parent.CustomGroupNumber.length - currentLevel.LevelIDLength));
        var preFixSpace = parent.CustomGroupNumberSpace.substr(0, (parent.CustomGroupNumberSpace.length - currentLevel.LevelIDLength));
        if (parent.CustomGroupNumber.substr((parent.CustomGroupNumber.length - currentLevel.LevelIDLength), currentLevel.LevelIDLength) == this.zeroFill(groupID, currentLevel.LevelIDLength, 0)) {
            this.territory.editGroup(this.territory.RootGroup, this.territory.RootGroup, TerritoryComponent.clickedParent, { Name: groupName, CustomGroupNumber: preFix + this.zeroFill(groupID, currentLevel.LevelIDLength, 0), CustomGroupNumberSpace: preFixSpace + this.zeroFill(groupID, currentLevel.LevelIDLength, 0) });
            jQuery("#editGroupModal").modal("hide");
        }
        else {
            //var parentGroup = this.currentParentGroup(this.territory.RootGroup, currentLevel, clickedGroup.GroupNumber);
            this.territory.returnGroup = null;
            await this.territory.getGroupsPassingId(this.territory.RootGroup, +clickedGroup.ParentGroupNumber);
            let parentGroup: Group = this.territory.returnGroup;
            if (await this.ifGroupIdExists(parentGroup, currentLevel, groupID)) {
                jQuery("#groupIdEditCheckErrorMessage").html("This group ID has already been used for a group in this level. Please select another group ID for this new group.");
                this.result = false;
            }
            else {
                if (groupID.length == currentLevel.LevelIDLength) {
                    this.territory.editGroup(this.territory.RootGroup, this.territory.RootGroup, TerritoryComponent.clickedParent, { Name: groupName, CustomGroupNumber: preFix + groupID, CustomGroupNumberSpace: preFixSpace + groupID });
                    jQuery("#editGroupModal").modal("hide");

                }
                else if (groupID.length < currentLevel.LevelIDLength) {
                    var PaddedGroupId = this.zeroFill(groupID, currentLevel.LevelIDLength, 0);
                    this.territory.editGroup(this.territory.RootGroup, this.territory.RootGroup, TerritoryComponent.clickedParent, { Name: groupName, CustomGroupNumber: preFix + PaddedGroupId, CustomGroupNumberSpace: preFixSpace + PaddedGroupId });
                    jQuery("#editGroupModal").modal("hide");

                }

                else if (groupID.length != currentLevel.LevelIDLength) {
                    jQuery("#groupIdEditCheckErrorMessage").html("The group id selected for this group in level <b>" + currentLevel.Name + "</b> is longer than the current group id length. Please adjust the group ID length of this level <b>" + currentLevel.Name + "</b> or select a valid group id within the current group id length.");
                }

                else if (+(parent.CustomGroupNumber + groupID) == this.constantIdLen) {// 8 digit
                    jQuery("#groupIdEditCheckErrorMessage").html("An ID of length (" + currentLevel.LevelIDLength + "+1) cannot be used for this group, please adjust ID length for this level before proceeding");
                }
            }
        }

        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }

    currentParentGroup(root: Group, currentLevel: Level, childGroupNumber: string): Group {
        if (+root.GroupNumber.charAt(0) == currentLevel.LevelNumber - 1) {
            for (var x = 0; x < root.Children.length; x++) {
                if (root.Children[x].GroupNumber == childGroupNumber)
                    return root;
            }
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.currentParentGroup(x, currentLevel, childGroupNumber));
            }
        }
        return root;
    }

    currentLevelMaxGroupId(root: Group, currentLevel: Level): number {
        if (+root.GroupNumber.charAt(0) == currentLevel.LevelNumber - 1) {
            for (var x = 0; x < root.Children.length; x++) {
                var actualId = root.Children[x].CustomGroupNumber.substr((root.Children[x].CustomGroupNumber.length - currentLevel.LevelIDLength), currentLevel.LevelIDLength);
                if ((this.curtLevelMaxGroupId < +actualId) && (+root.Children[x].GroupNumber.charAt(0) - +root.GroupNumber.charAt(0) == 1))// 2nd clause is for mid level add
                    this.curtLevelMaxGroupId = +actualId;
            }
            return this.curtLevelMaxGroupId;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.currentLevelMaxGroupId(x, currentLevel));
            }
        }
        return this.curtLevelMaxGroupId;
    }

    async ifGroupIdExists(root: Group, CurLevel: Level, searchId: string) {
        if (+root.GroupNumber.charAt(0) == CurLevel.LevelNumber - 1) {

            if (root.Children) {
                for (var i = 0; i < root.Children.length; i++) {
                    if (searchId.length < CurLevel.LevelIDLength) {
                        var PaddedGroupId = this.zeroFill(searchId, CurLevel.LevelIDLength, 0);
                        var rootCustomId = root.Children[i].CustomGroupNumber.substr((root.Children[i].CustomGroupNumber.length - PaddedGroupId.length), PaddedGroupId.length);
                        // 2nd clause is for mid level add
                        if ((rootCustomId == PaddedGroupId) && (+root.Children[i].GroupNumber.charAt(0) - +root.GroupNumber.charAt(0) == 1)) {
                            this.result = true;
                            break;
                        }
                    }
                    else {
                        var rootCustomId = root.Children[i].CustomGroupNumber.substr((root.Children[i].CustomGroupNumber.length - searchId.length), searchId.length);
                        // 2nd clause is for mid level add
                        if ((rootCustomId == searchId) && (+root.Children[i].GroupNumber.charAt(0) - +root.GroupNumber.charAt(0) == 1)) {
                            this.result = true;
                            break;
                        }
                    }
                }
            }

            return this.result;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.ifGroupIdExists(x, CurLevel, searchId));
            }
        }
        return this.result;
    }

    zeroFill(CustomGroupNumber: any, PaddingZero: number, Character: any): string {
        //var pad_char = typeof Character !== 'undefined' ? Character : '0';
        var pad_char = '0';
        PaddingZero = PaddingZero++;
        var temp = CustomGroupNumber.toString().length;
        var diff = PaddingZero - (+temp);
        diff = diff++;
        var pad = new Array(diff + 1).join(pad_char);
        return (pad + CustomGroupNumber);
    }



    clearGroupModal(): void {
        TerritoryComponent.clickedParent = null;
        this.defaultGroupNumber = null;
        this.listOfGroups = [];
        this.isMultiGroupAddChecked = false;
        jQuery("#addGroupModal").modal('hide');
        jQuery("#deleteGroupModal").modal('hide');
        jQuery("#editGroupModal").modal("hide");
        jQuery('#inputGroupName').val("");
        jQuery('#inputGroupID').val("");
        jQuery("#groupIdCheckErrorMessage").html("");
    }

    ngOnInit(): void {
        TerritoryComponent.globalDisableFlag = false;
        this._getUserRole();

        var t: Territory;
        this.territoryService.territorySharedData = { title: "Create New Territory", task: "Create New Territory" };
        this.territoryService.isChangeDetectedInTerritorySetup = false;
        this.territoryService.isChangeDetectedInTerritoryDef = false;

        if (jQuery(".dropdown-menu li:contains('My Territories')").length > 0) {
            this.toggleTitle = "My Territories";
            //this.breadCrumbUrl = "/territory/My-Client";
            this.breadCrumbUrl = "/territories/myterritories";
        }
        else {
            //console.log('ConfigService.clientFlag: ', ConfigService.clientFlag);
            this.toggleTitle = ConfigService.clientFlag ? "My Clients" : "All Clients";
            this.breadCrumbUrl = ConfigService.clientFlag ? "/territory/My-Client" : "/territoryAllClient/All-Client";
        }

        TerritoryComponent.brickDetailsUnderTerritory = [];
        let paramID: string = this.route.snapshot.params['id'];
        this.lockType = this.route.snapshot.params['id2'];
        this.clientID = +paramID.split("|")[0];
        this.checkisInternalClient();
        //this.getIMSStandardStructureOption();

        if (paramID != "" && paramID != "undefined" && typeof paramID != 'undefined') {
            if (paramID.indexOf('|') > 0) {
                this.territoryService.fnSetLoadingAction(true);
                this.isEditTerritoryDef = true;
                this.enabledBrickCreation = true;
                this.editableClientID = Number(paramID.split("|")[0]);
                this.editableTerritoryDefID = Number(paramID.split("|")[1]);
                this.territoryDefPageTitle = "Edit Territory";
                this.territoryService.territorySharedData = { title: "Edit Levels and Groups", task: "Edit Territory" };
                this.fnPullTerritoryDetails();


                //to lock history
                this.deactiveGuard.fnNewLock(this.loginUserObj.UserID, this.editableTerritoryDefID, "Territory Module", this.lockType, "Create Lock")
                    .then(result => { })
                    .catch((err: any) => { this.territoryService.fnSetLoadingAction(false); });
            } else {
                this.territoryService.fnSetLoadingAction(true);
                this.isNewBrickCreation = true;
                this.editableClientID = Number(paramID);

                //for IMS Standard Hierarchy		
                this.optionsForBaseFilter = [];
                this.optionsForBaseFilter.push('Brick Base');
                this.optionsForBaseFilter.push('Outlet Base');
                //this.territoryService.checkIMSHierarchy(this.clientID, 0, 'IMS Standard Outlet Structure').subscribe((data: boolean) => {
                //    this.IsUsedIMSOutletHierarchy = data;
                //    if (!this.IsUsedIMSOutletHierarchy) {
                //        //this.optionsForTerritoryBase = "IMS Standard Outlet Structure";
                //    }
                //});

                //to pull role permission
                this.loadUserData();

                //to populate SRA information
                try {
                    this.territoryService.fnPopulateSRAInfo(this.clientID).then((data: boolean) => {
                        this.territory.SRA_Client = data[0].SRA_Client || "";
                        this.territory.SRA_Suffix = data[0].SRA_Suffix || "";
                        this.territory.AD = data[0].AD || "";
                        this.territory.LD = data[0].LD || "";
                        this.tempTerritorySRAInfo = { SRA_Client: this.territory.SRA_Client, SRA_Suffix: this.territory.SRA_Suffix, AD: this.territory.AD, LD: this.territory.LD };
                        this.territoryService.fnSetLoadingAction(false);
                        if (data[0].IsUsed) {
                            TerritoryComponent.modalSaveBtnVisibility = false;
                            TerritoryComponent.modalSaveFnParameter = "";
                            TerritoryComponent.modalTitle = "A Territory cannot be created as system cannot suggest an unique suffix for the selected SRA Client.";
                            TerritoryComponent.modalCloseBtnCaption = "Ok";
                            this.territoryService.fnSetLoadingAction(false);
                            jQuery("#nextModal").modal("show");
                            return false;
                        }
                        //console.log(data);
                    });
                } catch (ex) {
                    this.territoryService.fnSetLoadingAction(false);
                    console.log("error");
                }


                //to generate standard structure info
                //this.territoryService.checkIMSHierarchy(this.clientID, 0, 'IMS Standard Brick Structure').subscribe((data: boolean) => {
                //    //console.log("IMS Standard Brick Structure.." + data);
                //    this.IsUsedIMSBrickHierarchy = data;
                //    if (!this.IsUsedIMSBrickHierarchy) {
                //        this.optionsForTerritoryBase = "IMS Standard Brick Structure";
                //    }
                //});

                this.checkIMSStandardOptions();

            }

        } else {
            this.isEditTerritoryDef = false;
            this.editableClientID = 0;
            this.editableTerritoryDefID = 0;
            this.territoryDefPageTitle = "Create New Territory";
            this.territoryService.territorySharedData = { title: "Create New Territory", task: "Create New Territory" };
            //to generate new SRA info
            //this.territoryService.checkIMSHierarchy(this.clientID, 0, 'IMS Standard Brick Structure').subscribe((data: boolean) => {
            //    //console.log("IMS Standard Brick Structure.." + data);
            //    this.IsUsedIMSBrickHierarchy = data;
            //    if (!this.IsUsedIMSBrickHierarchy) {
            //        this.optionsForTerritoryBase = "IMS Standard Brick Structure";
            //    }
            //});
            this.checkIMSStandardOptions();
            this.loadUserData();
        }

        this.createTerrLink = '/territory-create/' + this.editableClientID;


    }

    checkIMSStandardOptions() {
        this.territoryService.getAllTerritoriesName(this.clientID)
            .then((data: any) => {
                console.log("data...",data);
                if (data != null) {
                    this.allTerritoriesList = data||[];
                    this.territoryService.getIMSStandardStructureOption()
                        .then((o: any) => {
                            if (o != null) {
                                this.IMSStandardStructureOption = o;
                            }
                            
                           //var result = data.filter(x => this.IMSStandardStructureOption.map(x => x.Name).includes(x.Name));
                            var result = data.filter(x => this.IMSStandardStructureOption.map(x => x.Name).indexOf(x.Name)>-1);

                            if (result.length > 0) {
                                let isBrickBased = result.filter(x => x.IsBrickBased == true);
                                if (isBrickBased.length > 0)
                                    this.IsUsedIMSBrickHierarchy = true;
                                else
                                    this.IsUsedIMSBrickHierarchy = false;

                                let isOutletBased = result.filter(x => x.IsBrickBased == false);
                                if (isOutletBased.length > 0)
                                    this.IsUsedIMSOutletHierarchy = true;
                                else
                                    this.IsUsedIMSOutletHierarchy = false;
                            }
                            else {
                                this.IsUsedIMSBrickHierarchy = false;
                                this.IsUsedIMSOutletHierarchy = false;
                            }
                            //var options = this.IMSStandardStructureOption.filter(x => !data.map(x => x.Name).includes(x.Name));
                            var options = this.IMSStandardStructureOption.filter(x => !(data.map(x => x.Name).indexOf(x.Name)>-1));
                            let brickBase = options.filter(x => x.IsBrickBased == true).map(x => x.Name);
                            if (brickBase.length > 0) {
                                this.optionsForTerritoryBase = brickBase;
                            }
                        });
                }
                else {
                    this.territoryService.getIMSStandardStructureOption()
                        .then((o: any) => {
                            if (o != null) {
                                this.IMSStandardStructureOption = o;
                            }


                            this.IsUsedIMSBrickHierarchy = false;
                            this.IsUsedIMSOutletHierarchy = false;

                            let brickBase = this.IMSStandardStructureOption.filter(x => x.IsBrickBased == true).map(x => x.Name);
                            if (brickBase.length > 0) {
                                this.optionsForTerritoryBase = brickBase;
                            }
                        });
                }
            });
    }


    ngDoCheck() {
        jQuery(".dynamic-height-col").css("height", jQuery('.column-1').height() + 100);
        // for all groups except Australia's children, generate ID
        if (TerritoryComponent.GroupIdFlag) {
            this.groupParentName = "";
            if (this.generateDefaultGroupId()) {
                //count group of this level
                let groupIDLength = +TerritoryComponent.Levels[TerritoryComponent.clickedParent.GroupNumber.charAt(0)].LevelIDLength;
                let maximumGroupNumberToBe = Math.pow(10, groupIDLength) - 1;
                if (maximumGroupNumberToBe <= this.territory._levelGroupCount(TerritoryComponent.Groups, +TerritoryComponent.clickedParent.GroupNumber.charAt(0), )) {
                    TerritoryComponent.modalTitle = "Group ID length has been exceeded of level <b>" + TerritoryComponent.Levels[TerritoryComponent.clickedParent.GroupNumber.charAt(0)].Name + "</b>, please adjust before adding any further groups.";
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    TerritoryComponent.modalSaveFnParameter = "";
                    jQuery("#nextModal").modal("show");
                    TerritoryComponent.GroupIdFlag = false;
                    return false;
                }
                jQuery("#groupIdCheckErrorMessage").html("");
                this.groupParentName = TerritoryComponent.clickedParent.Name;
                this.defaultGroupPrefixID = TerritoryComponent.clickedParent.CustomGroupNumberSpace;
                jQuery("#addGroupModal").modal('show');
                this.isMultiGroupAddChecked = false;
                TerritoryComponent.GroupIdFlag = false;
                setTimeout(function () { jQuery("#inputGroupName").focus(); }, 500);
            }
        }

        if (TerritoryComponent.generateLinkToParentModal) {
            this.territory.returnGroup = null;
            this.territory.getGroupsPassingId(this.territory.RootGroup, +TerritoryComponent.clickedParent.ParentGroupNumber);
            this.parentNodeNameOfSelectedNode = this.territory.returnGroup.Name;
            this.isCheckedMultiNodeShift = false;
            TerritoryComponent.generateLinkToParentModal = false;
        }

        if (this.territoryService.isChangeDetectedInTerritorySetup) {//disabled territory header save button
            this.IsTerritoryHeaderSectionChanged = false;
        } else {
            this.fnChangeDetectionInTerritoryHeaderSection();
        }


        //for collapse expaned clicked detection
        if (TerritoryComponent.IsChangedInCollapsExpaned) {
            TerritoryComponent.IsChangedInCollapsExpaned = false;
            this.territory.returnGroup = null;
            if (this.savedTerritory != null) {
                this.territory.fnUpdateCollapseExpandFlag(this.savedTerritory.RootGroup, TerritoryComponent.collapseExpanedClickedNode);
                // this.territory.fnReorderOfTerritoryGroups(this.savedTerritory.RootGroup, 'asc');
            }

        }
    }


    getFootHeight(): number {
        return (Number(jQuery('.column-1').height()) + 100);
    }

    async fnModalConfirmationClick(event: any) {
        if (event == "Delete Bricks From Level") {
            if (jQuery("#nextModal").modal("hide")) {
                jQuery("#addLevelModal").modal('show');
                setTimeout(function () { jQuery("#inputLevelName").focus(); }, 500);
            }
        }
        if (event == "Add level between levels") {
            if (jQuery("#nextModal").modal("hide")) {
                jQuery("#addLevelModal").modal('show');
                setTimeout(function () { jQuery("#inputLevelName").focus(); }, 500);
            }
        }
        else if (event == "Delete Bricks From Add Group") {
            if (this.generateDefaultGroupId()) {
                jQuery("#addGroupModal").modal('show');
                setTimeout(function () { jQuery("#inputGroupName").focus(); }, 500);
            }
        }
        else if (event == "Delete Group") {
            if (jQuery("#nextModal").modal("hide")) {
                var delGroup: Group = TerritoryComponent.clickedParent;
                if (this.territory.deleteGroup(this.territory.RootGroup, this.territory.RootGroup, delGroup)) {
                    //this.territory.updateGroupId(delGroup); 
                    this.clearGroupModal();
                }
                TerritoryComponent.Groups = this.territory.RootGroup;
            }
        }
        else if (event == "Delete Bricks From Delete Group") {
            jQuery("#deleteGroupModal").modal('show');

        }
        else if (event == "Unsaved Territory Saved") {
            if (jQuery("#nextModal").modal("hide")) {
                this.btnSave_Click();
                jQuery("#nextModal").modal("hide")

                //this.HeightBalanceCheck();
                //this.fnGenerateBricks();

                //to check next level
                var len = this.territory.Levels.length;
                var orfanNumber = + await this.ifOrphanExistsInTree();
                if (orfanNumber == 0) {
                    this.IsHeightBalance(this.territory.RootGroup, len);
                    if (this.IsHeightBalanceCase1Flag == false || this.IsHeightBalanceCase2Flag != true) {
                        //TerritoryComponent.modalTitle = "Tree Height is not balanced. Please balance it before proceeding";
                        TerritoryComponent.modalTitle = "Not all levels have necessary groups, please review.";
                        TerritoryComponent.modalSaveBtnVisibility = false;
                        TerritoryComponent.modalCloseBtnCaption = "Ok";
                        TerritoryComponent.modalSaveFnParameter = "";
                        jQuery("#customModal").modal("show");
                        this.IsHeightBalanceCase1Flag = true;
                        this.IsHeightBalanceCase2Flag = false;

                        return;
                    }
                    else {
                        TerritoryComponent.modalTitle = "Changes made to the territory will apply to the <b>" + this.brickOutletType + "</b> allocation.";
                        TerritoryComponent.modalSaveBtnVisibility = false;
                        TerritoryComponent.modalCloseBtnCaption = "Ok";
                        TerritoryComponent.modalSaveFnParameter = "Go to Allocation Page";
                        jQuery("#customModal").modal("show");
                    }

                    this.IsHeightBalanceCase1Flag = true;
                    this.IsHeightBalanceCase2Flag = false;
                }
                else {
                    TerritoryComponent.modalTitle = "Link to parent the orphan group(s) before proceeding";
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    TerritoryComponent.modalSaveFnParameter = "";
                    jQuery("#customModal").modal("show");
                }

            }

        }
        else if (event == "Delete Level") {
            if (jQuery("#nextModal").modal("hide")) {
                this.deleteLevel(this.clickedLevelID);
            }

        } else if (event == "Back to previous state") {
            if (jQuery("#nextModal").modal("hide")) {
                this.btnCancel_Click();

                //mgs after Cancel
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalTitle = "Changes made to the territory hierarchy have not been applied to the <b>" + this.brickOutletType + "</b> allocation.";
                TerritoryComponent.modalCloseBtnCaption = "Ok";
                TerritoryComponent.modalSaveFnParameter = "";
                jQuery("#customModal").modal("show");


            }
        } else if (event == "back to territory tiles page") {
            if (jQuery("#customModal").modal("hide")) {
                if (this.authService.selectedTerritoryModule == "" || this.authService.selectedTerritoryModule == null) {
                    this.router.navigate(['territory/My-Client/' + this.editableClientID]);
                } else {
                    if (this.authService.selectedTerritoryModule == "myterritories") {
                        this.router.navigate(['territories/' + this.authService.selectedTerritoryModule + '/' + this.editableClientID]);
                    } else {
                        //this.router.navigate(['territory/' + this.authService.selectedTerritoryModule + '/' + this.editableClientID]);
                        this.router.navigate(['territory/My-Client/' + this.editableClientID]);
                    }

                }

            }
        } else if (event == "Save territory structure using copy method") {
            jQuery("#customModal").modal("hide")
            let type = "IMS Standard Structure";
            this.territoryService.fnSetLoadingAction(true);
            this.territoryService.fnCopyTerritory(this.clientID, 0, this.territory.Name, type).subscribe((data: any) => {
                this.territoryService.fnSetLoadingAction(false);
                TerritoryComponent.brickDetailsUnderTerritory = data[0].OutletBrickAllocation || [];
                this.enabledTerritoryHeader = false;
                this.territory.Id = data[0].Id;
                this.territory.Name = data[0].Name;
                this.territory.Client_Id = data[0].Client_Id;
                this.territory.IsBrickBased = data[0].IsBrickBased;
                this.territory.IsUsed = data[0].IsUsed;
                this.territory.Levels = data[0].Levels || [];
                this.territory.RootGroup = data[0].RootGroup || [];
                this.territory.GuiId = data[0].GuiId;
                this.territory.OrphanGroups = data[0].OrphanGroups || [];
                this.territory.groupsInLevel = data[0].groupsInLevel || [];
                this.territory.OutletBrickAllocation = data[0].OutletBrickAllocation || [];
                this.territory.updateLevelColor();
                TerritoryComponent.Groups = this.territory.RootGroup;
                TerritoryComponent.Levels = this.territory.Levels;
                this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
                this.territoryService.fnSetLoadingAction(false);
                this.savedTerritory = jQuery.extend(true, {}, this.territory);
                this.territoryService.isChangeDetectedInTerritoryDef = false;
                this.authService.isTimeout = false;
                //find last of after pulling data from db
                this.territory.groupsInLevel = [];
                this.territory._groupsInLevel(this.territory.RootGroup, this.territory.Levels.length);
                TerritoryComponent.territoryNodes = this.territory.groupsInLevel;
                this.isEditTerritoryDef = true;
                this.isImsTerritory = true;
                this.territoryService.isChangeDetectedInTerritorySetup = false;
                this.router.navigate(['territory-create/' + data[0].Client_Id + '|' + data[0].Id + '/View Lock']);

                TerritoryComponent.modalTitle = "Territory structure has been saved successfully.";
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalCloseBtnCaption = "Ok";
                TerritoryComponent.modalSaveFnParameter = "";
                jQuery("#customModal").modal("show");
                //to get available brick/outlet from db
                this.territoryService.getAvailableBrickOutletUpdated((this.territory.IsBrickBased == true) ? 'brick' : 'Outlet', this.territory.Id, this.userRole, this.territory.Client_Id).subscribe((data: any) => {
                    this.availbleBricks = data || [];
                });

            },
                (err: any) => {
                    this.territoryService.fnSetLoadingAction(false);
                    TerritoryComponent.modalTitle = "System has been failed to save territory information. Please try again.";
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    TerritoryComponent.modalSaveFnParameter = "";
                    jQuery("#customModal").modal("show");
                    console.log(err);
                }
            );
        }

        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
    }
    private _isBrickExistsInLastLevel(root: Group, lastLevelNumber: number): number {
        if (!root) return;
        if (+root.GroupNumber.charAt(0) == lastLevelNumber) {
            var count = 0;
            for (let node of TerritoryComponent.territoryNodes) {
                if (node.GroupNumber && +node.GroupNumber.charAt(0) === this.territory.Levels.length && node.BrickOutletCount > 0 && node.GroupNumber == root.GroupNumber) {
                    count = 1;
                    break;
                }
            }
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => count = count + this._isBrickExistsInLastLevel(x, lastLevelNumber));
        }

        return count;

    }

    async fnActionOnLevel(action: string, data: Level, levelDisabledFlag: boolean = false) {
        jQuery("#addLevelErrorMessage").html("");
        jQuery("#inputLevelName").val("");
        //to check level btn disaabled
        if (levelDisabledFlag || this.getGlobalDisableFlag()) {
            return false;
        }

        if (action === "add") {
            let IsOrphanGroupExists = await this.ifOrphanExistsInTree()
            if (+IsOrphanGroupExists > 0) {
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalTitle = "Please assign parent to parentless Group(s) before proceeding.";
                TerritoryComponent.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
            }
            else {
                this.clickedLevelID = data.LevelNumber;
                this.clickedLevel = data;
                this.levelModalAction = "add";
                this.levelModalTitle = "Add Level";
                jQuery("#idLength").val(this.initialLengthofLevel[this.clickedLevelID]);
                if (this.enabledBrickCreation && this._isBrickExistsInLastLevel(this.territory.RootGroup, this.territory.Levels.length) > 0) {
                    TerritoryComponent.modalSaveBtnVisibility = true;
                    TerritoryComponent.modalSaveFnParameter = "Delete Bricks From Level";
                    TerritoryComponent.modalTitle = "Bricks allocation will be deleted.Do you want to proceed?";
                    TerritoryComponent.modalBtnCapton = "Yes";
                    TerritoryComponent.modalCloseBtnCaption = "Cancel";
                    jQuery("#nextModal").modal("show");
                }
                else if (data.LevelNumber < this.territory.Levels.length && this.territory._levelGroupCount(this.territory.RootGroup, data.LevelNumber) > 0) {
                    TerritoryComponent.modalSaveBtnVisibility = true;
                    TerritoryComponent.modalSaveFnParameter = "Add level between levels";
                    TerritoryComponent.modalTitle = "Adding a level will remove the relationships among the nodes of existing levels, would you like to proceed?";
                    TerritoryComponent.modalBtnCapton = "Yes";
                    TerritoryComponent.modalCloseBtnCaption = "Cancel";
                    jQuery("#nextModal").modal("show");
                }
                else {
                    jQuery("#addLevelModal").modal('show');
                    setTimeout(function () { jQuery("#inputLevelName").focus(); }, 500);
                    return;
                }
            }
        } else if (action == "edit") {
            let IsOrphanGroupExists = + await this.ifOrphanExistsInTree()
            if (IsOrphanGroupExists > 0) {
                TerritoryComponent.modalTitle = "Please assign parent to parentless Group(s) before editing Level.";
                jQuery("#nextModal").modal("show");
            }
            else {
                this.clickedLevel = data;
                this.levelModalAction = "edit";
                this.levelModalTitle = "Edit Level";
                jQuery("#inputLevelName").val(data.Name);
                jQuery("#idLength").val(data.LevelIDLength);
                jQuery("#addLevelModal").modal('show');
                setTimeout(function () { jQuery("#inputLevelName").focus(); }, 500);
            }
        }
        else if (action === "delete") {
            if (this.orphanGroupsCountInNextLevel(+data.LevelNumber - 1) > 0) {
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalSaveFnParameter = "Un-Assigned";
                TerritoryComponent.modalTitle = "There are parentless Group(s) in this level(" + data.Name + "). Either assign parent or delete previous group before proceeding.";
                TerritoryComponent.modalBtnCapton = "Yes";
                TerritoryComponent.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
            }
            else {
                this.clickedLevelID = data.LevelNumber || 0;
                let IsOrphanGroupExists = + await this.ifOrphanExistsInTree()
                if (IsOrphanGroupExists > 0) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalTitle = "Please assign parent to parentless Group(s) before deleting <b>" + data.Name + "</b> level.";
                    TerritoryComponent.modalCloseBtnCaption = "Close";
                    TerritoryComponent.modalSaveFnParameter = "";
                    jQuery("#nextModal").modal("show");
                    return false;
                }

                else {
                    if (this.clickedLevelID < this.territory.Levels.length) {
                        //TerritoryComponent.modalTitle = "Deleting level <b>" + data.Name + "</b> will remove the relationships among the nodes of existing levels, would you like to proceed?";
                        TerritoryComponent.modalTitle = "Deleting level <b>" + data.Name + "</b> will delete all association with subsequent levels. Would you like to proceed?";
                    }
                    else {
                        //for editing mood all nodes are connected 
                        if (this.isEditTerritoryDef) {
                            TerritoryComponent.modalTitle = "Deleting level <b>" + data.Name + "</b> will delete all <b>" + this.brickOutletType.toLowerCase() + "</b> allocation. Would you like to proceed?";
                        } else {
                            TerritoryComponent.modalTitle = "Deleting level <b>" + data.Name + "</b> will delete all nodes of this level. Would you like to proceed?";
                        }

                    }
                    TerritoryComponent.modalSaveBtnVisibility = true;
                    TerritoryComponent.modalSaveFnParameter = "Delete Level";
                    TerritoryComponent.modalBtnCapton = "Yes";
                    TerritoryComponent.modalCloseBtnCaption = "Cancel";
                    jQuery("#nextModal").modal("show");
                }

            }
        }
        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
        return;

    }

    public getClickedGroup(): Group {
        if (typeof TerritoryComponent.clickedParent == 'undefined' || !TerritoryComponent.clickedParent) {
            var newGroup: Group = { Id: 1, GroupNumber: "", CustomGroupNumber: "", CustomGroupNumberSpace: "", Name: "", IsOrphan: false, PaddingLeft: 130, ParentId: 0, Children: null, ParentGroupNumber: "", TerritoryId: 0 };
            return newGroup;
        }
        return TerritoryComponent.clickedParent;
    }
    public getParentList(): Group[] {
        this.parentList = [];
        if (typeof TerritoryComponent.clickedParent != 'undefined' && TerritoryComponent.clickedParent) {
            var currrentParentGroupNumber: string = TerritoryComponent.clickedParent.ParentGroupNumber || "";
            this._getParentList(this.territory.RootGroup, +TerritoryComponent.clickedParent.GroupNumber.charAt(0) - 1, currrentParentGroupNumber);
        }
        return this.parentList;
    }
    private _getParentList(root: Group, parenLlevelId: number, parentGroupNumber: string): void {
        if (+root.GroupNumber.charAt(0) === parenLlevelId && !root.IsOrphan && root.GroupNumber != parentGroupNumber) {
            this.parentList.push(root);
        }
        else if (+root.GroupNumber.charAt(0) === parenLlevelId && !root.IsOrphan && TerritoryComponent.clickedParent.IsOrphan) {
            this.parentList.push(root);
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this._getParentList(x, parenLlevelId, parentGroupNumber));
            }
        }
    }
    public clearlinkToParentModal() {
        jQuery("#linkToParentModal").modal('hide');
        TerritoryComponent.clickedParent = null;
    }

    async linkToParentGroup(linkToParentGroupNumber: string) {
        TerritoryComponent.clickedParent.IsOrphan = true;
        var oldParentGroupNumber = TerritoryComponent.clickedParent.ParentGroupNumber;
        var old: Group = TerritoryComponent.clickedParent;
        //for multiple group shift
        if (this.isCheckedMultiNodeShift) {
            this.territory.returnGroup = null;
            await this.territory.getGroupsPassingId(this.territory.RootGroup, +oldParentGroupNumber);
            let parentGroups: Group = this.territory.returnGroup;
            let tempParentGroup: any[] = [];
            if (parentGroups.Children != null) {
                /*parentGroups.Children.slice().reverse().forEach(x => {
                    this.fnLinkToParentNode(x, x.ParentGroupNumber, linkToParentGroupNumber);
                });*/

                //let tempChildrenArray = parentGroups.Children
                // for (let i = tempChildrenArray.length - 1; i >= 0; i--) {
                //     //console.log(tempChildrenArray);
                //     await this.fnLinkToParentNode(tempChildrenArray[i], tempChildrenArray[i].ParentGroupNumber, linkToParentGroupNumber);
                //     //console.log("success");
                // }

                //descending order
                let tempChildrenArray = parentGroups.Children.sort((n1, n2) => {
                    if (n1["CustomGroupNumber"] < n2["CustomGroupNumber"]) { return 1; }
                    if (n1["CustomGroupNumber"] > n2["CustomGroupNumber"]) { return -1; }
                });

                for (let i = tempChildrenArray.length - 1; i >= 0; i--) {
                    await this.fnLinkToParentNode(tempChildrenArray[i], tempChildrenArray[i].ParentGroupNumber, linkToParentGroupNumber);
                }
            }
        } else {
            this.fnLinkToParentNode(old, old.ParentGroupNumber, linkToParentGroupNumber);
        }


        // correction of group ID
        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
        this.clearlinkToParentModal();
    }

    async fnLinkToParentNode(old: Group, oldParentGroupNumber: string, linkToParentGroupNumber: string) {
        this.generatedGroupIdToLinkParent = '0';
        let customGroupNumber = await this.fnGenerateGroupIDDuringLinkToParent(this.territory.RootGroup, old, old.CustomGroupNumberSpace, linkToParentGroupNumber)
        var newGroup: Group = { Id: old.Id, GroupNumber: old.GroupNumber, CustomGroupNumber: customGroupNumber.trim(), CustomGroupNumberSpace: customGroupNumber, Name: old.Name, IsOrphan: old.IsOrphan, PaddingLeft: old.PaddingLeft, ParentId: old.ParentId, Children: old.Children, ParentGroupNumber: old.ParentGroupNumber, TerritoryId: 0 };

        await this.territory.linkToParentGroup(this.territory.RootGroup, newGroup, linkToParentGroupNumber);
        old.IsOrphan = true;
        await this.territory.deleteGroupForLinkToParent(this.territory.RootGroup, this.territory.RootGroup, old, oldParentGroupNumber);

        if (this.LogMidLevel[+oldParentGroupNumber.charAt(0) + 1])//for 1st group after mid level add
            this.LogMidLevel[+oldParentGroupNumber.charAt(0) + 1] = false;
        //this.clearlinkToParentModal();
    }

    fnGenerateGroupIDDuringLinkToParent(root: Group, currentGroup: Group, generatedCustomNumber: string, linkToParentGroupNumber: string): string {
        let nextCustomNumber = currentGroup.CustomGroupNumberSpace.split(" ").pop();
        this.territory.returnGroup = null;
        this.territory.getGroupsPassingId(this.territory.RootGroup, +linkToParentGroupNumber);
        let parentGroupsOfLinkedNode: Group = this.territory.returnGroup;
        let tempCustomID = currentGroup.CustomGroupNumberSpace.split(" ").pop();
        let currentIdAvaiable = true;
        let availableCustomId = 0;
        let maxGroupID = 0;
        let previousId = 1;

        if (parentGroupsOfLinkedNode.Children != null) {
            parentGroupsOfLinkedNode.Children.forEach((x: any) => {
                //to check current ID
                if (+x.CustomGroupNumberSpace.split(" ").pop() == +tempCustomID) {
                    currentIdAvaiable = false;
                }

                //to check avialable ID
                if (+x.CustomGroupNumberSpace.split(" ").pop() != previousId && availableCustomId > 0) {
                    availableCustomId = previousId;
                } else {
                    if (availableCustomId == 0) {
                        previousId = +previousId + 1;
                    }

                    //for max group ID
                    if (+x.CustomGroupNumberSpace.split(" ").pop() > maxGroupID) {
                        maxGroupID = +x.CustomGroupNumberSpace.split(" ").pop();
                    }
                }
            });
        }

        if (currentIdAvaiable) {
            nextCustomNumber = this.paddingZero(+tempCustomID, currentGroup.CustomGroupNumberSpace.split(" ").pop().length);
        } else if (availableCustomId > 0) {
            nextCustomNumber = this.paddingZero(+availableCustomId, currentGroup.CustomGroupNumberSpace.split(" ").pop().length);
        } else {
            nextCustomNumber = this.paddingZero(+maxGroupID + 1, currentGroup.CustomGroupNumberSpace.split(" ").pop().length);
        }
        return nextCustomNumber;
    }

    /*fnGenerateGroupIDDuringLinkToParent(root: Group, currentGroup: Group, generatedCustomNumber: string, linkToParentGroupNumber: string): string {
        debugger;
        let nextCustomNumber = currentGroup.CustomGroupNumberSpace.split(" ").pop();
        let tempCustomID = "";
        if (+root.GroupNumber.charAt(0) == Number(+currentGroup.ParentGroupNumber.charAt(0)) + 1) {
            if (this.generatedGroupIdToLinkParent == '0') {
                tempCustomID = currentGroup.CustomGroupNumberSpace.split(" ").pop();
            } else {
                tempCustomID = this.generatedGroupIdToLinkParent;
            }
            if (root.CustomGroupNumberSpace.split(" ").pop() == tempCustomID.split(" ").pop() && root.GroupNumber != currentGroup.GroupNumber && root.IsOrphan != true && root.ParentGroupNumber == linkToParentGroupNumber) {
                if (this.generatedGroupIdToLinkParent != '0') {
                    nextCustomNumber = this.paddingZero((Number(this.generatedGroupIdToLinkParent.split(" ").pop()) + 1), currentGroup.CustomGroupNumberSpace.split(" ").pop().length);
                } else {
                    nextCustomNumber = this.paddingZero((Number(currentGroup.CustomGroupNumberSpace.split(" ").pop()) + 1), currentGroup.CustomGroupNumberSpace.split(" ").pop().length);
                }
                this.generatedGroupIdToLinkParent = nextCustomNumber;
                //this.fnGenerateGroupIDDuringLinkToParent(root.Children, currentGroup, this.generatedGroupIdToLinkParent, linkToParentGroupNumber);
            } else if (root.CustomGroupNumberSpace.split(" ").pop() == currentGroup.CustomGroupNumberSpace.split(" ").pop() && root.GroupNumber == currentGroup.GroupNumber) {
                if (this.generatedGroupIdToLinkParent == '0') {
                    this.generatedGroupIdToLinkParent = nextCustomNumber;
                }
            }
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.fnGenerateGroupIDDuringLinkToParent(x, currentGroup, this.generatedGroupIdToLinkParent, linkToParentGroupNumber));
            }
        }
        return this.generatedGroupIdToLinkParent;
}*/

    paddingZero(num: number, size: number): string {
        var s = num + "";
        while (s.length < size) s = "0" + s;
        return s;
    }
    private _isBrickExists(data: Group): boolean {
        var result = false;
        for (let node of TerritoryComponent.territoryNodes) {
            if (node.GroupNumber && +node.GroupNumber.charAt(0) === this.territory.Levels.length && node.BrickOutletCount > 0 && node.GroupNumber == data.GroupNumber) {
                result = true;
                break;
            }
        }
        return result;
    }

    fnActionOnGroup(action: string, data: Group, nextLevelOrphanNodes: number, groupDisabledFlag: boolean = false) {
        this.groupParentName = "";
        this.defaultGroupPrefixID = "";

        //to disabled add group btn
        if (groupDisabledFlag || this.getGlobalDisableFlag()) {
            return false;
        }

        if (action === "add") {
            if (this._isBrickExists(data)) {
                TerritoryComponent.modalSaveBtnVisibility = true;
                TerritoryComponent.modalSaveFnParameter = "Delete Bricks From Add Group";
                TerritoryComponent.modalTitle = "Bricks allocation will be deleted.Do you want to proceed?";
                TerritoryComponent.modalBtnCapton = "Yes";
                TerritoryComponent.modalCloseBtnCaption = "Cancel";
                jQuery("#nextModal").modal("show");
            }
            else if (nextLevelOrphanNodes > 0) {
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalTitle = "There are parentless group(s) in next level. Please assign parent for them before proceeding.";
                TerritoryComponent.modalCloseBtnCaption = "Close";

                jQuery("#nextModal").modal("show");
            }
            else {
                TerritoryComponent.clickedParent = this.territory.RootGroup;
                this.groupParentName = this.territory.RootGroup.Name;
                this.defaultGroupPrefixID = this.territory.RootGroup.CustomGroupNumberSpace;
                if (this.generateDefaultGroupId()) {
                    //count group of this level
                    let groupIDLength = +TerritoryComponent.Levels[TerritoryComponent.clickedParent.GroupNumber.charAt(0)].LevelIDLength;
                    let maximumGroupNumberToBe = Math.pow(10, groupIDLength) - 1;
                    //console.log("groupIDLength" + groupIDLength + "maximumGroupNumberToBe" + maximumGroupNumberToBe);
                    //console.log("count group:"+this.territory._levelGroupCount(TerritoryComponent.Groups, +TerritoryComponent.clickedParent.GroupNumber.charAt(0), ));
                    if (maximumGroupNumberToBe <= this.territory._levelGroupCount(TerritoryComponent.Groups, +TerritoryComponent.clickedParent.GroupNumber.charAt(0), )) {
                        TerritoryComponent.modalTitle = "Group ID length has been exceeded of level <b>" + TerritoryComponent.Levels[TerritoryComponent.clickedParent.GroupNumber.charAt(0)].Name + "</b>, please adjust before adding any further groups.";
                        TerritoryComponent.modalSaveBtnVisibility = false;
                        TerritoryComponent.modalCloseBtnCaption = "Ok";
                        TerritoryComponent.modalSaveFnParameter = "";
                        jQuery("#nextModal").modal("show");
                        TerritoryComponent.GroupIdFlag = false;
                        return false;
                    }
                    jQuery("#groupIdCheckErrorMessage").html("");
                    jQuery("#addGroupModal").modal('show');
                    setTimeout(function () { jQuery("#inputGroupName").focus(); }, 500);
                    //this.IsAvailableGroupNumber = false;
                }
            }
        }

        else if (action === "delete") {
            TerritoryComponent.clickedParent = data;
            if (this._isBrickExists(data)) {
                TerritoryComponent.modalTitle = "Deleting this group will remove the bricks/outlets allocated to it which will result in them becoming unassigned and this group will no longer be available in the territory set up, would you like to proceed?";
            }
            else {
                TerritoryComponent.modalTitle = "Deleting this group will remove all the groups underneath and also remove any {brick/outlet} allocations associated with these deleted groups, would you like to proceed?";

            }
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalSaveFnParameter = "Delete Group";
            TerritoryComponent.modalBtnCapton = "Yes";
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            jQuery("#nextModal").modal("show");
        }

        this.territoryService.isChangeDetectedInTerritorySetup = this.territory.fnChangeDetectionInTerritorySetup(this.savedTerritory, this.territory);
        this.authService.hasUnSavedChanges = true;
        return;
    }

    fnModalCloseClick(event: any) {
        if (event == "Unsaved Territory Saved") {
            var oldName = this.territory.Name;
            this.territory = jQuery.extend(true, {}, this.savedTerritory);

            let isSameAsIMSStandard: any[] = [];
            if (this.territory.Name != oldName)
                isSameAsIMSStandard = this.IMSStandardStructureOption.filter(x => x.Name == this.territory.Name);

            if (isSameAsIMSStandard.length && this.territory.IsUsed != true) {
                jQuery("#nextModal").modal("hide");
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalTitle = "Territory definition name cannot be same as any of the existing IMS Standard name.";
                TerritoryComponent.modalCloseBtnCaption = "Ok";
                TerritoryComponent.modalSaveFnParameter = "";
                jQuery("#customModal").modal("show");
                this.territory.Name = oldName;
            }
            else {
                TerritoryComponent.Groups = this.savedTerritory.RootGroup;
                TerritoryComponent.Levels = this.savedTerritory.Levels;
                this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
                if (jQuery("#nextModal").modal("hide")) {
                    //this.HeightBalanceCheck();
                    //this.fnGenerateBricks();
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalTitle = "Changes made to the territory hierarchy have not been applied to the <b>" + this.brickOutletType.toLowerCase() + "</b> allocation.";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    TerritoryComponent.modalSaveFnParameter = "";
                    jQuery("#customModal").modal("show");
                }
            }
        } else if (event == "Go to Allocation Page") {
            jQuery("#customModal").modal("hide");
            this.fnGenerateBricks();
        }
        else {
            jQuery("#nextModal").modal("hide");
            jQuery("#customModal").modal("hide");
        }
    }

    public orphanGroupsCountInNextLevel(levelId: number): number {
        return this._orphanGroupsCountInNextLevel(TerritoryComponent.Groups, levelId + 1);
    }

    private _orphanGroupsCountInNextLevel(root: Group, levelID: number): number {
        var count = 0;
        if (+root.GroupNumber.charAt(0) === levelID && +root.GroupNumber.charAt(0) > 1) {
            if (root.IsOrphan) {
                count = 1;
            }
            return count;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => count += this._orphanGroupsCountInNextLevel(x, levelID));
        }
        return count;
    }

    async ifOrphanExistsInTree() {
        Territory.IsOrphanExistsInStructure = 0;
        await this.territory.ifOrphanExistsInTree(this.territory.RootGroup);
        return Territory.IsOrphanExistsInStructure;
    }

    public isNodeDisabled(): boolean {
        if (TerritoryComponent.Groups != null)
            return TerritoryComponent.Levels.length == this.getLevelFromGroup(TerritoryComponent.Groups.GroupNumber).LevelNumber;
    }


    getOptions(selectedTerritoryBase: string): string[] {
        this.optionsForTerritoryBase = [];

        if (selectedTerritoryBase === "Brick Base" || selectedTerritoryBase === "Outlet Base") {
            var territory = new Territory();
            if (this.territory != null && this.territory.Name != null && this.territory.Name != undefined)
                var isIMSStandard = this.IMSStandardStructureOption.filter(x => x.Name.toLowerCase() == this.territory.Name.toLowerCase());
            //if (this.territory.Name == "IMS Standard Outlet Structure" || this.territory.Name == "IMS Standard Brick Structure") {
            if (isIMSStandard != undefined && isIMSStandard.length > 0) {
                this.territory.Name = "";
                //to set default generated SRA, LD, AD values
                this.territory.SRA_Client = this.tempTerritorySRAInfo.SRA_Client;
                this.territory.SRA_Suffix = this.tempTerritorySRAInfo.SRA_Suffix;
                this.territory.LD = this.tempTerritorySRAInfo.LD;
                this.territory.AD = this.tempTerritorySRAInfo.AD;
            }

            if (this.isIMSStandardStructure) {// assign empty if switch ims standard to custom
                this.territory.Levels = territory.Levels;
                this.territory.updateLevelColor();
                this.territory.RootGroup = territory.RootGroup;
                this.territory.IsUsed = false;
                TerritoryComponent.Groups = this.territory.RootGroup;
                TerritoryComponent.Levels = this.territory.Levels;
                this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
            }
            this.isIMSStandardStructure = false;
            this.selectedOption = 'Custom';
            /* this.territory.Levels = territory.Levels;
             this.territory.updateLevelColor();
             this.territory.RootGroup = territory.RootGroup;
             this.territory.IsUsed = false;
             TerritoryComponent.Groups = this.territory.RootGroup;
             TerritoryComponent.Levels = this.territory.Levels;
             this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);*/



            //this.IsUsedIMSOutletHierarchy = 'false';

        }

        //for outlet and brick type selection:
        if (selectedTerritoryBase === "Brick Base") {
            this.brickOutletType = 'Brick';
            TerritoryComponent.staticBrickOutletType = 'Brick';
        } else {
            this.brickOutletType = 'Outlet';
            TerritoryComponent.staticBrickOutletType = 'Outlet';
        }


        if (selectedTerritoryBase === "Outlet Base") {
            var options = this.IMSStandardStructureOption.filter(x => !this.allTerritoriesList.map(x => x.Name).includes(x.Name));
            let outletBase = options.filter(x => x.IsBrickBased == false).map(x => x.Name);
            if (outletBase.length > 0)
                this.optionsForTerritoryBase = outletBase;
            //this.optionsForTerritoryBase = "IMS Standard Outlet Structure";
            jQuery("#ddTerritoryMarketBase").val("Custom").change();
            TerritoryComponent.globalDisableFlag = false;
        }
        else if (selectedTerritoryBase === "Brick Base") {
            var options = this.IMSStandardStructureOption.filter(x => !this.allTerritoriesList.map(x => x.Name).includes(x.Name));
            let brickBase = options.filter(x => x.IsBrickBased == true).map(x => x.Name);
            if (brickBase.length > 0)
                this.optionsForTerritoryBase = brickBase;
            //this.optionsForTerritoryBase = "IMS Standard Brick Structure";
            jQuery("#ddTerritoryMarketBase").val("Custom").change();
            TerritoryComponent.globalDisableFlag = false;
        }
        TerritoryComponent.globalDisableFlag = false;

        TerritoryComponent.globalDisableFlag = false;
        //jQuery('#ddTerritoryMarketBase').selectedIndex = 1;

        return this.optionsForTerritoryBase;
    }
    getGlobalDisableFlag(): boolean {
        //TerritoryComponent.globalDisableFlag = true;
        return TerritoryComponent.globalDisableFlag;
    }

    getIMSHierarchy(selectedOption: string): void {
        this.territoryService.fnSetLoadingAction(true);
        ////Disable All
        let isIMSStandard = this.IMSStandardStructureOption.filter(x => x.Name.toLowerCase() == selectedOption.toLowerCase());
        //if (selectedOption == "IMS Standard Outlet Structure" || selectedOption == "IMS Standard Brick Structure") {
        if (isIMSStandard.length > 0) {
            TerritoryComponent.globalDisableFlag = true;
            this.isIMSStandardStructure = true;
            //this.IsPermitedADLDEdit=true;
        }
        else {
            TerritoryComponent.globalDisableFlag = false;
            this.isIMSStandardStructure = false;
            //to set default generated SRA, LD, AD values
            this.territory.SRA_Client = this.tempTerritorySRAInfo.SRA_Client;
            this.territory.SRA_Suffix = this.tempTerritorySRAInfo.SRA_Suffix;
            this.territory.LD = this.tempTerritorySRAInfo.LD;
            this.territory.AD = this.tempTerritorySRAInfo.AD;
        }
        /////End Disable All

        if (isIMSStandard.length > 0) {
            this.territoryService.getTerritoryDefForClientByName('internal', 0, selectedOption).subscribe((data: any) => {
                this.territory.Name = data[0].Name;
                this.territory.SRA_Client = data[0].SRA_Client;
                this.territory.SRA_Suffix = data[0].SRA_Suffix;
                //this.territory.AD = data[0].AD;
                // this.territory.LD = data[0].LD;
                this.territory.Levels = data[0].Levels || [];
                this.territory.updateLevelColor();
                this.territory.RootGroup = data[0].RootGroup || [];
                this.territory.IsUsed = true;
                TerritoryComponent.Groups = this.territory.RootGroup;
                TerritoryComponent.Levels = this.territory.Levels;
                this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
                //this.IsUsedIMSBrickHierarchy = data[0].IsUsed;
                this.territoryService.fnSetLoadingAction(false);
                TerritoryComponent.brickDetailsUnderTerritory = data[0].OutletBrickAllocation || [];
            });
        }

        //if (selectedOption == "IMS Standard Outlet Structure" && !this.IsUsedIMSOutletHierarchy) {
        //    this.territoryService.getTerritoryDefForClient(0, 0, selectedOption).subscribe((data: any) => {
        //        this.territory.Name = data[0].Name;
        //        this.territory.SRA_Client = data[0].SRA_Client;
        //        this.territory.SRA_Suffix = data[0].SRA_Suffix;
        //        //this.territory.AD = data[0].AD;
        //        //this.territory.LD = data[0].LD;
        //        this.territory.Levels = data[0].Levels || [];
        //        this.territory.updateLevelColor();
        //        this.territory.RootGroup = data[0].RootGroup || [];
        //        this.territory.IsUsed = true;
        //        TerritoryComponent.Groups = this.territory.RootGroup;
        //        TerritoryComponent.Levels = this.territory.Levels;
        //        this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
        //        //this.IsUsedIMSOutletHierarchy = data[0].IsUsed;
        //        this.territoryService.fnSetLoadingAction(false);
        //        TerritoryComponent.brickDetailsUnderTerritory = data[0].OutletBrickAllocation || [];
        //    });
        //}
        //else if (selectedOption == "IMS Standard Brick Structure" && !this.IsUsedIMSBrickHierarchy) {
        //    this.territoryService.getTerritoryDefForClient(0, 0, selectedOption).subscribe((data: any) => {
        //        this.territory.Name = data[0].Name;
        //        this.territory.SRA_Client = data[0].SRA_Client;
        //        this.territory.SRA_Suffix = data[0].SRA_Suffix;
        //        //this.territory.AD = data[0].AD;
        //        // this.territory.LD = data[0].LD;
        //        this.territory.Levels = data[0].Levels || [];
        //        this.territory.updateLevelColor();
        //        this.territory.RootGroup = data[0].RootGroup || [];
        //        this.territory.IsUsed = true;
        //        TerritoryComponent.Groups = this.territory.RootGroup;
        //        TerritoryComponent.Levels = this.territory.Levels;
        //        this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
        //        //this.IsUsedIMSBrickHierarchy = data[0].IsUsed;
        //        this.territoryService.fnSetLoadingAction(false);
        //        TerritoryComponent.brickDetailsUnderTerritory = data[0].OutletBrickAllocation || [];
        //    });
        //}
        else {
            var territory = new Territory();
            this.territory.Name = "";
            this.territory.Levels = territory.Levels;
            this.territory.updateLevelColor();
            this.territory.RootGroup = territory.RootGroup;
            this.territory.IsUsed = false;
            TerritoryComponent.Groups = this.territory.RootGroup;
            TerritoryComponent.Levels = this.territory.Levels;
            this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
            this.territoryService.fnSetLoadingAction(false);
        }

    }

    async HeightBalanceCheck() {
        var len = this.territory.Levels.length;
        var orfanNumber = await this.ifOrphanExistsInTree();
        if (+orfanNumber == 0) {
            this.IsHeightBalance(this.territory.RootGroup, len);

            if (this.IsHeightBalanceCase1Flag == false || this.IsHeightBalanceCase2Flag != true) {
                //TerritoryComponent.modalTitle = "Tree Height is not balanced. Please balance it before proceeding";
                TerritoryComponent.modalTitle = "Not all levels have necessary groups, please review.";
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalCloseBtnCaption = "Ok";
                TerritoryComponent.modalSaveFnParameter = "";
                jQuery("#customModal").modal("show");
                this.IsHeightBalanceCase1Flag = true;
                this.IsHeightBalanceCase2Flag = false;

                return;
            }
            else {
                this.fnGenerateBricks();
            }

            this.IsHeightBalanceCase1Flag = true;
            this.IsHeightBalanceCase2Flag = false;
        }
        else {
            TerritoryComponent.modalTitle = "Link to parent the orphan group(s) before proceeding";
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            jQuery("#customModal").modal("show");
            //console.log("Tree Height is not balanced");
        }
    }

    IsHeightBalance(root: Group, LevelNumber: number): boolean {
        console.log("levelNumber ..case1.." + LevelNumber);
        if (+root.GroupNumber.charAt(0) == (LevelNumber - 1)) {
            if (typeof root.Children == 'undefined' || !root.Children) {
                return this.IsHeightBalanceCase1Flag = false;
            }
            else if (root.Children.length == 0) {
                return this.IsHeightBalanceCase1Flag = false;
            }
            console.log(root);
        }
        if (+root.GroupNumber.charAt(0) == LevelNumber) {
            this.IsHeightBalanceCase2Flag = true;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.IsHeightBalance(x, LevelNumber));
            }
        }
    }

    async fnFindTerritoryTreeSummary(root: Group, LevelNumber: number) {
        if (+root.GroupNumber.charAt(0) == LevelNumber) {
            this.hasNoGroupInLastLevel = false;
            return;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children && root.Children.length > 0) {
                root.Children.forEach(x => this.fnFindTerritoryTreeSummary(x, LevelNumber));
            } else {
                this.territoryGroupMissingSummary.push({ level: +root.GroupNumber.charAt(0), parentGroup: root, status: "Incomplete" });
            }

        }
    }

    fnGenerateBricks() {
        this.territory.groupsInLevel = [];
        this.territory._groupsInLevel(this.territory.RootGroup, this.territory.Levels.length);
        this.territoryLastLevelNodes = this.territory.groupsInLevel;
        this.enabledTerritoryContent = false;
        this.enabledBricksAllocationContent = true;
        this.lastLevelName = this.territoryLastLevelNodes[0].LevelName;
        this.territory.Client_Id = this.editableClientID;
        // this.territory.Name="Territory Name"
        if (this.brickOutletType.toLowerCase() == "brick") {
            this.territory.IsBrickBased = true;
        } else {
            this.territory.IsBrickBased = false;
        }

    }
    public getNextLevelFromLevel(levelNumber: string): any {
        //return TerritoryComponent.Levels[+levelNumber] ? TerritoryComponent.Levels[+levelNumber].LevelColor : '#babbaba';
        return CONSTANTS.LEVEL_COLORS[+levelNumber] ? CONSTANTS.LEVEL_COLORS[+levelNumber].levelColor : 'white';
    }

    async fnSaveStructuredBasedTerritory() {
        //to check LD and AD
        let breakExecution: string = "true";
        let validationDetails: Territory[] = [];

        let isSameAsIMSStandard: any[] = [];
        if (this.territory.Name != this.savedTerritory.Name)
            isSameAsIMSStandard = this.IMSStandardStructureOption.filter(x => x.Name == this.territory.Name);

        if (this.territory.LD.trim() == "" && this.isLDADVisible == true) {
            //else if (this.territory.LD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "LD is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (this.territory.AD.trim() == "" && this.isLDADVisible == true) {
            //else if (this.territory.AD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "AD is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (isSameAsIMSStandard.length > 0 && this.territory.IsUsed != true) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Territory definition name cannot be same as any of the existing IMS Standard name.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }


        //to check name already exists
        if (this.editableTerritoryDefID > 0) {
            try {
                await this.territoryService.checkEditForTerritoryDefDuplication(this.clientID, this.editableTerritoryDefID, this.territory.Name.trim()).then(result => { breakExecution = result });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
                console.log("error during edit");
            }
        } else {
            try {
                await this.territoryService.checkCreateTerritoryDefDuplication(this.clientID, this.territory.Name.trim()).then(result => { breakExecution = result });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
                console.log("error new entry");
            }
        }

        if (breakExecution == "false" && this.isIMSStandardStructure != true) {
            //jQuery("#territoryNameCheckErrorMessage").html("Territory Definition '" + this.territory.Name.trim() + "' already exists. Please try again with different name. ");
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Territory Definition '" + this.territory.Name.trim() + "' already exists. Please try again with different name. ";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            jQuery("#newsTitle").focus();
            return false;
        }

        //check duplicate SRA Client and SRA SRA_Suffix
        try {
            await this.territoryService.checkSRADuplication(this.clientID, this.editableTerritoryDefID, this.territory.SRA_Client, this.territory.SRA_Suffix, this.territory.LD || "", this.territory.AD || "")
                .then(result => {
                    console.log(result);
                    validationDetails = result;
                });

            if (validationDetails.length > 0) {
                if (validationDetails[0].IsUsed) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "A Territory cannot be created as system cannot suggest an unique suffix for the selected SRA Client.";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].SRA_Client == 'true') {//uniqueness for combined values of SRA Client and SRA Suffix
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The SRA suffix chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].LD == 'true' && this.isLDADVisible == true) {//uniqueness for LD
                    //else if (validationDetails[0].LD == 'true' && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The <b>LD</b> chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].AD == 'true' && this.isLDADVisible == true) {//uniqueness for AD
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The <b>AD</b> chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
            }
        } catch (ex) {
            this.territoryService.fnSetLoadingAction(false);
            console.log("error new entry");
        }



        TerritoryComponent.modalTitle = "Do you want to save <b>" + this.territory.Name + "</b>?";
        TerritoryComponent.modalSaveBtnVisibility = true;
        TerritoryComponent.modalCloseBtnCaption = "Cancel";
        TerritoryComponent.modalSaveFnParameter = "Save territory structure using copy method";
        TerritoryComponent.modalBtnCapton = "Yes";
        jQuery("#customModal").modal("show");
        return false;
    }

    fnTerritoryCallBack(event: any) {
        //this.getIMSHierarchy(jQuery("#inputOptionValue").val());
        this.territoryService.fnSetLoadingAction(false);
        TerritoryComponent.territoryNodes = event.AssignedNodes;
        this.enabledBrickCreation = event.enabledBrickCreation;
        this.enabledTerritoryContent = true;
        this.enabledBricksAllocationContent = false;
        TerritoryComponent.brickDetailsUnderTerritory = event.brickDetailsUnderTerritory;
        this.availbleBricks = event.availbleBricks;
        this.isNewBrickCreation = false;
        this.isEditTerritoryDef = event.isEditTerritoryDef;
        if (event.newTerritoryDefId > 0) {
            this.territory.Id = event.newTerritoryDefId;
            this.editableTerritoryDefID = this.territory.Id;
            //this.territoryDefPageTitle = "Edit Territory";
            this.enabledTerritoryHeader = false;
        }

    }

    private loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            console.log('user object to detect external internal')
            console.log(usrObj)
            var roleid: number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('Territory', this.authService.isMyClientsSelected ? "My Clients" : "All Clients", roleid).subscribe(
                (data: any) => this.checkAccess(data),
                (err: any) => { console.log(err); },
                () => console.log('data loaded')
            );
        }
    }
    public canEditTerritoryPermission: boolean = false;
    public canViewTerritoryPermission: boolean = false;
    public canEditTerritoryGroup: boolean = false;
    public canDeleteTerritoryGroup: boolean = false;
    public canEditTerritoryOutlets: boolean = false;
    public canDeleteTerritoryOutlets: boolean = false;

    private checkAccess(data: UserPermission[]) {
        this.territoryService.fnSetLoadingAction(false);
        this.canViewTerritoryPermission = false;
        this.canDeleteTerritoryGroup = false;
        this.canEditTerritoryOutlets = false;
        this.canDeleteTerritoryOutlets = false;
        let canEditTerrDefForInternalClient = false;
        for (let it in data) {
            if (data[it].ActionName == ConfigUserAction.TerritoryDefinition && data[it].Privilage == 'View') {
                this.canViewTerritoryPermission = true;
            }

            if (data[it].ActionName == ConfigUserAction.TerritoryDefinition && data[it].Role == this.userRole && (data[it].Privilage == 'Edit' || data[it].Privilage == 'Delete')) {
                if (!this.isIMSStandardStructure || (this.isIMSStandardStructure && this.isInternalClient === true && this.lockType.toLowerCase() != 'view lock')) {
                    TerritoryComponent.globalDisableFlag = false;
                    this.canEditTerritoryPermission = true;
                }
            }

            //for LD AD edit 
            if (data[it].ActionName == "LD AD of Territory" && data[it].Privilage == 'Edit' && this.lockType != "View Lock") {
                this.IsPermitedADLDEdit = true;
            }

            //for internal client edit
            if (data[it].ActionName == ConfigUserAction.EditTerritoryDefinitionForInternalClient && this.isInternalClient === true) {
                canEditTerrDefForInternalClient = true;
            }

        }

        if (!canEditTerrDefForInternalClient && this.isIMSStandardStructure && this.isInternalClient === true && this.lockType.toLowerCase() != 'view lock') {
            this.canViewTerritoryPermission = true;
            this.canEditTerritoryPermission = false;
        }

        //take decision for role base implementation
        if (this.canEditTerritoryPermission) {
            this.territoryDefPageTitle = "Edit Territory";
            this.territoryService.territorySharedData = { title: "Edit Levels and Groups", task: "Edit Territory" };
            this.fnCheckForReferenceStructure();
        } else if (this.canViewTerritoryPermission) {
            TerritoryComponent.globalDisableFlag = true;
            this.enabledTerritoryHeader = false;
            this.isIMSStandardStructure = true;
            this.territoryDefPageTitle = "View Territory";
            this.territoryService.territorySharedData = { title: "View Territory", task: "View Territory" };
        }
    }

    public fnCheckForReferenceStructure() {
        this.IsReferenceStrucute = false;
        //to reference type
        if (this.territory.DimensionID != null && this.territory.DimensionID != '0') {
            if (+this.territory.DimensionID != this.territory.Id) {
                //its Reference structure because dimensionId and Id is not same
                TerritoryComponent.globalDisableFlag = true;
                //this.isEditableSRA = true;
                this.IsReferenceStrucute = true;
                this.isIMSStandardStructure = true;
            }

        }

        //for internal GMT
        if (this.userRole == "Internal GTM") {
            this.IsReferenceStrucute = false;
        }
    }

    public fnBackToClientTiles() {
        if (!this.territoryService.isChangeDetectedInTerritorySetup) {
            TerritoryComponent.modalTitle = "Do you want to return back to <b>Territory Definition</b> view?";
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            TerritoryComponent.modalSaveFnParameter = "back to territory tiles page";
            TerritoryComponent.modalBtnCapton = "Yes";
            jQuery("#customModal").modal("show");
        } else {
            TerritoryComponent.modalTitle = "Changes made to the Territory Definition will not apply. Would you like to proceed?";
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            TerritoryComponent.modalSaveFnParameter = "back to territory tiles page";
            TerritoryComponent.modalBtnCapton = "Ok";
            jQuery("#customModal").modal("show");
        }


        /*if (JSON.stringify(this.savedTerritory.RootGroup) == JSON.stringify(TerritoryComponent.Groups) && JSON.stringify(this.savedTerritory.Levels) == JSON.stringify(TerritoryComponent.Levels)) {
            TerritoryComponent.modalTitle = "Do you want to return back to <b>Territory Definition</b> view?";
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            TerritoryComponent.modalSaveFnParameter = "back to territory tiles page";
            TerritoryComponent.modalBtnCapton = "Yes";
            jQuery("#customModal").modal("show");
        } else {
            TerritoryComponent.modalTitle = "Changes made to the Territory Definition will not apply. Would you like to proceed?";
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            TerritoryComponent.modalSaveFnParameter = "back to territory tiles page";
            TerritoryComponent.modalBtnCapton = "Ok";
            jQuery("#customModal").modal("show");
        }*/
    }

    fnPullTerritoryDetails() {
        this.territoryService.getTerritoryDefForClient(this.editableClientID, this.editableTerritoryDefID, '').subscribe((data: any) => {

            TerritoryComponent.brickDetailsUnderTerritory = data[0].OutletBrickAllocation || [];
            this.territory.Id = data[0].Id;
            this.territory.DimensionID = data[0].DimensionID;
            this.territory.Name = data[0].Name;
            this.territory.Client_Id = data[0].Client_Id;
            this.territory.IsBrickBased = data[0].IsBrickBased;
            this.territory.SRA_Client = data[0].SRA_Client || "";
            this.territory.SRA_Suffix = data[0].SRA_Suffix || "";
            this.territory.LD = data[0].LD || "";
            this.territory.AD = data[0].AD || "";
            this.territory.IsUsed = data[0].IsUsed;
            this.territory.Levels = data[0].Levels || [];
            this.territory.RootGroup = data[0].RootGroup || [];
            this.territory.GuiId = data[0].GuiId;
            this.territory.OrphanGroups = data[0].OrphanGroups || [];
            this.territory.groupsInLevel = data[0].groupsInLevel || [];
            this.territory.OutletBrickAllocation = data[0].OutletBrickAllocation || [];
            this.territory.IsReferenced = data[0].IsReferenced || false;
            this.territory.updateLevelColor();

            TerritoryComponent.Groups = this.territory.RootGroup;
            TerritoryComponent.Levels = this.territory.Levels;
            this.extraLevels = this.territory.Levels.filter(t => t.LevelNumber != 1);
            this.territoryService.fnSetLoadingAction(false);
            //this.savedTerritory = jQuery.extend(true, {}, this.territory);

            //find last of after pulling data from db
            this.territory.groupsInLevel = [];
            this.territory._groupsInLevel(this.territory.RootGroup, this.territory.Levels.length);
            TerritoryComponent.territoryNodes = this.territory.groupsInLevel;
            //to assing brick outlet type
            if (this.territory.IsBrickBased == true) {
                this.brickOutletType = "Brick";
                TerritoryComponent.staticBrickOutletType = "Brick";
            } else {
                this.brickOutletType = "Outlet";
                TerritoryComponent.staticBrickOutletType = "Outlet";
            }

            // to order of territory level
            this.fnReOrderOfLevel();

            //to store territory in temporary
            this.savedTerritory = jQuery.extend(true, {}, this.territory);
            this.territory.fnReorderOfTerritoryGroups(this.savedTerritory.RootGroup, 'asc');

            //to get user permisson
            this.checkUserClientAccess(this.editableClientID);

            //to get available brick/outlet from db
            this.territoryService.getAvailableBrickOutletUpdated((this.territory.IsBrickBased == true) ? 'brick' : 'Outlet', this.territory.Id, this.userRole, this.territory.Client_Id).subscribe((data: any) => {
                this.availbleBricks = data || [];
            });

            //for IMS standard hierarchy 		
            this.isEditTerritoryMode = true;
            this.enabledTerritoryHeader = false;


            this.territoryService.getIMSStandardStructureOption()
                .then((o: any) => {
                    if (o != null) {
                        this.IMSStandardStructureOption = o;
                    }

                    let imsStructure = this.IMSStandardStructureOption.filter(x => x.Name == this.territory.Name);
                    if (imsStructure.length > 0) {
                        if (this.territory.IsBrickBased) {
                            this.optionsForBaseFilter.push('Brick Base');
                            let brickBase = this.IMSStandardStructureOption.filter(x => x.IsBrickBased == true).map(x => x.Name);
                            if (brickBase.length > 0) {
                                this.optionsForTerritoryBase = brickBase;
                            }
                        }
                        else {
                            this.optionsForBaseFilter.push('Outlet Base');
                            let outletBase = this.IMSStandardStructureOption.filter(x => x.IsBrickBased == false).map(x => x.Name);
                            if (outletBase.length > 0) {
                                this.optionsForTerritoryBase = outletBase;
                            }
                        }
                        this.isIMSStandardStructure = true;

                        if (this.isInternalClient === true) {
                            TerritoryComponent.globalDisableFlag = false;
                        }
                        else {
                            this.territoryDefPageTitle = "View Territory";
                            this.territoryService.territorySharedData = { title: "View Territory", task: "View Territory" };
                            jQuery("#ddTerritoryMarketBase option[value='Custom']").remove();
                            TerritoryComponent.globalDisableFlag = true;
                        }

                        this.selectedOption = this.territory.Name;
                    }
                    //if (this.territory.Name == "IMS Standard Outlet Structure") {
                    //    this.optionsForBaseFilter.push('Outlet Base');
                    //    this.optionsForTerritoryBase = "IMS Standard Outlet Structure";
                    //    this.isIMSStandardStructure = true;
                    //    this.territoryDefPageTitle = "View Territory";
                    //    this.territoryService.territorySharedData = { title: "View Territory", task: "View Territory" };
                    //    jQuery("#ddTerritoryMarketBase option[value='Custom']").remove();
                    //    TerritoryComponent.globalDisableFlag = true;
                    //} else if (this.territory.Name == "IMS Standard Brick Structure1") {
                    //    this.optionsForBaseFilter.push('Brick Base');
                    //    this.optionsForTerritoryBase = "IMS Standard Brick Structure";
                    //    this.isIMSStandardStructure = true;
                    //    this.territoryDefPageTitle = "View Territory";
                    //    this.territoryService.territorySharedData = { title: "View Territory", task: "View Territory" };
                    //    jQuery("#ddTerritoryMarketBase option[value='Custom']").remove();
                    //    TerritoryComponent.globalDisableFlag = true;
                    //}
                    else {
                        //TerritoryComponent.globalDisableFlag = false;
                        if (data[0].IsBrickBased) {
                            this.optionsForBaseFilter.push('Brick Base');
                        } else {
                            this.optionsForBaseFilter.push('Outlet Base');
                        }
                    }
                });

            //for territory view lock
            if (this.lockType.toLowerCase() == 'view lock') {
                TerritoryComponent.globalDisableFlag = true;
                this.isIMSStandardStructure = true;
            }

        }, (err: any) => {
            //this.tErrorModal.show();
            this.territoryService.fnSetLoadingAction(false);
            console.log(err);
            return false;
        });
    }

    async fnUpdateTerritoryHeaderInfo() {
        this.territory.Name = this.territory.Name || "";
        this.territory.RootGroup = this.territory.RootGroup || null;
        //this.territory.root
        this.territoryService.fnSetLoadingAction(true);
        let breakExecution: string = "true";
        let validationDetails: Territory[] = [];

        let isSameAsIMSStandard: any[] = [];
        if (this.territory.Name != this.savedTerritory.Name)
            isSameAsIMSStandard = this.IMSStandardStructureOption.filter(x => x.Name == this.territory.Name);

        if (this.territory.Name.trim() == "") {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "A territory definition name is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (this.territory.SRA_Client.trim() == "") {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "SRA cilent ID is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territory.SRA_Suffix.trim() == "" && this.isEditTerritoryDef != true && this.isIMSStandardStructure != true) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "SRA suffix is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        } else if (this.territory.LD.trim() == "" && this.isLDADVisible == true) {
            //else if (this.territory.LD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "LD is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (this.territory.AD.trim() == "" && this.isLDADVisible == true) {
            //else if (this.territory.AD.trim() == "" && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "AD is required. Please review.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }
        else if (isSameAsIMSStandard.length > 0 && this.territory.IsUsed != true) {
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Territory definition name cannot be same as any of the existing IMS Standard name.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            return false;
        }


        //to check name already exists
        if (this.editableTerritoryDefID > 0) {
            try {
                await this.territoryService.checkEditForTerritoryDefDuplication(this.clientID, this.editableTerritoryDefID, this.territory.Name.trim()).then(result => { breakExecution = result });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
                console.log("error during edit");
            }
        } else {
            try {
                await this.territoryService.checkCreateTerritoryDefDuplication(this.clientID, this.territory.Name.trim()).then(result => { breakExecution = result });
            } catch (ex) {
                this.territoryService.fnSetLoadingAction(false);
                console.log("error new entry");
            }
        }

        if (breakExecution == "false" && this.isIMSStandardStructure != true) {
            //jQuery("#territoryNameCheckErrorMessage").html("Territory Definition '" + this.territory.Name.trim() + "' already exists. Please try again with different name. ");
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalTitle = "Territory Definition '" + this.territory.Name.trim() + "' already exists. Please try again with different name. ";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            TerritoryComponent.modalSaveFnParameter = "";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
            jQuery("#newsTitle").focus();
            return false;
        }

        //check duplicate SRA Client and SRA SRA_Suffix
        try {
            await this.territoryService.checkSRADuplication(this.clientID, this.editableTerritoryDefID, this.territory.SRA_Client, this.territory.SRA_Suffix, this.territory.LD || "", this.territory.AD || "")
                .then(result => {
                    console.log(result);
                    validationDetails = result;
                });

            if (validationDetails.length > 0) {
                if (validationDetails[0].IsUsed) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "A Territory cannot be created as system cannot suggest an unique suffix for the selected SRA Client.";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].SRA_Client == 'true') {//uniqueness for combined values of SRA Client and SRA Suffix
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The SRA suffix chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].LD == 'true' && this.isLDADVisible == true) {//uniqueness for LD
                    //else if (validationDetails[0].LD == 'true' && this.isLDADVisible == true && this.isEditableSRA == true && this.getGlobalDisableFlag() == false) {
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The <b>LD</b> chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
                else if (validationDetails[0].AD == 'true' && this.isLDADVisible == true) {//uniqueness for AD
                    TerritoryComponent.modalSaveBtnVisibility = false;
                    TerritoryComponent.modalSaveFnParameter = "";
                    TerritoryComponent.modalTitle = "The <b>AD</b> chosen is not unique, please review. ";
                    TerritoryComponent.modalCloseBtnCaption = "Ok";
                    this.territoryService.fnSetLoadingAction(false);
                    jQuery("#nextModal").modal("show");
                    return false;
                }
            }
        } catch (ex) {
            this.territoryService.fnSetLoadingAction(false);
            console.log("error new entry");
        }

        //finally to send request for saving data
        // let territoryBaseInf:Territory;
        // territoryBaseInf.Id=this.territory.Id;
        // territoryBaseInf.AD=this.territory.AD;
        // territoryBaseInf.LD=this.territory.LD;
        // territoryBaseInf.Client_Id=this.territory.Client_Id;
        // territoryBaseInf.Client_Id=this.territory.Client_Id;
        // territoryBaseInf.Client_Id=this.territory.Client_Id;

        this.territoryService.updateTerritoryBaseInfo(this.territory.Client_Id, this.territory.Id, this.territory).subscribe((data: any) => {
            this.savedTerritory = jQuery.extend(true, {}, this.territory);
            this.territoryService.fnSetLoadingAction(false);
            TerritoryComponent.modalSaveBtnVisibility = false;
            TerritoryComponent.modalSaveFnParameter = "";
            TerritoryComponent.modalTitle = "Changes have been saved for the territory.";
            TerritoryComponent.modalCloseBtnCaption = "Ok";
            this.territoryService.fnSetLoadingAction(false);
            jQuery("#nextModal").modal("show");
        },
            (err: any) => {
                this.territoryService.fnSetLoadingAction(false);
                console.log(err);
            }
        );
    }

    private stringify(o: any): string {
        return JSON.stringify(o);
    }

    private checkUserClientAccess(cid: number) {
        this.territoryService.fnSetLoadingAction(true);
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.checkUserClientAccess(cid).subscribe(
                (data: any) => this.checkClientAccess(data),
                (err: any) => {
                    this.tErrorModal.show();
                    console.log(err);
                },
                () => console.log('data loaded')
            );
        }
    }
    private checkClientAccess(data: string[]) {
        this.authService.isMyClientsSelected = false;
        for (let it in data) {
            var cid: number = Number(data[it]);
            if (cid == this.editableClientID) {
                this.authService.isMyClientsSelected = true;
            }
        }
        this.loadUserData();//call role permision
    }

    fnChangeDetectionInTerritoryHeaderSection() {
        if (this.territoryService.isChangeDetectedInTerritorySetup) {
            this.IsTerritoryHeaderSectionChanged = false;
        } else if (this.savedTerritory.Name != this.territory.Name || this.savedTerritory.AD != this.territory.AD || this.savedTerritory.SRA_Client != this.territory.SRA_Client
            || this.savedTerritory.SRA_Suffix != this.territory.SRA_Suffix || this.savedTerritory.LD != this.territory.LD || this.savedTerritory.IsReferenced != this.territory.IsReferenced) {
            this.IsTerritoryHeaderSectionChanged = true;
        } else {
            this.IsTerritoryHeaderSectionChanged = false;
        }
    }

    fnReOrderOfLevel() {
        let colName = "LevelNumber";
        this.territory.Levels.sort((n1, n2) => {
            if (n1[colName] > n2[colName]) { return 1; }
            if (n1[colName] < n2[colName]) { return -1; }
            return 0;
        });
    }

    // @HostListener("window:scroll", [])
    // onWindowScroll() {
    //     const offset = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
    //     if (offset > 135) {
    //         jQuery('#top-layout').addClass('fixed');
    //         jQuery('#level-id-1').addClass('fixed-level-1');
    //         jQuery('#level-id-2').addClass('fixed-level-2');
    //         jQuery('#level-id-3').addClass('fixed-level-3');
    //         jQuery('#level-id-4').addClass('fixed-level-4');
    //         jQuery('#level-id-5').addClass('fixed-level-5');
    //         jQuery('#level-id-6').addClass('fixed-level-6');
    //     } else {
    //         jQuery('#top-layout').removeClass('fixed');
    //         jQuery('#level-id-1').removeClass('fixed-level-1');
    //         jQuery('#level-id-2').removeClass('fixed-level-2');
    //         jQuery('#level-id-3').removeClass('fixed-level-3');
    //         jQuery('#level-id-4').removeClass('fixed-level-4');
    //         jQuery('#level-id-5').removeClass('fixed-level-5');
    //         jQuery('#level-id-6').removeClass('fixed-level-6');
    //     }
    // }


    //getIMSStandardStructureOption() {
    //    this.territoryService.getIMSStandardStructureOption()
    //        .then((data: any) => {
    //            if (data != null) {
    //                this.IMSStandardStructureOption = data;
    //            }
    //        });
    //}

    isInternalClient: boolean = false;
    checkisInternalClient() {
        this.territoryService.checkIsInternalClient(this.clientID)
            .then((data: boolean) => {
                if (data != null) {
                    this.isInternalClient = data;
                }
            });
    }
}
