import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Headers, RequestOptions } from '@angular/http';
import 'rxjs/Rx';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';
import 'rxjs/add/operator/toPromise';
import { ConfigService } from '../../config.service';
import { Territory } from '../models/territory/territorydefinition.model';
import { OutletBrick } from '../models/territory/brick-allocation';
import { MOCK_TERRITORY2 } from '../models/territory/mock-territory2';
import { CommonService } from '../common';
import { AlertService } from '../../shared/component/alert/alert.service';

declare var jQuery: any;

@Injectable()
export class TerritoryDefinitionService {

    private _getTerritoriesUrl: string = ConfigService.getApiUrl('Territories?clientId=');

    constructor(private _http: Http, private alertService: AlertService) { }

    private territoryDefinitionUrl = ConfigService.getApiUrl('Territories/1');
    public isChangeDetectedInTerritorySetup: boolean;
    public isChangeDetectedInTerritoryDef: boolean;

    getTerritoryDefinition(): Observable<Territory> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.territoryDefinitionUrl, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Territory>JSON.parse(response.json()));
        //.do(data => console.log('territory defintion: ' + JSON.stringify(data)));
    }

    getTerritoryDefForClient(ClientId: number, TerritoryId: number, TerritoryName: string) {
        var url = ConfigService.getApiUrl('getTerritory/?clientId=' + ClientId + '&TerritoryId=' + TerritoryId + '&TerritoryName=' + TerritoryName);
        TerritoryDefinitionService.cacheTerritoryDefinition[url] && console.log('empty object keys: ', Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length);

        /*if (TerritoryDefinitionService.cacheTerritoryDefinition[url] && Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length) {
            console.log('TxR DEF FROM CACHE: ', TerritoryDefinitionService.cacheTerritoryDefinition[url]);
            return Observable.of(TerritoryDefinitionService.cacheTerritoryDefinition[url]);
        }*/
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(480000)
            .map((response: Response) => <Territory[]>JSON.parse(JSON.stringify(response.json())))
            .do(res => {
                TerritoryDefinitionService.cacheTerritoryDefinition[url] = res, console.log('TxR get data from API: ' + TerritoryDefinitionService.cacheTerritoryDefinition[url])
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getTerritoryDefForClientByName(ClientName: string, TerritoryId: number, TerritoryName: string) {
        var url = ConfigService.getApiUrl('getTerritory/?clientName=' + ClientName + '&TerritoryId=' + TerritoryId + '&TerritoryName=' + TerritoryName);
        TerritoryDefinitionService.cacheTerritoryDefinition[url] && console.log('empty object keys: ', Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length);

        /*if (TerritoryDefinitionService.cacheTerritoryDefinition[url] && Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length) {
            console.log('TxR DEF FROM CACHE: ', TerritoryDefinitionService.cacheTerritoryDefinition[url]);
            return Observable.of(TerritoryDefinitionService.cacheTerritoryDefinition[url]);
        }*/
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(480000)
            .map((response: Response) => <Territory[]>JSON.parse(JSON.stringify(response.json())))
            .do(res => {
                TerritoryDefinitionService.cacheTerritoryDefinition[url] = res, console.log('TxR get data from API: ' + TerritoryDefinitionService.cacheTerritoryDefinition[url])
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    /* getTerritoryDefForClient(ClientId: number, TerritoryId: number, TerritoryName: string) {
        var url = ConfigService.getApiUrl('getTerritory/?clientId=' + ClientId + '&TerritoryId=' + TerritoryId + '&TerritoryName=' + TerritoryName);
        console.log('inside get cache data: ', TerritoryDefinitionService.cacheTerritoryDefinition);
        TerritoryDefinitionService.cacheTerritoryDefinition[url] && console.log('empty object keys: ', Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length);
        
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this._http.get(url,options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Territory[]>JSON.parse(response.json()))
            .do(res => { TerritoryDefinitionService.cacheTerritoryDefinition[url] = res, console.log('TxR get data from API: ' + TerritoryDefinitionService.cacheTerritoryDefinition[url]) });
    }*/

    getAvailableBrickOutletUpdated(type: string, territoryDefId: number, role: string, clientId: number) {
        var url = ConfigService.getApiUrl('getBrickOutletUpdated/?type=' + type + '&territoryId=' + territoryDefId + '&Role=' + role + '&clientId=' + clientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <OutletBrick>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
    private handleError(error: Response | any) {
        let errMsg: string;
        if (error instanceof Response) {
            const body = error.json() || '';
            const err = body.error || JSON.stringify(body);
            errMsg = `${error.status} - ${error.statusText || ''} ${err}`;
        } else {
            errMsg = error.message ? error.message : error.toString();
        }
        console.error(errMsg);
        return Observable.throw(errMsg);
    }

    static cacheTerritoryDefinition = {};
    public territorySharedData = {};
    getClientTerritories(id: number) {
        var url = this._getTerritoriesUrl + id;

        //console.log('inside get cache data: ', TerritoryDefinitionService.cacheTerritoryDefinition);
        TerritoryDefinitionService.cacheTerritoryDefinition[url] && console.log('empty object keys: ', Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length);

        if (TerritoryDefinitionService.cacheTerritoryDefinition[url] && Object.keys(TerritoryDefinitionService.cacheTerritoryDefinition[url]).length) {
            //console.log('TxR DEF FROM CACHE: ', TerritoryDefinitionService.cacheTerritoryDefinition[url]);
            return Observable.of(TerritoryDefinitionService.cacheTerritoryDefinition[url]);
        }
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Territory[]>JSON.parse(response.json()));
        // .do(res => { TerritoryDefinitionService.cacheTerritoryDefinition[url] = res, console.log('TxR DEF NEW DATA: ' + TerritoryDefinitionService.cacheTerritoryDefinition[url]) });
    }

    fnGetClientTerritories(id: number) {
        var url = ConfigService.getApiUrl('ClientTerritories/?clientId=' + id);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <any[]>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    fnGetTerritoriesByClient(id: number) {
        var url = ConfigService.getApiUrl('GetTerritoryByClient/?clientId=' + id);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <any[]>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    private _clearTerritoryDefinitionCache(ClientId: number) {
        var url = this._getTerritoriesUrl + ClientId;
        TerritoryDefinitionService.cacheTerritoryDefinition[url] = {};
    }

    editTerritory(ClientId: number, TerritoryId: number, Territory: Territory) {
        this._clearTerritoryDefinitionCache(ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });

        return this._http.post(ConfigService.getApiUrl('editTerritory?ClientId=' + ClientId + "&TerritoryId=" + TerritoryId), JSON.stringify(Territory), options)
            .timeout(500000)
            .map((response: Response) => <Territory>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    updateTerritoryBaseInfo(ClientId: number, TerritoryId: number, Territory: any) {
        this._clearTerritoryDefinitionCache(ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });

        return this._http.post(ConfigService.getApiUrl('updateTerritoryBaseInfo?ClientId=' + ClientId + "&TerritoryId=" + TerritoryId), JSON.stringify(Territory), options)
            .timeout(500000)
            .map((response: Response) => response.json())
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    postTerritory(ClientId: number, Territory: Territory) {
        this._clearTerritoryDefinitionCache(ClientId);
        let url = ConfigService.getApiUrl('postTerritory?Id=' + ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });

        return this._http.post(ConfigService.getApiUrl('postTerritory?ClientId=' + ClientId), JSON.stringify(Territory), options)
            .timeout(500000)
            .map((response: Response) => <Territory>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('API Territory Def to post service: ' + JSON.stringify(data)));
    }

    fnCopyTerritory(destClientId: number, sourceTerritoryID: number, destTerritoryName: string, type: string) {
        this._clearTerritoryDefinitionCache(destClientId);
        let url = ConfigService.getApiUrl('copyTerritory?DestClientId=' + destClientId + '&SourceTerritoryID=' + sourceTerritoryID + '&DestTerritoryName=' + destTerritoryName + '&Type=' + type);
        //console.log("url" + url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, JSON.stringify(Territory), options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Territory>response.json())
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    deleteTerritory(ClientId: number, TerritoryId: number) {
        var url = ConfigService.getApiUrl('deleteTerritory/?clientId=' + ClientId + '&TerritoryId=' + TerritoryId);
        //console.log("service url:" + url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => response.json())
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('API Territory deleted:  ' + data));
    }


    deleteClientMarketDef(ClientId: number, MarketDefId: number) {
        var url = ConfigService.getApiUrl('deleteClientMarketDef/?clientId=' + ClientId + '&MarketDefId=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => response.toString());
        // .do(data => console.log('API clientMrket deleted:  ' + data));;
    }

    checkIMSHierarchy(ClientId: number, TerritoryId: number, TerritoryName: string) {
        var url = ConfigService.getApiUrl('checkIMSHierarchy/?clientId=' + ClientId + '&TerritoryId=' + TerritoryId + '&TerritoryName=' + TerritoryName);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Boolean>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        // .do(res => { console.log('TxR get data from API: ' + JSON.stringify(res)) });
    }

    getBrickOutlet(Type: string, role: string, clientId: number) {
        var url = ConfigService.getApiUrl('getBrickOutlet/?Type=' + Type + '&Role=' + role + '&ClientID=' + clientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <OutletBrick[]>(response.json()))
            .do(data => {
                //console.log('API clientMrket deleted:  ' + data)
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    async checkCreateTerritoryDefDuplication(ClientId: number, TerritoryName: string): Promise<string> {
        var url = ConfigService.getApiUrl('checkForTerritoryDefDuplication/?clientId=' + ClientId + '&TerritoryName=' + TerritoryName);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response.json();
    }

    async checkSRADuplication(ClientId: number, TerritoryId: number, SRAClient: string, SRASuffix: string, LD: string, AD: string): Promise<any> {
        var url = ConfigService.getApiUrl('checkSRADuplication/?ClientId=' + ClientId + '&TerritoryId=' + TerritoryId + '&SRAClient=' + SRAClient + '&SRASuffix=' + SRASuffix + '&LD=' + LD + '&AD=' + AD);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //return response.json().toString();
        return response.json();
    }

    async checkEditForTerritoryDefDuplication(ClientId: number, TerritoryId: number, TerritoryName: string): Promise<string> {
        var url = ConfigService.getApiUrl('checkForTerritoryDefDuplication/?clientId=' + ClientId + '&TerritoryId=' + TerritoryId + '&TerritoryName=' + TerritoryName);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return response.json().toString();
    }

    async checkSubcribedTerritoryDef(ClientId: number, MarketDefId: number): Promise<any> {
        var url = ConfigService.getApiUrl('checkSubcribedTerritoryDef/?ClientId=' + ClientId + '&TerritoryID=' + MarketDefId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        var response: any;
        await this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response.json();
    }
    async fnPopulateSRAInfo(ClientId: number): Promise<any> {
        var url = ConfigService.getApiUrl('populateSRAInfo/?ClientId=' + ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        var response: any;
        await this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response.json();
    }

    fnSetLoadingAction(action: boolean) {
        if (action == true) {
            jQuery("#overlay-loading").css("display", "block");
        } else {
            jQuery("#overlay-loading").css("display", "none");
        }
    }

    submitTerritory(TerritoryId: number[], userId: number) {
        var request = {
            TerritoryId: TerritoryId,
            UserId: userId
        };
        var url = ConfigService.getApiUrl('SubmitTerritory');
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, request , options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => { })
            .do(data => console.log('Territory History captured'));
    }

    async checkIsInternalClient(ClientId: number): Promise<boolean> {
        var url = ConfigService.getApiUrl('checkIsInternalClient/?ClientId=' + ClientId);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return response.json();
    }

    async getIMSStandardStructureOption(): Promise<any> {
        var url = ConfigService.getApiUrl('getIMSStandardStructure');
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return response.json();
    }

    async getAllTerritoriesName(ClientId: number): Promise<any> {
        var url = ConfigService.getApiUrl('getAllTerritoriesName/?clientId=' + ClientId);
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return response.json();
    }
}


