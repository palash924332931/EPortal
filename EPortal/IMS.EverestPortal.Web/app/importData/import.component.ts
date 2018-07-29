import { Component } from '@angular/core';
import { ClientService } from '../shared/services/client.service';
import { ImportService } from './import.service';
import { Observable } from 'rxjs/Observable';
import { CookieService } from 'angular2-cookie/services/cookies.service';

//datepicker
//import { IMyDpOptions } from 'mydatepicker';

@Component({
    selector: 'import',
    templateUrl: '../../app/importData/import.html',
    providers: [ImportService, ClientService],
    styleUrls: ['../../app/subscription/subscription.component.css', '../../app/deliverables/deliverables.css',
        '../../app/importData/import.component.css']
})

export class ImportComponent {

    //public myDatePickerOptions: IMyDpOptions = {
    //    // other options...
    //    dateFormat: 'dd.mm.yyyy',
    //};

    // Initialized to specific date (09.10.2018).
    //public model: any = { date: { year: 2018, month: 10, day: 9 } };


    public clients: any[] = [];
    public IRPClients: any[] = [];
    public client: any = {};
    public IRPClient: any = {};
    public deliClient: any = {};
    public marketClient: any = {};
    public territoryClient: any = {};

    //for multiselect options
    public clientOptions: any[] = [];
    public clientIRPOptions: any[] = [];

    //Messages
    public message: string = "";
    public showMessage: boolean = false;
    public isSuccessMessage = false;

    public deliMessage: string = "";
    public showDeliMessage: boolean = false;
    public isSuccessDeli: boolean = false;

    public values = [];
    public selectedClients: any[] = [];
    public emailId: string = "";

  


    public marketMessage: string = "";
    public showMarketMessage: boolean = false;
    public isSuccessMarket: boolean = false;

    public territoryMessage: string = "";
    public showTerritoryMessage: boolean = false;
    public isSuccessTerritory: boolean = false;


    constructor(private clientService: ClientService, private importService: ImportService, private _cookieService: CookieService) {

    }

    ngOnInit(): void {
        this.loadClients(); this.loadIRPClients(); this.loadAllClients();
        var cUser: any = this._cookieService.getObject("CurrentUser");       
        if (cUser) {
            this.emailId = cUser.EmailId;
        }                   
    }

