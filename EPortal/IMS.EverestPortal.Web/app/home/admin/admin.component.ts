import { Component, OnInit, OnChanges, Input, ViewChild } from '@angular/core';
import { Http } from '@angular/http';
import { NgForm } from '@angular/forms';
import { AdminService } from './admin.service';
import { IFile } from '../../shared/file.interface';
import { Summary, PopularLinks, CADPages, Listings, MonthlyNewProduct, NewsAlert, Test, Email } from '../../shared/model';
import { LayoutService } from '../../shared/layout.service';

import { CookieService } from 'angular2-cookie/services/cookies.service';
import { Client } from '../../shared/models/client';
import { CLIENTS } from '../../shared/models/mock-clients';
import { ClientService } from '../../shared/services/client.service';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../../security/auth.service';
import { UserPermission } from '../../shared/model';
import { ConfigUserAction } from '../../shared/services/config.userAction';
import { ConfigService } from '../../config.service';
import { ModalDirective } from 'ng2-bootstrap';


declare var jQuery: any;
declare var jsPDF: any;


@Component({
    selector: 'admin',
    templateUrl: '../../../app/home/admin/admin.component.html',
    providers: [AdminService, LayoutService],
    styleUrls: ['../../../app/home/admin/admin.component.css']

})
export class AdminComponent implements OnInit, OnChanges {

    @ViewChild('lgModal1') lgModal1: ModalDirective
    @ViewChild('uploadModal') uploadModal: ModalDirective
    title = 'Home Content Administration';
    count = 0;
    newsTitle = 'news title';
    fileuploadURL: string; // ='http://localhost:54033/api/GetAUSDDDSummary';
    apiURL: string;
    showArchive: boolean = false;
    fileName: string;
    fileToUpload: File;
    errorMessage: string;
    files: IFile[];
    pageTitle: string = '';
    Msg: string = "some name";
    summaries: Summary[] = [];
    listings: Listings[] = [];
    newProducts: MonthlyNewProduct[] = [];
    newsAlerts: NewsAlert[] = [];

    CADpages: CADPages[] = [];
    popularLinks: PopularLinks[] = [];
    newLink: PopularLinks = new PopularLinks(0, '', '', null);
    emails: Email[] = [];
    emailList: string = "";
    link: string = ConfigService.getWebAppUrl("LandingPage_Files/");
    newslink: string = ConfigService.getWebAppUrl("News_Files/");

    baseUrl: string = ConfigService.baseWebAppUrl;
    contentType: string = "News Alert - ";
    broadcastFile: string = "";
    contentDesc: string = "";
    filelistURL: string = ConfigService.getApiUrl("GetAUSDDDSummary");
    pharmlistUrl: string = ConfigService.getApiUrl("GetPharmacyListing");
    //hospitallistUrl: string = ConfigService.getApiUrl("GetHospitalListing");
    newproductlistUrl: string = ConfigService.getApiUrl("GetMonthlyNewProducts");
    pharmCADUrl: string = ConfigService.getApiUrl("GetMonthlyPharmacyCADPages");
    hospitalCADUrl: string = ConfigService.getApiUrl("GetMonthlyHospitalCADPages");
    newsUrl: string = ConfigService.getApiUrl("GetNewsAlert");
    isClickedOnce: boolean = false;
    fileType: string = "";
    isModifyTileNames: boolean = false;
    isModifyPopularLinks: boolean = false;

    constructor(private _adminService: AdminService, private _layoutService: LayoutService, private _authService: AuthService, private _cookieService: CookieService) {

    }

    ngOnInit(): void {
        this.loadUserData();
        this.getSummaries();

    }
    ngOnChanges(changes: any) {
        //this._layoutService.getPopularLinks()
        //    .subscribe(links => this.popularLinks = links, error => this.errorMessage = <any>error);

        this._layoutService.getPopularLinks().then((d) => {
            this.popularLinks = d;
        });
    }

