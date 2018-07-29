import { Component, OnInit, ViewChild } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Client } from '../shared/models/client';
import { CLIENTS } from '../shared/models/mock-clients';
import { Territory } from '../shared/models/territory/territorydefinition.model';
import { TerritoryDTO } from '../shared/models/territory/territorydefinition.model';
import { ClientService } from '../shared/services/client.service';
import { TerritoryDefinitionService } from '../shared/services/territorydefinition.service';
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
    templateUrl: '../../app/territorydefinition/territory-view.html',
    styleUrls: ['../../app/market-view/clients-sidebar.css', '../../app/subscription/subscription.css']
    //providers: [ClientService]
})
export class TerritoryViewComponent implements OnInit {
    @ViewChild('tViewErrModal') tViewErrModal: ModalDirective
    @ViewChild('TerritoryModal') TerritoryModal: ModalDirective

    loading: boolean = true;
    noTerritoryDefs: boolean = false;
    clients: Client[] = [];
    myClients: Client[] = [];
    searchedClients: Client[] = [];
    tempUserPermission: UserPermission[] = [];
    temporaryUserPermission = { allClientPermission: [], myClientPermission: [] };

    client: Client;
    territoryDefinitionsFiltered: Territory[] = [];
    territoryfDTO: TerritoryDTO[] = [];

    selectedTerritoryId: number;

    isMyclientsSelected: boolean;
    isSearch: boolean;
    toggleTitle: string = 'All Clients';
    public createTerritoryLink: string;

    public deletedTerritoryDefinitionID: number;
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
    public loginUserObj: any;
    public paramID: string;

    breadCrumbUrl: string;
    isMyClientsVisible: boolean;
    isMyClientsAccessible: boolean; //check for tab visibility
    stringFilter: string = '';
    //authentication variables
    canCreateTerrDef: boolean = false;
    canEditTerrDef: boolean = false;
    canDeleteTerrDef: boolean = false;
    canViewContent: boolean = false;
    visibeAllClientBtn: boolean = false;
    IsEditDefDependOnClientType: boolean = false;
    isSubmitButtonVisible: boolean = true;

    userId: number = 0;

    constructor(private clientService: ClientService, private alertService: AlertService, public route: ActivatedRoute, private _cookieService: CookieService, private authService: AuthService,
        private territoryService: TerritoryDefinitionService, private router: Router) {
        this.loginUserObj = this._cookieService.getObject('CurrentUser');
    }

    getClients(): void {
        this.clientService.getMockClientsByPromise(this.isMyclientsSelected).then(clients => {
            this.clients = clients;
            this.onSelectClientsType(this.isMyclientsSelected);
        });

    }

    ngOnInit(): void {
        //find user id from login cookie.
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            this.userId = usrObj.UserID

            let currentRole = usrObj.RoleName;
            if (currentRole != null && currentRole === 'Third Party') {
                this.isSubmitButtonVisible = false;
            }
        }
        
        this.clientService.fnSetLoadingAction(true);
        this.paramID = this.route.snapshot.params['id'];
        this.selectedClientID = this.route.snapshot.params['id2'] || 0;
        //to strored module name
        this.authService.selectedTerritoryModule = this.paramID;
        if (this.paramID == 'myterritories') {
            this.isMyclientsSelected = true;
            this.isMyClientsVisible = true;
            this.toggleTitle = "My Territories";
            this.breadCrumbUrl = "/territories/myterritories";
        }
        if (this.paramID == "My-Client") {
            this.fnSetNevigationFlag(true);
        } else if (this.paramID == "All-Client") {
            this.fnSetNevigationFlag(false);
        } else {
            this.fnSetNevigationFlag(true);
        }
        //}
        this.authService.canAllClientAccess = false;
        this.isMyClientsAccessible = false;
        this.CheckMenuVisibility();

