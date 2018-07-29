import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';
import { Client, LockedDefinition } from '../unlock/unlock.model';

@Injectable()
export class UnlockService {
    private actionUrl: string;

    constructor(private http: Http) {
        this.actionUrl = ConfigService.baseWebApiUrl;
    }

    //Get all the clients with newly created clients 
    getAllClients(): Observable<any> {
        var url = `${this.actionUrl}/GetClients`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <Client[]>JSON.parse(response.json()));
    }

    //Get locked definitions 
    getLockedDefinitions(clientId: number): Observable<any> {
        var url = `${this.actionUrl}/GetLockedDefinitions?clientId=${clientId}`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <LockedDefinition[]>JSON.parse(JSON.stringify(response.json())));
    }

    //unlock definitions
    unlockDefinitions(historiesID: number[]): Observable<any> {
        var url = `${this.actionUrl}/UnlockDefinitions`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, historiesID, options)
            .map((response: Response) => response.json());
    }
}