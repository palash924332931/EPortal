import { CanDeactivate } from '@angular/router';
import { Observable } from 'rxjs/Observable';
import { Injectable } from '@angular/core';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { ClientService } from '../shared/services/client.service';
import { ConfigService } from '../config.service';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { CommonService } from '../shared/common';


export interface ComponentCanDeactivate {
    canDeactivate: () => boolean | Observable<boolean>;
}
@Injectable()
export class DeactivateGuard implements CanDeactivate<ComponentCanDeactivate> {
    public loginUserObj: any;
    constructor(private router: Router, private clientService: ClientService, private _http: Http, private _cookieService: CookieService, public route: ActivatedRoute) {
        this.loginUserObj = this._cookieService.getObject('CurrentUser');
    }
    async canDeactivate(component: ComponentCanDeactivate) {
        // if there are no pending changes, just allow deactivation; else confirm first
        var url = this.router.url.split('/')[1];
        let urlDecoded = decodeURIComponent(this.router.url);
        let lockType: string;
        let marketId: string;
        let territoryId:string;

        //to release lock       

        if (!component.canDeactivate()) {
            let returnConfirmationValue = confirm('WARNING: You have unsaved changes. Press Cancel to go back and save these changes, or OK to lose these changes.');
            //for market module
            if (url == 'marketCreate' && returnConfirmationValue == true) {
                if (urlDecoded.split('/').length > 2) {
                    lockType = urlDecoded.split('/')[3];
                    territoryId = urlDecoded.split('/')[2];
                }


                if (territoryId.indexOf('|') > 0) {
                    let defId = Number(territoryId.split("|")[1]);
                    this.clientService.fnSetLoadingAction(true);
                    try {
                        await this.fnReleaseLock(this.loginUserObj.UserID, defId, 'Territory Module', lockType, 'Release Lock').then(result => {this.clientService.fnSetLoadingAction(false); });
                    } catch (ex) {
                        this.clientService.fnSetLoadingAction(false);
                    }
                     this.clientService.fnSetLoadingAction(false);
                }
                //to release lock
                return true;

            } else if (url == 'territory-create' && returnConfirmationValue == true) {
                if (urlDecoded.split('/').length > 2) {
                    lockType = urlDecoded.split('/')[3];
                    marketId = urlDecoded.split('/')[2];
                }


                if (marketId.indexOf('|') > 0) {
                    let defId = Number(marketId.split("|")[1]);
                    this.clientService.fnSetLoadingAction(true);
                    try {
                        await this.fnReleaseLock(this.loginUserObj.UserID, defId, 'Market Module', lockType, 'Release Lock').then(result => {this.clientService.fnSetLoadingAction(false); });
                    } catch (ex) {
                        this.clientService.fnSetLoadingAction(false);
                    }
                     this.clientService.fnSetLoadingAction(false);
                }
                //to release lock
                return true;

            }
            else if (url == 'deliverablesedit' && returnConfirmationValue == true) {
                if (urlDecoded.split('/').length > 2) {
                    lockType = urlDecoded.split('/')[3];
                    marketId = urlDecoded.split('/')[2];
                }
                if (marketId.indexOf('|') > 0) {
                    let defId = Number(marketId.split("|")[1]);
                    this.clientService.fnSetLoadingAction(true);
                    try {
                        await this.fnReleaseLock(this.loginUserObj.UserID, defId, 'Delivery Module', lockType, 'Release Lock').then(result => { this.clientService.fnSetLoadingAction(false); });
                    } catch (ex) {
                        this.clientService.fnSetLoadingAction(false);
                    }
                    this.clientService.fnSetLoadingAction(false);
                }
                //to release lock
                return true;
            }
            else {
                return returnConfirmationValue;
            }
        }else{
            return true;
        }
        /* return component.canDeactivate() ?
             true :  confirm('WARNING: You have unsaved changes. Press Cancel to go back and save these changes, or OK to lose these changes.');*/

    }

    //to release lock
    async fnReleaseLock(UserId: number, DefId: number, DocType: string, LockType: string, Status: string): Promise<any[]> {
        var response: any;
        var url = ConfigService.getApiUrl('CommonLockHistories/?UserId=' + UserId + '&DefId=' + DefId + '&DocType=' + DocType + '&LockType=' + LockType + '&Status=' + Status);
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        await this._http.get(url,options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return JSON.parse(response.json());
    }
    //to lock user history
     async fnNewLock(UserId: number, DefId: number, DocType: string, LockType: string, Status: string): Promise<any[]> {
        var response: any;
        var url = ConfigService.getApiUrl('CommonLockHistories/?UserId=' + UserId + '&DefId=' + DefId + '&DocType=' + DocType + '&LockType=' + LockType + '&Status=Create Lock');
        let options = new RequestOptions({ headers: CommonService.getHeaders(), method: "get" }); 
        await this._http.get(url,options)
            .timeout(ConfigService.httpTimeout)
            .toPromise().then(result => response = result);
        return JSON.parse(response.json());
    }
}