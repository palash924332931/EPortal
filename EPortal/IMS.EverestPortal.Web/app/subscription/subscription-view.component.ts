import { Component, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Client } from '../shared/models/client';
import { CLIENTS } from '../shared/models/mock-clients';
import { SubscriptionService } from './subscription.service';
import { ClientService } from '../shared/services/client.service';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';
import { ConfigService } from '../config.service';
import { ModalDirective } from 'ng2-bootstrap';
import { ClientSubscriptionDTO } from './subscription.model';
import { ClientMarketBaseDTO } from './subscription.model';
import { ClientMarketBase } from './subscription.model';
import { months } from './subscription.model';
import { months2 } from './subscription.model';
import { DeliverablesDTO } from '../deliverables/deliverables.model';
import { AlertService } from '../shared/component/alert/alert.service';

declare var jQuery: any;
declare var jsPDF: any;

@Component({
    selector: 'market-view',
    templateUrl: '../../app/subscription/subscription-view.html',
    styleUrls: ['../../app/market-view/clients-sidebar.css', '../../app/subscription/subscription.css']
})
export class SubscriptionViewComponent implements OnInit, AfterViewInit {
    @ViewChild('SubErrorModal') SubErrorModal: ModalDirective
    @ViewChild('lgSubModal') lgSubModal: ModalDirective
    @ViewChild('lgSubDateModal') lgSubDateModal: ModalDirective
    @ViewChild('lgDeliveryModal') lgDeliveryModal: ModalDirective
    @ViewChild('lgSubSaveModal') lgSubSaveModal: ModalDirective
    @ViewChild('lgSubSubmitModal') lgSubSubmitModal: ModalDirective
    @ViewChild('lgDelSubmitModal') lgDelSubmitModal: ModalDirective
    @ViewChild('lgBaseSubmitModal') lgBaseSubmitModal: ModalDirective

    public daterange: any = {};

    private selectedDate(value: any) {
        this.daterange.start = value.start;
        this.daterange.end = value.end;
    }

    loading: boolean = true;
    noSubscription: boolean = false;
    noDeliverables: boolean = false;
    clients: Client[] = [];
    myClients: Client[] = [];
    searchedClients: Client[] = [];
    tempUserPermission: UserPermission[] = [];
    SubscriptionHistories: any[] = [];

    client: Client;
    clientsFiltered: Client[] = [];
    isMyclientsSelected: boolean;
    isSearch: boolean;
    toggleTitle: string = 'All Clients';
    clientSubscription: any[] = [];
    sortedSubscription: any[] = [];
    sortedDeliverables: any[] = [];
    clientMarketBase: ClientMarketBase[] = [];
    filteredclientMarketBase: any[] = [];
    selectedSubscriptionid: number;
    toggle: boolean = false;
    selectedClientName: string;
    currentClientId: number;
    SubscriptionId: number;
    IsCheckAllEnabled: boolean = true;
    IsCheckAllSelected: boolean = true;
    selectedSubscription: boolean = false;
    selectedDelivery: number;
    selectedMarketBase: number;

    selectAllSubscription: boolean = false;
    selectAllDeliverable: boolean = false;


    public deletedMarketDefinitionID: number;
    public deletedClientID: number;
    public dynamicModalSaveFunction: any;
    public modalTitle = '<span ></span>';
    public modalSaveBtnVisibility: boolean = false;
    public modalSaveFnParameter: string = "";
    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Cancel";

    breadCrumbUrl: string;
    isMyClientsVisible: boolean;

    stringFilter: string = '';
    //authentication variables
    canAddMarketBase: boolean = false;
    canEditMarketBase: boolean = false;
    canDelMarketBase: boolean = false;
    canEditDeliverable: boolean = false;
    canViewContent: boolean = false;
    visibeAllClientBtn: boolean = false;
    canPrintContent: boolean = false;
    canCloneDeliverable: boolean = false;
    canDownload: boolean = false;

    userId: number = 0;

    private mm: number;
    private mon: string;
    private years: number[] = [];
    private yy: number;
    private curFromYear: number;
    private curToYear: number;
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
    deliverablesList: any[] = [];
    MarketBaseList: any[] = [];
    IsSubscriptionTab: boolean = true;
    isMenuNavigation: boolean = true;
    PreviousPage: string;
    usrObj: any;

    constructor(private clientService: ClientService, private subscriptionService: SubscriptionService, public route: ActivatedRoute,
        private _cookieService: CookieService, private authService: AuthService, private alertService: AlertService,
        private router: Router) {


    }

    ngOnInit(): void {
        //find user id from login cookie.
        this.usrObj = this._cookieService.getObject('CurrentUser');
        if (this.usrObj) {
            this.userId = this.usrObj.UserID;
        }
        if (jQuery(".dropdown-menu li:contains('My Subscriptions')").length > 0) {
            this.isMyclientsSelected = true;
            this.isMyClientsVisible = true;
            this.toggleTitle = "My Subscriptions";
            //this.breadCrumbUrl = "/subscription/My-Client";
            this.breadCrumbUrl = "/subscriptions/mysubscriptions";
        }
        else {
            let paramID: string = this.route.snapshot.params['id'];
            let seconParam: string = this.route.snapshot.params['id2'];
            if (paramID == "myclients") {
                this.isMyclientsSelected = true;
                this.isMyClientsVisible = true;
                this.breadCrumbUrl = "/subscription/myclients";
                this.toggleTitle = "My Clients";
                ConfigService.clientFlag = true;
            } else if (paramID == "allclients") {
                this.isMyclientsSelected = false;
                this.isMyClientsVisible = false;
                this.breadCrumbUrl = "/subscriptions/allclients";
                this.toggleTitle = "All Clients";
                ConfigService.clientFlag = false;
            } else {
                this.isMyclientsSelected = true;
                this.isMyClientsVisible = true;
                this.breadCrumbUrl = "/subscription/myclients";
                this.toggleTitle = "My Clients";
                ConfigService.clientFlag = true;
            }
            if (seconParam == undefined || seconParam == '') {
                this.isMenuNavigation = true;
            }
            else {
                this.isMenuNavigation = false;
                this.currentClientId = Number(seconParam.split("|")[0]);
                this.PreviousPage = seconParam.split("|")[1];
            }
        }
        if (this.authService.SelectedClientID != undefined && this.authService.SelectedClientID > 0)
            this.currentClientId = this.authService.SelectedClientID;

        // this.IsSubscriptionTab = true;
        this.authService.canAllClientAccess = false;
        this.CheckMenuVisibility();

        this.subscribeToClientList();
        this.loadUserData();
        this.authService.isMyClientsSelected = this.isMyclientsSelected
        this.visibeAllClientBtn = this.authService.canAllClientAccess;
        //this.loadSubscription();
        //console.log('inside on init, isMyClientsSelected: ', this.isMyclientsSelected);
        //for (var i = 0; i < months.length; i++){
        //    this.monthsFrom.push(months[i]);
        //    this.monthsTo.push(months[i]);
        //}
        this.monthsFrom = months;
        this.monthsTo = months2;

        this.getMonth();
        this.getYear();
        this.curFromYear = 2017;
        this.curToYear = 2017;
        this.Invalid = false;
    }
    ngAfterViewInit() {
        if (this.isMenuNavigation == false && this.PreviousPage == '0') {
            //this.getClientMarketDetailsonLoad(this.currentClientId);
            if (this.authService.SelectedClientID != undefined && this.authService.SelectedClientID > 0)
                this.currentClientId = this.authService.SelectedClientID;
            this.getSubscription(this.currentClientId);
        }
    }
    getSubscriptionName(obj: any) {
        return obj.Country + " " + obj.Service + " " + obj.Data + " " + obj.Source;
    }
    subscribeToClientList() {
        this.clientService.fnSetLoadingAction(true);
        if (this.clients.length == 0) {
            this.clientService.getClients(this.userId)
                .finally(() => this.clientService.fnSetLoadingAction(false))
                .subscribe(
                (data: any) => this._processClients(data),
                (err: any) => {
                    this.SubErrorModal.show();
                    console.log(err);
                },
                () => console.log('clients loaded')
                );
        }
    }

