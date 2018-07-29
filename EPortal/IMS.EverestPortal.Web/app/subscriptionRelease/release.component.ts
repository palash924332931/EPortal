import { Component, OnInit, HostListener } from '@angular/core';
import { ReleaseService } from './release.service';
import { ClientService } from '../shared/services/client.service';
import { ModalDirective, PaginationComponent } from 'ng2-bootstrap';
import { UiSwitchModule } from 'angular2-ui-switch';
import { TabsetComponent } from 'ng2-bootstrap';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import { Subject } from 'rxjs/Subject';
import { Observable } from 'rxjs/Observable';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';
import { ComponentCanDeactivate } from '../security/deactivate-guard';

declare var jQuery: any;

@Component({
    selector: 'Release',
    templateUrl: '../../app/subscriptionRelease/release.component.html',
    providers: [ReleaseService, ClientService],
    styleUrls: ['../../app/subscriptionRelease/release.component.css']
})
export class ReleaseComponent implements ComponentCanDeactivate{

    private searchMfrTerms = new Subject<string>();
    private searchPackExceptionTerms = new Subject<string>();

    public client: any;
    public clientReleases: any[] = [];
    public filteredReleases: any[] = [];
    public mfrs: any[] = [];
    public packExceptions: any[] = [];
    public txtSearchRelease: string = "";
    public enable: boolean = false;
    public txtSearchMfr: string = "";
    public txtSearchPack: string = "";
    public selectMfrCurrentPage: boolean = false;
    public selectAllMfrSearchItems: boolean = false;

    public selectPackCurrentPage: boolean = false;
    public selectAllPackSearchItems: boolean = false;
    @HostListener('window:beforeunload')
    canDeactivate(): Observable<boolean> | boolean {
        if (this.isReleaseValueChanged == true) {
            if (this.authService.isTimeout == true)
                return true;
            else
                return false;
        }
        else {
            return true;
        }
    }
    constructor(private releaseService: ReleaseService, private clientService: ClientService,
        private _cookieService: CookieService, private authService: AuthService ) {

    };
   
    ngOnInit(): void {
        this.loadUserData();
    }

    

