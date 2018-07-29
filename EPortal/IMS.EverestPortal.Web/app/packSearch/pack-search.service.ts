import { Injectable } from "@angular/core";
import { Http, Response, Headers } from '@angular/http';
import 'rxjs/add/operator/map'
import 'rxjs/add/operator/timeout'
import { Observable } from 'rxjs/Observable';
import { PackSearch } from '../../app/shared/model';
import { SearchFilter, PackSearchFilter } from '../../app/shared/model';
import { ConfigService } from '../config.service';
import { PackSearchResult } from '../../app/shared/model'
import { PackResultResponse } from '../../app/shared/model'
import { PackDescResult } from '../../app/shared/model'
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class PackSearchService {
    private actionUrl: string;
    private headers: Headers;

    constructor(private http: Http, private alertService: AlertService) {
        this.actionUrl = ConfigService.baseWebApiUrl;

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
    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        return headers;
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
    getPackSearchResult(searchParam: PackSearchFilter): Observable<PackResultResponse> {
        let filter: SearchFilter[] = [];
        if (searchParam != null) {
            searchParam.ATC.forEach(a => { filter.push(a); });
            searchParam.NEC.forEach(a => { filter.push(a); });
            searchParam.Molecule.forEach(a => { filter.push(a); });
            searchParam.PackDescription.forEach(a => { filter.push(a); });
            searchParam.ProductDescription.forEach(a => { filter.push(a); });
            searchParam.Manufacturer.forEach(a => { filter.push(a); });
            filter.push(searchParam.Flagging);
            filter.push(searchParam.Branding);
            filter.push(searchParam.PFC);
            filter.push(searchParam.APN);
            filter.push(searchParam.Orderby);
            filter.push(searchParam.Start);
            filter.push(searchParam.Rows);
        }

        let ldata$ = this.http
            .post(`${this.actionUrl}/GetPacksSearchResult`, JSON.stringify(filter), { headers: CommonService.getHeaders() })
            //.timeout(10000)
            .map(function (res) {
                return JSON.parse(res.json());
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        // (response: Response) => <PackSearchResult[]>JSON.parse(response.json()));

        //let ldata$ = this.http
        //    .post(`${this.actionUrl}/GetPacksSearchResult`, JSON.stringify(searchParam), { headers: CommonService.getHeaders()})
        //    .map(mapList);
        return ldata$;
    }
    getPackDescResult(searchParam: SearchFilter[]): Observable<PackDescResult[]> {
        //  console.log('inside service method' + searchParam[0].Criteria + searchParam[0].Value ); 
        //let ldata$ = this.http
        //    .post(`${this.actionUrl}/GetPacksDescResult`, JSON.stringify(searchParam), { headers: CommonService.getHeaders() })
        //    .map(function (res) {
        //        console.log(res.json());
        //        return JSON.parse(res.json());
        //    });
        // (response: Response) => <PackSearchResult[]>JSON.parse(response.json()));

        let ldata$ = this.http
            .post(`${this.actionUrl}/GetPacksDescResult`, JSON.stringify(searchParam), { headers: CommonService.getHeaders() })
            .timeout(5000)
            .map(mapList)
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return ldata$;
    }
    private handleError(error: any) {
        let errorMsg = error.message
        return Observable.throw(errorMsg);
    }

  

    downloadExcel(opts: any): Observable<Object[]> {
        return Observable.create(observer => {

            var value = JSON.stringify(opts);
            // let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
            //console.log(options);
            var url = `${this.actionUrl}/export?options=` + encodeURIComponent(value);
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
                    } else {
                        observer.error(xhr.response);
                    }
                }
            }
            xhr.send();

        });
    }

    downloadExcel1(opts: any): void {
        var value = JSON.stringify(opts);
        var url = `${this.actionUrl}/export?options=` + value;
        window.location.href = url;
    }
}
function mapList(response: Response): PackDescResult[] {
    return response.json().map(toList);
}

function toList(r: PackDescResult): PackDescResult {

    let lObj = <PackDescResult>({
        PackDescription: r.PackDescription,
        Manufacturer: r.Manufacturer,
        ATC: r.ATC,
        NEC: r.NEC,
        Molecule: r.Molecule,
        Flagging: r.Flagging,
        Branding: r.Branding,
        ProductName: r.ProductName
    });

    return lObj;
}



function mapData(response: Response): PackSearch {
    return toList(response.json());
}

