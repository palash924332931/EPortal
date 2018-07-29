import { Component, OnInit, ViewChild, HostListener } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Client } from '../shared/models/client';
import { CLIENTS } from '../shared/models/mock-clients';

import { ClientService } from '../shared/services/client.service';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';
import { ConfigService } from '../config.service';
import { ModalDirective } from 'ng2-bootstrap';
import { DeliverableService } from './deliverables-edit.service';
import { Frequency } from './deliverables.model';
import { Period } from './deliverables.model';
import { ReportWriter, PeriodForFrequency } from './deliverables.model';
import { Restriction } from './deliverables.model';
import { ClientMarketDefDTO } from './deliverables.model';
import { ClientTerritoryDTO } from './deliverables.model';
import { ClientsDTO } from './deliverables.model';
import { DeliverablesDTO, SubChannelsDTO, DataType, EntityType } from './deliverables.model';
import { months } from '../subscription/subscription.model';
import { months2 } from '../subscription/subscription.model';
import { ComponentCanDeactivate, DeactivateGuard } from '../security/deactivate-guard';
import { Observable } from 'rxjs/Observable';

declare var jQuery: any;


@Component({
    selector: 'deliverable-edit',
    templateUrl: '../../app/deliverables/deliverables-edit.html',
    styleUrls: ['../../app/market-view/clients-sidebar.css', '../../app/subscription/subscription.css', '../../app/deliverables/deliverables.css']
})
export class DeliverablesEditComponent implements OnInit, ComponentCanDeactivate {
    @ViewChild('DelErrorModal') DelErrorModal: ModalDirective
    @ViewChild('lgDelMktModal') lgDelMktModal: ModalDirective
    @ViewChild('lgDelTerModal') lgDelTerModal: ModalDirective
    @ViewChild('lgDelDateModal') lgDelDateModal: ModalDirective
    @ViewChild('lgDelClntModal') lgDelClntModal: ModalDirective
    @ViewChild('lgDelSaveModal') lgDelSaveModal: ModalDirective

    @HostListener('window:beforeunload',  ['$event'])
    canDeactivate(): Observable<boolean> | boolean {
        //console.log('this.authService.isTimeout ' + this.authService.isTimeout);
        if (this.initialvalue != JSON.stringify(this.SavedeliverablesList) == true && this.canNavigate == false) {
            //console.log('canDeactivate =' + this.authService.isTimeout);
            if (this.authService.isTimeout == true) {
                return true;
            }
            else {
                return false;
            }
        }
        else {
            //if (this.authService.isTimeout == true)
            //this.ReleaseLock();
            this.clientService.fnSetLoadingAction(true);
            try {
                this.deactiveGuard.fnReleaseLock(this.usrObj.UserID, this.editDeliverableID, 'Delivery Module', this.lockType, 'Release Lock').then(result => { this.clientService.fnSetLoadingAction(false); });
            } catch (ex) {
                this.clientService.fnSetLoadingAction(false);
            }
            this.clientService.fnSetLoadingAction(false);
            //console.log('canDeactivate =true');
            return true;
        }
    }
    @HostListener('window:unload', ['$event'])
    unloadHandler(event)  {
        this.clientService.fnSetLoadingAction(true);
        try {
            this.deactiveGuard.fnReleaseLock(this.usrObj.UserID, 0, '', '', 'Release Lock All').then(result => { console.log('Released all locks'); });
        } catch (ex) {
            this.clientService.fnSetLoadingAction(false);
        }
        this.clientService.fnSetLoadingAction(false);
    }
    canNavigate: boolean = false;
   // @ViewChild('lgModal') lgModal: ModalDirective
    editClientID: number;
    editDeliverableID: number;
    FrequncyList: Frequency[] = [];
    PeriodList: Period[] = [];
    PeriodListSaved: Period[] = [];
    ReportWriterList: ReportWriter[] = [];
    PeriodForFrequencyList: PeriodForFrequency[] = [];
    RestrictionList: Restriction[] = [];
    ClientMarketDefList: ClientMarketDefDTO[] = [];
    FilteredClientMarketDefList: ClientMarketDefDTO[] = [];
    ClientTerritoryList: ClientTerritoryDTO[] = [];
    FilteredClientTerritoryList: ClientTerritoryDTO[] = [];
    ClientList: ClientsDTO[] = [];
    FilteredClientList: ClientsDTO[] = [];
    deliverablesList: DeliverablesDTO[] = [];
    SavedeliverablesList: any;

    IsCheckAllMktEnabled: boolean = true;
    IsCheckAllMktSelected: boolean = true;
    IsCheckAllTerEnabled: boolean = true;
    IsCheckAllTerSelected: boolean = true;
    IsCheckAllClientEnabled: boolean = true;
    IsCheckAllClientSelected: boolean = true;

    private curFromYear: number;
    private curToYear: number;
    monthsFrom: any = [];
    monthsTo: any = [];
    private years: number[] = [];
    private mon: string;
    validationMsg: string;
    Invalid: boolean;
    mktDeflistCount: number;
    terDeflistCount: number;
    isTerrMandatory: boolean;

    createMarketLink: string;
    createTerritoryLink: string;
    breadCrumbLink: string;
    bredCrumbName: string;

    deliverableMessage: string;
    isSuccess: boolean;

    public modalTitle = '<span >White here....?</span>';
    public modalSaveBtnVisibility: boolean = false;
    public modalSaveFnParameter: string = "";
    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Cancel";

