import { Component, Input, ViewChild, HostListener } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { MarketBaseService } from '../shared/services/marketbase.service';
import { Atc, Atc1, Atc2, Atc3, Atc4, Nec, Nec1, Nec2, Nec3, Nec4, Manufacturer, Molecule, Filter, Product } from '../shared/component/p-autocomplete/p-autocom.model';
import { ModalDirective } from 'ng2-bootstrap';
import { CONSTANTS } from '../shared/constants';
import { Pack } from '../shared/models/pack';
import { Dimension } from '../shared/models/marketbase/dimension'
import { BaseFilter } from '../shared/models/base-filter-new';
import { MarketBase, MarketBaseDetails } from '../shared/models/market-base-new';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { ViewChildren, QueryList, OnInit, AfterViewInit } from '@angular/core';
import { PAutoCompleteComponent } from '../shared/component/p-autocomplete/p-autocom.component';
import { AlertService } from '../shared/component/alert/alert.service';
import { ConfigService } from '../config.service';
import { Observable } from 'rxjs/Observable';
import { AuthService } from '../security/auth.service';

declare var jQuery: any;

@Component({
    selector: 'components',
    templateUrl: '../../app/marketbase/marketbase.component.html',
    styleUrls: ['../../app/marketbase/marketbase.component.css'],
    providers: [MarketBaseService]
})
export class MarketBaseComponent {
    @HostListener('window:beforeunload')
    canDeactivate(): Observable<boolean> | boolean {
        if (this.isChangeDetectedInMarketBase == true) { // Here add condition to check for any unsaved changes
            if (this.authService.isTimeout == true)
                return true;
            else
                return false; // return false will show alert to the user
        }
        else {
            return true;
        }
    }

    // this.authService.hasUnSavedChanges = true;
    isChangeDetectedInMarketBase: boolean = false;
    atc1List: any[] = [];
    atc2List: Atc2[] = []; atc3List: Atc3[] = []; atc4List: Atc4[] = [];
    nec1List: Nec1[] = []; nec2List: Nec2[] = []; nec3List: Nec3[] = []; nec4List: Nec4[] = [];
    manufacturerList: Manufacturer[] = []; moleculeList: Molecule[] = []; productList: Product[] = [];
    dimentionList: Dimension[] = []; poisonScheduleList: any[] = []; formList: any[] = [];pxrList:any[]=[];
    marketBaseType: any = 'ATC1'; showNEC: boolean = true; showATC: boolean = true; showPacks: boolean = false;
    marketBaseName: string = ""; marketBaseSuffix: string = ""; tempMarketBaseSuffix: string = ""; marketBase: MarketBase; tempMarketBase: MarketBase; paramID: string = "";

    canEditMarketBase: boolean = false;
    @ViewChild('lgDateModal') lgDateModal: ModalDirective
    @ViewChild('errModal') errModal: ModalDirective
    private mm: number;
    private mon: string;
    private years: number[] = [];
    private yy: number;
    private curFromYear: number;
    private curToYear: number;
    StartDate: Date;
    tempStartDate: Date;
    EndDate: Date;
    tempEndDate: Date;
    fromYear: number;
    toYear: number;
    fromMonth: string;
    toMonth: string;
    monthsFrom: any = [];
    monthsTo: any = [];
    selectedFromYear: number;
    selectedToYear: number;
    selectedFromMonth: string;
    selectedToMonth: string;
    TempMonthsFrom: any = [];
    validationMsg: string;
    Invalid: boolean;

    //for Grid
    public dynamicTableBind: any;
    public staticTableBind: any;
    public staticPackList: Pack[];
    public dynamicPackList: Pack[] = [];
    public tempDynamicPackList: Pack[] = [];
    public enabledStaticTableFooterBtns: boolean = false;
    public enabledDynamicTableFooterBtns: boolean = false;
    public checkedFlaggingDD: boolean = false;
    public checkedBrandingDD: boolean = false;
    public currentClientID: string;
    public isEditMarketBase: boolean = false;
    public editableMarketBaseID: number = 0;
    public clientName: string = "";
    public marketbaseFullName: string = "";

    //for custom modal
    public modalSaveBtnVisibility: boolean;
    public modalSaveFnParameter: string = "";
    public modalTitle: string;
    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Close";

    criteriaList: any[] = [];
    public baseFilterList: BaseFilter[] = [];
    public baseFilterTypeList: BaseFilter[] = [];
    public baseFilterListForView: BaseFilter[] = [];
    public temporaryBaseFilterList: BaseFilter[] = [];
    public marketBasePackList: any;
    public marketBaseTitle: string = 'Add Market Base';
    //public marketBase: MarketBase;
    //public marketBaseName = "";
    //public marketBaseSuffix = "";

    toggleTitle: string = '';
    breadCrumbUrl: string = '';

    descDivVisible: boolean;
    marketBaseDescription: string;
    tempBaseFilter: BaseFilter;
    tempBaseFilterList: BaseFilter[] = [];

    DefaultStartDate: Date;

    constructor(private marketBaseService: MarketBaseService, private _cookieService: CookieService, public route: ActivatedRoute, public router: Router, private authService: AuthService, private alertService: AlertService) {
    }

    //autocomplete selection handlers
    public onATC1Selected(selected: any) {
        this.atc1List = selected || [];
        this.criteriaList = selected || [];
    } //if (this.atc1List.length > 0) { jQuery(".checkbox-atc1").prop("checked", true); } else { jQuery(".checkbox-atc1").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || []; }
    public onATC2Selected(selected: any) {
        this.atc2List = selected || [];
        this.criteriaList = selected || [];
    }//if (this.atc2List.length > 0) { jQuery(".checkbox-atc2").prop("checked", true); } else { jQuery(".checkbox-atc2").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc3List).concat(this.atc4List) || []; }
    public onATC3Selected(selected: any) { this.atc3List = selected || []; this.criteriaList = selected || []; }//if (this.atc3List.length > 0) { jQuery(".checkbox-atc3").prop("checked", true); } else { jQuery(".checkbox-atc3").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc4List) || []; }
    public onATC4Selected(selected: any) { this.atc4List = selected || []; this.criteriaList = selected || []; }// if (this.atc4List.length > 0) { jQuery(".checkbox-atc4").prop("checked", true); } else { jQuery(".checkbox-atc4").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc3List) || []; }
    public onNEC1Selected(selected: any) { this.nec1List = selected || []; this.criteriaList = selected || []; }//if (this.nec1List.length > 0) { jQuery(".checkbox-nec1").prop("checked", true); } else { jQuery(".checkbox-nec1").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || []; }
    public onNEC2Selected(selected: any) { this.nec2List = selected || []; this.criteriaList = selected || []; }//if (this.nec2List.length > 0) { jQuery(".checkbox-nec2").prop("checked", true); } else { jQuery(".checkbox-nec2").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec3List).concat(this.nec4List) || []; }
    public onNEC3Selected(selected: any) { this.nec3List = selected || []; this.criteriaList = selected || []; }//if (this.nec3List.length > 0) { jQuery(".checkbox-nec3").prop("checked", true); } else { jQuery(".checkbox-nec3").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec4List) || []; }
    public onNEC4Selected(selected: any) { this.nec4List = selected || []; this.criteriaList = selected || []; }//if (this.nec4List.length > 0) { jQuery(".checkbox-nec4").prop("checked", true); } else { jQuery(".checkbox-nec4").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec3List) || []; }
    public onMoleculeSelected(selected: any) { this.moleculeList = selected || []; this.criteriaList = selected || []; } //if (this.moleculeList.length > 0) { jQuery(".checkbox-molecule").prop("checked", true); } else { jQuery(".checkbox-molecule").prop("checked", false) } }
    public onManufacturerSelected(selected: any) { this.manufacturerList = selected || []; this.criteriaList = selected || []; }//if (this.manufacturerList.length > 0) { jQuery(".checkbox-mfr").prop("checked", true); } else { jQuery(".checkbox-mfr").prop("checked", false) } }
    public onProductSelected(selected: any) { this.productList = selected || []; this.criteriaList = selected || []; } //if (this.productList.length > 0) { jQuery(".checkbox-product").prop("checked", true); } else { jQuery(".checkbox-product").prop("checked", false) } }
    public onDimensionSelected(selected: any) { this.dimentionList = selected || []; this.criteriaList = selected || []; } //if (this.productList.length > 0) { jQuery(".checkbox-product").prop("checked", true); } else { jQuery(".checkbox-product").prop("checked", false) } }
    public onPoisonScheduleSelected(selected: any) { this.poisonScheduleList = selected || []; this.criteriaList = selected || []; }
    public onFormSelected(selected: any) { this.formList = selected || []; this.criteriaList = selected || []; }
    public onPxRSelected(selected: any) { this.pxrList = selected || []; this.criteriaList = selected || []; }
    

