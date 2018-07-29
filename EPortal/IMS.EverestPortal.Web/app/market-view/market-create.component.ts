import { Component, OnInit, ElementRef, AfterViewInit, ViewChild, KeyValueDiffers, ChangeDetectionStrategy, IterableDiffers, HostListener } from '@angular/core';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { ClientMarketBase } from '../shared/models/client-market-base';
import { AdditionalFilter } from '../shared/models/additional-filter';
import { CLIENT_MARKET_BASES } from '../shared/models/mock-clients';
import { ClientService } from '../shared/services/client.service';
import { Client } from '../shared/models/client';
import { CLIENTS } from '../shared/models/mock-clients';
import { MarketBase } from '../shared/models/market-base';
import { StaticPackMarketBase } from '../shared/models/static-pack-market-base';
import { DynamicPackMarketBase } from '../shared/models/dynamic-pack-market-base';
import { MktPackSeachService } from './mktPackSearch.service';
import { PackDescSearch } from '../../app/shared/model';
import { MarketDefinition } from '../shared/models/market-definition';
import { PaginationComponent } from 'ng2-bootstrap/ng2-bootstrap';
import { NgModel } from '@angular/forms';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';
import { ConfigService } from '../config.service';
import { BaseFilter } from '../shared/models/base-filter';

import { ModalDirective } from 'ng2-bootstrap';
import { PackDescSearchComponent } from '../PackDescSearch/packDescSearch.component';
import { AlertService } from '../shared/component/alert/alert.service';

import { ComponentCanDeactivate, DeactivateGuard } from '../security/deactivate-guard';
import { Observable } from 'rxjs/Observable';


declare var jQuery: any;

@Component({
    selector: 'market-create',
    changeDetection: ChangeDetectionStrategy.Default,
    templateUrl: '../../app/market-view/market-create-tabular.html',
    styleUrls: ['../../app/content/css/marketCreate.css'],
    providers: [ClientService, MktPackSeachService]
})
export class MarketCreateComponent implements OnInit, AfterViewInit, ComponentCanDeactivate {

    @ViewChild('mmErrModal') mmErrModal: ModalDirective
    @HostListener('window:beforeunload')
    canDeactivate(): Observable<boolean> | boolean {
        if (this.isChangeDetectedInMarketSetup == true || this.isChangeDetectedInMarketDefinition == true) { // Here add condition to check for any unsaved changes
            //alert("tab close if condition");
            if (this.authService.isTimeout == true)
                return true;
            else
                return false; // return false will show alert to the user
        }
        else {
            //to release lock
            this.clientService.fnSetLoadingAction(true);
            try {
                this.deactiveGuard.fnReleaseLock(this.loginUserObj.UserID, this.editableMarketDefID, 'Market Module', this.lockType, 'Release Lock').then(result => { this.clientService.fnSetLoadingAction(false); });
            } catch (ex) {
                this.clientService.fnSetLoadingAction(false);
            }
            this.clientService.fnSetLoadingAction(false);
            return true;
        }
    }



    public createMarketLink: string;
    public marketCreationStep2: string = "none";
    public marketCreationStep1: string = "block";
    public dynamicModalSaveFunction: any;
    public modalTitle = '<span ></span>';
    public modalSaveBtnVisibility: boolean = false;
    public modalSaveFnParameter: string = "";
    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Close";
    public selectedPackIDForGroup: string = "";
    public dropdownGroupValues: any = [];
    public newGroupID: any;
    public newsTitle: string;
    public filtersApplied: any = [];
    //Permission Variables 
    public canCreateMarket: boolean = false;
    public canFilter: boolean = false;
    public canAddToMarketDefinition: boolean = false;
    public canEditMarket: boolean = false;
    public canAddDelMarketBase: boolean = false;
    public canpackListFromMarketbase: boolean = false;
    public canpackListFromPackList: boolean = false;
    public canpacksToGroup: boolean = false;
    public canfactorToGroup: boolean = false;
    public canfactorToPack: boolean = false;
    public canchangeGroupNo_def: boolean = false;
    public canchangeGroupNo: boolean = false;
    public canAddgroupName: boolean = false;
    public canEditContent: boolean = true;
    public isAdmin: boolean = false;
    public tempUserData: UserPermission[] = [];

    public existingMarketDifinition: MarketDefinition[];
    public isEditMarketDef: boolean = false;
    public editableClientID: number = 0;
    public editableMarketDefID: number = 0;

    public dynamicTableBind: any;
    public staticTableBind: any;
    public marketbaseTableBind: any;
    public guID: string = "";
    public guIDPresent: boolean = false;
    public clickSavedBtnInStep1: boolean = false;
    public tempClientInfoFinal: any[] = [];
    public selectedGroupID: any[] = [];
    public enabledDynamicTableFooterBtns: boolean = false;
    public enabledStaticTableFooterBtns: boolean = false;
    public atcDependencyArray: any[] = [];
    public necDependencyArray: any[] = [];
    public mfrDependencyArray: any[] = [];
    public productDependencyArray: any[] = [];
    public moleculeDependencyArray: any[] = [];
    public operationOnNaGroup: boolean = false;
    public isNAGroupMessageShow: boolean = false;
    public marketBaseGenericErrorMgs: string;
    public factorOrGroupGenericErrorMgs: string;

    public groupIdErrorMgs: string;
    public groupNameErrorMgs: string;
    public saveBtnEnabledForGroupId: boolean;
    public saveBtnEnabledForGroupName: boolean;
    public loginUserObj: any;
    public lockType: string;

    dynamicMmarketBaseGroup: any = [];
    clientInfoFinal: Client[] = [];
    marketBases: ClientMarketBase[];
    selectedMarketBase: ClientMarketBase;
    marketBasesForView: ClientMarketBase[] = [];
    selectedMarketBaseForAutoCom: ClientMarketBase[] = [];
    filters: AdditionalFilter[] = [];

    staticPackMarketBase: StaticPackMarketBase[] = [];
    dynamicPackMarketBase: DynamicPackMarketBase[] = [];
    isMarketBaseSelected: boolean;
    public tempDynamicPackMarketBbase: DynamicPackMarketBase[];
    public tempStaticPackMarketBbase: StaticPackMarketBase[];
    public temmpMarketDifinitionBaseMap: any[] = [];
    public backFromMarketDef: boolean = false;
    public enabledGroupDetails: boolean = true;
    marketDefsFiltered: MarketDefinition;
    clients: Client[] = [];
    myClients: Client[] = [];
    searchedClients: Client[] = [];
    client: Client;
    clientsFiltered: Client[] = [];
    client_packList: Client = CLIENTS[0];

    toggleTitle: string = '';
    breadCrumbUrl: string = '';
    tempFiltersForMolecule: any = [];
    /* pack search*/
    model: SearchDTO = new SearchDTO();

    packDescription: PackDescSearch[] = [];
    packDescCount: number = 1;
    errorMessage: string = '';
    isLoading: boolean = true;
    enabledMarketBaseTable: boolean = true;
    differ: any;
    iDiffer: any;
    isChangeDetectedInMarketDefinition: boolean = false;
    isChangeDetectedInMarketSetup: boolean = false;
    isFirstTimeLoadMarketDefinition: boolean = false;
    activeReflowMarketDefContent: boolean = false;
    activeReflowAvailablePackContent: boolean = false;

    tempMarketDefName: string = "";
    marketDefNameChangedDetected: boolean = false;
    //Autocomplete list
    atc1List: any[]; atc2List: any[]; atc3List: any[]; atc4List: any[]; nec1List: any[]; nec2List: any[]; nec3List: any[]; nec4List: any[]; moleculeList: any[]; manufacturerList: any[]; productList: any[];
    atc1Selection: any; atc2Selection: any; atc3Selection: any; atc4Selection: any; nec1Selection: any; nec2Selection: any; nec3Selection: any; nec4Selection: any; moleculeSelection: any; manufacturerSelection: any; productSelection: any;

    constructor(private clientService: ClientService, private elementRef: ElementRef, private deactiveGuard: DeactivateGuard,
        private mktPackSeachService: MktPackSeachService, private route: ActivatedRoute, private router: Router, private alertService: AlertService,
        private authService: AuthService, private _cookieService: CookieService, private differs: KeyValueDiffers, private iDiffers: IterableDiffers) { this.differ = differs.find({}).create(null); this.iDiffer = iDiffers.find([]).create(null); this.loginUserObj = this._cookieService.getObject('CurrentUser'); }

    ngOnInit(): void {
        if (jQuery(".dropdown-menu li:contains('My Markets')").length > 0) {
            this.toggleTitle = "My Markets";
            //this.breadCrumbUrl = "/market/My-Client";
            this.breadCrumbUrl = "/markets/mymarkets";
        }
        else {
            this.toggleTitle = ConfigService.clientFlag ? "My Clients" : "All Clients";
            this.breadCrumbUrl = ConfigService.clientFlag ? "/market/My-Client" : "/marketAllClient/All-Client";
        }

        this.clientService.fnSetLoadingAction(true);//to set loading true
        let paramID: string = this.route.snapshot.params['id'];
        this.lockType = this.route.snapshot.params['id2'];

        if (paramID != "" && paramID != "undefined" && typeof paramID != 'undefined') {
            if (paramID.indexOf('|') > 0) {
                this.isEditMarketDef = true;
                this.editableClientID = Number(paramID.split("|")[0]);
                this.editableMarketDefID = Number(paramID.split("|")[1]);
                jQuery(".market-title").html(this.lockType == 'View Lock' ? "View Market" : 'Edit Market');

                //to lock history
                this.deactiveGuard.fnNewLock(this.loginUserObj.UserID, this.editableMarketDefID, "Market Module", this.lockType, "Create Lock")
                    .then(result => { })
                    .catch((err: any) => { this.clientService.fnSetLoadingAction(false); });
            } else {
                this.editableClientID = Number(paramID);
            }

        } else {
            this.isEditMarketDef = false;
            this.editableClientID = 0;
            this.editableMarketDefID = 0;
        }
        this.subscribeToMarketBaseList();
        this.createMarketLink = '/marketCreate/' + this.editableClientID;
        this.checkUserClientAccess(this.editableClientID);

        this.canFilter = false;
        //to bind static table
        this.fnBindStaticTable();

        //to bind dynamic table
        this.fnBindDynamicTable();

        //to bind marketbase table
        this.fnBindMarketBaseTable();

        this.loadUserData();

        this.clientService.fnSetLoadingAction(false);//to set loading false
        this.packDescCount = 1;
    }

    ngDoCheck() {
        this.enabledMarketBaseTable = this.marketBasesForView.filter((rec: ClientMarketBase) => { if (rec.UsedMarketBaseStatus == 'true' || rec.UsedMarketBaseStatus == 'True') { return true; } else { return false } }).length > 0 ? true : false;
        var changesDynamicPack = this.iDiffer.diff(this.dynamicPackMarketBase);
        if (changesDynamicPack) {
            if (!this.isFirstTimeLoadMarketDefinition) {
                this.fnMarketDefChangeDetection();
            }
            this.isFirstTimeLoadMarketDefinition = false;

        }
    }
    //autocomplete selection handlers
    public onATC1Selected(selected: any) { this.atc1List = selected || []; if (this.atc1List.length > 0) { jQuery(".checkbox-atc1").prop("checked", true); } else { jQuery(".checkbox-atc1").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || []; }
    public onATC2Selected(selected: any) { this.atc2List = selected || []; if (this.atc2List.length > 0) { jQuery(".checkbox-atc2").prop("checked", true); } else { jQuery(".checkbox-atc2").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc3List).concat(this.atc4List) || []; }
    public onATC3Selected(selected: any) { this.atc3List = selected || []; if (this.atc3List.length > 0) { jQuery(".checkbox-atc3").prop("checked", true); } else { jQuery(".checkbox-atc3").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc4List) || []; }
    public onATC4Selected(selected: any) { this.atc4List = selected || []; if (this.atc4List.length > 0) { jQuery(".checkbox-atc4").prop("checked", true); } else { jQuery(".checkbox-atc4").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc3List) || []; }
    public onNEC1Selected(selected: any) { this.nec1List = selected || []; if (this.nec1List.length > 0) { jQuery(".checkbox-nec1").prop("checked", true); } else { jQuery(".checkbox-nec1").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || []; }
    public onNEC2Selected(selected: any) { this.nec2List = selected || []; if (this.nec2List.length > 0) { jQuery(".checkbox-nec2").prop("checked", true); } else { jQuery(".checkbox-nec2").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec3List).concat(this.nec4List) || []; }
    public onNEC3Selected(selected: any) { this.nec3List = selected || []; if (this.nec3List.length > 0) { jQuery(".checkbox-nec3").prop("checked", true); } else { jQuery(".checkbox-nec3").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec4List) || []; }
    public onNEC4Selected(selected: any) { this.nec4List = selected || []; if (this.nec4List.length > 0) { jQuery(".checkbox-nec4").prop("checked", true); } else { jQuery(".checkbox-nec4").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec3List) || []; }
    public onMoleculeSelected(selected: any) { this.moleculeList = selected || []; if (this.moleculeList.length > 0) { jQuery(".checkbox-molecule").prop("checked", true); } else { jQuery(".checkbox-molecule").prop("checked", false) } }
    public onManufacturerSelected(selected: any) { this.manufacturerList = selected || []; if (this.manufacturerList.length > 0) { jQuery(".checkbox-mfr").prop("checked", true); } else { jQuery(".checkbox-mfr").prop("checked", false) } }
    public onProductSelected(selected: any) { this.productList = selected || []; if (this.productList.length > 0) { jQuery(".checkbox-product").prop("checked", true); } else { jQuery(".checkbox-product").prop("checked", false) } }



    loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('Market', this.authService.isMyClientsSelected ? "My Clients" : "All Clients", roleid).subscribe(
                (data: any) => this.checkAccess(data),
                (err: any) => {
                    this.clientService.fnSetLoadingAction(false);
                    this.mmErrModal.show();
                    console.log(err);
                },
                () => console.log('data loaded')
            );
        }
    }

    private checkAccess(data: UserPermission[]) {
        //console.log('data length: ', data.length);
        //this.isAdmin = this.authService.canAllClientAccess;

        for (let it in data) {
            if (data[it].Role == 'Internal Admin' || data[it].Role == 'Internal Production' || data[it].Role == 'Internal Support') {
                // this.isMyclientsSelected = true;
                this.isAdmin = true;
                this.authService.canAllClientAccess = true;
            }
        }
        this.canEditContent = this.authService.isMyClientsSelected ? true : false;
        if (this.canEditContent == true || this.isAdmin == true) {
            for (let it in data) {
                // console.log('item=' + data[it].ActionName);

                if (data[it].ActionName == ConfigUserAction.filterMarketbase && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canFilter = true;
                }
                if (data[it].ActionName == ConfigUserAction.marketdefinitionName && data[it].Privilage == 'Edit') {
                    this.canEditMarket = true;
                }
                if (data[it].ActionName == ConfigUserAction.marketbaseToMarktDef && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canAddDelMarketBase = true;
                }
                if (data[it].ActionName == ConfigUserAction.packListFromMarketbase && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canpackListFromMarketbase = true;
                }
                if (data[it].ActionName == ConfigUserAction.packListFromPackList && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canpackListFromPackList = true;
                }
                if (data[it].ActionName == ConfigUserAction.packsToGroup && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canpacksToGroup = true;
                }
                if (data[it].ActionName == ConfigUserAction.factorToGroup && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canfactorToGroup = true;
                }
                if (data[it].ActionName == ConfigUserAction.factorToPack && (data[it].Privilage == 'Add' || data[it].Privilage == 'Delete')) {
                    this.canfactorToPack = true;
                }
                if (data[it].ActionName == ConfigUserAction.changeGroupNumber_default && (data[it].Privilage == 'Edit')) {
                    this.canchangeGroupNo_def = true;
                }
                if (data[it].ActionName == ConfigUserAction.changeGroupNumber && (data[it].Privilage == 'Edit')) {
                    this.canchangeGroupNo = true;
                }
                if (data[it].ActionName == ConfigUserAction.groupName && (data[it].Privilage == 'Add')) {
                    this.canAddgroupName = true;
                }
            }

            if (this.lockType == 'View Lock') {
                this.canFilter = false;
                this.canEditMarket = false;
            }
        }
        this.tempUserData = data;
        jQuery("#hdnCanFilter").val(this.canFilter);

    }
    isViewMode() {
        if ((this.canEditContent == true && this.canEditMarket == true) || this.isAdmin == true)
            return false;
        else
            return true;
    }
    ngAfterViewInit() {
        //call service for existing data of market view		
        if (this.isEditMarketDef == true) {
            // this.clientService.getClientMarketDef(this.editableClientID,this.editableMarketDefID).subscribe(	
            this.clientService.fnSetLoadingAction(true);
            this.clientService.getClientMarketDef(this.editableClientID, this.editableMarketDefID).subscribe(
                (data: MarketDefinition[]) => {
                    this.existingMarketDifinition = data;
                    this.fnExistingMarketDefinitioneEmit();
                    //this.dynamicPackMarketBase = data["MarketDefinitionPacks"].filter((rec: any) => rec.Alignment == "dynamic-right" || rec.Alignment == null) || [];
                    //this.staticPackMarketBase = data["MarketDefinitionPacks"].filter((rec: any) => rec.Alignment == "static-left") || [];
                    this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase)) || [];
                    this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase)) || [];

