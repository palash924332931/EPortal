import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Headers, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';
import { ConfigService } from '../../config.service';
import { Pack } from '../models/pack';
import { MarketBase, MarketBaseDetails, } from '../models/market-base-new';
import { Dimension } from '../models/marketbase/dimension';
import { CommonService } from '../common';
import { AlertService } from '../../shared/component/alert/alert.service';


declare var jQuery: any;

@Injectable()
export class MarketBaseService {

    constructor(private _http: Http, private alertService: AlertService) { }

    //private port: number = 50056;
    getClientName(ClientId: number) {
        var url = ConfigService.getApiUrl('GetClientName/?ClientId=' + ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <string>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getAvailablePacks() {
        var url = ConfigService.getApiUrl('MarketBaseCreate/GetAvailablePackList');
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <Pack[]>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }


    saveMarketBase(ClientId: number, marketBase: any) {
        var url = ConfigService.getApiUrl('MarketBaseCreate/SaveMarketBase/?ClientId=' + ClientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, JSON.stringify(marketBase), options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketBase[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('Market Base List Load Successfully'));
    }
    editMarketBase(ClientId: number, MarketBaseId: number, marketBase: any) {
        var url = ConfigService.getApiUrl('MarketBaseCreate/EditMarketBase/?ClientId=' + ClientId + '&MarketBaseId=' + MarketBaseId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, JSON.stringify(marketBase), options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <string>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });

        /* return this._http.post(url, JSON.stringify(marketBase), options)
        .timeout(ConfigService.httpTimeout)
        .map((response: Response) => <MarketBase[]>JSON.parse(response.json()))
        .catch((error) => {
            this.alertService.exceptionAlert(error);
            return Observable.throw("");
        });*/
        // .do(data => console.log('Market Base List Load Successfully'));
    }


    getMarketBasePacks(marketBaseId: number, clientId: number) {
        var url = ConfigService.getApiUrl('MarketBaseCreate/GetMarketBasePacks/?id=' + marketBaseId + '&clientId=' + clientId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <MarketBase>(JSON.parse(response.json())))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('Market Base List Load Successfully'));
    }
    async checkMarketbaseNameDuplication(MarketbaseId: number, ClientId: number, MarketDefName: string): Promise<boolean> {
        var url = ConfigService.getApiUrl('MarketBaseCreate/checkForMarketbaseDuplication/?MarketbaseId=' + MarketbaseId + '&ClientId=' + ClientId + '&MarketbaseName=' + MarketDefName);
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

    getEffectedMarketDefName(MarketBaseId: number, ClientId: number) {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        var url = ConfigService.getApiUrl('MarketBaseCreate/GetEffectedMarketDefName/?MarketBaseId=' + MarketBaseId + '&ClientId=' + ClientId);
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <string>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    fnSetLoadingAction(action: boolean) {
        if (action == true) {
            jQuery("#overlay-loading").css("display", "block");
        } else {
            jQuery("#overlay-loading").css("display", "none");
        }
    }
    getStartDate(): Observable<Date> {
        var url = ConfigService.getApiUrl('MarketBaseCreate/GetDefaultStartDate');
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        let response = this._http
            .get(url, options)
            .map((response: Response) => <Date>(response.json()));
        return response;

    }
    submitMarketBase(MarketBaseId: number, userId: number) {
        var url = ConfigService.getApiUrl('MarketBaseCreate/SubmitMarketBase/?MarketBaseId=' + MarketBaseId + '&userId=' + userId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => { })
            .do(data => console.log('Market Base History captured'));
    }

    deleteMarketBase(ClientId: number, marketbaseId: number) {
        var url = ConfigService.getApiUrl('DeleteMarketbase/?ClientId=' + ClientId + '&MarketbaseId=' + marketbaseId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(url, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => <string>(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
}