    private loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this._authService.getInitialRoleAccess('Admin', 'Content Administration', roleid).subscribe(
                (data: any) => (this.checkAccess(data)),
                (err: any) => {
                    console.log(err);
                }
            );
        }
    }

    private checkAccess(data: UserPermission[]) {
        for (let p of data) {
            if (p.ActionName == ConfigUserAction.ModifyTileNames) {
                this.isModifyTileNames = true;
            }

            if (p.ActionName == ConfigUserAction.ModifyPopularLinks) {
                this.isModifyPopularLinks = true;
            }
        }
    }

    onSave() {
        //console.log(this.newsTitle);
        this.count++;
    };

    clicked(): boolean {
        return (this.count % 2 == 0);
    }

    getSummaries(): void {
        this.summaries.push(new Summary(1, '', ''));
        this.listings.push(new Listings(1, '', ''));
        this.newProducts.push(new MonthlyNewProduct(1, '', ''));
        this.CADpages.push(new CADPages(1, '', ''));
        this.newsAlerts.push(new NewsAlert(1, '', ''));
        this.newsAlerts.push(new NewsAlert(2, '', ''));

        this._layoutService.getMonthlyDataSummaries()
            .subscribe(summaries => this.summaries = summaries, error => this.errorMessage = <any>error);
        this._layoutService.getListings()
            .subscribe(listings => this.listings = listings, error => this.errorMessage = <any>error);

        //this._layoutService.getPopularLinks()
        //    .subscribe(links => this.popularLinks = links, error => this.errorMessage = <any>error);
        this._layoutService.getPopularLinks().then((d) => {
            this.popularLinks = d;
        });

        this._layoutService.getNewsAlerts("12")
            .subscribe(newsalerts => {
                this.newsAlerts = newsalerts;
            }, error => this.errorMessage = <any>error);

        this._layoutService.getCADPages()
            .subscribe(cadPages => this.CADpages = cadPages, error => this.errorMessage = <any>error);

        this._layoutService.getMonthlyNewProducts()
            .subscribe(monthlyNewProducts => this.newProducts = monthlyNewProducts, error => this.errorMessage = <any>error);
    }
    uploadFileModal(fileType: string) {
        this.fileToUpload = null;
        this.fileType = fileType;
        this.isClickedOnce = false;
        this.uploadModal.config.backdrop = 'static';
        this.uploadModal.config.keyboard = false;
        this.uploadModal.show();
    }
    private cancelUpload() {
        this.uploadModal.hide();
    }
    onChange($event: any): void {
        var target = $event.target || $event.srcElement;
        this.fileToUpload = target.files[0];

        this.fileName = target.files[0].name;
    }
    popularLinkFileChange($event: any): void {
        var target = $event.target || $event.srcElement;
        this.newLink.PopularLinkFile = target.files[0];

    }
    uploadFile(fileToUpload: File): void {
        // alert(this.fileName);
        this._adminService.uploadAFile(fileToUpload, this.fileName, this.fileType);

        this.uploadModal.hide();
    }

    saveSummary() {
        this._adminService.saveSummary(this.summaries[0]).then(
            () => {
                alert('Data Summary updated successfully.');
            });
    }
    saveListings() {
        this._adminService.saveListings(this.listings[0]).then(
            () => {
                alert('Listings updated successfully.');
            });
    }

    saveNewProducts() {
        this._adminService.saveNewProds(this.newProducts[0]).then(
            () => {
                alert('New Products updated successfully.');
            });
    }
    saveCADs() {
        this._adminService.saveCADs(this.CADpages[0]).then(
            () => {
                alert('CADs updated successfully.');
            });
    }
    saveNewsAlert(id: number, dbID: number) {
        if (this.newsAlerts[id].NewsAlertTitle.length > 70)
            alert('The news title that you have entered exceeds 70 characters, please note that this will cause the news title to appear with appending ‘…’' );

        if (this.newsAlerts[id].NewsAlertTitle != '' || (this.newsAlerts[id].NewsAlertDescription != '' && this.newsAlerts[id].NewsAlertDescription != null)) {
            this._adminService.updateNewsAlert(this.newsAlerts[id]).then(
                () => {
                    alert('News alert ' + (id + 1).toString() + ' updated successfully.');
                });
        }
    }
    broadcastNews(fileType: string) {
        this.isClickedOnce = false;
        this.setVariables(fileType);
        this.fileType = fileType;
        this._adminService.getEmails()
            .subscribe(emails => this.emails = emails, error => { this.errorMessage = <any>error; alert(this.errorMessage); },
            () => {
                this.emailList = "";
                for (var i = 0; i < this.emails.length; i++) {
                    this.emailList = this.emailList + this.emails[i].Email + "; ";
                }
                //alert(this.emailList);
            });

        this.lgModal1.config.backdrop = 'static';
        this.lgModal1.config.keyboard = false;
        this.lgModal1.show();
    }
    private setVariables(fileType: string) {
        this.broadcastFile = "";
        if (fileType.startsWith("News")) {
            this.contentDesc = "A News Alert has been uploaded to the Client Portal.";
            if (fileType.toLowerCase().startsWith("newsalert1"))
                this._layoutService.filelistUrl = this.newsUrl + "?newsType=1";
            else
                this._layoutService.filelistUrl = this.newsUrl + "?newsType=2";
            this._layoutService.getFiles()
                .subscribe(f => this.files = f, error => this.errorMessage = <any>error,
                () => {
                    this.broadcastFile = this.files[0].fileName;
                    this.contentType = "News Alert - " + this.removeExtension(this.broadcastFile);
                });
        }
        else {
            this.broadcastFile = "";
            if (fileType.startsWith("MonthlyDataSummary")) {
                this.contentType = "New File - Monthly Data Summary";
                // this._layoutService.filelistUrl = this.filelistURL;
                this.contentDesc = "Monthly Data Summary";
            }
            if (fileType.startsWith("MonthlyNewProduct")) {
                this.contentType = "New File - Monthly New Product List";
                // this._layoutService.filelistUrl = this.newproductlistUrl;
                this.contentDesc = "Monthly New Product List";
            }
            if (fileType.startsWith("Listings")) {
                this.contentType = "New File - Listings";
                // this._layoutService.filelistUrl = this.newproductlistUrl;
                this.contentDesc = "Listings";
            }
            if (fileType.startsWith("CADPages")) {
                this.contentType = "New File - CADPages";
                // this._layoutService.filelistUrl = this.newproductlistUrl;
                this.contentDesc = "CADPages";
            }

        }

    }
    private removeExtension(filename: string) {
        if (filename != null && filename != "")
        {
            var lastDotPosition = filename.lastIndexOf(".");
            if (lastDotPosition === -1)
                return filename;
            return filename.substr(0, lastDotPosition);
        }
        return filename;
    }
    sendEmails() {
        this.isClickedOnce = true;
        this._adminService.sendEmail(this.contentType, this.baseUrl, this.broadcastFile, this.contentDesc).then(
            () => {
                alert('email sent successfully.');
                this.lgModal1.hide();
            });
    }

    private cancelBroadcast() {
        this.lgModal1.hide();
    }


    saveLink() {
        var isExist = this.popularLinks.findIndex(x => x.PopularLinkTitle.trim() == this.newLink.PopularLinkTitle.trim());
        if (this.newLink.PopularLinkId == null || this.newLink.PopularLinkId == 0) {
            if (this.newLink.PopularLinkTitle != '' || this.newLink.PopularLinkDescription != '') {
                if (isExist === -1) {
                    this._adminService.addLink(this.newLink).then(
                        () => {

                            //this._layoutService.getPopularLinks()
                            //    .subscribe(links => this.popularLinks = links, error => this.errorMessage = <any>error)
                            if (this.newLink.PopularLinkFile != null) {
                                var extension = this.newLink.PopularLinkFile.name.slice(this.newLink.PopularLinkFile.name.indexOf("."));
                                this._adminService.uploadAFile(this.newLink.PopularLinkFile, this.newLink.PopularLinkTitle + extension, 'PopularLinks');
                            }

                            this._layoutService.getPopularLinks().then((d) => {
                                this.popularLinks = d;
                            });

                            this.newLink.PopularLinkTitle = '';
                            this.newLink.PopularLinkDescription = '';
                            this.newLink.PopularLinkId = null;
                            this.newLink.PopularLinkFile = null;
                        });
                }
                else {
                    alert("Title already exist.");
                }
            }
        }
        else {
            if (this.newLink.PopularLinkTitle != '' || (this.newLink.PopularLinkDescription != '' && this.newLink.PopularLinkDescription != null)) {
                for (var i = 0; i < this.popularLinks.length; i++) {
                    if (this.popularLinks[i].PopularLinkId == this.newLink.PopularLinkId) {
                        var j = i;
                        //console.log(this.newLink.PopularLinkId);
                        // console.log(this.popularLinks[i].PopularLinkId);
                        if (this.popularLinks[i].PopularLinkTitle.trim() === this.newLink.PopularLinkTitle.trim()) {
                            isExist = -1;
                        }

                        if (isExist === -1) {
                            this._adminService.updateLink(this.newLink).then(
                                () => {
                                    if (this.newLink.PopularLinkFile != null) {
                                        var extension = this.newLink.PopularLinkFile.name.slice(this.newLink.PopularLinkFile.name.indexOf("."));
                                        this._adminService.uploadAFile(this.newLink.PopularLinkFile, this.newLink.PopularLinkTitle + extension, 'PopularLinks');
                                    }

                                    this._layoutService.getPopularLinks().then((d) => {
                                        this.popularLinks = d;
                                    });

                                    //this.popularLinks[j] = this.newLink;
                                    this.newLink.PopularLinkTitle = '';
                                    this.newLink.PopularLinkDescription = '';
                                    this.newLink.PopularLinkId = null;
                                    this.newLink.PopularLinkFile = null;
                                    //this._layoutService.getPopularLinks()
                                    //    .subscribe(links => this.popularLinks = links, error => this.errorMessage = <any>error)

                                });
                        }
                        else {
                            alert("Title already exist.");
                        }
                    }
                }

            }
        }

    }
    editLink(id: number) {
        for (var i in this.popularLinks) {
            if (this.popularLinks[i].PopularLinkId == id) {
                //console.log('popLinkId: ' + this.popularLinks[i].PopularLinkId);
                this.newLink.PopularLinkId = this.popularLinks[i].PopularLinkId;
                this.newLink.PopularLinkTitle = this.popularLinks[i].PopularLinkTitle;
                this.newLink.PopularLinkDescription = this.popularLinks[i].PopularLinkDescription;
            }
        }

    }
    cancelLink() {
        this.newLink.PopularLinkTitle = '';
        this.newLink.PopularLinkDescription = '';
        this.newLink.PopularLinkId = null;
        this.newLink.PopularLinkFile = null;
    }
    deleteLink(id: number) {
        for (var i = 0; i < this.popularLinks.length; i++) {
            if (this.popularLinks[i].PopularLinkId == id) {
                var j = i;
                // console.log(j);
                this._adminService.deleteLink(id).then(
                    () => {
                        this.popularLinks.splice(j, 1);
                    });
            }
        }

    }
    cancelSummary() {
        this._layoutService.getMonthlyDataSummaries()
            .subscribe(summaries => this.summaries = summaries, error => this.errorMessage = <any>error);
    };
    cancelListings() {
        this._layoutService.getListings()
            .subscribe(listings => this.listings = listings, error => this.errorMessage = <any>error);
    };
    cancelNewsAlerts(alertType: number) {
        this._layoutService.getNewsAlerts(alertType.toString())
            .subscribe(newsalerts => { this.newsAlerts[alertType] = newsalerts[0] }, error => this.errorMessage = <any>error);
    };
    cancelCADPages() {
        this._layoutService.getCADPages()
            .subscribe(cadPages => this.CADpages = cadPages, error => this.errorMessage = <any>error);
    };
    cancelNewProducts() {
        this._layoutService.getMonthlyNewProducts()
            .subscribe(monthlyNewProducts => this.newProducts = monthlyNewProducts, error => this.errorMessage = <any>error);
    };
}