    noneSelected() {
        return !(this.clientSubscription.some(x => x.subscription.Selected));
    }
    NoDeliverablesSelected() {
        return !(this.deliverablesList.some(x => x.Selected));
    }
    private _processClients(data: Client[]) {
        //console.log('data length: ', data.length);
        var tempClients: Client[] = [];
        for (let item in data) {
            tempClients.push({ Id: data[item].Id, Name: data[item].Name, IsMyClient: data[item].IsMyClient, MarketDefinitions: [] });
        }
        this.clients = tempClients;
        if (this.isMenuNavigation == true) {
            this.myClients = this.clients.filter(u => u.IsMyClient == true);
            var firstClient;
            if (this.authService.SelectedClientID != undefined && this.authService.SelectedClientID > 0) {
                this.currentClientId = this.authService.SelectedClientID;
                if (this.isMyclientsSelected) {
                    firstClient = this.myClients.filter(u => u.Id == this.currentClientId)[0];
                }
                else {
                    firstClient = this.clients.filter(u => u.Id == this.currentClientId)[0];
                }
                if (firstClient == undefined)
                    firstClient = this.isMyclientsSelected ? this.myClients[0] : this.clients[0];
            }
            else {
                firstClient = this.isMyclientsSelected ? this.myClients[0] : this.clients[0];
            }
            if (firstClient != undefined) {
                this.selectedClientName = firstClient.Name;
                //alert('process' + this.selectedClientName);
                //console.log('nav: first client: ', firstClient);
                this.checkMyClient(firstClient.Id);
                //this.getClientMarketDetails(firstClient.Id);
                this.getSubscription(firstClient.Id);
                this.getDeliverables(firstClient.Id);
                this.currentClientId = firstClient.Id;
                this.authService.SelectedClientID = firstClient.Id;
            }
        }
        else {
            this.myClients = this.clients.filter(u => u.IsMyClient == true);
            firstClient = this.clients.filter(u => u.Id == this.currentClientId)[0];
            this.currentClientId = firstClient.Id;
            this.authService.SelectedClientID = firstClient.Id;
            // this.getSubscription(firstClient.Id);
            this.loadSubscription(firstClient, false);
            if (this.PreviousPage == '1') //delivery page
            {
                jQuery('.nav-tabs a[href="#delivTab"]').tab('show');
                this.IsSubscriptionTab = false;
            }
            else {
                jQuery('.nav-tabs a[href="#subsTab"]').tab('show');
                this.IsSubscriptionTab = true;
            }

        }
    }

    getselectedOptions() { // right now: ['1','3']
        var list1: any = this.clientSubscription
            .filter(opt => opt.subscription.Selected)
            //.find(x => x.subscription.subscriptionId)

            .map(x => x.subscription)
        return list1;

    }
    getSelectedMarketbase() { // right now: ['1','3']
        var list1: any = this.MarketBaseList
            .filter(opt => opt.selected)
        //.find(x => x.subscription.subscriptionId)
        return list1;

    }

    getSelectedDeliverables() {
        var dllist: any = this.deliverablesList
            .filter(opt => opt.Selected)
        return dllist;
    }

    navigate(selection: boolean) {
        if (selection) {
            this.router.navigate(['subscription/myclients']);
        } else {
            this.router.navigate(['subscriptions/allclients']);
        }
    }

    onSelectClientsType(selection: boolean) {
        this.clientService.fnSetLoadingAction(true);
        this.isMyclientsSelected = selection;
        this.isMyClientsVisible = selection;
        ConfigService.clientFlag = selection;
        this.isMenuNavigation = true;
        this.stringFilter = '';
        (selection === true) ? this.toggleTitle = "My Clients" : this.toggleTitle = "All Clients";
        //console.log("toggletile: ", this.toggleTitle);
        var firstClient;
        if (this.authService.SelectedClientID != undefined && this.authService.SelectedClientID > 0) {
            this.currentClientId = this.authService.SelectedClientID;
            if (selection) {
                firstClient = this.myClients.filter(u => u.Id == this.currentClientId)[0];
            }
            else {
                firstClient = this.clients.filter(u => u.Id == this.currentClientId)[0];
            }
            if (firstClient == undefined)
                firstClient = (selection) ? this.myClients[0] : this.clients[0];
        }
        else {
            firstClient = (selection) ? this.myClients[0] : this.clients[0];
        }
        if (!firstClient) {
            this.clientService.fnSetLoadingAction(false);
            this.selectedClientName = "";
            this.clientSubscription = [];
            this.deliverablesList = [];
            return;
        }
        this.currentClientId = firstClient.Id;
        this.authService.SelectedClientID = firstClient.Id;
        this.selectedClientName = firstClient.Name;
        // this.IsSubscriptionTab = true;

        this.tempUserPermission = [];
        //this.getClientMarketDetails(firstClient.Id);
        this.getSubscription(firstClient.Id);
        this.getDeliverables(firstClient.Id);
        //console.log('bar: first client: ', firstClient);
        //if (this.tempUserPermission.length > 0)
        //    this.checkAccess(this.tempUserPermission);
        //else
        //this.loadUserData();
        this.checkMyClient(firstClient.Id);
        jQuery('.nav-tabs a[href="#subsTab"]').tab('show');//change the tab selectioin to subscription
        this.IsSubscriptionTab = true;
    }

    loadSubscription(selectedClient: Client, isMenu: boolean): void {
        this.clientService.fnSetLoadingAction(true);
        if (isMenu == true) this.isMenuNavigation = true;
        this.client = selectedClient;
        this.currentClientId = selectedClient.Id;
        this.authService.SelectedClientID = selectedClient.Id;
        //jQuery('#sidebar-client-list li.selected').removeClass('selected');
        //jQuery('#sidebar-client-list li:contains(' + selectedClient.Name + ')').addClass('selected');

        //this.clientService.getMarketDefinitionsForClient(selectedClient.Id).subscribe(data => this.clientsFiltered = data);
        //this.subscriptionService.getClientSubscription(selectedClient.Id).subscribe(data => this.clientSubscription = data);

        this.getSubscription(selectedClient.Id);
        //this.getClientMarketDetails(selectedClient.Id);
        //this.getClient(selectedClient.Id);
        this.selectedClientName = selectedClient.Name;
        // this.IsSubscriptionTab = true;
        //alert('load subsc' + this.selectedClientName);
        this.checkMyClient(selectedClient.Id);
        this.getDeliverables(selectedClient.Id);
        //console.log(this.clientsFiltered);
        jQuery('.nav-tabs a[href="#subsTab"]').tab('show');//change the tab selectioin to subscription
        this.IsSubscriptionTab = true;
    }