    ngOnInit(): void {
        this.descDivVisible = false;
        this.showATC = true;
        this.showNEC=false;
        if (jQuery(".dropdown-menu li:contains('My Subscription')").length > 0) {
            this.toggleTitle = "My Subscriptions";
            this.breadCrumbUrl = "/subscription/myclients";
        }
        else {
            //console.log('ConfigService.clientFlag: ', ConfigService.clientFlag);
            this.toggleTitle = ConfigService.clientFlag ? "My Clients" : "All Clients";
            this.breadCrumbUrl = ConfigService.clientFlag ? "/subscription/myclients" : "/subscriptions/allclients";
        }
        //

        this.fnGetDefaultDateForCalender();

        this.marketBaseService.fnSetLoadingAction(true);
        this.paramID = this.route.snapshot.params['id'] || "";
        if (this.paramID.indexOf('|') > 0) {
            this.currentClientID = this.paramID.split("|")[0];
            this.editableMarketBaseID = Number(this.paramID.split("|")[1]) || 0;
            this.paramID = this.editableMarketBaseID.toString();
            if (this.editableMarketBaseID > 0) {
                this.isEditMarketBase = true;//to set edit flag
                this.marketBaseTitle = "Edit Market Base";
                this.fnLoadSavedData(this.editableMarketBaseID.toString(), this.currentClientID);
            }

        } else {
            this.currentClientID = this.paramID;
            this.marketBaseService.fnSetLoadingAction(false);

            //set default duration date
            /* var today = new Date();
             this.mm = today.getMonth() + 1;
             var currentMonth =today.getMonth()+1;
             var currentYear = today.getFullYear();
             if (this.mm < 10) {
                 this.mon = '0' + this.mm
             }
             if (this.editableMarketBaseID > 0) {
                 this.StartDate = new Date(this.curFromYear + "-" + this.mon + "-01");
                 this.tempStartDate = new Date(this.curFromYear + "-" + this.mon + "-01");
             }
             else {
                 if (this.DefaultStartDate == undefined) this.DefaultStartDate = new Date;
 
                 this.StartDate = new Date(currentYear + "-" + currentMonth + "-01");
                 this.tempStartDate = new Date(currentYear + "-" + currentMonth + "-01");
             }
             this.EndDate = new Date(currentYear + "-" + "12" + "-01");
             this.tempEndDate = new Date(currentYear + "-" + "12" + "-01");*/
            //end of default date
        }

        //to pull client Name
        this.marketBaseService.getClientName(Number(this.currentClientID)).subscribe(
            (data: any) => {
                this.clientName = data;
                this.marketBaseService.fnSetLoadingAction(false);
            },
            (err: any) => {
                console.log(err);
                this.marketBaseService.fnSetLoadingAction(false);

            });


        /******Date Start*******/
        this.monthsFrom = CONSTANTS.months;
        this.monthsTo = CONSTANTS.months2;

        this.getMonth();
        this.getYear();
        var today = new Date();
        this.curFromYear = today.getFullYear();
        this.curToYear = today.getFullYear();
        this.Invalid = false;
        /*****Date End*****/
        // Static Table Starts
        this.staticTableBind = {
            tableID: "static-table",
            tableClass: "table table-border ",
            tableName: "Available Pack List",
            enableSerialNo: false,
            tableRowIDInternalName: "PFC",
            tableColDef: [
                { headerName: 'Pack Description', width: '50%', internalName: 'Pack_Description', className: "dynamic-pack-name", sort: true, type: "", onClick: "" },
                { headerName: 'PFC', width: '8%', internalName: 'PFC', className: "dynamic-pfc", sort: true, type: "", onClick: "" },
                { headerName: 'Manufacturer', width: '20%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "" },
                { headerName: 'ATC4', width: '10%', internalName: 'ATC4_Code', className: "dynamic-atc4", sort: true, type: "", onClick: "" },
                { headerName: 'NEC4', width: '8%', internalName: 'NEC4_Code', className: "dynamic-nec4", sort: true, type: "", onClick: "" }
            ],
            enableSearch: true,
            enableCheckbox: true,
            enableRecordCreateBtn: false,
            pageSize: 10,
            displayPaggingSize: 5,
            enablePTableDataLength: true,
            checkboxColumnHeader: " ",
            pTableStyle: {
                tableOverflowY: true,
                overflowContentHeight: '370px'
            }
        };
        // Static table ends

        //Dynamic Table starts
        this.dynamicTableBind = {
            tableID: "dynamic-table",
            tableClass: "table table-border ",
            tableName: "Market Base Packs",
            enableSerialNo: false,
            tableRowIDInternalName: "PFC",
            tableColDef: [
                { headerName: 'Pack Description', width: '50%', internalName: 'Pack_Description', className: "dynamic-pack-name", sort: true, type: "", onClick: "" },
                { headerName: 'PFC', width: '8%', internalName: 'PFC', className: "dynamic-pfc", sort: true, type: "", onClick: "" },
                { headerName: 'Manufacturer', width: '20%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "" },
                { headerName: 'ATC4', width: '10%', internalName: 'ATC4_Code', className: "dynamic-atc4", sort: true, type: "", onClick: "" },
                { headerName: 'NEC4', width: '8%', internalName: 'NEC4_Code', className: "dynamic-nec4", sort: true, type: "", onClick: "" }
            ],

            enableSearch: true,
            enableCheckbox: true,
            enableRecordCreateBtn: false,
            pageSize: 10,
            displayPaggingSize: 3,
            enablePTableDataLength: true,
            checkboxColumnHeader: " ",
            pTableStyle: {
                tableOverflowY: true,
                overflowContentHeight: '370px'
            }
        };
        this.dynamicPackList = [];

    }


    fnLoadData() {
        this.marketBaseService.getAvailablePacks().subscribe(
            (data: Pack[]) => {
                this.staticPackList = data;
                if (this.isEditMarketBase) {
                    this.marketBaseService.fnSetLoadingAction(false);
                }
            },
            (err: any) => {
                console.log(err);
                this.marketBaseService.fnSetLoadingAction(false);

            },
            () => console.log('available packs loaded'));
    }
    fnChangeDropdonw(values: string, type: string) {
        if (type == "Flagging") {
            this.checkedFlaggingDD = true;
        } else if (type == "Branding") {
            this.checkedBrandingDD = true;
        }

    }

    fnGetAvailablePackList(type: string) {
        this.marketBaseService.fnSetLoadingAction(true);
        this.marketBaseService.getAvailablePacks().subscribe(
            (data: Pack[]) => {
                this.staticPackList = data || [];
                if (type == "DataEditMood") {
                    this._populateSavedPackList(this.marketBase);
                }
                this.marketBaseService.fnSetLoadingAction(false);
            },
            (err: any) => {
                console.log(err);
                this.marketBaseService.fnSetLoadingAction(false);

            },
            () => console.log('available packs loaded'));
    }

    fnGetDefaultDateForCalender() {
        this.marketBaseService.getStartDate().subscribe(
            (data: any) => {
                this.DefaultStartDate = data || new Date;
                //for default date
                //set default duration date
                var today = new Date();
                this.mm = today.getMonth() + 1;
                if (this.mm < 10) {
                    this.mon = '0' + this.mm
                } else {
                    this.mon = this.mm.toString();
                }

                if (this.editableMarketBaseID > 0) {
                    this.StartDate = new Date(this.curFromYear + "-" + this.mon + "-01");
                    this.tempStartDate = new Date(this.curFromYear + "-" + this.mon + "-01");
                }
                else {
                    if (this.DefaultStartDate == undefined) this.DefaultStartDate = new Date;
                    var dd = this.DefaultStartDate.toString();
                    var y1 = dd.split('-')[0];
                    // var m1 = dd.split('/')[1];
                    var m1 = dd.split('-')[1];
                    this.StartDate = new Date(y1 + "-" + m1 + "-01");
                    this.tempStartDate = new Date(y1 + "-" + m1 + "-01");
                }
                this.EndDate = new Date(this.curToYear + "-" + "12" + "-01");
                this.tempEndDate = new Date(this.curToYear + "-" + "12" + "-01");

                for (let it in this.monthsFrom) {
                    this.monthsFrom[it].selected = false;
                }
                for (let it in this.monthsTo) {
                    this.monthsTo[it].selected = false;
                }
                this.monthsFrom[this.mm - 1].selected = true;
                this.monthsTo[11].selected = true;
                //end of default

            },
            (err: any) => {
                this.marketBaseService.fnSetLoadingAction(false),
                    console.log(err);
            }
        );
    }

    private fnLoadSavedData(marketBaseId: string, clientId: string) {
        this.marketBaseService.getMarketBasePacks(+marketBaseId, +clientId).subscribe(
            (dataSet: MarketBaseDetails) => {
                var data: MarketBase;
                if (dataSet != null) {
                    data = dataSet.MarketBase;
                    let dimension = dataSet.Dimension || [];
                    dimension.forEach((rec: any) => {
                        rec.FilterName = "Dimension";
                        rec.Code = rec.DimensionName;
                    });

                    this.dimentionList = dimension || [];

                    //to get PxR list
                    let pxrDetails = dataSet.PxRList || [];
                    pxrDetails.forEach((rec: any) => {
                        rec.FilterName = "pxrcode";
                        rec.Code = rec.MarketCode;
                    });
                    this.pxrList=pxrDetails||[];

                }
                this.marketBase = data[0] || [];
                this.tempMarketBase = data[0] || [];
                this.marketBaseName = data[0].Name;
                this.marketBaseSuffix = data[0].Suffix || "";
                this.tempMarketBaseSuffix = data[0].Suffix || "";
                if (this.marketBaseSuffix != "") {
                    this.marketbaseFullName = this.marketBaseName + " " + this.marketBaseSuffix;
                } else {
                    this.marketbaseFullName = this.marketBaseName;
                }
                this.StartDate = new Date(data[0].DurationFrom);
                this.tempStartDate = new Date(data[0].DurationFrom);
                this.EndDate = new Date(data[0].DurationTo);
                this.tempEndDate = new Date(data[0].DurationTo);
                this.marketBaseType = data[0].BaseType;
                jQuery("#ddlSelectType").val(this.marketBaseType)
                if (this.marketBaseType.toLowerCase() == "pack") {
                    // this._populateSavedPackList(data);
                    this.fnGetAvailablePackList('DataEditMood');
                    this.showNEC = false;
                    this.showATC = false;
                    this.showPacks = true;
                } else {
                    this.selectType(this.marketBaseType, 'PushData');
                    this.baseFilterList = data[0].Filters || [];
                    this.temporaryBaseFilterList = data[0].Filters || [];
                    this.baseFilterListForView = this.baseFilterList.filter((record: BaseFilter, index: any) => {//to remove flagging all & branding all
                        if (record.Values == '\'Ethical\',\'Proprietary\'' || record.Values == '\'Branded\',\'Generic\'') {
                            return false;
                        } else {
                            return true;
                        }
                    });

                    //to check base criteria exists
                    this.baseFilterList.forEach((record: BaseFilter, index: any) => {
                        if (record.IsBaseFilterType == true) {
                            //to make basefilter first row of row in add/restrict 
                            this.baseFilterTypeList.push({ Id: 1, MarketBaseId: 2, Name: record.Name, Criteria: record.Criteria, Values: record.Values, IsEnabled: record.IsEnabled, IsRestricted: record.IsRestricted, IsBaseFilterType: record.IsBaseFilterType });
                        } else {
                            return true;
                        }
                    });

                    if (!this.marketBaseType.includes('Packs')) {
                        this.descDivVisible = true;
                        this._generateMarketBaseDescription(this.marketBaseType);
                    }

                    this.fnSetAutocompleteValues();
                    this.marketBaseService.fnSetLoadingAction(false);
                }



            },
            (err: any) => {
                //this.errModal.show();
                console.log(err);
                this.marketBaseService.fnSetLoadingAction(false);
            },
            () => console.log('Market Base loaded'));
    }
    private _populateSavedPackList(data: MarketBase): void {
        //var packs = data[0].Filters[0].Values.split(",");
        var packs = data.Filters[0].Values.split(",");
        for (let i = 0; i < Number(packs.length); i++) {
            let item = packs[i];
            var selectedStaticInfo = this.staticPackList.filter((rec: Pack) => "'" + rec.PFC + "'" == item)[0];
            this.staticPackList.splice(this.staticPackList.indexOf(selectedStaticInfo), 1);
            this.dynamicPackList.push(selectedStaticInfo);
        }

        this.tempDynamicPackList = JSON.parse(JSON.stringify(this.dynamicPackList));
    }

    fnSetAutocompleteValues() {
        let baseType = ['Atc1', 'Atc2', 'Atc3', 'Atc4', 'Nec1', 'Nec2', 'Nec3', 'Nec4', 'Product', 'Manufacturer', 'Molecule', 'Flagging', 'Branding','PoisonSchedule','Form'];
        baseType.forEach((rec: any, index: any) => {
            let criteriaOfSelectedBase = this.baseFilterList.filter((record: any, index: any) => {
                if (record.Name.toLowerCase() == rec.toLowerCase()) {
                    return true;
                } else {
                    return false;
                }
            }) || [];
            if (criteriaOfSelectedBase.length > 0) {
                if (rec.toLowerCase() == 'atc1') {
                    this.atc1List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'atc2') {
                    this.atc2List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'atc3') {
                    this.atc3List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'atc4') {
                    this.atc4List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'nec1') {
                    this.nec1List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'nec2') {
                    this.nec2List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'nec3') {
                    this.nec3List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'nec4') {
                    this.nec4List = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'product') {
                    this.productList = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'molecule') {
                    this.moleculeList = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                } else if (rec.toLowerCase() == 'manufacturer') {
                    this.manufacturerList = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, 'Mfr');
                    console.log(this.manufacturerList)
                } else if (rec.toLowerCase() == 'flagging') {
                    this.checkedFlaggingDD = true;
                    jQuery("#ddFlagging").val(criteriaOfSelectedBase[0].Values);

                } else if (rec.toLowerCase() == 'branding') {
                    this.checkedBrandingDD = true;
                    jQuery("#ddBranding").val(criteriaOfSelectedBase[0].Values);
                }else if (rec.toLowerCase() == 'poisonschedule') {
                    this.poisonScheduleList = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                    console.log(" this.poisonScheduleList", this.poisonScheduleList);
                }else if (rec.toLowerCase() == 'form') {
                    this.formList = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                    console.log(" this.formList", this.formList);
                }
                else if (rec.toLowerCase() == 'pxrcode') {
                    this.pxrList = this.fnCreateBaseCriteriaArray(criteriaOfSelectedBase[0].Values, rec);
                    console.log(" this.formList", this.formList);
                }
            }
        });
        //  this.baseFilterList.filter
    }
    @ViewChildren(PAutoCompleteComponent)
    private children: QueryList<PAutoCompleteComponent>;
    private atc1: PAutoCompleteComponent; private atc2: PAutoCompleteComponent; private atc3: PAutoCompleteComponent; private atc4: PAutoCompleteComponent;
    private nec1: PAutoCompleteComponent; private nec2: PAutoCompleteComponent; private nec3: PAutoCompleteComponent; private nec4: PAutoCompleteComponent;
    private molecule: PAutoCompleteComponent; private manufacturer: PAutoCompleteComponent; private product: PAutoCompleteComponent;

    ngAfterViewInit(): void {
        var childrenArray = this.children.toArray();
        for (var i in childrenArray) {
            var child = childrenArray[i];
            switch (child.AutoComType.toLowerCase()) {
                case 'atc1': { this.atc1 = child; }
                case 'atc2': { this.atc2 = child; }
                case 'atc3': { this.atc3 = child; }
                case 'atc4': { this.atc4 = child; }
                case 'nec1': { this.nec1 = child; }
                case 'nec2': { this.nec2 = child; }
                case 'nec3': { this.nec3 = child; }
                case 'nec4': { this.nec4 = child; }
                case 'manufacturer': { this.manufacturer = child; }
                case 'molecule': { this.molecule = child; }
                case 'product': { this.product = child; }
                // case 'poisonschedule': { this.poisonScheduleList = child; }
                // case 'form': { this.product = child; }

            }
        }

        // this.marketBaseService.getStartDate().subscribe(
        //     (data: any) => { this.DefaultStartDate = data || new Date; this.selectType("ATC1"); 
        // },
        //     (err: any) => {
        //         this.marketBaseService.fnSetLoadingAction(false),
        //         console.log(err);
        //     }
        // );
        //this.selectType("ATC1");
    }


    public selectType(selectedType: string, action: string = "") {
        this.marketBaseType = selectedType;
        this.showATC = true;
        this.showNEC = true;
        this.showPacks = false;
        this.atc1.enableMe(); this.atc2.enableMe(); this.atc3.enableMe(); this.atc4.enableMe(); this.nec1.enableMe(); this.nec2.enableMe(); this.nec3.enableMe(); this.nec4.enableMe();
        this.atc1.makeMultiSelect(); this.atc2.makeMultiSelect(); this.atc3.makeMultiSelect(); this.atc4.makeMultiSelect(); this.nec1.makeMultiSelect(); this.nec2.makeMultiSelect(); this.nec3.makeMultiSelect(); this.nec4.makeMultiSelect(); this.molecule.makeMultiSelect(); this.manufacturer.makeMultiSelect(); this.product.makeMultiSelect();
        //to clear previous data
        this.atc1List = []; this.atc2List = []; this.atc3List = []; this.atc4List = []; this.nec1List = []; this.nec2List = []; this.nec3List = []; this.nec4List = []; this.manufacturerList = []; this.moleculeList = []; this.productList = [];
        this.checkedBrandingDD = false;
        this.checkedFlaggingDD = false;
        if (action != "PushData") {
            this.marketBaseName = "";
            this.marketBaseSuffix = "";
            this.tempMarketBaseSuffix = "";
            this.marketbaseFullName = "";
            //this.StartDate = null;
            //this.EndDate = null;
            this.baseFilterList = [];
            this.baseFilterListForView = [];
            this.baseFilterTypeList = [];

            //set default duration date
            var today = new Date();
            this.mm = today.getMonth() + 1;
            if (this.mm < 10) {
                this.mon = '0' + this.mm
            }
            if (this.editableMarketBaseID > 0) {
                this.StartDate = new Date(this.curFromYear + "-" + this.mon + "-01");
                this.tempStartDate = new Date(this.curFromYear + "-" + this.mon + "-01");
            }
            else {
                if (this.DefaultStartDate == undefined) this.DefaultStartDate = new Date;
                var dd = this.DefaultStartDate.toString().split(' ')[0];
                var y1 = dd.split('-')[0];
                // var m1 = dd.split('/')[1];
                var m1 = dd.split('-')[1];
                this.StartDate = new Date(y1 + "-" + m1 + "-01");
                this.tempStartDate = new Date(y1 + "-" + m1 + "-01");
            }
            this.EndDate = new Date(this.curToYear + "-" + "12" + "-01");
            this.tempEndDate = new Date(this.curToYear + "-" + "12" + "-01");

            for (let it in this.monthsFrom) {
                this.monthsFrom[it].selected = false;
            }
            for (let it in this.monthsTo) {
                this.monthsTo[it].selected = false;
            }
            this.monthsFrom[this.mm - 1].selected = true;
            this.monthsTo[11].selected = true;

        }

        this.baseFilterList = [];
        switch (selectedType.toLowerCase()) {
            case "atc1": {
                this.showNEC = false;
                this.atc1.clearList();
                //this.atc1.makeSingleSelect("atc1");
                break;
            }
            case "atc2": {
                this.showNEC = false; this.atc1.disableMe();
                this.atc2.clearList();
                //this.atc2.makeSingleSelect("atc2");
                break;
            }
            case "atc3": {
                this.showNEC = false; this.atc1.disableMe(); this.atc2.disableMe();
                this.atc3.clearList();
                //this.atc3.makeSingleSelect("atc3");
                break;
            }
            case "atc4": {
                this.showNEC = false; this.atc1.disableMe(); this.atc2.disableMe(); this.atc3.disableMe();
                this.atc4.clearList();
                //this.atc4.makeSingleSelect("atc4");
                break;
            }
            case "nec1": {
                this.showATC = false;
                this.nec1.clearList();
                //this.nec1.makeSingleSelect("nec1");
                break;
            }
            case "nec2": {
                this.showATC = false; this.nec1.disableMe();
                this.nec2.clearList();
                //this.nec2.makeSingleSelect("nec2");
                break;
            }
            case "nec3": {
                this.showATC = false; this.nec1.disableMe(); this.nec2.disableMe();
                this.nec3.clearList();
                //this.nec3.makeSingleSelect("nec3");
                break;
            }
            case "nec4": {
                this.showATC = false; this.nec1.disableMe(); this.nec2.disableMe(); this.nec3.disableMe();
                this.nec4.clearList();
                //this.nec4.makeSingleSelect("nec4");
                break;
            }
            case "manufacturer": {
                //this.manufacturer.makeSingleSelect("manufacturer");
                break;
            }
            case "molecule": {
                //this.molecule.makeSingleSelect("molecule");
                break;
            }
            case "product": {
                //this.product.makeSingleSelect("product");
                break;
            }
            case "pack": {
                this.showNEC = false;
                this.showATC = false;
                this.showPacks = true;
                this._updateMarketBase();
                this.fnLoadData();
                break;
            }
        }
        this.fnMarketBaseChangeDetection();
    }

    async  SaveMarketBase() {
        //to bind marketbase full name
        let IsMarketbaseNameExists = false;
        if (this.marketBaseSuffix != "") {
            this.marketbaseFullName = this.marketBaseName.trim() + " " + this.marketBaseSuffix;
        } else {
            this.marketbaseFullName = this.marketBaseName.trim();
        }


        if (this.showPacks) {
            if (this.dynamicPackList.length == 0) {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Market Base Packs should not be empty, please select at least one pack. ";
                this.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
                return false;
            }

            else if (typeof this.marketBaseName == 'undefined' || this.marketBaseName == "" || typeof this.marketBaseSuffix == 'undefined' || this.marketBaseSuffix == "") {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Market Base Label should not be blank.";
                this.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
                return false;
            } else if (this.marketBaseSuffix.length >= 26) {
                this.alertService.fnLoading(false);
                this.marketBaseService.fnSetLoadingAction(false);
                this.alertService.alert("Marketbase label exceeds the 25 character limitation. Please review.");
                jQuery("#newsTitle").focus();
                return false;
            }
            else if (this.marketBaseSuffix.match(/^[-/+()&/,.\w\s]*$/) == null) {
                this.alertService.fnLoading(false);
                this.marketBaseService.fnSetLoadingAction(false);
                this.alertService.alert("only alphanumeric with +, -, _,.,&,/, (, ) special characters allowed.");
                return false;
            }
            else if (typeof this.StartDate == 'undefined' || this.StartDate == null || typeof this.EndDate == 'undefined' || this.EndDate == null) {
                // else if (typeof this.StartDate == 'undefined' || this.StartDate.toString() == "" || typeof this.EndDate == 'undefined' || this.EndDate.toString() == "") {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Duration of this Market base should not be empty";
                this.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
                return false;
            } else {
                try {
                    await this.marketBaseService.checkMarketbaseNameDuplication(this.editableMarketBaseID, +this.currentClientID, this.marketbaseFullName).then(result => { IsMarketbaseNameExists = result });
                } catch (ex) {
                    this.alertService.fnLoading(false);
                    console.log("error during edit");
                }
            }
            if (IsMarketbaseNameExists) {
                this.alertService.fnLoading(false);
                this.marketBaseService.fnSetLoadingAction(false);
                this.alertService.alert("Marketbase <b>" + this.marketbaseFullName + "</b> already exists. Please try again with a different label. ");
                return false;
            }


            if (!this.isEditMarketBase) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "Save Market Base";
                this.modalTitle = "Would you like to save market base <b>" + this.marketbaseFullName + "</b>?";
                this.modalBtnCapton = "Yes";
                this.modalCloseBtnCaption = "No";
                jQuery("#nextModal").modal("show");
                return false;
            }
            else if (this.isEditMarketBase) {
                //to check dependency of market base
                this.marketBaseService.getEffectedMarketDefName(+this.editableMarketBaseID, +this.currentClientID).subscribe((data: string) => {
                    if (data == "") {
                        this.modalSaveBtnVisibility = true;
                        this.modalSaveFnParameter = "Save Market Base";
                        this.modalTitle = "Would you like to save market base <b>" + this.marketbaseFullName + "</b>?";
                        this.modalBtnCapton = "Yes";
                        this.modalCloseBtnCaption = "No";
                        jQuery("#nextModal").modal("show");
                        return false;
                    } else {
                        this.modalSaveBtnVisibility = true;
                        this.modalSaveFnParameter = "Save Market Base";
                        this.modalTitle = "Editing market base <b>" + this.marketbaseFullName + " </b> will have effect on <b>" + data + "</b> market definitions; hence affect your deliverables, would you like to proceed?<br/>\
                        <div class='mgs-note'>Note: System may take up to 24 hours for changes to take effect on existing definitions and deliverables. To immediately reflect the changes please edit definitions from Market module.</div>";
                        this.modalBtnCapton = "Yes";
                        this.modalCloseBtnCaption = "No";
                        jQuery("#nextModal").modal("show");
                        return false;
                    }
                },
                    (err: any) => {
                        this.marketBaseService.fnSetLoadingAction(false);
                        console.log(err);
                    }
                );
            }


        }
        else {
            this.marketBaseService.fnSetLoadingAction(true);
            if (typeof this.marketBaseName == 'undefined' || this.marketBaseName.trim() == "" || typeof this.marketBaseSuffix == 'undefined') {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "No selection has been applied to the market base summary. Please review.";
                this.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
                this.marketBaseService.fnSetLoadingAction(false);
                return false;
            } else if (typeof this.marketBaseSuffix == 'undefined' || this.marketBaseSuffix.trim() == "" || typeof this.marketBaseSuffix == 'undefined') {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Market base label should not be blank.";
                this.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
                this.marketBaseService.fnSetLoadingAction(false);
                return false;
            } else if (this.marketBaseSuffix.length >= 26) {
                this.alertService.fnLoading(false);
                this.marketBaseService.fnSetLoadingAction(false);
                this.alertService.alert("Market base label exceeds the 25 character limitation. Please review.");
                jQuery("#newsTitle").focus();
                return false;
            }
            else if (this.marketBaseSuffix.match(/^[-/+()&/,.\w\s]*$/) == null) {
                this.alertService.fnLoading(false);
                this.marketBaseService.fnSetLoadingAction(false);
                this.alertService.alert("only alphanumeric with +, -, _,.,&,/, (, ) special characters allowed.");
                return false;
            }
            // else if (typeof this.StartDate == 'undefined' || this.StartDate.toString() == "" || typeof this.EndDate == 'undefined' || this.EndDate.toString() == "") {
            else if (typeof this.StartDate == 'undefined' || this.StartDate == null || typeof this.EndDate == 'undefined' || this.EndDate == null) {
                this.modalSaveBtnVisibility = false;
                this.modalSaveFnParameter = "";
                this.modalTitle = "Duration of this market base should not be empty!!";
                this.modalCloseBtnCaption = "Close";
                this.marketBaseService.fnSetLoadingAction(false);
                jQuery("#nextModal").modal("show");
                return false;
            }
            else {
                try {
                    await this.marketBaseService.checkMarketbaseNameDuplication(this.editableMarketBaseID, +this.currentClientID, this.marketbaseFullName).then(result => { IsMarketbaseNameExists = result });
                } catch (ex) {
                    this.alertService.fnLoading(false);
                    console.log("error during edit");
                }
            }
            if (IsMarketbaseNameExists) {
                this.alertService.fnLoading(false);
                this.marketBaseService.fnSetLoadingAction(false);
                this.alertService.alert("Marketbase <b>" + this.marketbaseFullName + "</b> already exists. Please try again with a different label. ");
                return false;
            }


            //confirmation 
            if (this.isEditMarketBase) {
                //mgs during edit market base.
                this.marketBaseService.getEffectedMarketDefName(+this.editableMarketBaseID, +this.currentClientID).subscribe((data: string) => {
                    if (data == "") {
                        this.modalSaveBtnVisibility = true;
                        this.modalSaveFnParameter = "Save Marketbase without pack";
                        this.modalTitle = "Would you like to save market base <b>" + this.marketbaseFullName + "?";
                        this.modalBtnCapton = "Yes";
                        this.modalCloseBtnCaption = "No";
                        this.marketBaseService.fnSetLoadingAction(false);
                        jQuery("#nextModal").modal("show");
                        return false;
                    } else {
                        this.modalSaveBtnVisibility = true;
                        this.modalSaveFnParameter = "Save Marketbase without pack";
                        //this.modalTitle = "Editing Market Base <b>" + this.marketbaseFullName + " </b> will have effect on <b>" + data + "</b> market definitions; hence affect your deliverables, would you like to proceed?";
                        this.modalTitle = "Editing market base <b>" + this.marketbaseFullName + " </b> will have effect on <b>" + data + "</b> market definitions; hence affect your deliverables, would you like to proceed?<br/>\
                        <div class='mgs-note'>Note: System may take up to 24 hours for changes to take effect on existing definitions and deliverables. To immediately reflect the changes please edit definitions from Market module.</div>";
                        this.modalBtnCapton = "Yes";
                        this.modalCloseBtnCaption = "No";
                        this.marketBaseService.fnSetLoadingAction(false);
                        jQuery("#nextModal").modal("show");
                        return false;
                    }
                },
                    (err: any) => {
                        this.marketBaseService.fnSetLoadingAction(false);
                        console.log(err);
                    }
                );
            } else {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "Save Marketbase without pack";
                this.modalTitle = "Would you like to save market base <b>" + this.marketbaseFullName + "</b>?";
                this.modalBtnCapton = "Yes";
                this.modalCloseBtnCaption = "No";
                this.marketBaseService.fnSetLoadingAction(false);
                jQuery("#nextModal").modal("show");
                return false;

            }
        }


    }
    CancelMarketBase(): boolean {
        if (this.isEditMarketBase) {
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "Restore Market Base";
            this.modalTitle = "Would you like to cancel the changes made to this market base?";
            this.modalBtnCapton = "Yes";
            this.modalCloseBtnCaption = "No";
            jQuery("#nextModal").modal("show");
            return false;
        }
    }
    private _updateMarketBase(): void {
        if (this.showPacks) {
            //this.marketBaseName = "Custom Pack(" + this.dynamicPackList.length.toString() + ")";
            this.marketBaseName = "Custom Pack";
        }
        else {
            this.marketBaseName = 'test';
        }
    }
    private _getFormattedDate(date: Date): string {
        var year = date.getFullYear();
        var month = (1 + date.getMonth()).toString();
        month = month.length > 1 ? month : '0' + month;
        var day = date.getDate().toString();
        day = day.length > 1 ? day : '0' + day;
        return year + '-' + month + '-' + day;
    }
    getYear() {
        var today = new Date();
        this.yy = today.getFullYear();
        this.years.push(this.yy - 1);
        for (var i = (this.yy); i <= (this.yy + 50); i++) {
            this.years.push(i);
        }
    }

