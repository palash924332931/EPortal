import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';

@Injectable()
export class AllocationService {
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
    GetUsers(): Observable<any> {
        var url = `${this.actionUrl}/allocation/GetUsersWithClientAssignedCount`
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //Get users with by Client Id
    GetUsersbyClientId(clientId:any): Observable<any> {
        var url = `${this.actionUrl}/allocation/GetUserByClient?id=${clientId}`
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http
            .get(url, options)
            .map(function (res) {
                //console.log(res.json());
                return res.json() as any;
            });
    }

    //Get the users with assigned client count
    GetClients(): Observable<any> {
        var url = `${this.actionUrl}/allocation/GetClientsWithUserAssignedCount`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http
            .get(url, options)
            .map(function (res) {
                console.log('Clients '+res.json());
               return res.json() as any;
            });
    }

    //Get clients with by user Id
    GetClientbyUserId(userId :any): Observable<any> {
        var url = `${this.actionUrl}/allocation/GetClientByUser?id=${userId}`
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //Allocate the users to clients
    Allocate(request: any): Observable<any> {
        var url = `${this.actionUrl}/allocation/AllocateUserWithClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                console.log(res)
            });
    }

    getToReallocateUser(request: any): Observable<any> {
        var url = `${this.actionUrl}/allocation/ToReallocateUsers`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    getToReallocateClient(request: any): Observable<any> {
        var url = `${this.actionUrl}/allocation/ToReallocateClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //Remove the allocation
    delete(request: any): Observable<any> {
        var url = `${this.actionUrl}/allocation/Delete`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                console.log(res)
            });
    }

    //Remove the allocation
    reAllocate(request: any): Observable<any> {
        var url = `${this.actionUrl}/allocation/Reallocate`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                console.log(res)
            });
    }



}