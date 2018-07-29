import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../../config.service';
import { CommonService } from '../../shared/common';

@Injectable()
export class SubscriptionAndDeliverablesCreateService {

    private actionUrl: string;

    constructor(private http: Http) {
        this.actionUrl = ConfigService.baseWebApiUrl;
    }

    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        return headers;
    }

    //subscription dropdowns
    GetDatatypes(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetDataTypes`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetClients(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetSources(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetSources`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetCountries(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetCountries`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }


    GetServices(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetServices`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetTerritoryBases(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetTerritoryBases`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetSubscriptionsByClientId(id: any): Observable<any> {
        var url = `${this.actionUrl}/admin/GetSubscriptionsByClient?clientid=` + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetSubscriptions(id: any): Observable<any> {
        var url = `${this.actionUrl}/admin/GetSubscriptions?id=` + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetDeliverable(id: any): Observable<any> {
        var url = `${this.actionUrl}/admin/GetDeliverable?id=` + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetDeliverablesBySubscription(id: any): Observable<any> {
        var url = `${this.actionUrl}/admin/GetDeliverablesBySubscription?id=` + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetDeliveryTypes(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetDeliveryTypes`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetFrequencyTypes(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetFrequencyTypes`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetFrequencies(id: any): Observable<any> {
        var url = `${this.actionUrl}/admin/GetFrequencies?id=` + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetPeriods(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetPeriods`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetReportWriters(id: any): Observable<any> {
        var url = `${this.actionUrl}/admin/GetReportWriters?id=` + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetRestriction(id: any, tid: any, clientid: any): Observable<any> {
        //var url = `${this.actionUrl}/admin/GetRestriction`;
        //let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        //return this.http
        //    .get(url, options)
        //    .map(function (res) {
        //        return res.json() as any;
        //    });

        var url = this.actionUrl + '/deliverables/getRestrictions/?id=' + id + '&tid=' + tid + '&clientid=' + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <any[]>JSON.parse(response.json()))
            .catch((error) => {
                //this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    //create the subscriptions for the selected clients
    CreateSubscription(request: any): Observable<any> {
        var url = `${this.actionUrl}/subscription/create`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //updated the subscriptions for the selected clients
    UpdateSubscription(request: any): Observable<any> {
        var url = `${this.actionUrl}/subscription/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }


    //create the Deliverable for the selected clients
    CreateDeliverable(request: any): Observable<any> {
        var url = `${this.actionUrl}/deliverable/create`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //updated the Deliverable for the selected clients
    UpdateDeliverable(request: any): Observable<any> {
        var url = `${this.actionUrl}/deliverable/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }
}