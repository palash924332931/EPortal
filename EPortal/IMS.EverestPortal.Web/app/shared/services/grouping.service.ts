import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Headers, RequestOptions } from '@angular/http';
import { Observable, Subject } from 'rxjs/Rx';

import { ClientMarketBase } from '../models/client-market-base';
import { ConfigService } from '../../config.service';
import { CommonService } from '../common';
import { StaticPackMarketBase } from '../models/static-pack-market-base';
import { DynamicPackMarketBase } from '../models/dynamic-pack-market-base';
import { MarketDefinition } from '../models/market-definition';
import { MarketGroupView, MarketGroupPack,MarketDefinitionPacks } from '../../shared/models/grouping/grouping-model';
import { AlertService } from '../../shared/component/alert/alert.service';

declare var jQuery: any;

@Injectable()
export class GroupingService {
    public static marketDefinitionBaseMap: any[] = [];
    public static marketDefinition: MarketDefinition=new MarketDefinition();
    public static dynamicPacksFinal: MarketDefinitionPacks[] = [];
    public static dynamicPacksList: MarketDefinitionPacks[] = [];
    public static isLockDef: boolean = false;

    constructor(private _http: Http, private alertService: AlertService) { }

    fnGetMarketBases(ClientId: number, MarketDefId: number, Action: string) {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(ConfigService.getApiUrl('GetMarketBases/?ClientId=' + ClientId + '&MarketDefId=' + MarketDefId + '&Action=' + Action), options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <ClientMarketBase[]>(response.json()))
            .do(data => {
                //console.log('API client market bases: ' + JSON.stringify(data))
            });
    }
    async getDynamicAvailablePackList(finalQuery: string, ClientId: number): Promise<MarketDefinitionPacks[]> {
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        await this._http.post(ConfigService.getApiUrl('DynamicAvailablePackList/?Id=' + ClientId), finalQuery, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise()
            .then(result => response = result)
            .catch((error) => {
                //this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //return JSON.parse(response.json());
        return response.json();
    }
    async getStaticAvailablePackList(finalQuery: string, ClientId: number): Promise<MarketDefinitionPacks[]> {
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.post(ConfigService.getApiUrl('StaticAvailablePackList/?Id=' + ClientId), finalQuery, options)
            .timeout(ConfigService.httpTimeout)
            .toPromise()
            .then(result => response = result)
            .catch((error) => {
                //this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //return JSON.parse(response.json());
        return response.json();
    }

    saveMarketGroupView(marketDefinitionId: number, groupView: MarketGroupView[], groupPack: MarketGroupPack[]): Observable<any> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        //let body = JSON.stringify(groupView);
        let body = { MarketDefinitionId: marketDefinitionId, GroupView: groupView, MarketGroupPack: groupPack }
        return this._http.post(ConfigService.getApiUrl('postMarketGroup'), body, options)
            .map(function (res) {
                return res.json() as any;
            })
            .catch((error) => {
                //this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getMarketGroupView(marketDefinitionId: number) {
        var url = ConfigService.getApiUrl('GetMarketGroup/?MarketDefinitionId=' + marketDefinitionId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <any>(response.json()))
            .catch((error) => {
                //this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    fnSaveMarketGroupDetails(finalMarket: string, clientId: number, marketDefId: number) {
        debugger;
        var response: any;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.post(ConfigService.getApiUrl('SaveMarketGroupDetails/?MarketDefId=' + marketDefId + "&ClientId=" + clientId), finalMarket, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketDefinition>(response.json()))
            .catch((error) => {
                //this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    fnGetMarketDef(ClientId: number, MarketDefId: number) {
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


    async fnGetMarketDefinitionPacks(ClientId: number, MarketDefId: number): Promise<MarketDefinitionPacks[]> {
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
    async updateMarketDefinitionName(ClientId: number, MarketDefId: number, MarketDefName: string): Promise<string> {
        //this._clearMarketDefinitionCache(ClientId);
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

    async uniqueID() {
        var idLength = 8;
        var ts = Date.now().toString();
        var parts = ts.split("").reverse();
        var id = "";

        for (var i = 0; i < idLength; ++i) {
            var index = await this.getRandomInt(0, parts.length - 1);
            id += parts[index];
        }

        return id;
    }

    async  getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
}