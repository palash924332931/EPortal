import { Component, OnInit, ViewChild, HostListener } from '@angular/core';
//import { Pipe, PipeTransform } from 'angular2/core';
import { DatePipe } from '@angular/common';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Client } from '../shared/models/client';
import { CLIENTS } from '../shared/models/mock-clients';

import { ClientService } from '../shared/services/client.service';
import { DateService } from '../shared/services/date.service';

import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';

import { ConfigService } from '../config.service';
import { ModalDirective } from 'ng2-bootstrap';
import { AuditVersionService } from './AuditVersioning.service';
import { ComponentCanDeactivate, DeactivateGuard } from '../security/deactivate-guard';
import { Observable } from 'rxjs/Observable';
import { SubscriptionReportDTO, clientDTO, NameDTO, DeliverablenNameDTO } from './AuditVersioning.model';
import { SubscriptionPeriodChangeDTO, VersionDTO, DeliverableVersionDTO } from './AuditVersioning.model';
import { SubscriptionMktBaseNamEChangeDTO } from './AuditVersioning.model';
import { AlertService } from '../shared/component/alert/alert.service';

import { IMyDpOptions, IMyOptions, IMyDateModel, IMyDate } from 'mydatepicker';



@Component({
    selector: 'deliverable-edit',
    templateUrl: '../../app/AuditVersioning/AuditVersioning.html',
    styleUrls: ['../../app/AuditVersioning/AuditVersioning.css'],
    providers: [AuditVersionService, DatePipe, DateService]
})




//@Pipe({ name: 'demoNumber' })
//export class DemoNumber implements PipeTransform {
//    transform(value, args: string[]): any {
//        let res = [];
//        for (let i = 0; i < value; i++) {
//            res.push(i);
//        }
//        return res;
//    }
//}

export class AuditVersionComponent implements OnInit {

    
    IsRecordFound: boolean = false;
    IsParameterNotFound = false;
    ParamMissingMessage: string;
    NoRecordsMessage: string;
    keys: string[] = [];
    headerkeys: string[] = [];
    ReportList: any[] = [];
    columns: any[] = [];
    NameList: NameDTO[] = [];
    DeliverableNames: DeliverablenNameDTO[];
    VersionList: VersionDTO[];
    DeliverableVersions: DeliverableVersionDTO[];
    clientDataList: clientDTO[] = [];
    ClientID: any;
    durationStartDateDeli: IMyDateModel;
    durationEndDate: IMyDateModel;
    selectedClient: clientDTO;
    SectionID: number;
    EntityID: number;
    EntityName: string;
    startVersionNo: number;
    endVersionNo: number;
    reportName: string;
    SectionName: string;
    reportTypeList: string[] = [];
    SectionList: string[] = [];
    objLength: number;
    FullName: string;
    enabledReportDetails: boolean = false;

    usrObj: any;
    constructor(private AuditVersionService: AuditVersionService, private datePipe: DatePipe,
        // public route: ActivatedRoute,
        private _cookieService: CookieService, private dServie: DateService,
        // private authService: AuthService, private deactiveGuard: DeactivateGuard,
        private router: Router, private clientService: ClientService, private alertService: AlertService) {
        this.usrObj = this._cookieService.getObject('CurrentUser');

    }
    ngOnInit(): void {
        this.getClients();
        this.GetSectionNames();
        this.SectionName = this.SectionList[0];
        this.GetReportTypes("Markets");
    }


    //datepicker components

    public myDatePickerOptions: IMyOptions = {
        dateFormat: 'dd-mm-yyyy',
        editableDateField: false,
    };

