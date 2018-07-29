import { Injectable } from "@angular/core";
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map'
import { Observable } from 'rxjs/Observable';
//import { Subscription } from '../../app/shared/models/subscription';
import { ConfigService } from '../config.service';
import { ClientSubscriptionDTO } from './subscription.model';
import { ClientMarketBase } from './subscription.model';
import { ClientMarketBaseDTO } from './subscription.model';
import { DeliverablesDTO } from '../deliverables/deliverables.model';
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class SubscriptionService {
    private actionUrl: string;
    private headers: Headers;
    private getapiUrl: string;
    private getsubapiUrl: string;
    private getdownloadUrl: string;
    private getdownloadDeliverablesUrl: string;
    public subscriptionID: number;
    public getMarketBaseapiUrl: string;

    constructor(private http: Http, private alertService: AlertService) {
        this.actionUrl = ConfigService.baseWebApiUrl;
        this.getapiUrl = ConfigService.getApiUrl('ClientMarketBaseDetails?id=');
        this.getsubapiUrl = ConfigService.getApiUrl('GetClientSubscriptions?clientid=');
        this.getMarketBaseapiUrl = ConfigService.getApiUrl('GetMarketBaseForSubscription?SubscriptionId=');
        this.getdownloadUrl = ConfigService.getApiUrl('DownloadSubscriptions?clientid=');
        this.getdownloadDeliverablesUrl = ConfigService.getApiUrl('deliverables/DownloadDeliverablesByClient?clientid=')
    }
    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        return headers;
    }

    getClientMarketBase(id: number) {
        var url = this.getapiUrl + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <ClientMarketBase[]>JSON.parse(response.json()))
                .catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                });
    }
    getClientSubscription(cliendid: number) {
        var url = this.getsubapiUrl + cliendid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) =>
                <ClientSubscriptionDTO[]>(response.json())
            )
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getClientMarketBaseForSubscription(subscriptionId: number) {
        var url = this.getMarketBaseapiUrl + subscriptionId;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) =>
                <ClientMarketBaseDTO[]>(response.json())
            )
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
    submitMarketBase(MarketBaseIds: any[], userId: number) {
        //var url = ConfigService.getApiUrl('MarketBaseCreate/SubmitMarketBase/?MarketBaseId=' + MarketBaseId + '&userId=' + userId);
        var url = ConfigService.getApiUrl('MarketBaseCreate/SubmitMarketBase/?userId=' + userId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, MarketBaseIds, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => { })
            .do(data => console.log('Market Base History captured'));
    }

    submitSubscription(Subscription: any, userId: number) {
        var url = ConfigService.getApiUrl('subscription/SubmitSubscription?&UserId=' + userId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        
        return this.http.post(url, Subscription, options)
            .timeout(ConfigService.httpTimeout)
            
            .map((response: Response) => { })
            .do(data => console.log('Territory History captured'));
    }

    SubmitDeliverables(Deliverables: any, UserId: number) {
        var url = ConfigService.getApiUrl('deliverables/SubmitDeliverable/?&UserId=' + UserId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, Deliverables, options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => { })
            .do(data => console.log('Delivery History captured'));
    }

    AddSubscriptionMarketBase(request: any): Observable<any> {
        var url = `${this.actionUrl}/subscription/addMarketBase`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res)
            }
            )
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }


    private getCookie(cname: string) {
        // var name = cname + "=";
        var name = ConfigService.webApiName + '_' + cname + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }
    private getxlHeaders() {


        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/ vnd.openxmlformats - officedocument.spreadsheetml.sheet');
        var t = this.getCookie("token");
        if (t != null && t != '')
            headers.append('Authorization', 'bearer ' + t);
        return headers;
    }
    
    downloadDeliverables(clientId: number): Observable<Object[]> {
        return Observable.create(observer => {

            //var value = JSON.stringify(opts);
            //cliendid: number) {
            var url = this.getdownloadDeliverablesUrl + clientId;
            let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
            //console.log(options);
            // var url = `${this.actionUrl}/GetClientSubscriptions`
            //+ value;
            let xhr = new XMLHttpRequest();
            let headers = this.getxlHeaders();
            xhr.open('GET', url, true);
            xhr.setRequestHeader('Content-type', 'application/json');
            var t = this.getCookie("token");
            if (t != null && t != '')
                headers.append('Authorization', 'bearer ' + t);
            xhr.setRequestHeader('Authorization', 'bearer ' + t);
            xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
            xhr.responseType = 'blob';

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {

                        var contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                        var blob = new Blob([xhr.response], { type: contentType });
                        observer.next(blob);
                        observer.complete();
                    } else {
                        observer.error(xhr.response);
                    }
                }
            }
            xhr.send();

        });
    }
    downloadReport(cliendid:number): Observable<Object[]> {
        return Observable.create(observer => {

            //var value = JSON.stringify(opts);
            //cliendid: number) {
            var url = this.getdownloadUrl + cliendid;
             let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
            //console.log(options);
           // var url = `${this.actionUrl}/GetClientSubscriptions`
                //+ value;
            let xhr = new XMLHttpRequest();
            let headers = this.getxlHeaders();
            xhr.open('GET', url, true);
            xhr.setRequestHeader('Content-type', 'application/json');
            var t = this.getCookie("token");
            if (t != null && t != '')
                headers.append('Authorization', 'bearer ' + t);
            xhr.setRequestHeader('Authorization', 'bearer ' + t);
            xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
            xhr.responseType = 'blob';

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {

                        var contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                        var blob = new Blob([xhr.response], { type: contentType });
                        observer.next(blob);
                        observer.complete();
                    } else {
                        observer.error(xhr.response);
                    }
                }
            }
            xhr.send();

        });
    }
    DeleteSubMarketBase(request: any): Observable<any> {
        var url = `${this.actionUrl}/subscription/deleteMarketBase`;
        //url = url + "?subid=" + subId + "&mktid=" + mktId;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log('deleteMarketBase- ' + res);
            })
            .catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                });
    }
    ValidateDelMarketBase(subid: number, mktid: number, clientid: number): Observable<any> {
        var url = `${this.actionUrl}/subscription/ValidatedeleteMarket/?subscriptionId=` + subid + `&markettbaseid=` + mktid + `&clientid=` + clientid;
        //url = url + "?subid=" + subId + "&mktid=" + mktId;
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            }).catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    async getListOfMarketForMarketbase(subid: number, mktid: number, clientid: number): Promise<any> {
        var url = ConfigService.getApiUrl('subscription/GetListOfMarketForMarketbase/?subscriptionId=' + subid + '&marketbaseId=' + mktid + '&clientId=' + clientid);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        var response: any;
        await this.http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return JSON.parse(response.json());
    }

    UpdateSubscription(request: any): Observable<any> {
        var url = `${this.actionUrl}/subscription/updateSubscription`;

        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log('updateSubscription- ' + res);
            }).catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
    getDeliverablesByClient(id: number) {
        var url = this.actionUrl + '/deliverables/GetDeliverablesByClient/?clientid=' + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <DeliverablesDTO[]>JSON.parse(response.json()))
                .catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                });
    }
    CloneDeliverables(request: any) {
        var url = `${this.actionUrl}/deliverables/CloneDeliverable`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log('Copied deliverables- ' + res);
            }).catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
    CheckDeliveryLock(id: number) {
        var url = this.actionUrl + '/deliverables/CheckDeliveryLock/?defId=' + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <string>(response.json())
            ).catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                });

    }
    
}