    ngDoCheck() {
        //if (this.criteriaList)
        //    console.log(this.criteriaList);
    }
    applyCriteria(): string[] {
        return this.criteriaList;
    }

    getMonth() {
        var today = new Date();
        this.mm = today.getMonth() + 1;
        if (this.mm < 10) {
            this.mon = '0' + this.mm
        }
    }
    previousYearFrom() {
        this.curFromYear = this.curFromYear - 1;
    }
    nextYearFrom() {
        this.curFromYear = this.curFromYear + 1;
    }
    previousYearTo() {
        this.curToYear = this.curToYear - 1;
    }
    nextYearTo() {
        this.curToYear = this.curToYear + 1;
    }
    FromMonthClick(mon: any) {
        for (let it in this.monthsFrom) {
            if (this.monthsFrom[it].val == mon.val)
                this.monthsFrom[it].selected = true;
            else
                this.monthsFrom[it].selected = false;
        }
    }
    ToMonthClick(mon: any) {
        for (let it in this.monthsTo) {
            if (this.monthsTo[it].val == mon.val)
                this.monthsTo[it].selected = true;
            else
                this.monthsTo[it].selected = false;
        }
    }
    UpdateTimeDuration() {
        this.Invalid = false;
        var fMonth: string; var tMonth: string;
        for (let it in this.monthsFrom) {
            if (this.monthsFrom[it].selected == true)
                fMonth = this.monthsFrom[it].val;
        }
        for (let it in this.monthsTo) {
            if (this.monthsTo[it].selected == true)
                tMonth = this.monthsTo[it].val;
        }
        if (this.curFromYear > this.curToYear) {
            this.validationMsg = "Invalid Date Range";
            this.Invalid = true;
        }
        else if (this.curFromYear == this.curToYear) {
            if (Number(fMonth) >= Number(tMonth)) {
                this.validationMsg = "Invalid Date Range";
                this.Invalid = true;
            }
        }
        if (this.Invalid == false) {
            this.StartDate = new Date(this.curFromYear + "-" + fMonth + "-01");
            this.EndDate = new Date(this.curToYear + "-" + tMonth + "-01");
            //

            this.lgDateModal.hide();
        }

        this.fnMarketBaseChangeDetection();
    }

