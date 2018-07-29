import { Injectable, EventEmitter } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/of';
import 'rxjs/add/operator/do';
import 'rxjs/add/operator/delay';

import { UserPermission } from '../../app/shared/model';
import { ConfigService } from '../config.service';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class AuthService {
    private actionUrl: string;
    private headers: Headers;
    usrPermissionList: UserPermission[] = [];
    usrPermission: Observable<UserPermission[]>;
    //userData = new UserPermission(); 

    userData: UserPermission[];
    canAllClientAccess: boolean = true;
    canMyClientAccess: boolean = true;
    isMyClientsSelected: boolean = true;
    canPackSearchAccess: boolean = true;
    canAllocationAccess: boolean = false;
    canReleaseAccess: boolean = false;
    //market
    selectedMarketModule:string;
    //subscription
    canSubAllClientAccess: boolean = true;
    canSubMyClientAccess: boolean = true;
    //Territory
    canTerAllClientAccess: boolean = true;
    canTerMyClientAccess: boolean = true;
    canAccessContentAdministration: boolean = false;
    canAccessUserManagement: boolean = false;
    //Reports
    canAccessAuditReports: boolean = false;
    canAccessReports: boolean = false;
    selectedTerritoryModule:string;
    SelectedClientID: number;
    isTimeout: boolean;
    hasUnSavedChanges: boolean;

    logoutChange: EventEmitter<boolean> = new EventEmitter<boolean>();
    

    constructor(private http: Http, private _cookieService: CookieService, private alertService: AlertService) {
        this.actionUrl = ConfigService.baseWebApiUrl;
    }

    private getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        return headers;
    }
    getInitialRoleAccess(sectionName: string, moduleName: string, roleID: Number) {
        var roleid: Number = 1;
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            roleid = usrObj.RoleID;
            let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
            var url = this.actionUrl + '/GetModulePermission/?section=' + sectionName + '&module=' + moduleName + '&roleid=' + roleid;
            //console.log(url);
            return this.http
                .get(url,options)
                .map((response: Response) => <UserPermission[]>JSON.parse(response.json()));

            //    this.usrPermission = ldata$;
        }
    }
    getViewData(sectionName: string, moduleName: string, action: string) {
        var roleid: Number = 1;
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            roleid = usrObj.RoleID;
            var modName = '';
            var url = this.actionUrl + '/GetActionPermission/?section=' + sectionName + '&module=' + modName + '&action=' + action + '&roleid=' + roleid;
            //console.log('url' + url);
            let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
            return (this.http.get(url,options)
                 .map((response: Response) => <UserPermission[]>JSON.parse(response.json())));
        }
    }
    CheckPermission(sectionName: string, moduleName: string, action: string) {
        var roleid: Number = 1;
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            roleid = usrObj.RoleID;
            //console.log(usrObj);
            //alert("RoleID:"+usrObj.RoleID);
            var url = this.actionUrl + '/GetActionPermission/?section=' + sectionName + '&module=' + moduleName + '&action=' + action + '&roleid=' + roleid;
            let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
            return (this.http.get(url,options)
                .map((response: Response) => <UserPermission[]>JSON.parse(response.json()))
                .catch((error) => {
                    this.alertService.exceptionAlert(error);
                    return Observable.throw("");
                }));
        }
        
        //var flag: boolean;
        ////console.log('section=' + sectionName + '&module=' + moduleName + '&action=' + action);
        //var res: boolean = false;
        //this.getViewData(sectionName, moduleName, action)
        //    .subscribe(data => {
        //        this.userData = data;
        //        res = this.checkViewAccess(sectionName, moduleName, action);
        //    });
        //return res;
    }


    CheckPermissionReturnPromise(sectionName: string, moduleName: string, action: string): Promise<any> {
        var roleid: Number = 1;
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            roleid = usrObj.RoleID;
            var url = this.actionUrl + '/GetActionPermission/?section=' + sectionName + '&module=' + moduleName + '&action=' + action + '&roleid=' + roleid;
            let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" });
            return this.http.get(url, options)
                .map((response: Response) => <UserPermission[]>JSON.parse(response.json())).toPromise()
                .catch((error) => {
                    //this.alertService.exceptionAlert(error);
                    //return Observable.throw("");
                });
        }
        else {
            return Promise.resolve(null);
        }
    }

    checkViewAccess(sectionName: string, moduleName: string, action: string): boolean {

        //console.log('inside view access' + this.userData.length);
        for (let it in this.userData) {
            if (this.userData != null && sectionName == this.userData[it].Section && moduleName == this.userData[it].ModuleName && action == this.userData[it].ActionName) {
                this.count = 1;
                //console.log("check view access -true")
                this.isLoggedIn = true;
                return true;
            }
            if (this.isLoggedIn == false) {
                //console.log("check view access -false")
                return false;
            }
        }
    }
    checkUserClientAccess( cid: number) {
        var uid: Number = 1;
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            uid = usrObj.UserID;
            
            var url = this.actionUrl + '/GetUserClients/?uid=' + uid + '&cid=' + cid;
            let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
            //console.log(url);
            return this.http
                .get(url,options)
                .map((response: Response) => <string[]>JSON.parse(response.json()));
        }
    }
    isLoggedIn: boolean = false;

    // store the URL so we can redirect after logging in
    redirectUrl: string;

    login(): Observable<boolean> {
        
        return Observable.of(true).delay(1000).do(val => this.isLoggedIn = true);
    }

    logout(): void {
        this.isLoggedIn = false;
    }
    count: Number = 0;
}
