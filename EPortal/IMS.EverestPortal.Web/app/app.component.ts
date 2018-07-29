import { Component, OnInit, ViewChild } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { loginComponent } from './login/login.component';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { AuthService } from './security/auth.service';
import { UserPermission, Password } from './shared/model';
import { ModalDirective } from 'ng2-bootstrap';
import { LoginService } from './login/login.service';
import { Idle, DEFAULT_INTERRUPTSOURCES } from '@ng-idle/core';
import { ConfigService } from './config.service';
import { CommonService } from './shared/common';

declare var jQuery: any;
@Component({
    selector: 'my-app',
    templateUrl: '../app/app.component.html',
    providers: [LoginService]
})
export class AppComponent implements OnInit {

    @ViewChild('errorModal') errorModal: ModalDirective
    @ViewChild('pwdModal') pwdModal: ModalDirective
    @ViewChild('retModal') retModal: ModalDirective

    isUserLogged: boolean = false;
    isResetPasswordVisible: boolean = false;
    token: string = "";
    username: string;
    userEmail: string;
    isMyClientsAccessible = false;
    isAllClientsAccessible = false;
    isPackSearchAccessible = false;
    isAllocationAccess = false;
    isReleaseAccess = false;
    //subscription
    isSubMyClientsAccessible = false;
    isSubAllClientsAccessible = false;
    //Territory
    isTerMyClientsAccessible = false;
    isTerAllClientsAccessible = false;

    //isAdminAccessible: boolean = false;
    isUserManagementAccessible: boolean = false;
    isContentAministrationAccessible: boolean = false;
    isInternalAdmin: boolean = false;
    isMasterDataAccessible: boolean = false;
    //Reporting
    isReportsAccessible: boolean = false;
    isAuditReportsAccessible: boolean = false;
    //Home
    isHomeAccessible: boolean = true;

    m_oldPwd: string = "";
    m_newPwd: string = "";
    m_confirmPwd: string = "";
    isClickedOnce: boolean = false;
    oldPwd: string = "";
    userID: number = 0;
    isMaintenanceDateAvailable: boolean = false;
    maintenanceMonth: string = "";
    maintenanceDate: string = "";

    ngOnInit(): void {
        jQuery("#oldPwd").unbind();
        jQuery("#oldPwd").bind("keyup", function () {
            jQuery("#oldPwdErr").html("");
            jQuery("#changePwdErr").html("");
        });

        jQuery("#newPwd").unbind();
        jQuery("#newPwd").bind("keyup", function () {
            jQuery("#newPwdErr").html("");
            jQuery("#changePwdErr").html("");
        });
        jQuery("#confirmPwd").unbind();
        jQuery("#confirmPwd").bind("keyup", function () {
            jQuery("#changePwdErr").html("");
            jQuery("#confirmPwdErr").html("");
        });

        jQuery("#oldPwdErr").html("");
        jQuery("#newPwdErr").html("");
        jQuery("#confirmPwdErr").html("");
        jQuery("#changePwdErr").html("");

        //Get maintenance date
        if (this.isUserLogged) {
            this.getMaintenanceDate();
        }
    }

    getMaintenanceDate() {
        //Check maintenance date for current month
        this._LoginService.getMaintenanceDate().subscribe(
            data => {
                if (data != '' && data != null) {
                    this.isMaintenanceDateAvailable = true;
                    let index = data.indexOf("&&");
                    if (index != -1) {
                        this.maintenanceMonth = data.substring(0, index);
                        this.maintenanceDate = data.substring(index + 2, data.length);
                    }
                    else
                        this.isMaintenanceDateAvailable = false;
                }
                else
                    this.isMaintenanceDateAvailable = false;
            },
            error => {
                this.isMaintenanceDateAvailable = false;
            });
    }

    isLoggedIn(): void {
        var cUser: any = this._cookieService.getObject("CurrentUser");
        this.isUserLogged = false;
        if (cUser) {
            var t = CommonService.getCookie("token");
            if (t) {
                if (t != '') {
                    this.isUserLogged = true;
                    this.username = cUser.username;
                    this.userID = cUser.UserID;
                    this.userEmail = cUser.EmailId;
                }
            }
        }
    };

