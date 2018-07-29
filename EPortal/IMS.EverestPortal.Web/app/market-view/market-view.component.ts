import { Component, OnInit, ViewChild } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Client } from '../shared/models/client';
import { MarketDefinition } from '../shared/models/market-definition';
import { MarketDefDTO } from '../shared/models/market-definition';
import { CLIENTS } from '../shared/models/mock-clients';
import { ClientService } from '../shared/services/client.service';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';
import { ConfigService } from '../config.service';
import { ModalDirective } from 'ng2-bootstrap';
import { AlertService } from '../shared/component/alert/alert.service';


declare var jQuery: any;

@Component({
    selector: 'market-view',
    templateUrl: '../../app/market-view/market-view.html',
    styleUrls: ['../../app/market-view/clients-sidebar.css', '../../app/subscription/subscription.css']
    //providers: [ClientService]
})
export class MarketViewComponent implements OnInit {
    @ViewChild('mViewErrModal') mViewErrModal: ModalDirective
    @ViewChild('MarketDefModal') MarketDefModal: ModalDirective

    loading: boolean = true;
    noMarketDefs: boolean = false;
    selectedMarketDefId: number;
    clients: Client[] = [];
    myClients: Client[] = [];
    searchedClients: Client[] = [];
    tempUserPermission: UserPermission[] = [];
    temporaryUserPermission = { myClientPermission: [], allClientPermission: [] }

    client: Client;
    clientsFiltered: Client[] = [];
    marketdefinition: MarketDefinition[] = [];
    marletDefDTO: any[] = [];
    isMyclientsSelected: boolean;
    isSearch: boolean;
    toggleTitle: string = 'All Clients';
    public createMarketLink: string;

    public deletedMarketDefinitionID: number;
    public deletedClientID: number;
    public dynamicModalSaveFunction: any;
    public modalTitle = '<span ></span>';
    public modalSaveBtnVisibility: boolean = false;
    public modalSaveFnParameter: string = "";
    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Cancel";
    public selectedClientID: number = 0;
    public selectedClientName: string;
    public deliverableList: any[] = [];

    breadCrumbUrl: string;
    isMyClientsVisible: boolean;
    paramID: string;

    stringFilter: string = '';
    //authentication variables
    canCreateMarket: boolean = false;
    canEditMarket: boolean = false;
    canDeleteMarket: boolean = false;
    canViewContent: boolean = false;
    visibeAllClientBtn: boolean = false;
    loginUserObj: any;

    userId: number = 0;

    constructor(private clientService: ClientService, public route: ActivatedRoute, private _cookieService: CookieService, private authService: AuthService,
        private router: Router, private alertService: AlertService) {
        this.loginUserObj = this._cookieService.getObject('CurrentUser');

    }

    getClients(): void {//to get all clients
        this.clientService.getMockClientsByPromise(this.isMyclientsSelected).then(clients => {
            this.clients = clients;
            this.onSelectClientsType(this.isMyclientsSelected);
        });

    }

    ngOnInit(): void {
        //find user id from login cookie.
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            this.userId = usrObj.UserID;
        }


        this.clientService.fnSetLoadingAction(true);
        this.paramID = this.route.snapshot.params['id'];
        this.authService.selectedMarketModule = this.paramID;
        this.selectedClientID = this.route.snapshot.params['id2'] || 0;
        if (this.paramID == "mymarkets") {
            this.isMyclientsSelected = true;
            this.isMyClientsVisible = true;
            this.toggleTitle = "My Markets";
            this.breadCrumbUrl = "/markets/mymarkets";
        }
        else if (this.paramID == "My-Client") {
            this.fnSetNavigationFlag(true);
            this.isMyclientsSelected = true;
        } else if (this.paramID == "All-Client") {
            this.isMyclientsSelected = false;
            this.fnSetNavigationFlag(false);
        } else {
            this.fnSetNavigationFlag(true);
        }
        // }

        this.authService.canAllClientAccess = false;
        this.CheckMenuVisibility();