    getDeliverables(clientId: number) {
        this.noDeliverables = true;
        //this.clientService.fnSetLoadingAction(true);
        this.subscriptionService.getDeliverablesByClient(clientId).subscribe(
            (data: any) => {
                this.deliverablesList = data, console.log(this.deliverablesList), (data.length === 0 ? this.noDeliverables = false : this.noDeliverables = true),
                    this.clientService.fnSetLoadingAction(false);
                this.sortedDeliverables = this.deliverablesList.sort(function (a, b) {

                    if (a.DisplayName < b.DisplayName) return -1;
                    if (a.DisplayName > b.DisplayName) return 1;
                    return 0;

                })
                    .sort(function (a, b) {

                        if (a.Submitted < b.Submitted) return -1;
                        if (a.Submitted > b.Submitted) return 1;
                        return 0;

                    })

                this.setSelectAllDeliverable();
            },
            (err: any) => {
                this.SubErrorModal.show();
                console.log(err); this.clientService.fnSetLoadingAction(false);
            },
            () => console.log('delivery list loaded')
        );

    }

    searchClient(searchKey: string, selection: boolean) {
        var sourceList = (selection) ? this.myClients : this.clients;
        this.clientService.getClientsBySearch(searchKey, sourceList)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(data => this.searchedClients = data);
    }

    refreshClientList(selection: boolean) {
        this.isMenuNavigation = true;
        if (this.stringFilter) {
            this.stringFilter = '';
            //this.isSearch = false;
            this.searchedClients = [];
            var firstClient;
            if (this.authService.SelectedClientID != undefined && this.authService.SelectedClientID > 0) {
                this.currentClientId = this.authService.SelectedClientID;
                firstClient = this.clients.filter(u => u.Id == this.currentClientId)[0];
            }
            else {
                firstClient = (selection) ? this.myClients[0] : this.clients[0];
            }
            this.selectedClientName = firstClient.Name;
            //this.getClientMarketDetails(firstClient.Id);
            this.getSubscription(firstClient.Id);
            this.getDeliverables(firstClient.Id);
        }
    }


