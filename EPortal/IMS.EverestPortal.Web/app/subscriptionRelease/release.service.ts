import { Injectable } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';

@Injectable()
export class ReleaseService {

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

    
    //Get the users with assigned client count
    GetClientReleaseDetails(userId: string, isAllClients :boolean): Observable<any> {
        var url = `${this.actionUrl}/release/clientReleaseDetails?id=` + userId + '&isAllClients=' + isAllClients;
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    //Get Manufacturers details by search value
    GetMFR(request :any): Observable<any> {
        var url = `${this.actionUrl}/release/GetMFR`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }


    GetPackException(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/GetPackException`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {                
                return res.json() as any;
            });
    } 

    Allocate(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/AllocateReleases`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res);
            });
    } 

    saveReleases(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/SaveReleases`;
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res);
            });
    }

    updatePackExpiryDate(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/SaveExpiryDates`;
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res);
            });
    }


    LogError(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/LogError`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res);
            });
    } 

    AllocateAllMfrSearchItems(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/SaveAllMfrSearchItems`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log()
            });
    } 

    AllocateAllPackSearchItems(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/SaveAllPackSearchItems`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log()
            });
    } 

    GetMfrsbyClient(clientId: any): Observable<any> {
        var url = `${this.actionUrl}/release/ClientMFRs?Id=${clientId}`
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetPacksbyClient(clientId: any): Observable<any> {
        var url = `${this.actionUrl}/release/ClientPackException?Id=${clientId}`
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    deleteMfr(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/removeMFR`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res)
            });
    }

    deletePacks(request: any): Observable<any> {
        var url = `${this.actionUrl}/release/removePackException`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res)
            });
    }


      

}