    loadIRPClients() {
        this.clientService.fnSetLoadingAction(true);
        this.importService.GetIRPClients()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.IRPClients = p.data, this.setClientMultiselectOptionsIRPClients(p.data)),
            e => console.log(e)
            );
    }

    loadClients() {
        this.clientService.fnSetLoadingAction(true);
        this.importService.GetClients()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.setClientMultiselectOptionsClients(p.data)),
            e => console.log(e)
            );
    }

    loadAllClients() {
        this.clientService.fnSetLoadingAction(true);
        this.importService.GetAllClients()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clients = p.data),
            e => console.log(e)
            );
    }

    setClientMultiselectOptionsClients(data: any[]) {
        let options = [];
        if (data && data.length > 0) {
            for (var c of data) {
                let obj = { Text: c.Name, Value: c };
                options.push(obj);
            }
        }
        this.clientOptions = options;
    };

    setClientMultiselectOptionsIRPClients(data: any[]) {
        let options = [];
        if (data && data.length > 0) {
            for (var c of data) {
                let obj = { Text: c.ClientName, Value: c };
                options.push(obj);
            }
        }
        this.clientIRPOptions = options;
    };

    importClients() {
        console.log(this.client);
    }

    public selectedIRPClients: any[] = [];
    public selectAllIRPClients: boolean = false;
    importSelectedClients() {
        
        this.message = "";
        this.showMessage = false;
       
        var request = {
            selectedClients: this.selectedIRPClients.map(o => o.Value).map(c => c.ClientId),
            selectAll: this.selectAllIRPClients
        }
        this.clientService.fnSetLoadingAction(true);

        this.importService.importSelectedClient(request)
            .finally(() => (this.clientService.fnSetLoadingAction(false), this.showMessage = true))
            .subscribe(
            p => (this.message = p.message, this.isSuccessMessage = p.isSuccess, this.loadClients()),
            e => (this.message = e.json().ExceptionMessage, this.isSuccessMessage = false)
            );
    }

    clientName: string = "";
    clientNo: string = "";
    clientCreateMsg: string = "";
    isSuccessCreateClient: boolean = false;
    showCreateMessage: boolean = false;

    createClient() {

        this.showCreateMessage = false;
        this.clientCreateMsg = "";
        if (!this.clientName || !this.clientNo) {
            return;
        }

        var request = {
            Name: this.clientName,
            ClientNo: this.clientNo
        }

        this.clientService.fnSetLoadingAction(true);
        this.importService.createClient(request)
            .finally(() => (this.clientService.fnSetLoadingAction(false), this.showCreateMessage = true, this.clientName = "", this.clientNo = ""))
            .subscribe(
            p => (this.clientCreateMsg = p.message, this.isSuccessCreateClient = p.isSuccess, this.loadClients()),
            e => (this.clientCreateMsg = e.json().ExceptionMessage, this.isSuccessCreateClient = false)
            );
    }


    public deliClients: any[] = [];    
    public selectAllDeliAndSubs: boolean = false;
    //public importMessage: string = "";
    importDeliverablesAndSubscription() {  

        this.subscriptionsImportMessage = "";
        this.deliverablesImportMessage = "";  
        this.AllClientsImportMessage = "";
        //this.importMessage = "";

       this.importedSubscriptions = [];
       this.importedDeliverables = [];  

        this.deliMessage = "";
        this.showDeliMessage = false;

        if (!(this.deliClients.length > 0) && (!this.selectAllDeliAndSubs)) {
            this.deliMessage = "Select client";
            this.showDeliMessage = true;
            return;
        }
        this.clientService.fnSetLoadingAction(true);      

        var request = {
            selectedClients: this.deliClients.map(o => o.Value).map(c => c.Id),
            selectAll: this.selectAllDeliAndSubs,
            emailId: this.emailId
        }

       
        this.importService.importDeliverablesAndSubscription(request)
            .finally(() => (this.clientService.fnSetLoadingAction(false), this.showDeliMessage = true))
            .subscribe(
            p => (this.deliMessage = p.importMessage, this.isSuccessDeli = p.isSuccess, this.setSubscriptionsDeliverablesReponse(p)),
            e => (this.deliMessage = e.json().ExceptionMessage, this.isSuccessDeli = false)
            );
    }

    public marketClients: any[] = [];
    public selectAllMarkets: boolean = false;

    public marketImportLog: any[] = [];
    importMarkets()  {      

        if (!(this.marketClients.length > 0) && (!this.selectAllMarkets)) {
            this.marketMessage = "Select client";
            this.showMarketMessage = true;
            return;
        }
        this.clientService.fnSetLoadingAction(true);

        this.marketImportLog = [];

        var request = {
            selectedClients: this.marketClients.map(o => o.Value).map(c => c.Id),
            selectAll: this.selectAllMarkets,
            emailId: this.emailId
        } 

        this.marketMessage = "";
        this.showMarketMessage = false;
       
        this.importService.importMarkets(request)
            .finally(() => (this.clientService.fnSetLoadingAction(false), this.showMarketMessage = true))
            .subscribe(
            p => (this.setMarketMessage(p)),
            e => (this.marketMessage = e.json().ExceptionMessage, this.isSuccessMarket = false)
            );
    }

    public setMarketMessage(response: any) {
        this.marketMessage = response.message ? response.message: "";
        this.isSuccessMarket = response.isSuccess ? response.isSuccess : false;
        this.marketImportLog = response.log ? response.log : [];
    }

    public importedSubscriptions: any[] = [];
    public importedDeliverables: any[] = [];

    public subscriptionsImportMessage: string = "";
    public deliverablesImportMessage: string = "";
    public AllClientsImportMessage: string = "";
    setSubscriptionsDeliverablesReponse(response: any) {
        if (!response.IsSelectAll) {
            this.importedSubscriptions = response.sResponse;
            this.importedDeliverables = response.dResponse;
            if (!(this.importedSubscriptions.length > 0)) {

                this.subscriptionsImportMessage = "No subscriptions are imported"
            }
            if (!(this.importedDeliverables.length > 0)) {

                this.deliverablesImportMessage = "No deliverables are imported"
            }
        }
        else {
            this.isSuccessDeli = response.isSuccess;
            this.AllClientsImportMessage = response.message;
        }
    }


    public territoriesClients: any[] = [];
    public selectAllTerritories: boolean = false;

    public territoryImportLog: any[] = [];
    importTerritories() {

        if (!(this.territoriesClients.length > 0) && (!this.selectAllTerritories)) {
            this.territoryMessage = "Select client";
            this.showTerritoryMessage = true;
            return;
        }
       
        this.clientService.fnSetLoadingAction(true);
        this.territoryImportLog = [];

        var request = {
            selectedClients: this.territoriesClients.map(o => o.Value).map(c => c.Id),
            selectAll: this.selectAllTerritories,
            emailId: this.emailId
        }
        this.territoryMessage = "";
        this.showTerritoryMessage = false;
       
        this.importService.importTerritories(request)
            .finally(() => (this.clientService.fnSetLoadingAction(false), this.showTerritoryMessage = true))
            .subscribe(
            p => (this.setTerritoriesResponse(p)),
            e => (this.territoryMessage = e.json().ExceptionMessage, this.isSuccessTerritory = false)
            );
    }

    public setTerritoriesResponse(response: any) {
        this.territoryMessage = response.message ? response.message : "";
        this.isSuccessTerritory = response.isSuccess ? response.isSuccess : false;
        this.territoryImportLog = response.log ? response.log : [];
    }
    //Export to TDW
    public ExportTDWMsg: string = "";
    public selectAllExportToTdw: boolean = false;
    public isSuccessExportTDW: boolean = false;
    public showExportTDWMessage: boolean = false;
    public tdwClients: any[] = [];

    ExportToTdw() {
       
        var req = {
            selectedClients: this.tdwClients.map(o=> o.Value).map(c=> c.Id),
            selectAll: this.selectAllExportToTdw
        }

        this.showExportTDWMessage = false;

        this.clientService.fnSetLoadingAction(true);
        this.importService.exportTdw(req)
            .finally(() => (this.clientService.fnSetLoadingAction(false), this.showExportTDWMessage = true))
            .subscribe(
            p => (this.ExportTDWMsg = p.message, this.isSuccessExportTDW = p.isSuccess),
            e => (this.ExportTDWMsg = e.json().ExceptionMessage, this.isSuccessExportTDW = false)
        );
    }


    //extraction
   


    extractMarkets(): void {
        
        this.clientService.fnSetLoadingAction(true);
        this.importService.extract("markets")
            .finally(() => {
                this.clientService.fnSetLoadingAction(false)
            })
            .catch(error => Observable.throw(error))
            .subscribe((res) => {
                var downloadUrl = URL.createObjectURL(res);
               

                const docUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }));
                const anchor = document.createElement('a');
                anchor.download = "MarketDefinitionExtract.xlsx";
               
                anchor.href = docUrl;
                anchor.click();
            }),
            (err => console.log(err)),
            (() => console.log("export excel completd"));
    }

    extractTerritories() {

        this.clientService.fnSetLoadingAction(true);
        this.importService.extract("territories")
            .finally(() => {
                this.clientService.fnSetLoadingAction(false)
            })
            .catch(error => Observable.throw(error))
            .subscribe((res) => {
                var downloadUrl = URL.createObjectURL(res);


                const docUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }));
                const anchor = document.createElement('a');
                anchor.download = "TerritoriesExtract.xlsx";

                anchor.href = docUrl;
                anchor.click();
            }),
            (err => console.log(err)),
            (() => console.log("export excel completd"));
    }


}