    logout(): void {
        //this.isUserLogged = false;
        //this._cookieService.removeAll();
        // this.router.navigateByUrl('/');
        this.router.navigate(['logout']);
       // this.resetIdle();
        this.idle.stop();
    }
    changePassword(): void {
        this.isClickedOnce = false;
        //this.oldPwd = CommonService.getCookie("userPwd");
        this.m_oldPwd = "";
        this.m_newPwd = "";
        this.m_confirmPwd = "";
        jQuery("ResetPwdSuccess").html("");
        jQuery("changePwdErr").html("");
        this.pwdModal.config.backdrop = 'static';
        this.pwdModal.config.keyboard = false;
        this.pwdModal.show();
    }
    m_changePassword(): boolean {
        this.isClickedOnce = false;

        if (this.m_oldPwd == "") { //if m_oldPwd not correct - message
            jQuery("#oldPwdErr").html("This information is required.");
            jQuery("#oldPwd").focus();
            return false;
        }
        //else if (this.m_oldPwd != this.oldPwd) {
        //    jQuery("#oldPwdErr").html("The current password is incorrect.");
        //    jQuery("#oldPwd").focus();
        //    return false;
        //}
        else if (this.m_newPwd == "") {
            jQuery("#newPwdErr").html("This information is required.");
            jQuery("#newPwd").focus();
            return false;
        } else if (this.m_newPwd.length < 8) {
            jQuery("#newPwdErr").html("Minimum 8 characters are required for the new password.");
            jQuery("#newPwd").focus();
            return false;
        } else if (this.m_newPwd.length > 25) {
            jQuery("#newPwdErr").html("Maximum 25 characters are required for the new password.");
            jQuery("#newPwd").focus();
            return false;
        } else if (this.validateRegExp(this.m_newPwd) === false) {
            jQuery("#newPwdErr").html("Password should be three of the four character types: lowercase letters, uppercase letters, numbers and symbols ");
            jQuery("#newPwd").focus();
            return false;
        } else if (this.m_confirmPwd == "") {
            jQuery("#confirmPwdErr").html("This information is required.");
            jQuery("#confirmPwd").focus();
            return false;
        } else if (this.m_newPwd != this.m_confirmPwd) {
            jQuery("#confirmPwdErr").html("Your password and confirmation password do not match.");
            jQuery("#confirmPwd").focus();
            return false;
        } else {
            jQuery("#oldPwdErr").html("");
            jQuery("#newPwdErr").html("");
            jQuery("#confirmPwdErr").html("");
            jQuery("#changePwdErr").html("");
            this.isClickedOnce = true;
            this._LoginService.updatePassword(this.userID, this.m_oldPwd, this.m_newPwd).subscribe(response => {
                if (response.isSuccess) {
                    jQuery("#ResetPwdSuccess").html("Your password has been changed.");
                    jQuery("#changePwdErr").html("");
                }
                else {
                    jQuery("#ResetPwdSuccess").html("");
                    jQuery("#changePwdErr").html(response.message);
                }
            }, err => {

            });
        }

    }