    UpdateTimeDurationForCancel() {
        var mon = this.StartDate.getMonth();
        for (let it in this.monthsFrom) {
            if (this.monthsFrom[it].val == this.StartDate.getMonth() + 1)
                this.monthsFrom[it].selected = true;
            else
                this.monthsFrom[it].selected = false;
        }
        for (let it in this.monthsTo) {
            if (this.monthsTo[it].val == this.EndDate.getMonth() + 1)
                this.monthsTo[it].selected = true;
            else
                this.monthsTo[it].selected = false;
        }

        this.lgDateModal.show();

    }

    fnModalConfirmationClick(event: any) {
        if (event == "Save Market Base") {
            jQuery("#nextModal").modal("hide");
            this.marketBaseService.fnSetLoadingAction(true);
            var filterValues = "";
            this.dynamicPackList.forEach(p => filterValues += ",'" + p.PFC + "'");
            filterValues = filterValues.substr(1);

            //PxR data format
            this.pxrList.forEach((rec:any)=>{
                rec.MarketCode=rec.Code;
            });

            if (this.isEditMarketBase) {
                this.marketBase = {
                    Id: this.marketBase.Id, Name: this.marketBaseName, Description: this.marketBaseName, DurationFrom: this._getFormattedDate(this.StartDate),
                    DurationTo: this._getFormattedDate(this.EndDate), Suffix: this.marketBaseSuffix, GuiId: this.marketBase.GuiId, BaseType: this.marketBaseType,
                    Filters: [{
                        Id: this.marketBase.Filters[0].Id, Name: this.marketBaseName, Criteria: jQuery("#ddlSelectType").val(), Values: filterValues, IsEnabled: true,
                        IsBaseFilterType: true, IsRestricted: false, MarketBaseId: this.marketBase.Id
                    }]
                };
            }
            else {
                this.marketBase = {
                    Id: 0, Name: this.marketBaseName, Description: this.marketBaseName, DurationFrom: this._getFormattedDate(this.StartDate),
                    DurationTo: this._getFormattedDate(this.EndDate), Suffix: this.marketBaseSuffix, GuiId: "", BaseType: this.marketBaseType,
                    Filters: [{
                        Id: 0, Name: this.marketBaseName, Criteria: jQuery("#ddlSelectType").val(), Values: filterValues, IsEnabled: true,
                        IsBaseFilterType: true, IsRestricted: false, MarketBaseId: 0
                    }]
                };
            }

            if (this.showPacks) {
                if (!this.isEditMarketBase) {
                    this.marketBaseService.saveMarketBase(+this.currentClientID, this.marketBase).subscribe((data: MarketBase[]) => {
                        this.marketBaseService.fnSetLoadingAction(false);
                        this.paramID = data[0].Id.toString();
                        this.editableMarketBaseID = +this.paramID;
                        this.fnResetTempVariable();
                        jQuery("#nextModal").modal("hide");
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "Create Market base to post service";
                        this.modalTitle = "Market Base has been successfully saved";
                        this.modalCloseBtnCaption = "Ok";
                        jQuery("#customModal").modal("show");
                    },
                        (err: any) => {
                            this.marketBaseService.fnSetLoadingAction(false);
                            console.log(err);
                        }
                    );
                }
                else {
                    this.marketBaseService.editMarketBase(+this.currentClientID, +this.paramID, this.marketBase).subscribe((data: any) => {
                        this.marketBaseService.fnSetLoadingAction(false);
                        this.paramID = data.Id.toString();
                        this.editableMarketBaseID = +this.paramID;
                        this.fnResetTempVariable();
                        jQuery("#nextModal").modal("hide");
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "Create Market base to post service";
                        this.modalTitle = "Market Base has been saved";
                        this.modalCloseBtnCaption = "Ok";
                        jQuery("#customModal").modal("show");
                    },
                        (err: any) => {
                            this.marketBaseService.fnSetLoadingAction(false);
                            console.log(err);
                        }
                    );
                }
            }

            //else{
            //    this.marketBase = { Id: 100, Name: this.marketBaseName, Suffix: this.marketBaseSuffix, Description: "", DurationTo: this.EndDate.toString(), DurationFrom: this.StartDate.toString(), Filters: this.baseFilterList };
            //    console.log('saving market base');
            //    console.log(this.marketBase);
            //    this.marketBaseService.saveMarketBasePacks(this.marketBase).subscribe((data: any) => {
            //        jQuery("#nextModal").modal("hide");
            //        this.modalSaveBtnVisibility = false;
            //        this.modalSaveFnParameter = "";
            //        this.modalTitle = "Market Base has been successfully saved";
            //        this.modalCloseBtnCaption = "Ok";
            //        jQuery("#customModal").modal("show");
            //    },
            //        (err: any) => {
            //            console.log(err);
            //        }
            //    );
            //}
        }
        else if (event == "Restore Market Base") {
            this.ngOnInit();
            this.ngAfterViewInit();
            jQuery("#nextModal").modal("hide");
            this.isChangeDetectedInMarketBase = false;
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "No changes have been made to the Market Base";
            this.modalCloseBtnCaption = "Ok";
            jQuery("#customModal").modal("show");
        } else if (event == "Save Marketbase without pack") {
            this.marketBaseService.fnSetLoadingAction(true);
            //this._getFormattedDate(this.EndDate)
             //PxR data format
            this.pxrList.forEach((rec:any)=>{
                rec.MarketCode=rec.Code;
            });

            this.marketBase = { Id: 0, Name: this.marketBaseName, Suffix: this.marketBaseSuffix, Description: "", DurationTo: this._getFormattedDate(this.EndDate), DurationFrom: this._getFormattedDate(this.StartDate), GuiId: "", BaseType: this.marketBaseType, Filters: this.baseFilterList };
            let marketbaseDetails = { Marketbase: this.marketBase, Dimension: this.dimentionList || [],PxR:this.pxrList||[] }
            if (this.isEditMarketBase) {//to save market base during edit
                this.marketBaseService.editMarketBase(Number(this.currentClientID), this.editableMarketBaseID, marketbaseDetails).subscribe((data: any) => {
                    this.modalSaveBtnVisibility = false;
                    this.modalSaveFnParameter = "";
                    //this.modalTitle = "Market Base has been successfully saved";
                    this.modalTitle = data.replace(/"/g, '');
                    this.modalCloseBtnCaption = "Ok";
                    this.marketBaseService.fnSetLoadingAction(false);
                    //console.log(data)
                    //this.editableMarketBaseID = data.Id;
                    this.isEditMarketBase = true;
                    this.fnResetTempVariable();
                    // this.router.navigate(["./marketbase/" + this.currentClientID + "|" + this.editableMarketBaseID]);
                    jQuery("#customModal").modal("show");
                },
                    (err: any) => {
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalTitle = "Market Base has not been saved. Please try again.";
                        this.modalCloseBtnCaption = "Ok";
                        this.marketBaseService.fnSetLoadingAction(false);
                        jQuery("#customModal").modal("show");
                        console.log(err);
                    }
                );
            } else {
                //for new entry
                let marketbaseDetails = { Marketbase: this.marketBase, Dimension: this.dimentionList || [],PxR:this.pxrList||[] }
                this.marketBaseService.saveMarketBase(Number(this.currentClientID), marketbaseDetails).subscribe((data: any) => {
                    this.modalSaveBtnVisibility = false;
                    this.modalSaveFnParameter = "";
                    this.modalTitle = "Market Base has been successfully saved";
                    this.modalCloseBtnCaption = "Ok";
                    this.marketBaseService.fnSetLoadingAction(false);
                    //console.log("date.....");
                    //console.log(data)
                    this.editableMarketBaseID = data[0].Id;
                    this.isEditMarketBase = true;
                    this.fnResetTempVariable();
                    this.router.navigate(["./marketbase/" + this.currentClientID + "|" + this.editableMarketBaseID]);
                    jQuery("#customModal").modal("show");
                },
                    (err: any) => {
                        this.modalSaveBtnVisibility = false;
                        this.modalSaveFnParameter = "";
                        this.modalTitle = "Market Base has not been saved. Please try again.";
                        this.modalCloseBtnCaption = "Ok";
                        this.marketBaseService.fnSetLoadingAction(false);
                        jQuery("#customModal").modal("show");
                        console.log(err);
                    }
                );
            }
            jQuery("#nextModal").modal("hide");
            jQuery("#customModal").modal("hide");
        }
        else {
            jQuery("#nextModal").modal("hide");
            jQuery("#customModal").modal("hide");
        }
    }
    fnModalCloseClick(event: any) {
        jQuery("#nextModal").modal("hide");
        jQuery("#customModal").modal("hide");
        if (event == "Create Market base to post service") {
            this.isEditMarketBase = true;
            this.router.navigate(["./marketbase/" + this.currentClientID + "|" + this.paramID]);
        }
    }
    fnStaticTablePageChange(event: any) {
        this.enabledStaticTableFooterBtns = false;
    }
    fnDynamicTablePageChange(event: any) {
        this.enabledDynamicTableFooterBtns = false;
    }
    fnCheckboxStaticTableClick(event: any) {
        if (jQuery(".checkbox-static-table:checked").length > 0) {
            this.enabledStaticTableFooterBtns = true;
        } else {
            this.enabledStaticTableFooterBtns = false;
        }
    }
    fnCheckboxDynamicTableClick(event: any) {
        if (jQuery(".checkbox-dynamic-table:checked").length > 0) {
            this.enabledDynamicTableFooterBtns = true;
        } else {
            this.enabledDynamicTableFooterBtns = false;
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


            for (let i = 0; i < Number(selectedStaticObjectArry.length - 1); i++) {
                let item = selectedStaticObjectArry[i];
                var selectedStaticInfo = this.staticPackList.filter((rec: Pack) => rec.PFC == item)[0];
                this.staticPackList.splice(this.staticPackList.indexOf(selectedStaticInfo), 1);
                this.dynamicPackList.push(selectedStaticInfo);
            }
            this._updateMarketBase();
            //to disable footer button of static table
            this.enabledStaticTableFooterBtns = false;
            this.fnMarketBaseChangeDetection();
        }
        else {
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
        jQuery(".checkbox-dynamic-table").each(function () {
            if (jQuery(this).prop("checked") == true) {
                selectedDynamicObject = selectedDynamicObject + jQuery(this).attr("data-sectionvalue") + "|";
            }
        });

        if (selectedDynamicObject.length > 0) {
            let selectedDynamicObjectArry = selectedDynamicObject.split("|");
            //to shift dynamic to static           
            for (let i = 0; i < Number(selectedDynamicObjectArry.length - 1); i++) {
                let item = selectedDynamicObjectArry[i];
                var selectedDynamicInfo = this.dynamicPackList.filter((rec: Pack) => rec.PFC == item)[0];
                this.dynamicPackList.splice(this.dynamicPackList.indexOf(selectedDynamicInfo), 1);//remove form dynamic
                this.staticPackList.push(selectedDynamicInfo);//push in static
            }
            this.fnMarketBaseChangeDetection();
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Packs move to Available Pack List from market base packs.";
            this.modalBtnCapton = "Save";
            this.modalCloseBtnCaption = "OK";
            jQuery("#nextModal").modal("show");
            this._updateMarketBase();
            //to disable footer btns of dynamic table
            this.enabledDynamicTableFooterBtns = false;

        } else {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "Please select item(s) to remove from market base packs list.";
            this.modalBtnCapton = "Save";
            jQuery("#nextModal").modal("show");
            return;
        }
    }

    fnApplyCriteria(): void {

        this.marketBaseService.fnSetLoadingAction(true);
        let ddSelectedVal = this.marketBaseType;
        let baseFilterCriteriaExists: boolean = false;
        //this.marketBaseName = ddSelectedVal + ' ';
        this.marketBaseName = ddSelectedVal;
        this.baseFilterList = [];
        this.baseFilterTypeList = [];

        if (this.atc1List.length > 0) {
            this.baseFilterList.push({ Id: 1, MarketBaseId: 2, Name: 'ATC1', Criteria: "ATC1", Values: this.getCSV(this.atc1List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'atc1' ? true : false });
        }
        if (this.atc2List.length > 0) {
            this.baseFilterList.push({ Id: 2, MarketBaseId: 2, Name: 'ATC2', Criteria: "ATC2", Values: this.getCSV(this.atc2List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'atc2' ? true : false });
        }
        if (this.atc3List.length > 0) {
            this.baseFilterList.push({ Id: 3, MarketBaseId: 2, Name: 'ATC3', Criteria: "ATC3", Values: this.getCSV(this.atc3List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'atc3' ? true : false });
        }
        if (this.atc4List.length > 0) {
            this.baseFilterList.push({ Id: 4, MarketBaseId: 2, Name: 'ATC4', Criteria: "ATC4", Values: this.getCSV(this.atc4List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'atc4' ? true : false });
        }
        if (this.nec1List.length > 0) {
            this.baseFilterList.push({ Id: 5, MarketBaseId: 2, Name: 'NEC1', Criteria: "NEC1", Values: this.getCSV(this.nec1List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'nec1' ? true : false });
        }
        if (this.nec2List.length > 0) {
            this.baseFilterList.push({ Id: 6, MarketBaseId: 2, Name: 'NEC2', Criteria: "NEC2", Values: this.getCSV(this.nec2List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'nec2' ? true : false });
        }
        if (this.nec3List.length > 0) {
            this.baseFilterList.push({ Id: 7, MarketBaseId: 2, Name: 'NEC3', Criteria: "NEC3", Values: this.getCSV(this.nec3List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'nec3' ? true : false });
        }
        if (this.nec4List.length > 0) {
            this.baseFilterList.push({ Id: 8, MarketBaseId: 2, Name: 'NEC4', Criteria: "NEC4", Values: this.getCSV(this.nec4List, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'nec4' ? true : false });
        }
        if (this.manufacturerList.length > 0) {
            this.baseFilterList.push({ Id: 9, MarketBaseId: 2, Name: 'Manufacturer', Criteria: "Manufacturer", Values: this.getCSV(this.manufacturerList, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'manufacturer' ? true : false });
        }
        if (this.productList.length > 0) {
            this.baseFilterList.push({ Id: 10, MarketBaseId: 2, Name: 'Product', Criteria: "Product", Values: this.getCSV(this.productList, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'product' ? true : false });
        }
        if (this.moleculeList.length > 0) {
            this.baseFilterList.push({ Id: 11, MarketBaseId: 2, Name: 'Molecule', Criteria: "Molecule", Values: this.getCSV(this.moleculeList, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'molecule' ? true : false });
        }

        if (this.checkedBrandingDD) {
            let selectedBrandingVal = jQuery("#ddBranding").val();
            this.baseFilterList.push({ Id: 12, MarketBaseId: 2, Name: 'Branding', Criteria: "Branding", Values: selectedBrandingVal, IsEnabled: true, IsRestricted: false, IsBaseFilterType: false });
        }
        if (this.checkedFlaggingDD) {
            let selectedFlaggingVal = jQuery("#ddFlagging").val();
            this.baseFilterList.push({ Id: 13, MarketBaseId: 2, Name: 'Flagging', Criteria: "Flagging", Values: selectedFlaggingVal, IsEnabled: true, IsRestricted: false, IsBaseFilterType: false });
        }

        if (this.poisonScheduleList.length > 0) {
            this.baseFilterList.push({ Id: 11, MarketBaseId: 2, Name: 'PoisonSchedule', Criteria: "PoisonSchedule", Values: this.getCSV(this.poisonScheduleList, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'poisonschedule' ? true : false });
        }
        if (this.formList.length > 0) {
            this.baseFilterList.push({ Id: 11, MarketBaseId: 2, Name: 'Form', Criteria: "Form", Values: this.getCSV(this.formList, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'form' ? true : false });
        }
        if (this.pxrList.length > 0) {
            this.baseFilterList.push({ Id: 11, MarketBaseId: 2, Name: 'PxR', Criteria: "PxRCode", Values: this.getCSV(this.pxrList, 'Code'), IsEnabled: true, IsRestricted: false, IsBaseFilterType: ddSelectedVal.toLowerCase() == 'pxrcode' ? true : false });
        }



        //to check base criteria exists
        this.baseFilterList.forEach((record: BaseFilter, index: any) => {
            if (record.Values == '\'Ethical\',\'Proprietary\'' || record.Values == '\'Branded\',\'Generic\'') {

            } else {
                //this.marketBaseName = this.marketBaseName + ' ' + record.Values + ' ';
            }

            if (record.IsBaseFilterType == true) {
                baseFilterCriteriaExists = true;

                //to make basefilter first row of row in add/restrict 
                this.baseFilterTypeList.push({ Id: 1, MarketBaseId: 2, Name: record.Name, Criteria: record.Criteria, Values: record.Values, IsEnabled: record.IsEnabled, IsRestricted: record.IsRestricted, IsBaseFilterType: record.IsBaseFilterType });
            } else {
                return true;
            }
        });



        this.baseFilterListForView = this.baseFilterList.filter((record: BaseFilter, index: any) => {//to remove flagging all & branding all
            if (record.Values == '\'Ethical\',\'Proprietary\'' || record.Values == '\'Branded\',\'Generic\'') {
                return false;
            } else {
                return true;
            }
        });

        this.marketBaseName = this.marketBaseName.replace(/\'/g, '');;
        //to check criteria of seceted market base
        if (!baseFilterCriteriaExists) {
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = "You have selected <b>" + this.marketBaseType + " </b> market base but criteria of this market base is empty. Please select one criteria of this market base.";
            this.modalBtnCapton = "Yes";
            this.modalCloseBtnCaption = "Ok";
            this.marketBaseService.fnSetLoadingAction(false);
            this.marketBaseName = "";
            jQuery("#nextModal").modal("show");
            return;
        }

        if (!ddSelectedVal.includes('Packs')) {
            this.descDivVisible = true;
            this._generateMarketBaseDescription(ddSelectedVal);
        }
        this.marketBaseService.fnSetLoadingAction(false);
        this.fnMarketBaseChangeDetection();
    }

    private _generateMarketBaseDescription(selectedMarketBaseType: string) {
        selectedMarketBaseType = selectedMarketBaseType.toUpperCase();
        if (selectedMarketBaseType.includes('ATC') || selectedMarketBaseType.includes('NEC')) {
            this.marketBaseDescription = selectedMarketBaseType + '=';
        }
        else {
            this.marketBaseDescription = '';
        }
        this.marketBaseDescription += this.baseFilterList.filter(x => x.Criteria.toUpperCase() == selectedMarketBaseType)[0].Values;
        this.tempBaseFilterList = [];
        this.baseFilterList.forEach((record: BaseFilter, index: any) => {
            if (record.Criteria.toUpperCase() != selectedMarketBaseType) {
                this.tempBaseFilterList.push(Object.create(record));
            }
        });



        if (this.tempBaseFilterList.length > 0) {
            var tempLastFilterValue = this.tempBaseFilterList[this.tempBaseFilterList.length - 1].Values;
            //this.tempBaseFilterList[this.tempBaseFilterList.length - 1].Values = tempLastFilterValue.substring(0, tempLastFilterValue.length - 2);
            this.tempBaseFilterList.forEach(x => {
                if (x.IsRestricted == true) {
                    x.Criteria = 'excluding ' + x.Criteria;
                }
            });
        }
    }

    private getCSV(arr: any[], key: string) {
        arr = arr.filter((rec: any, index: any) => { if (rec.Code != "") { return true; } else { return false; } })
        return arr.map(function (obj) {
            return "'" + obj[key] + "'";
        }).join(',');
    }

    fnCreateBaseCriteriaArray(values: any, FilterName: any) {
        let returnArray: any[] = [];
        if (values.indexOf(',') > 0) {
            let valuesArray = values.trim().split("',");
            for (let i = 0; i < valuesArray.length; i++) {
                returnArray.push({ Code: valuesArray[i].replace(/\'/g, ''), FilterName: FilterName });
            }
        } else {
            returnArray.push({ Code: values.replace(/\'/g, ''), FilterName: FilterName });
        }
        return returnArray;
    }

    fnChangeRestrictedVal(event: any, type: string, record: BaseFilter) {
        if (type == 'Restrict') {
            this.baseFilterList.every((rec: BaseFilter, index: any) => {
                if (rec.Criteria == record.Criteria) {
                    rec.IsRestricted = true;

                    return false;
                } else {
                    return true;
                }
            });

            //to set marketbase name for restric type

            //to set marketbase desc for restrict type
            //console.log('record.criteria: ', JSON.stringify(record.Criteria));
            //console.log('TempBaseFilterList: ', JSON.stringify(this.tempBaseFilterList));
            var restrictedRecord = this.tempBaseFilterList.filter(x => !x.Criteria.includes('excluding') && x.Criteria == record.Criteria)[0];
            //console.log('RESTRICTED RECORD: ', restrictedRecord);
            if (restrictedRecord) {
                let marketBaseNameRestircted = this.marketBaseName.replace(record.Values.replace(/\'/g, ''), 'excl. ' + record.Values.replace(/\'/g, ''));
                //this.marketBaseName = marketBaseNameRestircted;
                this.tempBaseFilterList.filter(x => x.Criteria == record.Criteria)[0].Criteria = 'excluding ' + restrictedRecord.Criteria;
            }

        } else if (type == 'Add') {
            this.baseFilterList.every((rec: BaseFilter, index: any) => {
                if (rec.Criteria == record.Criteria) {
                    rec.IsRestricted = false;
                    return false;
                } else {
                    return true;
                }
            });
            //to set marketbase name for add type
            //this.marketBaseName = this.marketBaseName.replace('excl. ' + record.Values.replace(/\'/g, ''), record.Values.replace(/\'/g, ''));
            //to set marketbase desc for add type
            var restrictedRecord = this.tempBaseFilterList.filter(x => x.Criteria.replace('excluding ', '') == record.Criteria)[0];
            //console.log('restricted record-', restrictedRecord, ':', 'record-', record.Criteria);
            this.tempBaseFilterList.filter(x => x.Criteria.replace('excluding ', '') == record.Criteria)[0].Criteria = restrictedRecord.Criteria.replace('excluding ', '');
        }

    }

    fnChangeMarketBaseCheckbox(type: string, event: any) {
        let checkboxVal = event.target.checked;
        if (type.toLowerCase() == "flagging") {
            if (checkboxVal) { this.checkedFlaggingDD = true; } else { this.checkedFlaggingDD = false; }
        } else if (type.toLowerCase() == "branding") {
            if (checkboxVal) { this.checkedBrandingDD = true; } else { this.checkedBrandingDD = false; }
        }
        else if (type.toLowerCase() == "atc1") { if (!checkboxVal) { this.atc1List = []; } }
        else if (type.toLowerCase() == "atc2") { if (!checkboxVal) { this.atc2List = []; } }
        else if (type.toLowerCase() == "atc3") { if (!checkboxVal) { this.atc3List = []; } }
        else if (type.toLowerCase() == "atc4") { if (!checkboxVal) { this.atc4List = []; } }
        else if (type.toLowerCase() == "nec1") { if (!checkboxVal) { this.nec1List = []; } }
        else if (type.toLowerCase() == "nec2") { if (!checkboxVal) { this.nec2List = []; } }
        else if (type.toLowerCase() == "nec3") { if (!checkboxVal) { this.nec3List = []; } }
        else if (type.toLowerCase() == "nec4") { if (!checkboxVal) { this.nec4List = []; } }
        else if (type.toLowerCase() == "product") { if (!checkboxVal) { this.productList = []; } }
        else if (type.toLowerCase() == "molecule") { if (!checkboxVal) { this.moleculeList = []; } }
        else if (type.toLowerCase() == "manufacturer") { if (!checkboxVal) { this.manufacturerList = []; } }
        else if (type.toLowerCase() == "poisonschedule") { if (!checkboxVal) { this.poisonScheduleList = []; } }
        else if (type.toLowerCase() == "form") { if (!checkboxVal) { this.formList = []; } }
        else if (type.toLowerCase() == "pxrcode") { if (!checkboxVal) { this.pxrList = []; } }
    }

    fnMarketBaseChangeDetection() {
        //console.log('fnMarketBaseChangeDetection');
        //console.log(this.tempStartDate);
        //console.log(this.EndDate);
        this.authService.hasUnSavedChanges = true;
        if (JSON.stringify(this.marketBase) == JSON.stringify(this.tempMarketBase) && JSON.stringify(this.baseFilterList) == JSON.stringify(this.temporaryBaseFilterList) &&
            this._getFormattedDate(this.StartDate) == this._getFormattedDate(this.tempStartDate) && this._getFormattedDate(this.EndDate) == this._getFormattedDate(this.tempEndDate) && this.marketBaseSuffix == this.tempMarketBaseSuffix &&
            JSON.stringify(this.dynamicPackList) == JSON.stringify(this.tempDynamicPackList)) {
            this.isChangeDetectedInMarketBase = false;
        } else {
            this.isChangeDetectedInMarketBase = true;
        }
    }

    fnDeleteMarketbase() {
        this.alertService.fnLoading(true)
        this.marketBaseService.getEffectedMarketDefName(+this.editableMarketBaseID, +this.currentClientID).subscribe((data: string) => {
            this.alertService.fnLoading(false);
            if (data == "") {//there are no market definition related with this marketbase
                this.alertService.confirm("Do you want to delete market base <b>" + this.marketBaseName + " " + this.marketBaseSuffix + " </b>?",
                    () => {
                        this.fnFinallyDeleteMarketbase();
                    },
                    () => { });
                return false;
            } else {
                let confMessage = "Deleting market base <b>" + this.marketbaseFullName + " </b> will have effect on market definitions <b>" + data + "</b>, which may affect your deliverables using these definitions.Would you like to proceed?<br/>\
                        <div class='mgs-note'>Note: The system may take up to 24 hours for these changes to take effect in existing definitions and deliverables. To immediately reflect these changes please edit the definitions from the Market module.</div>";

                this.alertService.confirm(confMessage,
                    () => {
                        this.fnFinallyDeleteMarketbase();
                    },
                    () => { });
                return false;
            }
        },
            (err: any) => {
                this.alertService.fnLoading(false);
                console.log(err);
            }
        );

    }

        fnFinallyDeleteMarketbase() {
        this.marketBaseService.deleteMarketBase(+this.currentClientID, this.editableMarketBaseID).subscribe(
            (success: any) => {
                this.atc1List = [];
                this.atc2List = []; this.atc3List = []; this.atc4List = [];
                this.nec1List = []; this.nec2List = []; this.nec3List = []; this.nec4List = [];
                this.manufacturerList = []; this.moleculeList = []; this.productList = [];
                this.dimentionList = []; this.poisonScheduleList = []; this.formList = [],this.pxrList=[];

                this.baseFilterList = [];
                this.baseFilterTypeList = [];
                this.baseFilterListForView = [];
                this.temporaryBaseFilterList = [];

                this.marketBaseName = "";
                this.editableMarketBaseID = 0;
                this.marketBaseSuffix = "";
                this.isEditMarketBase = false;
                this.descDivVisible = false;
                this.router.navigate(["./marketbase/" + this.currentClientID]);
                this.alertService.alert(success.replace(/"/g,''));
            },
            (error: any) => {
                console.log("error");
            }
        );
    }

    fnResetTempVariable() {
        this.tempMarketBase = JSON.parse(JSON.stringify(this.marketBase));
        this.temporaryBaseFilterList = JSON.parse(JSON.stringify(this.baseFilterList));
        this.tempStartDate = this.StartDate;
        this.tempEndDate = this.EndDate;
        this.tempMarketBaseSuffix = this.marketBaseSuffix;
        this.tempDynamicPackList = JSON.parse(JSON.stringify(this.dynamicPackList));
        this.isChangeDetectedInMarketBase = false;
    }

    SubmitMarketBase(): void {
        this.alertService.fnLoading(true);
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        this.marketBaseService.submitMarketBase(this.marketBase.Id, userid).subscribe((data: any) => {
            this.alertService.fnLoading(false);
            this.alertService.alert("Marketbase submitted successfully.");
        },
            (err: any) => {
                this.alertService.fnLoading(false);
                console.log(err);
            }
        );
    }

    NavigateToBack() {
        var url = this.breadCrumbUrl;
        this.router.navigate([url, this.currentClientID + "|0"]);
    }
}