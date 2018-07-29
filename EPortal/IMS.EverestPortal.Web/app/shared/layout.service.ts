import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions, ResponseContentType} from '@angular/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
//import 'rxjs/add/operator/do';
import { IFile } from './file.interface';
import { Summary, PopularLinks, CADPages, Listings, MonthlyNewProduct, NewsAlert, HomeContent, HomeFile } from './model';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class LayoutService {
    constructor(private _http: Http, private alertService: AlertService) { }

    //summaries: Summary[];

    private monthlyDataUrl = ConfigService.getApiUrl('MonthlyDataSummary/Get');
    private newsAlertUrl = ConfigService.getApiUrl('NewsAlerts/Get');
    private cadPagesUrl = ConfigService.getApiUrl('CADPages/Get');
    private listingsUrl = ConfigService.getApiUrl('Listings/Get');
    private monthlyNewProductsUrl = ConfigService.getApiUrl('MonthlyNewProducts/Get');
    private popularLinksUrl = ConfigService.getApiUrl('PopularLinks/Get/');
    private landingPageContentUrl = ConfigService.getApiUrl('GetLandingPageContent');
    private landingPageFileUrl = ConfigService.getApiUrl('GetLandingPageFiles');
    private downloadFileUrl = ConfigService.getApiUrl('GetFileFromServer');

    filelistUrl: string;

    getMonthlyDataSummaries(): Observable<Summary[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.monthlyDataUrl, options)
           // .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getMonthlyDataSummaries')))
            .map((response: Response) => <Summary[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    async getAllFiles(): Promise<HomeFile[]> {
        //return this._http.get(this.landingPageFileUrl)
        //    .map((response: Response) => <HomeFile[]>JSON.parse(response.json())).toPromise();
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        var response: HomeFile[];
        await this._http.get(this.landingPageFileUrl, options)
            //.timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getAllFiles')))
            .toPromise().then(result => response = <HomeFile[]>JSON.parse(result.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response;

    }
    getFiles(): Observable<IFile[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.filelistUrl, options)
           // .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getFiles')))
            .map((response: Response) => <IFile[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });

    }
    getFileFromBackend(fileName: string, newsFlag:string): Promise<any> {
        return this._http.get(this.downloadFileUrl + '?fileName=' + fileName + '&newsFlag=' + newsFlag, { headers: CommonService.getHeaders(), responseType: ResponseContentType.ArrayBuffer })
            .map(res => res).toPromise();
        //.do(data => console.log('downloadfile: ' + JSON.stringify(data)));
        // .catch((error: any) => Observable.throw(error || 'Server error'));
    } 
    async getFilesPromise(): Promise<IFile[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        var response: IFile[];
        await this._http.get(this.filelistUrl, options)
            // .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getFilesPromise')))
            .toPromise().then(result => response = <IFile[]>JSON.parse(result.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response;
    }
   
    async getPopularLinks(): Promise<PopularLinks[]> {
        var response: PopularLinks[];
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(this.popularLinksUrl, options)
          //  .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getPopularLinks')))
            .toPromise().then(result => response = <PopularLinks[]>JSON.parse(result.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response;
    }
    getNewsAlerts(newsType: string): Observable<NewsAlert[]> {
        let surl = this.newsAlertUrl + "?newsType=" + newsType;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(surl, options)
          //  .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getNewsAlerts')))
            .map((response: Response) => <NewsAlert[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    async getLandingPageContents(): Promise<HomeContent[]> {
        var response: HomeContent[];
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        await this._http.get(this.landingPageContentUrl, options)
          //  .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getLandingPageContents')))
            .toPromise().then(result => response = <HomeContent[]>JSON.parse(result.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        return response;
    }

    getCADPages(): Observable<CADPages[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http.get(this.cadPagesUrl, options)
            //.timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getCADPages')))
            .map((response: Response) => <CADPages[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('cadpages: ' + JSON.stringify(data)));
    }

    getListings(): Observable<Listings[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        //return this.http.get(this.monthlyDataUrl).forEach(this.extractData).catch(this.handleError);
        return this._http.get(this.listingsUrl, options)
           // .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getListings')))
            .map((response: Response) => <Listings[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        // .do(data => console.log('listings: ' + JSON.stringify(data)));
    }

    getMonthlyNewProducts(): Observable<MonthlyNewProduct[]> {
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        
        return this._http.get(this.monthlyNewProductsUrl, options)
           // .timeout(ConfigService.httpTimeout, new Error(ConfigService.getErrorMessage('getMonthlyNewProducts')))
            .map((response: Response) => <MonthlyNewProduct[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        //.do(data => console.log('MonthlyNewProduct: ' + JSON.stringify(data)));
    }

    private extractData(res: Response) {
        let body = res.json();
        //console.log('in extraction');
        //console.dir(body);
        //return <Summary[]>body;
        //this.summaries = <Summary[]>body;
    }

    private handleError(error: Response | any) {
        // In a real world app, we might use a remote logging infrastructure
        //let errMsg: string;
        //if (error instanceof Response) {
        //    const body = error.json() || '';
        //    const err = body.error || JSON.stringify(body);
        //    errMsg = `${error.status} - ${error.statusText || ''} ${err}`;
        //} else {
        //    errMsg = error.message ? error.message : error.toString();
        //}
        //console.error(errMsg);
        //return Observable.throw(errMsg);
    }

}