        this.subscribeToClientList();
        //this.loadUserData();
        this.authService.isMyClientsSelected = this.isMyclientsSelected
        this.visibeAllClientBtn = this.authService.canAllClientAccess;
        //this.isMyclientsSelected = true;
        //this.isSearch = false;

        //--for mock data
        //this.subscribeToMockClientList();

        //this.clientService.getMarketDefinitionsForClient(this.clients[0].Id).subscribe(data => this.clientsFiltered = data);

        //console.log('inside on init, isMyClientsSelected: ', this.isMyclientsSelected);
    }

    subscribeToClientList() {
        this.clientService.fnSetLoadingAction(true);
        if (this.clients.length == 0) {
            this.clientService.getClients(this.userId)
                .finally(() => this.clientService.fnSetLoadingAction(true))
                .subscribe(
                (data: any) => {
                    this._processClients(data); //this.clientService.fnSetLoadingAction(false) 
                },
                (err: any) => {
                    this.mViewErrModal.show();
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log('clients loaded')
                );
        }
    }


    private _processClients(data: Client[]) {
        //console.log('data length: ', data.length);
        var tempClients: Client[] = [];
        for (let item in data) {
            tempClients.push({ Id: data[item].Id, Name: data[item].Name, IsMyClient: data[item].IsMyClient, MarketDefinitions: [] });
        }
        this.clients = tempClients;
        this.myClients = this.clients.filter(u => u.IsMyClient == true);
        var firstClient = this.isMyclientsSelected ? this.myClients[0] : this.clients[0];
        if (firstClient) {
            this.selectedClientName = firstClient.Name;
        }
        //console.log('nav: first client: ', firstClient);
        //to check selectedID of auth service
        // if(this.authService.SelectedClientID>0){
        //     this.selectedClientID=this.authService.SelectedClientID;//to assing selected client ID from auth service
        //     console.log("client ID from auth service:"+this.authService.SelectedClientID);
        // }


        if (this.selectedClientID > 0) {//for selected client
            //this.createMarketLink = '/marketCreate/' + this.selectedClientID + '/No Lock';
            this.createMarketLink = '/group/' + this.selectedClientID + '/No Lock';
            this.selectedClientName = this.clients.filter(u => u.Id == this.selectedClientID)[0].Name;//set client name accouding to client ID
            this.getClient(this.selectedClientID);
            //to check is my client or not;
            let isSelectedClientCategory = this.clients.filter(u => u.Id == this.selectedClientID)[0].IsMyClient || false;
            if (isSelectedClientCategory) {
                this.fnSetNavigationFlag(true);
            } else {
                this.fnSetNavigationFlag(false);
            }
            //end of my client checking
        } else if (this.authService.SelectedClientID > 0) {
            this.selectedClientID = this.authService.SelectedClientID;
            //this.createMarketLink = '/marketCreate/' + this.selectedClientID + '/No Lock';
            this.createMarketLink = '/group/' + this.selectedClientID + '/No Lock';
            let isSelectedClientCategory = this.clients.filter(u => u.Id == this.selectedClientID)[0].IsMyClient || false;
            if (ConfigService.clientFlag && isSelectedClientCategory) {
                this.getClient(this.selectedClientID);
                this.fnSetNavigationFlag(true);
            } else if (ConfigService.clientFlag) {
                if (firstClient) {
                    this.getClient(firstClient.Id);
                    this.selectedClientID = firstClient.Id;
                    this.authService.SelectedClientID = firstClient.Id;
                    this.fnSetNavigationFlag(true);
                }
            } else {
                this.getClient(this.selectedClientID);
                this.fnSetNavigationFlag(false);
            }
        } else {
            if (firstClient) {
                //this.createMarketLink = '/marketCreate/' + firstClient.Id + '/No Lock';
                this.createMarketLink = '/group/' + firstClient.Id + '/No Lock';
                this.getClient(firstClient.Id);
                this.selectedClientID = firstClient.Id;
                this.authService.SelectedClientID = firstClient.Id;//to assing selected client ID into authService
            }
            else
                this.clientService.fnSetLoadingAction(false);
        }

    }

    private fnSetNavigationFlag(isMyClient: boolean) {
        if (this.paramID == "mymarkets") {
            this.isMyclientsSelected = true;
            this.isMyClientsVisible = true;
            this.breadCrumbUrl = "/markets/mymarkets";
            this.toggleTitle = "My Markets";
            ConfigService.clientFlag = true;
        } else {
            if (isMyClient) {
                this.isMyclientsSelected = true;
                this.isMyClientsVisible = true;
                this.breadCrumbUrl = "/market/My-Client";
                this.toggleTitle = "My Clients";
                ConfigService.clientFlag = true;
            } else {
                //this.isMyclientsSelected = false;
                this.isMyClientsVisible = false;
                this.breadCrumbUrl = "/marketAllClient/All-Client";
                this.toggleTitle = "All Clients";
                ConfigService.clientFlag = false;
            }
        }

    }
    onSelectClientsType(selection: boolean) {
        this.isMyclientsSelected = selection;
        this.isMyClientsVisible = selection;
        ConfigService.clientFlag = selection;

        this.stringFilter = '';
        if (selection === true) {
            this.toggleTitle = "My Clients";
            if (this.selectedClientID > 0 && this.clients.filter(u => u.Id == this.selectedClientID && u.IsMyClient == selection).length > 0) {
                let selectedClientInfo = this.clients.filter(u => u.Id == this.selectedClientID && u.IsMyClient == selection)[0];
                this.fnSelectClientsInTab(selectedClientInfo);
            } else {
                this.fnSelectClientsInTab((selection) ? this.myClients[0] : this.clients[0]);
            }
        } else {
            this.toggleTitle = "All Clients";
            if (this.selectedClientID > 0 && this.clients.filter(u => u.Id == this.selectedClientID).length > 0) {
                this.fnSelectClientsInTab(this.clients.filter(u => u.Id == this.selectedClientID)[0]);
            } else {
                this.fnSelectClientsInTab((selection) ? this.myClients[0] : this.clients[0]);
            }
        }

        if (this.tempUserPermission.length > 0)
            this.checkAccess(this.tempUserPermission);
        else
            this.loadUserData();
    }

    fnSelectMyClientAllClient(type: string) {
        if (type == "My-Client") {
            this.router.navigate(['market/My-Client']);
        } else {
            this.router.navigate(['marketAllClient/All-Client']);
        }
    }

    fnSelectClientsInTab(selectedClient: Client) {
        if (selectedClient) {
            this.selectedClientName = selectedClient.Name;//Set firstClient Name 
            this.getClient(selectedClient.Id);
            this.selectedClientID = selectedClient.Id;//to select client in view
            this.authService.SelectedClientID = selectedClient.Id;//to assing selected client ID into authService
            //this.createMarketLink = '/marketCreate/' + selectedClient.Id + '/No Lock';
            this.createMarketLink = '/group/' + selectedClient.Id + '/No Lock';
        }
    }

    loadMarketDefinition(selectedClient: Client): void {
        this.client = selectedClient;
        //this.createMarketLink = '/marketCreate/' + selectedClient.Id + '/No Lock';
        this.createMarketLink = '/group/' + selectedClient.Id + '/No Lock';
        this.selectedClientName = selectedClient.Name;
        this.selectedClientID = selectedClient.Id;
        this.authService.SelectedClientID = selectedClient.Id;//to assing selected client ID into authService
        this.getClient(selectedClient.Id);
        //this.checkMyClient(selectedClient.Id);
        //console.log(this.clientsFiltered);
    }

    fnModalCloseClick(action: string) {
        jQuery("#nextModal").modal("hide");
    }

    searchClient(searchKey: string, selection: boolean) {
        //--for mock data
        //this.clientService.getMockClientsBySearch(searchKey, this.clients).subscribe(data => this.clients = data);
        //this.isSearch = true;
        var sourceList = (selection) ? this.myClients : this.clients;
        this.clientService.getClientsBySearch(searchKey, sourceList).subscribe(data => this.searchedClients = data);
    }

    refreshClientList(selection: boolean) {
        if (this.stringFilter) {
            this.stringFilter = '';
            this.searchedClients = [];
            var firstClient = (selection) ? this.myClients[0] : this.clients[0];
            this.selectedClientName = firstClient.Name;
            this.selectedClientID = firstClient.Id;
            this.authService.SelectedClientID = firstClient.Id;//to assing selected client ID into authService
            this.getClient(firstClient.Id);
        }
    }

    subscribeToClientMarketDefinition(): void {
        this.clientService.getMockMarketDefinition().subscribe(client => this.client = client);
    }

    subscribeToMockClientList(): void {
        this.clientService.getMockClients(this.isMyclientsSelected).subscribe(data => { console.log('testing click my clients ', data); this.clients = data; console.log('after success: ', this.clients); });
    }

    getClient(clientId: number) {
        this.selectedClientName = this.clients.filter(u => u.Id == clientId)[0].Name;//set client name accouding to client ID
        this.loading = true;
        this.clientService.fnSetLoadingAction(true);
        this.noMarketDefs = false;
        jQuery('#custWrapper').css('display', 'hidden');
        this.clientService.fnGetMarketDefinition(clientId).subscribe(
            (data: any) => { this._processMarketDefinitionTiles(data) },
            (err: any) => {
                this.mViewErrModal.show();
                this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Market Definitions loaded')
        );


        // this.clientService.getClient(clientId).subscribe(
        //     (data: any) => this._processMarketDefinition(data),
        //     (err: any) => {
        //         this.mViewErrModal.show();
        //         this.clientService.fnSetLoadingAction(false);
        //         console.log(err);
        //     },
        //     () => console.log('Market Definitions loaded')
        // );
        this.checkMyClient(clientId);
    }
    private _processMarketDefinitionTiles(data: MarketDefinition[]) {
        //console.log('inside callback');
        // this.clientsFiltered = [];
        // this.clientsFiltered.push(data);
        //console.log(this.clientsFiltered);
        this.marketdefinition = data || [];
        this.loading = false;
        this.clientService.fnSetLoadingAction(false);
        if (this.marketdefinition.length === 0) this.noMarketDefs = true;
        jQuery('#custWrapper').css('display', 'block');
        //console.log('inside final callback');
    }
    private _processMarketDefinition(data: Client) {
        //console.log('inside callback');
        this.clientsFiltered = [];
        this.clientsFiltered.push(data);
        //console.log("client fitlered array:");
        //console.log(this.clientsFiltered);
        this.loading = false;
        this.clientService.fnSetLoadingAction(false);
        if (data.MarketDefinitions.length === 0) this.noMarketDefs = true;
        //console.log('mkt defs: ', data.MarketDefinitions, ' noMarketDefs: ', this.noMarketDefs);
        jQuery('#custWrapper').css('display', 'block');
        //console.log('inside final callback');
    }


    async fnDeleteMarketDefinition(clientID: number, marketDefinitionID: number, marketDefinitinName: string, event: Event) {
        this.clientService.fnSetLoadingAction(true);
        this.deliverableList = [];
        let deliverableName: string = "";
        let currentlyUsingUserList = [];
        //to check its lock or not
        await this.clientService.getDefinitionLockHistories(this.loginUserObj.UserID, marketDefinitionID, "Market Module", "All Lock", "Check for Delete")
            .then(result => { console.log(result); currentlyUsingUserList = result || []; this.clientService.fnSetLoadingAction(false); })
            .catch((err: any) => { this.clientService.fnSetLoadingAction(false); this.mViewErrModal.show(); });

        if (currentlyUsingUserList.length > 0) {// locked by other user
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = '<span >The definition is currently being viewed by another user, hence cannot be deleted. Please try later.</span>';
            this.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            return false;
        }

        await this.fnGetMarketDefSubscribledList(clientID, marketDefinitionID);
        this.clientService.fnSetLoadingAction(false);
        if (this.deliverableList.length > 0) {
            deliverableName = '<ul>';
            this.deliverableList.forEach((rec: any) => {
                deliverableName = deliverableName + '<li>' + rec + '</li>';
            });
            deliverableName = deliverableName + '</ul>';

            if (this.canDeleteMarket) {
                this.deletedMarketDefinitionID = marketDefinitionID;
                this.deletedClientID = clientID;
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "delete Market Definition";
                this.modalTitle = '<span >Deleting <b>' + marketDefinitinName + '</b> will remove this from following deliverables: <br/><div class="error-list">' + deliverableName + '</div> Are you sure you would like to delete?</span>';
                this.modalBtnCapton = "Yes";
                jQuery("#nextModal").modal("show");
                //event.stopPropagation();
                return false;
            }
            else {
                //console.log('delete false');
                event.stopPropagation();
                return false;
            }
        } else {
            if (this.canDeleteMarket) {
                this.deletedMarketDefinitionID = marketDefinitionID;
                this.deletedClientID = clientID;
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "delete Market Definition";
                this.modalTitle = '<span >Do you want to delete market definition ' + marketDefinitinName + '?</span>';
                this.modalBtnCapton = "Yes";
                jQuery("#nextModal").modal("show");
                //event.stopPropagation();
                return false;
            }
            else {
                //console.log('delete false');
                event.stopPropagation();
                return false;
            }
        }

    }
    async fnGetMarketDefSubscribledList(clientId: number, marketDefId: number) {
        await this.clientService.checkSubcribedMarketDef(clientId, marketDefId)
            .then(
            (data: any) => { this.deliverableList = data || []; console.log(data) })
            .catch((err: any) => {
                this.clientService.fnSetLoadingAction(false);
                //this.mViewErrModal.show();//off to show mgs
                console.log(err);
            });
    }
    public btnModalSaveClick(action: string): void {
        if (action == "delete Market Definition") {
            let clientID = this.deletedClientID;
            let marketDefinitionID = this.deletedMarketDefinitionID;
            //write here code for deleted.
            this.subscribeToDeleteClientMarketDef(clientID, marketDefinitionID);
            this.deletedClientID = 0;
            this.deletedMarketDefinitionID = 0;

            // var selectedStaticInfo = this.clientsFiltered[0].MarketDefinitions.filter((rec: any) => rec.Id == marketDefinitionID)[0];
            // this.clientsFiltered[0].MarketDefinitions.splice(this.clientsFiltered[0].MarketDefinitions.indexOf(selectedStaticInfo), 1);


            var selectedStaticInfo = this.marketdefinition.filter((rec: any) => rec.Id == marketDefinitionID)[0];
            this.marketdefinition.splice(this.marketdefinition.indexOf(selectedStaticInfo), 1);
            //location.reload();

        }
        jQuery("#nextModal").modal("hide");
    }

    private subscribeToDeleteClientMarketDef(ClientId: number, MarketDefId: number) {
        //edit market definition
        //console.log('inside process client: ');
        //this.clientsFiltered[0].MarketDefinitions[0].MarketDefinitionPacks = this.dynamicPackMarketBase;
        this.clientService.deleteClientMarketDef(ClientId, MarketDefId).subscribe(
            (data: any) => {
                console.log("success fn call");
                console.log(data)
            },
            (err: any) => {
                this.clientService.fnSetLoadingAction(false);
                //this.mViewErrModal.show();//off to show mgs
                //if (err.status == 0) {
                //    this.alertService.alert("System has failed to connect with server due to network problem.");
                //} else {
                //    this.alertService.alert(err.json().Message);
                //}
                console.log("error method");
                console.log(err);
            },
            () => {
                console.log("deleted client list: ")
                //console.log(data);
            }
        );

        // this.route.navigate["/market"];
        //this.router.navigate(['About']); // here "About" is name not path
    }
    private loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('Market', (this.isMyclientsSelected ? 'My Clients' : 'All Clients'), roleid)
                .finally(() => this.clientService.fnSetLoadingAction(false))
                .subscribe(
                (data: any) => {
                    if (this.isMyclientsSelected) {
                        this.temporaryUserPermission.myClientPermission = data
                    } else {
                        this.temporaryUserPermission.allClientPermission = data
                    }
                    this.checkAccess(data)
                },
                (err: any) => {
                    this.mViewErrModal.show();
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log('data loaded')
                );
        }
    }

    private checkAccess(data: UserPermission[]) {
        //assign fromm temporary variable;
        if (this.isMyclientsSelected) {
            data = this.temporaryUserPermission.myClientPermission;
        }
        else {
            data = this.temporaryUserPermission.allClientPermission;
        }

        //console.log('this.isMyclientsSelected: ', this.isMyclientsSelected);
        this.canCreateMarket = false;
        // this.canViewContent = true;
        this.canEditMarket = false;
        this.canDeleteMarket = false;
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
                //console.log('item=' + data[it].ActionName + "-" + data[it].Privilage);
                if (data[it].ActionName == ConfigUserAction.marketdefinition && data[it].Privilage == 'Add') {
                    this.canCreateMarket = true;
                }
                if (data[it].ActionName == ConfigUserAction.globalNavigation && data[it].Privilage == 'View') {
                    //console.log('this.canViewContent' + this.canViewContent);
                    this.canViewContent = true;
                }
                if (data[it].ActionName == ConfigUserAction.marketbaseToMarktDef && data[it].Privilage == 'Add') {
                    //console.log('this.canEditMarket' + this.canEditMarket);
                    this.canEditMarket = true;
                }
                if (data[it].ActionName == ConfigUserAction.marketbaseToMarktDef && data[it].Privilage == 'Delete') {
                    // console.log('this.canDeleteMarket' + this.canDeleteMarket);
                    this.canDeleteMarket = true;
                }
                //console.log('this.canCreateMarket' + this.canCreateMarket);
            }
        }

        var usrObj: any = this._cookieService.getObject('CurrentUser');

        if (this.isMyclientsSelected && usrObj.RoleName != 'Client Manager') {
            this.canCreateMarket = true;
            this.canEditMarket = true;
            this.canDeleteMarket = true;
            this.canViewContent = true;
        }
        this.tempUserPermission = data;
    }
    private checkMyClient(clientId: number) {
        this.isMyclientsSelected = false;
        for (let it in this.myClients) {
            if (this.myClients[it].Id == clientId)
                this.isMyclientsSelected = true;
        }

        /*if (this.tempUserPermission.length > 0)
            this.checkAccess(this.tempUserPermission);
        else
            this.loadUserData();
        */
        if (this.temporaryUserPermission.myClientPermission.length > 0 && this.isMyclientsSelected) {
            this.checkAccess(this.tempUserPermission);
        } else if (this.temporaryUserPermission.allClientPermission.length > 0 && !this.isMyclientsSelected) {
            this.checkAccess(this.tempUserPermission);
        }
        else
            this.loadUserData();

        this.authService.isMyClientsSelected = this.isMyclientsSelected;
    }
    async fnEditMarketDefinition(marketDef: any) {

        this.clientService.fnSetLoadingAction(true);
        let currentlyEditingUserList: any[] = [];
        //to get previous lock history
        await this.clientService.getDefinitionLockHistories(this.loginUserObj.UserID, marketDef.Id, "Market Module", "Edit Lock", "Check Status")
            .then(result => { console.log(result); currentlyEditingUserList = result || []; this.clientService.fnSetLoadingAction(false); })
            .catch((err: any) => { this.clientService.fnSetLoadingAction(false); this.mViewErrModal.show(); });

        if (this.canEditMarket && currentlyEditingUserList.length == 0) {//route other page   
            var url = '/group/' + marketDef.ClientId + '|' + marketDef.Id + '/Edit Lock';
            /* if (this.selectedClientID == 72) {
                 var url = '/group/' + marketDef.ClientId + '|' + marketDef.Id + '/Edit Lock';
             } else {
                 var url = '/marketCreate/' + marketDef.ClientId + '|' + marketDef.Id + '/Edit Lock';
             }*/
            this.router.navigateByUrl(url);

        }
        else if (currentlyEditingUserList.length > 0) {
            if ((currentlyEditingUserList[0].CurrentUserType == '1' || currentlyEditingUserList[0].CurrentUserType == true) && (currentlyEditingUserList[0].LockUserType == '0' || currentlyEditingUserList[0].LockUserType == false)) {
                this.modalTitle = '<span >The definition is currently being edited by <b>IQVIA</b>, hence cannot be edited, please try later.</span>';
            } else {
                this.modalTitle = '<span >The definition is currently being edited by <b>' + currentlyEditingUserList[0].LockUserName + '</b>, hence cannot be edited, please try later.</span>';
            }
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";

            this.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            return false;
        }
        else {
            //console.log('this.canEditMarket' + this.canEditMarket);
            event.stopPropagation();
        }


    }

    async fnReadOnlyMarketDef(cid: number, mid: number, event: Event) {
        //console.log('this.canEditMarket' + this.canEditMarket + cid + '|' + mid);
        var url = '/group/' + cid + '|' + mid + '/View Lock';
        this.router.navigateByUrl(url);
    }

    private CheckMenuVisibility() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var url = this.router.url;
        if (usrObj) {
            this.authService.CheckPermission('Market', '', 'Use global navigation toolbar')
                .subscribe(
                (data: any) => this.checkPermission(data),
                (err: any) => {
                    this.clientService.fnSetLoadingAction(false);
                    //this.mViewErrModal.show();
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

    private SubmitMarketButton() {
        jQuery(".market-submission-checkbox").prop('checked', false);
        this.marletDefDTO = [];
        this.loading = true;
        this.clientService.fnSetLoadingAction(true);
        this.noMarketDefs = false;
        jQuery('#custWrapper').css('display', 'hidden');
        jQuery('#SuccessMessage').css('display', 'none');
        this.clientService.fnGetMarketDefinitionByClient(this.selectedClientID).subscribe(
            (data: any) => { this._processMarketDTOTiles(data); },
            (err: any) => {
                this.mViewErrModal.show();
                this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Market Definitions loaded')
        );


        this.MarketDefModal.show();

    }

    private _processMarketDTOTiles(data: MarketDefDTO[]) {
        this.marletDefDTO = data || [];
        //this.marletDefDTO = this.marletDefDTO.sort(function (a, b) {
        //    if (a.Name.toLowerCase() < b.Name.toLowerCase()) return -1;
        //    if (a.Name.toLowerCase() > b.Name.toLowerCase()) return 1;
        //    return 0;
        //});

        //this.marletDefDTO = this.marletDefDTO.sort(function (a, b) {
        //    if (a.Submitted < b.Submitted) return -1;
        //    if (a.Submitted > b.Submitted) return 1;
        //    return 0;

        //});

        this.loading = false;
        this.clientService.fnSetLoadingAction(false);
        jQuery('#custWrapper').css('display', 'block');
    }

    private CancelSubmitMarketPopup() {
        //jQuery('#SuccessMessage').css('display', 'hiddenno');
        this.MarketDefModal.hide();
    }

    private SubmitMarketDef(MarketDefID: number) {
        this.alertService.fnLoading(true);
        //this.MarketDefModal.hide();
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        var selectedMarket: any = this.getSelectedMarkets();
        var MarketDefIDs = selectedMarket.map(x => x.Id);
        this.clientService.fnSubmitMarketDef(MarketDefIDs, userid).subscribe((data: any) => {
            jQuery(".market-submission-checkbox").prop('checked', false);
            this.alertService.fnLoading(false);
            this.selectedMarketDefId = 0;
            this.SubmitMarketButton();
            jQuery('#SuccessMessage').css('display', 'block');
            // this.alertService.alert("Market definition version has submitted successfully.");
        },
            (err: any) => {
                this.alertService.fnLoading(false);
                console.log(err);
            }
        );
    }

    getSelectedMarkets() { // right now: ['1','3']
        var list1: any = this.marletDefDTO
            .filter(opt => opt.selected)
        //.find(x => x.subscription.subscriptionId)
        debugger
        return list1;

    }
}
