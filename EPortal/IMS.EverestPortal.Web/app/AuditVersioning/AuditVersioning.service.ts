import { Injectable } from "@angular/core";
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map'
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';
import { SubscriptionReportDTO } from './AuditVersioning.model';
import { SubscriptionPeriodChangeDTO } from './AuditVersioning.model';
import { SubscriptionMktBaseNamEChangeDTO } from './AuditVersioning.model';
import { clientDTO, NameDTO, DeliverablenNameDTO, VersionDTO, DeliverableVersionDTO } from './AuditVersioning.model';


@Injectable()
export class AuditVersionService {

    private actionUrl: string;
    private headers: Headers;
    private getapiUrl: string;
    private getsubapiUrl: string;

    constructor(private http: Http, private alertService: AlertService) {
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


    getSubscriptionReportById(id: number, startversion: number, endversion: number, reportname: string) {
        var url = this.actionUrl + '/Audit/SubscriptionReport/Get/?id=' + id + '&startversion=' + startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        //alert(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <SubscriptionReportDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }


    getAllClients() {
        console.log('component - get clients');
        var url = this.actionUrl + '/Audit/Clients/Get';
        //+ id + '&startversion=' + startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <clientDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }


    getSubscriptionNames(clntID: number) {
        console.log('Client ID = ' + clntID);
        var url = this.actionUrl + '/Audit/Subscriptions/GetByClientID?clientID= ' + clntID;
        //+ startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    getDeliverableNames(clntID: number) {
        var url = this.actionUrl + '/Audit/Deliverables/GetByClientID?clientID= ' + clntID;
        //+ startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }


    getUsers() {
        var url = this.actionUrl + '/Audit/users';
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    getTdwClients() {
        var url = this.actionUrl + '/Audit/tdwclients';
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    getSubscriptionVersions(clntID: number, SubscriptionId: number, startDate: string, endDate: string) {
        //alert(startDate);
        var url = this.actionUrl + '/Audit/Subscription/GetVersions?clientID= ' + clntID + '&SubscriptionId=' + SubscriptionId + '&startDate=' + startDate + '&endDate=' + endDate;
        //  alert(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <VersionDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    getDeliverableVersions(clntID: number, DeliverableId: number, startDate: string, endDate: string) {
        var url = this.actionUrl + '/Audit/Deliverables/GetVersions?clientID= ' + clntID + '&DeliverableId=' + DeliverableId + '&startDate=' + startDate + '&endDate=' + endDate;
        //alert(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <VersionDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
    getVersions(sectionName: string, clntID: number, defId: number, startDate: string, endDate: string) {
        let url: string;
        if (sectionName == 'Deliverables') {
            url = this.actionUrl + '/Audit/Deliverables/GetVersions?clientID= ' + clntID + '&DeliverableId=' + defId + '&startDate=' + startDate + '&endDate=' + endDate;
        } else if (sectionName == 'Market Base') {
            url = this.actionUrl + '/Audit/Marketbase/GetVersions?clientID= ' + clntID + '&marketbaseId=' + defId + '&startDate=' + startDate + '&endDate=' + endDate;
        } else if (sectionName == 'Markets') {
            url = this.actionUrl + '/Audit/Markets/GetVersions?clientID= ' + clntID + '&defId=' + defId + '&startDate=' + startDate + '&endDate=' + endDate;
        }
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <VersionDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    getAuditReport(SectionName: string, EntityID: number, startVersion: number, endVersion: number, reportname: string) {
        var url = this.actionUrl + '/Audit/' + this.getSectionPathName(SectionName) + '/Get?Id= ' + EntityID + '&startVersion=' + startVersion + '&endVersion=' + endVersion + '&reportname=' + reportname;
        //alert(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <any[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }

            );

    }

    private getSectionPathName(SectionName: string) {
        if (SectionName == "Subscription") {
            return 'SubscriptionReport';
        }
        else if (SectionName == "Deliverables") {
            return 'DeliverablesReport';
        }
        else if (SectionName == "Territories") {
            return 'TerritoryReport';
        }else if (SectionName == "Market Base") {
            return 'MarketbaseReport';
        }else if (SectionName == "Markets") {
            return 'MarketDefinitionReport';
        }
    }


    getTerritoryNames(clntID: number) {
        console.log('Client ID = ' + clntID);
        var url = this.actionUrl + '/Audit/Territory/GetByClientID?clientID= ' + clntID;
        //+ startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }
    getMarketbaseVersions(clntID: number, marketbaseId: number, startDate: string, endDate: string) {
        var url = this.actionUrl + '/Audit/Marketbase/GetVersions?clientID= ' + clntID + '&marketbaseId=' + marketbaseId + '&startDate=' + startDate + '&endDate=' + endDate;
        //alert(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <VersionDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }

    getTerritoryVersions(clntID: number, TerritoryId: number, startDate: string, endDate: string ) {
        var url = this.actionUrl + '/Audit/Territory/GetVersions?clientID= ' + clntID + '&TerritoryId=' + TerritoryId + '&startDate=' + startDate + '&endDate=' + endDate;
        //alert(url);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <VersionDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
            );
    }


    //Gets the User Audit versions reports
    GetUserAudit(userId: number, startDate: any, endDate: any, userName: string): Observable<any[]> {
        var request = {
            userId: userId,
            startDate: startDate,
            endDate: endDate,
            username: userName
        }
        var url = `${this.actionUrl}/Audit/users`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
   
    //Gets the User Audit versions reports
    GetTdwAudit(clientId: number, startDate: any, endDate: any, userName: string): Observable<any[]> {
        var request = {
            clientId: clientId,
            startDate: startDate,
            endDate: endDate
        }
        var url = `${this.actionUrl}/Audit/tdwexport`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this.http.post(url, request, options)
            .map(function (res) {
                return res.json() as any;
            }).catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }


    getMarketbaseNames(clntID: number) {
        console.log('Client ID = ' + clntID);
        var url = this.actionUrl + '/Audit/Marketbase/GetMarketbaseNames?clientID= ' + clntID;
        //+ startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
          );
    }

    getMarketDefinitionNames(clntID: number) {
        console.log('Client ID = ' + clntID);
        var url = this.actionUrl + '/Audit/Markets/GetMarketDefinitionNames?clientID= ' + clntID;
        //+ startversion + '&endversion=' + endversion + '&reportname=' + reportname;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this.http.get(url, options)
            .map((response: Response) => <NameDTO[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            }
          );
    }
}