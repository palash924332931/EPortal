import { Injectable } from "@angular/core";
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map'
import { Observable } from 'rxjs/Observable';
//import { Subscription } from '../../app/shared/models/subscription';
import { ConfigService } from '../config.service';
import { User } from '../user/user-management.model';
import { Role, Client } from '../user/user-management.model';
import { CommonService } from '../shared/common';


@Injectable()
export class UserManagementService {
    private actionUrl: string;
    private headers: Headers;
    private getapiUrl: string;
  

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
    getClients() {
        var url = `${this.actionUrl}/GetClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <Client[]>JSON.parse(response.json()));
    }
    getRoles() {
        var url = `${this.actionUrl}/GetRoles`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <Role[]>JSON.parse(response.json()));
    }
    getUsers() {
        var url = `${this.actionUrl}/GetUsers`;
        //console.log(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <User[]>JSON.parse(response.json()));
    }
    getUserByID() {
        var url = `${this.actionUrl}/subscription/addMarketBase`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <User[]>JSON.parse(response.json()));
    }
    AddUser(request: User): Observable<any> {
        var url = `${this.actionUrl}/AddUser`;
       
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                console.log('user added- ' + res);
            });
    }
    UpdateUserStatus(request: any): Observable<any> {
        var url = `${this.actionUrl}/UpdateUserStatus`;

        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                console.log('user status updated- ' + res);
            });
    }

    ResendAccountVerificationEmail(request: User): Observable<any> {
        var url = `${this.actionUrl}/ResendAccountVerificationEmail`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }
    DeleteUser(request: User): Observable<any> {
        var url = `${this.actionUrl}/DeleteUser`;

        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                console.log('user deleted- ' + res);
            });
    }
}