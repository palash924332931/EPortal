import { Injectable } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
//import 'rxjs/add/operator/map';
//import { Observable } from 'rxjs/Rx';
//import { ConfigService } from '../config.service';
import { ConfigService } from '../config.service';

@Injectable()
export class CommonService {
    //Singleton??
    public static setCookie(cname: string, cvalue: string, exdays:number) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toUTCString();
        var cookieName = ConfigService.webApiName + '_' + cname;
        document.cookie = cookieName + "=" + cvalue + ";" + expires;
    }
    public static getCookie(cname: string) {
       // var name = cname + "=";
        var name = ConfigService.webApiName + '_' + cname + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }
    public static getCookies() {

        alert(document.cookie);

    }
    public static getHeaders() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Content-Type', 'application/json');
        headers.append('Accept', 'application/json');
        var t = this.getCookie("token");
      
        if (t!=null && t!='')
            headers.append('Authorization', 'bearer '+t);
        return headers;
    }

    public static getHeadersForFileUpload() {
        let headers = new Headers();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.append('Accept', 'application/json');
        var t = this.getCookie("token");
        if (t != null && t != '')
            headers.append('Authorization', 'bearer ' + t);
        return headers;
    }
}