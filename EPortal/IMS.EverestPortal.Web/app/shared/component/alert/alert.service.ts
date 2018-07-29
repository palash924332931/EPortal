import { Injectable } from '@angular/core';
import { Router, NavigationStart } from '@angular/router';
import { Observable } from 'rxjs';
import { Subject } from 'rxjs/Subject';
@Injectable()
export class AlertService {
    private subject = new Subject<any>();
    private loadingFlag: boolean = false;
    constructor() { }
    confirm(message: string, siFn: () => void, noFn: () => void, type: string = 'confirm') {
        this.setConfirmation(message, siFn, noFn, type);
    }
    confirmAsync(message: string, siFn: () => Promise<any>, noFn: () => void, type: string = 'confirm') {
        this.setConfirmation(message, siFn, noFn, type);
    }

    alertAutoTerminated(message: string, siFn: () => void = null, noFn: () => void = this.closefn, type: string = 'alert-terminated') {
        this.setConfirmation(message, siFn, noFn, type);
    }
    alert(message: string, noFn: () => void = this.closefn, type: string = 'alert') {
        this.setConfirmation(message, this.closefn, noFn, type);
    }
    exceptionAlert(error: any, siFn: () => void = null, noFn: () => void = this.closefn, type: string = 'alert') {
        if (error.status==0){
            this.setConfirmation("System has failed to connect with server due to network problem.", siFn, noFn, type);
        } else {
            this.setConfirmation(error._body, siFn, noFn, type);
        }
    }
    fnLoading(flag: boolean) {
        this.setConfirmation(flag==true?'true':'false', null, null, "loading");
    }
    setConfirmation(message: string, siFn: () => void, noFn: () => void, type: string) {
        let that = this;
        this.subject.next({
            type: type,
            text: message,
            siFn:
            function () {
                that.subject.next(); //this will close the modal
                siFn();
            },
            noFn: function () {
                that.subject.next();
                noFn();
            }
        });

        if (type == "alert-terminated") {
            setTimeout(() => {
                this.subject.next();
            }, 3000);
        }

    }

    closefn = function () {
        //this.subject.next();
    }

    getMessage(): Observable<any> {
        return this.subject.asObservable();
    }

}