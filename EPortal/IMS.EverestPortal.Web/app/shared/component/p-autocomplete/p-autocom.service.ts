﻿import { Injectable } from '@angular/core';
import { Http, Response, RequestOptions, Headers } from '@angular/http';
//import 'rxjs/Rx';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';
import 'rxjs/add/operator/toPromise';
import { ConfigService } from '../../../config.service';
import { Atc4, Atc, Atc1, Atc2, Atc3, Nec, Nec1, Nec2, Nec3, Nec4, Filter } from './p-autocom.model';
import { CommonService } from '../../common';
import { AlertService } from '../../../shared/component/alert/alert.service';

@Injectable()
export class AutoCompleteService {
    constructor(private _http: Http, private alertService: AlertService) { }

    autoComList: any[];

    getAutocompleteList<T>(source: string, filter: Filter[]): Observable<T[]> {
        return this._http.post(ConfigService.getApiUrl('autocomplete/' + source), JSON.stringify(filter), { headers: CommonService.getHeaders() })
            .map((response: Response) => <T[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
            //.do(data => { this.autoComList = data; });
    }

    getAutocompleteListForDimensioni<T>(source: string, clientId:number,searchText:string, filter: Filter[]): Observable<T[]> {
       console.log("filter",filter,"search Text:",searchText);
        return this._http.post(ConfigService.getApiUrl('autocomplete/' + source+'?ClientId='+clientId+'&SearchValue='+searchText), JSON.stringify(filter), { headers: CommonService.getHeaders() })
            .map((response: Response) => <T[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
            //.do(data => { this.autoComList = data; });
    }

    getAutocompleteListGenerate<T>(source: string, clientId:number,searchText:string, filter: Filter[]): Observable<T[]> {
       console.log("filter",filter,"search Text:",searchText);
        return this._http.post(ConfigService.getApiUrl('autocomplete/' + source+'?ClientId='+clientId+'&SearchValue='+searchText), JSON.stringify(filter), { headers: CommonService.getHeaders() })
            .map((response: Response) => <T[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
            //.do(data => { this.autoComList = data; });
    }


    getMultiSelectList(request: any): Observable<any> {
        return this._http.post(ConfigService.getApiUrl('ReportConfig/GetReportParameters'), request, { headers: CommonService.getHeaders() })
            .map((response: Response) => JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
            //.do(data => { this.autoComList = data; });
    }

    //api/ReportConfig/GetReportParameters

    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        return headers;
    }
}