    CanViewContent: boolean = false;
    CanEditContent: boolean = false;
    CanAddMktDef: boolean = false;
    CanAddTerDef: boolean = false;
    CanDelMktDef: boolean = false;
    CanDelTerDef: boolean = false;
    CanAddClient: boolean = false;
    isMyclientsSelected: boolean = false;
    isMyClientsVisible: boolean = false;
    tempUserPermission: UserPermission[] = [];
    CanEditSubchannel: boolean = false;
    CanEditIRPReportNumber: boolean = false;

    SaveMessage: string;
    public lockType: string;
    usrObj: any;
    subChannels: SubChannelsDTO[] = [];

    constructor(private clientService: ClientService, private deliverableService: DeliverableService, public route: ActivatedRoute,
        private _cookieService: CookieService, private authService: AuthService, private deactiveGuard: DeactivateGuard,
        private router: Router) {
        this.usrObj = this._cookieService.getObject('CurrentUser');

    }

    ngOnInit(): void {
        //console.log('this.route.snapshot.params ' + this.route.snapshot.params);
        let paramID: string = this.route.snapshot.params['id'];
        this.lockType = this.route.snapshot.params['id2'];
        if (paramID != "" && paramID != "undefined" && typeof paramID != 'undefined') {
            if (paramID.indexOf('|') > 0) {
                this.editClientID = Number(paramID.split("|")[0]);
                this.editDeliverableID = Number(paramID.split("|")[1]);
                this.isMyclientsSelected = (Number(paramID.split("|")[2]) == 1 ? true : false);
                this.isMyClientsVisible = (Number(paramID.split("|")[3]) == 1 ? true : false);
                
                //alert('this.lockType ' + this.lockType);
                this.deactiveGuard.fnNewLock(this.usrObj.UserID, this.editDeliverableID, "Delivery Module", this.lockType, "Create Lock")
                    .then(result => { })
                    .catch((err: any) => { this.clientService.fnSetLoadingAction(false); });
            } else {
                // this.editClientID = Number(paramID);
                this.editDeliverableID = Number(paramID);
            }

        } else {
            this.editClientID = 0;
            this.editDeliverableID = 0;
            this.isMyclientsSelected = false;
        }

        this.createMarketLink = "/market/My-Client";
        this.createTerritoryLink = "/territory/My-Client";
        this.breadCrumbLink = '/subscription/myclients';
        if (this.isMyClientsVisible == true) {
            this.bredCrumbName = "My Clients";
            this.breadCrumbLink = "/subscription/myclients";
        }
        else {
            this.bredCrumbName = "All Clients";
            this.breadCrumbLink = "/subscriptions/allclients";
        }
        if (jQuery(".dropdown-menu li:contains('My Subscription')").length > 0) {
            this.isMyclientsSelected = true;
            this.isMyClientsVisible = true;
            this.bredCrumbName = "My Subscription";
            this.breadCrumbLink = "/subscription/myclients";
        }
        //this.clientService.fnSetLoadingAction(true);
        //this.getLookupData(this.editClientID);
        //this.getMarketDefs();
        //this.getTerritories();
        //this.getClients();
        //this.getDeliverable(this.editDeliverableID );
        //this.loadUserData();
        //this.monthsFrom = months;
        //this.monthsTo = months2;
       // this.UpdateLock();
        this.Reload();
        //this.SaveMessage = "Deliverable settings have been saved.";
    }

    isChanged: boolean = false;


    checkBeforeNavigate(event: any, link: string) {
        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "checkSaveChanges";
        this.modalTitle = '<span>Changes made to the Deliverable settings will not apply. Would you like to proceed?</span>';
        this.modalBtnCapton = "Yes";

        this.isDeliverableSettingsChnaged();
        if (this.isChanged) {
            jQuery("#nextModal").modal("show");
        } else {
            this.router.navigate([link]);
        }
        return false;
    }

    isDeliverableSettingsChnaged(): void {
        this.isChanged = false;
        this.canNavigate = false;
        if (this.initialvalue != JSON.stringify(this.SavedeliverablesList)) {
            this.isChanged = true;
        }
    }


