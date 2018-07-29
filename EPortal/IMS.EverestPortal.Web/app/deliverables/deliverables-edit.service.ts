import { Injectable } from "@angular/core";
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map'
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { Frequency } from './deliverables.model';
import { Period } from './deliverables.model';
import { Restriction } from './deliverables.model';
import { ReportWriter, PeriodForFrequency } from './deliverables.model';
import { ClientMarketDefDTO } from './deliverables.model';
import { ClientTerritoryDTO } from './deliverables.model';
import { ClientsDTO } from './deliverables.model';
import { DeliverablesDTO } from './deliverables.model'; 
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class DeliverableService {
    private actionUrl: string;
    private headers: Headers;
    private getapiUrl: string;
    private getsubapiUrl: string;

    constructor(private http: Http , private  alertService :AlertService) {
        this.actionUrl = ConfigService.baseWebApiUrl;
        this.getapiUrl = ConfigService.getApiUrl('ClientMarketBaseDetails?id=');
        this.getsubapiUrl = ConfigService.getApiUrl('GetClientSubscriptions?clientid=');
    }
    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        return headers;
    }

    getFrequencye(id: number, clientid: number) {
        var url = this.actionUrl + '/deliverables/getFrequncy/?id=' + id + '&clientid=' + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <Frequency[]>JSON.parse(response.json()));
    }
    getPeriod(id: number, clientid: number) {
        var url = this.actionUrl + '/deliverables/getPeriod/?id=' + id + '&clientid=' + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <Period[]>JSON.parse(response.json()));
    }
    getRestrictions(id: number, tid: string, clientid: number) {
        var url = this.actionUrl + '/deliverables/getRestrictions/?id=' + id + '&tid=' + tid + '&clientid=' + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <Restriction[]>JSON.parse(response.json()))
                .catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                });
    }
    getReportWriters(id: number, clientid: number) {
        var url = this.actionUrl + '/deliverables/getReportWriters/?id=' + id + '&clientid=' + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <ReportWriter[]>JSON.parse(response.json())
                )
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getPeriodForFrequency() {
        var url = this.actionUrl + '/deliverables/getPeriodForFrequency';
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <PeriodForFrequency[]>(response.json())
            )
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getMarketDefinition(id:number,delid:number) {
        var url = this.actionUrl + '/deliverables/getClientMarketDef/?clientid=' + id + '&delid=' + delid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <ClientMarketDefDTO[]>JSON.parse(response.json()))
                .catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                }
            );
    }
    getTerritories(id: number, delid: number) {

        var url = this.actionUrl + '/deliverables/GetClientTerritories/?clientid=' + id + '&delid=' + delid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <ClientTerritoryDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
    getDeliveryClients(id: number) {
        var url = this.actionUrl + '/deliverables/GetClients/?id=' + id;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <ClientsDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
    getDeliverablesById(id:number, clientid: number) {
        var url = this.actionUrl + '/deliverables/GetDeliverableByID/?id=' + id + '&clientid=' + clientid;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        return this.http.get(url,options)
            .map((response: Response) => <DeliverablesDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
   
    UpdateDeliverables(request: any): Observable<any> {
        var url = `${this.actionUrl}/deliverables/updateDeliverables`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                console.log('updatedeliverable- ' + res);
                return res.json() as any;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
    UpdateDeliveryLock(request: any): Observable<any> {
        var url = `${this.actionUrl}/deliverables/AddLock`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                console.log('update delivery lock- ' + res);
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
    RelaseDeliveryLock(request: any): Observable<any> {
        var url = `${this.actionUrl}/deliverables/ReleaseLock`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this.http.post(url, request, options)
            .map(function (res) {
                console.log('release delivery lock- ' + res);
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    SubmitDeliverables(DeleverableId: number, UserId: number) {
        var url = ConfigService.getApiUrl('deliverables/SubmitDeliverable/?DeliverableId=' + DeleverableId + '&UserId=' + UserId);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, '', options)
            .timeout(ConfigService.httpTimeout)
            .map((response: Response) => { })
            .do(data => console.log('Delivery History captured'));
    }
}