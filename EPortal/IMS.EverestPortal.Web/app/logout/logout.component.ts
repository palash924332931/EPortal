import { Component, OnInit } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { DeliverableService } from '../deliverables/deliverables-edit.service';
import { DeactivateGuard } from '../security/deactivate-guard';

@Component({
    selector: 'logout-component',
    template: '',
})

export class LogoutComponent implements OnInit {

    constructor(private _cookieService: CookieService, private router: Router, private authService: AuthService, private deliverableService: DeliverableService,
        private deactiveGuard: DeactivateGuard) { }

    ngOnInit() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');

        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
            try {
                this.deactiveGuard.fnReleaseLock(userid, 0, '', '', 'Release Lock All').then(
                    result => {
                        //console.log('Released all locks');
                        this.removeAllCookie();
                    }).catch(err => {
                        //Waiting for log the error
                        setTimeout(() => {
                            this.removeAllCookie();
                        }, 4000);
                    });
            } catch (ex) {
                //Waiting for log the error
                setTimeout(() => {
                    this.removeAllCookie();
                }, 4000);
            }
        }
        else {
            this.removeAllCookie();
        }
    }

    private removeAllCookie(): void {
        var email = this._cookieService.get("EmailId");
        this._cookieService.removeAll();
        if (email != undefined) {
            this._cookieService.put('EmailId', email);
        }
        this.authService.logoutChange.emit(false);
        this.router.navigateByUrl('/');
    }
}