    getSubscription(clientId: number) {
        this.loading = true;
        //this.clientService.fnSetLoadingAction(true);
        this.noSubscription = false;
        jQuery('#custWrapper').css('display', 'hidden');
        this.subscriptionService.getClientSubscription(clientId)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (data: any) => { this._processSubscriptionData(data); this.getClientMarketDetails(clientId) },
            (err: any) => {
                //this.SubErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('subscription loaded')
            );
    }
    getClientMarketDetails(clientId: number) {
        //this.clientService.fnSetLoadingAction(true);
        this.subscriptionService.getClientMarketBase(clientId)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            res => {
                this.clientMarketBase = res; this.filteredclientMarketBase = res; this.setPagination();
                if (this.isMenuNavigation == false && this.PreviousPage == '0' && this.subscriptionService.subscriptionID > 0 && this.currentClientId > 0) {
                    this.ShowDialogOnLoad(this.subscriptionService.subscriptionID, this.currentClientId);
                }
            }, (err: any) => {
                this.SubErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            });
        // console.log('client marketbase' + this.clientMarketBase);
    }
    private _processSubscriptionData(data: ClientSubscriptionDTO[]) {

        this.clientSubscription = data;
        //this.clientSubscription.filter(x => x.Subscription).sort(function (a, b) {
        //    return a.Submitted - b.Submitted;
        //})

        this.sortedSubscription =
            this.clientSubscription
                .sort(function (a, b) {

                    if (a.subscription.Name < b.subscription.Name) return -1;
                    if (a.subscription.Name > b.subscription.Name) return 1;
                    return 0;

                })
                .sort(function (a, b) {

                    if (a.subscription.Submitted < b.subscription.Submitted) return -1;
                    if (a.subscription.Submitted > b.subscription.Submitted) return 1;
                    return 0;

                })

        //  OrderBy(s => s.Submitted);
        if (this.clientSubscription.length > 0) {
            this.canDownload = true;
        }
        else {
            this.canDownload = false;
        }
        console.log(this.clientSubscription);
        this.loading = false;
        this.clientService.fnSetLoadingAction(false);
        if (data.length === 0) this.noSubscription = true;
        //console.log('mkt defs: ', data.MarketDefinitions, ' noMarketDefs: ', this.noMarketDefs);
        jQuery('#custWrapper').css('display', 'block');
        this.setSelectAllSubscriptionValue();
        //console.log('inside final callback');
    }

    selectAllSubscriptionChange(selectedValue: boolean) {       

        this.sortedSubscription.forEach(function (value) {
            if (!(value.subscription.Submitted == 'Yes')) {
                value.subscription.Selected = selectedValue;
            }
        });
    }

    selectAllDeliverableChange(selectedValue: boolean) {
        console.log(selectedValue);

        this.sortedDeliverables.forEach(function (value) {
            if (!(value.Submitted == 'Yes')) {
                value.Selected = selectedValue;
            }
        });
    }

    subscriptionChange(value: boolean) {
        if (!value) {
            this.selectAllSubscription = false;
        }
        this.setSelectAllSubscriptionValue();
    }

    setSelectAllSubscriptionValue() {
        var temp = this.sortedSubscription.filter(s => (!s.subscription.Selected && s.subscription.Submitted != 'Yes'));
        if (temp.length > 0) {
            this.selectAllSubscription = false;
        } else {
            this.selectAllSubscription = true;
        }

        if (this.sortedSubscription.filter(s => (s.subscription.Submitted == 'No')).length == 0) {
            this.selectAllSubscription = false;
        }
    }

    deliverableChange(value: boolean) {
        if (!value) {
            this.selectAllDeliverable = false;
        }
        this.setSelectAllDeliverable();
    }

    setSelectAllDeliverable() {
        var temp = this.sortedDeliverables.filter(s => (!s.Selected && s.Submitted != 'Yes'));
        if (temp.length > 0) {
            this.selectAllDeliverable = false;
        } else {
            this.selectAllDeliverable = true;
        }
        if (this.sortedDeliverables.filter(s => (s.Submitted == 'No')).length == 0) {
            this.selectAllDeliverable = false;
        }
    }
    private ShowDialog(subid: number, clienid: number) {
        this.CurrentPage = 1;
        this.subscriptionService.subscriptionID = subid;
        if (this.canAddMarketBase) {
            for (let i in this.clientMarketBase) {
                this.clientMarketBase[i].selected = false;
                this.clientMarketBase[i].isSaved = false;
            }
            var Mktids = this.getSelectedValues(this.filteredclientMarketBase, 'MarketBaseId');
            //var Mktids1 = this.getSelectedValues(this.clientMarketBase, 'MarketBaseId');
            var subscription: any = this.clientSubscription;
            for (let item in subscription) {
                if (subscription[item].subscription.SubscriptionId == subid) {
                    for (let it in subscription[item].MarketBase) {
                        var mktid = subscription[item].MarketBase[it].Id;
                        for (let i in this.clientMarketBase) {
                            if (this.clientMarketBase[i].MarketBaseId == Number(mktid)) {
                                this.clientMarketBase[i].selected = true;
                                this.clientMarketBase[i].isSaved = true;
                            }
                        }
                    }
                }
            }
            this.IsCheckAllEnabled = true;
            this.IsCheckAllSelected = false;
            var selLenth = this.clientMarketBase.filter(p => p.selected == true).length;
            var totLen = this.clientMarketBase.length;
            if (selLenth == totLen) {
                this.IsCheckAllEnabled = false;
                this.IsCheckAllSelected = true;
            }
            this.selectedSubscriptionid = subid;
            this.currentClientId = clienid;
            this.authService.SelectedClientID = clienid;
            this.lgSubModal.show();
        }
    }

    private ShowDialogOnLoad(subid: number, clienid: number) {
        //console.log('inside showdiaglogonload' + subid);

        this.CurrentPage = 1;
        for (let i in this.clientMarketBase) {
            this.clientMarketBase[i].selected = false;
            this.clientMarketBase[i].isSaved = false;
        }
        var Mktids = this.getSelectedValues(this.filteredclientMarketBase, 'MarketBaseId');
        //var Mktids1 = this.getSelectedValues(this.clientMarketBase, 'MarketBaseId');
        var subscription: any = this.clientSubscription;
        for (let item in subscription) {
            if (subscription[item].subscription.SubscriptionId == subid) {
                for (let it in subscription[item].MarketBase) {
                    var mktid = subscription[item].MarketBase[it].Id;
                    for (let i in this.clientMarketBase) {
                        if (this.clientMarketBase[i].MarketBaseId == Number(mktid)) {
                            this.clientMarketBase[i].selected = true;
                            this.clientMarketBase[i].isSaved = true;
                        }
                    }
                }
            }
        }
        this.IsCheckAllEnabled = true;
        this.IsCheckAllSelected = false;
        var selLenth = this.clientMarketBase.filter(p => p.selected == true).length;
        var totLen = this.clientMarketBase.length;
        if (selLenth == totLen) {
            this.IsCheckAllEnabled = false;
            this.IsCheckAllSelected = true;
        }
        this.selectedSubscriptionid = subid;
        this.currentClientId = clienid;
        this.authService.SelectedClientID = clienid;
        //console.log('this.clientMarketBase=' + this.clientMarketBase.length);
        // console.log('this.clientSubscription=' + this.clientSubscription.length);
        this.lgSubModal.show();

    }

    private CancelSubscriptionPopup() {
        this.IsCheckAllSelected = false;
        for (let i in this.clientMarketBase) {
            this.clientMarketBase[i].selected = false;
            this.clientMarketBase[i].isSaved = false;
        }
        this.lgSubModal.hide();
    }

    private CancelSubmitSubscriptionPopup() {
        this.ClearSubscriptionSelection();
        this.setSelectAllSubscriptionValue();
        this.lgSubSubmitModal.hide();
    }

    private ClearSubscriptionSelection() {
        this.selectAllSubscription = false;
        this.sortedSubscription.map(function (value) {
            value.subscription.Selected = false;
        })
    }

    private ClearDeliverableSelection() {
        this.selectAllDeliverable = false;
        this.sortedDeliverables.map(function (value) {
            value.Selected = false;
        });
    }


    private SubmitSubButton() {
        jQuery('#SuccessMessage').css('display', 'none'); 
        this.lgSubSubmitModal.show();
    }

    private SubmitDeliveryButton() {
        jQuery('#SuccessMessageDelivery').css('display', 'none'); 
        this.lgDelSubmitModal.show();
    }

    private CancelSubmitDeliveryPopup() {
        this.ClearDeliverableSelection();
        this.setSelectAllDeliverable();
        this.lgDelSubmitModal.hide();
    }

    SubmitDeliverables(DeliverableId: number) {
        var dlvList: any = this.getSelectedDeliverables();
        var DeliverableIds = dlvList.map(x => x.DeliverableId);
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        this.subscriptionService.SubmitDeliverables(DeliverableIds, userid).subscribe((data: any) => {
            //alert("Submit success");
           
            this.getDeliverables(this.currentClientId);
            jQuery('#SuccessMessageDelivery').css('display', 'block'); 

        },
            (err: any) => {
                console.log(err);
            }
        );
    }

    SubmitMarketBaseButton(subscriptionId: number) {
        this.selectedSubscriptionid = subscriptionId;
        jQuery('#custWrapper').css('display', 'hidden');
        this.subscriptionService.getClientMarketBaseForSubscription(subscriptionId)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (data: any) => { this._processMarketBasesData(data); },
            (err: any) => {
                //this.SubErrorModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('subscription loaded')
            );

        //var subscription: any = this.clientSubscription;
        //for (let item in subscription) {
        //    if (subscription[item].subscription.SubscriptionId == subscriptionId) {
        //        this.MarketBaseList = subscription[item].MarketBase;
        //    }
        //}
        this.lgBaseSubmitModal.show();
        jQuery('#mktmessage').css('display', 'none'); 
    }

    private _processMarketBasesData(data: ClientMarketBaseDTO[]) {
        this.MarketBaseList = data || [];
        this.MarketBaseList = this.MarketBaseList.sort(function (a, b) {
            if (a.Name < b.Name) return -1;
            if (a.Name > b.Name) return 1;
            return 0;
        });
        this.MarketBaseList = this.MarketBaseList.sort(function (a, b) {
            if (a.Submitted < b.Submitted) return -1;
            if (a.Submitted > b.Submitted) return 1;
            return 0;
        });

        this.clientService.fnSetLoadingAction(false);
        jQuery('#custWrapper').css('display', 'block');
        
        
    }

    SubmitMarketBase(marketBaseId: number) {
        jQuery(".radio-marketbase-submission").prop('checked', false);
        this.alertService.fnLoading(true);
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        var selectedMarketbase: any = this.getSelectedMarketbase();
        var marketbaseIds = selectedMarketbase.map(x => x.Id);
        //this.lgBaseSubmitModal.hide();
        this.subscriptionService.submitMarketBase(marketbaseIds, userid).subscribe((data: any) => {
            jQuery(".marketbase-submission-checkbox").prop("checked",false);
           this.alertService.fnLoading(false);
           
           //this.alertService.alert("Marketbase information submitted successfully.");
           this.SubmitMarketBaseButton(this.selectedSubscriptionid);
           jQuery('#mktmessage').css('display', 'block');
            
            
        },
           
            (err: any) => {
                this.alertService.fnLoading(false);
                console.log(err);
            }
        );
    }

    private CancelSubmiBasePopup() {

        this.lgBaseSubmitModal.hide();
    }

    SubmitSubscription(SubscriptionId: number): void {

        var selectedSubscription: any = this.getselectedOptions();
        var subscriptionIds = selectedSubscription.map(x => x.SubscriptionId);
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        
        this.subscriptionService.submitSubscription(subscriptionIds, userid).subscribe((data: any) => {
            //  alert("Submit success");
            this.getSubscription(this.currentClientId);
            jQuery('#SuccessMessage').css('display', 'block'); 

            
        },
            (err: any) => {
                console.log(err);
            }
        );

    }

    private AddToService() {
        //console.log(this.clientMarketBase);
        let obj = new ClientSubscriptionDTO();
        var Mktids = this.getSelectedValues(this.clientMarketBase, 'MarketBaseId');
        var request = {
            subscriptionid: this.selectedSubscriptionid,
            mktbaseid: Mktids,
            clientid: this.currentClientId
        }
        this.clientService.fnSetLoadingAction(true);
        this.subscriptionService.AddSubscriptionMarketBase(request)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            r => (this.getSubscription(this.currentClientId),
                this.lgSubModal.hide()),
            e => { console.log("error" + e); this.clientService.fnSetLoadingAction(false); }
            );
        //this.selectedSubscriptionid = 0;
        //this.currentClientId = 0;
        //this.lgSubModal.hide();
        this.clientMarketBase.forEach(x => x.selected = false);
        this.isMenuNavigation = true;
    }
    //Pagination

    public usertotalItems: number = this.filteredclientMarketBase.length;
    public CurrentPage: number = 1;
    public itemsPerPage: number = 10;
    public MarketBaseByPage: any[] = [];

    searchMarketase: string = "";

    searchClientMarketBase() {
        this.filteredclientMarketBase = this.clientMarketBase.filter(x => x.MarketBaseName.toLowerCase()
            .indexOf(this.searchMarketase.toLowerCase()) >= 0);
        this.setPagination();
    }


    public PageChanged(event: any): void {
        this.CurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.MarketBaseByPage = this.filteredclientMarketBase.slice(startIndex, endIndex);
    }

    setPagination(): void {
        this.usertotalItems = this.filteredclientMarketBase.length;
        this.PageChanged({ page: 1, itemsPerPage: this.itemsPerPage })
    }


    buttonState() {
        var ret = this.clientMarketBase.some(x => x.selected == true);
        return !this.clientMarketBase.filter(p => p.isSaved != true).some(x => x.selected == true);
    }
    checkAll(ev: any) {
        this.clientMarketBase.filter(p => p.isSaved != true).forEach(x => x.selected = ev.target.checked)
    }
    toggleItem(item: ClientMarketBase) {
        //item.checked = !item.checked
        //this.toggle = this.clientMarketBase.every(item => item.checked)
    }
    isAllChecked() {
        //this.toggle = !this.toggle
        //this.clientMarketBase.forEach(item => item. = this.toggle)
        return this.clientMarketBase.every(x => x.selected);
    }
    delsubid: number;
    delmktid: number;
    DelValidation: string = "";
    marketName: string;
    async deleteMarketBase(mktid: number, subid: number, clientid: number, mktName: string) {
        this.clientService.fnSetLoadingAction(true);
        if (this.canDelMarketBase) {
            this.DelValidation == ""
            this.marketName = mktName;
            //alert(mktid + "-" + subid);
            this.delsubid = subid;
            this.delmktid = mktid;
            this.request = {
                subscriptionid: this.delsubid,
                mktbaseid: this.delmktid
            }

            await this.listOfMarketForMarketBase(mktid, subid, clientid, mktName);

            this.subscriptionService.ValidateDelMarketBase(this.delsubid, this.delmktid, clientid)
                .finally(() => this.clientService.fnSetLoadingAction(false))
                .subscribe(
                (data: any) => { this.DelValidation = data; this.clientService.fnSetLoadingAction(false); }
                );

            //to check this marketbase is assigned


            /****************************************/
            if (this.listOfMarketForMarketbase.length < 1) {
                this.currentClientId = clientid;
                this.authService.SelectedClientID = clientid;
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "delete_market_base";
                this.modalTitle = '<span >Do you want to delete the market base ' + mktName + ' ? </span>';
                this.modalBtnCapton = "Yes";
                jQuery("#nextModal").modal("show");
            }
            //event.stopPropagation();
        }
        return false;


    }

    public listOfMarketForMarketbase: any[];
    async listOfMarketForMarketBase(mktid: number, subid: number, clientid: number, mktName: string) {
        this.listOfMarketForMarketbase = [];
        await this.subscriptionService.getListOfMarketForMarketbase(this.delsubid, this.delmktid, clientid)
            .then(
            (data: any) => { this.listOfMarketForMarketbase = data || []; console.log(data); this.clientService.fnSetLoadingAction(false); })
            .catch((err: any) => {
                this.clientService.fnSetLoadingAction(false);
                //this.mViewErrModal.show();//off to show mgs
                console.log(err);
            });
        this.clientService.fnSetLoadingAction(false);
        if (this.listOfMarketForMarketbase.length > 0) {
            let marketNameFormarketbase = '<ul>';
            this.listOfMarketForMarketbase.forEach((rec: any) => {
                marketNameFormarketbase = marketNameFormarketbase + '<li>' + rec.Name + '</li>';
            });
            marketNameFormarketbase = marketNameFormarketbase + '</ul>';
            this.currentClientId = clientid;
            this.authService.SelectedClientID = clientid;
            let message = '<span >Deleting market base <b>' + mktName + '</b> will remove packs from following market definition/s: <br/><div class="error-list">' + marketNameFormarketbase + '</div> Are you sure you would like to delete this market base?</span>';
            /* -----------------------------------------------
            this.modalSaveBtnVisibility = true;
            this.modalSaveFnParameter = "delete_market_base";
            this.modalTitle = '<span >Deleting market base <b>' + mktName + '</b> will remove packs from following market definition/s: <br/><div class="error-list">' + marketNameFormarketbase + '</div> Are you sure you would like to delete this market base?</span>';
            this.modalBtnCapton = "Yes";
            jQuery("#nextModal").modal("show");

            /--------------------------------------------------*/
            this.alertService.confirm(message,
                () => {
                    this.request = {
                        subscriptionid: this.delsubid,
                        mktbaseid: this.delmktid,
                        clientid: this.currentClientId
                    }
                    this.clientService.fnSetLoadingAction(true);
                    this.subscriptionService.DeleteSubMarketBase(this.request)
                        .subscribe(
                        r => (this.getSubscription(this.currentClientId), this.getDeliverables(this.currentClientId),
                            jQuery("#nextModal").modal("hide")),
                        e => (console.log("error" + e), jQuery("#nextModal").modal("hide"), this.clientService.fnSetLoadingAction(false))
                        );
                    this.delsubid = 0;
                    this.delmktid = 0;
                    this.alertService.alert("Market Base has deleted from subscription. <br/><div >Note: This will not take effect in existing market definitions until the overnight refresh process has run.</div>");
                },
                () => { });
            //event.stopPropagation(); 
            event.stopPropagation();
            return false;
        }
    }


    request: any;
    public btnModalSaveClick(action: string): void {
        if (action == "delete_market_base") {
            if (this.DelValidation == "") {
                //write here code for deleted.
                this.request = {
                    subscriptionid: this.delsubid,
                    mktbaseid: this.delmktid,
                    clientid: this.currentClientId
                }
                this.clientService.fnSetLoadingAction(true);
                this.subscriptionService.DeleteSubMarketBase(this.request)
                    .subscribe(
                    r => (this.getSubscription(this.currentClientId), this.getDeliverables(this.currentClientId),
                        jQuery("#nextModal").modal("hide")),
                    e => (console.log("error" + e), jQuery("#nextModal").modal("hide"), this.clientService.fnSetLoadingAction(false))
                    );
                this.delsubid = 0;
                this.delmktid = 0;
            }
            else {
                var array = this.DelValidation.split('|');
                if (array != undefined) {
                    //var delArray = array[0].split(',');
                    //var MktArray = array[1].split(',');
                    var delName = array[0];
                    var mktName = array[1];
                }
                this.DelValidation == ""
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "confirm_delete_market_base";
                this.modalTitle = '<span >Deleting market base ' + this.marketName + ' will remove the market definition ' + mktName + ' from the deliverable ' + delName + '. Please confirm market base deletion </span>';
                this.modalBtnCapton = "Yes";
                this.DelValidation == ""
                jQuery("#nextModal").modal("show");
            }

        }
        if (action == "confirm_delete_market_base") {

            this.clientService.fnSetLoadingAction(true);
            this.subscriptionService.DeleteSubMarketBase(this.request)
                .subscribe(
                r => (this.getSubscription(this.currentClientId), this.getDeliverables(this.currentClientId),
                    jQuery("#nextModal").modal("hide")),
                e => (console.log("error" + e), jQuery("#nextModal").modal("hide"), this.clientService.fnSetLoadingAction(false))
                );
            this.delsubid = 0;
            this.delmktid = 0;
        }
        if (action == "update_service_duration") {
            this.clientService.fnSetLoadingAction(true);
            this.subscriptionService.UpdateSubscription(this.dateRequest)
                .subscribe(
                r => (this.getSubscription(this.currentClientId), this.getDeliverables(this.currentClientId), jQuery("#nextModal").modal("hide"), this.lgSubDateModal.hide()),
                e => (console.log("error" + e), this.clientService.fnSetLoadingAction(false))
                );
            this.lgSubDateModal.hide();
        }

    }
    fnModalCloseClick(action: string) {
        jQuery("#nextModal").modal("hide");
    }
    getSelectedValues(data: any[], key: string): any[] {
        var selectedValues = data.filter(d => d.selected).map(function (x) {
            return x[key];
        });

        return selectedValues;
    }
    private loadUserData() {

        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('Subscription', (this.isMyclientsSelected ? 'My Clients' : 'All Clients'), roleid).subscribe(
                (data: any) => this.checkAccess(data),
                (err: any) => {
                    this.SubErrorModal.show();
                    console.log(err);
                },
                () => console.log('data loaded')
            );
            this.authService.getInitialRoleAccess('Deliverables', (this.isMyclientsSelected ? 'My Clients' : 'All Clients'), roleid).subscribe(
                (data: any) => this.checkDeliverableAccess(data),
                (err: any) => {
                    this.SubErrorModal.show();
                    console.log(err);
                },
                () => console.log('data loaded')
            );


        }
    }

    private checkDeliverableAccess(data: UserPermission[]) {
        this.canEditDeliverable = false;
        this.canCloneDeliverable = false;
        for (let it in data) {
            if (data[it].ActionName == ConfigUserAction.deliverables && (data[it].Privilage == 'Edit')) {
                this.canEditDeliverable = true;
            }
            if (data[it].ActionName == ConfigUserAction.duplicatedeliverables && (data[it].Privilage == 'Add')) {
                this.canCloneDeliverable = true;
            }
        }
    };


    private checkAccess(data: UserPermission[]) {
        //console.log('this.isMyclientsSelected: ', this.isMyclientsSelected);
        this.canAddMarketBase = false;
        // this.canViewContent = true;
        this.canEditMarketBase = false;
        this.canDelMarketBase = false;
        this.canPrintContent = false;
        var isAdmin: boolean = false;
        for (let it in data) {
            if (data[it].Role == 'Internal Admin' || data[it].Role == 'Internal Production' || data[it].Role == 'Internal Support') {
                // this.isMyclientsSelected = true;
                isAdmin = true;
                this.authService.canAllClientAccess = true;
            }
        }
        // if (this.isMyclientsSelected == true || this.authService.canAllClientAccess  == true) {
        if (this.isMyclientsSelected == true || isAdmin == true) {
            for (let it in data) {
                // console.log('item=' + data[it].ActionName + "-" + data[it].Privilage);
                if (data[it].ActionName == ConfigUserAction.SubscriptionService && data[it].Privilage == 'Add') {
                    this.canAddMarketBase = true;
                    this.canEditMarketBase = true;
                }
                if (data[it].ActionName == ConfigUserAction.globalNavigation && data[it].Privilage == 'View') {
                    console.log('this.canViewContent' + this.canViewContent);
                    this.canViewContent = true;
                }
                //if (data[it].ActionName == ConfigUserAction.marketbaseToMarktDef && data[it].Privilage == 'Edit') {
                //    console.log('this.canEditMarketBase' + this.canEditMarketBase);
                //    this.canEditMarketBase = true;
                //}
                if (data[it].ActionName == ConfigUserAction.SubscriptionService && data[it].Privilage == 'Delete') {
                    this.canDelMarketBase = true;
                }
                if (data[it].ActionName == ConfigUserAction.ViewContent && data[it].Privilage == 'Print') {
                    this.canPrintContent = true;
                }
                //console.log('this.canAddMarketBase' + this.canAddMarketBase);
            }
        }
        this.tempUserPermission = data;
    }
    private checkMyClient(clientId: number) {
        this.isMyclientsSelected = false;
        for (let it in this.myClients) {
            if (this.myClients[it].Id == clientId)
                this.isMyclientsSelected = true;
        }
        //if (this.tempUserPermission.length > 0)
        //    this.checkAccess(this.tempUserPermission);
        //else
        this.loadUserData();
        this.authService.isMyClientsSelected = this.isMyclientsSelected;
    }
    public editValid(cid: number, mid: number, event: Event) {
        //  routerLink = "/marketCreate/{{client.Id}}|{{marketDef.Id}}"
        this.subscriptionService.subscriptionID = 0;
        if (this.canEditMarketBase) {
            //var url = '/marketbase/' + cid + '|' + mid;
            var url = '/marketbase/' + cid + '|' + mid;
            this.router.navigateByUrl(url);
        }
        else {
            //console.log('this.canEditMarketBase' + this.canEditMarketBase);
            event.stopPropagation();
        }
    }

    disableDiv(cid: number, mid: number, event: Event) {
        //console.log('this.canEditMarketBase' + this.canEditMarketBase + cid + '|' + mid);
        var url = '/marketCreate/' + cid + '|' + mid;
        this.router.navigateByUrl(url);
        //this.authService.canMyClientAccess=
        //if (this.canEditMarketBase == false || this.canDelMarketBase == false) {
        //    //  alert('stop');
        //    event.stopPropagation();
        //    //event.preventDefault();
        //    return false;


        //}
        //else {
        //    //routerLink="/marketCreate/{{client.Id}}|{{marketDef.Id}}
        //    var url = '/marketCreate/' + cid + '|' + mid;
        //    this.router.navigateByUrl(url);
        //}
    }
    private CheckMenuVisibility() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var url = this.router.url;
        if (usrObj) {
            this.authService.CheckPermission('Subscription', '', 'Use global navigation toolbar')
                .subscribe(
                (data: any) => this.checkPermission(data),
                (err: any) => {
                    //this.SubErrorModal.show();
                    console.log(err);
                },
                () => console.log('data loaded')
                );
        }
    }
    private checkPermission(data: UserPermission[]) {
        // this.authService.canAllClientAccess = false;
        // this.authService.canMyClientAccess = false;

        if (data && data.length > 0) {
            for (let it in data) {
                //if (typeof data[it] !== 'undefined') {
                if (data[it].ModuleName == 'All Clients') {
                    //console.log("check view access -true")
                    this.authService.canAllClientAccess = true;
                    this.visibeAllClientBtn = true
                    //this.isAllClientsAccessible = true;

                }
                if (data[it].ModuleName == 'My Clients') {
                    //console.log("check view access -true")
                    this.authService.canMyClientAccess = true;
                    // this.isMyClientsAccessible = true;
                }
                //}
            }
        }
    }
    getYear() {
        var today = new Date();
        this.yy = today.getFullYear();
        this.years.push(this.yy - 1);
        for (var i = (this.yy); i <= (this.yy + 50); i++) {
            this.years.push(i);
        }
    }
    getMonth() {
        var today = new Date();
        this.mm = today.getMonth() + 1;
        if (this.mm < 10) {
            this.mon = '0' + this.mm
        }
    }
    setDefaultMonthYear(cid: number, subId: number, fromdt: Date, toDate: Date) {
        // debugger;
        if (this.canEditMarketBase) {
            this.lgSubDateModal.show();
            console.log('fromdt-' + fromdt);
            this.currentClientId = cid;
            this.authService.SelectedClientID = cid;
            this.selectedSubscriptionid = subId;
            var start = new Date(fromdt);
            var end = new Date(toDate);

            this.fromYear = start.getFullYear();
            this.fromMonth = (start.getMonth() + 1).toString();
            if ((start.getMonth() + 1) < 10) {
                this.fromMonth = '0' + this.fromMonth;
            }
            this.toYear = end.getFullYear();
            this.toMonth = (end.getMonth() + 1).toString();

            if ((end.getMonth() + 1) < 10) {
                this.toMonth = '0' + this.toMonth;
            }
            //var fMonth = this.months.filter(p => p.val == this.fromMonth)[0];
            //this.fromMonth = fMonth.name;

            //var tMonth = this.months.filter(p => p.val == this.toMonth)[0];
            //this.toMonth = tMonth.name;
            for (let it in this.monthsFrom) {
                if (this.monthsFrom[it].val == this.fromMonth)
                    this.monthsFrom[it].selected = true;
                else
                    this.monthsFrom[it].selected = false;
            }
            for (let it in this.monthsTo) {
                if (this.monthsTo[it].val == this.toMonth)
                    this.monthsTo[it].selected = true;
                else
                    this.monthsTo[it].selected = false;
            }
            this.curFromYear = this.fromYear;
            this.curToYear = this.toYear;
        }
    }

    dateRequest: any;
    UpdateSubscription() {
        this.dateRequest = {};
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
            this.dateRequest = {
                subscriptionid: this.selectedSubscriptionid,
                fromdate: "01/" + fMonth + "/" + this.curFromYear,
                todate: "01/" + tMonth + "/" + this.curToYear,
                clientid: this.currentClientId
            }
            var currentDate = new Date();
            var year = currentDate.getFullYear();
            if (this.curToYear < year) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "update_service_duration";
                this.modalTitle = '<span >By changing the end date to a previous year you will no longer be able to see this subscription/deliverable which will make it inactive </span>';
                this.modalBtnCapton = "Ok";

                jQuery("#nextModal").modal("show");
            }
            else {
                this.clientService.fnSetLoadingAction(true);
                this.subscriptionService.UpdateSubscription(this.dateRequest)
                    .subscribe(
                    r => (this.getSubscription(this.currentClientId), this.getDeliverables(this.currentClientId), this.lgSubDateModal.hide()),
                    e => (console.log("error" + e), this.clientService.fnSetLoadingAction(false))
                    );
                this.lgSubDateModal.hide();
            }
        }
    }
    previousYearFrom() {
        this.curFromYear = this.curFromYear - 1;
        //this.selectedFromYear = this.curFromYear;
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

    exportXLS(): void {

        /// this.downLoadQuery.ExportType = "xlsx";

        if (this.IsSubscriptionTab == false) {
            //jQuery(".collapse").collapse('show');
            // this.printDeliverables();
            this.subscriptionService.downloadDeliverables(this.currentClientId)
                .finally(() => {
                    this.clientService.fnSetLoadingAction(false)
                })
                .subscribe((res) => {
                    // console.log('Component'),
                    //console.log(res);
                    var downloadUrl = URL.createObjectURL(res);

                    const pdfUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetapplication/pdf' }));
                    const anchor = document.createElement('a');
                    anchor.download = `Deliverables.xlsx`;
                    anchor.href = pdfUrl;
                    anchor.click();
                    //console.log(downloadUrl);
                    // window.open(downloadUrl , "_blank");
                }),
                (err => console.log(err)),
                (() => console.log("export excel completd"));
            //setTimeout(this.printDeliverables(), 5000);
        }
        else {
            this.subscriptionService.downloadReport(this.currentClientId)
                .finally(() => {
                    this.clientService.fnSetLoadingAction(false)
                })
                .subscribe((res) => {
                    // console.log('Component'),
                    //console.log(res);
                    var downloadUrl = URL.createObjectURL(res);

                    const pdfUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetapplication/pdf' }));
                    const anchor = document.createElement('a');
                    anchor.download = `Subscriptions.xlsx`;
                    anchor.href = pdfUrl;
                    anchor.click();
                    //console.log(downloadUrl);
                    // window.open(downloadUrl , "_blank");
                }),
                (err => console.log(err)),
                (() => console.log("export excel completd"));
        }
    }
    PrintSubscription() {

        if (this.IsSubscriptionTab == false) {
            //jQuery(".collapse").collapse('show');
            this.printDeliverables();
            //setTimeout(this.printDeliverables(), 5000);
        }
        else {
            var pdf = new jsPDF('l', 'pt', 'a4');
            //var start = jQuery("#sampleDiv");
            //var head = jQuery("#SubName");
            //var tile = jQuery("#custWrapper");

            var options = {
                background: '#fff',
                pagesplit: true
            };
            var div = `<div id="printHeaderSubscription" class="mcHeading" >Subscriptions: ${this.selectedClientName} </b></div>`;

            pdf.addHTML(jQuery("#myTabContent").prepend(div), options, function () {
                //pdf.output("dataurlnewwindow");
                pdf.save('Subscriptions.pdf');
            });

            jQuery("#custWrapper").css("padding", "0px");
            jQuery("#printHeaderSubscription").remove();
        }
        //jQuery(".collapse").collapse('hide');
    }

    printDeliverables() {
        var pdf = new jsPDF('l', 'pt', 'a4');

        var options = {
            background: '#fff',
            pagesplit: true
        };

        var div = `<div id="printHeaderDeliv" class="mcHeading" >Subscriptions: ${this.selectedClientName} </b></div>`;

        pdf.addHTML(jQuery("#myTabContent").prepend(div), options, function () {
            // pdf.output("dataurlnewwindow");
            pdf.save('Deliverables.pdf');
        });

        jQuery("#custWrapperDeliverables").css("padding", "0px");
        jQuery("#printHeaderDeliv").remove();
    }
    selectTab(tabName: string) {
        if (tabName == 'subscription')
            this.IsSubscriptionTab = true;
        else
            this.IsSubscriptionTab = false;
    }
    async EditDeliverables(clientid: number, deliveryid: number) {
        var url = '/deliverablesedit/' + clientid + '|' + deliveryid + '|' + (this.isMyclientsSelected == true ? 1 : 0) + '|' + (this.isMyClientsVisible == true ? 1 : 0) + '/Edit Lock';
        var msg = "";
        this.clientService.fnSetLoadingAction(true);
        //this.subscriptionService.CheckDeliveryLock(deliveryid)
        //    .subscribe(
        //    r => (this.NavigateEdit(r, url), this.clientService.fnSetLoadingAction(false)),
        //    e => (console.log("error" + e), this.clientService.fnSetLoadingAction(false))
        //    );
        let currentlyEditingUserList: any[] = [];
        //to get previous lock history
        await this.clientService.getDefinitionLockHistories(this.usrObj.UserID, deliveryid, "Delivery Module", "Edit Lock", "Check Status")
            .then(result => { console.log(result); currentlyEditingUserList = result || []; this.clientService.fnSetLoadingAction(false); })
            .catch((err: any) => { this.clientService.fnSetLoadingAction(false) });

        if (this.canEditDeliverable && currentlyEditingUserList.length == 0) {//route other page           
            this.router.navigateByUrl(url);

        }
        else if (currentlyEditingUserList.length > 0) {
            // this.SaveMessage = 'The definition is currently being edited by <b>' + currentlyEditingUserList[0].Status + '</b>, hence cannot be edited, please try later.';

            if ((currentlyEditingUserList[0].CurrentUserType == '1' || currentlyEditingUserList[0].CurrentUserType == true) && (currentlyEditingUserList[0].LockUserType == '0' || currentlyEditingUserList[0].LockUserType == false)) {
                this.SaveMessage = '<span >The definition is currently being edited by <b>IQVIA</b>, hence cannot be edited, please try later.</span>';
            } else {
                this.SaveMessage = '<span >The definition is currently being edited by <b>' + currentlyEditingUserList[0].LockUserName + '</b>, hence cannot be edited, please try later.</span>';
            }

            this.lgSubSaveModal.show();
            return false;
        }
        // return false; 

    }

    ViewDeliverables(clientid: number, deliveryid: number) {
        var url = '/deliverablesedit/' + clientid + '|' + deliveryid + '|' + (this.isMyclientsSelected == true ? 1 : 0) + '|' + (this.isMyClientsVisible == true ? 1 : 0) + '/View Lock';
        this.router.navigateByUrl(url);
        //let currentlyEditingUserList: any[] = [];
        ////to get previous lock history
        //await this.clientService.getDefinitionLockHistories(this.usrObj.UserID, deliveryid, "Delivery Module", "View Lock", "Check Status")
        //    .then(result => { console.log(result); currentlyEditingUserList = result || []; this.clientService.fnSetLoadingAction(false); })
        //    .catch((err: any) => { this.clientService.fnSetLoadingAction(false) });

        //if (currentlyEditingUserList.length == 0) {//route other page           
        //    this.router.navigateByUrl(url);
        //    console.log('currentlyEditingUserList.length =0');
        //}
        //else if (currentlyEditingUserList.length > 0) {
        //    this.SaveMessage = '<span >The definition is currently being edited by <b>' + currentlyEditingUserList[0].Status + '</b>, hence cannot be edited, please try later.</span>';
        //    this.lgSubSaveModal.show();
        //    console.log('currentlyEditingUserList.length >0');
        //    return false;
        //}
        //alert(currentlyEditingUserList.length);
        // return false; 

    }
    //NavigateEdit(msg:string,url:string)
    //{
    //    if (msg.length > 0) {
    //        this.SaveMessage = msg;
    //        this.lgSubSaveModal.show();
    //        return;
    //    }
    //    else {
    //        this.router.navigateByUrl(url);
    //    }

    //}
    redrictToURL(url: string, param: string) {
        this.router.navigate([url + param]);
    }

    CheckTerritoryBase(terBase: string) {
        if (terBase.toLowerCase() == "both") {
            return false;
        }
        else
            return true;
    }

    getRestriction(ResId: number, ResName: string) {
        if (ResId == null || ResId == 0 || ResId.toString() == '')
            return 'N/A';
        else
            return ResName;
    }
    VisibleTerritoryBase(terBase: any) {
        if (terBase.ServiceTerritoryId == 1 || terBase.ServiceTerritoryId == 2 || terBase.ServiceTerritoryId == 3) {
            return true;
        }
        else {
            return false;
        }

    }
    public DeliveryCloneList: any[];
    public DeliverablesByPage: any[] = [];
    public deliverytotalItems: number
    SaveMessage: string = "";
    ShowCloneDeliverableList() {
        this.DeliveryCloneList = [];
        for (let it in this.deliverablesList) {
            var data = {
                'DeliverableId': this.deliverablesList[it].DeliverableId,
                'DisplayName': this.deliverablesList[it].DisplayName,
                'selected': false,
                'disabled': !((this.deliverablesList[it].DeliveryTypeId == 2) || (this.deliverablesList[it].DeliveryTypeId == 3))
            };
            this.DeliveryCloneList.push(data);
        }

        this.setDeliveryPagination(),
            //console.log(this.DeliveryCloneList);
            this.lgDeliveryModal.show();
    }

    public PageChangedDelivery(event: any): void {
        this.CurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.DeliverablesByPage = this.DeliveryCloneList.slice(startIndex, endIndex)

    }

    setDeliveryPagination(): void {
        this.deliverytotalItems = this.DeliveryCloneList.length;
        this.PageChangedDelivery({ page: 1, itemsPerPage: this.itemsPerPage })
    }

    CloneDeliverables() {
        var delIds = this.getSelectedValues(this.DeliveryCloneList, 'DeliverableId');
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        var request = {
            userid: userid,
            deliverableid: delIds,
            clientid: this.currentClientId
        }
        if (delIds.length > 1)
            this.SaveMessage = "Copy of the deliverables had been created";
        else
            this.SaveMessage = "Copy of the deliverable had been created";

        this.clientService.fnSetLoadingAction(true);
        this.subscriptionService.CloneDeliverables(request)
            .subscribe(
            r => (this.getDeliverables(this.currentClientId),
                this.lgSubSaveModal.show()),
            e => (this.clientService.fnSetLoadingAction(false),
                (delIds.length > 1) ? this.SaveMessage = "System couldn’t create copy of the deliverables, please try again" : this.SaveMessage = "System couldn’t create copy of the deliverable, please try again",
                this.lgSubSaveModal.show(), console.log("error" + e))
            );
        this.lgDeliveryModal.hide();
        this.DeliveryCloneList.forEach(x => x.selected = false);
        this.isMenuNavigation = true;
    }
    buttonDeliveryCloneState() {
        if (this.DeliveryCloneList != undefined) {
            var ret = this.DeliveryCloneList.filter(x => x.selected == true);
            return !this.DeliveryCloneList.some(x => x.selected == true);
        }

        // return true;
    }
}
