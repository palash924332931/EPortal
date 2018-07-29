import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../../config.service';
import { CommonService } from '../../shared/common';
import { EntityType } from '../../deliverables/deliverables.model';

@Injectable()
export class MasterDataService {

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
        var url = `${this.actionUrl}/masterData/GetDataTypes`;
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
        var url = `${this.actionUrl}/masterData/GetSources`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetCountries(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetCountries`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }


    GetServices(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetServices`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetTerritoryBases(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetTerritoryBases`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetDeliveryTypes(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetDeliveryTypes`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetFrequencyTypes(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetFrequencyTypes`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetFrequencies(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetFrequencies`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    

    GetPeriods(): Observable<any> {
        var url = `${this.actionUrl}/masterData/GetPeriods`;
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

    GetRestriction(): Observable<any> {
        var url = `${this.actionUrl}/admin/GetRestriction`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            });
    }
        
    //update the country 
    UpdateCountry(request: any): Observable<any> {
        var url = `${this.actionUrl}/country/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //update the service
    UpdateService(request: any): Observable<any> {
        var url = `${this.actionUrl}/service/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //update the territory Base
    UpdateTerritoryBase(request: any): Observable<any> {
        var url = `${this.actionUrl}/territoryBase/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //update the territory Base
    UpdateDataType(request: any): Observable<any> {
        var url = `${this.actionUrl}/datatype/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //update the territory Base
    UpdateSource(request: any): Observable<any> {
        var url = `${this.actionUrl}/source/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //update the delivery type
    UpdateDeliveryType(request: any): Observable<any> {
        var url = `${this.actionUrl}/deliverytype/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    //update the period
    UpdatePeriod(request: any): Observable<any> {
        var url = `${this.actionUrl}/period/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    UpdateFrequencyType(request: any): Observable<any> {
        var url = `${this.actionUrl}/frequencytype/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    UpdateFrequency(request: any): Observable<any> {
        var url = `${this.actionUrl}/frequency/update`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            });
    }

    getEntityTypes(): Observable<EntityType[]> {
        var url = `${this.actionUrl}/masterData/GetEntityTypes`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http
            .get(url, options)
            .map(function (res) {
                return res.json() as EntityType[];
            });
    }

    saveSubchannel(entityType: EntityType): Observable<boolean> {
        var url = `${this.actionUrl}/masterData/SaveSubchannel`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, entityType, options)
            .map(function (res) {
                return res.json() as boolean;
            });
    }

    deleteSubchannel(entityTypeId: number): Observable<boolean> {
        var url = `${this.actionUrl}/masterData/DeleteSubchannel?entityTypeId=` + entityTypeId;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, {}, options)
            .map(function (res) {
                return res.json() as boolean;
            });
    }
    
}