import { Injectable } from '@angular/core';
import {
    CanActivate, Router,
    ActivatedRouteSnapshot,
    RouterStateSnapshot,
    CanActivateChild,
    NavigationExtras,
    CanLoad, Route
} from '@angular/router';
import { AuthService } from './auth.service';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { UserPermission } from '../shared/model';


@Injectable()
export class AuthGuard implements CanActivate, CanActivateChild, CanLoad {
    model: any = {};
    hasView: boolean = false;
    canAccessAllClient: boolean = false;
    canAccessMyClient: boolean = false;
    canAccessAllocaton: boolean = false;
    canAccessAdmin: boolean = false;

    constructor(private authService: AuthService, private router: Router, private _cookieService: CookieService, ) {

    }

    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> {
        return this.authService.CheckPermissionReturnPromise('', '', 'Use global navigation toolbar')
            .then(
            (data: any) => {
                if (data != null) {
                    this.checkPermission(data);

                    let curPath = route.data["pack"] as boolean;
                    let curPathAllocation = route.data["allocation"] as boolean;
                    let curPathSubscription = route.data["subscription"] as boolean;
                    let curPathTerritory = route.data["territory"] as boolean;
                    let curAdmin = route.data["admin"] as boolean;
                    let group = route.data["group"] as boolean;
                    let curPathReport = route.data["report"] as boolean;
                    var usrObj: any = this._cookieService.getObject('CurrentUser');


                    if (group) {
                        return true;
                    }
                    if (state.url == "/importData" || state.url == "/subscriptionAndDeliverablesCreate") {
                        if (usrObj.RoleID == 4) {
                            return true;
                        }
                        return false;
                    }

                    if (state.url == "/masterData"){
                        if (usrObj.RoleID == 4 || usrObj.RoleID == 5 || usrObj.RoleID == 7) {
                            return true;
                        }
                        return false;
                    }

                    //console.log('can activate' + curPath);
                    if (curPath == true) {
                        return this.authService.canPackSearchAccess;
                    }
                    else if (curPathAllocation == true) {
                        return this.authService.canAllocationAccess;
                    }
                    else if (curPathSubscription == true) {
                        if (state.url.toString().substr(1, 21) == 'subscriptionAllClient')
                            return this.authService.canSubAllClientAccess;
                        else
                            return this.authService.canSubMyClientAccess;
                    }
                    else if (curPathTerritory == true) {
                        if (state.url.toString().substr(1, 18) == 'territoryAllClient')
                            return this.authService.canTerAllClientAccess;
                        else {
                            if (this.authService.canTerMyClientAccess) {
                                return this.authService.canTerMyClientAccess;
                            } else {
                                return this.authService.canTerAllClientAccess;
                            }
                        }

                    }
                    else if (curAdmin == true) {


                        if (usrObj) {
                            var roleid: Number = usrObj.RoleID;
                            //  alert('check admin:' + roleid.toString());
                            if (usrObj.RoleID == 5 || usrObj.RoleID == 4 || usrObj.RoleID == 7)
                                return true;
                            else return false;
                        }
                    }
                    else if (curPathReport == true)
                    {
                        if (usrObj) {
                            var roleid: Number = usrObj.RoleID;
                            if (usrObj.RoleID == 1 || usrObj.RoleID == 2 || usrObj.RoleID == 3 || usrObj.RoleID == 5 || usrObj.RoleID == 4 || usrObj.RoleID == 7 || usrObj.RoleID == 8)
                                return true;
                            else return false;
                        }
                    }
                    else if (state.url == "/" && usrObj.RoleID == 8) {
                        this.router.navigateByUrl('/territories/myterritories');
                    }
                    else if (state.url == "/" && usrObj.RoleID == 9) {
                        return true;
                    }
                    else {
                        if (state.url.toString().substr(1, 15) == 'marketAllClient')
                            return this.authService.canAllClientAccess;
                        else
                            return this.authService.canMyClientAccess;
                    }
                }
                else {
                    let url = `/${route.url}`;
                    if (url != "/") {
                        this.router.navigateByUrl('/');
                    }
                    return true;
                }
            },
            (err: any) => {
                console.log(err)
            });
    }

    private checkPermission(data: UserPermission[]) {
        this.authService.canAllClientAccess = false;
        this.authService.canMyClientAccess = false;
        this.authService.canAllocationAccess = false;
        this.authService.canReleaseAccess = false;

        this.authService.canSubAllClientAccess = false;
        this.authService.canSubMyClientAccess = false;

        this.authService.canTerAllClientAccess = false;
        this.authService.canTerMyClientAccess = false;
        this.authService.canAccessContentAdministration = false;
        this.authService.canAccessUserManagement = false;

        if (data && data.length > 0) {
            this.authService.canAllocationAccess = false;
            for (let it in data) {
                if (data[it].Section == "Market" && data[it].ModuleName == 'All Clients') {
                    this.authService.canAllClientAccess = true;
                }

                if (data[it].Section == "Market" && data[it].ModuleName == 'My Clients') {
                    this.authService.canMyClientAccess = true;
                }

                if (data[it].Section == "Market" && data[it].ModuleName == 'Pack Search') {
                    this.authService.canPackSearchAccess = true;
                }

                if (data[it].Section == "Subscription" && data[it].ModuleName == 'Allocation') {
                    this.authService.canAllocationAccess = true;
                }

                if (data[it].Section == "Subscription" && data[it].ModuleName == 'Release') {
                    this.authService.canReleaseAccess = true;
                }

                if (data[it].Section == "Subscription" && data[it].ModuleName == 'All Clients') {
                    this.authService.canSubAllClientAccess = true;
                }

                if (data[it].Section == "Subscription" && data[it].ModuleName == 'My Clients') {
                    this.authService.canSubMyClientAccess = true;
                }

                if (data[it].Section == "Territory" && data[it].ModuleName == 'All Clients') {
                    this.authService.canTerAllClientAccess = true;
                }

                if (data[it].Section == "Territory" && data[it].ModuleName == 'My Clients') {
                    this.authService.canTerMyClientAccess = true;
                }

                if (data[it].Section == "Admin" && data[it].ModuleName == 'User management') {
                    this.authService.canAccessUserManagement = true;
                }

                if (data[it].Section == "Admin" && data[it].ModuleName == 'Content Administration') {
                    this.authService.canAccessContentAdministration = true;
                }

                if (data[it].Section == "System Reporting" && data[it].ModuleName == 'Audit Reports') {
                    this.authService.canAccessAuditReports = true;
                }

                if (data[it].Section == "System Reporting" && data[it].ModuleName == 'Reports') {
                    this.authService.canAccessReports = true;
                }
            }
        }
    }


    canActivateChild(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> {
        return this.canActivate(route, state);
    }

    canLoad(route: Route): boolean {
        let url = `/${route.path}`;

        return this.checkLogin(url);
    }
    canView(route: Route): boolean {
        //  let url = `/${route.path}`;

        return true;


    }

    checkLogin(url: string): boolean {

        if (this.authService.isLoggedIn) { return true; }

        // Store the attempted URL for redirecting
        //this.authService.redirectUrl = url;



        // Navigate to the login page with extras
        return false;
    }
}
