import { Injectable } from '@angular/core';

@Injectable()
export class ConfigService {
    public static readonly webAppHost: string ='10.66.1.155';
    public static readonly webAppPort: string = '8085';
    public static readonly baseWebAppUrl: string = 'http://' + ConfigService.webAppHost + ':' + ConfigService.webAppPort;

    public static readonly webApiHost: string = '10.66.1.155';;
    public static readonly webApiPort: string = '8085';
    public static readonly webApiName: string = 'SITWebApi121'; //unique for each site
    public static readonly baseWebApiUrl: string = 'http://' + ConfigService.webApiHost + ':' + ConfigService.webApiPort + '/SITWebApi121/api';
    public static readonly WebApiTokenPath: string = 'http://' + ConfigService.webApiHost + ':' + ConfigService.webApiPort + '/SITWebApi121/token';

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

    public static readonly idleTimeout: number = 300;
    public static readonly idleTimeWarning: number = 60;
}