                    if (this.dynamicPackMarketBase.length > 0) {
                        this.isFirstTimeLoadMarketDefinition = true;
                        this.isChangeDetectedInMarketDefinition = false;
                        this.authService.hasUnSavedChanges = true
                    }
                    this.clientService.fnSetLoadingAction(false);
                    //console.log("data in edit mode:"+JSON.stringify( this.dynamicPackMarketBase));
                    //this.fnGererateTempMarketBaseDuringEdit();//to store market base in temp
                },
                (err: any) => {
                    this.clientService.fnSetLoadingAction(false);
                    //this.mmErrModal.show();
                    // if (err.status == 0) {
                    //     this.alertService.alert("System has failed to connect with server due to network problem.");
                    // } else {
                    //     this.alertService.alert(err.json().Message);
                    // }
                    // console.log(err);
                },
                () => console.log('market bases loaded')
            );
        }
        this.disableControls();
    }

    fnMarketDefChangeDetection() {
        if (JSON.stringify(this.tempDynamicPackMarketBbase) == JSON.stringify(this.dynamicPackMarketBase)) {
            this.isChangeDetectedInMarketDefinition = false;
            console.log("changes in dynamic array");
        } else {
            this.isChangeDetectedInMarketDefinition = true;
            this.authService.hasUnSavedChanges = true
            console.log("changes in dynamic array and temp array not same");

        }
    }

    fnMarketSetupChangeDetection() {
        if (this.fnGererateTempMarketBaseDuringEdit('return values').length == 0) {
            this.isChangeDetectedInMarketSetup = true;
            return false;
        }


        if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, this.fnGererateTempMarketBaseDuringEdit('return values'))) {
            this.isChangeDetectedInMarketSetup = false;
            console.log("changes in market setup false");
        } else {
            this.isChangeDetectedInMarketSetup = true;
            console.log("changes in market setup true");

        }

        //to enabled the save button
        this.fnDetectMarketDefNameChanged();
    }

    subscribeToMarketBaseList() {
        this.clientService.fnSetLoadingAction(true);
        if (!this.marketBases) {
            // this.clientService.getClientMarketBases(this.editableClientID).subscribe(
            //     (data: any) => this._processMarketBases(data),
            //     (err: any) => {
            //         this.clientService.fnSetLoadingAction(false);
            //         this.errModal.show();
            //         console.log(err);
            //     },
            //     () => console.log('market bases loaded')
            // );

            this.clientService.fnGetMarketBases(this.editableClientID, this.editableMarketDefID, this.editableMarketDefID > 0 ? 'According to MarketDef' : 'All Market Base').subscribe(
                (data: any) => this._processMarketBases(data),
                (err: any) => {
                    this.clientService.fnSetLoadingAction(false);
                    this.mmErrModal.show();
                    console.log(err);
                },
                () => console.log('market bases loaded')
            );
        }
    }

    private _processMarketBases(data: ClientMarketBase[]) {
        this.marketBases = data || [];
        this.marketBasesForView = [];
        //for unique record
        if (this.marketBases.length > 0) {
            let flag: any[] = [];
            for (var i = 0; i < this.marketBases.length; i++) {
                if (!flag[this.marketBases[i].Id]) {
                    flag[this.marketBases[i].Id] = true;
                    this.marketBasesForView.push(this.marketBases[i]);
                }
            }
        }



        //to show default selected market base
        if (this.marketBasesForView.length == 1 && this.isEditMarketDef != true) {
            this.marketBasesForView.forEach((rec: any) => { rec.UsedMarketBaseStatus = 'true' });
            setTimeout(() => {
                this.fnDefaultSelectMarketBase();
            }, 800);
        }

        this.enabledMarketBaseTable = this.marketBasesForView.filter((rec: ClientMarketBase) => { if (rec.UsedMarketBaseStatus == 'true' || rec.UsedMarketBaseStatus == 'True') { return true; } else { return false } }).length > 0 ? true : false;
    }

    activateMarketBase(dom: string, marketBaseId: number) {
        this.marketBaseGenericErrorMgs = "";
        // console.log('is checked : ', jQuery('#' + dom).prop('checked'));
        // console.log('market base id : ', marketBaseId);
        if (jQuery('#' + dom).prop('checked')) {
            jQuery('#icon_' + marketBaseId).removeClass('disab').addClass('purpLink');
            jQuery('#col2_' + marketBaseId).removeClass('userRefreshHidden').addClass('userRefreshVisible');
            jQuery('#mbtext_' + marketBaseId).removeClass('textWeightNormal').addClass('textWeightBold');
            jQuery("#dynamic-" + marketBaseId).prop("checked", true);
        }
        else {
            jQuery('#icon_' + marketBaseId).removeClass('purpLink').addClass('disab');
            jQuery('#col2_' + marketBaseId).removeClass('userRefreshVisible').addClass('userRefreshHidden');
            jQuery('#mbtext_' + marketBaseId).removeClass('textWeightBold').addClass('textWeightNormal');

            jQuery('#col3_' + marketBaseId).removeClass('userRefreshVisible').addClass('userRefreshHidden');
            //jQuery('#col3_' + marketBaseId).empty();
            jQuery('#col3_' + marketBaseId + " div.nodeEqual").remove();

        }

        this.fnMarketSetupChangeDetection();
    }

    fnDefaultSelectMarketBase(marketBaseId: number = 0) {
        //console.log("marketBaseId: " + marketBaseId);
        if (marketBaseId > 0) {
            jQuery("#chkbox_" + marketBaseId).prop("checked", true);
            jQuery("#mbtext_" + marketBaseId).removeClass("textWeightNormal").addClass("textWeightBold");
            jQuery("#icon_" + marketBaseId).removeClass("disab").addClass("purpLink");
            jQuery("#col2_" + marketBaseId).removeClass("userRefreshHidden").addClass("userRefreshVisible");
            jQuery("#dynamic-" + marketBaseId).prop("checked", true);
        } else {
            if (!this.isEditMarketDef && (this.marketBasesForView.length == 1)) {
                jQuery("#chkbox_" + this.marketBasesForView[0]["Id"]).prop("checked", true);
                jQuery("#mbtext_" + this.marketBasesForView[0]["Id"]).removeClass("textWeightNormal").addClass("textWeightBold");
                jQuery("#icon_" + this.marketBasesForView[0]["Id"]).removeClass("disab").addClass("purpLink");
                jQuery("#col2_" + this.marketBasesForView[0]["Id"]).removeClass("userRefreshHidden").addClass("userRefreshVisible");
                jQuery("#dynamic-" + this.marketBasesForView[0]["Id"]).prop("checked", true);
            }
        }

        this.clientService.fnSetLoadingAction(false);
    }

    checkboxExcludeATC1: boolean = true; checkboxExcludeATC2: boolean = true; checkboxExcludeATC3: boolean = true; checkboxExcludeATC4: boolean = true; checkboxExcludeNEC1: boolean = true; checkboxExcludeNEC2: boolean = true; checkboxExcludeNEC3: boolean = true; checkboxExcludeNEC4: boolean = true; checkboxExcludeMFR: boolean = true; checkboxExcludeProduct: boolean = true; checkboxExcludeMolecule: boolean = true;
    includeExcludeArray = [{
        checkboxExcludeATC1: true, checkboxExcludeATC2: true, checkboxExcludeATC3: true, checkboxExcludeATC4: true, checkboxExcludeNEC1: true, checkboxExcludeNEC2: true, checkboxExcludeNEC3: true, checkboxExcludeNEC4: true,
        checkboxExcludeMFR: true, checkboxExcludePRODUCT: true, checkboxExcludeMOLECULE: true
    }];

    async setSelectedMarketBase(marketBase: ClientMarketBase) {
        let tempatc1: any[] = [], tempatc2: any[] = [], tempatc3: any[] = [], tempatc4: any[] = [], tempnec1: any[] = [], tempnec2: any[] = [], tempnec3: any[] = [], tempnec4: any[] = [], tempmfr: any[] = [], tempproduct: any[] = [], tempmolecule: any[] = [];
        this.atcDependencyArray = []; this.necDependencyArray = [];
        let includeExcludeLocalArray = [{
            checkboxExcludeATC1: true, checkboxExcludeATC2: true, checkboxExcludeATC3: true, checkboxExcludeATC4: true, checkboxExcludeNEC1: true, checkboxExcludeNEC2: true, checkboxExcludeNEC3: true, checkboxExcludeNEC4: true,
            checkboxExcludeMFR: true, checkboxExcludePRODUCT: true, checkboxExcludeMOLECULE: true
        }];
        this.selectedMarketBaseForAutoCom = this.marketBases.filter((record: ClientMarketBase, index: any) => {
            if (record.MarketBaseId == marketBase.MarketBaseId) {
                return true;
            } else {
                return false;
            }
        });
        jQuery(".PSTBNewAuto").val("");
        jQuery(".PSTBNewAuto").css("display", "none");
        jQuery(".cusGlyphClose").css("display", "none");

        this.selectedMarketBase = marketBase;
        var marketBaseName: any = marketBase.MarketBaseName.split(" ")[0];
        jQuery(".base-market-name").html(marketBase.MarketBaseName);
        jQuery("div.packSearchModalPanel .selected-checkbox input[type='checkbox']").prop("checked", false);
        // jQuery("div.packSearchModalPanel .checkbox-exclude-contains").prop("checked", true);

        //to remove all disabled 
        jQuery(".autocom-content").removeClass("disabled-content");
        jQuery(".autocom-content .filter-container").removeClass("disabled");
        if (isNaN(marketBaseName[3]) == false) {//to disabled
            if (marketBaseName[0].toLowerCase() == "a") {
                for (var i = Number(marketBaseName[3]); i >= 0; i--) {
                    jQuery(".autocom-content-Atc" + i).addClass("disabled-content");
                    jQuery(".autocom-content-Atc" + i + " .filter-container").first().addClass("disabled");
                }
            } else if (marketBaseName[0].toLowerCase() == "n") {
                for (var i = Number(marketBaseName[3]); i >= 0; i--) {
                    jQuery(".autocom-content-Nec" + i).addClass("disabled-content");
                    jQuery(".autocom-content-Nec" + i + " .filter-container").first().addClass("disabled-content");
                }
            }

        }


        //for user permission
        if (this.canFilter != true) {
            for (var i = 1; i <= 13; i++) {
                jQuery("#v" + i).attr("disabled", true);
                jQuery("#f" + i).attr("disabled", true);
            }
            jQuery("div.packSearchModalPanel  input[type='checkbox']").attr("disabled", true);
            for (var i = 4; i >= 0; i--) {
                jQuery("#checkbox-atc" + i).attr("disabled", true);
            }

        }
        else {
            for (var i = 1; i <= 13; i++) {
                jQuery("#v" + i).attr("disabled", false);
                jQuery("#f" + i).attr("disabled", false);
            }
            jQuery("div.packSearchModalPanel  input[type='checkbox']").attr("disabled", false);

            for (var i = 4; i >= 0; i--) {
                jQuery("input.checkbox-atc" + i).attr("disabled", false);
            }
        }

        if (isNaN(marketBaseName[3]) == false) {
            for (var i = Number(marketBaseName[3]); i >= 0; i--) {
                jQuery("#v" + i).attr("disabled", true);
                jQuery("input.checkbox-atc" + i).attr("disabled", true);
            }
        }
        //to set previous value in modal
        let tempFilterSelectedVal: any = [], tempIndividualSelectedVal: any = [], excludeSymbol = '≠';
        jQuery(".filTable tbody tr.marketID-" + this.selectedMarketBase.Id + " td div.basefilter-" + this.selectedMarketBase.Id + " div.nodeEqual").each(function () {
            var filterName, filterVal, filterContent = jQuery(this).html();
            if (filterContent.indexOf(excludeSymbol) > 0) {//for exclude
                filterName = filterContent.split(excludeSymbol)[0].trim().replace(" ", "").toLowerCase();
                filterVal = filterContent.split(excludeSymbol)[1];
                //jQuery("#checkbox-exclude-" + filterName).prop("checked", false);
                includeExcludeLocalArray[0]['checkboxExclude' + filterName.toUpperCase()] = false;

            } else {//for include
                filterName = filterContent.split("=")[0].trim().replace(" ", "").toLowerCase();
                filterVal = filterContent.split("=")[1];
                includeExcludeLocalArray[0]['checkboxExclude' + filterName.toUpperCase()] = true;
            }

            filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];

            if (filterName == "flagging") {
                jQuery("#v11").val(filterVal.replace(/'/g, '')).change();
                jQuery(".checkbox-" + filterName).prop("checked", true);
            } else if (filterName == "branding") {
                jQuery(".checkbox-" + filterName).prop("checked", true);
                jQuery("#v12").val(filterVal.replace(/'/g, '')).change();
            }
            else {
                jQuery(".checkbox-" + filterName).prop("checked", true);
                tempIndividualSelectedVal = [];
                //new code for autocomplete content to pass array by Palash
                let filtersCounter: number = 1;
                if (filterVal.indexOf("',") > -1) {
                    let filterValArrayWithComma = filterVal.split("',");
                    for (let i = 0; i < filterValArrayWithComma.length; i++) {
                        tempFilterSelectedVal.push({ Code: filterValArrayWithComma[i].replace(/'/g, ''), FilterName: filterName.toLowerCase() });
                        tempIndividualSelectedVal.push({ Code: filterValArrayWithComma[i].replace(/'/g, ''), FilterName: filterName.toLowerCase() });
                        filtersCounter = filtersCounter + 1;
                    }

                } else {
                    //tempFilterSelectedVal.push({"$id":filtersCounter,"ATC4_Code":filterVal,"ATC4_Desc":filterVal,"FilterName":filterName});
                    tempFilterSelectedVal.push({ Code: filterVal.replace(/'/g, ''), FilterName: filterName.toLowerCase() });
                    tempIndividualSelectedVal.push({ Code: filterVal.replace(/'/g, ''), FilterName: filterName.toLowerCase() });
                }
                //end of new code
            }

            //assign individula array set 
            if (filterName.toLowerCase() == "atc1") { tempatc1 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "atc2") { tempatc2 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "atc3") { tempatc3 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "atc4") { tempatc4 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "nec1") { tempnec1 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "nec2") { tempnec2 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "nec3") { tempnec3 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "nec4") { tempnec4 = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "mfr") { tempmfr = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "molecule") { tempmolecule = tempIndividualSelectedVal; }
            else if (filterName.toLowerCase() == "product") { tempproduct = tempIndividualSelectedVal; }
        });

        if (tempFilterSelectedVal.length <= 0) {
            tempFilterSelectedVal.push({ Code: "", FilterName: "" });
        }


        this.filtersApplied = tempFilterSelectedVal; //to pass values from market component to auto complete
        this.atc1List = tempatc1; this.atc2List = tempatc2; this.atc3List = tempatc3; this.atc4List = tempatc4; this.nec1List = tempnec1; this.nec2List = tempnec2; this.nec3List = tempnec3; this.nec4List = tempnec4; this.productList = tempproduct; this.moleculeList = tempmolecule; this.manufacturerList = tempmfr;
        this.atcDependencyArray = this.atc1List.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || [];
        this.necDependencyArray = this.nec1List.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || [];
        // console.log("tempFilterSelectedVal" + JSON.stringify(tempFilterSelectedVal));
        //for dropdown change auto checked
        jQuery("div.packSearchModalPanel  select").bind("change", function () {
            var textValues = jQuery(this).val();
            var classOfValues = jQuery(this).attr("class");
            if (textValues != "" && textValues != 'undefined') {
                jQuery(".checkbox-" + classOfValues).prop("checked", true);
            } else {
                jQuery(".checkbox-" + classOfValues).prop("checked", false);
            }

        });

        //console.log(includeExcludeLocalArray);

        this.includeExcludeArray = includeExcludeLocalArray;
        // console.log(this.includeExcludeArray[0]['checkboxExcludeATC3']);
        //console.log(this.includeExcludeArray);
    }

    applyAdditionalFilters() {
        let counter = 0;
        let tempFilters: any = [];
        this.filtersApplied = [];
        let filterCheckboxChecked: any[] = [];
        jQuery("div.packSearchModalPanel .selected-checkbox input[type='checkbox']").each(function () {
            if (jQuery(this).prop("checked")) {
                let checkboxID = jQuery(this).attr("class");
                var criteriaName = jQuery("." + checkboxID).next("span").html();
                var criteriaSpanID = jQuery("." + checkboxID).next("span").eq(0).attr("id");
                var criteriaValue = jQuery("#v" + criteriaSpanID.substring(1)).val();
                //console.log("checkboxID" + checkboxID.split("-")[1] + ":criteriaName:" + criteriaName);
                filterCheckboxChecked.push({ filterName: checkboxID.split("-")[1], checkedProp: true });
            }
        });

        //console.log(filterCheckboxChecked);

        //check if checkbox selected then read data from array
        if (filterCheckboxChecked.length > 0) {
            //console.log("data exists");
            for (let i = 0; i < filterCheckboxChecked.length; i++) {
                //console.log("for loop" + filterCheckboxChecked[i].filterName + " this.atc4List:" + JSON.stringify(this.atc4List));
                if (filterCheckboxChecked[i].filterName.toLowerCase() == "atc1") {
                    if (this.atc1List != undefined && this.atc1List.length > 0) {
                        tempFilters.push({ Criteria: "ATC 1", Values: this.getCSV(this.atc1List, 'Code'), IsExclude: jQuery("#checkbox-exclude-atc1").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "atc2") {
                    if (this.atc2List != undefined && this.atc2List.length > 0) {
                        tempFilters.push({ Criteria: "ATC 2", Values: this.getCSV(this.atc2List, 'Code'), IsExclude: jQuery("#checkbox-exclude-atc2").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "atc3") {
                    if (this.atc3List != undefined && this.atc3List.length > 0) {
                        tempFilters.push({ Criteria: "ATC 3", Values: this.getCSV(this.atc3List, 'Code'), IsExclude: jQuery("#checkbox-exclude-atc3").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "atc4") {
                    if (this.atc4List != undefined && this.atc4List.length > 0) {
                        tempFilters.push({ Criteria: "ATC 4", Values: this.getCSV(this.atc4List, 'Code'), IsExclude: jQuery("#checkbox-exclude-atc4").is(':checked') })

                        //console.log("error in array:" + JSON.stringify(tempFilters) + " row data" + JSON.stringify(this.atc4List));
                    }
                }

                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "mfr") {
                    if (this.manufacturerList != undefined && this.manufacturerList.length > 0) {
                        tempFilters.push({ Criteria: "MFR", Values: this.getCSV(this.manufacturerList, 'Code'), IsExclude: jQuery("#checkbox-exclude-mfr").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "nec1") {
                    if (this.nec1List != undefined && this.nec1List.length > 0) {
                        tempFilters.push({ Criteria: "NEC 1", Values: this.getCSV(this.nec1List, 'Code'), IsExclude: jQuery("#checkbox-exclude-nec1").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "nec2") {
                    if (this.nec2List != undefined && this.nec2List.length > 0) {
                        tempFilters.push({ Criteria: "NEC 2", Values: this.getCSV(this.nec2List, 'Code'), IsExclude: jQuery("#checkbox-exclude-nec2").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "nec3") {
                    if (this.nec3List != undefined && this.nec3List.length > 0) {
                        tempFilters.push({ Criteria: "NEC 3", Values: this.getCSV(this.nec3List, 'Code'), IsExclude: jQuery("#checkbox-exclude-nec3").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "nec4") {
                    if (this.nec4List != undefined && this.nec4List.length > 0) {
                        tempFilters.push({ Criteria: "NEC 4", Values: this.getCSV(this.nec4List, 'Code'), IsExclude: jQuery("#checkbox-exclude-nec4").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "molecule") {
                    if (this.moleculeList != undefined && this.moleculeList.length > 0) {
                        tempFilters.push({ Criteria: "Molecule", Values: this.getCSV(this.moleculeList, 'Code'), IsExclude: jQuery("#checkbox-exclude-molecule").is(':checked') })
                        this.tempFiltersForMolecule.push({ Criteria: "Molecule", Values: this.getCSVForMolecule(this.moleculeList, 'Code'), IsExclude: jQuery("#checkbox-exclude-molecule").is(':checked') })

                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "product") {
                    if (this.productList != undefined && this.productList.length > 0) {
                        tempFilters.push({ Criteria: "Product", Values: this.getCSV(this.productList, 'Code'), IsExclude: jQuery("#checkbox-exclude-product").is(':checked') })
                    }
                }
                else if (filterCheckboxChecked[i].filterName.toLowerCase() == "flagging") {
                    if (jQuery("#v11").val() != "") {
                        // tempFilters.push({ Criteria: "Flagging", Values: "'" + jQuery("#v11").val() + "'", IsExclude: jQuery("#checkbox-exclude-flagging").is(':checked') })
                        tempFilters.push({ Criteria: "Flagging", Values: "'" + jQuery("#v11").val() + "'", IsExclude: true })
                    }
                } else if (filterCheckboxChecked[i].filterName.toLowerCase() == "branding") {
                    if (jQuery("#v12").val() != "") {
                        //tempFilters.push({ Criteria: "Branding", Values: "'" + jQuery("#v12").val() + "'", IsExclude: jQuery("#checkbox-exclude-branding").is(':checked') })
                        tempFilters.push({ Criteria: "Branding", Values: "'" + jQuery("#v12").val() + "'", IsExclude: true })
                    }
                }

            }
        }


        this.filters = tempFilters;
        var filterRow = jQuery('#col3_' + this.selectedMarketBase.Id);
        //filterRow.html("");
        jQuery('#col3_' + this.selectedMarketBase.Id + " div.nodeEqual").remove();
        let filterCounter = 0;
        let excludeIncludeOperator = '=';
        if (this.filters.length > 0) {
            filterRow.removeClass('userRefreshHidden').addClass('userRefreshVisible');
            for (let filter of this.filters) {
                filterCounter = filterCounter + 1;
                if (filter.IsExclude) {
                    excludeIncludeOperator = '=';
                } else {
                    excludeIncludeOperator = '≠';
                }


                if (filterCounter > 2) {
                    filterRow.append('<div class="nodeEqual filter-hidden">' + filter.Criteria + excludeIncludeOperator + '<strong>' + filter.Values + '</strong>' + '</div>');
                    //filterRow.append('<a href="#" class="more-less" id="more-111-'+this.selectedMarketBase.Id+'" >More..</a>');
                } else {
                    filterRow.append('<div class="nodeEqual">' + filter.Criteria + excludeIncludeOperator + '<strong>' + filter.Values + '</strong>' + '</div>');
                }

                jQuery("#checkbox-exclude-" + this.selectedMarketBase.Id).prop('checked', filter.IsExclude)
            }
            //filterRow.append('<div class="nodeEqualMore" > <a href="#" data- toggle="modal" data- target="#filterModalEdit" > more...</a></div><div class="clearAll" >');
            if (filterCounter <= 2) {
                filterRow.append('<div class="clearAll">');
            }


            this.filters = [];
            this._clearModal();
        } else {
            filterRow.removeClass('userRefreshVisible').addClass('userRefreshHidden');
        }


        //to append more purpLink
        if (filterCounter > 2) {
            //filterRow.append('<a href="#" class="more-less" id="more-'+this.selectedMarketBase.Id+'" >More..</a>');
            jQuery('#more-' + this.selectedMarketBase.Id).css("display", "inline");
            filterRow.append(jQuery('#more-' + this.selectedMarketBase.Id));
            filterRow.append('<div class="clearAll">');
        } else {
            jQuery('#more-' + this.selectedMarketBase.Id).css("display", "none");
        }

        this.fnMarketSetupChangeDetection();
    }


    async fnCreateMarketStep1(compareWithPreData: string) {
        let marketBaseDetailsData: any = this.marketBases;
        let client: Client[] = [];
        let marketDefinition: any = [];
        let marketDefinitionBaseMap: any = [];
        let additionalFilter: any = [];
        let marketBase: any = [];
        let recordDetails: any = "";
        let clientID: any = "";
        let clientName: any = "";
        let itemChecked: any = false;
        let breakExecution: string = "true";
        let marketDefinitionName: string = jQuery("#newsTitle").val();
        this.marketBaseGenericErrorMgs = "";
        this.newsTitle = marketDefinitionName;
        this.clientService.fnSetLoadingAction(true);
        if (marketDefinitionName == "" || marketDefinitionName == " ") {
            jQuery(".required-error-mgs").html("This information is required.");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        } else if (marketDefinitionName.length >= 26) {
            jQuery(".required-error-mgs").html("This label exceeds the 25 character limitation. Please review.");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        }
        else if (marketDefinitionName.match(/^[-/+()&/,.\w\s]*$/) == null) {
            jQuery(".required-error-mgs").html("only alphanumeric with +, -,., _,&,/, (, ) special characters allowed.");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        } else {
            if (this.editableMarketDefID > 0) {
                try {
                    await this.clientService.checkEditForMarketDefDuplication(this.editableClientID, this.editableMarketDefID, jQuery("#newsTitle").val().trim()).then(result => { breakExecution = result });
                } catch (ex) {
                    this.clientService.fnSetLoadingAction(false);
                    console.log("error during edit");
                }
            } else {
                try {
                    await this.clientService.checkCreateMarketDefDuplication(this.editableClientID, jQuery("#newsTitle").val().trim()).then(result => { breakExecution = result });
                } catch (ex) {
                    this.clientService.fnSetLoadingAction(false);
                    console.log("error new entry");
                }
            }
            jQuery(".required-error-mgs").html("");
        }

        if (breakExecution == "false") {
            jQuery(".required-error-mgs").html("Market definition '" + jQuery("#newsTitle").val().trim() + "' already exists. Please try again with a different label. ");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return false;
        }
        //to ready data from table to bind market definition
        jQuery(".filTable tbody tr").each(function () {
            var recordID = jQuery(this).attr("class").split("-")[1];
            //read thats are checked
            if (jQuery("#chkbox_" + recordID).prop("checked") == true) {
                var baseName = jQuery(".filTable tbody tr.marketID-" + recordID + " td span.baseName").html();
                var selectedMarketBase: any = marketBaseDetailsData.filter((rec: any) => rec.Id == recordID)[0];
                var refreshSettingVal: any = "";
                itemChecked = true;
                //to select refreshSetting Val
                jQuery(".ref-" + recordID).each(function () {
                    if (jQuery(this).prop("checked") == true) {
                        refreshSettingVal = jQuery(this).attr("id").split("-")[0];
                    }
                });

                //to select content of filter options
                additionalFilter = [];
                let filterName, filterVal;
                let containsFlag: boolean = true;
                let excludeSymbol = '≠'
                jQuery(".filTable tbody tr.marketID-" + recordID + " td div.basefilter-" + recordID + " div.nodeEqual").each(function () {
                    let filterContent = jQuery(this).html();
                    if (filterContent.indexOf(excludeSymbol) > 0) {//for exclude
                        filterName = filterContent.split(excludeSymbol)[0].trim();
                        filterVal = filterContent.split(excludeSymbol)[1];
                        //to remove strong tag
                        filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];
                        containsFlag = false;

                    } else {//for include
                        filterName = filterContent.split("=")[0].trim();
                        filterVal = filterContent.split("=")[1];
                        //to remove strong tag
                        filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];
                        containsFlag = true;
                    }

                    //var filterName = jQuery(this).html().split("=")[0];
                    //var filterVal = jQuery(this).html().split("=")[1];
                    //to remove strong tag
                    //filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];

                    additionalFilter.push({ Id: recordID, Name: 'filter-' + recordID, Criteria: filterName, Values: filterVal, IsEnabled: containsFlag });
                });
                /*marketBase = { Id: selectedMarketBase.MarketBaseId, Name: selectedMarketBase.MarketBaseName, Description: selectedMarketBase.Description, Filters: [{ Id: selectedMarketBase.BaseFilterId, Name: selectedMarketBase.BaseFilterName, Criteria: selectedMarketBase.BaseFilterCriteria, Values: selectedMarketBase.BaseFilterValues, IsEnabled: selectedMarketBase.BaseFilterIsEnabled }] };*/
                let marketBaseFilter = marketBaseDetailsData.filter((record: ClientMarketBase, index: any) => {
                    if (record.MarketBaseId == selectedMarketBase.MarketBaseId) {
                        return true;
                    } else {
                        return false;
                    }
                }) || [];
                //to bind market base filter array
                let marketBaseFilterArray: BaseFilter[] = [];
                marketBaseFilter.forEach((rec: ClientMarketBase, index: any) => {
                    marketBaseFilterArray.push({ Id: rec.Id, Name: rec.BaseFilterName, Criteria: rec.BaseFilterCriteria, Values: rec.BaseFilterValues, IsEnabled: true, MarketBaseId: rec.MarketBaseId, IsRestricted: rec.IsRestricted, IsBaseFilterType: rec.IsBaseFilterType });
                });

                marketBase = {
                    Id: selectedMarketBase.MarketBaseId, Name: selectedMarketBase.MarketBaseName, Description: selectedMarketBase.Description, Filters: marketBaseFilterArray
                };
                //to set marketbaseID
                //marketDefinitionBaseMap.push({ Id: recordID, Name: baseName, MarketBase: marketBase, Filters: additionalFilter, DataRefreshType: refreshSettingVal });
                marketDefinitionBaseMap.push({ Id: recordID, Name: baseName, MarketBaseId: selectedMarketBase.MarketBaseId, MarketBase: marketBase, Filters: additionalFilter, DataRefreshType: refreshSettingVal });
                clientID = selectedMarketBase.ClientId;
                clientName = selectedMarketBase.ClientName;
            }


        });

        //to check any checkbox is selected
        if (!itemChecked) {
            this.marketBaseGenericErrorMgs = "Please select any item(s) before proceed.";
            this.clientService.fnSetLoadingAction(false);
            return false;
        }
        marketDefinition.push({ Id: 1, Name: marketDefinitionName, Description: '', MarketDefinitionBaseMaps: marketDefinitionBaseMap });
        client.push({ Id: clientID, Name: clientName, IsMyClient: true, MarketDefinitions: marketDefinition });
        //to go next step without 
        // if(this.isEditMarketDef && this.clickSavedBtnInStep1==false){
        //     console.log("table market base map:"+JSON.stringify(marketDefinitionBaseMap));
        //     console.log("database market base map:"+JSON.stringify(this.existingMarketDifinition["MarketDefinitionBaseMaps"]))
        //     this.btnModalSaveClick("ProceedStep2");
        //     return ;
        // }
        if (this.isEditMarketDef) {
            if (compareWithPreData == "Yes") {//save btn not clicked yet so pulled data show in grid
                if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, client)) {
                    //to pull packs from DB
                    if (this.dynamicPackMarketBase.length < 1 && this.staticPackMarketBase.length < 1) {//If there is no packs then pull from DB
                        await this.fnGetMarketDefinitionPacks();
                    }
                    this.btnModalSaveClick("ProceedStep2");
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    this.clientService.fnSetLoadingAction(false);
                    return;
                } else {
                    this.modalSaveBtnVisibility = true;
                    this.modalSaveFnParameter = "Save changes market information";
                    this.modalTitle = '<span >Changes have been made to the Market Definition. Would you like to apply these?</span>';
                    this.modalBtnCapton = "Ok";
                    this.modalCloseBtnCaption = "Cancel";
                    jQuery("#nextModal").modal("show");
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    this.clientService.fnSetLoadingAction(false);
                }

                //this.tempClientInfoFinal=JSON.parse( JSON.stringify(this.clientsFiltered));
                this.clientService.fnSetLoadingAction(false);
                return;
            } else if (this.clickSavedBtnInStep1 == true && compareWithPreData == "Yes") {
                if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, client) && this.backFromMarketDef == true) {
                    this.btnModalSaveClick("ProceedStep2");
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    //this.subscribeToAvailablePackList();
                    this.clientService.fnSetLoadingAction(false);
                } else if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, client)) {
                    this.btnModalSaveClick("ProceedStep2");
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    this.subscribeToAvailablePackList();
                } else {
                    this.modalSaveBtnVisibility = true;
                    this.modalSaveFnParameter = "ProceedStep2WithDataSave";
                    this.modalTitle = '<span >Do you want to save changes made to the market definition selection?</span>';
                    this.modalBtnCapton = "Save";
                    this.modalCloseBtnCaption = "Cancel";
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    jQuery("#nextModal").modal("show");
                    this.clientService.fnSetLoadingAction(false);
                    return;
                }
            }
        } else {
            if (compareWithPreData == "Yes") {//clicked next btn                
                if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, client)) {
                    this.btnModalSaveClick("ProceedStep2");
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    this.clientService.fnSetLoadingAction(false);
                    //this.subscribeToAvailablePackList();
                } else {
                    this.modalSaveBtnVisibility = true;
                    //this.modalSaveFnParameter = "ProceedStep2WithDataSave";
                    this.modalSaveFnParameter = "Save changes market information";
                    this.modalTitle = '<span >Changes have been made to the Market Definition. Would you like to apply these?</span>';
                    this.modalBtnCapton = "Ok";
                    this.modalCloseBtnCaption = "Cancel";
                    jQuery("#nextModal").modal("show");
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    //this.temmpMarketDifinitionBaseMap=JSON.parse( JSON.stringify(this.clientInfoFinal[0].MarketDefinitions[0].MarketDefinitionBaseMaps)); 
                    this.clientService.fnSetLoadingAction(false);
                    return;
                }

            } else {//clicked save btn
                if (this.backFromMarketDef) {
                    if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, client)) {
                        this.clientInfoFinal = client;
                        this.clientsFiltered = client;
                        this.client_packList = client[0];
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalTitle = "Changes made to the market base selection criteria and will apply to the pack allocation.";
                        this.modalBtnCapton = "Save";
                        this.modalCloseBtnCaption = "Close";
                        jQuery("#nextModal").modal("show");
                        this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                        //this.backFromMarketDef=false;
                        this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientInfoFinal[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                        this.clientService.fnSetLoadingAction(false);
                        return;
                    } else {
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalTitle = "Changes made to the market base selection criteria and will apply to the pack allocation. ";
                        this.modalBtnCapton = "Save";
                        jQuery("#nextModal").modal("show");
                        this.clientInfoFinal = client;
                        this.clientsFiltered = client;
                        this.client_packList = client[0];
                        //to save into temp so that back
                        this.clickSavedBtnInStep1 = true;
                        this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientInfoFinal[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                        this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                        this.backFromMarketDef = false;
                        this.clientService.fnSetLoadingAction(false);
                    }

                } else {
                    this.clientInfoFinal = client;
                    this.clientsFiltered = client;
                    this.client_packList = client[0];
                    this.modalSaveBtnVisibility = false;
                    this.modalSaveFnParameter = "";
                    this.modalTitle = "Changes made to the market base selection criteria and will apply to the pack allocation.";
                    this.modalBtnCapton = "Save";
                    this.modalCloseBtnCaption = "Close";
                    jQuery("#nextModal").modal("show");
                    this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                    this.backFromMarketDef = false;
                    this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientInfoFinal[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                    this.clientService.fnSetLoadingAction(false);
                    //go to next step
                }

            }

        }

    }

    //to compare marketbase with previous data
    fnCompareMarketBaseArray(previousDataArray: any, currentDataArray: any): boolean {
        if (previousDataArray.length > 0 && currentDataArray.length > 0) {
            let previousMarketDifinitionBaseMap = JSON.parse(JSON.stringify(previousDataArray[0].MarketDefinitions[0].MarketDefinitionBaseMaps || []));
            let currentMarketDifinitionBaseMap = JSON.parse(JSON.stringify(currentDataArray[0].MarketDefinitions[0].MarketDefinitionBaseMaps || []));
            if (JSON.stringify(previousMarketDifinitionBaseMap) == JSON.stringify(currentMarketDifinitionBaseMap)) {
                return true;
            } else {
                return false;
            }
        } else {
            if (JSON.stringify(previousDataArray) == JSON.stringify(currentDataArray)) {
                return true;
            } else {
                return false;
            }
        }
        // return false;
    }

    fnGererateTempMarketBaseDuringEdit(returnStatus: string = '') {
        let marketBaseDetailsData: any = this.marketBases;
        let client: Client[] = [];
        let marketDefinition: any = [];
        let marketDefinitionBaseMap: any = [];
        let additionalFilter: any = [];
        let marketBase: any = [];
        let recordDetails: any = "";
        let clientID: any = "";
        let clientName: any = "";
        let itemChecked: any = false;
        let marketDefinitionName: string = jQuery("#newsTitle").val();
        //to ready data from table to bind market definition
        jQuery(".filTable tbody tr").each(function () {
            var recordID = jQuery(this).attr("class").split("-")[1];
            //read thats are checked
            if (jQuery("#chkbox_" + recordID).prop("checked") == true) {
                var baseName = jQuery(".filTable tbody tr.marketID-" + recordID + " td span.baseName").html();
                var selectedMarketBase: any = marketBaseDetailsData.filter((rec: any) => rec.Id == recordID)[0];
                var refreshSettingVal: any = "";
                itemChecked = true;
                //to select refreshSetting Val
                jQuery(".ref-" + recordID).each(function () {
                    if (jQuery(this).prop("checked") == true) {
                        refreshSettingVal = jQuery(this).attr("id").split("-")[0];
                    }
                });

                //to select content of filter option
                additionalFilter = [];
                let filterName, filterVal;
                let containsFlag: boolean = true;
                let excludeSymbol = '≠'
                jQuery(".filTable tbody tr.marketID-" + recordID + " td div.basefilter-" + recordID + " div.nodeEqual").each(function () {
                    let filterContent = jQuery(this).html();
                    if (filterContent.indexOf(excludeSymbol) > 0) {//for exclude
                        filterName = filterContent.split(excludeSymbol)[0].trim();
                        filterVal = filterContent.split(excludeSymbol)[1];
                        //to remove strong tag
                        filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];
                        containsFlag = false;

                    } else {//for include
                        filterName = filterContent.split("=")[0].trim();
                        filterVal = filterContent.split("=")[1];
                        //to remove strong tag
                        filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];
                        containsFlag = true;
                    }
                    /*jQuery(".filTable tbody tr.marketID-" + recordID + " td div.basefilter-" + recordID + " div.nodeEqual").each(function () {
                        var filterName = jQuery(this).html().split("=")[0];
                        var filterVal = jQuery(this).html().split("=")[1];
                        //to remove strong tag
                        filterVal = filterVal.split("<strong>")[1].split("</strong>")[0];*/

                    additionalFilter.push({ Id: recordID, Name: 'filter-' + recordID, Criteria: filterName, Values: filterVal, IsEnabled: containsFlag });
                });

                let marketBaseFilter = marketBaseDetailsData.filter((record: ClientMarketBase, index: any) => {
                    if (record.MarketBaseId == selectedMarketBase.MarketBaseId) {
                        return true;
                    } else {
                        return false;
                    }
                }) || [];
                //to bind market base filter array
                let marketBaseFilterArray: BaseFilter[] = [];
                marketBaseFilter.forEach((rec: ClientMarketBase, index: any) => {
                    marketBaseFilterArray.push({ Id: rec.Id, Name: rec.BaseFilterName, Criteria: rec.BaseFilterCriteria, Values: rec.BaseFilterValues, IsEnabled: true, MarketBaseId: rec.MarketBaseId, IsRestricted: rec.IsRestricted, IsBaseFilterType: rec.IsBaseFilterType });
                });


                marketBase = { Id: selectedMarketBase.MarketBaseId, Name: selectedMarketBase.MarketBaseName, Description: selectedMarketBase.Description, Filters: marketBaseFilterArray };
                //change marketDefinitionBaseMap for marketBaseId
                //marketDefinitionBaseMap.push({ Id: recordID, Name: baseName, MarketBase: marketBase, Filters: additionalFilter, DataRefreshType: refreshSettingVal });
                marketDefinitionBaseMap.push({ Id: recordID, Name: baseName, MarketBaseId: selectedMarketBase.MarketBaseId, MarketBase: marketBase, Filters: additionalFilter, DataRefreshType: refreshSettingVal });
                clientID = selectedMarketBase.ClientId;
                clientName = selectedMarketBase.ClientName;
            }
        });


        marketDefinition.push({ Id: 1, Name: marketDefinitionName, Description: '', MarketDefinitionBaseMaps: marketDefinitionBaseMap });
        client.push({ Id: clientID, Name: clientName, IsMyClient: true, MarketDefinitions: marketDefinition });
        if (returnStatus == "") {
            this.clientInfoFinal = client;
            this.clientsFiltered = client;
            this.client_packList = client[0];
            this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
        }

        //if (marketDefinitionBaseMap.length > 0 || marketDefinition.length>0) {
        if (marketDefinitionBaseMap.length > 0) {
            return client;
        } else {
            return [];
        }
    }

    fnBacktoPreStateMarketDef() {
        //compare there are anyting changes
        if (JSON.stringify(this.tempDynamicPackMarketBbase) == JSON.stringify(this.dynamicPackMarketBase) && JSON.stringify(this.tempStaticPackMarketBbase) == JSON.stringify(this.staticPackMarketBase)) {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = '<span >No Changes have been made to the Market Definition.</span>';
            this.modalCloseBtnCaption = "Ok";
            jQuery("#customModal").modal("show");
        } else {
            //back to previous data
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "Market Definition Back to Previous State";
            this.modalTitle = '<span >Changes made to the market definition criteria will not apply. Would you like to proceed? </span>';
            //this.modalBtnCapton = "Yes";
            this.modalBtnCapton = "Ok";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#customModal").modal("show");
            return;
        }

    }

    async subscribeToAvailablePackList() {
        this.clientService.fnSetLoadingAction(true);
        console.log('this.client_packList.MarketDefinitions.length=', this.client_packList.MarketDefinitions.length);
        var ADDfilterCondition = '';
        var BASEfilterCondition = '';
        var query = '';
        var finalQuery = '';

        var staticQuery = '';
        var dynamicQuery = '';
        var staticFinalQuery = '';
        var dynamicFinalQuery = '';
        for (var i = 0; i < this.client_packList.MarketDefinitions.length; i++) {
            //console.log('marketdef.length=', this.client_packList.MarketDefinitions.length);
            var marketdefbasemap = this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps;
            //console.log('marketdefbasemap.length=', marketdefbasemap.length);
            for (var j = 0; j < marketdefbasemap.length; j++) {
                if (this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps[j].DataRefreshType == 'static') {
                    staticQuery = this._buildQuery(i, j, ADDfilterCondition, BASEfilterCondition, staticQuery, 'static');
                    if (staticFinalQuery == '')
                        staticFinalQuery = staticQuery;
                    else {
                        staticFinalQuery = staticFinalQuery + ' UNION ' + staticQuery;
                        //console.log('....staticFinalQuery:', staticFinalQuery);

                    }
                }

                else if (this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps[j].DataRefreshType == 'dynamic') {
                    dynamicQuery = this._buildQuery(i, j, ADDfilterCondition, BASEfilterCondition, dynamicQuery, 'dynamic');
                    if (dynamicFinalQuery == '')
                        dynamicFinalQuery = dynamicQuery;

                    else {
                        dynamicFinalQuery = dynamicFinalQuery + ' UNION ' + dynamicQuery;
                        //console.log('....dynamicFinalQuery:', dynamicFinalQuery);
                    }
                }
            }

            // this.clientService.fnSetLoadingAction(false);

        }


        //this.clientService.getAvailablePackList(finalQuery);
        var initialDynamicQuery: string = '';
        if (dynamicFinalQuery != '') {
            initialDynamicQuery = dynamicFinalQuery;
            dynamicFinalQuery = 'SELECT ROW_NUMBER() OVER(ORDER BY PACK)+5000 as \'Id\', * FROM ( ' + dynamicFinalQuery + ' )D';
            dynamicFinalQuery = this._buildQueryForConcatenation(dynamicFinalQuery, 'dynamic');
            dynamicFinalQuery = this._deleteTemporaryTables() + dynamicFinalQuery;
            console.log('....full finalQuery:', dynamicFinalQuery);
        }

        if (staticFinalQuery != '') {
            if (dynamicFinalQuery != '') {
                staticFinalQuery = staticFinalQuery + ' AND PFC not in (select distinct PFC from (' + initialDynamicQuery + ')PFC)\n';
            }
            staticFinalQuery = 'SELECT ROW_NUMBER() OVER(ORDER BY PACK)+1000 as \'Id\', * FROM ( ' + staticFinalQuery + ' )S';
            staticFinalQuery = this._buildQueryForConcatenation(staticFinalQuery, 'static');
            staticFinalQuery = this._deleteTemporaryTables() + staticFinalQuery;
            console.log('....full staticFinalQuery:', staticFinalQuery);
        }



        await this.clientService.getDynamicAvailablePackList(dynamicFinalQuery, this.editableClientID).then(result => { this._processDynamicAvailablePacks(result) }).catch((err: any) => { this.clientService.fnSetLoadingAction(false); this.mmErrModal.show(); });
        await this.clientService.getStaticAvailablePackList(staticFinalQuery, this.editableClientID).then(data => { this._processStaticAvailablePacks(data) }).catch((err: any) => { this.clientService.fnSetLoadingAction(false); this.mmErrModal.show(); });
        this.clientService.fnSetLoadingAction(false);

    }

    private _buildQuery(i: number, j: number, ADDfilterCondition: string, BASEfilterCondition: string, query: string, DataRefreshType: string): string {
        var addfilter = this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps[j].Filters;
        var baseName = this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps[j].MarketBase.Name;
        var baseId = this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps[j].MarketBase.Id;
        var basefilter = this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps[j].MarketBase.Filters;
        var logicalORflag = false;
        var restrictedValue = false;
        //console.log('base filter: ', basefilter);
        //console.log('addfilter.length=', addfilter.length);
        if (addfilter.length > 0) {
            for (var k = 0; k < addfilter.length; k++) {
                var criteria = '';
                if (addfilter[k].Criteria == 'MFR' || addfilter[k].Criteria == 'Manufacturer')
                    criteria = 'Org_Long_Name';
                else if (addfilter[k].Criteria == 'Molecule') {
                    criteria = 'Description';
                }
                else if (addfilter[k].Criteria == 'Flagging')
                    criteria = 'FRM_Flgs5_Desc';
                else if (addfilter[k].Criteria == 'Branding')
                    criteria = 'Frm_Flgs3_Desc';
                else if (addfilter[k].Criteria == 'Product')
                    criteria = 'ProductName';

                if (criteria != '') {
                    var values = addfilter[k].Values;
                    //console.log('add criteria=', criteria);
                    //console.log('add filter values=', values);
                    //values = "( '" + values.replace(",", "' , '") + "' )";

                    //console.log('add values filter:', values);
                    if (criteria != 'Description') {
                        values = "( " + values + " )";
                        //ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' and ';
                        if (addfilter[k].IsEnabled) {
                            ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
                        } else {
                            ADDfilterCondition = ADDfilterCondition + criteria + ' not in ' + values + ' OR ';
                        }

                    }
                    else if (this.tempFiltersForMolecule.length > 0) {
                        if (this.tempFiltersForMolecule[0].Values.indexOf('|') > 0) {// for multiple molecule
                            var concatValues = this.tempFiltersForMolecule[0].Values;
                            var tempArr: any[] = concatValues.split('|');
                            tempArr.forEach((item: any) => {
                                item = "(\'%" + item.replace(/'/g, '') + "%\')";
                                //ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + item + ' or ';
                                if (addfilter[k].IsEnabled) {
                                    ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + item + ' OR ';
                                } else {
                                    ADDfilterCondition = ADDfilterCondition + criteria + ' not like ' + item + ' OR ';
                                }
                            });

                        } else {
                            values = "(\'%" + values.replace(/'/g, '') + "%\')";
                            //ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + values + ' or ';
                            if (addfilter[k].IsEnabled) {
                                ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + values + ' OR ';
                            } else {
                                ADDfilterCondition = ADDfilterCondition + criteria + ' not like ' + values + ' OR ';
                            }
                        }

                        this.tempFiltersForMolecule = [];

                        ADDfilterCondition = '( ' + ADDfilterCondition.substring(0, ADDfilterCondition.length - 4) + ' )';

                        ADDfilterCondition += ' and ';

                    }
                }

            }
            var first = true;
            var second = true;
            for (var k = 0; k < addfilter.length; k++) {
                var criteria = '';
                if (addfilter[k].Criteria == 'ATC 1' || addfilter[k].Criteria == 'ATC1') {
                    if (first) { first = false; criteria = '#ATC1_Code'; }
                    else criteria = 'ATC1_Code';
                }

                else if (addfilter[k].Criteria == 'ATC 2' || addfilter[k].Criteria == 'ATC2') {
                    if (first) { first = false; criteria = '#ATC2_Code'; }
                    else criteria = 'ATC2_Code';
                }
                else if (addfilter[k].Criteria == 'ATC 3' || addfilter[k].Criteria == 'ATC3') {
                    if (first) { first = false; criteria = '#ATC3_Code'; }
                    else criteria = 'ATC3_Code';
                }
                else if (addfilter[k].Criteria == 'ATC 4' || addfilter[k].Criteria == 'ATC4') {
                    if (first) { first = false; criteria = '#ATC4_Code'; }
                    else criteria = 'ATC4_Code';
                }

                if (criteria != '') {
                    var values = addfilter[k].Values;
                    //console.log('add criteria=', criteria);
                    //console.log('add filter values=', values);
                    // values = "( '" + values.replace(",", "' , '") + "' )";
                    values = "( " + values + " )";
                    //console.log('add values filter:', values);
                    //ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
                    if (addfilter[k].IsEnabled) {
                        ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
                    } else {
                        ADDfilterCondition = ADDfilterCondition + criteria + ' not in ' + values + ' OR ';
                    }
                    logicalORflag = true;
                }

            }

            if (logicalORflag) {
                ADDfilterCondition = ADDfilterCondition + '@ ) and ';
                ADDfilterCondition = ADDfilterCondition.replace("OR @", " ");
                ADDfilterCondition = ADDfilterCondition.replace("#", " ( ");
                logicalORflag = false;
            }


            for (var m = 0; m < addfilter.length; m++) {
                var criteria = '';
                if (addfilter[m].Criteria == 'NEC1' || addfilter[m].Criteria == 'NEC 1') {
                    if (second) { second = false; criteria = '#NEC1_Code'; console.log("criteria NEC1" + criteria); }
                    else criteria = 'NEC1_Code';
                }
                else if (addfilter[m].Criteria == 'NEC2' || addfilter[m].Criteria == 'NEC 2') {
                    if (second) { second = false; criteria = '#NEC2_Code'; }
                    else criteria = 'NEC2_Code';
                }
                else if (addfilter[m].Criteria == 'NEC3' || addfilter[m].Criteria == 'NEC 3') {
                    if (second) { second = false; criteria = '#NEC3_Code'; }
                    else criteria = 'NEC3_Code';
                }
                else if (addfilter[m].Criteria == 'NEC4' || addfilter[m].Criteria == 'NEC 4') {
                    if (second) { second = false; criteria = '#NEC4_Code'; }
                    else criteria = 'NEC4_Code';
                }

                if (criteria != '') {
                    var values = addfilter[m].Values;
                    //console.log('add criteria=', criteria);
                    //console.log('add filter values=', values);
                    // values = "( '" + values.replace(",", "' , '") + "' )";
                    values = "( " + values + " )";
                    //console.log('add values filter:', values);
                    //ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
                    if (addfilter[m].IsEnabled) {
                        ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
                    } else {
                        ADDfilterCondition = ADDfilterCondition + criteria + ' not in ' + values + ' OR ';
                    }


                    //console.log(addfilter[m].IsEnabled);

                    logicalORflag = true;
                }


            }

            if (logicalORflag) {
                ADDfilterCondition = ADDfilterCondition + '@ )';
                ADDfilterCondition = ADDfilterCondition.replace("OR @", " ");
                //console.log("ADDfilterCondition..." + ADDfilterCondition);
                ADDfilterCondition = ADDfilterCondition.replace("#", " ( ");
                //console.log("ADDfilterCondition$$..." + ADDfilterCondition);
            }
            else {
                ADDfilterCondition = ADDfilterCondition + '@';
                ADDfilterCondition = ADDfilterCondition.replace("and @", " ");
                ADDfilterCondition = ADDfilterCondition.replace("OR @", " ");

            }


            //console.log('ADDfilterCondition:', ADDfilterCondition);
        }


        // for non restrcit 
        //console.log('non restrict basefilter.length=', basefilter.length);
        for (var m = 0; m < basefilter.length; m++) {
            var criteria1 = '';
            if ((basefilter[m].Criteria == 'ATC 1' || basefilter[m].Criteria == 'ATC1') && !basefilter[m].IsRestricted)
                criteria1 = 'ATC1_Code';
            else if ((basefilter[m].Criteria == 'ATC 2' || basefilter[m].Criteria == 'ATC2') && !basefilter[m].IsRestricted)
                criteria1 = 'ATC2_Code';
            else if ((basefilter[m].Criteria == 'ATC 3' || basefilter[m].Criteria == 'ATC3') && !basefilter[m].IsRestricted)
                criteria1 = 'ATC3_Code';
            else if ((basefilter[m].Criteria == 'ATC 4' || basefilter[m].Criteria == 'ATC4') && !basefilter[m].IsRestricted)
                criteria1 = 'ATC4_Code';
            else if ((basefilter[m].Criteria == 'MFR' || basefilter[m].Criteria == 'Manufacturer') && !basefilter[m].IsRestricted)
                criteria1 = 'Org_Long_Name';
            else if ((basefilter[m].Criteria == 'NEC1' || basefilter[m].Criteria == 'NEC 1') && !basefilter[m].IsRestricted)
                criteria1 = 'NEC1_Code';
            else if ((basefilter[m].Criteria == 'NEC2' || basefilter[m].Criteria == 'NEC 2') && !basefilter[m].IsRestricted)
                criteria1 = 'NEC2_Code';
            else if ((basefilter[m].Criteria == 'NEC3' || basefilter[m].Criteria == 'NEC 3') && !basefilter[m].IsRestricted)
                criteria1 = 'NEC3_Code';
            else if ((basefilter[m].Criteria == 'NEC4' || basefilter[m].Criteria == 'NEC 4') && !basefilter[m].IsRestricted)
                criteria1 = 'NEC4_Code';
            else if ((basefilter[m].Criteria == 'Molecule') && !basefilter[m].IsRestricted) {
                criteria1 = 'Description';
            }
            else if ((basefilter[m].Criteria == 'Flagging') && !basefilter[m].IsRestricted)
                criteria1 = 'FRM_Flgs5_Desc';
            else if ((basefilter[m].Criteria == 'Branding') && !basefilter[m].IsRestricted)
                criteria1 = 'Frm_Flgs3_Desc';
            else if ((basefilter[m].Criteria == 'Product') && !basefilter[m].IsRestricted)
                criteria1 = 'ProductName';
            else if ((basefilter[m].Criteria == 'PACK') && !basefilter[m].IsRestricted)
                criteria1 = 'PFC';

            // var criteria1 = basefilter[m].Criteria;
            if (criteria1.length > 0) {
                var values = basefilter[m].Values;
                //console.log('basecriteria=', criteria1);
                //console.log('basefilter values=', values);
                //values = "( '" + values.replace(",", "' , '") + "' )";
                values = "( " + values + " )";
                //console.log('base values filter:', values);
                BASEfilterCondition = BASEfilterCondition + criteria1 + ' in ' + values + ' and ';
            }


        }
        if (BASEfilterCondition.length > 0) {
            BASEfilterCondition = BASEfilterCondition + '@';
            BASEfilterCondition = BASEfilterCondition.replace("and @", " ");
            //console.log('filterCondition:', BASEfilterCondition);
        }
        BASEfilterCondition = BASEfilterCondition + ' and#';
        //for restrict check
        //console.log('restrict basefilter.length=', basefilter.length);
        for (var m = 0; m < basefilter.length; m++) {
            var criteria1 = '';
            if ((basefilter[m].Criteria == 'ATC 1' || basefilter[m].Criteria == 'ATC1') && basefilter[m].IsRestricted)
                criteria1 = 'ATC1_Code';
            else if ((basefilter[m].Criteria == 'ATC 2' || basefilter[m].Criteria == 'ATC2') && basefilter[m].IsRestricted)
                criteria1 = 'ATC2_Code';
            else if ((basefilter[m].Criteria == 'ATC 3' || basefilter[m].Criteria == 'ATC3') && basefilter[m].IsRestricted)
                criteria1 = 'ATC3_Code';
            else if ((basefilter[m].Criteria == 'ATC 4' || basefilter[m].Criteria == 'ATC4') && basefilter[m].IsRestricted)
                criteria1 = 'ATC4_Code';
            else if ((basefilter[m].Criteria == 'MFR' || basefilter[m].Criteria == 'Manufacturer') && basefilter[m].IsRestricted)
                criteria1 = 'Org_Long_Name';
            else if ((basefilter[m].Criteria == 'NEC1' || basefilter[m].Criteria == 'NEC 1') && basefilter[m].IsRestricted)
                criteria1 = 'NEC1_Code';
            else if ((basefilter[m].Criteria == 'NEC2' || basefilter[m].Criteria == 'NEC 2') && basefilter[m].IsRestricted)
                criteria1 = 'NEC2_Code';
            else if ((basefilter[m].Criteria == 'NEC3' || basefilter[m].Criteria == 'NEC 3') && basefilter[m].IsRestricted)
                criteria1 = 'NEC3_Code';
            else if ((basefilter[m].Criteria == 'NEC4' || basefilter[m].Criteria == 'NEC 4') && basefilter[m].IsRestricted)
                criteria1 = 'NEC4_Code';
            else if ((basefilter[m].Criteria == 'Molecule') && basefilter[m].IsRestricted) {
                criteria1 = 'Description';
            }
            else if ((basefilter[m].Criteria == 'Flagging') && basefilter[m].IsRestricted)
                criteria1 = 'FRM_Flgs5_Desc';
            else if ((basefilter[m].Criteria == 'Branding') && basefilter[m].IsRestricted)
                criteria1 = 'Frm_Flgs3_Desc';
            else if ((basefilter[m].Criteria == 'Product') && basefilter[m].IsRestricted)
                criteria1 = 'ProductName';
            else if ((basefilter[m].Criteria == 'PACK') && basefilter[m].IsRestricted)
                criteria1 = 'PFC';

            // var criteria1 = basefilter[m].Criteria;
            if (criteria1.length > 0) {
                var values = basefilter[m].Values;
                //console.log('basecriteria=', criteria1);
                //console.log('basefilter values=', values);
                // values = "( '" + values.replace(",", "' , '") + "' )";
                values = "( " + values + " )";
                //console.log('base values filter:', values);
                BASEfilterCondition = BASEfilterCondition + criteria1 + ' not in ' + values + ' and ';
                restrictedValue = true;
            }


        }
        if (restrictedValue) {
            BASEfilterCondition = BASEfilterCondition.replace("and#", " and ");
            BASEfilterCondition = BASEfilterCondition + '@';
            BASEfilterCondition = BASEfilterCondition.replace("and @", " ");
            //console.log('filterCondition:', BASEfilterCondition);
        }
        else if (!restrictedValue) {
            BASEfilterCondition = BASEfilterCondition.replace("and#", " ");
            //console.log('filterCondition:', BASEfilterCondition);
        }

        if (addfilter.length > 0) {
            query = ' SELECT DISTINCT Pack_Description AS Pack , \'' + baseName + '\' AS MarketBase, \'' + baseId + '\' AS MarketBaseId'
                + ', \'\' AS GroupNumber, \'\' AS GroupName, \'\' AS Factor, PFC,  Org_Long_Name AS Manufacturer, ATC4_Code AS ATC4, NEC4_Code AS NEC4, \'' + DataRefreshType + '\' AS DataRefreshType' + ', ProductName AS Product' + ', dm.Description As Molecule' + ', DIMProduct_Expanded.highlighter AS ChangeFlag'
                + ' from DIMProduct_Expanded left JOIN dbo.DMMoleculeConcat dm ON DIMProduct_Expanded.FCC = dm.FCC ' +
                ' WHERE ' + BASEfilterCondition + ' AND  ' + ADDfilterCondition + ' AND (DIMProduct_Expanded.highlighter IS NULL OR DIMProduct_Expanded.highlighter <> \'D\')';
        }
        else {
            query = ' SELECT DISTINCT Pack_Description AS Pack , \'' + baseName + '\' AS MarketBase, \'' + baseId + '\' AS MarketBaseId'
                + ', \'\' AS GroupNumber, \'\' AS GroupName, \'\' AS Factor, PFC,  Org_Long_Name AS Manufacturer, ATC4_Code AS ATC4, NEC4_Code AS NEC4, \'' + DataRefreshType + '\' AS DataRefreshType' + ', ProductName AS Product' + ', dm.Description As Molecule' + ', DIMProduct_Expanded.highlighter AS ChangeFlag'
                + ' from DIMProduct_Expanded left JOIN dbo.DMMoleculeConcat dm ON DIMProduct_Expanded.FCC = dm.FCC ' +
                ' WHERE ' + BASEfilterCondition + ' AND (DIMProduct_Expanded.highlighter IS NULL OR DIMProduct_Expanded.highlighter <> \'D\')';
        }
        BASEfilterCondition = '';
        ADDfilterCondition = '';

        //console.log('query:', DataRefreshType, query);
        return query;
    }

    private _deleteTemporaryTables() {
        var statement = 'IF OBJECT_ID(\'tempdb..#td\') IS NOT NULL DROP TABLE #td;\n\nIF OBJECT_ID(\'tempdb..#ts\') IS NOT NULL DROP TABLE #ts;\n\n';
        return statement;
    }

    private _buildQueryForConcatenation(query: string, queryType: string): string {
        var tempTable: string;
        if (queryType == 'static') {
            index = '1000';
            tempTable = '#ts';
        }
        else {
            index = '50000';
            tempTable = '#td';
        }
        var index = (queryType == 'static') ? '1000' : '50000';
        query = 'select Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, Product, Molecule, ChangeFlag into ' + tempTable + ' from(' + query + ')A;\n\n';

        //var moleculeConcatQuery = '';
        //moleculeConcatQuery += 'Select distinct A.Pack, A.GroupNumber, A.GroupName, A.Factor, A.Manufacturer, A.ATC4, A.NEC4, A.DataRefreshType, A.Product, substring(A.Molecule, 2, 5000) Molecule, A.ChangeFlag, A.MarketBaseId, A.MarketBase ';
        //moleculeConcatQuery += 'into #m from (SELECT b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Product, b.ChangeFlag, b.MarketBaseId, b.MarketBase, ';
        //moleculeConcatQuery += '(SELECT \',\' + a.Molecule FROM #t a WHERE a.Pack = b.Pack and a.NEC4 = b.NEC4 and a.Manufacturer = b.Manufacturer and a.MarketBaseId = b.MarketBaseId ';
        //moleculeConcatQuery += 'FOR XML PATH(\'\'))[Molecule] FROM #t b ';
        //moleculeConcatQuery += 'GROUP BY b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Product, b.ChangeFlag, b.MarketBaseId, b.MarketBase)A order by A.Pack;\n\n';

        //query += moleculeConcatQuery;

        var queryToConcat = 'SELECT ROW_NUMBER() OVER(ORDER BY PACK)+' + index + ' as \'Id\', * FROM (  ';
        queryToConcat += 'Select distinct A.Pack, A.GroupNumber, A.GroupName, A.Factor, A.PFC, A.Manufacturer, A.ATC4, A.NEC4, A.DataRefreshType, A.Product, A.Molecule, A.ChangeFlag, ';
        queryToConcat += 'substring(A.MarketBase, 2, 200) MarketBase, substring(A.MarketBaseId, 2, 200) MarketBaseId ';
        queryToConcat += 'from ';
        queryToConcat += '( SELECT ';
        queryToConcat += 'b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.PFC, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Product, b.Molecule, b.ChangeFlag, ';
        queryToConcat += '(SELECT \',\' + a.MarketBase FROM ' + tempTable + ' a WHERE a.Pack = b.Pack and a.NEC4 = b.NEC4 and a.Manufacturer = b.Manufacturer and a.PFC = b.PFC ';
        queryToConcat += 'FOR XML PATH(\'\'))[MarketBase], ';
        queryToConcat += '(SELECT \',\' + a.MarketBaseId FROM ' + tempTable + ' a ';
        queryToConcat += 'WHERE a.Pack = b.Pack and a.NEC4 = b.NEC4 and a.Manufacturer = b.Manufacturer and a.PFC = b.PFC FOR XML PATH(\'\')) [MarketBaseId] FROM ' + tempTable + ' b ';
        queryToConcat += 'GROUP BY b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.PFC, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Molecule, b.Product, b.ChangeFlag, b.MarketBaseId )A \n\n';
        queryToConcat += ' )X';
        query += queryToConcat;


        //console.log('AFTER CONCAT inside function:', query);
        return query;
    }


    private _processDynamicAvailablePacks(data: DynamicPackMarketBase[]) {
        //console.log('data length: ', data.length);
        this.dynamicPackMarketBase = data || [];//pack assign 
        this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase));
        //console.log('pack market bases in component: ', this.dynamicPackMarketBase);
        this.isFirstTimeLoadMarketDefinition = true;
        this.isChangeDetectedInMarketDefinition = false;
    }

    private _processStaticAvailablePacks(data: StaticPackMarketBase[]) {
        this.staticPackMarketBase = data || [];
        this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase));
        //console.log('pack market bases in component 111: ', this.staticPackMarketBase);
    }

    async btnModalSaveClick(action: string) {
        if (action == "ProceedStep2") {
            this.marketCreationStep1 = "none";
            this.marketCreationStep2 = "block";
            //jQuery("#nextModal").modal("hide");            
        } else if (action == "ProceedStep1") {
            this.marketCreationStep1 = "block";
            this.marketCreationStep2 = "none";
            jQuery("#nextModal").modal("hide");
        } else if (action == "ProceedStep2WithDataSave") {
            jQuery("#nextModal").modal("hide");
            this.backFromMarketDef = false;
            await this.subscribeToAvailablePackList();
            if (this.dynamicPackMarketBase.length > 0 || this.staticPackMarketBase.length > 0) {
                this.isChangeDetectedInMarketDefinition = true;
                this.isChangeDetectedInMarketSetup = false;
                this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientInfoFinal[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                this.marketCreationStep1 = "none";
                this.marketCreationStep2 = "block";
            } else {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "There are no packs available in the market definition content. Please review.";
                this.modalBtnCapton = "";
                this.modalCloseBtnCaption = "OK";
                jQuery("#nextModal").modal("show");
            }


        } else if (action == "SaveClientMarketDef") {
            if (this.isEditMarketDef == true && this.editableClientID != 0 && this.editableMarketDefID != 0) {
                //edit function here
                jQuery("#nextModal").modal("hide");
                this.clientService.fnSetLoadingAction(true);
                this.subscribeToEditClientMarketDef(this.editableClientID, this.editableMarketDefID);
                this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase));
                this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase));

                //code for change market base refresh type
                this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                this.fnExistingMarketDefinitioneEmit();
                this.isChangeDetectedInMarketDefinition = false;


            } else {
                //new item save   
                jQuery("#nextModal").modal("hide");
                this.clientService.fnSetLoadingAction(true);
                this.subscribeToSaveClientMarketDef(this.editableClientID);
                this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase));
                this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase));
                //console.log("temp data:" + this.tempDynamicPackMarketBbase.length + " dynamic data length:" + this.dynamicPackMarketBase.length);

                //code for change market base refresh type
                this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                this.fnExistingMarketDefinitioneEmit();
                this.isChangeDetectedInMarketDefinition = false;

            }


        } else if (action == "ClearMarketCreateStep") {
            if (this.editableMarketDefID == 0) {
                jQuery(".filTable tbody input[type=checkbox]").prop("checked", false);
                jQuery(".filTable tbody div.refresh-setting").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody div.base-filter-info").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody a.filter-setting").removeClass("purpLink").addClass("disab");
                jQuery(".filTable tbody div.base-filter-info div.nodeEqual").remove();
                jQuery(".filTable tbody td span.baseName").removeClass("textWeightBold").addClass("textWeightNormal");
                this.fnExistingMarketDefinitioneEmit();
            } else {
                jQuery(".filTable tbody input[type=checkbox]").prop("checked", false);
                jQuery(".filTable tbody div.refresh-setting").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody div.base-filter-info").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody a.filter-setting").removeClass("purpLink").addClass("disab");
                jQuery(".filTable tbody div.base-filter-info div.nodeEqual").remove();
                jQuery(".filTable tbody td span.baseName").removeClass("textWeightBold").addClass("textWeightNormal");
                this.fnExistingMarketDefinitioneEmit();

            }
            jQuery("#nextModal").modal("hide");
        } else if (action == "ClearMarketCreateStepFromModal") {
            if (this.editableMarketDefID == 0) {
                jQuery(".filTable tbody input[type=checkbox]").prop("checked", false);
                jQuery(".filTable tbody div.refresh-setting").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody div.base-filter-info").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody a.filter-setting").removeClass("purpLink").addClass("disab");
                jQuery(".filTable tbody div.base-filter-info div.nodeEqual").remove();
                jQuery(".filTable tbody td span.baseName").removeClass("textWeightBold").addClass("textWeightNormal");
                this.fnExistingMarketDefinitioneEmit();
            } else {
                jQuery(".filTable tbody input[type=checkbox]").prop("checked", false);
                jQuery(".filTable tbody div.refresh-setting").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody div.base-filter-info").removeClass("userRefreshVisible").addClass("userRefreshHidden");
                jQuery(".filTable tbody a.filter-setting").removeClass("purpLink").addClass("disab");
                jQuery(".filTable tbody div.base-filter-info div.nodeEqual").remove();
                jQuery(".filTable tbody td span.baseName").removeClass("textWeightBold").addClass("textWeightNormal");
                this.fnExistingMarketDefinitioneEmit();

            }
        } else if (action == "marketDefinitionBackToPreviousState") {
            //console.log("back to temp data temp data:" + this.tempDynamicPackMarketBbase.length + " dynamic data length:" + this.dynamicPackMarketBase.length);
            this.dynamicPackMarketBase = JSON.parse(JSON.stringify(this.tempDynamicPackMarketBbase));
            this.staticPackMarketBase = JSON.parse(JSON.stringify(this.tempStaticPackMarketBbase));

            jQuery("#nextModal").modal("hide");
            return;
        } else if (action == "SaveMarketBaseWithDeletePreviousData") {
            this.clickSavedBtnInStep1 = true;
            this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientInfoFinal[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
            this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
            jQuery("#nextModal").modal("hide");
            this.backFromMarketDef = false;
            return;
        } else if (action == "DeleteFromMarketDefinition") {
            let selectedDynamicObject: any = "";
            let selectMarketBaseArray: any[] = [];
            let dynamicPacks = this.dynamicPackMarketBase || [];
            let recordID: any;
            jQuery(".checkbox-dynamic-table").each(function () {
                if (jQuery(this).prop("checked") == true) {
                    selectedDynamicObject = selectedDynamicObject + jQuery(this).attr("data-sectionvalue") + "|";
                    //let marketBaseName = jQuery("#dynamic-table tr.row-" + jQuery(this).attr("data-sectionvalue") + " td.dynamic-market-base").text().trim();
                    recordID = jQuery(this).attr("data-sectionvalue");
                    let marketBaseName = dynamicPacks.filter((rec: any) => { if (rec.Id == recordID) { return true } else { return false } })[0].MarketBase;
                    if (selectMarketBaseArray.indexOf(marketBaseName) < 0) {
                        selectMarketBaseArray.push(marketBaseName);
                    }
                }
            });
            let selectedDynamicObjectArry = selectedDynamicObject.split("|");
            //to remove group from selected data
            for (let i = 0; i < Number(selectedDynamicObjectArry.length - 1); i++) {
                this.dynamicPackMarketBase.forEach((rec: any, index: any) => {
                    if (rec.Id == Number(selectedDynamicObjectArry[i])) {
                        rec.GroupID = "",
                            rec.GroupName = "",
                            rec.GroupNumber = "",
                            rec.Factor = ""
                        return;
                    }
                });
            }

            //to set refresh status
            for (let i = 0; i < selectMarketBaseArray.length; i++) {
                this.dynamicPackMarketBase.forEach(function (part, index) {
                    if (part.MarketBase == selectMarketBaseArray[i]) {
                        part.DataRefreshType = "static";
                    }
                });

                // to shift dynamic to static in MarketDefinitionBaseMaps array
                selectMarketBaseArray.forEach((rec: any, index: any) => {
                    this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionBaseMaps.forEach((record: any, index: any) => {
                        if (rec.trim() == record.Name.trim()) {
                            record.DataRefreshType = "static";
                        }
                    });
                });

                //to disable footer btns of dynamic table
                this.enabledDynamicTableFooterBtns = false;
            }

            //to shift dynamic to static           
            for (let i = 0; i < Number(selectedDynamicObjectArry.length - 1); i++) {
                let item = selectedDynamicObjectArry[i];
                var selectedDynamicInfo = this.dynamicPackMarketBase.filter((rec: any) => rec.Id == item)[0];
                this.dynamicPackMarketBase.splice(this.dynamicPackMarketBase.indexOf(selectedDynamicInfo), 1);//remove form dynamic
                this.staticPackMarketBase.push(selectedDynamicInfo);//push in static
            }

            /*this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Packs move to Available Pack List and relevant market base changes to 'Static'.";
            this.modalCloseBtnCaption = "OK";*/
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Pack/s have moved to ‘Available Pack List’ and the market base <b>" + selectMarketBaseArray + "’s</b> data refresh setting has changed to static. Any new packs loaded into this market base will not automatically insert into the market definition.";
            this.modalCloseBtnCaption = "OK";
            jQuery("#nextModal").modal("show");
        } else if (action == "BackToMarketBaseWithDataSave") {
            this.btnModalSaveClick("SaveClientMarketDef");//back with savings data
            this.marketCreationStep1 = "block";
            this.marketCreationStep2 = "none";
            this.backFromMarketDef = true;
            return;
        } else if (action == "RemoveGropInformation") {
            for (let i = 0; i < this.selectedGroupID.length; i++) {
                this.dynamicPackMarketBase.forEach((part, index) => {
                    if (part.Id == Number(this.selectedGroupID[i])) {
                        part.GroupName = "";
                        part.GroupNumber = "";
                        part.Factor = "";
                    }
                });
            }
            jQuery("#nextModal").modal("hide");
            jQuery("#dynamic-table .checkbox-dynamic-table").prop("checked", false);
            jQuery("#dynamic-table .select-all-dynamic-table").prop("checked", false);
            //to disable footer btns of dynamic table            
            this.enabledDynamicTableFooterBtns = false;
            this.fnMarketDefChangeDetection();

        } else if (action == "Save changes market information") {
            jQuery("#nextModal").modal("hide");
            this.modalSaveBtnVisibility = false;
            this.isChangeDetectedInMarketSetup = false;
            this.fnMarketSetupChangeDetection();
            //this.modalSaveFnParameter = "ProceedStep2WithDataSave";
            this.modalSaveFnParameter = "ProceedStep2WithDataSave from second conformation";
            this.modalTitle = '<span >Changes made to the market base selection criteria and will apply to the pack allocation.</span>';
            this.modalCloseBtnCaption = "Ok";
            jQuery("#customModal").modal("show");
            return;
        } else if (action == "back to market tiles page") {
            jQuery("#nextModal").modal("hide");
            this.fnRelocateMarketTiles();
            //this.router.navigate(['market/My-Client/' + this.editableClientID]);
        } else if (action == "Back to previous step of Market setup") {
            jQuery("#customModal").modal("hide");
            this.clearMarketCreateStep();
        } else if (action == "Market Definition Back to Previous State") {
            //back to previous data
            jQuery("#customModal").modal("hide");
            this.isFirstTimeLoadMarketDefinition = true;
            this.dynamicPackMarketBase = JSON.parse(JSON.stringify(this.tempDynamicPackMarketBbase));
            this.staticPackMarketBase = JSON.parse(JSON.stringify(this.tempStaticPackMarketBbase));
            this.isChangeDetectedInMarketDefinition = false;
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = '<span >Changes made to the market definition criteria for pack allocation have not been applied.</span>';
            this.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");

        } else if (action == "back to market tiles page with saving data") {
            if (this.isEditMarketDef == true && this.editableClientID != 0 && this.editableMarketDefID != 0) {
                //edit function here
                jQuery("#nextModal").modal("hide");
                this.clientService.fnSetLoadingAction(true);
                this.subscribeToEditClientMarketDef(this.editableClientID, this.editableMarketDefID, 'Save data with back to tiles page');
                this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase));
                this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase));

                //code for change market base refresh type
                this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                this.fnExistingMarketDefinitioneEmit();

            } else {
                //new item save   
                jQuery("#nextModal").modal("hide");
                this.clientService.fnSetLoadingAction(true);
                this.subscribeToSaveClientMarketDef(this.editableClientID, "Save data with back to tiles page");
                this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase));
                this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase));
                //console.log("temp data:" + this.tempDynamicPackMarketBbase.length + " dynamic data length:" + this.dynamicPackMarketBase.length);

                //code for change market base refresh type
                this.temmpMarketDifinitionBaseMap = JSON.parse(JSON.stringify(this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionBaseMaps));
                this.tempClientInfoFinal = JSON.parse(JSON.stringify(this.clientsFiltered));
                this.fnExistingMarketDefinitioneEmit();

            }
        }
    }

    fnModalCloseClick(action: string) {
        if (action == "ProceedStep2WithDataSave") {
            this.btnModalSaveClick("ClearMarketCreateStepFromModal");
            this.fnCreateMarketStep1("Yes");
            jQuery("#nextModal").modal("hide");
            return;
        } else if (action == "Save changes market information") {
            this.isChangeDetectedInMarketSetup = false;
            this.btnModalSaveClick("ClearMarketCreateStepFromModal");
            this.fnCreateMarketStep1("Yes");
            jQuery("#nextModal").modal("hide");
            jQuery("#customModal").modal("hide");
            return;
        }
        else if (action == "BackToMarketBaseWithDataSave") {
            this.btnModalSaveClick("marketDefinitionBackToPreviousState");//to back previous state
            //this.marketCreationStep1 = "block";
            //this.marketCreationStep2 = "none";
            //this.backFromMarketDef = true;
            jQuery("#nextModal").modal("hide");
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "Back to Marekt setup screen after state cancel";
            this.modalTitle = '<span >Changes made to the market definition criteria for pack allocation have not been applied.</span>';
            this.modalCloseBtnCaption = "Ok";
            jQuery("#customModal").modal("show");

        } else if (action == "ProceedStep2WithDataSave from second conformation") {
            jQuery("#customModal").modal('hide');
            this.btnModalSaveClick("ProceedStep2WithDataSave");
        } else if (action == "Back to Marekt setup screen after state cancel") {
            jQuery("#customModal").modal("hide");
            this.marketCreationStep1 = "block";
            this.marketCreationStep2 = "none";
            this.backFromMarketDef = true;
        } else if (action == "back to market tiles page with saving data") {
            jQuery("#nextModal").modal("hide");
            //this.router.navigate(['market/My-Client/' + this.editableClientID]);
            this.fnRelocateMarketTiles();
        } else if (action == "back to tiles after saving market") {
            jQuery("#nextModal").modal("hide");
            this.router.navigate(['market/My-Client/' + this.editableClientID]);
        }
        else {
            jQuery("#nextModal").modal("hide");
            jQuery("#customModal").modal("hide");
        }
    }

    fnNextStepGenerator(nextStep: string): void {
        this.disableControls();
        if (nextStep == "Step2") {
            this.fnCreateMarketStep1("Yes");
            return;
        } else if (nextStep == "Step1") {
            this.marketCreationStep1 = "block";
            this.marketCreationStep2 = "none";
            this.backFromMarketDef = true;
        } else if (nextStep == "backFromMktDef") {
            if (JSON.stringify(this.dynamicPackMarketBase) == JSON.stringify(this.tempDynamicPackMarketBbase)) {
                this.marketCreationStep1 = "block";
                this.marketCreationStep2 = "none";
                this.backFromMarketDef = true;
                return;
            } else {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "BackToMarketBaseWithDataSave";
                this.modalTitle = '<span >Changes have been made to the market definition criteria for Pack allocation, Please save these.</span>';
                this.modalBtnCapton = "Save";
                this.modalCloseBtnCaption = "Cancel";
                jQuery("#nextModal").modal("show");
                return;
            }

        }
    }
    private _clearModal() {
        for (let i = 1; i < 14; i++) {
            jQuery('#v' + i).val('');
        }
    }

    fnAddtoMktDef(): void {
        let selectedStaticObject: any = "";
        jQuery(".checkbox-static-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                selectedStaticObject = selectedStaticObject + jQuery(this).attr("data-sectionvalue") + "|";
            }
        });

        if (selectedStaticObject.length > 0) {
            let selectedStaticObjectArry = selectedStaticObject.split("|");
            //to remove group information
            for (let i = 0; i < Number(selectedStaticObjectArry.length - 1); i++) {
                this.staticPackMarketBase.forEach((rec: any, index: any) => {
                    if (rec.Id == selectedStaticObjectArry[i]) {
                        rec.GroupID = "",
                            rec.GroupName = "",
                            rec.GroupNumber = "",
                            rec.Factor = ""
                    }
                });
            }

            for (let i = 0; i < Number(selectedStaticObjectArry.length - 1); i++) {
                let item = selectedStaticObjectArry[i];
                var selectedStaticInfo = this.staticPackMarketBase.filter((rec: any) => rec.Id == item)[0];
                this.staticPackMarketBase.splice(this.staticPackMarketBase.indexOf(selectedStaticInfo), 1);
                //console.log("select data a:" + JSON.stringify(selectedStaticInfo));
                this.dynamicPackMarketBase.push(selectedStaticInfo);
            }

            //to disable footer button of static table
            this.enabledStaticTableFooterBtns = false;
        } else {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Please select any items from available pack list.";
            this.modalBtnCapton = "Save";
            this.modalCloseBtnCaption = "Close";
            jQuery("#nextModal").modal("show");
            return;
        }

        /******** **********/
        jQuery(".selectAll").each(function () {
            if (jQuery(this).prop("checked") == true) {
                jQuery(this).val = "FALSE";
                jQuery(this).val = "false";
            }

        });
    }

    fnDeleteFromMktDef(): void {
        let selectedDynamicObject: any = "";
        let selectMarketBaseArray: any[] = [];
        let isDynamicType: boolean = false;
        let dynamicPacks = this.dynamicPackMarketBase || []
        let recordID: any;
        jQuery(".checkbox-dynamic-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                selectedDynamicObject = selectedDynamicObject + jQuery(this).attr("data-sectionvalue").trim() + "|";
                recordID = jQuery(this).attr("data-sectionvalue");
                //let marketBaseName = jQuery("#dynamic-table tr.row-" + jQuery(this).attr("data-sectionvalue") + " td.dynamic-market-base").text();                
                let marketBaseName = dynamicPacks.filter((rec: any) => { if (rec.Id == recordID) { return true } else { return false } })[0].MarketBase;
                if (selectMarketBaseArray.indexOf(marketBaseName) < 0) {
                    selectMarketBaseArray.push(marketBaseName);
                }

            }
        });

        if (selectedDynamicObject.length > 0) {
            let selectedDynamicObjectArry = selectedDynamicObject.split("|");
            //to check data resfresh type
            for (let i = 0; i < selectedDynamicObjectArry.length - 1; i++) {
                this.dynamicPackMarketBase.forEach((rec: any, index: any) => {
                    if (rec.Id == selectedDynamicObjectArry[i]) {
                        if (rec.DataRefreshType == "dynamic") {
                            isDynamicType = true;
                        }
                    }
                });
            }

            //end of check
            if (isDynamicType) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "DeleteFromMarketDefinition";
                this.modalCloseBtnCaption = "Cancel";
                //this.modalTitle = selectMarketBaseArray+" will no longer be refreshed dynamically if you remove this pack(s).  Would you like to proceed?" ;
                this.modalTitle = "By deleting the pack/s from the market definition this will result in the market base " + selectMarketBaseArray + " data refresh setting changing from dynamic to static. Any new packs loaded into this market base will not automatically insert into the market definition. Would you like to proceed?";
                this.modalBtnCapton = "Yes";
                jQuery("#nextModal").modal("show");
                return;
            } else {
                //to remove group from selected data
                for (let i = 0; i < Number(selectedDynamicObjectArry.length - 1); i++) {
                    this.dynamicPackMarketBase.forEach((rec: any, index: any) => {
                        if (rec.Id == Number(selectedDynamicObjectArry[i])) {
                            rec.GroupID = "",
                                rec.GroupNumber = "",
                                rec.GroupName = "",
                                rec.Factor = ""
                            return;
                        }
                    });
                }



                //to shift dynamic to static           
                for (let i = 0; i < Number(selectedDynamicObjectArry.length - 1); i++) {
                    let item = selectedDynamicObjectArry[i];
                    var selectedDynamicInfo = this.dynamicPackMarketBase.filter((rec: any) => rec.Id == item)[0];
                    this.dynamicPackMarketBase.splice(this.dynamicPackMarketBase.indexOf(selectedDynamicInfo), 1);//remove form dynamic
                    this.staticPackMarketBase.push(selectedDynamicInfo);//push in static
                }

                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Packs move to Available Pack List from Market Definition Content.";
                this.modalBtnCapton = "Save";
                this.modalCloseBtnCaption = "OK";
                jQuery("#nextModal").modal("show");

                //to disable footer btns of dynamic table
                this.enabledDynamicTableFooterBtns = false;
            }


        } else {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Please select item(s) to remove from market definition list.";
            this.modalBtnCapton = "Save";
            jQuery("#nextModal").modal("show");
            return;
        }
    }

    async fnAddOrEditGroupInfo() {
        let selectedPackName: string = "";
        let selectedPackIDMakeGroup: string = "";
        let checkedItemHasNoGroup: boolean = false;
        let checkedItemHasNAGroup: boolean = false;
        let checkedItemHasGroup: boolean = false;
        this.dropdownGroupValues = this.dropdownGroupValues;
        this.enabledGroupDetails = true;
        this.operationOnNaGroup = false;
        this.isNAGroupMessageShow = false;
        this.factorOrGroupGenericErrorMgs = "";
        this.groupIdErrorMgs = "";
        this.groupNameErrorMgs = "";
        this.fnBindDDForGroup();
        let selectedGroup = "", selectedGroupID = "", selectedFactorVal = "";
        let selectedNAGroup = "", selectedNAGroupID = "", selectedNAFactorVal = "";
        let dynamicPacks = this.dynamicPackMarketBase;
        jQuery("#selectedPackInfo").html("");// to clear previous data
        jQuery("#txtFactorValue").val("");
        jQuery("#txtGroupName").val("");
        jQuery("#txtGroupID").val("");
        jQuery(".groupNameError").html("");
        //to mgs when group name is blank
        jQuery("#txtGroupName").bind("keyup", function () {
            if (jQuery(this).val() != "") {
                jQuery(".groupNameError").html("");
            }
        });

        //read record from table 
        jQuery("#dynamic-table tbody tr .checkbox-dynamic-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                let recordID = jQuery(this).attr("data-sectionvalue");
                selectedPackIDMakeGroup = selectedPackIDMakeGroup + recordID + "|";
                // selectedPackName = selectedPackName + jQuery("#dynamic-table tbody tr.row-" + recordID + " td.dynamic-pack-name").html() + "; ";
                // let selectedGroupName = jQuery("#dynamic-table tbody tr.row-" + recordID + " td.dynamic-group-name").html();
                // let selectedGroupFactorValue = jQuery("#dynamic-table tbody tr.row-" + recordID + " td.dynamic-factor").html();

                let selectedRecord = dynamicPacks.filter((rec: any) => { if (rec.Id == recordID) { return true } else { return false } })[0];
                selectedPackName = selectedPackName + selectedRecord.Pack + "; ";
                let selectedGroupName = selectedRecord.GroupName;
                let selectedGroupFactorValue = selectedRecord.Factor;

                //console.log(selectedRecord);
                if ((selectedGroupName == "" || selectedGroupName == " " || selectedGroupName == null) && (selectedGroupFactorValue == " " || selectedGroupFactorValue == "" || selectedGroupFactorValue == null)) {
                    checkedItemHasNoGroup = true;
                } else if ((selectedGroupName == "" || selectedGroupName == " " || selectedGroupName == null) && (selectedGroupFactorValue != " " && selectedGroupFactorValue != null)) {//for N/A group
                    checkedItemHasNAGroup = true;
                    selectedNAGroup = selectedGroupName;
                    selectedNAGroupID = selectedRecord.GroupNumber;
                    selectedNAFactorVal = selectedGroupFactorValue;
                } else {
                    checkedItemHasGroup = true;
                    selectedGroup = selectedGroupName;
                    selectedGroupID = selectedRecord.GroupNumber;
                    selectedFactorVal = selectedGroupFactorValue;
                }

            }
        });

        if (selectedPackIDMakeGroup.length > 0) {
            if (checkedItemHasGroup && checkedItemHasNoGroup) {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = '<span >Selected item(s) already assigned in group. Please select item(s) either assigned in group or not.</span>';
                this.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
                return;
            } else {
                jQuery("#selectedPackInfo").html(Number(selectedPackIDMakeGroup.split("|").length) - 1 + " item(s) Selected <span id='details-pack'></span> <a id='details'>Details</a>");
                //jQuery("#selectedPackInfo").html(Number(selectedPackIDMakeGroup.split("|").length) - 1 + " item(s) Selected (" + selectedPackName + " )");
                jQuery("#grouping").modal("show");
                this.selectedPackIDForGroup = selectedPackIDMakeGroup;
                if (checkedItemHasGroup) {
                    jQuery("button.dropdown-toggle").html("" + selectedGroupID + "-" + selectedGroup + " <span class='caret'></span>");//default selection new
                    jQuery("#txtGroupName").val(selectedGroup);
                    jQuery("#txtGroupID").val(selectedGroupID)//to show Group ID
                    jQuery("#txtFactorValue").val(selectedFactorVal)//to show factor
                    this.saveBtnEnabledForGroupId = true;
                    this.saveBtnEnabledForGroupName = true;
                } else if (checkedItemHasNAGroup) {
                    jQuery("button.dropdown-toggle").html("N/A <span class='caret'></span>");//default selection new
                    jQuery("#txtGroupName").val("");
                    jQuery("#txtGroupID").val("")//to show Group ID
                    jQuery("#txtFactorValue").val(selectedNAFactorVal)//to show factor
                    this.enabledGroupDetails = false;
                    this.operationOnNaGroup = true;
                    this.saveBtnEnabledForGroupId = true;
                    this.saveBtnEnabledForGroupName = true;
                } else {
                    let nextGroupNumber = -1;
                    await this.dynamicPackMarketBase.forEach(function (part, index) {//to change existing group id
                        if (part.GroupNumber != "" && Number(part.GroupNumber || 0) >= nextGroupNumber) {
                            nextGroupNumber = Number(part.GroupNumber) + 1;
                        }
                    });
                    jQuery("#txtGroupID").val((nextGroupNumber < 1) ? 1 : nextGroupNumber);//to show Group ID
                    this.saveBtnEnabledForGroupId = true;
                    this.saveBtnEnabledForGroupName = false;
                }
            }

            jQuery("#details").bind("click", function () {
                let detailsVal = jQuery("#details-pack").html();
                if (detailsVal == "") {
                    jQuery("#details-pack").html(" (" + selectedPackName + ")");
                    jQuery("#details").html("Less");
                } else {
                    jQuery("#details-pack").html("");
                    jQuery("#details").html("Details");
                }

            })
        } else {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = '<span >Please select any item(s) to add or edit in group.</span>';
            this.modalBtnCapton = "Save";
            this.modalCloseBtnCaption = "Close";
            jQuery("#nextModal").modal("show");
            return;
        }

    }

    fnPackGroupCreation(): void {
        this.clientService.fnSetLoadingAction(true);
        let groupName = jQuery("#txtGroupName").val();
        let factor = jQuery("#txtFactorValue").val();
        let GroupID: any = jQuery("#txtGroupID").val();
        this.factorOrGroupGenericErrorMgs = "";

        // read dropdown selected value;
        let group = jQuery("button.dropdown-toggle").text().trim();
        if (group.indexOf("-")) {
            group = group.split("-")[0].trim();
        }
        if (group != "N/A") {
            if (GroupID == "" || GroupID == " ") {  //to check empty group id.          
                this.factorOrGroupGenericErrorMgs = "Group ID is required to proceed this action.";
                jQuery("#txtGroupID").focus();
                this.clientService.fnSetLoadingAction(false);
                return;
            }

            if (groupName == "") { //to check empty group Name           
                this.factorOrGroupGenericErrorMgs = "Group name is required to proceed this action.";
                jQuery("#txtGroupName").focus();
                this.clientService.fnSetLoadingAction(false);
                return;
            }
        }


        ////check numeric for factor
        if (isNaN(GroupID)) {
            this.factorOrGroupGenericErrorMgs = "Only numeric values are allowed for Group #. Please review.";
            jQuery("#txtGroupID").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        }
        //validation for group name 
        if (groupName.length >= 26) {
            this.factorOrGroupGenericErrorMgs = "only 25 characters allowed.";
            jQuery("#txtGroupName").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        }
        /*
         if (groupName.match(/^[-/+()&/,\w\s]*$/) == null) {
           this.factorOrGroupGenericErrorMgs ="only alphanumeric with +, -, _,&,/, (, ) special characters allowed.";
        */
        if (groupName.match(/^[-/+()&/,\w\s]*$/) == null) {
            this.factorOrGroupGenericErrorMgs = "only alphanumeric with +, -, _, (, ) special characters allowed.";
            jQuery("#txtGroupName").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        }

        ////check numeric for factor
        if (isNaN(factor)) {
            this.factorOrGroupGenericErrorMgs = "Only numeric values are allowed for a factor. Please review.";
            jQuery("#txtFactorValue").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        }


        let selectedPackIDForGroupArry = this.selectedPackIDForGroup.split("|");
        //assing group number for new
        if (group == "New") {
            group = this.newGroupID;
            for (let i = 0; i < selectedPackIDForGroupArry.length - 1; i++) {
                this.dynamicPackMarketBase.forEach(function (part, index) {
                    if (part.Id == Number(selectedPackIDForGroupArry[i])) {
                        part.GroupName = groupName;
                        part.GroupNumber = GroupID;
                        part.Factor = factor;
                    }
                });
            }
        } else if (group == "N/A") {
            for (let i = 0; i < selectedPackIDForGroupArry.length - 1; i++) {
                this.dynamicPackMarketBase.forEach(function (part, index) {
                    if (part.Id == Number(selectedPackIDForGroupArry[i])) {
                        part.Factor = factor;
                        part.GroupNumber = "",
                            part.GroupName = "";
                    }
                });
            }
        }
        else {
            this.dynamicPackMarketBase.forEach(function (part, index) {//to change existing group id
                if (part.GroupNumber == group) {
                    part.GroupNumber = GroupID,
                        part.GroupName = groupName;
                    part.Factor = factor;
                }
            });

            for (let i = 0; i < selectedPackIDForGroupArry.length - 1; i++) {//to assing into new ID
                this.dynamicPackMarketBase.forEach(function (part, index) {
                    if (part.Id == Number(selectedPackIDForGroupArry[i])) {
                        part.GroupName = groupName;
                        part.GroupNumber = GroupID;
                        part.Factor = factor;
                    }
                });
            }

        }

        jQuery("#dynamic-table .checkbox-dynamic-table").prop("checked", false);
        jQuery("#dynamic-table .select-all-dynamic-table").prop("checked", false);
        //to disable footer btns of dynamic table
        this.enabledDynamicTableFooterBtns = false;
        this.isChangeDetectedInMarketDefinition = true;
        this.authService.hasUnSavedChanges = true
        jQuery("#grouping").modal("hide");
        this.clientService.fnSetLoadingAction(false);
    }

    fnPackGroupRemove(): void {
        this.clientService.fnSetLoadingAction(true);
        let selectedPackName: string = "";
        //let selectedPackIDRemoveGroup: string = "";
        let selectedPackIDRemoveGroup: any[] = [];
        let selectedItemsGroupName: string = "";
        let checkSelectedIsGroup: any = true;
        this.selectedGroupID = [];
        let dynamicPacks = this.dynamicPackMarketBase;
        jQuery("#dynamic-table tbody tr .checkbox-dynamic-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                let recordID = jQuery(this).attr("data-sectionvalue");
                //console.log("checked" + recordID);
                selectedPackIDRemoveGroup.push(recordID);
                //let selectedGroupName = jQuery("#dynamic-table tbody tr.row-" + recordID + " td.dynamic-group-name").html();


                let selectedRecord = dynamicPacks.filter((rec: any) => { if (rec.Id == recordID) { return true } else { return false } })[0];
                let selectedGroupName = selectedRecord.GroupName;
                let selectedGroupFactorValue = selectedRecord.Factor;

                selectedItemsGroupName = selectedItemsGroupName + selectedGroupName + "|";
                if (selectedGroupName == "" || selectedGroupName == " ") {
                    checkSelectedIsGroup = false;
                }
            }
        });

        if (selectedPackIDRemoveGroup.length > 0) {
            if (checkSelectedIsGroup == true) {
                this.selectedGroupID = selectedPackIDRemoveGroup;
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "RemoveGropInformation";
                this.modalTitle = "Group information of selected pack(s) will be removed. Please confirm!";
                this.modalBtnCapton = "OK";
                this.modalCloseBtnCaption = "Cancel";
                jQuery("#nextModal").modal("show");
                this.clientService.fnSetLoadingAction(false);
                return;
            } else {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Your selected Item(s) has no group. Please confirm that your selected item(s) has group.";
                this.modalBtnCapton = "Save";
                this.modalCloseBtnCaption = "OK";
                jQuery("#nextModal").modal("show");
                this.clientService.fnSetLoadingAction(false);
                return;
            }

        } else {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Please select item(s) to remove from group.";
            this.modalBtnCapton = "Save";
            this.modalCloseBtnCaption = "Close";
            jQuery("#nextModal").modal("show");
            this.clientService.fnSetLoadingAction(false);
            return;
        }
    }


    fnCheckboxDynamicTableClick(event: any) {
        if (jQuery(".checkbox-dynamic-table:checked").length > 0) {
            this.enabledDynamicTableFooterBtns = true;
        } else {
            this.enabledDynamicTableFooterBtns = false;
        }
    }
    fnDynamicTablePageChange(event: any) {
        this.enabledDynamicTableFooterBtns = false;
    }
    fnStaticTablePageChange(event: any) {
        this.enabledStaticTableFooterBtns = false;
    }
    fnCheckboxStaticTableClick(event: any) {
        if (jQuery(".checkbox-static-table:checked").length > 0) {
            this.enabledStaticTableFooterBtns = true;
        } else {
            this.enabledStaticTableFooterBtns = false;
        }
    }

    async actionOnDDChange(arg: any) {
        let selectedGroup = arg.value;
        let selectedGroupName = arg.groupName;
        let selectedGroupNumber = arg.value;
        let selectedGroupFactor = arg.factor;
        this.factorOrGroupGenericErrorMgs = "";
        this.groupIdErrorMgs = "";
        this.groupNameErrorMgs = "";
        this.saveBtnEnabledForGroupId = false;
        this.saveBtnEnabledForGroupName = false;
        let selectedGroupArray = this.dynamicPackMarketBase.filter((rec: any) => rec.GroupNumber == Number(selectedGroup));
        jQuery(".groupNameError ").html("");//to clear the message 
        this.isNAGroupMessageShow = false;
        if (selectedGroupNumber == "New") {
            let nextGroupNumber = -1
            //selectedGroupNumber = "";
            selectedGroupName = "";
            this.enabledGroupDetails = true;
            if (this.operationOnNaGroup) {
                this.isNAGroupMessageShow = true;
            }

            //to find out unique number 
            await this.dynamicPackMarketBase.forEach(function (part, index) {//to change existing group id
                if (part.GroupNumber != "" && Number(part.GroupNumber || 0) >= nextGroupNumber) {
                    nextGroupNumber = Number(part.GroupNumber) + 1;
                }
            });
            selectedGroupNumber = (nextGroupNumber < 1) ? 1 : nextGroupNumber;//to show Group ID
            this.saveBtnEnabledForGroupId = true;
        } else if (selectedGroupNumber == "N/A") {
            this.enabledGroupDetails = false;
            selectedGroupNumber = "";
            selectedGroupName = "";
            this.isNAGroupMessageShow = false;
            this.saveBtnEnabledForGroupId = true;
            this.saveBtnEnabledForGroupName = true;

        } else {
            this.enabledGroupDetails = true;
            if (this.operationOnNaGroup) {
                this.isNAGroupMessageShow = true;
            }

            this.saveBtnEnabledForGroupId = true;
            this.saveBtnEnabledForGroupName = true;
        }

        jQuery("#txtGroupName").val(selectedGroupName);
        jQuery("#txtGroupID").val(selectedGroupNumber)//to show Group ID
        jQuery("#txtFactorValue").val(selectedGroupFactor)//to show factor
        jQuery("#appendContent").remove();

        if (selectedGroup != "New") {
            jQuery("#selectedPackInfo").append('<div id="appendContent"><span>Your selected group has ' + selectedGroupArray.length + ' item(s)</span></div>');
        } else {
        }

        let selectedItemCount = jQuery("#selectedPackInfo").html().split(" ")[0] | 0;
        //jQuery("#txtFactorValue").val(Number(100 / (Number(selectedItemCount + selectedGroupArray.length))).toFixed(2));


    }

    fnBindDDForGroup(): void {
        this.dropdownGroupValues = [];
        let ddGroup: any = [];
        let sortedDDGroup: any = [];
        let maxGroupNumber = 999;
        let finalDDList: any[] = [];
        this.factorOrGroupGenericErrorMgs = "";
        this.dynamicPackMarketBase.forEach(function (part, index) {
            if (part.GroupName != "" && part.GroupName != null) {
                ddGroup.push({ groupName: part.GroupName, value: '' + part.GroupNumber + '', label: part.GroupNumber + " - " + part.GroupName, factor: part.Factor });
            }
        });

        //code for unique
        let flag: any[] = [];
        for (var i = 0; i < ddGroup.length; i++) {
            if (!flag[ddGroup[i].value]) {
                flag[ddGroup[i].value] = true;
                finalDDList.push(ddGroup[i]);
            }
        }
        finalDDList.unshift({ groupName: "N/A", value: "N/A", label: 'N/A' });
        finalDDList.unshift({ groupName: "New", value: "New", label: 'New' });
        this.dropdownGroupValues = finalDDList;
        //this.newGroupID = Number(maxGroupNumber) + 1;
        jQuery("button.dropdown-toggle").html("New <span class='caret'></span>");//default selection new        

    }

    fnChangeFactoringModel(type: string, value: string) {
        let existingGroupID = "";
        let existingGroupName = "";

        let group = jQuery("button.dropdown-toggle").text().trim();
        //let newGroupID = jQuery(this).val();
        let newGroupValue: any = value;
        if (group.indexOf("-") > 0) {
            existingGroupID = group.split("-")[0].trim();
            existingGroupName = group.split("-")[1].trim();
        }
        if (type == "GroupID") {
            this.saveBtnEnabledForGroupId = true;
            this.groupIdErrorMgs = "";
            if (newGroupValue == "") {//disabled for empty value
                this.saveBtnEnabledForGroupId = false;
                return;
            } else if (isNaN(newGroupValue)) {//to check numeric
                this.groupIdErrorMgs = "Only numeric values are allowed for Group #. Please review.";
                this.saveBtnEnabledForGroupId = false;
                return;
            }
            //to check with existing ID
            if (group != 'New') {
                this.dropdownGroupValues.every((rec: any, index: any) => {
                    if (rec.value == newGroupValue && rec.value != existingGroupID) {
                        this.groupIdErrorMgs = "This group id is already applied to an existing group. Please select the next available ID or select an existing group.";
                        this.saveBtnEnabledForGroupId = false;
                        return false;
                    } else {
                        return true;
                    }
                });
            } else {
                this.dropdownGroupValues.every((rec: any, index: any) => {
                    if (rec.value == newGroupValue) {
                        this.groupIdErrorMgs = "This group id is already applied to an existing group. Please select the next available ID or select an existing group.";
                        this.saveBtnEnabledForGroupId = false;
                        return false;
                    } else {
                        jQuery(".groupNameError ").html("");
                        return true;
                    }
                });
            }
        } else if (type == "GroupName") {
            this.saveBtnEnabledForGroupName = true;
            if (newGroupValue == "") {//disabled button for empty value
                this.saveBtnEnabledForGroupName = false;
            }
            this.groupNameErrorMgs = "";
            if (group != 'New') {
                this.dropdownGroupValues.every((rec: any, index: any) => {
                    if (rec.groupName.trim() == newGroupValue.trim() && rec.groupName != existingGroupName) {
                        this.groupNameErrorMgs = "This group name is already applied to an existing group. Please select the next available Name or select an existing group.";
                        this.saveBtnEnabledForGroupName = false;
                        return false;
                    } else {
                        return true;
                    }
                });
            } else {
                this.dropdownGroupValues.every((rec: any, index: any) => {
                    if (rec.groupName == newGroupValue) {
                        this.groupNameErrorMgs = "This group name is already applied to an existing group. Please select the next available Name or select an existing group.";
                        this.saveBtnEnabledForGroupName = false;
                        return false;
                    } else {
                        jQuery(".groupNameError ").html("");
                        return true;
                    }
                });
            }
        }


    }


    fnSaveMarketDef() {
        if (this.dynamicPackMarketBase.length > 0) {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "SaveClientMarketDef";
            this.modalCloseBtnCaption = "Cancel";
            this.modalTitle = "<span >Changes made to the market definition criteria for pack allocation. Would you like to save?</span>";
            //this.modalBtnCapton = "Yes";
            this.modalBtnCapton = "Ok";
            jQuery("#nextModal").modal("show");
        } else {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalCloseBtnCaption = "Ok";
            this.modalTitle = "<span >There are no packs available in the market definition content. Please review.</span>";
            this.modalBtnCapton = "Yes";
            jQuery("#nextModal").modal("show");
        }
    }

    private subscribeToSaveClientMarketDef(ClientId: number, type: string = "") {
        //console.log('inside process client: ');
        if (this.guID != "" && this.guIDPresent == true) {
            //update         
            this.subscribeToEditClientMarketDef(this.editableClientID, this.editableMarketDefID);
        } else {
            //final array set to save dynamic and static info
            let finalDynamicStaticArray: any[] = [];
            this.dynamicPackMarketBase.forEach(function (part, index) {
                part.Alignment = "dynamic-right";
            });
            this.staticPackMarketBase.forEach(function (part, index) {
                part.Alignment = "static-left";
            });
            finalDynamicStaticArray = this.dynamicPackMarketBase.concat(this.staticPackMarketBase);
            //console.log("finalDynamicStaticArray" + JSON.stringify(finalDynamicStaticArray));
            this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionPacks = finalDynamicStaticArray;

            this.clientService.postClientMarketDef(JSON.stringify(this.clientsFiltered), ClientId).subscribe(
                (data) => {
                    this.clientService.fnSetLoadingAction(false);
                    this.isChangeDetectedInMarketDefinition = false;
                    this.isChangeDetectedInMarketSetup = false;
                    this.authService.hasUnSavedChanges = true;
                    this.marketDefsFiltered = data;
                    this.guID = this.marketDefsFiltered.GuiId;
                    this.editableMarketDefID = this.marketDefsFiltered.Id;
                    this.guIDPresent = true;
                    this.router.navigate(['marketCreate/' + this.editableClientID + '|' + this.editableMarketDefID + '/Edit Lock']);
                    if (type == "Save data with back to tiles page") {
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "back to tiles after saving market";
                        this.modalCloseBtnCaption = "OK";
                        this.modalTitle = "<span >Market definition content saved successfully.</span>";
                        this.modalBtnCapton = "";
                        jQuery("#nextModal").modal("show");
                    } else {
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalCloseBtnCaption = "OK";
                        this.modalTitle = "<span >Market definition content saved successfully.</span>";
                        this.modalBtnCapton = "";
                        jQuery("#nextModal").modal("show");
                    }

                },

                (err: any) => {
                    this.clientService.fnSetLoadingAction(false);
                    //this.mmErrModal.show();
                    if (err.status == 0) {
                        this.alertService.alert("System has failed to connect with server due to network problem.");
                    } else {
                        this.alertService.alert(err.json().Message);
                    }
                    console.log(err);
                },
                () => console.log("final Client list: " + JSON.stringify(this.clientsFiltered))
            );
            //console.log("find gui ID"+JSON.stringify(this.dynamicPackMarketBase));
        }

    }

    private subscribeToEditClientMarketDef(ClientId: number, MarketDefId: number, type: string = "") {
        //final array set to save dynamic and static info
        let finalDynamicStaticArray: any[] = [];
        this.dynamicPackMarketBase.forEach(function (part, index) {
            part.Alignment = "dynamic-right";
        });
        this.staticPackMarketBase.forEach(function (part, index) {
            part.Alignment = "static-left";
        });
        finalDynamicStaticArray = this.dynamicPackMarketBase.concat(this.staticPackMarketBase);
        this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionPacks = finalDynamicStaticArray;
        this.clientService.editClientMarketDef(JSON.stringify(this.clientsFiltered), ClientId, MarketDefId).subscribe(
            data => {
                this.clientService.fnSetLoadingAction(false);//to stop waiting..
                this.isChangeDetectedInMarketDefinition = false;
                this.isChangeDetectedInMarketSetup = false;
                this.authService.hasUnSavedChanges = true;
                this.marketDefsFiltered = data;
                this.guID = this.marketDefsFiltered.GuiId;
                this.editableMarketDefID = this.marketDefsFiltered.Id;
                this.guIDPresent = true;
                if (type == "Save data with back to tiles page") {
                    this.router.navigate(['marketCreate/' + this.editableClientID + '|' + this.editableMarketDefID + '/Edit Lock']);
                    this.modalSaveBtnVisibility = false;
                    this.modalSaveFnParameter = "back to tiles after saving market";
                    this.modalCloseBtnCaption = "OK";
                    this.modalTitle = "<span >Market definition content saved successfully.</span>";
                    this.modalBtnCapton = "";
                    jQuery("#nextModal").modal("show");

                } else {
                    this.modalSaveBtnVisibility = false;
                    this.modalSaveFnParameter = "";
                    this.modalCloseBtnCaption = "OK";
                    this.modalTitle = "<span >Market definition content saved successfully.</span>";
                    this.modalBtnCapton = "";
                    jQuery("#nextModal").modal("show");
                    this.router.navigate(['marketCreate/' + this.editableClientID + '|' + this.editableMarketDefID + '/Edit Lock']);
                }

            },
            //saved alert here             
            (err: any) => {
                this.clientService.fnSetLoadingAction(false);
                //this.mmErrModal.show();
                if (err.status == 0) {
                    this.alertService.alert("System has failed to connect with server due to network problem.");
                } else {
                    this.alertService.alert(err.json().Message);
                }
                console.log(err);
            },
            () => console.log("edited client list: " + JSON.stringify(this.clientsFiltered))
        );

        // this.route.navigate["/market"];
        //this.router.navigate(['About']); // here "About" is name not path
    }

    public fnExistingMarketDefinitioneEmit() {
        //console.log("Temp Market Base:" + JSON.stringify(this.temmpMarketDifinitionBaseMap));
        if (this.temmpMarketDifinitionBaseMap.length > 0) {
            for (let i = 0; i < this.temmpMarketDifinitionBaseMap.length; i++) {
                let marketBase = this.temmpMarketDifinitionBaseMap[i]["MarketBase"];
                let marketBaseName: string = this.temmpMarketDifinitionBaseMap[i]["Name"];
                let dataRefreshType = this.temmpMarketDifinitionBaseMap[i]["DataRefreshType"];
                let marketDefinitionId = this.temmpMarketDifinitionBaseMap[i]["MarketDefinitionId"];
                let filters = this.temmpMarketDifinitionBaseMap[i]["Filters"];

                jQuery(".filTable tbody tr").each(function () {
                    var recordID = jQuery(this).attr("class").split("-")[1];
                    let packName: string = jQuery(this).attr("title");
                    if (packName.trim().toString() == marketBaseName.trim().toString()) {
                        jQuery("#chkbox_" + recordID).prop("checked", true);
                        jQuery('#col2_' + recordID).removeClass('userRefreshHidden').addClass('userRefreshVisible');
                        //jQuery("#" + dataRefreshType + -+recordID).prop("checked", true);
                        jQuery("#" + dataRefreshType + "-" + recordID).prop("checked", true);
                        jQuery('#icon_' + recordID).removeClass('disab').addClass('purpLink');
                        //jQuery('#col3_' + recordID).html("");
                        jQuery('#col3_' + recordID + " div.nodeEqual").remove();
                        let filterCounter = 0;
                        let excludeIncludeOperator = '=';
                        if (filters.length > 0) {
                            jQuery('#col3_' + recordID).removeClass('userRefreshHidden').addClass('userRefreshVisible');//icon_2
                            for (let f = 0; f < filters.length; f++) {
                                filterCounter = filterCounter + 1;
                                let filterCriteria = filters[f].Criteria;
                                let filterValues = filters[f].Values;
                                if (filters[f].IsEnabled) {//to exclude include
                                    excludeIncludeOperator = '=';
                                } else {
                                    excludeIncludeOperator = '≠';
                                }

                                if (filterCounter > 2) {
                                    jQuery('#col3_' + recordID).append('<div class="nodeEqual filter-hidden">' + filterCriteria + excludeIncludeOperator + '<strong>' + filterValues + '</strong>' + '</div>');
                                } else {
                                    jQuery('#col3_' + recordID).append('<div class="nodeEqual">' + filterCriteria + excludeIncludeOperator + '<strong>' + filterValues + '</strong>' + '</div>');
                                }
                            }
                        }

                        if (filterCounter > 2) {
                            jQuery('#more-' + recordID).css("display", "inline");
                            jQuery('#col3_' + recordID).append(jQuery('#more-' + recordID));
                            jQuery('#col3_' + recordID).append('<div class="clearAll">');
                        } else {
                            jQuery('#more-' + recordID).css("display", "none");
                            jQuery('#col3_' + recordID).append('<div class="clearAll">');
                        }
                        //this.disableControls();
                        return;
                    }

                });
            }
        } else if (this.isEditMarketDef) {
            let marketDefinitionPackName = this.existingMarketDifinition["Name"];
            this.newsTitle = marketDefinitionPackName;
            this.tempMarketDefName = marketDefinitionPackName;
            for (let i = 0; i < this.existingMarketDifinition["MarketDefinitionBaseMaps"].length; i++) {
                //console.log("base map :"+ JSON.stringify(this.existingMarketDifinition["MarketDefinitionBaseMaps"][i]));
                let marketBase = this.existingMarketDifinition["MarketDefinitionBaseMaps"][i]["MarketBase"];
                //console.log("marketBase:"+JSON.stringify(marketBase));
                let marketBaseName: string = this.existingMarketDifinition["MarketDefinitionBaseMaps"][i]["Name"];
                let dataRefreshType = this.existingMarketDifinition["MarketDefinitionBaseMaps"][i]["DataRefreshType"];
                let marketDefinitionId = this.existingMarketDifinition["MarketDefinitionBaseMaps"][i]["MarketDefinitionId"];
                let filters = this.existingMarketDifinition["MarketDefinitionBaseMaps"][i]["Filters"];
                //console.log("Refresh marketBaseName: "+marketBaseName+":dataRefreshType:"+dataRefreshType)

                jQuery(".filTable tbody tr").each(function () {
                    var recordID = jQuery(this).attr("class").split("-")[1];
                    let packName: string = jQuery(this).attr("title") || "";
                    //console.log("packname:"+packName+": marketbaseName:"+marketBaseName+": recordID"+recordID);
                    if (packName.trim().toString() == marketBaseName.trim().toString()) {
                        //console.log("matched --- packName :"+packName+": marketBaseName :"+marketBaseName+": M V:"+recordID);

                        //console.log("packname:"+packName+": marketbaseName:"+marketBaseName+": recordID"+recordID);
                        jQuery("#chkbox_" + recordID).prop("checked", true);
                        jQuery('#col2_' + recordID).removeClass('userRefreshHidden').addClass('userRefreshVisible');
                        //jQuery("#" + dataRefreshType + -+recordID).prop("checked", true);
                        jQuery("#" + dataRefreshType + "-" + recordID).prop("checked", true);
                        jQuery('#icon_' + recordID).removeClass('disab').addClass('purpLink');
                        jQuery('#mbtext_' + recordID).removeClass('textWeightNormal').addClass('textWeightBold');
                        //jQuery('#col3_' + recordID).html("");
                        jQuery('#col3_' + recordID + " div.nodeEqual").remove();
                        let filterCounter = 0;
                        let excludeIncludeOperator = "=";
                        if (filters.length > 0) {
                            jQuery('#col3_' + recordID).removeClass('userRefreshHidden').addClass('userRefreshVisible');//icon_2

                            for (let f = 0; f < filters.length; f++) {
                                filterCounter = filterCounter + 1;
                                let filterCriteria = filters[f].Criteria;
                                let filterValues = filters[f].Values;
                                if (filters[f].IsEnabled) {//to exclude include
                                    excludeIncludeOperator = '=';
                                } else {
                                    excludeIncludeOperator = '≠';
                                }
                                if (filterCounter > 2) {
                                    jQuery('#col3_' + recordID).append('<div class="nodeEqual filter-hidden">' + filterCriteria + excludeIncludeOperator + '<strong>' + filterValues + '</strong>' + '</div>');
                                } else {
                                    jQuery('#col3_' + recordID).append('<div class="nodeEqual">' + filterCriteria + excludeIncludeOperator + '<strong>' + filterValues + '</strong>' + '</div>');
                                }

                            }
                        }

                        if (filterCounter > 2) {
                            jQuery('#more-' + recordID).css("display", "inline");
                            jQuery('#col3_' + recordID).append(jQuery('#more-' + recordID));
                            jQuery('#col3_' + recordID).append('<div class="clearAll">');
                        } else {
                            jQuery('#more-' + recordID).css("display", "none");
                            jQuery('#col3_' + recordID).append('<div class="clearAll">');
                        }

                        return;
                    }

                });
            }
        }

        //to stored temp values
        this.fnGererateTempMarketBaseDuringEdit();
    }

    disableControls() {
        if (this.canFilter != true) {
            jQuery("div.packSearchModalPanel  input[type='text']").attr("disabled", true);
            jQuery("div.packSearchModalPanel  input[type='checkbox']").attr("disabled", true);
            jQuery('div.packSearchModalPanel select.dropdown').attr('disabled', true);
            jQuery('table#static-table input[type=checkbox]').attr('disabled', true);
            jQuery('table#dynamic-table input[type=checkbox]').attr('disabled', true);
            jQuery('#p-table-footer input[type=checkbox]').attr('disabled', true);
            jQuery("#v11").attr("disabled", true);
            jQuery("#v12").attr("disabled", true);
            jQuery(".p-table-footer a").bind("click", function () {
                jQuery('table#dynamic-table input[type=checkbox]').attr('disabled', 'true');
                jQuery('table#static-table input[type=checkbox]').attr('disabled', 'true');
            });
            //jQuery(".p-table-footer a").bind("click", function () {
            //    jQuery('table#static-table input[type=checkbox]').attr('disabled', 'true');
            //});
            //jQuery("#checkbox-dynamic-table").attr('disabled', 'true');
            //jQuery('table input[type=checkbox]').attr('disabled', 'true');
            //jQuery("#dynamic-table").parent().parent().find('input:checkbox').attr('disabled', true);
            //jQuery("#dynamic-table").closest("table").find('tbody input[type=checkbox]').attr('disabled', true);
        }
        else {
            jQuery("div.packSearchModalPanel  input[type='text']").attr("disabled", false);
            jQuery("div.packSearchModalPanel  input[type='checkbox']").attr("disabled", false);
            jQuery('div.packSearchModalPanel select.dropdown').attr('disabled', false);
            jQuery('table#static-table input[type=checkbox]').attr('disabled', false);
            jQuery('table#dynamic-table input[type=checkbox]').attr('disabled', false);
            jQuery('#p-table-footer input[type=checkbox]').attr('disabled', false);
        }
    }

    //performSearch(form: any) {
    //    //console.log('Event Value' + JSON.stringify(form) + 'Current Page'+ this.currentPage)
    //    //console.log('search' + this.model.searchString);
    //    this.packDescCount = 1;
    //    this.currentPage = 1;
    //    if (this.model.searchOptions != undefined && this.model.searchOptions != '' && this.model.searchString != undefined && this.model.searchString.length > 0) {
    //        this.clientService.fnSetLoadingAction(true);
    //        this.mktPackSeachService
    //            .getSearchResult(this.model.searchOptions, this.model.searchString, this.editableClientID)
    //            .subscribe(
    //            p => { this.packDescription = p, console.log('this.packDescription'), this.clientService.fnSetLoadingAction(false) },
    //            e => { this.errorMessage = e, this.clientService.fnSetLoadingAction(false) },
    //            () => (this.isLoading = false, this.totalItems = this.packDescription.length, this.packDescCount = this.packDescription.length,
    //                this.pageChanged({ page: this.currentPage, itemsPerPage: this.itemsPerPage })));
    //    }
    //    else {
    //        this.packDescription = [];
    //        this.packDescriptionByPage = [];
    //        this.packDescCount = 0;
    //    }
    //    //console.log("pack- " + this.packDescription);
    //    //this.totalItems = this.packDescription.length;
    //}

    Close() {
        this.model.searchString = "";
        this.model.searchOptions = "";
        this.packDescription = [];
        this.packDescriptionByPage = [];
        this.packDescCount = 1;
        // console.log('close click is working');
    }

    packDescriptionByPage: PackDescSearch[] = [];

    // Start Pagination 
    public totalItems: number = this.packDescription.length;
    public currentPage: number = 1;
    public itemsPerPage: number = 5;

    public setPage(pageNo: number): void {
        this.currentPage = pageNo;
    }

    public pageChanged(event: any): void {
        // console.log('Page changed to: ' + event.page);
        // console.log('Number items per page: ' + event.itemsPerPage);

        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.packDescriptionByPage = this.packDescription.slice(startIndex, endIndex)

    }

    public fnBacktoPreviousState() {
        //for empty market base
        if (this.fnGererateTempMarketBaseDuringEdit('return values').length == 0) {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "Back to previous step of Market setup";
            this.modalTitle = "<span >Changes made to the market base selection criteria will not apply to the pack allocation. Would you like to proceed?</span>";
            this.modalBtnCapton = "Ok";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#customModal").modal("show");
            return false;
        }

        //for normal senario

        if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, this.fnGererateTempMarketBaseDuringEdit('return values'))) {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "<span >No Changes have been made to the Market Definition.</span>";
            this.modalCloseBtnCaption = "Ok";
            jQuery("#customModal").modal("show");
            return false;
        } else {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "Back to previous step of Market setup";
            this.modalTitle = "<span >Changes made to the market base selection criteria will not apply to the pack allocation. Would you like to proceed?</span>";
            this.modalBtnCapton = "Ok";
            this.modalCloseBtnCaption = "Cancel";
            jQuery("#customModal").modal("show");
        }
    }

    public clearMarketCreateStep() {
        this.marketBaseGenericErrorMgs = "";
        if (this.editableMarketDefID == 0) {
            jQuery(".filTable tbody input[type=checkbox]").prop("checked", false);
            jQuery(".filTable tbody div.refresh-setting").removeClass("userRefreshVisible").addClass("userRefreshHidden");
            jQuery(".filTable tbody div.base-filter-info").removeClass("userRefreshVisible").addClass("userRefreshHidden");
            jQuery(".filTable tbody a.filter-setting").removeClass("purpLink").addClass("disab");
            jQuery(".filTable tbody div.base-filter-info div.nodeEqual").remove();
            jQuery(".filTable tbody td span.baseName").removeClass("textWeightBold").addClass("textWeightNormal");
            //to show mgs
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "ClearMarketCreateStep";
            this.modalTitle = "<span >Changes made to the market base selection criteria have not been applied to the pack allocation.</span>";
            this.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            this.fnExistingMarketDefinitioneEmit();
        } else {
            jQuery(".filTable tbody input[type=checkbox]").prop("checked", false);
            jQuery(".filTable tbody div.refresh-setting").removeClass("userRefreshVisible").addClass("userRefreshHidden");
            jQuery(".filTable tbody div.base-filter-info").removeClass("userRefreshVisible").addClass("userRefreshHidden");
            jQuery(".filTable tbody a.filter-setting").removeClass("purpLink").addClass("disab");
            jQuery(".filTable tbody div.base-filter-info div.nodeEqual").remove();
            jQuery(".filTable tbody td span.baseName").removeClass("textWeightBold").addClass("textWeightNormal");
            //to show mgs
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "ClearMarketCreateStep";
            this.modalTitle = "<span >Changes made to the market base selection criteria have not been applied to the pack allocation.</span>";
            this.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            //to ready existing data
            this.fnExistingMarketDefinitioneEmit();

        }



        //Changes made to the market base selection criteria have not been applied to the pack allocation

    }
    // End

    public fnBackToClientTiles(type: string) {
        if (type == "first screen") {
            if (this.fnCompareMarketBaseArray(this.tempClientInfoFinal, this.fnGererateTempMarketBaseDuringEdit('return values'))) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "back to market tiles page";
                this.modalCloseBtnCaption = "Cancel";
                this.modalTitle = "<span >Do you want to return back to <b>Market Definition</b> view?</span>";
                //this.modalBtnCapton = "Yes";
                this.modalBtnCapton = "Ok";
                jQuery("#nextModal").modal("show");
            } else {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "back to market tiles page";
                this.modalCloseBtnCaption = "Cancel";
                this.modalTitle = "<span >Changes made to the market definition setup will not apply. Would you like to proceed?</span>";
                //this.modalBtnCapton = "Yes";
                this.modalBtnCapton = "Ok";
                jQuery("#nextModal").modal("show");
            }

        } else if (type == "second screen") {
            if (JSON.stringify(this.dynamicPackMarketBase) != JSON.stringify(this.tempDynamicPackMarketBbase) || JSON.stringify(this.staticPackMarketBase) != JSON.stringify(this.tempStaticPackMarketBbase)) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "back to market tiles page with saving data";
                this.modalCloseBtnCaption = "Cancel";
                this.modalTitle = "<span >Changes made to the <b>Market Definition</b>, would you like to save?</span>";
                //this.modalBtnCapton = "Yes";
                this.modalBtnCapton = "Ok";
                jQuery("#nextModal").modal("show");
            } else {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "back to market tiles page";
                this.modalCloseBtnCaption = "Cancel";
                this.modalTitle = "<span >Do you want to return back to <b>Market Definition</b> view?</span>";
                //this.modalBtnCapton = "Yes";
                this.modalBtnCapton = "Ok";
                jQuery("#nextModal").modal("show");
            }
        }
    }

    private checkUserClientAccess(cid: number) {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.checkUserClientAccess(cid).subscribe(
                (data: any) => this.checkClientAccess(data),
                (err: any) => {
                    this.clientService.fnSetLoadingAction(false);
                    this.mmErrModal.show();
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
    }
    fnMarketBaseTableCellClick(event: any) {
        //console.log(event.event.target.checked);
        if (event.cellName == "UsedMarketBaseStatus") {
            if (event.event.target.checked) {
                this.marketBasesForView.forEach((recod: ClientMarketBase) => {
                    if (recod.MarketBaseId == event.record.MarketBaseId) {
                        recod.UsedMarketBaseStatus = 'true';
                        setTimeout(() => {
                            this.fnDefaultSelectMarketBase(recod.MarketBaseId);
                        }, 500);

                    }
                });
            } else {
                this.marketBasesForView.forEach((recod: ClientMarketBase) => {
                    if (recod.MarketBaseId == event.record.MarketBaseId) {
                        recod.UsedMarketBaseStatus = 'false';
                    }
                });
            }
            this.fnMarketSetupChangeDetection();

        } else if (event.cellName == "p-table-select-all") {
            if (event.event.target.checked) {
                this.marketBasesForView.forEach((recod: ClientMarketBase) => {
                    recod.UsedMarketBaseStatus = 'true';
                    setTimeout(() => {
                        this.fnDefaultSelectMarketBase(recod.MarketBaseId);
                    }, 500);
                });
            } else {
                this.marketBasesForView.forEach((recod: ClientMarketBase) => {
                    recod.UsedMarketBaseStatus = 'false';
                });
            }

            this.fnMarketSetupChangeDetection();
        }
    }

    fnRouteToMarketBase() {
        jQuery("#MarketbaseListModal").modal("hide");
        this.router.navigate(['./marketbase/' + this.editableClientID]);
    }

    fnCustomReflowSetting(event: string) {
        if (event == 'static-table') {
            //activeReflowAvailablePackContent
            if (this.activeReflowAvailablePackContent) {
                jQuery("#" + event + "-fitlerInfo").hide();
                this.activeReflowAvailablePackContent = false;
            } else {
                this.activeReflowAvailablePackContent = true;
            }
        } else if (event == 'dynamic-table') {
            if (this.activeReflowMarketDefContent) {
                jQuery("#" + event + "-fitlerInfo").hide();
                this.activeReflowMarketDefContent = false;
            } else {
                this.activeReflowMarketDefContent = true;
            }
        }

    }
    //to save market name only
    async fnSaveMarketName() {
        let breakExecution;
        this.clientService.fnSetLoadingAction(true);
        if (this.newsTitle == "" || this.newsTitle == " ") {
            jQuery(".required-error-mgs").html("This information is required.");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        } else if (this.newsTitle.length >= 26) {
            jQuery(".required-error-mgs").html("This label exceeds the 25 character limitation. Please review.");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        }
        else if (this.newsTitle.match(/^[-/+()&/,.\w\s]*$/) == null) {
            jQuery(".required-error-mgs").html("only alphanumeric with +, -, _,.,&,/, (, ) special characters allowed.");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return;
        } else {
            if (this.editableMarketDefID > 0) {
                try {
                    await this.clientService.checkEditForMarketDefDuplication(this.editableClientID, this.editableMarketDefID, jQuery("#newsTitle").val().trim()).then(result => { breakExecution = result });
                } catch (ex) {
                    this.clientService.fnSetLoadingAction(false);
                    console.log("error during edit");
                }
            } else {
                try {
                    await this.clientService.checkCreateMarketDefDuplication(this.editableClientID, this.newsTitle.trim()).then(result => { breakExecution = result });
                } catch (ex) {
                    this.clientService.fnSetLoadingAction(false);
                    console.log("error new entry");
                }
            }
        }

        if (breakExecution == "false") {
            jQuery(".required-error-mgs").html("Market definition '" + jQuery("#newsTitle").val().trim() + "' already exists. Please try again with a different label. ");
            jQuery("#newsTitle").focus();
            this.clientService.fnSetLoadingAction(false);
            return false;
        }

        //to save name
        await this.clientService.updateMarketDefinitionName(this.editableClientID, this.editableMarketDefID, this.newsTitle.trim())
            .then(result => {
                this.marketDefNameChangedDetected = false;
                this.tempMarketDefName = this.newsTitle;
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = '<span >Market definition name has been updated successfully.</span>';
                this.modalCloseBtnCaption = "Ok";
                jQuery("#nextModal").modal("show");
                this.clientService.fnSetLoadingAction(false);
            }).catch(ex => {
                console.log("fail");
                this.clientService.fnSetLoadingAction(false);
            });

        jQuery(".required-error-mgs").html("");
    }
    //to get packs from DB
    async fnGetMarketDefinitionPacks() {
        await this.clientService.fnGetMarketDefinitionPacks(this.editableClientID, this.editableMarketDefID)
            .then(result => {
                debugger;
                this.dynamicPackMarketBase = result.filter((rec: any) => rec.Alignment == "dynamic-right" || rec.Alignment == null) || [];
                this.staticPackMarketBase = result.filter((rec: any) => rec.Alignment == "static-left") || [];
                this.tempDynamicPackMarketBbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase)) || [];
                this.tempStaticPackMarketBbase = JSON.parse(JSON.stringify(this.staticPackMarketBase)) || [];
               // this._processDynamicAvailablePacks(result)
            })
            .catch((err: any) => {
                console.log(err);
                this.clientService.fnSetLoadingAction(false);
                //this.mmErrModal.show(); 
                if (err.status == 0) {
                    this.alertService.alert("System has failed to connect with server due to network problem.");
                } else {
                    this.alertService.alert(err.Message);
                }
            });
    }
    //save button enabled disabled in fast screen    
    fnDetectMarketDefNameChanged() {
        if (this.tempMarketDefName != this.newsTitle && this.isChangeDetectedInMarketSetup != true && this.isEditMarketDef == true && this.newsTitle != "") {
            this.marketDefNameChangedDetected = true;
        } else {
            this.marketDefNameChangedDetected = false;
        }
        jQuery(".required-error-mgs").html("");
    }

    //autocomplete methods    
    private getCSV(arr: any[], key: string) {
        arr = arr.filter((rec: any, index: any) => { if (rec.Code != "") { return true; } else { return false; } })
        return arr.map(function (obj) {
            return "'" + obj[key] + "'";
        }).join(',');
    }

    private getCSVForMolecule(arr: any[], key: string) {
        arr = arr.filter((rec: any, index: any) => { if (rec.Code != "") { return true; } else { return false; } })
        return arr.map(function (obj) {
            return "'" + obj[key] + "'";
        }).join('|');
    }

    private findIndexByAttr(arr: any[], attr: string, value: string) {
        for (var i = 0; i < arr.length; i += 1) {
            if (arr[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }
    // end autocomplete methods
    ShowMarketBaseDialog() {
        jQuery("#MarketbaseListModal").modal('show');
    }

    fnBindStaticTable() {
        // Static Table Starts
        this.staticTableBind = {
            tableID: "static-table",
            tableClass: "table table-border ",
            tableName: "Available Pack List",
            enableSerialNo: false,
            tableRowIDInternalName: "Id",
            tableColDef: [
                { headerName: 'PFC', width: '15%', internalName: 'PFC', className: "static-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
                { headerName: 'Pack Description', width: '55%', internalName: 'Pack', className: "static-pack-description", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Market Base', width: '30%', internalName: 'MarketBase', className: "static-market-base", sort: true, type: "", onClick: "", visible: true }

            ],
            enabledFixedHeader: true,
            enableSearch: true,
            enableCheckbox: true,
            enableRecordCreateBtn: false,
            enablePagination: true,
            columnNameSetAsClass: 'ChangeFlag',
            pageSize: 500,
            displayPaggingSize: 3,
            enabledStaySeletedPage: true,
            enablePTableDataLength: false,
            enabledColumnSetting: true,
            enabledColumnFilter: true,
            enabledReflow: true,
            enabledCustomReflow: true,
            pTableStyle: {
                tableOverflowY: true,
                overflowContentHeight: '428px'
            }
        };
        // Static table ends
    }

    fnBindDynamicTable() {
        //Dynamic Table starts
        this.dynamicTableBind = {
            tableID: "dynamic-table",
            tableClass: "table table-border ",
            tableName: "Market Definition Content",
            enableSerialNo: false,
            tableRowIDInternalName: "Id",
            tableColDef: [
                { headerName: 'PFC', width: '5%', internalName: 'PFC', className: "dynamic-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
                { headerName: 'Pack Name', width: '13%', internalName: 'Pack', className: "dynamic-pack-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Market Base', width: '8%', internalName: 'MarketBase', className: "dynamic-market-base", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Group #', width: '4%', internalName: 'GroupNumber', className: "dynamic-group-no", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Group Name', width: '8%', internalName: 'GroupName', className: "dynamic-group-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Factor', width: '5%', internalName: 'Factor', className: "dynamic-factor", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Product', width: '8%', internalName: 'Product', className: "dynamic-product", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Manufacturer', width: '8%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'ATC4 Code', width: '7%', internalName: 'ATC4', className: "dynamic-atc4", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'NEC4 Code', width: '7%', internalName: 'NEC4', className: "dynamic-nec4", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Molecule', width: '29%', internalName: 'Molecule', className: "dynamic-Molecule", sort: true, type: "", onClick: "", visible: true },
            ],
            enableSearch: true,
            enableCheckbox: true,
            enablePagination: true,
            enableRecordCreateBtn: false,
            pageSize: 500,
            displayPaggingSize: 10,
            enablePTableDataLength: false,
            columnNameSetAsClass: 'ChangeFlag',
            enabledStaySeletedPage: true,
            enabledColumnResize: true,
            enabledColumnSetting: true,
            enabledColumnFilter: true,
            enabledCustomReflow: true,
            pTableStyle: {
                tableOverflow: true,
                overflowContentWidth: '150%',
                overflowContentHeight: '478px',
                paginationPosition: 'left',
            }
        };
        //Dynamic Table ends
    }

    fnBindMarketBaseTable() {
        // Static Table Starts
        this.marketbaseTableBind = {
            tableID: "marketbase-table",
            tableClass: "table table-border ",
            tableName: "Add Market Base",
            enableSerialNo: false,
            tableRowIDInternalName: "Id",
            tableColDef: [
                { headerName: ' ', width: '5%', internalName: 'UsedMarketBaseStatus', className: "marketbase-select", sort: false, type: "checkbox-all", onClick: "true" },
                { headerName: 'Available Market Bases', width: '95%', internalName: 'MarketBaseName', className: "marketbase-name", sort: true, type: "", onClick: "" }

            ],
            enableSearch: true,
            pageSize: 10,
            displayPaggingSize: 3,
            enabledStaySeletedPage: true,
            enabledCellClick: true,
        };
        // Static table ends
    }

    fnRelocateMarketTiles() {
        if (this.authService.selectedMarketModule == "" || this.authService.selectedMarketModule == null) {
            this.router.navigate(['market/My-Client/' + this.editableClientID]);
        } else {
            if (this.authService.selectedMarketModule == "mymarkets") {
                this.router.navigate(['markets/' + this.authService.selectedMarketModule + '/' + this.editableClientID]);
            } else {
                this.router.navigate(['market/My-Client/' + this.editableClientID]);
            }
        }

    }
    private SubmitMarketDef() {
        this.alertService.confirm("Do you want to save current market definition as a version?",
            () => {
                this.alertService.fnLoading(true);
                var usrObj: any = this._cookieService.getObject('CurrentUser');
                var userid;
                if (usrObj) {
                    userid = usrObj.UserID;
                }
                // this.clientService.fnSubmitMarketDef(this.editableMarketDefID, userid).subscribe((data: any) => {
                //     this.alertService.fnLoading(false);
                //     this.alertService.alert("Market definition version has saved successfully.");
                //     //this.SubmitMarketButton();
                // },
                //     (err: any) => {
                //         this.alertService.fnLoading(false);
                //         console.log(err);
                //     }
                // );

            },
            () => { });

    }
}
class SearchDTO {
    searchString: string;
    searchOptions: string;
}