    validateRegExp(expression: string): boolean {
        let count: number = 0;
        if (/^(?=.*[a-z]).+$/.test(expression)) {
            count++;
        }
        if (/^(?=.*[A-Z]).+$/.test(expression)) {
            count++;
        }
        if (/[$-/:-?{-~!"^_`\[\]]/.test(expression)) {
            count++;
        }
        if (/^(?=.*\d).+$/.test(expression)) {
            count++;
        }
        if (count >= 3) {
            return true;
        }
        return false;
    }

    closeDialog() {
        this.retModal.hide();
    }
    cancelPasswordChange() {
        this.pwdModal.hide();
    }

    constructor(private activatedRoute: ActivatedRoute, private _cookieService: CookieService, private router: Router, private authService: AuthService, private _LoginService: LoginService, private idle: Idle
    ) {
        this.authService.isTimeout = false;
        authService.logoutChange.subscribe((o: any) => { this.isUserLogged = o; })
        idle.setIdle(ConfigService.idleTimeout);
        idle.setTimeout(ConfigService.idleTimeWarning);
        idle.setInterrupts(DEFAULT_INTERRUPTSOURCES);

        idle.onTimeoutWarning.subscribe((countdown: number) => {
            this.authService.isTimeout = true;

            var url = this.router.url.split('/')[1];
            if ((url == 'deliverablesedit' || url == 'release' || url == 'marketCreate' || url == 'territory-create') && this.authService.hasUnSavedChanges == true) {
                if (countdown == ConfigService.idleTimeWarning) {

                    alert('You will time out in ' + countdown + ' seconds!');
                    //var r = confirm('You will time out in ' + countdown + ' seconds!, press OK to remain logged in');
                    //if (r == true) {
                    //    //idle.setKeepaliveEnabled(true);
                    //    this.resetIdle();
                    //    //idle.setAutoResume(AutoResume.idle)
                    //}
                    //else {
                    //    this.authService.isTimeout = true;
                    //}
                    this.authService.isTimeout = false;
                }
            }
            console.log('TimeoutWarning: ' + countdown);
        });
        idle.onTimeout.subscribe(() => {
            //console.log('Timeout');

            this.logout();
            this.authService.isTimeout = false;
            //idle.stop();
            //idle.ngOnDestroy();
        });
        idle.watch();
        //this.resetIdle();
        var usrObj: any = this._cookieService.getObject('CurrentUser');

        var url = this.router.url;
        if (usrObj) {

            if (usrObj.RoleName == 'Internal Admin') {
                this.isInternalAdmin = true;
            }

            if (usrObj.RoleID == 8){
                this.isHomeAccessible = false;
            }

            if (usrObj.RoleName == 'Internal Admin' || usrObj.RoleName == 'Internal Production' || usrObj.RoleName == 'Internal Support') {
                this.isMasterDataAccessible = true;
            }


            //alert('currentuser check permission');
            this.authService.CheckPermission('', '', 'Use global navigation toolbar')
                .subscribe(
                (data: any) => this.checkPermission(data),
                (err: any) => {

                    this.errorModal.show();
                    this.logout();
                    console.log(err)

                },
                () => console.log('data loaded')
                );
        }

        this.isLoggedIn();
    }
    resetIdle() {
        this.idle.watch();
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
                //if (typeof data[it] !== 'undefined') {
                if (data[it].Section == "Market" && data[it].ModuleName == 'All Clients') {
                    
                    this.authService.canAllClientAccess = true;
                    this.isAllClientsAccessible = true;

                }
                if (data[it].Section == "Market" && data[it].ModuleName == 'My Clients') {
                    
                    this.authService.canMyClientAccess = true;
                    this.isMyClientsAccessible = true;
                }
                if (data[it].Section == "Market" && data[it].ModuleName == 'Pack Search') {
                    this.authService.canPackSearchAccess = true;
                    this.isMyClientsAccessible = true;
                    this.isPackSearchAccessible = true;
                }
                if (data[it].Section == "Subscription" && data[it].ModuleName == 'Allocation') {
                    this.authService.canAllocationAccess = true;
                    this.isAllocationAccess = true;
                }
                if (data[it].Section == "Subscription" && data[it].ModuleName == 'Release') {
                    this.authService.canReleaseAccess = true;
                    this.isReleaseAccess = true;
                }
                if (data[it].Section == "Subscription" && data[it].ModuleName == 'All Clients') {
                    this.authService.canSubAllClientAccess = true;
                    this.isSubAllClientsAccessible = true;
                }
                if (data[it].Section == "Subscription" && data[it].ModuleName == 'My Clients') {
                    this.authService.canSubMyClientAccess = true;
                    this.isSubMyClientsAccessible = true;
                }
                if (data[it].Section == "Territory" && data[it].ModuleName == 'All Clients') {
                    this.authService.canTerAllClientAccess = true;
                    this.isTerAllClientsAccessible = true;
                }
                if (data[it].Section == "Territory" && data[it].ModuleName == 'My Clients') {
                    this.authService.canTerMyClientAccess = true;
                    this.isTerMyClientsAccessible = true;
                }
                if (data[it].Section == "Admin" && data[it].ModuleName == 'User management') {
                    //alert("admin section");
                    this.authService.canAccessUserManagement = true;
                    this.isUserManagementAccessible = true;
                    //this.isAdminAccessible = true;
                }
                if (data[it].Section == "Admin" && data[it].ModuleName == 'Content Administration') {
                    this.authService.canAccessContentAdministration = true;
                    this.isContentAministrationAccessible = true;
                }
                if (data[it].Section == "System Reporting" && data[it].ModuleName == 'Audit Reports') {
                    this.authService.canAccessAuditReports = true;
                    this.isAuditReportsAccessible = true;
                } 
                //Testing
                //this.isReportsAccessible = false;
                if (data[it].Section == "System Reporting" && data[it].ModuleName == 'Reports') {
                    this.authService.canAccessReports = true;
                    this.isReportsAccessible = true;
                } 
            }
        }
    }


    navigateMyclients(module: any): void {
        if (module == "mysubscriptions") {
            let link = ['./subscriptions/mysubscriptions']
            this.router.navigate([''], { skipLocationChange: true });
            setTimeout(() => { this.router.navigate(link); }, 100)
        } else {
            let link = ['./subscription/myclients']
            this.router.navigate([''], { skipLocationChange: true });
            setTimeout(() => { this.router.navigate(link); }, 100)
        }

    }

    navigateAllclients(): void {
        let link = ['./subscriptions/allclients'];
        this.router.navigate([''], { skipLocationChange: true });
        setTimeout(() => { this.router.navigate(link); }, 100)
    }

}