    getLookupData(clientId: number) {
        this.deliverableService.getFrequencye(this.editDeliverableID, clientId).subscribe(
            (data: any) => { this.FrequncyList = data },
            (err: any) => {
                this.DelErrorModal.show();
                console.log(err); this.clientService.fnSetLoadingAction(false);
            },
            () => console.log('frequency loaded')
        );
        this.deliverableService.getPeriod(this.editDeliverableID, clientId).subscribe(
            (data: any) => { this.PeriodList = data; this.PeriodListSaved = data; },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Period loaded')
        );
        this.deliverableService.getRestrictions(this.editDeliverableID, '', clientId).subscribe(
            (data: any) => { this.RestrictionList = data },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('restrictions loaded')
        );
        this.deliverableService.getReportWriters(this.editDeliverableID, clientId).subscribe(
            (data: any) => { this.ReportWriterList = data },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Reportwriter loaded')
        );

        this.deliverableService.getPeriodForFrequency().subscribe(
            (data: any) => {
                this.PeriodForFrequencyList = data
            },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('PeriodForFrequencyList loaded')
        );

    }
    getMarketDefs() {
        //this.clientService.fnSetLoadingAction(true);
        this.deliverableService.getMarketDefinition(this.editClientID, this.editDeliverableID).subscribe(
            (data: any) => { this.ClientMarketDefList = data, this.FilteredClientMarketDefList = data, this.setMarketPagination(), console.log(this.ClientMarketDefList) },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('market definition loaded')
        );
    }
    getTerritories() {
        //this.clientService.fnSetLoadingAction(true);
        this.deliverableService.getTerritories(this.editClientID, this.editDeliverableID).subscribe(
            (data: any) => { this.ClientTerritoryList = data, this.FilteredClientTerritoryList = data, this.setTerritoryPagination(), console.log(this.ClientTerritoryList) },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Territory definition loaded')
        );
    }
    getClients() {
        this.deliverableService.getDeliveryClients(this.editClientID).subscribe(
            (data: any) => { this.ClientList = data, this.FilteredClientList = data, this.setClientPagination(), console.log(this.ClientList) },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Client list loaded')
        );
    }
    initialvalue: string = "";
    getDeliverable(deliveryid: number, clientid: number) {
        this.deliverableService.getDeliverablesById(deliveryid, clientid).subscribe(
            (data: any) => {
                data.SubChannelsDTO.forEach(s => {
                    this.checkDataTypeSelction(s);
                });
                
                this.initialvalue = JSON.stringify(data), this.deliverablesList = data, this.SavedeliverablesList = this.deliverablesList, this.checkMktCount(this.SavedeliverablesList),
                    this.checkTerCount(this.SavedeliverablesList), console.log('delivery=' + this.deliverablesList)

                this.loadPeriodBasedOnFrequency(data.FrequencyId);
            },
            (err: any) => {
                this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('delivery list loaded')
        );
    }
    public mktDeftotalItems: number = this.ClientMarketDefList.length;
    public territorytotalItems: number = this.ClientTerritoryList.length;
    public ClienttotalItems: number = this.ClientList.length;

    public CurrentPage: number = 1;
    public itemsPerPage: number = 10;
    public MarketDefsByPage: any[] = [];
    public TerritoryByPage: any[] = [];
    public ClientByPage: any[] = [];

    public PageChangedMarket(event: any): void {
        this.CurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.MarketDefsByPage = this.FilteredClientMarketDefList.slice(startIndex, endIndex)
    }

    searchMarketDef: string = "";
    searchClientMarketDef() {
        this.FilteredClientMarketDefList = this.ClientMarketDefList.filter(x => x.Name.toLowerCase()
            .indexOf(this.searchMarketDef.toLowerCase()) >= 0);
        this.setMarketPagination();
    }

    setMarketPagination(): void {
        this.itemsPerPage = 10;
        this.mktDeftotalItems = this.FilteredClientMarketDefList.length;
        //this.itemsPerPage = (this.mktDeftotalItems >= this.itemsPerPage) ? this.itemsPerPage : this.ClientMarketDefList.length;
        this.PageChangedMarket({ page: 1, itemsPerPage: this.itemsPerPage })
    }
    public PageChangedTerritory(event: any): void {
        this.CurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.TerritoryByPage = this.FilteredClientTerritoryList.slice(startIndex, endIndex)
    }

    searchTerritory: string = "";
    searchTerritories() {
        this.FilteredClientTerritoryList = this.ClientTerritoryList.filter(x => x.Name.toLowerCase()
            .indexOf(this.searchTerritory.toLowerCase()) >= 0);
        this.setTerritoryPagination();
    }

    setTerritoryPagination(): void {
        this.itemsPerPage = 10;
        this.territorytotalItems = this.FilteredClientTerritoryList.length;
        //this.itemsPerPage = (this.territorytotalItems >= this.itemsPerPage) ? this.itemsPerPage : this.ClientTerritoryList.length;
        this.PageChangedTerritory({ page: 1, itemsPerPage: this.itemsPerPage })
    }
    public PageChangedClient(event: any): void {
        this.CurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.ClientByPage = this.FilteredClientList.slice(startIndex, endIndex)
    }

    searchClient: string = "";
    searchClients() {
        this.FilteredClientList = this.ClientList.filter(x => x.Name.toLowerCase()
            .indexOf(this.searchClient.toLowerCase()) >= 0);
        this.setClientPagination();
    }

    setClientPagination(): void {
        this.itemsPerPage = 10;
        this.ClienttotalItems = this.FilteredClientList.length;
        //this.itemsPerPage = (this.ClienttotalItems >= this.itemsPerPage) ? this.itemsPerPage : this.ClientList.length;
        this.PageChangedClient({ page: 1, itemsPerPage: this.itemsPerPage })
    }
    //setSelectedValues(data: any) {
    //    for (let item in data.marketDefs) {
    //        for (let it in this.ClientMarketDefList) {
    //            if (this.ClientMarketDefList[it].Id == data.marketDefs[item].Id) {
    //                this.ClientMarketDefList[it].selected = true;
    //                this.ClientMarketDefList[it].isSaved = true;
    //            }
    //        }
    //    }
    //}
    checkMktCount(data: any) {
        if (data.marketDefs == undefined || data.marketDefs.length == 0) {
            this.mktDeflistCount = 0;
        }
        else {
            this.mktDeflistCount = data.marketDefs.length;
        }
    }
    checkTerCount(data: any) {
        this.isTerrMandatory = false;
        if (data.SubServiceTerritoryId == 1 || data.SubServiceTerritoryId == 2 || data.SubServiceTerritoryId == 3) {
            this.isTerrMandatory = true;
            if (data.territories == undefined || data.territories.length == 0) {
                this.terDeflistCount = 0;
            }
            else {
                this.terDeflistCount = data.territories.length;
            }
        }
    }
    private ShowMarketDialog(subid: number, clienid: number) {
        this.CurrentPage = 1;
        //if (this.canAddMarketBase) {
        var Mktids = this.getSelectedValues(this.ClientMarketDefList, 'Id');
        for (let i in this.ClientMarketDefList) {
            this.ClientMarketDefList[i].selected = false;
            this.ClientMarketDefList[i].isSaved = false;
        }
        //var mktdef=this.SavedeliverablesList.marketDefs;
        //for (let item in this.SavedeliverablesList.marketDefs) {
        //    for (let it in Mktids) {
        //        if (Mktids[it] == this.SavedeliverablesList.marketDefs[item].Id) {
        //            this.SavedeliverablesList.marketDefs[item].selected = true;
        //            this.SavedeliverablesList.marketDefs[item].isSaved = true;
        //        }
        //    }
        //}
        for (let item in this.SavedeliverablesList.marketDefs) {
            for (let it in this.ClientMarketDefList) {
                if (this.ClientMarketDefList[it].Id == this.SavedeliverablesList.marketDefs[item].Id) {
                    this.SavedeliverablesList.marketDefs[item].selected = true;
                    this.SavedeliverablesList.marketDefs[item].isSaved = true;
                    this.ClientMarketDefList[it].selected = true;
                    this.ClientMarketDefList[it].isSaved = true;
                }
            }
        }
        this.IsCheckAllMktEnabled = true;
        this.IsCheckAllMktSelected = false;
        var selLenth = this.ClientMarketDefList.filter(p => p.selected == true).length;
        var totLen = this.ClientMarketDefList.length;
        if (selLenth == totLen) {
            this.IsCheckAllMktEnabled = false;
            this.IsCheckAllMktSelected = true;
        }
        this.lgDelMktModal.show();
        //}

    }
    private CancelMarketPopup() {
        for (let i in this.ClientMarketDefList) {
            if (this.ClientMarketDefList[i].isSaved == undefined || this.ClientMarketDefList[i].isSaved == false) {
                this.ClientMarketDefList[i].selected = false;
            }
        }
        var selLenth = this.ClientMarketDefList.filter(p => p.selected == true).length;
        var totLen = this.ClientMarketDefList.length;
        if (selLenth == totLen) {
            this.IsCheckAllMktEnabled = false;
            this.IsCheckAllMktSelected = true;
        }
        this.lgDelMktModal.hide();
    }
    private ShowTerritoryDialog(subid: number, clienid: number) {
        this.CurrentPage = 1;
        //if (this.canAddMarketBase) {
        var Terids = this.getSelectedValues(this.ClientTerritoryList, 'Id');


        for (let i in this.ClientTerritoryList) {
            this.ClientTerritoryList[i].selected = false;
            this.ClientTerritoryList[i].isSaved = false;
        }
        //for (let item in this.SavedeliverablesList.territories) {
        //    for (let it in Terids) {
        //        if (Terids[it] == this.SavedeliverablesList.territories[item].Id) {
        //            this.SavedeliverablesList.territories[item].selected = true;
        //            this.SavedeliverablesList.territories[item].isSaved = true;
        //        }

        //    }

        //}
        for (let item in this.SavedeliverablesList.territories) {
            for (let it in this.ClientTerritoryList) {
                if (this.ClientTerritoryList[it].Id == this.SavedeliverablesList.territories[item].Id) {
                    this.SavedeliverablesList.territories[item].selected = true;
                    this.SavedeliverablesList.territories[item].isSaved = true;
                    this.ClientTerritoryList[it].selected = true;
                    this.ClientTerritoryList[it].isSaved = true;
                }
            }
        }
        this.IsCheckAllTerEnabled = true;
        this.IsCheckAllTerSelected = false;
        var selLenth = this.ClientTerritoryList.filter(p => p.selected == true).length;
        var totLen = this.ClientTerritoryList.length;
        if (selLenth == totLen) {
            this.IsCheckAllTerEnabled = false;
            this.IsCheckAllTerSelected = true;
        }
        this.lgDelTerModal.show();
        //}

    }
    private CancelTerritoryPopup() {
        //this.IsCheckAllTerSelected = false;
        for (let i in this.ClientTerritoryList) {
            if (this.ClientTerritoryList[i].isSaved == undefined || this.ClientTerritoryList[i].isSaved == false) {
                this.ClientTerritoryList[i].selected = false;
            }
        }
        var selLenth = this.ClientTerritoryList.filter(p => p.selected == true).length;
        var totLen = this.ClientTerritoryList.length;
        if (selLenth == totLen) {
            this.IsCheckAllTerEnabled = false;
            this.IsCheckAllTerSelected = true;
        }
        this.lgDelTerModal.hide();
    }
    private ShowClientDialog(subid: number, clienid: number) {
        this.CurrentPage = 1;
        var Clientids = this.getSelectedValues(this.ClientList, 'Id');
        for (let i in this.ClientList) {
            this.ClientList[i].selected = false;
            this.ClientList[i].isSaved = false;
        }


        //for (let item in this.SavedeliverablesList.clients) {
        //    for (let it in Clientids) {
        //        if (Clientids[it] == this.SavedeliverablesList.clients[item].Id) {
        //            this.SavedeliverablesList.clients[item].selected = true;
        //            this.SavedeliverablesList.clients[item].isSaved = true;
        //        }

        //    }

        //}
        for (let item in this.SavedeliverablesList.clients) {
            for (let it in this.ClientList) {
                if (this.ClientList[it].Id == this.SavedeliverablesList.clients[item].Id && this.SavedeliverablesList.clients[item].IsThirdparty == this.ClientList[it].IsThirdparty) {
                    this.SavedeliverablesList.clients[item].selected = true;
                    this.SavedeliverablesList.clients[item].isSaved = true;
                    this.ClientList[it].selected = true;
                    this.ClientList[it].isSaved = true;
                }
            }
        }
        this.IsCheckAllClientEnabled = true;
        this.IsCheckAllClientSelected = false;
        var selLenth = this.ClientList.filter(p => p.selected == true).length;
        var totLen = this.ClientList.length;
        if (selLenth == totLen) {
            this.IsCheckAllClientEnabled = false;
            this.IsCheckAllClientSelected = true;
        }
        this.lgDelClntModal.show();
    }
    private CancelClientPopup() {
        this.lgDelClntModal.hide();
    }
    checkAll(ev: any, tp: string) {
        if (tp == 'market') {
            this.ClientMarketDefList.filter(p => p.isSaved != true).forEach(x => x.selected = ev.target.checked);
        }
        else if (tp == 'territory') {
            this.ClientTerritoryList.filter(p => p.isSaved != true).forEach(x => x.selected = ev.target.checked);
        }
        else if (tp == 'client') {
            this.ClientList.filter(p => p.isSaved != true).forEach(x => x.selected = ev.target.checked);
        }
    }


    AddToDelivery(tp: string) {
        // var tempdeliveryList: any = this.deliverablesList;
        if (tp == 'market') {

            //var mktlist = this.ClientMarketDefList.filter(p => p.isSaved != true).forEach(x => x.selected = true);
            for (var key in this.ClientMarketDefList) {
                if (this.ClientMarketDefList[key].isSaved != true && this.ClientMarketDefList[key].selected == true) {
                    this.SavedeliverablesList.marketDefs.push(this.ClientMarketDefList[key]);
                    this.ClientMarketDefList[key].isSaved = true;
                }
            }

            //console.log(this.SavedeliverablesList.marketDefs);
            this.checkMktCount(this.SavedeliverablesList);
            //this.deliverablesList.marketDefs.push(mktlist);
            this.lgDelMktModal.hide();
        }
        else if (tp == 'territory') {
            //this.ClientTerritoryList.filter(p => p.isSaved != true).forEach(x => x.selected = ev.target.checked);
            for (var key in this.ClientTerritoryList) {
                if (this.ClientTerritoryList[key].isSaved != true && this.ClientTerritoryList[key].selected == true) {
                    this.SavedeliverablesList.territories.push(this.ClientTerritoryList[key]);
                }
            }
            this.checkTerCount(this.SavedeliverablesList);
            this.lgDelTerModal.hide();

            var Terids = this.getSelectedID(this.SavedeliverablesList.territories, 'Id');
            this.clientService.fnSetLoadingAction(true);
            var tids = Terids.join();
            this.deliverableService.getRestrictions(this.editDeliverableID, tids, this.editClientID).subscribe(
                (data: any) => { this.RestrictionList = data, this.clientService.fnSetLoadingAction(false) },
                (err: any) => {
                    this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log('restrictions loaded')
            );
        }
        else if (tp == 'client') {
            for (var key in this.ClientList) {
                if (this.ClientList[key].isSaved != true && this.ClientList[key].selected == true) {
                    this.SavedeliverablesList.clients.push(this.ClientList[key]);
                }
            }
            this.lgDelClntModal.hide();
            //this.ClientMarketDefList.filter(p => p.isSaved != true).forEach(x => x.selected = ev.target.checked);
        }
    }

    loadPeriodBasedOnFrequency(frequencyId: number) {
        setTimeout(() => { 
            let frequencies = this.FrequncyList.filter(f => f.FrequencyId == frequencyId);
            if (frequencies.length > 0) {
                let filterPeriod = this.PeriodForFrequencyList.filter(p => p.FrequencyTypeId == frequencies[0].FrequencyTypeId).map(p => p.PeriodId);
                if (filterPeriod.length > 0) {
                    this.PeriodList = this.PeriodListSaved.filter(p => {
                        let index = filterPeriod.indexOf(p.PeriodId);
                        if (index != -1)
                            return true;
                        else
                            return false;
                    });
                }
            }
        });
    }

    dropdownChange(deviceValue: number, tp: string) {
        if (tp == 'frequency') {
            this.SavedeliverablesList.FrequencyId = deviceValue;
            this.loadPeriodBasedOnFrequency(deviceValue);
        }
        else if (tp == 'period') {
            this.SavedeliverablesList.PeriodId = deviceValue;
        }
        else if (tp == 'restriction') {
            this.SavedeliverablesList.RestrictionId = deviceValue;
        }
        else if (tp == 'reportwriter') {
            this.SavedeliverablesList.ReportWriterId = deviceValue;
        }
    }

    UpdateDeliverables() {
        this.clientService.fnSetLoadingAction(true);
        var MktCount: number = this.SavedeliverablesList.marketDefs == undefined ? 0 : this.SavedeliverablesList.marketDefs.length;
        var TerCount: number = this.SavedeliverablesList.territories == undefined ? 0 : this.SavedeliverablesList.territories.length;
        //check territory base is brick, outlet or both

        this.SaveMessage = "Deliverable settings have been saved";
        if (MktCount <= 0) {
            if (this.SavedeliverablesList.SubServiceTerritoryId == 1 || this.SavedeliverablesList.SubServiceTerritoryId == 2 || this.SavedeliverablesList.SubServiceTerritoryId == 3) {
                if (TerCount <= 0) {
                    this.SaveMessage = "Deliverable settings have been saved. Please note that a Market Definition and a Territory Definition must be added for this to be a valid deliverable";
                }
                else {
                    this.SaveMessage = "Deliverable settings have been saved. Please note that a Market Definition must be added for this to be a valid deliverable";
                }
            }
            else {
                this.SaveMessage = "Deliverable settings have been saved. Please note that a Market Definition must be added for this to be a valid deliverable";
            }
        }
        else {
            if (this.SavedeliverablesList.SubServiceTerritoryId == 1 || this.SavedeliverablesList.SubServiceTerritoryId == 2 || this.SavedeliverablesList.SubServiceTerritoryId == 3) {
                if (TerCount <= 0) {
                    this.SaveMessage = "Deliverable settings have been saved. Please note that a Territory Definition must be added for this to be a valid deliverable";
                }
            }
        }
        this.deliverableService.UpdateDeliverables(this.SavedeliverablesList)
            .subscribe(
            r => { this.deliverableMessage = r.message, this.isSuccess = r.isSuccess, this.ReloadAfterUpdate(), console.log('getDeliverable' + this.editClientID); if (this.isSuccess) { this.lgDelSaveModal.show(); }},
            e => (console.log("error" + e), this.clientService.fnSetLoadingAction(false))
            );
        console.log(this.SavedeliverablesList);
        //for (var key in this.deliverablesList) {
        //    console.log(key);
        //}

        //this.deliverableService.getRestrictions(this.editDeliverableID).subscribe(
        //    (data: any) => { this.RestrictionList = data, this.clientService.fnSetLoadingAction(false) },
        //    (err: any) => {
        //        this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
        //        console.log(err);
        //    },
        //    () => console.log('restrictions loaded')
        //);

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
    getYear() {
        var today = new Date();
        var yy = today.getFullYear();
        this.years.push(yy - 1);
        for (var i = (yy); i <= (yy + 50); i++) {
            this.years.push(i);
        }
    }
    getMonth() {
        var today = new Date();
        var mm = today.getMonth() + 1;
        if (mm < 10) {
            this.mon = '0' + mm
        }
    }
    setDefaultMonthYear(fromdt: Date, toDate: Date) {
        //if (this.canEditMarketBase) {
        this.lgDelDateModal.show();
        //console.log('fromdt-' + fromdt);
        var start = new Date(fromdt);
        var end = new Date(toDate);

        var fromYear = start.getFullYear();
        var fromMonth = (start.getMonth() + 1).toString();
        if ((start.getMonth() + 1) < 10) {
            fromMonth = '0' + fromMonth;
        }
        var toYear = end.getFullYear();
        var toMonth = (end.getMonth() + 1).toString();

        if ((end.getMonth() + 1) < 10) {
            toMonth = '0' + toMonth;
        }

        for (let it in this.monthsFrom) {
            if (this.monthsFrom[it].val == fromMonth)
                this.monthsFrom[it].selected = true;
            else
                this.monthsFrom[it].selected = false;
        }
        for (let it in this.monthsTo) {
            if (this.monthsTo[it].val == toMonth)
                this.monthsTo[it].selected = true;
            else
                this.monthsTo[it].selected = false;
        }
        this.curFromYear = fromYear;
        this.curToYear = toYear;
        //}
    }

    UpdateDespatchPeriod() {

        this.Invalid = false;
        var fMonth: string; var tMonth: string;
        for (let it in this.monthsFrom) {
            if (this.monthsFrom[it].selected == true)
                //fMonth = this.monthsFrom[it].val;
                fMonth = this.monthsFrom[it].name;
        }
        for (let it in this.monthsTo) {
            if (this.monthsTo[it].selected == true)
                //tMonth = this.monthsTo[it].val;
                tMonth = this.monthsTo[it].name;
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
            var stDate;
            var enDate;
            stDate = "01/" + fMonth + "/" + this.curFromYear;
            enDate = "01/" + tMonth + "/" + this.curToYear;
            this.SavedeliverablesList.StartDate = stDate;
            this.SavedeliverablesList.EndDate = enDate;
            this.lgDelDateModal.hide();
        }
    }
    DeleteTerritory(id: number, name: string) {
        this.delTerId = id;
        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "delete_territory";
        this.modalTitle = '<span >Would you like to proceed in removing the territory definition ' + name + ' from this deliverable?</span>';
        this.modalBtnCapton = "Yes";
        jQuery("#nextModal").modal("show");
        return false;

    }
    delMktID: number
    delTerId: number;
    delClientId: number;
    delClientThirdparty: boolean;
    DeleteMarketDef(id: number, name: string) {
        this.delMktID = id;
        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "delete_market_def";
        this.modalTitle = '<span >Would you like to proceed in removing the market definition ' + name + ' from this deliverable?</span>';
        this.modalBtnCapton = "Yes";
        jQuery("#nextModal").modal("show");
        return false;
    }
    DeleteClient(id: number, name: string, IsThirdparty: boolean) {
        this.delClientId = id;
        this.delClientThirdparty = IsThirdparty;
        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "delete_client";
        this.modalTitle = '<span >Would you like to proceed in removing the client ' + name + ' from this deliverable?</span>';
        this.modalBtnCapton = "Yes";
        jQuery("#nextModal").modal("show");
        return false;
    }
    fnModalCloseClick(action: string) {
        jQuery("#nextModal").modal("hide");
    }
    public btnModalSaveClick(action: string, link: string): void {
        if (action == "delete_market_def") {
            for (var key in this.ClientMarketDefList) {
                if (this.ClientMarketDefList[key].Id == this.delMktID) {
                    this.ClientMarketDefList[key].selected = false;
                    this.removeByAttr(this.SavedeliverablesList.marketDefs, 'Id', this.delMktID);

                }
            }
            this.checkMktCount(this.SavedeliverablesList);
        }
        else if (action == "delete_territory") {
            for (var key in this.ClientTerritoryList) {
                if (this.ClientTerritoryList[key].Id == this.delTerId) {
                    this.ClientTerritoryList[key].selected = false;
                    //this.SavedeliverablesList.territories.filter(this.ClientTerritoryList[key]);
                    //this.SavedeliverablesList.territories = this.SavedeliverablesList.territories.filter(function (el:any) {
                    //    return el.id == id;
                    //});
                    this.removeByAttr(this.SavedeliverablesList.territories, 'Id', this.delTerId);
                }
            }
            this.clientService.fnSetLoadingAction(true);
            var Terids = this.getSelectedID(this.SavedeliverablesList.territories, 'Id');
            this.clientService.fnSetLoadingAction(true);
            var tids = Terids.join();
            if (tids.length == 0) tids = '0';
            this.deliverableService.getRestrictions(this.editDeliverableID, tids, this.editClientID).subscribe(
                (data: any) => { this.RestrictionList = data, this.clientService.fnSetLoadingAction(false) },
                (err: any) => {
                    this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log('restrictions loaded')
            );
            this.checkTerCount(this.SavedeliverablesList);
        }
        else if (action == "delete_client") {
            //alert('client' + this.delClientId);
            for (var key in this.ClientList) {
                if (this.ClientList[key].Id == this.delClientId && this.ClientList[key].IsThirdparty == this.delClientThirdparty) {
                    this.ClientList[key].selected = false;
                    this.removeByAttrClient(this.SavedeliverablesList.clients, 'Id', this.delClientId, 'IsThirdparty', this.delClientThirdparty);
                }
            }
        }

        if (action == "checkSaveChanges") {
            this.canNavigate = true;
            this.router.navigate([link]);
        }

        if (action == "checkReload") {
            this.canNavigate = true;
            this.Reload();
        }
        if (action == "checkClose") {
            this.canNavigate = true;
            this.router.navigate([this.breadCrumbLink, this.editClientID + "|1"]);
        }
        if (action == "checkSaveChangesForClose") {
            this.canNavigate = true;
            this.router.navigate([this.breadCrumbLink, this.editClientID + "|1"]);
        }
        jQuery("#nextModal").modal("hide");
    }
    removeByAttr = function (arr: any, attr: any, value: any) {
        var i = arr.length;
        while (i--) {
            if (arr[i]
                && arr[i].hasOwnProperty(attr)
                && (arguments.length > 2 && arr[i][attr] === value)) {

                arr.splice(i, 1);

            }
        }
        return arr;
    }
    removeByAttrClient = function (arr: any, attr1: any, value1: any, attr2: any, value2: any) {
        var i = arr.length;
        while (i--) {
            if (arr[i]
                && arr[i].hasOwnProperty(attr1) && arr[i].hasOwnProperty(attr2)
                && (arguments.length > 2 && arr[i][attr1] === value1 && arr[i][attr2] === value2)) {

                arr.splice(i, 1);

            }
        }
        return arr;
    }
    getSelectedValues(data: any[], key: string): any[] {
        var selectedValues = data.filter(d => d.selected).map(function (x) {
            return x[key];
        });

        return selectedValues;
    }
    getSelectedID(data: any[], key: string): any[] {
        var selectedValues = data.map(function (x) {
            return x[key];
        });

        return selectedValues;
    }
    ResetDeliverables() {

        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "checkReload";
        this.modalTitle = '<span>Changes made to the Deliverable settings will not apply. Would you like to proceed?</span>';
        this.modalBtnCapton = "Yes";

        this.isDeliverableSettingsChnaged();
        if (this.isChanged) {
            jQuery("#nextModal").modal("show");
        } else {
            this.Reload();
        }
        return false;
    }
    ReloadAfterUpdate() {
        this.clientService.fnSetLoadingAction(false);
        if (this.isSuccess) this.Reload();
    }
    Reload() {
        
        this.clientService.fnSetLoadingAction(true);
        this.getLookupData(this.editClientID);
        this.getMarketDefs();
        this.getTerritories();
        this.getClients();

        this.getDeliverable(this.editDeliverableID, this.editClientID);

        this.monthsFrom = months;
        this.monthsTo = months2;
        if (this.tempUserPermission.length == 0) {
            this.loadUserData();
        }
        else {
            this.checkAccess(this.tempUserPermission);
        }
    }
    
    private loadUserData() {
        this.usrObj= this._cookieService.getObject('CurrentUser');
        if (this.usrObj) {
            var roleid: number = this.usrObj.RoleID;
            this.authService.getInitialRoleAccess('Deliverables', (this.isMyclientsSelected ? 'My Clients' : 'All Clients'), roleid).subscribe(
                (data: any) => this.checkAccess(data),
                (err: any) => {
                    this.DelErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log('data loaded')
            );
        }
    }

    private checkAccess(data: UserPermission[]) {
        console.log('this.isMyclientsSelected: ', this.isMyclientsSelected);
        this.CanAddMktDef = false;
        this.CanAddTerDef = false;
        this.CanDelMktDef = false;
        this.CanDelTerDef = false;
        this.CanEditContent = false;
        this.CanAddClient = false;

        var isAdmin: boolean = false;
        for (let it in data) {
            if (data[it].Role == 'Internal Admin' || data[it].Role == 'Internal Production' || data[it].Role == 'Internal Support') {
                // this.isMyclientsSelected = true;
                isAdmin = true;
                //this.authService.canAllClientAccess = true;
            }

        }
        // if (this.isMyclientsSelected == true || this.authService.canAllClientAccess  == true) {
        if (this.isMyclientsSelected == true || isAdmin == true) {
            for (let it in data) {
                // console.log('item=' + data[it].ActionName + "-" + data[it].Privilage);
                if (data[it].ActionName == ConfigUserAction.delliveryMktDef && data[it].Privilage == 'Add' && this.lockType != "View Lock") {
                    this.CanAddMktDef = true;
                }
                if (data[it].ActionName == ConfigUserAction.delliveryMktDef && data[it].Privilage == 'Delete' && this.lockType != "View Lock") {
                    this.CanDelMktDef = true;
                    //console.log('CanDelMktDef' + this.CanDelMktDef);
                }
                if (data[it].ActionName == ConfigUserAction.delliveryTerDef && data[it].Privilage == 'Add' && this.lockType != "View Lock") {
                    this.CanAddTerDef = true;
                }
                if (data[it].ActionName == ConfigUserAction.delliveryTerDef && data[it].Privilage == 'Delete' && this.lockType != "View Lock") {
                    this.CanDelTerDef = true;
                }
                if (data[it].ActionName == ConfigUserAction.deliveryContent && data[it].Privilage == 'Edit' && this.lockType !="View Lock") {
                    //console.log('this.canViewContent' + this.CanEditContent);
                    this.CanEditContent = true;
                }
                if (data[it].ActionName == ConfigUserAction.updateSubchannel && data[it].Privilage == 'Edit' && this.lockType != "View Lock") {
                    this.CanEditSubchannel = true;
                }
                if (data[it].ActionName == ConfigUserAction.updateIRPReportNumber && data[it].Privilage == 'Edit' && this.lockType != "View Lock") {
                    this.CanEditIRPReportNumber = true;
                }
            }
        }

        for (let it in data) {
            if (data[it].ActionName == ConfigUserAction.deliverablesClient && data[it].Privilage == 'Add' && this.lockType != "View Lock") {
                this.CanAddClient = true;
            }
        }
        this.tempUserPermission = data;
        this.clientService.fnSetLoadingAction(false);
    }

    buttonState(tp: string) {
        if (tp == 'market') {
            var ret = this.ClientMarketDefList.some(x => x.selected == true);
            return !this.ClientMarketDefList.filter(p => p.isSaved != true).some(x => x.selected == true);
        }
        else if (tp == 'territory') {
            var ret = this.ClientTerritoryList.some(x => x.selected == true);
            return !this.ClientTerritoryList.filter(p => p.isSaved != true).some(x => x.selected == true);
        }
        else if (tp == 'client') {
            var ret = this.ClientList.some(x => x.selected == true);
            return !this.ClientList.filter(p => p.isSaved != true).some(x => x.selected == true);
        }
    }

    NavigateToBack() {
        this.modalSaveBtnVisibility = true;
        this.modalBtnCapton = "Yes";

        this.isDeliverableSettingsChnaged();
        if (this.isChanged) {
            this.modalSaveFnParameter = "checkSaveChangesForClose";
            this.modalTitle = '<span>Changes made to the Deliverable settings will not apply. Would you like to proceed?</span>';
            jQuery("#nextModal").modal("show");
        } else {
            this.modalSaveFnParameter = "checkClose";
            this.modalTitle = '<span >Do you want to return back to <b>Deliverables</b> view?</span>';
            jQuery("#nextModal").modal("show");
            //this.router.navigate([this.breadCrumbLink, this.editClientID + "|1"]);
        }
        return false;

    }
    GetDeliveryList() {
        this.isDeliverableSettingsChnaged();
        this.authService.hasUnSavedChanges = this.isChanged;
        return JSON.stringify(this.SavedeliverablesList);
    }
    UpdateLock() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        var request = {
            defId: this.editDeliverableID,
            docType: "Delivery",
            lockType: "Edit",
            userId: userid
        }
        this.deliverableService.UpdateDeliveryLock(request)
            .subscribe(
            r => { console.log('deliver lock') },
            e => (console.log("error" + e))
            );
    }
    ReleaseLock() {
        this.clientService.fnSetLoadingAction(true);
        try {
            this.deactiveGuard.fnReleaseLock(this.usrObj.UserID, this.editDeliverableID, 'Delivery Module', this.lockType, 'Release Lock').then(result => { this.clientService.fnSetLoadingAction(false); });
        } catch (ex) {
            this.clientService.fnSetLoadingAction(false);
        }
        this.clientService.fnSetLoadingAction(false);
        //var usrObj: any = this._cookieService.getObject('CurrentUser');
        //var userid;
        //if (usrObj) {
        //    userid = usrObj.UserID;
        //}
        //var request = {
        //    defId: this.editDeliverableID,
        //    docType: "Delivery",
        //    lockType: "Edit",
        //    userId: userid
        //}
        //this.deliverableService.RelaseDeliveryLock(request)
        //    .subscribe(
        //    r => { console.log('deliver release lock' ) },
        //    e => (console.log("error" + e))
        //    );
    }

    SubmitDeliverables() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        this.deliverableService.SubmitDeliverables(this.SavedeliverablesList.DeliverableId, userid).subscribe((data: any) => {
            alert("Submit success");
        },
            (err: any) => {
                console.log(err);
            }
        );
    }

    toggleDataType(subChannels: SubChannelsDTO) {
        if (subChannels != null && subChannels.DataType != null && subChannels.EntityTypes != null) {
            subChannels.EntityTypes.forEach(e => e.IsSelected = subChannels.DataType.IsSelected);
        }
    }

    toggleEntityType(subChannels: SubChannelsDTO) {
        this.checkDataTypeSelction(subChannels);
    }

    private checkDataTypeSelction(subChannels: SubChannelsDTO) {
        if (subChannels != null && subChannels.DataType != null && subChannels.EntityTypes != null) {
            let uncheckedEntity = subChannels.EntityTypes.filter(e => e.IsSelected == false);

            if (uncheckedEntity.length > 0) {
                subChannels.DataType.IsSelected = false;
            }
            else {
                subChannels.DataType.IsSelected = true;
            }
        }
    }
}