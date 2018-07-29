import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Headers, RequestOptions } from '@angular/http';
//import 'rxjs/Rx';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
//import 'rxjs/add/operator/do';
import 'rxjs/add/operator/toPromise';
import { ConfigService } from '../../config.service';
import { CommonService } from '../../shared/common';

import { IFile } from '../../shared/file.interface';
import { Summary, PopularLinks, CADPages, Listings, MonthlyNewProduct, NewsAlert, Email } from '../../shared/model';

@Injectable()
export class AdminService {
    constructor(private _http: Http) { }

    private monthlyDataUrl = ConfigService.getApiUrl('MonthlyDataSummary/Get');
    private newsAlertUrl = ConfigService.getApiUrl('NewsAlerts/Get');
    private cadPagesUrl = ConfigService.getApiUrl('CADPages/Get');
    private listingsUrl = ConfigService.getApiUrl('Listings/Get');
    private monthlyNewProductsUrl = ConfigService.getApiUrl('MonthlyNewProducts/Get');
    private popularLinksUrl = ConfigService.getApiUrl('PopularLinks/Get/');

    private popularLinksGetUrl = ConfigService.getApiUrl('PopularLinks/Get/');
    private popularLinksAddUrl = ConfigService.getApiUrl('PopularLinks/Add/');
    private popularLinksUpdateUrl = ConfigService.getApiUrl('PopularLinks/Update/');
    private popularLinksDeleteUrl = ConfigService.getApiUrl('PopularLink/Delete?Id=');
    private summaryAddUrl = ConfigService.getApiUrl('MonthlyDataSummary/Update'); //+ 'values'; //'MonthlyDataSummary/Add';
    private listingsUpdateUrl = ConfigService.getApiUrl('Listings/Update');
    private monthlyNewProductsUpdateUrl = ConfigService.getApiUrl('MonthlyNewProducts/Update');
    private cadPagesUpdateUrl = ConfigService.getApiUrl('CADPages/Update');
    private newsUpdateUrl = ConfigService.getApiUrl('NewsAlerts/Update');
    private getEmailListUrl = ConfigService.getApiUrl('GetEmails');
    private sendEmailListUrl = ConfigService.getApiUrl('Broadcast');
    private fileuploadUrl = ConfigService.getApiUrl('UploadFile');

    private title = "Home Content Administration";
    private popularLinksEditMode = false;

    filelistUrl: string;

    getEmails(): Observable<Email[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });

        return this._http.get(this.getEmailListUrl, options)
            .map((response: Response) => <Email[]>JSON.parse(response.json()))
            .do(data => console.log('Email: ' + JSON.stringify(data)));
    }
    saveSummary(summary: Summary): any {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });

        return this._http.put(this.summaryAddUrl, JSON.stringify(summary), options)
            .map((response: Response) => this.extractRes(response)).toPromise();
    }

    saveListings(listing: Listings): any {
        //var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });
        return this._http.put(this.listingsUpdateUrl, JSON.stringify(listing), options)
            .map((response: Response) => this.extractRes(response)).toPromise();
    }
    saveNewProds(newProducts: MonthlyNewProduct): any {
        // var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });
        return this._http.put(this.monthlyNewProductsUpdateUrl, JSON.stringify(newProducts), options)
            .map((response: Response) => this.extractRes(response)).toPromise();
    }
    saveCADs(cadPages: CADPages): any {
        //var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });
        return this._http.put(this.cadPagesUpdateUrl, JSON.stringify(cadPages), options)
            .map((response: Response) => this.extractRes(response)).toPromise();
    }
    addLink(link: PopularLinks): any {
        // var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(this.popularLinksAddUrl, JSON.stringify(link), options)
            .map((response: Response) => this.extractRes(response))
            .toPromise();
    }
    deleteLink(id: number): any {
        //var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "delete" });
        return this._http.delete(this.popularLinksDeleteUrl + id, options)
            .toPromise();
    }
    updateLink(link: PopularLinks): any {
        // var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });
        return this._http.put(this.popularLinksUpdateUrl, JSON.stringify(link), options)
            .map((response: Response) => this.extractRes(response)).toPromise();
    }
    updateNewsAlert(news: NewsAlert): any {
        // var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });
        return this._http.put(this.newsUpdateUrl, JSON.stringify(news), options)
            .map((response: Response) => this.extractRes(response)).toPromise();
    }
    sendEmail(contentType: string, link: string, fileName: string, contentDesc: string): any {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        var req = { "contentType": contentType, "link": link, "fileName": fileName, "contentDesc": contentDesc };  
        var s=JSON.stringify(req);
     
        return this._http.post(this.sendEmailListUrl, s,  options)
            .map((response: Response) => this.extractRes(response))
            .toPromise();
    }

    uploadAFile(file: File, fileName: string, fileType: string): string {
            let formData: FormData = new FormData();
            formData.append('uploadFile', file, fileName);
            let options = new RequestOptions({ headers: CommonService.getHeadersForFileUpload(), method: "post" });
            this._http.post(this.fileuploadUrl + "?fileType=" + fileType, formData, options)
                .map(res => res.json())
                .catch(error => Observable.throw(error))
                .subscribe(
                data => {
                    console.log('success')
                },
                error => console.log(error)
                )
            return "Completed";
    }
    private extractRes(res: Response): any {
        //let body = res.json();
        //return body.fields || { };
    }

    private extractData(res: Response) {
        // let body = res.json();
        //  console.log('in extraction');
        //  console.dir(body);
    }


    private handleError(error: Response | any) {
        let errMsg: string;
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

}