        this.subscribeToClientList();
        this.loadUserData();
        this.authService.isMyClientsSelected = this.isMyclientsSelected
        this.visibeAllClientBtn = this.authService.canAllClientAccess;
        // console.log('inside on init, isMyClientsSelected: ', this.isMyclientsSelected);
    }

    subscribeToClientList() {
        if (this.clients.length == 0) {
            this.clientService.getClients(this.userId).subscribe(
                (data: any) => this._processClients(data),
                (err: any) => {
                    this.tViewErrModal.show();
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log('clients loaded')
            );
        }
    }


    private _processClients(data: Client[]) {
        console.log('data length: ', data.length);
        var tempClients: Client[] = [];
        for (let item in data) {
            tempClients.push({ Id: data[item].Id, Name: data[item].Name, IsMyClient: data[item].IsMyClient, MarketDefinitions: [] });
        }
        this.clients = tempClients;
        this.myClients = this.clients.filter(u => u.IsMyClient == true);
        var firstClient = this.isMyclientsSelected ? this.myClients[0] : this.clients[0];
        this.client = firstClient;
        if (firstClient) {
            this.selectedClientName = firstClient.Name//set client name of firstClient  
        }


        if (this.selectedClientID > 0) {//for selected client
            //  this.client = this.clients.filter(u => u.Id == this.selectedClientID)[0];
            this.selectedClientName = this.clients.filter(u => u.Id == this.selectedClientID)[0].Name;//set client name accouding to client ID
            this.createTerritoryLink = '/territory-create/' + this.selectedClientID + '/No Lock';
            this.getTerritories(this.selectedClientID);
            this.client = this.clients.filter(u => u.Id == this.selectedClientID)[0];//assign only selected client;

            //to check is my client or not;
            let isSelectedClientCategory = this.clients.filter(u => u.Id == this.selectedClientID)[0].IsMyClient || false;
            if (isSelectedClientCategory) {
                this.fnSetNevigationFlag(true);
            } else {
                this.fnSetNevigationFlag(false);
            }
            //end of my client checking
        } else if (this.authService.SelectedClientID > 0) {//to check selectedID of auth service
            this.selectedClientID = this.authService.SelectedClientID;
            //   this.client = this.clients.filter(u => u.Id == this.selectedClientID)[0];       
            this.createTerritoryLink = '/territory-create/' + this.selectedClientID + '/No Lock';
            let isSelectedClientCategory = this.clients.filter(u => u.Id == this.selectedClientID)[0].IsMyClient || false;
            if (ConfigService.clientFlag && isSelectedClientCategory) {
                this.getTerritories(this.selectedClientID);
                this.fnSetNevigationFlag(true);
            } else if (ConfigService.clientFlag) {
                if (firstClient) {
                    this.getTerritories(firstClient.Id);
                    this.selectedClientID = firstClient.Id;
                    this.authService.SelectedClientID = firstClient.Id;
                }
                else
                    this.clientService.fnSetLoadingAction(false);
                this.fnSetNevigationFlag(true);
            } else {
                this.getTerritories(this.selectedClientID);
                this.fnSetNevigationFlag(false);
            }
        } else {
            if (firstClient) {
                this.createTerritoryLink = '/territory-create/' + firstClient.Id + '/No Lock';
                this.getTerritories(firstClient.Id);
                this.selectedClientID = firstClient.Id;
                this.authService.SelectedClientID = firstClient.Id;
            }//to assing selected client ID into authService
            else
                this.clientService.fnSetLoadingAction(false);

        }

        //for my client / all client permission access
        this.checkMyClient(this.selectedClientID);
    }

    private fnSetNevigationFlag(isMyClient: boolean) {
        if (this.paramID == "myterritories") {
            this.isMyclientsSelected = true;
            this.isMyClientsVisible = true;
            this.breadCrumbUrl = "/territories/myterritories";
            this.toggleTitle = "My Territories";
            ConfigService.clientFlag = true;
        } else {
            if (isMyClient) {
                this.isMyclientsSelected = true;
                this.isMyClientsVisible = true;
                this.breadCrumbUrl = "/territory/My-Client";
                this.toggleTitle = "My Clients";
                ConfigService.clientFlag = true;
            } else {
                this.isMyclientsSelected = false;
                this.isMyClientsVisible = false;
                this.breadCrumbUrl = "/territoryAllClient/All-Client";
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

        this.loadUserData();
    }

    fnSelectMyClientAllClient(type: string) {
        if (type == "My-Client") {
            this.router.navigate(['territory/My-Client']);
        } else {
            this.router.navigate(['territoryAllClient/All-Client']);
        }
    }

    fnSelectClientsInTab(selectedClient: Client) {
        if (selectedClient) {
            this.client = selectedClient;
            this.selectedClientName = selectedClient.Name;//Set firstClient Name 
            this.getTerritories(selectedClient.Id);
            this.selectedClientID = selectedClient.Id;//to select client in view
            this.authService.SelectedClientID = selectedClient.Id;//to assing selected client ID into authService
            this.createTerritoryLink = '/territory-create/' + selectedClient.Id + '/No Lock';
        }

        this.clientService.fnSetLoadingAction(false);

    }

    loadTerritoryDefinition(selectedClient: Client): void {
        this.client = selectedClient;
        this.selectedClientName = selectedClient.Name;
        this.selectedClientID = selectedClient.Id;
        this.authService.SelectedClientID = selectedClient.Id;//to assing selected client ID into authService
        this.createTerritoryLink = '/territory-create/' + selectedClient.Id + '/No Lock';

        this.getTerritories(selectedClient.Id);
        this.checkMyClient(selectedClient.Id);
        //console.log(this.territoryDefinitionsFiltered);
    }

    fnModalCloseClick(action: string) {
        jQuery("#nextModal").modal("hide");
    }

    searchClient(searchKey: string, selection: boolean) {        
        var sourceList = (selection) ? this.myClients : this.clients;
        this.clientService.getClientsBySearch(searchKey, sourceList).subscribe(data => this.searchedClients = data);
    }

    refreshClientList(selection: boolean) {
        if (this.stringFilter) {
            this.stringFilter = '';
            //this.isSearch = false;
            this.searchedClients = [];
            var firstClient = (selection) ? this.myClients[0] : this.clients[0];
            if (firstClient) {
                this.selectedClientName = firstClient.Name;
                this.selectedClientID = firstClient.Id;
                this.authService.SelectedClientID = firstClient.Id;//to assing selected client ID into authService
                this.getTerritories(firstClient.Id);
            }
            this.clientService.fnSetLoadingAction(false);
        }
    }

    subscribeToClientMarketDefinition(): void {
        this.clientService.getMockMarketDefinition().subscribe(client => this.client = client);
    }

    subscribeToMockClientList(): void {
        this.clientService.getMockClients(this.isMyclientsSelected).subscribe(data => { console.log('testing click my clients ', data); this.clients = data; console.log('after success: ', this.clients); });
    }

    getTerritories(clientId: number) {
        this.selectedClientName = this.clients.filter(u => u.Id == clientId)[0].Name;//set client name according to client ID
        this.IsEditDefDependOnClientType = this.clients.filter(u => u.Id == clientId)[0].IsMyClient;
        this.loading = true;
        this.clientService.fnSetLoadingAction(true);
        this.noTerritoryDefs = false;
        jQuery('#custWrapper').css('display', 'hidden');
        this.territoryService.fnGetClientTerritories(clientId).subscribe(
            (data: any) => this._processTerritoryDefinition(data),
            (err: any) => {
                this.tViewErrModal.show();
                this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Territory Definitions loaded')
        );
    }

    private _processTerritoryDefinition(data: Territory[]) {
        //console.log('inside callback');
        this.territoryDefinitionsFiltered = [];
        this.territoryDefinitionsFiltered = data;
        console.log(this.territoryDefinitionsFiltered);
        this.loading = false;
        this.clientService.fnSetLoadingAction(false);
        if (data.length === 0) this.noTerritoryDefs = true;
        //console.log('mkt defs: ', data.MarketDefinitions, ' noTerritoryDefs: ', this.noTerritoryDefs);
        jQuery('#custWrapper').css('display', 'block');
        //console.log('inside final callback');
    }

    async fnDeleteTerritoryDefinition(territoryDef: Territory, event: Event) {
        //clientID: number, territoryDefinitionID: number, territoryDefinitinName: string,
        this.clientService.fnSetLoadingAction(true);
        this.deliverableList = [];
        let deliverableName: string = "";
        this.deletedTerritoryDefinitionID = territoryDef.Id;
        this.deletedClientID = territoryDef.Client_Id;
        let currentlyUsingUserList = [];
        //to check its lock or not
        await this.clientService.getDefinitionLockHistories(this.loginUserObj.UserID, this.deletedTerritoryDefinitionID, "Territory Module", "All Lock", "Check for Delete")
            .then(result => { console.log(result); currentlyUsingUserList = result || []; this.clientService.fnSetLoadingAction(false); })
            .catch((err: any) => { this.clientService.fnSetLoadingAction(false); this.tViewErrModal.show(); });

        if (currentlyUsingUserList.length > 0) {// locked by other user
            this.modalSaveBtnVisibility = false;
            this.modalSaveFnParameter = "";
            this.modalTitle = '<span >The definition is currently being viewed by another user, hence cannot be deleted. Please try later.</span>';
            this.modalCloseBtnCaption = "Ok";
            jQuery("#nextModal").modal("show");
            return false;
        }

        await this.fnGetTerritoryDefSubscribledList(territoryDef.Client_Id, territoryDef.Id);
        this.clientService.fnSetLoadingAction(false);
        if (this.deliverableList.length > 0) {
            deliverableName = '<ul>';
            this.deliverableList.forEach((rec: any) => {
                deliverableName = deliverableName + '<li>' + rec + '</li>';
            });
            deliverableName = deliverableName + '</ul>';

            if (this.canDeleteTerrDef) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "Delete Territory Definition";
                this.modalTitle = '<span >Deleting <b>' + territoryDef.Name + '</b> will remove this from following deliverables: <br/><div class="error-list">' + deliverableName + '</div> Are you sure you would like to delete?</span>';
                this.modalBtnCapton = "Yes";
                this.modalCloseBtnCaption = "Cancel";
                jQuery("#nextModal").modal("show");
                //event.stopPropagation();
                return false;
            }
            else {
                console.log('delete false');
                event.stopPropagation();
                return false;
            }
        } else {
            if (this.canDeleteTerrDef) {
                this.modalSaveBtnVisibility = true;
                this.modalSaveFnParameter = "Delete Territory Definition";
                this.modalTitle = '<span >Do you want to delete territory definition <b>' + territoryDef.Name + '</b>?</span>';
                this.modalBtnCapton = "Yes";
                this.modalCloseBtnCaption = "Cancel";
                jQuery("#nextModal").modal("show");
                //event.stopPropagation();
                return false;
            }
            else {
                console.log('delete false');
                event.stopPropagation();
                return false;
            }
        }

    }
    async fnGetTerritoryDefSubscribledList(clientId: number, territoryDefId: number) {
        await this.territoryService.checkSubcribedTerritoryDef(clientId, territoryDefId)
            .then(
            (data: any) => { this.deliverableList = data || []; console.log(data) })
            .catch((err: any) => {
                this.clientService.fnSetLoadingAction(false);
                //this.tViewErrModal.show();//off to show mgs
                console.log(err);
            });
    }

    public fnModalConformationClick(action: string): void {
        if (action == "Delete Territory Definition") {
            this.territoryService.fnSetLoadingAction(true);
            let ClientID = this.deletedClientID;
            let TerritoryDefId = this.deletedTerritoryDefinitionID;
            //write here code for deleted.
            //    this.territoryService.deleteTerritory(clientID, territoryDefinitionID);
            this.territoryService.deleteTerritory(ClientID, TerritoryDefId).subscribe(
                data => {                   
                        console.log("territory definition:" + JSON.stringify(this.territoryDefinitionsFiltered));
                        var selectedTerritoryInfo = this.territoryDefinitionsFiltered.filter((x: any) => x.Id == TerritoryDefId && x.Client_Id == ClientID)[0];
                        this.territoryDefinitionsFiltered.splice(this.territoryDefinitionsFiltered.indexOf(selectedTerritoryInfo), 1);
                        this.deletedClientID = 0;
                        this.deletedTerritoryDefinitionID = 0;
                        this.territoryService.fnSetLoadingAction(false);
                },
                (err: any) => {
                    //this.tViewErrModal.show();//off to show mgs
                    this.territoryService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log("deleted teritory list: ")
            );

        }
        jQuery("#nextModal").modal("hide");
    }

    private subscribeToDeleteClientMarketDef(ClientId: number, MarketDefId: number) {
        //edit market definition
        //console.log('inside process client: ');
        //this.territoryDefinitionsFiltered[0].MarketDefinitions[0].MarketDefinitionPacks = this.dynamicPackMarketBase;
        this.clientService.deleteClientMarketDef(ClientId, MarketDefId).subscribe(
            //data => this._processClient(data),
            (err: any) => {
                this.tViewErrModal.show();
                console.log(err);
            },
            () => console.log("deleted client list: ")
        );

        // this.route.navigate["/market"];
        //this.router.navigate(['About']); // here "About" is name not path
    }
    private loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;

            if (this.temporaryUserPermission.myClientPermission.length > 0 && this.isMyclientsSelected) {
                this.checkAccess(this.temporaryUserPermission.myClientPermission)
            } else if (this.temporaryUserPermission.allClientPermission.length > 0 && !this.isMyclientsSelected) {
                this.checkAccess(this.temporaryUserPermission.allClientPermission)
            } else {
                this.authService.getInitialRoleAccess('Territory', (this.isMyclientsSelected ? 'My Clients' : 'All Clients'), roleid).subscribe(
                    (data: any) => {
                        this.isMyclientsSelected ? this.temporaryUserPermission.myClientPermission = data : this.temporaryUserPermission.allClientPermission = data;
                        this.checkAccess(data);
                    },
                    (err: any) => {
                        this.tViewErrModal.show();
                        this.clientService.fnSetLoadingAction(false);
                        console.log(err);
                    },
                    () => console.log('data loaded')
                );
            }

        }
    }

    private checkAccess(data: UserPermission[]) {
        console.log('this.isMyclientsSelected: ', this.isMyclientsSelected);
        this.canCreateTerrDef = false;
        // this.canViewContent = true;
        this.canEditTerrDef = false;
        this.canDeleteTerrDef = false;
        var isAdmin: boolean = false;
        for (let it in data) {
            if (data[it].Role == 'Internal Admin' || data[it].Role == 'Internal Production' || data[it].Role == 'Internal Support') {
                // this.isMyclientsSelected = true;
                isAdmin = true;
                this.authService.canAllClientAccess = true;
            }
            else if (data[it].Role == 'Internal Data Reference') {
                isAdmin = true;
            }
        }
        // if (this.isMyclientsSelected == true || this.authService.canAllClientAccess  == true) {
        // if (this.isMyclientsSelected == true || isAdmin == true) {
        for (let it in data) {
            console.log('item=' + data[it].ActionName + "-" + data[it].Privilage);
            if (data[it].ActionName == ConfigUserAction.TerritoryDefinition && data[it].Privilage == 'Add') {
                this.canCreateTerrDef = true;
            }
            if (data[it].ActionName == ConfigUserAction.TerritoryDefinition && data[it].Privilage == 'View') {
                console.log('this.canViewContent' + this.canViewContent);
                this.canViewContent = true;
            }
            if (data[it].ActionName == ConfigUserAction.TerritoryDefinition && data[it].Privilage == 'Add') {
                console.log('this.canEditTerrDef' + this.canEditTerrDef);
                this.canEditTerrDef = true;
            }
            if (data[it].ActionName == ConfigUserAction.TerritoryDefinition && data[it].Privilage == 'Delete') {
                // console.log('this.canDeleteTerrDef' + this.canDeleteTerrDef);
                this.canDeleteTerrDef = true;
            }
            //console.log('this.canCreateTerrDef' + this.canCreateTerrDef);
        }
        // }
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
        if (this.canEditTerrDef) {
            var url = '/marketCreate/' + cid + '|' + mid;
            this.router.navigateByUrl(url);
        }
        else {
            console.log('this.canEditTerrDef' + this.canEditTerrDef);
            event.stopPropagation();
        }
    }

    async fnEditTerritoryDef(territoryDef: Territory) {
        this.clientService.fnSetLoadingAction(true);
        let currentlyEditingUserList: any[] = [];

        //to get previous lock history
        await this.clientService.getDefinitionLockHistories(this.loginUserObj.UserID, territoryDef.Id, "Territory Module", "Edit Lock", "Check Status")
            .then(result => { console.log(result); currentlyEditingUserList = result || []; this.clientService.fnSetLoadingAction(false); })
            .catch((err: any) => { this.clientService.fnSetLoadingAction(false); this.tViewErrModal.show(); });

        if (this.canEditTerrDef && currentlyEditingUserList.length == 0) {//route other page           
            var url = '/territory-create/' + territoryDef.Client_Id + '|' + territoryDef.Id + '/Edit Lock';
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
            console.log('this.canEditTerritory Def' + this.canEditTerrDef);
            event.stopPropagation();
        }
    }

    disableDiv(cid: number, tid: number, event: Event) {
        // console.log('this.canEditTerrDef' + this.canEditTerrDef + cid + '|' + mid);
        var url = '/territory-create/' + cid + '|' + tid + '/View Lock';
        this.router.navigateByUrl(url);
    }
    private CheckMenuVisibility() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var url = this.router.url;
        if (usrObj) {
            this.authService.CheckPermission('Territory', '', 'Use global navigation toolbar')
                .subscribe(
                (data: any) => this.checkPermission(data),
                (err: any) => {
                    //this.tViewErrModal.show();
                    console.log(err);
                },
                () => console.log('data loaded')
                );
        }
    }
    private checkPermission(data: UserPermission[]) {
        // this.authService.canAllClientAccess = false;
        // this.authService.canMyClientAccess = false;
        this.visibeAllClientBtn = false;
        this.isMyClientsAccessible = false;
        if (data && data.length > 0) {
            for (let it in data) {
                //if (typeof data[it] !== 'undefined') {
                if (data[it].ModuleName == 'All Clients') {
                    console.log("check view access -true")
                    this.authService.canAllClientAccess = true;
                    this.visibeAllClientBtn = true;
                    //this.isAllClientsAccessible = true;

                }
                if (data[it].ModuleName == 'My Clients') {
                    console.log("check view access -true")
                    this.authService.canMyClientAccess = true;
                    this.isMyClientsAccessible = true;
                }
                //}
            }
        }
    }


    private SubmitTerritoryButton() {

        this.loading = true;
        this.clientService.fnSetLoadingAction(true);
        this.noTerritoryDefs = false;
        jQuery('#SuccessMessage').css('display', 'none'); 
        jQuery('#custWrapper').css('display', 'hidden');
        this.territoryService.fnGetTerritoriesByClient(this.selectedClientID).subscribe(
            (data: any) => this._processTerritoryDTODefinition(data),
            (err: any) => {
                this.tViewErrModal.show();
                this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('Territory Definitions loaded')
        );
       
        this.TerritoryModal.show();
    }

    private _processTerritoryDTODefinition(data: TerritoryDTO[]) {
        //console.log('inside callback');
        this.territoryfDTO = [];
        this.territoryfDTO = data;
        //console.log(this.territoryfDTO);
        this.setSelectedValues();
        this.loading = false;
        this.clientService.fnSetLoadingAction(false);
        //console.log('mkt defs: ', data.MarketDefinitions, ' noTerritoryDefs: ', this.noTerritoryDefs);
      //  this.SuccessMessage.show();

        jQuery('#custWrapper').css('display', 'block');
      //  this.alertService.alert("Territory Definition version has saved successfully.");
        //console.log('inside final callback');
    }

    private setSelectedValues() {
        let selected = false;
        for (let dto of this.territoryfDTO) {
            dto.Selected = selected;
        }        
    }

    private CancelSubmitTerritoryPopup() {

        this.TerritoryModal.hide();
    }

    private SubmitTerritory(): void {
        this.clientService.fnSetLoadingAction(true);
        let territoryIds: number[] = [];
        territoryIds = this.getselectedValuesforSubmit();
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }
        
        this.territoryService.submitTerritory(territoryIds, userid)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe((data: any) => {    
                
                this.SubmitTerritoryButton();
                jQuery('#SuccessMessage').css('display', 'block');        
        },
            (err: any) => {
                console.log(err);
            }
        );
    }

    getselectedValuesforSubmit() {
        var selectedIds = [];      
        selectedIds = this.territoryfDTO.filter(x => x.Selected).map(function (sv) {
            return sv.Id;
        });
        return selectedIds;
    }
}
