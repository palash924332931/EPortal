import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Headers, RequestOptions } from '@angular/http';
//import 'rxjs/Rx';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
//import 'rxjs/add/operator/do';
import 'rxjs/add/operator/toPromise';
//import 'rxjs/add/observable/of';
//import 'rxjs/add/observable/fromPromise';
//import 'rxjs/add/observable/throw';


import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';

import {  User,Email,Password } from '../shared/model';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class LoginService {
    constructor(private _http: Http, private alertService: AlertService) { }

    private tokenUrl = ConfigService.WebApiTokenPath;
    private checkLoginUrl = ConfigService.getApiUrl('UserLogin');
    private userEmailUrl = ConfigService.getApiUrl('UserEmail');
    private userPasswordEmail = ConfigService.getApiUrl('SendPassword');
    private getuserPasswordUrl = ConfigService.getApiUrl('GetUserPassword');
    private changePasswordUrl = ConfigService.getApiUrl('ChangePassword');
    private sendPasswordResetUrl = ConfigService.getApiUrl('SendPasswordResetEmail');
    private getUsernameForResetTokenUrl = ConfigService.getApiUrl('GetUsernameForResetToken');
    private changePasswordByResetTokenUrl = ConfigService.getApiUrl('ChangePasswordByResetToken');
    private getMaintenanceDateUrl = ConfigService.getApiUrl('GetMaintenanceDate');

    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        
       // headers.append('Authorization', 'bearer '+'token');
        return headers;
    }
    getUserInfo(userName: string, pwd: string): Promise<User[]> {
       // var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });

        //console.log('options:', options);
        return this._http.get(this.checkLoginUrl + '?userName=' + encodeURIComponent(userName) + '&pwd=' + encodeURIComponent(pwd), options)
            .map((response: Response) => <User[]>JSON.parse(response.json())).toPromise()
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                this.handleError;
                return Observable.throw("");
            });
    }
    
    getToken(userName: string, pwd: string): Promise<any>  {
        let header = new Headers();
        header.set("Access-Control-Allow-Origin", "*");
        header.append('Content-Type', 'application/x-wwww-form-urlencoded');

        let options = new RequestOptions({ headers: header, method: "post" });

        var body = 'grant_type=password&username=' + encodeURIComponent(userName) + '&password=' + encodeURIComponent(pwd);
        return this._http.post(this.tokenUrl, body, options)
            .map((response: Response) => response).toPromise()
            .catch((error) => {
                let message = "Login failed.";
                if (error != null && error._body != null) {
                    if (typeof (error._body) == "string" && error._body.indexOf("error_descriptio") != -1) {
                        message = error._body.substring(error._body.lastIndexOf("error_descriptio") + 20, error._body.indexOf("}") - 1);
                        error = { "_body": message };
                    }
                }
                this.alertService.exceptionAlert(error);
                this.handleError;
                return Observable.throw("");
            });
    }

    getUserEmail(userName: string): Promise<Email[]> {
        return this._http.get(this.userEmailUrl + '?userName=' + userName)
            .map((response: Response) => <Email[]>JSON.parse(response.json())).toPromise();
    }
    //getPassword(userID: number): Promise<Password[]> {
    //    return this._http.get(this.getuserPasswordUrl + '?userID=' + userID.toString())
    //        .map((response: Response) => <Password[]>JSON.parse(response.json())).toPromise();
    //}
    updatePassword(userID: number, oldPwd: string, newPwd: string): any {
        var request = {
            UserID: userID,
            OldPassword: oldPwd,
            Password: newPwd
        };
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(this.changePasswordUrl, request, options)
            .map(function (res) {
                return res.json() as any;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }
    sendPassword(userName: string): any {
        //alert(this.userEmailUrl + '?userName=' + userName);
        //var headers = new Headers({ 'Content-Type': 'application/json' });
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" }); 
        return this._http.post(this.userPasswordEmail + '?userName=' + userName, options)
            .toPromise();
    }

    getUsernameForResetToken(token: any): Observable<any> {
        var url = this.getUsernameForResetTokenUrl + `?ResetToken=${token}`;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http
            .get(url, options)
            .map(function (res) {
                return res.json() as any;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    SendPasswordResetEmail(userName: string): any {
        var request = {
            UserName: userName
        };
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "post" });
        return this._http.post(this.sendPasswordResetUrl, request, options)
            .map(function (res) {
                return res.json() as any;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    changePasswordByResetToken(token: string, password: string): Observable<any> {
        var request = {
            Token: token,
            Password: password
        };
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "put" });
        return this._http.post(this.changePasswordByResetTokenUrl, request, options)
            .map(function (res) {
                return res.json() as any;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    getMaintenanceDate(): Observable<string> {
        var url = this.getMaintenanceDateUrl;
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
        return this._http
            .get(url, options)
            .map(function (res) {
                return res.json() as string;
            })
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
    }

    private handleError(error: Response | any) {
        let errMsg: string;
       // alert('error');
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
