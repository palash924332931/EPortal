﻿import { Injectable } from '@angular/core';

@Injectable()
export class ConfigService {


    public static readonly webAppHost: string = '10.66.1.155';
    public static readonly webAppPort: string = '8087';
    public static readonly baseWebAppUrl: string = 'http://' + ConfigService.webAppHost + ':' + ConfigService.webAppPort;

    public static readonly webApiHost: string = '10.66.1.155';
    public static readonly webApiPort: string = '8087';
    public static readonly webApiName: string = 'API'; //unique for each site
    public static readonly baseWebApiUrl: string = 'http://' + ConfigService.webApiHost + ':' + ConfigService.webApiPort + '/' + ConfigService.webApiName + '/api';
    public static readonly WebApiTokenPath: string = 'http://' + ConfigService.webApiHost + ':' + ConfigService.webApiPort + '/' + ConfigService.webApiName + '/token';

    //live
/*    public static readonly webAppHost: string = 'everest.imshealth.com';
    public static readonly webAppPort: string = '80';
    public static readonly baseWebAppUrl: string = 'https://' + ConfigService.webAppHost;

    public static readonly webApiHost: string = 'everest.imshealth.com';
    public static readonly webApiPort: string = '80';
    public static readonly baseWebApiUrl: string = 'https://' + ConfigService.webApiHost + '/api/api';
    public static readonly WebApiTokenPath: string = 'https://' + ConfigService.webApiHost + '/api/token';*/

    public static getWebAppUrl(path: string) {
        return `${ConfigService.baseWebAppUrl}/${path}`;
    }

    public static getApiUrl(path: string) {
        return `${ConfigService.baseWebApiUrl}/${path}`;
    }

    public static clientFlag: boolean = true;

    public static readonly httpTimeout: number = 60000;

    public static readonly ErrorMessage: string = "Error - Application timed-out. ";

    public static getErrorMessage(messsage: string) {
        return `${ConfigService.ErrorMessage}/${messsage}`;
    }

    public static readonly idleTimeout: number = 3000;
    public static readonly idleTimeWarning: number = 60;
}