import { Injectable } from '@angular/core';
import { Response, Headers, Http } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';

@Injectable()
export class ReportService {
    private actionUrl: string;
    reportSearchQuery: any;

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

    //Get Manufacturers details by search value
    GetReportFilters(request: any): Observable<any> {
        var url = `${this.actionUrl}/report/GetReportFilters`
        return this.http
            .post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    setSearchQuery(q: any) {
        this.reportSearchQuery = q;
    }

    getSearchQuery(): any {
        return this.reportSearchQuery;
    }



}