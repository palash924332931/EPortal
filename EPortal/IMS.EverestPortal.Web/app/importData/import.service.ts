import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';

@Injectable()
export class ImportService {
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
    GetIRPClients(): Observable<any> {
        var url = `${this.actionUrl}/import/GetIRPClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }


    //Get the clients
    GetClients(): Observable<any> {
        var url = `${this.actionUrl}/import/GetEverestClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //Get all the clients with newly created clients 
    GetAllClients(): Observable<any> {
        var url = `${this.actionUrl}/import/GetAllEverestClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }


    


    importSelectedClient(request: any): Observable<any> {
        var url = `${this.actionUrl}/import/clients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    createClient(request: any): Observable<any> {
       var url = `${this.actionUrl}/client/create`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    importDeliverablesAndSubscription(request: any): Observable<any> {
        var url = `${this.actionUrl}/import/DeliverablesAndSubscription`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    importMarkets(request: any): Observable<any> {
        var url = `${this.actionUrl}/import/Markets`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    importTerritories(request: any): Observable<any> {
        var url = `${this.actionUrl}/import/Territories`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    exportTdw(request: any): Observable<any> {
        var url = `${this.actionUrl}/export/tdw`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
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
    extract(extractType:string): Observable<Object[]> {
        try {
            return Observable.create(observer => {
                var url = `${this.actionUrl}/extract/markets`;
                if (extractType == "territories") {
                    url = `${this.actionUrl}/extract/territories`;
                }
                
                let xhr = new XMLHttpRequest();
                let headers = this.getxlHeaders();
                xhr.open('POST', url, true);
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
                        }
                        else {
                            observer.error(xhr.response);
                        }
                    }
                }
                xhr.send();
            });
        }
        catch (err) {
            alert(err.descrription);
        }
    }





}