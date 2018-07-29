/// <reference path="../globals.ts" />
import { Injectable } from '@angular/core'
import { Observable } from 'rxjs/Observable';
import { ConfigService } from '../config.service';
import { Http, Response, Headers, RequestOptions, ResponseContentType, BrowserXhr } from '@angular/http';
import { CommonService } from '../shared/common';
//import * as myGlobals from './globals';






//import * as FileSaver from 'file-saver';
@Injectable()
export class ReportFilterService {

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

    CreateFilter(request: any): Observable<any> {
        var url = `${this.actionUrl}/ReportFilter/CreateCustomFilter`;
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    EditCustomFilter(request: any): Observable<any> {
        var url = `${this.actionUrl}/ReportFilter/EditCustomFilter`;
        //console.log(url);
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res)
            });
    }

    GetReports(request: any): Observable<any> {
        var url = `${this.actionUrl}/ReportView/GetReportView`;
        //console.log(url);
        return this.http.post(url, request, { headers: CommonService.getHeaders()})
            .map(function (res) {
                return res.json() as any;
            });
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


    downloadReport(opts: any): Observable<Object[]> {
        try {
            return Observable.create(observer => {

                var value = JSON.stringify(opts);
                // let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
                //console.log(options);
                var url = `${this.actionUrl}/ReportView/Export?options=` + value;
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
                          //  alert(xhr.statusText);

                            observer.error(xhr.response);

                            //throw new Error(xhr.responseText);
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
    downloadReport1(opts: any): Observable <any> {
        var value = JSON.stringify(opts);
       // let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        //console.log(options);
        var url = `${this.actionUrl}/ReportView/Export?options=` + value;
        //window.location.href = url;
        //console.log(url);



















        let headers = this.getxlHeaders();
      //  headers.append('Accept', 'application/ vnd.openxmlformats - officedocument.spreadsheetml.sheet');
        headers.append('Content-Type', 'application/json');
        headers.append('responseType', 'blob');

        return this.http.post(url, value, { headers: headers })
            .map(response => {
                if (response.status == 400) {
                    this.handleError;
                } else if (response.status == 200) {
                    var contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                    var blob = new Blob([(<any>response)._body], { type: contentType });            // size is 89KB instead of 52KB
                    //                    var blob = new Blob([(<any>response).arrayBuffer()], { type: contentType });  // size is 98KB instead of 52KB
                    //                    var blob = new Blob([(<any>response).blob()], { type: contentType });         // received Error: The request body isn't either a blob or an array buffer
                    return blob;
                }
            })
            .catch(this.handleError);

     
    }

    private handleError(error: Response | any) {
        let errMsg: string;

        const body = error.json() || '';
        const err = body.error || JSON.stringify(body);
        errMsg = `${error.status} - ${error.statusText || ''} ${err}`;

        alert(errMsg);
        if (error instanceof Response) {
            const body = error.json() || '';
            const err = body.error || JSON.stringify(body);
            errMsg = `${error.status} - ${error.statusText || ''} ${err}`;
        } else {
            errMsg = error.message ? error.message : error.toString();
        }
        console.error(errMsg);
        return Observable.throw(errMsg);
    }

    DeleteCustomFilter(filterId: any): Observable<any> {
        let request = { FilterID: filterId}
        var url = `${this.actionUrl}/ReportFilter/Delete`;
        //console.log(url);
        return this.http.post(url, request, { headers: CommonService.getHeaders() })
            .map(function (res) {
                //console.log(res)
            });
    }


    GetFilters(moduleId: any, userId: any): Observable<any> {
        var url = `${this.actionUrl}/ReportFilter/GetFiltersByModule?ModuleID=${moduleId}&userID=${userId}`;
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetFilterById(Id: number): Observable<any> {
        var url = `${this.actionUrl}/ReportFilter/Get?Id=${Id}`;
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetFieldsByModule(moduleId: any, userId: any): Observable<any> {
        var url = `${this.actionUrl}/ReportFilter/GetReportFieldsByModule?ModuleID=${moduleId}&userId=${userId}`;
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

    GetSection(userTypeId: number): Observable<any> {
        var url = `${this.actionUrl}/ReportFilter/GetReportSection?id=${userTypeId}`;
        return this.http
            .get(url, { headers: CommonService.getHeaders() })
            .map(function (res) {
                return res.json() as any;
            });
    }

}