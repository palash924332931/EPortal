import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Headers, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/timeout';
import { Client } from '../models/client';
import { CLIENTS } from '../models/mock-clients';
import { BaseFilter } from '../models/base-filter';
import { AdditionalFilter } from '../models/additional-filter';
import { MarketBase } from '../models/market-base';
import { MarketDefinitionBaseMap } from '../models/market-definition-base-map';
import { MarketDefinition } from '../models/market-definition';
import { MarketDefDTO } from '../models/market-definition';
//import { FILTER3 } from '../models/mock-clients';
import { ClientMarketBase } from '../models/client-market-base';

import { StaticPackMarketBase } from '../models/static-pack-market-base';
import { DynamicPackMarketBase } from '../models/dynamic-pack-market-base';
import { ConfigService } from '../../config.service';
import { CommonService } from '../common';
import { AlertService } from '../../shared/component/alert/alert.service';

declare var jQuery: any;

@Injectable()
export class ClientService {

    constructor(private _http: Http, private alertService: AlertService) { }

    //private port: number = 50056;

    clients: Client[];

    public emittedClients: any = new Subject();

    getClientsObservable(): Observable<Client[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.getClientsUrl, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Client[]>JSON.parse(response.json()))
            .do(data => console.log('real clients: ' + JSON.stringify(data)));
    }

    getMockClients(isMyclientSelected: boolean): Observable<Client[]> {
        var result = Observable.of(CLIENTS);
        if (isMyclientSelected) {
            result = Observable.of(CLIENTS.filter(c => c.IsMyClient == isMyclientSelected));
            this.emittedClients.next(result);
            return result;
        }
        this.emittedClients.next(result);
        return result;
    }

    getMockClientsByPromise(isMyclientSelected: boolean): Promise<Client[]> {
        if (isMyclientSelected) {
            return Promise.resolve(CLIENTS.filter(c => c.IsMyClient == isMyclientSelected));
        }
        return Promise.resolve(CLIENTS);
    }

    getMockClientsBySearch(searchKey: string, clients: Client[]): Observable<Client[]> {
        var result = Observable.of(clients.filter(c => c.Name.toLowerCase().search(searchKey.toLowerCase()) != -1));
        this.emittedClients.next(result);
        return result;
    }

    getClientsBySearch(searchKey: string, clients: Client[]): Observable<Client[]> {
        var result = Observable.of(clients.filter(c => c.Name.toLowerCase().search(searchKey.toLowerCase()) != -1));
        this.emittedClients.next(result);
        return result;
    }

    getMockMarketDefinition(): Observable<Client> {
        //console.log('inside service' + FILTER3);
        //console.log('inside service' + CLIENTS[0].Name);

        return Observable.of(CLIENTS[0]);
    }

    getMarketDefinitionsForClient(clientId: number): Observable<Client[]> {
        return Observable.of(CLIENTS.filter(c => c.Id == clientId));
    }

    private getClientsUrl: string = ConfigService.getApiUrl('clients?uid=');
    private getClientUrl: string = ConfigService.getApiUrl('client?id=');
    private getMarketDefByClient: string = ConfigService.getApiUrl('GetMarketDefByClient?id=');
    private getClientMarketBasesUrl: string = ConfigService.getApiUrl('ClientMarketBase/?Id=');

    static cacheClients = {}
    getClients(uid: number) {
        var url = this.getClientsUrl;
        if (ClientService.cacheClients[url]) {
            //console.log('CLIENTS FROM CACHE: ', ClientService.cacheClients[url]);
            return Observable.of(ClientService.cacheClients[url]);
        }
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.getClientsUrl + uid, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Client[]>JSON.parse(response.json()))
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(res => { ClientService.cacheClients[url] = res, console.log('CLIENTS NEW DATA: ' + ClientService.cacheClients[url]) });
    }

    clearCacheClients(): void {
        var url = this.getClientsUrl;
        ClientService.cacheClients[url] = null;
        //console.log("Client cache clear");
    }


    static cacheMarketDefinition = {};
    getClient(id: number) {
        var url = this.getClientUrl + id;

        //console.log('inside get cache data: ', ClientService.cacheMarketDefinition);
        ClientService.cacheMarketDefinition[url] && console.log('empty object keys: ', Object.keys(ClientService.cacheMarketDefinition[url]).length);

        if (ClientService.cacheMarketDefinition[url] && Object.keys(ClientService.cacheMarketDefinition[url]).length) {
            //console.log('MKT DEF FROM CACHE: ', ClientService.cacheMarketDefinition[url]);
            return Observable.of(ClientService.cacheMarketDefinition[url]);
        }
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Client>JSON.parse(response.json()))
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(res => { ClientService.cacheMarketDefinition[url] = res, console.log('MKT DEF NEW DATA: ' + ClientService.cacheMarketDefinition[url]) });
    }

    fnGetMarketDefinition(clientId: number) {
        var url = this.getClientUrl + clientId;
        if (ClientService.cacheMarketDefinition[url] && Object.keys(ClientService.cacheMarketDefinition[url]).length) {//to get from cache
            return Observable.of(ClientService.cacheMarketDefinition[url]);
        }
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketDefinition>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });

    }

    fnGetMarketDefinitionByClient(clientId: number) {
        var url = this.getMarketDefByClient + clientId;
        
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketDefDTO>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });

    }

    getClientMarketBases(ClientId: number) {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.getClientMarketBasesUrl + ClientId, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <ClientMarketBase[]>JSON.parse(response.json()))
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    fnGetMarketBases(ClientId: number, MarketDefId: number, Action: string) {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(ConfigService.getApiUrl('GetMarketBases/?ClientId=' + ClientId + '&MarketDefId=' + MarketDefId + '&Action=' + Action), options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <ClientMarketBase[]>(response.json()))
            .do(data => {
                //console.log('API client market bases: ' + JSON.stringify(data))
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });;
    }    

    async getStaticAvailablePackList(finalQuery: string, ClientId: number): Promise<StaticPackMarketBase[]> {
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.post(ConfigService.getApiUrl('StaticAvailablePackList/?Id=' + ClientId), finalQuery, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise()
            .then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //return JSON.parse(response.json());
        return response.json();
    }

    async getDynamicAvailablePackList(finalQuery: string, ClientId: number): Promise<DynamicPackMarketBase[]> {
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        await this._http.post(ConfigService.getApiUrl('DynamicAvailablePackList/?Id=' + ClientId), finalQuery, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise()
            .then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //return JSON.parse(response.json());
         return response.json();
    }

    async fnGetMarketDefinitionPacks(ClientId: number, MarketDefId: number): Promise<DynamicPackMarketBase[]> {
        var response: any;
        var url = ConfigService.getApiUrl('getMarketDefinitionPacks/?ClientId=' + ClientId + '&MarketDefId=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return (response.json());
    }

    async getDefinitionLockHistories(UserId: number, DefId: number, DocType: string, LockType: string, Status: string): Promise<DynamicPackMarketBase[]> {
        var response: any;
        var url = ConfigService.getApiUrl('getCommonLockHistories/?UserId=' + UserId + '&DefId=' + DefId + '&DocType=' + DocType + '&LockType=' + LockType + '&Status=' + Status);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return JSON.parse(response.json());
    }

    async LockHistories(UserId: number, DefId: number, DocType: string, LockType: string, Status: string): Promise<DynamicPackMarketBase[]> {
        var response: any;
        var url = ConfigService.getApiUrl('LockHistories/?UserId=' + UserId + '&DefId=' + DefId + '&DocType=' + DocType + '&LockType=' + LockType + '&Status=' + Status);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return JSON.parse(response.json());
    }


    async checkCreateMarketDefDuplication(ClientId: number, MarketDefName: string): Promise<string> {
        var url = ConfigService.getApiUrl('checkForMarketDefDuplication/?clientId=' + ClientId + '&MarketDefName=' + MarketDefName);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response.json().toString();
    }

    async checkEditForMarketDefDuplication(ClientId: number, MarketDefId: number, MarketDefName: string): Promise<string> {
        var url = ConfigService.getApiUrl('checkForMarketDefDuplication/?clientId=' + ClientId + '&MarketDefId=' + MarketDefId + '&MarketDefName=' + MarketDefName);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response.json().toString();
    }

    private _clearMarketDefinitionCache(ClientId: number) {
        var viewUrl = this.getClientUrl + ClientId;
        ClientService.cacheMarketDefinition[viewUrl] = {};
    }

    postClientMarketDef(client: string, ClientId: number) {
        this._clearMarketDefinitionCache(ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(ConfigService.getApiUrl('saveClientMarketDef/?Id=' + ClientId), client, options)
            .timeout(500000)
            .map((response: Response) => <MarketDefinition>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => {//console.log('API clientMrket Def to post: ' + JSON.stringify(data))
        // });
    }

    editClientMarketDef(client: string, ClientId: number, MarketDefId: number) {
        this._clearMarketDefinitionCache(ClientId);
        //console.log('inside edit cache data: ', ClientService.cacheMarketDefinition);

        var url = ConfigService.getApiUrl('editClientMarketDef/?clientId=' + ClientId + '&MarketDefId=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, client, options)
            .timeout(500000)
            .map((response: Response) => <MarketDefinition>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    deleteClientMarketDef(ClientId: number, MarketDefId: number) {
        var url = ConfigService.getApiUrl('deleteClientMarketDef/?clientId=' + ClientId + '&MarketDefId=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketDefinition[]>response.json())
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('API clientMrket deleted:  ' + data));;
        //.map((response: Response) => <MarketDefinition[]>JSON.parse(response.json()))
        //.do(data => console.log('API clientMrket del ' + JSON.stringify(data)));
    }

    async checkSubcribedMarketDef(ClientId: number, MarketDefId: number): Promise<any> {
        var url = ConfigService.getApiUrl('checkSubcribedMarketDef/?clientId=' + ClientId + '&MarketDefId=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        var response: any;
        await this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return JSON.parse(response.json());
        //.map((response: Response) => <MarketDefinition[]>JSON.parse(response.json()))
        //.do(data => console.log('API clientMrket del ' + JSON.stringify(data)));


    }


    getClientMarketDef(ClientId: number, MarketDefId: number) {
        var url = ConfigService.getApiUrl('GetClientMarketDef/?clientId=' + ClientId + '&MarketDefId=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketDefinition[]>((response.json())))
            //.map((response: Response) => console.log(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
    async updateMarketDefinitionName(ClientId: number, MarketDefId: number, MarketDefName: string): Promise<string> {
        this._clearMarketDefinitionCache(ClientId);
        var url = ConfigService.getApiUrl('updateMarketDefName/?ClientId=' + ClientId + '&MarketDefId=' + MarketDefId + '&MarketDefName=' + MarketDefName);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
             .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response.json().toString();
    }
    
    fnSetLoadingAction(action: boolean) {
        if (action == true) {
            jQuery("#overlay-loading").css("display", "block");
        } else {
            jQuery("#overlay-loading").css("display", "none");
        }
    } 

    fnSubmitMarketDef(MarketDefIds: any[], UserId: number) {
        var url = ConfigService.getApiUrl('SubmitMarketDef/?userId=' + UserId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, MarketDefIds, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => { })
            .do(data => console.log('Market Base History captured'));
    }  
}