    updateExpiryDate(evt: any, pack: any): void {
        
        pack.ExpiryDate = evt;
        var req = {
            packs: [pack],
            Client: this.selectedClient
        };
        this.releaseService.updatePackExpiryDate(req)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            r => this.getPackExceptionsByClient(this.selectedClient),
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false))
            )
               
       
    }
    
    //MFR Start
    searchMfr():void {
        //this.searchMfrTerms.next(value);
        this.mfrs = [];
        //this.setMfrPagination([])
        if (this.txtSearchMfr) {
            this.releaseService.GetMFR({ Description: this.txtSearchMfr, Pagination: { NoOfItems: this.mfrItemsPerPage, CurrentPage: this.mfrCurrentPage } })
                .finally(() => (this.clientService.fnSetLoadingAction(false)))
                .subscribe(
                r => (this.loadMfrs(r.data), this.setMfrPagination(r)),
                e => console.log(e),
                () => (this.clientService.fnSetLoadingAction(false))
                )
        } else {
            this.mfrTotalItems = 0;
        }
    }


    loadMfrs(searchResults: any[]): void {
        this.selectMfrCurrentPage = false;
        this.mfrs = this.SetMfrSelectedValue(searchResults);
        if (this.selectAllMfrSearchItems) {
            this.selectMfrAllItems(this.selectAllMfrSearchItems);
        }
    }

    SetMfrSelectedValue(data: any[]): any[] {
        for (let d of data) {
            d.selected = false;
        }
        return data;
    }

    //Pagination Mfr
    setMfrPagination(res: any): void {
        this.mfrTotalItems = res.resultCount;
    }

    public mfrTotalItems: number = 0;    
    public mfrCurrentPage: number = 1
    public mfrItemsPerPage : number = 15
    public mfrPageChanged(event: any): void {
        this.mfrCurrentPage = event.page;
        this.searchMfr();
    }
    //Pagination End

    selectMfrCurrentPageItems(value: boolean): void {
        if (!value) {
            this.selectAllMfrSearchItems = false;
        }
        
        for (let m of this.mfrs) {
            m.selected = value;
        }
        this.selectedClients = this.getSelectedClients();
        this.selectedMfrs = this.getSelectedValues(this.mfrs, 'Org_Code');        
    }

    selectMfrAllItems(value: boolean): void {       
       
        this.selectMfrCurrentPage = value;        
        for (let m of this.mfrs) {
            m.selected = value;
        }
        this.selectedClients = this.getSelectedClients();
        this.selectedMfrs = this.getSelectedValues(this.mfrs, 'Org_Code'); 
    }

    //MfR End

    //PAcks Start
    searchPacks(): void {       
        this.packExceptions = [];        
        if (this.txtSearchPack) {
            this.releaseService.GetPackException({ Description: this.txtSearchPack, Pagination: { NoOfItems: this.packsItemsPerPage, CurrentPage: this.packsCurrentPage } })
                .finally(() => (this.clientService.fnSetLoadingAction(false)))
                .subscribe(
                r => (this.loadPack(r.data), this.setPackPagination(r), this.setPackProductLevelSelection(this.client)),
                e => console.log(e),
                () => (this.clientService.fnSetLoadingAction(false))
                )
        } else {
            this.packsTotalItems = 0;
        }
    }


    loadPack(searchResults: any[]): void{
        this.selectPackCurrentPage = false;
        this.packExceptions = this.SetMfrSelectedValue(searchResults);
        if (this.selectAllPackSearchItems) {
            this.selectPackAllItems(this.selectAllPackSearchItems);
        }        
    }
    //Pagination starts
    public packsTotalItems: number = 0;
    public packsCurrentPage: number = 1
    public packsItemsPerPage: number = 15
    public packsPageChanged(event: any): void {
        this.packsCurrentPage = event.page;
        this.searchPacks();
    }

    SetPackSelectedValue(data: any[]): any[] {
        for (let d of data) {
            d.selected = false;
            d.ProductLevel = false;
        }
        return data;
    }

    setPackPagination(res: any): void {
        this.packsTotalItems = res.resultCount;
    }
    //Pagination ends

    selectPackCurrentPageItems(value: boolean): void {
        if (!value) {
            this.selectAllPackSearchItems = false;
        }
        for (let m of this.packExceptions) {
            m.selected = value;
        }
        this.selectedClients = this.getSelectedClients();
        this.selectedPacks = this.getSelectedPacks(); 
    }

    selectPackAllItems(value: boolean): void {
        this.selectPackCurrentPage = value;
        for (let m of this.packExceptions) {
            m.selected = value;
        }
        this.selectedClients = this.getSelectedClients();
        this.selectedPacks = this.getSelectedPacks(); 
    }

    //Packs End
     
    public userID: string = "";
    loadReleases() {        
        this.clientService.fnSetLoadingAction(true);
        this.releaseService.GetClientReleaseDetails(this.userID, this.isAllClientsAccessible)
            .finally(() => (this.clientService.fnSetLoadingAction(false)))
            .subscribe(
            p => (this.setReleaseSummary(p)),
            e => (console.log(e)),
            () => (this.clientService.fnSetLoadingAction(false))
            );
    }

    public initialClientReleases: string = "";
    setReleaseSummary(p: any): void {
        this.initialClientReleases = JSON.stringify(this.SetSelectedValue(p.data));
        this.clientReleases = this.SetSelectedValue(p.data);
        this.filteredReleases = this.SetSelectedValue(p.data);
        this.setReleasesPagination();
        this.clientService.fnSetLoadingAction(false);
        if (this.client) {           
                this.client = this.filteredReleases.filter(x => x.clientId == this.client.clientId)[0];
        }
        this.isReleaseValueChanged = false;
    }
    
    

    SetSelectedValue(data: any[]): any[] {
        for (let d of data) {
            d.selected = false;
        }
        return data
    }

    public releasesItemsPerPage : number = 15
    public releasesTotalItems: number = this.filteredReleases.length;
    public releasesCurrentPage: number = 1;
    public releasesByPage: any[]=[];

    searchReleases(): void {
        this.filteredReleases = this.clientReleases.filter(x => x.clientName.toLowerCase()
            .indexOf(this.txtSearchRelease.toLowerCase()) >= 0);
        this.setReleasesPagination();
    }


    public releasesPageChanged(event: any): void {
        this.releasesCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.releasesItemsPerPage;
        var endIndex = startIndex + this.releasesItemsPerPage;
        this.releasesByPage = this.filteredReleases.slice(startIndex, endIndex)
    }

    setReleasesPagination(): void {
        this.releasesTotalItems = this.filteredReleases.length;
        this.releasesPageChanged({ page: this.releasesCurrentPage, itemsPerPage: this.releasesItemsPerPage });
    }


    getSelectedValues(data: any[], key: string): any[] {
        var selectedValues = data.filter(d => d.selected).map(function (x) {
            return x[key];
        });
        return selectedValues;
    }

    getSelectedClients(): any[] {
        this.selectedClients = [];
        if (this.client) {
            this.selectedClients.push(this.client);
        }
        return this.selectedClients; 
    }

    getSelectedPacks(): any[] {
        return this.packExceptions.filter(d => d.selected);
    }

    public selectedClients: any[] = [];
    public selectedPacks: any[] = [];
    public selectedMfrs: any[] = [];
    
    Allocate() {
        this.selectedClients = this.getSelectedClients();
        this.selectedMfrs = [];
        this.selectedPacks = [];        

        if (!this.selectAllMfrSearchItems) {
            this.selectedMfrs = this.getSelectedValues(this.mfrs, 'Org_Code');
        }

        if (!this.selectAllPackSearchItems) {
            this.selectedPacks = this.getSelectedPacks();
        }

        if (this.selectAllMfrSearchItems) {
            this.releaseService.AllocateAllMfrSearchItems({ Clients: this.selectedClients, Description: this.txtSearchMfr })
                .finally(() => (this.clientService.fnSetLoadingAction(false)))           
                .subscribe(
                p => (this.loadReleases(), this.showSummaryDetails()),
                e => (console.log(e)),
                () => (this.clientService.fnSetLoadingAction(false), this.clearSelection())
                );

        }

        if (this.selectAllPackSearchItems) {
            this.releaseService.AllocateAllPackSearchItems({ Clients: this.selectedClients, Description: this.txtSearchPack })
                .finally(() => (this.clientService.fnSetLoadingAction(false)))
                .subscribe(
                p => (this.loadReleases(), this.showSummaryDetails()),
                e => (console.log(e)),
                () => (this.clientService.fnSetLoadingAction(false), this.clearSelection())
                );

        }

        var req = {
            Mfrs: this.selectedMfrs,
            Packs: this.selectedPacks,
            Clients : this.selectedClients
        };
        
       this.clientService.fnSetLoadingAction(true);//to set loading true
       this.releaseService.Allocate(req)
           .finally(() => (this.clientService.fnSetLoadingAction(false)))
            .subscribe(
            p => (this.loadReleases(), this.showSummaryDetails()),
            e => (console.log(e)),
            () => (this.clientService.fnSetLoadingAction(false), this.clearSelection())
            );
    }

    saveReleaseDetails() {
        var req = {
            Clients: this.clientReleases
        };
        this.clientService.fnSetLoadingAction(true);//to set loading true
        this.releaseService.saveReleases(req)
            .finally(() => (this.clientService.fnSetLoadingAction(false)))
            .subscribe(
            p => (this.loadReleases()),
            e => (console.log(e)),
            () => (this.clientService.fnSetLoadingAction(false), this.isReleaseValueChanged= false)
            );
    }

    clearReleasesChanges(): void {
        this.setReleaseSummary({ data: JSON.parse(this.initialClientReleases) });
    }

    showSummaryDetails(): void {
        
        this.selectedMfrs = this.getSelectedValues(this.mfrs, 'Org_Code');
        if (this.selectedMfrs.length > 0)
            this.getMfrsByClient(this.selectedClients[0]);

        this.selectedPacks = this.getSelectedPacks();
        if (this.selectedPacks.length > 0 && !(this.selectedMfrs.length > 0))
            this.getPackExceptionsByClient(this.selectedClients[0]);
    }
    clearSelection(): void {
        for (let mfr of this.mfrs) {
            mfr.selected = false;
        }
        this.selectMfrCurrentPage = false;
        this.selectAllPackSearchItems = false;

        for (let pack of this.packExceptions) {
            pack.selected = false;
        }
        this.selectPackCurrentPage = false;
        this.selectAllMfrSearchItems = false;

        
        this.selectedPacks = [];
        this.selectedMfrs = [];
    }


    updateSelection(selectedClient : any): void {
        this.showDetails = false;
        this.selectedClients = this.getSelectedClients();
        this.selectedPacks = this.getSelectedPacks();
        this.selectedMfrs = this.getSelectedValues(this.mfrs, 'Org_Code');

        //Update product level toggle selections
        this.setPackProductLevelSelection(selectedClient);


    }
       

    public isReleaseValueChanged: boolean = false;

    setCapitalChemist(cap: any,client:any) {
        client.CapitalChemist = !cap;
        this.isReleaseValueChanged = this.initialClientReleases != JSON.stringify(this.clientReleases);
        this.authService.hasUnSavedChanges = this.isReleaseValueChanged;
    }

    setCensus(Census: any, client: any) {
        client.Census = !Census;
        this.isReleaseValueChanged = this.initialClientReleases != JSON.stringify(this.clientReleases);
        this.authService.hasUnSavedChanges = this.isReleaseValueChanged;
    }

    setOneKey(OneKey: any, client: any) {
        client.OneKey = !OneKey;
        this.isReleaseValueChanged = this.initialClientReleases != JSON.stringify(this.clientReleases);
        this.authService.hasUnSavedChanges = this.isReleaseValueChanged;
    }

    updateSelectionMfr(evt: any): void {
        if (!evt) {
            this.selectAllMfrSearchItems = false;
            this.selectMfrCurrentPage = false;
        }
        this.selectedClients = this.getSelectedClients();        
        this.selectedMfrs = this.getSelectedValues(this.mfrs, 'Org_Code');
    }



    updateSelectionPackException(evt: any): void {
        if (!evt) {
            this.selectAllPackSearchItems = false;
            this.selectPackCurrentPage = false;
        }
        this.selectedClients = this.getSelectedClients();
        this.selectedPacks = this.getSelectedPacks();        
    }


    //Get Clients details and allocated users
    getMfrsByClient(client: any): void {
        jQuery('.nav-tabs a[href="#subs"]').tab('show');
        this.selectAllMfrDetail = false;

        this.selectedClient = client;       
        this.releaseService.GetMfrsbyClient(client.clientId)
            .finally(() => (this.clientService.fnSetLoadingAction(false)))
                .subscribe(
                r => (this.setClientMfrsDetails(r.data),
                    this.client = this.filteredReleases.filter(x => x.clientId == client.clientId)[0]
                    , this.isMfrDeleteDisabled = true),
                e => console.log(e),
                () => (this.clientService.fnSetLoadingAction(false))
                )
    }

    public clientMfrs: any[] = [];
    public clientMfrsByPage: any[] = [];
    public showMfrDetails: boolean = false;
    public showDetails: boolean = false;
    public selectedClientMfr: any[] = [];
    public isMfrDeleteDisabled: boolean = true;
    public selectedClient: any;

    public clientMfrTotalCount: number = 0;
    public clientMfrCurrentPage: number = 1;
    public clientMfrItemsPerPage: number = 12;

    public clientMfrPageChanged(event: any): void {
        this.clientMfrCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.clientMfrItemsPerPage;
        var endIndex = startIndex + this.clientMfrItemsPerPage;
        this.clientMfrsByPage = this.clientMfrs.slice(startIndex, endIndex)
    }

    setClientMfrsPagination(): void {
        this.clientMfrTotalCount = this.clientMfrs.length;
        this.clientMfrPageChanged({ page: this.clientMfrCurrentPage, itemsPerPage: this.clientMfrItemsPerPage });
    }

    

    setClientMfrsDetails(data: any[]): void {
        this.clientMfrs = this.SetSelectedValue(data);
        this.showMfrDetails = true;
        this.showDetails = true;
        this.setClientMfrsPagination();
    }

    updateClientMfrSelection(evt: any): void {
        if (!evt) this.selectAllMfrDetail = false;
        this.isMfrDeleteDisabled = !(this.getSelectedValues(this.clientMfrs, 'Org_Code').length > 0)
    }

    RemoveMfrsFromClient(sClient: any) {
        this.clientService.fnSetLoadingAction(true)
        var clients = [sClient];
        var Mfrs = this.getSelectedValues(this.clientMfrs, 'Org_Code');
        var req = {
            Mfrs: Mfrs,
            Clients: clients
        };
        this.clientService.fnSetLoadingAction(true)
        this.releaseService.deleteMfr(req)
            .finally(() => (this.clientService.fnSetLoadingAction(false)))
            .subscribe(p => (this.loadReleases(), this.getMfrsByClient(sClient)), e => console.log(e),
            () => ( this.clientService.fnSetLoadingAction(false))
            );
    }

    public clientPackExceptions: any[] = [];
    public clientPackExceptionsByPage: any[] = [];
    public selectedClientPack: any[] = [];
    public isPackDeleteDisabled: boolean = true;

    public clientPackExceptionsTotalCount: number = 0;
    public clientPackCurrentPage: number = 1;
    public clientPacksItemsPerPage: number = 12;

    public clientPacksPageChanged(event: any): void {
        this.clientPackCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.clientPacksItemsPerPage;
        var endIndex = startIndex + this.clientPacksItemsPerPage;
        this.clientPackExceptionsByPage = this.clientPackExceptions.slice(startIndex, endIndex)
    }

    setClientPacksPagination(): void {
        this.clientPackExceptionsTotalCount = this.clientPackExceptions.length;
        this.clientPacksPageChanged({ page: this.clientPackCurrentPage, itemsPerPage: this.clientPacksItemsPerPage });
    }

    //Get pack exceptions with clients
    getPackExceptionsByClient(client: any): void {

        this.selectedClient = client;
        this.selectAllPackExceptionDetails = false;
        jQuery('.nav-tabs a[href="#deli"]').tab('show');       
        this.releaseService.GetPacksbyClient(client.clientId)
            .finally(() => (this.clientService.fnSetLoadingAction(false)))
                .subscribe(
                r => (this.setClientPackDetails(r.data),
                    this.client = this.filteredReleases.filter(x => x.clientId == client.clientId)[0],
                    this.isPackDeleteDisabled = true),
                e => console.log(e),
                () => (this.clientService.fnSetLoadingAction(false))
                )
        
    }

    setClientPackDetails(data: any[]): void {
        this.clientPackExceptions = this.SetSelectedValue(data);
        this.showMfrDetails = false;
        this.showDetails = true;
        this.setClientPacksPagination();
    }

    updateClientPackSelection(evt: any): void {
        if(!evt)
        this.selectAllPackExceptionDetails = false;
        this.isPackDeleteDisabled = !(this.getSelectedValues(this.clientPackExceptions, 'Id').length > 0)
    }

    RemovePackFromClient(sClient: any) {
        this.clientService.fnSetLoadingAction(true)
        var clients = [sClient];
        var Packs = this.clientPackExceptions.filter(x => x.selected);

        var getPackByProductLevel = Packs.filter(p => p.ProductLevel);

        var productsToBeDeleted : any[] = [];

        for (let p of getPackByProductLevel) {
            let temp = this.clientPackExceptions.filter(c => c.ProductGroupName == p.ProductGroupName);
            if (temp && temp.length > 0) {
                for (let pd of temp)
                    productsToBeDeleted.push(pd);
            }
        }

        let singlePacks = Packs.filter(x => !x.ProductLevel);
        if (singlePacks && singlePacks.length > 0) {
            for (let sp of singlePacks)
            productsToBeDeleted.push(sp);
        }
         

        var req = {
            Packs: productsToBeDeleted,
            Clients: clients
        };
        this.clientService.fnSetLoadingAction(true);
        this.releaseService.deletePacks(req)
            .finally(() => (this.clientService.fnSetLoadingAction(false)))
            .subscribe(p => (this.loadReleases(), this.getPackExceptionsByClient(sClient)), e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false))
            );
    }


    public isOneKeyAccessible: boolean = false;
    public isCensusAccessible: boolean = false;
    public isPackExceptionAccessible: boolean = false;
    public isAllClientsAccessible: boolean = false;


    private loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        this.userID = usrObj.UserID;
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('Subscription', 'Release', roleid).subscribe(
                (data: any) => (this.checkAccess(data),this.loadReleases()),
                (err: any) => {
                    console.log(err);
                }
            );
        }
    }

    private checkAccess(data: UserPermission[]) {
        console.log(data);
        for (let p of data)
        {
            if (p.ActionName == ConfigUserAction.ReleaseOneKey) {                
                this.isOneKeyAccessible = true;
            }

            if (p.ActionName == ConfigUserAction.ReleaseCensus) {
                this.isCensusAccessible = true;
            }

            if (p.ActionName == ConfigUserAction.ReleasePackExeception) {
                this.isPackExceptionAccessible = true;
            }

            if (p.ActionName == ConfigUserAction.ReleaseAllClients) {
                this.isAllClientsAccessible = true;
            }
            
        }
        
    }

    setPackProductLevelSelection(client: any) {
        if (client) {
            this.releaseService.GetPacksbyClient(client.clientId)
                .finally(() => (this.clientService.fnSetLoadingAction(false)))
                .subscribe(
                r => (this.setToggleSelection(r.data)),
                e => console.log(e),
                () => (this.clientService.fnSetLoadingAction(false))
                )
        }
    }

    setToggleSelection(clientPacks:any[]) {
        for (var pe of this.packExceptions) {
            pe.ProductLevel = false;
            if (clientPacks.filter(x => x.Id == pe.Id).length > 0) {
                pe.ProductLevel = clientPacks.filter(x => x.Id == pe.Id)[0].ProductLevel;
            }
        }
    }

    //select all mfr details
    selectAllMfrDetail: boolean = false;
    selectAllMfrDetailChange(value: boolean): void {

        for (let cm of this.clientMfrs) {
            cm.selected = value;
        }

        this.updateClientMfrSelection(value);
    }

    selectAllPackExceptionDetails: boolean = false;
    selectAllPackExceptionDetailsChange(value: boolean): void {
        for (let pe of this.clientPackExceptions) {
            pe.selected = value
        }
        this.updateClientPackSelection(value);
    }
   
}