import { ErrorHandler, Injectable, ViewChild } from '@angular/core';
//import { AuthService } from './auth.service';
import { ReleaseService } from '../subscriptionRelease/release.service';

declare var jQuery: any;


@Injectable()
export class GlobalErrorHandler implements ErrorHandler {

    
    req: any = {};
    constructor(private releaseService: ReleaseService) {
        // The true paramter tells Angular to rethrow exceptions, so operations like 'bootstrap' will result in an error
        // when an error happens. If we do not rethrow, bootstrap will always succeed.
        //super(true);
    }


    handleError(error: any) {
        console.log('error=' + error.message);
        //JSON.parse(error._body).Message

        //console.log(error.message.toLowerCase().indexOf('InvalidStateError'));

        if (error.message && (error.message.indexOf('InvalidStateError') >= 0)) {
            return;
        }

        if (error.message) {
            if (!(error.message.toLowerCase().indexOf('timeout') == -1)) {
                if (error.message) {
                    jQuery("#exceptionModalContent").text('Error ocurred: ' + error.message);
                }
            }
            if (error.message.toLowerCase().indexOf('htmlinputelement') == -1) {
                if (error.message) {
                    jQuery("#exceptionModal").modal("show");
                }
            }
        }
        if (error && error._body && JSON.parse(error._body).Message) {
            var memMsg: string = JSON.parse(error._body).Message;
           // if (!(memMsg.indexOf('memory') == -1)) {
                jQuery("#exceptionModalContent").text(memMsg);
                jQuery("#exceptionModal").modal("show");
           // }
        }
        else {
            jQuery("#exceptionModal").modal("show");
        }
        // send the error to the server
       
        console.log("error -----");
        console.log( error);


        var ExceptionValueString: string = "";

        if (error.stack) {
            ExceptionValueString = JSON.stringify(error.stack);
        }
        else {
            ExceptionValueString = JSON.stringify(error);
        }

        let errorType: string;
        if (error instanceof SyntaxError) {
            errorType = "SyntaxError";
        } else if (error instanceof TypeError) {
            errorType = "TypeError";
        } else if (error instanceof ReferenceError) {
            errorType = "ReferenceError";
        } else if (error instanceof URIError) {
            errorType = "URIError";
        } else if (error instanceof ErrorEvent) {
            errorType = "ErrorEvent";
        } else {
            errorType = "Error";
        }

        let location = window.location;

        this.req = {
            ExceptionValue: ExceptionValueString,
            URL: location.href,
            ErrorType: errorType
        };

        this.releaseService.LogError(this.req)
            .subscribe(
            p => (console.log("Exception logged"), jQuery("#overlay-loading").css("display", "none")),
            e => (console.log("Exception happened is not logged, please contact your administrator"),
                jQuery("#overlay-loading").css("display", "none"))
            );
    }
}