    public myEndDatePickerOptions: IMyOptions = {
        dateFormat: 'dd-mm-yyyy',
        editableDateField: false,
        disableSince: { year: 0, month: 0, day: 0 }

    };
    getAuditReportById(SectionName: string, id: number, startversion: number, endversion: number, reportname: string) {
        this.enabledReportDetails = true;
        this.IsRecordFound = false;
        this.clientService.fnSetLoadingAction(true);
        this.AuditVersionService.getAuditReport(SectionName, id, startversion, endversion, reportname)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (response: any) => {
                this.ReportList = [];
                if (reportname == "Period Changes") {
                    this.auditReportData = response.SubscriptionPeriodChange || [];
                    this.auditReportSettings.tableName = "Audit - Period Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'DataSubscriptionPeriod', width: '10%', internalName: 'DataSubscriptionPeriod', sort: true, type: "", onClick: "" },
                        { headerName: 'VersionNumber', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" }, 
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                    ]
                }
                if (reportname == "Market Base Changes") {
                    this.auditReportData = response.SubscriptionMktBaseNamEChange || [];
                    this.auditReportSettings.tableName = "Audit - Market Base Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Market Base Name', width: '10%', internalName: 'MarketBaseName', sort: true, type: "", onClick: "" },
                        { headerName: 'Market Base Version', width: '10%', internalName: 'MarketBaseVersion', sort: true, type: "", onClick: "" },
                        { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                        { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                    ]
                }
                if (reportname == "Report Parameter Changes") {
                    this.auditReportData = response.DeliverableReportParameterChange || [];
                    this.auditReportSettings.tableName = "Audit - Report Parameter Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Data Delivery Period', width: '10%', internalName: 'DataDeliveryPeriod', sort: true, type: "", onClick: "" },
                        { headerName: 'Frequency', width: '6%', internalName: 'Frequency', sort: true, type: "", onClick: "" },
                        { headerName: 'Period', width: '5%', internalName: 'Period', sort: true, type: "", onClick: "" },
                        { headerName: 'Restriction', width: '7%', internalName: 'Restriction', sort: true, type: "", onClick: "" },
                        { headerName: 'Report Writer', width: '8%', internalName: 'ReportWriter', sort: true, type: "", onClick: "" },
                        { headerName: 'Delivered To', width: '7%', internalName: 'DeliveredTo', sort: true, type: "", onClick: "" },
                        { headerName: 'PROBE', width: '5%', internalName: 'PROBE', sort: true, type: "", onClick: "" },
                        { headerName: 'Census', width: '6%', internalName: 'Census', sort: true, type: "", onClick: "" },
                        { headerName: 'Onekey', width: '5%', internalName: 'One_Key', sort: true, type: "", onClick: "" },
                        { headerName: 'Pack Exception', width: '8%', internalName: 'PackException', sort: true, type: "", onClick: "" },
                        { headerName: 'Version', width: '5%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '8%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '8%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                        ]
                }
                if (reportname == "Market Definition Changes") {
                    this.auditReportData = response.DeliverableMktDfnChange || [];
                    this.auditReportSettings.tableName = "Audit - Market Defintion Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Market Definition Name', width: '10%', internalName: 'MarketDefinitionName', sort: true, type: "", onClick: "" },
                        { headerName: 'Market Definition Version', width: '10%', internalName: 'MarketDefnitionVersion', sort: true, type: "", onClick: "" },
                        { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },                        
                        { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                        ]
                }
                if (reportname == "Territory Definition Changes") {
                    this.auditReportData = response.DeliverableTerritoryDfnChange || [];                  
                    this.auditReportSettings.tableName = "Audit - Territory Definition Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Territory Definition Name', width: '10%', internalName: 'TerritoryDefinitionName', sort: true, type: "", onClick: "" },
                        { headerName: 'Territory Definition Version', width: '10%', internalName: 'TerritoryDefnitionVersion', sort: true, type: "", onClick: "" },
                        { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                        { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                    ]
                }
                if (reportname == "Name and Id Changes") {                    

                    this.auditReportData = response.TerritoryDefinitionChanges || [];
                    this.auditReportSettings.tableName = "Audit - Name and Id Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Territory Definition Name', width: '10%', internalName: 'TerritoryDefinitionName', sort: true, type: "", onClick: "" },
                        { headerName: 'SRA Client', width: '10%', internalName: 'SRAClient', sort: true, type: "", onClick: "" },
                        { headerName: 'SRA Suffix', width: '10%', internalName: 'SRASuffix', sort: true, type: "", onClick: "" },
                        { headerName: 'LD', width: '10%', internalName: 'LD', sort: true, type: "", onClick: "" },
                        { headerName: 'AD', width: '10%', internalName: 'AD', sort: true, type: "", onClick: "" },
                        { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                    ]
                }
                if (reportname == "Allocation Changes") {                 

                    this.auditReportData = response.TerritoryAllocationChanges || [];
                    this.auditReportSettings.tableName = "Audit - Allocation Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Brick Or Outlet Code', width: '10%', internalName: 'BrickOrOutletCode', sort: true, type: "", onClick: "" },
                        { headerName: 'Brick Or Outlet Name', width: '10%', internalName: 'BrickOrOutletName', sort: true, type: "", onClick: "" },
                        { headerName: 'Group', width: '10%', internalName: 'Group', sort: true, type: "", onClick: "" },
                        { headerName: 'Parent Groups', width: '10%', internalName: 'ParentGroups', sort: true, type: "", onClick: "" },
                        { headerName: 'ID', width: '10%', internalName: 'ID', sort: true, type: "", onClick: "" },
                        { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                        { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                    ]
                }
                if (reportname == "Group Changes") {

                    this.auditReportData = response.TerritoryGroupChanges || [];
                    this.auditReportSettings.tableName = "Audit - Group Changes";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Territory Definition Name', width: '10%', internalName: 'GroupNames', sort: true, type: "", onClick: "" },
                        { headerName: 'ID', width: '10%', internalName: 'ID', sort: true, type: "", onClick: "" },
                        { headerName: 'Parent Groups', width: '10%', internalName: 'ParentGroups', sort: true, type: "", onClick: "" },
                        { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                        { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },                       
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                        ]
                }

                if (this.ReportList && this.ReportList.length > 0) {
                    this.keys = Object.keys(this.ReportList[0]);

                    this.headerkeys = [];
                    let tempKey = Object.keys(this.ReportList[0]);
                    tempKey.forEach((r) => {
                        let word: string = '';
                        if ((r.indexOf('_', 0) == -1)) {
                            for (var i = 0; i < r.length; i++) {
                                if (r[i] == r[i].toUpperCase()) {
                                    if (i !== 0 && (!this.isUpperCase(r)) && (i + 1 !== r.length) && (r[i+1] != r[i+1].toUpperCase()))
                                        word = word + ' ';
                                }
                                word = word + r[i];
                            }

                            this.headerkeys.push(word);
                        }
                        else {
                            r = r.replace('_', '');
                            this.headerkeys.push(r);
                        }
                    });

                }
                if (this.ReportList && this.ReportList.length == 0) {
                    this.IsRecordFound = true;
                    this.NoRecordsMessage = "No Records Found";
                }
                console.log(this.keys);
               
            },
            (err: any) => {
                console.log(err);
            },
            () => console.log(' Client List generated ')
            );
    }



    isUpperCase(str) {
        return str === str.toUpperCase();
    }

    getClients() {
        console.log('component - get clients');
        this.AuditVersionService.getAllClients().subscribe(
            (response: any) => {

                this.clientDataList = response.data;
                if (this.clientDataList != null && this.clientDataList.length > 0) {
                    this.ClientID = this.clientDataList[0].clientID;
                    this.getMarketDefNames(this.ClientID);
                }

                //this.initialvalue = JSON.stringify(data), this.SubscriptionReportList = data, this.SavedeliverablesList = this.deliverablesList, this.checkMktCount(this.SavedeliverablesList),
                //    this.checkTerCount(this.SavedeliverablesList), console.log('delivery=' + this.deliverablesList)
            },
            (err: any) => {
                //this.DelErrorModal.show();
                //this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log(' Audit Subscription Report generated ')
        );
    }

    getSubscriptionNames(clientId: number) {
        if ((typeof clientId != 'undefined' && clientId)) {
            this.AuditVersionService.getSubscriptionNames(clientId).subscribe(
                (response: any) => {

                    this.NameList = response.data
                    if (this.NameList != null && this.NameList.length > 0) {
                        this.EntityID = this.NameList[0].ID;
                        this.getSubscriptionVersions(clientId, this.EntityID, null, null);
                    }
                    //this.initialvalue = JSON.stringify(data), this.SubscriptionReportList = data, this.SavedeliverablesList = this.deliverablesList, this.checkMktCount(this.SavedeliverablesList),
                    //    this.checkTerCount(this.SavedeliverablesList), console.log('delivery=' + this.deliverablesList)
                },
                (err: any) => {
                    //this.DelErrorModal.show();
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log(' Audit Subscription Names generated ')
            );
        }
    }

    getTerritoryNames(clientId: number) {
        if ((typeof clientId != 'undefined' && clientId)) {
            this.alertService.fnLoading(true);
            this.AuditVersionService.getTerritoryNames(clientId).subscribe(
                (response: any) => {
                    this.alertService.fnLoading(false);
                    this.NameList = response.data
                    if (this.NameList != null && this.NameList.length > 0) {
                        this.EntityID = this.NameList[0].ID;
                        this.getTerritoryVersions(clientId, this.EntityID, null, null);
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log(' Audit Territory Names generated ')
            );
        }
    }

    getMarketbaseNames(clientId: number) {
        if ((typeof clientId != 'undefined' && clientId)) {
            this.alertService.fnLoading(true);
            this.AuditVersionService.getMarketbaseNames(clientId).subscribe(
                (response: any) => {
                    this.alertService.fnLoading(false);
                    this.NameList = response || [];
                    if (this.NameList != null && this.NameList.length > 0) {
                        this.EntityID = this.NameList[0].ID;
                        this.getMarketbaseVersions(clientId, this.EntityID, null, null);
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log(' Audit Marketbase Names generated ')
            );
        }
    }

    getMarketDefNames(clientId: number) {
        if ((typeof clientId != 'undefined' && clientId)) {
            this.alertService.fnLoading(true);
            this.AuditVersionService.getMarketDefinitionNames(clientId).subscribe(
                (response: any) => {
                    this.alertService.fnLoading(false);
                    this.NameList = response || [];
                    if (this.NameList != null && this.NameList.length > 0) {
                        this.EntityID = this.NameList[0].ID;
                        this.getMarketDefVersions(clientId, this.EntityID, null, null);
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log(' Audit Marketbase Names generated ')
            );
        }
    }


    getMarketbaseVersions(clntID: number, MarketbaseId: number, startDate: string, endDate: string) {

        //if ((typeof clntID != 'undefined' && clntID) && (typeof MarketbaseId != 'undefined' && MarketbaseId) && (typeof startDate != 'undefined' && startDate) && (typeof endDate != 'undefined' && endDate)) {
        /*if ((typeof clntID != 'undefined' && clntID) && (typeof MarketbaseId != 'undefined' && MarketbaseId)) {
           this.AuditVersionService.getDeliverableVersions(clntID, MarketbaseId, startDate, endDate).subscribe(
               (response: any) => {
                   debugger;
                   this.VersionList = response.data
                   if (this.VersionList != null && this.VersionList.length > 0) {
                       this.startVersionNo = this.VersionList[0].VersionNo;
                       this.endVersionNo = this.VersionList[0].VersionNo;
                   }
               },
               (err: any) => {
                   console.log(err);
               },
               () => console.log(' Audit Deliverable Version List generated ')
           );
       }*/

        if ((typeof clntID != 'undefined' && clntID) && (typeof MarketbaseId != 'undefined' && MarketbaseId)) {
            this.alertService.fnLoading(true);
            this.AuditVersionService.getVersions(this.SectionName, clntID, MarketbaseId, startDate, endDate).subscribe(
                (response: any) => {
                    this.alertService.fnLoading(false);
                    this.VersionList = response || [];
                    if (this.VersionList != null && this.VersionList.length > 0) {
                        this.startVersionNo = this.VersionList[0].VersionNo;
                        this.endVersionNo = this.VersionList[0].VersionNo;
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    console.log(err);
                },
                () => console.log(' Audit Deliverable Version List generated ')
            );
        }
    }


    getMarketDefVersions(clntID: number, MarketbaseId: number, startDate: string, endDate: string) {
        if ((typeof clntID != 'undefined' && clntID) && (typeof MarketbaseId != 'undefined' && MarketbaseId)) {
            this.alertService.fnLoading(true);
            this.AuditVersionService.getVersions(this.SectionName, clntID, MarketbaseId, startDate, endDate).subscribe(
                (response: any) => {
                    this.alertService.fnLoading(false);
                    this.VersionList = response || [];
                    if (this.VersionList != null && this.VersionList.length > 0) {
                        this.startVersionNo = this.VersionList[0].VersionNo;
                        this.endVersionNo = this.VersionList[0].VersionNo;
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    console.log(err);
                },
                () => console.log(' Audit Deliverable Version List generated ')
            );
        }
    }

    clearList() {
        this.NameList = []; this.VersionList = [];
        this.durationEndDate = null; this.durationStartDateDeli = null;
        this.reportTypeList = [];
        this.VersionList = [];
        this.ReportList = [];
        this.startVersionNo = 0;
        this.endVersionNo = 0;
        this.NoRecordsMessage = "";
        this.ParamMissingMessage = "";
        //this.SectionName = this.SectionList[0];

    }
    onClientChange(clientID: any, SectionName: any) {
        this.enabledReportDetails = false;
        this.auditReportData=[];
        this.clearList();
        this.clearDates();
        if (SectionName == "Subscription") {
            this.getSubscriptionNames(clientID);
        }
        else if (SectionName == "Deliverables") {
            this.getDeliverableNames(clientID);
        }
        else if (SectionName == "Territories") {
            this.getTerritoryNames(clientID);
        } else if (SectionName == "Market Base") {
            this.getMarketbaseNames(clientID);
        } else if (SectionName == "Markets") {
            this.getMarketDefNames(clientID);
        }

        this.GetReportTypes(SectionName);
    }

    onSectionChange(clientID: any, SectionName: any) {
        this.enabledReportDetails = false;
        this.auditReportData=[];
        this.clearList();
        this.clearDates();
        if (SectionName == "Subscription") {
            this.getSubscriptionNames(clientID);
        }
        else if (SectionName == "Deliverables") {
            this.getDeliverableNames(clientID);
        }
        else if (SectionName == "User Management") {
            this.GetUsers();
        }
        else if (SectionName == "Maintenance") {
            this.GetTdwClients();
        }
        else if (SectionName == "Territories") {
            this.getTerritoryNames(clientID);
        } else if (SectionName == "Market Base") {
            this.getMarketbaseNames(clientID);
        } else if (SectionName == "Markets") {
            this.getMarketDefNames(clientID);
        }
        this.GetReportTypes(SectionName);

        this.auditReportSettings.tableName = this.reportName;
    }

    onEntityChange(clientID: any, EntityId: any) {
        this.VersionList = [];
        this.ReportList = [];
        //this.durationStartDateDeli = null;
        //this.durationEndDate = null;
        this.clearDates();

        //this.GetVersions(clientID, this.SectionName, EntityId, this.durationStartDateDeli, this.durationEndDate);
    }


    GetVersions(clientID: number, SectionName: string, EntityID: number, startDate: any, endDate: any) {
        this.enabledReportDetails = false;
        this.VersionList = [];
        //this.ReportList = [];
        //this.durationStartDateDeli = null;
        //this.durationEndDate = null;  
        this.NoRecordsMessage = "";
        this.ParamMissingMessage = "";
        //this.transformDate(startDate);
        let startdateformat: string = "";
        if (startDate != null && startDate.date != null) {
            startdateformat = startDate.date.year + '-' + (startDate.date.month.toString().length > 1 ? startDate.date.month : '0' + startDate.date.month)
                + '-' + (startDate.date.day.toString().length > 1 ? startDate.date.day : '0' + startDate.date.day);
        }
        let enddateformat: string = "";
        if (endDate != null && endDate.date != null) {
            enddateformat = endDate.date.year + '-' + (endDate.date.month.toString().length > 1 ? endDate.date.month : '0' + endDate.date.month)
                + '-' + (endDate.date.day.toString().length > 1 ? endDate.date.day : '0' + endDate.date.day);
        }

        // alert(this.durationEndDate.formatted);

        //let startdateformat: string = startDate.getFullYear() + '-' + startDate.getMonth() + '-' + startDate.getDay();
        //let enddateformat: string = endDate.getFullYear() + '-' + endDate.getMonth() + '-' + endDate.getDay();

        if (SectionName == "Subscription") {
            this.getSubscriptionVersions(clientID, EntityID, startdateformat, enddateformat);
        }
        if (SectionName == "Deliverables") {
            this.getDeliverableVersions(clientID, EntityID, startdateformat, enddateformat);
        }
        if (SectionName == "Territories") {
            this.getTerritoryVersions(clientID, EntityID, startdateformat, enddateformat);
        } else if (SectionName == "Market Base") {
            this.getMarketbaseVersions(clientID, EntityID, this.fnDateFormat(this.durationStartDateDeli, '1990-01-01'), this.fnDateFormat(this.durationEndDate));
            //this.getMarketbaseVersions(clientID, EntityID, startdateformat, enddateformat);
        } else if (SectionName == "Markets") {
            console.log(this.fnDateFormat(this.durationEndDate))
            this.getMarketDefVersions(clientID, EntityID, this.fnDateFormat(this.durationStartDateDeli, '1990-01-01'), this.fnDateFormat(this.durationEndDate));
            //this.getMarketDefVersions(clientID, EntityID, startdateformat, enddateformat);
        }

        //set the end date configurations
        //    this.myEndDatePickerOptions = {
        //    dateFormat: 'dd-mm-yyyy',
        //    editableDateField: false,
        //    disableSince: this.durationStartDateDeli

        //};        
        this.disableUntil();
        this.disableSince();
    }

    clearDates() {
        this.durationStartDateDeli = null;
        this.durationEndDate = null;

        this.disableUntil();
        this.disableSince();
    }

    disableUntil() {
        let copy = this.getCopyOfOptions(this.myEndDatePickerOptions);
        copy.disableUntil = { year: 0, month: 0, day: 0 };
        if (this.durationStartDateDeli) {
            let selectedDate = this.durationStartDateDeli.jsdate;
            //selectedDate.setDate(selectedDate.getDate() - 1);          
            copy.disableUntil = { year: selectedDate.getFullYear(), month: selectedDate.getMonth() + 1, day: selectedDate.getDate() - 1 };
        }
        this.myEndDatePickerOptions = copy;
    }

    disableSince() {
        let copy = this.getCopyOfOptions(this.myDatePickerOptions);
        copy.disableSince = { year: 0, month: 0, day: 0 };
        if (this.durationEndDate) {
            let selectedDate = this.durationEndDate.jsdate;
            //selectedDate.setDate(selectedDate.getDate() + 1);
            copy.disableSince = { year: selectedDate.getFullYear(), month: selectedDate.getMonth() + 1, day: selectedDate.getDate() + 1 };
        }
        this.myDatePickerOptions = copy;
    }

    // Returns copy of myOptions
    getCopyOfOptions(options: IMyOptions): IMyOptions {
        return JSON.parse(JSON.stringify(options));
    }

    GetTerritoryVersions(clientID: number, SectionName: string, EntityID: number) {
        if (SectionName == "Territories") {
            this.GetVersions(clientID, SectionName, EntityID, null, null);
        } else if (SectionName == "Market Base") {
            this.GetVersions(clientID, SectionName, EntityID, this.durationStartDateDeli, this.durationEndDate);
        }
    }

    getDeliverableNames(clientId: number) {
        this.AuditVersionService.getDeliverableNames(clientId).subscribe(
            (response: any) => {

                this.NameList = response.data
                if (this.NameList != null && this.NameList.length > 0) {
                    this.EntityID = this.NameList[0].ID;
                    this.getDeliverableVersions(clientId, this.EntityID, null, null);
                }
                //this.initialvalue = JSON.stringify(data), this.SubscriptionReportList = data, this.SavedeliverablesList = this.deliverablesList, this.checkMktCount(this.SavedeliverablesList),
                //    this.checkTerCount(this.SavedeliverablesList), console.log('delivery=' + this.deliverablesList)
            },
            (err: any) => {
                //this.DelErrorModal.show();
                this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log(' Audit - Deliverable Names generated ')
        );
    }

    getSubscriptionVersions(clntID: number, SubscriptionId: number, startDate: string, endDate: string) {

        if ((typeof clntID != 'undefined' && clntID) && (typeof SubscriptionId != 'undefined' && SubscriptionId)) {
            //&& (typeof startDate != 'undefined' && startDate) && (typeof endDate != 'undefined' && endDate)) {
            this.AuditVersionService.getSubscriptionVersions(clntID, SubscriptionId, startDate, endDate).subscribe(
                (response: any) => {

                    this.VersionList = response.data
                    if (this.VersionList != null && this.VersionList.length > 0) {
                        this.startVersionNo = this.VersionList[0].VersionNo;
                        this.endVersionNo = this.VersionList[0].VersionNo;
                    }
                    //this.initialvalue = JSON.stringify(data), this.SubscriptionReportList = data, this.SavedeliverablesList = this.deliverablesList, this.checkMktCount(this.SavedeliverablesList),
                    //    this.checkTerCount(this.SavedeliverablesList), console.log('delivery=' + this.deliverablesList)
                },
                (err: any) => {
                    //this.DelErrorModal.show();
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log(' Audit Subscription Version List generated ')
            );
        }
    }

    getDeliverableVersions(clntID: number, DeliverableId: number, startDate: string, endDate: string) {
        if ((typeof clntID != 'undefined' && clntID) && (typeof DeliverableId != 'undefined' && DeliverableId)) {
            // && (typeof startDate != 'undefined' && startDate) && (typeof endDate != 'undefined' && endDate)) {
            this.AuditVersionService.getDeliverableVersions(clntID, DeliverableId, startDate, endDate).subscribe(
                (response: any) => {
                    this.VersionList = response.data
                    if (this.VersionList != null && this.VersionList.length > 0) {
                        this.startVersionNo = this.VersionList[0].VersionNo;
                        this.endVersionNo = this.VersionList[0].VersionNo;
                    }
                },
                (err: any) => {
                    console.log(err);
                },
                () => console.log(' Audit Deliverable Version List generated ')
            );
        }
    }

    getTerritoryVersions(clntID: number, TerritoryId: number, startDate: string, endDate: string) {
        if ((typeof clntID != 'undefined' && clntID) && (typeof TerritoryId != 'undefined' && TerritoryId)) {
            this.AuditVersionService.getTerritoryVersions(clntID, TerritoryId, startDate, endDate).subscribe(
                (response: any) => {

                    this.VersionList = response.data
                    if (this.VersionList != null && this.VersionList.length > 0) {
                        this.startVersionNo = this.VersionList[0].VersionNo;
                        this.endVersionNo = this.VersionList[0].VersionNo;
                    }
                    //this.initialvalue = JSON.stringify(data), this.SubscriptionReportList = data, this.SavedeliverablesList = this.deliverablesList, this.checkMktCount(this.SavedeliverablesList),
                    //    this.checkTerCount(this.SavedeliverablesList), console.log('delivery=' + this.deliverablesList)
                },
                (err: any) => {
                    //this.DelErrorModal.show();
                    this.clientService.fnSetLoadingAction(false);
                    console.log(err);
                },
                () => console.log(' Audit Territory Version List generated ')
            );
        }
    }

    GetSectionNames() {
        this.SectionList = ["Markets", "Territories", "Market Base", "Subscription", "Deliverables", "Maintenance", "User Management"];
        if (this.SectionList != null && this.SectionList.length > 0) {
            this.SectionName = this.SectionList[0];
        }
    }


    GetReportTypes(SectionName: string) {

        this.reportTypeList = [];
        if (SectionName == "Subscription") {
            this.reportTypeList = ['Period Changes', 'Market Base Changes'];
        }
        if (SectionName == "Deliverables") {
            this.reportTypeList = ['Report Parameter Changes', 'Market Definition Changes', 'Territory Definition Changes'];
        }

        if (SectionName == "Territories") {
            this.reportTypeList = ['Name and Id Changes', 'Allocation Changes', 'Group Changes'];
        }

        if (SectionName == "User Management") {
            this.reportTypeList = ['User'];
        } else if (SectionName == "Market Base") {
            this.reportTypeList = ['Name Changes', 'Settings Changes'];
        } else if (SectionName == "Markets") {
            //this.reportTypeList = ['Market Definition Name Changes', 'Market Base Setting Changes', 'Market Definition Packs Changes', 'Group Information Changes'];
            this.reportTypeList = ['Name Changes', 'Market Base Changes', 'Pack Changes', 'Group Changes'];
        }
        if (this.SectionName == "Maintenance") {
            this.reportTypeList = ["TDW Transfer"];
        }
        if (this.reportTypeList != null && this.reportTypeList.length > 0) {
            this.reportName = this.reportTypeList[0];
        }
    }

    GetAuditReport() {
        this.enabledReportDetails = false;

        if (this.SectionName == "User Management") {
            this.GetUserAudit();
        }
        else if (this.SectionName == "Maintenance") {
            this.GetTdwExportAudit();
        }
        else if (this.SectionName == "Market Base") {
            this.fnGetMarketbaseAudit();
        } else if (this.SectionName == "Markets") {
            this.fnGetMarketDefAudit();
        }
        else if (this.SectionName != null && this.EntityID != null && this.startVersionNo != null && this.endVersionNo != null && this.reportName != null
        ) {
            this.getAuditReportById(this.SectionName, this.EntityID, this.startVersionNo, this.endVersionNo, this.reportName);
            this.FullName = "Audit - " + this.SectionName + "  " + this.reportName;
        }
        else {
            this.IsParameterNotFound = true;
            this.ParamMissingMessage = " Please provide all Parameters to Generate Audit ! ";
            //if(this.startVersionNo == null)
            //{ 
            //    this.NoRecordsMessage = " Start Version is Missing !.Please select start Version "; 
            //}
            //if (this.endVersionNo == null) {
            //    this.NoRecordsMessage = " End Version is Missing !.Please select  End Version ";
            //}
        }
    }



    //User changes -- starts
    GetUsers() {
        this.NameList = [];
        this.clientService.fnSetLoadingAction(true);
        this.AuditVersionService.getUsers()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (response: any) => {
                this.NameList = response.data
                this.EntityID = this.NameList[0].ID;
            },
            (err: any) => {
                console.log(err);
            },
            () => console.log(' users added ')
            );
    }


    GetTdwClients() {
        this.NameList = [];
        this.clientService.fnSetLoadingAction(true);
        this.AuditVersionService.getTdwClients()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (response: any) => {
                this.NameList = response.data
                this.NameList.unshift({ ID: 0, Name: "All" })
                this.EntityID = this.NameList[0].ID;
            },
            (err: any) => {
                console.log(err);
            },
            () => console.log(' users added ')
            );
    }

    GetUserAudit() {
        this.IsRecordFound = false;
        this.enabledReportDetails = true;
        if (/*this.durationStartDateDeli && this.durationEndDate &&*/ this.EntityID > 0) {
            let sDate = this.durationStartDateDeli ? this.dServie.getDatefromDatePickerModel(this.durationStartDateDeli) : "";
            let eDate = this.durationEndDate ? this.dServie.getDatefromDatePickerModel(this.durationEndDate) : "";
            let entityName = this.NameList.filter(n => n.ID == this.EntityID)[0].Name;
            this.clientService.fnSetLoadingAction(true);
            this.AuditVersionService.GetUserAudit(this.EntityID, sDate, eDate, entityName)
                .finally(() => this.clientService.fnSetLoadingAction(false))
                .subscribe(
                (response: any) => {
                    
                    if (response) {
                        
                        this.auditReportData = response.data || [];
                        this.auditReportSettings.tableName = "Audit - User";
                        this.auditReportSettings.tableColDef = [
                                { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                                { headerName: 'User Name', width: '10%', internalName: 'User Name', sort: true, type: "", onClick: "" },
                                { headerName: 'User Id', width: '10%', internalName: 'User Id', sort: true, type: "", onClick: "" },
                                { headerName: 'User Role', width: '10%', internalName: 'User Role', sort: true, type: "", onClick: "" },
                                { headerName: 'Client', width: '10%', internalName: 'Client', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '10%', internalName: 'Done By', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'Date Time', sort: false, type: "", onClick: "" }                           
                            ]

                        
                    }
                },
                (err: any) => {
                    console.log(err);
                },
                () => console.log('User report completed ')
                );
        }
    }

    GetTdwExportAudit() {
        this.enabledReportDetails = true;
        this.IsRecordFound = false;
        let sDate = this.durationStartDateDeli ? this.dServie.getDatefromDatePickerModel(this.durationStartDateDeli) : "";
        let eDate = this.durationEndDate ? this.dServie.getDatefromDatePickerModel(this.durationEndDate) : "";
        let entityName = this.NameList.filter(n => n.ID == this.EntityID)[0].Name;
        this.clientService.fnSetLoadingAction(true);
        this.AuditVersionService.GetTdwAudit(this.EntityID, sDate, eDate, entityName)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (response: any) => {
                if (response) {
                    this.auditReportData = response.data || [];
                    this.auditReportSettings.tableName = "Audit - TDW Tranfer";
                    this.auditReportSettings.tableColDef = [
                        { headerName: 'Transfer Version Id', width: '10%', internalName: 'TransferVerisonNumber', sort: true, type: "", onClick: "" },
                        { headerName: 'Client Id', width: '10%', internalName: 'ClientId', sort: true, type: "", onClick: "" },
                        { headerName: 'Item Type', width: '10%', internalName: 'ItemType', sort: true, type: "", onClick: "" },
                        { headerName: 'Item Id', width: '10%', internalName: 'ItemId', sort: true, type: "", onClick: "" },
                        { headerName: 'Name', width: '10%', internalName: 'Name', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted Item Version', width: '10%', internalName: 'SubmittedItemVersion', sort: true, type: "", onClick: "" },
                        { headerName: 'Period Type', width: '10%', internalName: 'PeriodType', sort: true, type: "", onClick: "" },
                        { headerName: 'Period', width: '10%', internalName: 'Period', sort: true, type: "", onClick: "" },
                        { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                        { headerName: 'Date Time', width: '10%', internalName: 'TimeOfSubmission', sort: false, type: "", onClick: "" }
                    ]
                }
            },
            (err: any) => {
                console.log(err);
            },
            () => console.log('User report completed ')
            );
    }

    fnGetMarketbaseAudit() {
        if (this.EntityID > 0) {
            this.enabledReportDetails = true;
            this.alertService.fnLoading(true);
            let sDate = this.durationStartDateDeli == null ? null : this.dServie.getDatefromDatePickerModel(this.durationStartDateDeli);
            let eDate = this.durationEndDate == null ? null : this.dServie.getDatefromDatePickerModel(this.durationEndDate);
            this.AuditVersionService.getAuditReport(this.SectionName, this.EntityID, this.startVersionNo, this.endVersionNo, this.reportName).subscribe(
                (response: any) => {
                    if (response) {
                        this.auditReportData = response || [];
                        this.auditReportData.forEach((rec: any) => {
                            rec.DateTime = rec.DateTime == null ? "" : rec.DateTime.replace("T", " ").substring(0, 19);
                        });

                        if (this.reportName == 'Settings Changes') {
                            this.auditReportSettings.tableName = "Audit - Settings Changes";
                            this.auditReportSettings.tableColDef = [
                                { headerName: 'Market Base Name', width: '10%', internalName: 'MarketBaseName', sort: true, type: "", onClick: "" },
                                { headerName: 'Settings', width: '30%', internalName: 'Settings', sort: true, type: "", onClick: "" },
                                { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '8%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" },
                                { headerName: 'Total Count of Packs', width: '12%', internalName: 'PackCount', sort: true, type: "", onClick: "" }
                            ]
                        } else {
                            this.auditReportSettings.tableName = "Audit - Name Changes";
                            this.auditReportSettings.tableColDef = [
                                { headerName: 'Market Base Name', width: '10%', internalName: 'MarketBaseName', sort: true, type: "", onClick: "" },
                                { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '8%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                            ]

                        }
                        this.alertService.fnLoading(false);
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    console.log(err);
                },
                () => console.log('User report completed ')
            );
        } else {
            this.alertService.alert("System has failed to generate the report.");
        }
    }

    fnGetMarketDefAudit() {
        //if (this.durationStartDateDeli && this.durationEndDate && this.EntityID > 0) {
        if (this.EntityID > 0) {
            this.enabledReportDetails = true;
            this.alertService.fnLoading(true);
            let sDate = this.durationStartDateDeli == null ? null : this.dServie.getDatefromDatePickerModel(this.durationStartDateDeli);
            let eDate = this.durationEndDate == null ? null : this.dServie.getDatefromDatePickerModel(this.durationEndDate);
            this.AuditVersionService.getAuditReport(this.SectionName, this.EntityID, this.startVersionNo, this.endVersionNo, this.reportName).subscribe(
                (response: any) => {
                    if (response) {
                        this.auditReportData = response || [];
                        this.auditReportData.forEach((rec: any) => {
                            rec.DateTime = rec.DateTime == null ? "" : rec.DateTime.replace("T", " ").substring(0, 19);
                        });

                        if (this.reportName == 'Name Changes') {
                            this.auditReportSettings.tableName = "Audit - Name Changes";
                            this.auditReportSettings.tableColDef = [
                                { headerName: 'Market Definition Name', width: '10%', internalName: 'MarketDefName', sort: true, type: "", onClick: "" },
                                { headerName: 'Version Number', width: '30%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" },
                            ]
                        } else if (this.reportName == 'Pack Changes') {
                            this.auditReportSettings.tableName = "Audit - Pack Changes";
                            this.auditReportSettings.tableColDef = [
                                { headerName: 'PFC', width: '10%', internalName: 'PFC', sort: true, type: "", onClick: "" },
                                { headerName: 'Pack Description', width: '10%', internalName: 'PackDescription', sort: true, type: "", onClick: "" },
                                { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                                { headerName: 'MarketBase', width: '10%', internalName: 'MarketBase', sort: true, type: "", onClick: "" },
                                { headerName: 'Groups', width: '10%', internalName: 'Groups', sort: true, type: "", onClick: "" },
                                { headerName: 'Factor', width: '10%', internalName: 'Factor', sort: true, type: "", onClick: "" },
                                { headerName: 'Version Number', width: '10%', internalName: 'Version', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '8%', internalName: 'ActionBy', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                            ]

                        } else if (this.reportName == 'Market Base Changes') {
                            this.auditReportSettings.tableName = "Audit - Market Base Changes";
                            this.auditReportSettings.tableColDef = [
                                { headerName: 'Market Base Name', width: '10%', internalName: 'MBName', sort: true, type: "", onClick: "" },
                                { headerName: 'Data Refresh Settings', width: '10%', internalName: 'DataRefreshSettings', sort: true, type: "", onClick: "" },
                                { headerName: 'Filter', width: '10%', internalName: 'Filter', sort: true, type: "", onClick: "" },
                                { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                                { headerName: 'Version Number', width: '10%', internalName: 'Version', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '8%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                            ]
                        } else if (this.reportName == 'Group Changes') {
                            this.auditReportSettings.tableName = "Audit - Group Changes";
                            this.auditReportSettings.tableColDef = [
                                { headerName: 'Group Name', width: '15%', internalName: 'GroupName', sort: true, type: "", onClick: "" },
                                { headerName: 'Market Attribute', width: '15%', internalName: 'MarketAttribute', sort: true, type: "", onClick: "" },
                                { headerName: 'PFC', width: '10%', internalName: 'PFC', sort: true, type: "", onClick: "" },
                                { headerName: 'Pack Description', width: '20%', internalName: 'PackDescription', sort: true, type: "", onClick: "" },
                                { headerName: 'Action', width: '10%', internalName: 'Action', sort: true, type: "", onClick: "" },
                                { headerName: 'Version Number', width: '10%', internalName: 'Version', sort: true, type: "", onClick: "" },
                                { headerName: 'Submitted By', width: '10%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
                                { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" }
                            ]
                        }
                        this.alertService.fnLoading(false);
                    }
                },
                (err: any) => {
                    this.alertService.fnLoading(false);
                    console.log(err);
                },
                () => console.log('User report completed ')
            );
        } else {
            this.alertService.alert("System has failed to generate the report.");
        }
    }
    setHeaders() {
        if (this.ReportList && this.ReportList.length > 0) {
            this.keys = Object.keys(this.ReportList[0]);
            this.headerkeys = Object.keys(this.ReportList[0]);
        }
    }

    //User changes -- ends

    public auditReportSettings = {
        tableID: "static-table",
        tableClass: "table table-border ",
        tableName: "Marketbase Settings Changes",
        enableSerialNo: false,
        tableRowIDInternalName: "PFC",
        tableColDef: [
            { headerName: 'Market Base Name', width: '10%', internalName: 'MarketBaseName', sort: true, type: "", onClick: "" },
            { headerName: 'Settings', width: '30%', internalName: 'Settings', sort: true, type: "", onClick: "" },
            { headerName: 'Version Number', width: '10%', internalName: 'VersionNumber', sort: true, type: "", onClick: "" },
            { headerName: 'Submitted By', width: '8%', internalName: 'SubmittedBy', sort: true, type: "", onClick: "" },
            { headerName: 'Date Time', width: '10%', internalName: 'DateTime', sort: true, type: "", onClick: "" },
            { headerName: 'Total Count of Packs', width: '12%', internalName: 'PackCount', sort: true, type: "", onClick: "" }
        ],
        enableSearch: true,
        pageSize: 500,
        enabledColumnFilter: true,
        displayPaggingSize: 5,
        pTableStyle: {
            tableOverflowY: true,
            overflowContentHeight: '370px'
        }
    };

    public auditReportData = [];
    fnChangeReportName() {
        this.enabledReportDetails = false;
        this.auditReportData=[];
    }
    fnDateFormat(pDate: any, defaultDate: string = null) {
        let returnDate = defaultDate;
        if (pDate != null && pDate != '') {
            returnDate = pDate.date.year + '-' + (pDate.date.month.toString().length > 1 ? pDate.date.month : '0' + pDate.date.month)
                + '-' + (pDate.date.day.toString().length > 1 ? pDate.date.day : '0' + pDate.date.day);
        }

        return returnDate
    }
}