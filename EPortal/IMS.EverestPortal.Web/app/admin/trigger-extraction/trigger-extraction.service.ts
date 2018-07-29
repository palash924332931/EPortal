import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../../config.service';
import { CommonService } from '../../shared/common';
import { Client } from '../../user/user-management.model';



@Injectable()
export class TriggerExtractionService  {
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

    ////Get the clients to which the user role has access to
    GetClients(): Observable<Client[]> {
        var url = `${this.actionUrl}/GetClients`
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map((response: Response) => <Client[]>JSON.parse(response.json()));
    }

    //Get the deliverables for client
    GetDeliverables(clientid: number): Observable<any> {
        var url = `${this.actionUrl}/deliverables/GetDeliverablesByClient` + `&clientid=` + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }
}