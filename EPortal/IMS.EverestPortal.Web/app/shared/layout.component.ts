import { Component, OnInit, OnChanges, Input } from "@angular/core";
import { Http } from '@angular/http';
import { LayoutService } from './layout.service';
import { PopularLinks, HomeContent, HomeFile } from './model'; //Summary,  CADPages, Listings, MonthlyNewProduct, NewsAlert,
import { IFile } from './file.interface';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';

@Component({
    selector: 'layout',
    templateUrl: '../../app/shared/layout.component.html',
    //template: '<div class="brand">navigation for {{title }}</div>',
    providers: [LayoutService],
    styleUrls: ['../../app/shared/layout.component.css']

})
export class LayoutComponent {

    @Input() title = '';
    market = '';
    CurrentMontlyDataSummary = '';
   
   // public popularLinks: PopularLinks[]=[];

    NewsAlert1_Title: string = '';
    NewsAlert1_Desc: string = '';
    NewsAlert2_Title: string = '';
    NewsAlert2_Desc: string = '';
    Listing_Title: string = '';
    Listing_Desc: string = '';
    Summary_Title: string = '';
    Summary_Desc: string = '';
    CAD_Title: string = '';
    CAD_Desc: string = '';
    Product_Title: string = '';
    Product_Desc: string = '';
    AllFiles: HomeFile[] = [];
        
    link: string = ConfigService.getWebAppUrl("LandingPage_Files/");
    newslink: string = ConfigService.getWebAppUrl("News_Files/");
    newsalert1link: string = ConfigService.getWebAppUrl("NewsAlert1/");
    newsalert2link: string = ConfigService.getWebAppUrl("NewsAlert2/");
    summaryFiles: string[] = [];
    pharmList: string[] = [];
    hospitalList: string[] = [];
    newproductList: string[]=[]; 
    pharmCAD: string[] = [];
    hospitalCAD: string[] = [];
    homeContent: HomeContent[];
    archives: IFile[];
    newsFiles: IFile[];
    newsFiles1: IFile[] = [];
    newsFiles2: IFile[] = [];
   
    @Input() newsUrl: string = ConfigService.getApiUrl("GetNewsArticleAll");
    newAlert1File: string = "";
    newAlert2File: string = "";

    errorMessage: string;

    constructor(private layoutService: LayoutService) {
    }

    ngOnInit(): void {
        var t = CommonService.getCookie("token");
        if (t != null && t != '') {
            this.getHomeContent();
            this.getFiles();
            this.getNews();
        }
    }
    
    async getHomeContent() {
        await this.layoutService.getLandingPageContents().then((f) => {
            this.homeContent = f;
           
            for (var i = 0; i < f.length; i++) {
                if (f[i].ContentType == 'CAD') {
                    this.CAD_Title = f[i].Title;
                    this.CAD_Desc = f[i].Desc;
                }
                if (f[i].ContentType == 'DataSum') {
                    this.Summary_Title = f[i].Title;
                    this.Summary_Desc = f[i].Desc;
                }
                if (f[i].ContentType == 'Listing') {
                    this.Listing_Title = f[i].Title;
                    this.Listing_Desc = f[i].Desc;
                }
                if (f[i].ContentType == 'NewProduct') {
                    this.Product_Title = f[i].Title;
                    this.Product_Desc = f[i].Desc;
                }
                if (f[i].ContentType == 'News1') {
                    if (f[i].Title.length <= 70)
                        this.NewsAlert1_Title = f[i].Title;
                    else 
                        this.NewsAlert1_Title = f[i].Title.substring(0,70) +'...';
                    
                    this.NewsAlert1_Desc = f[i].Desc.substring(0, 250) + '...';
                }
                if (f[i].ContentType == 'News2') {
                    if (f[i].Title.length <= 70)
                        this.NewsAlert2_Title = f[i].Title;
                    else
                        this.NewsAlert2_Title = f[i].Title.substring(0, 70) + '...';
                
                    this.NewsAlert2_Desc = f[i].Desc.substring(0, 250) + '...';
                }
                // side-bar
                //if (f[i].ContentType == 'Link') {
                    //var l: PopularLinks = new PopularLinks(0, '', '');
                    //l.PopularLinkId = f[i].Id;
                    //l.PopularLinkTitle = f[i].Title;
                    //l.PopularLinkDescription = f[i].Desc; 
                    //this.popularLinks.push(l);
               // }
            }
        });

    }
    async getFiles() {
     
        await this.layoutService.getAllFiles().then((f) => {
            this.AllFiles = f;

            for (var i = 0; i < f.length; i++) {
                if (f[i].fileType == 'PCAD') {
                    this.pharmCAD.push(f[i].fileName);
                }
                if (f[i].fileType == 'HCAD') {
                    this.hospitalCAD.push(f[i].fileName);
                }
                if (f[i].fileType == 'Sum') {
                    this.summaryFiles.push(f[i].fileName);
                }
                if (f[i].fileType == 'PListing') {
                    this.pharmList.push(f[i].fileName);
                }
                if (f[i].fileType == 'Prod') {
                    this.newproductList.push(f[i].fileName);
                }
                if (f[i].fileType == 'HListing') {
                    this.hospitalList.push(f[i].fileName);
                }
            }

        });

    }
    async getNews() {
     
        this.layoutService.filelistUrl = this.newsUrl;

        await this.layoutService.getFilesPromise().then((f) => {
            this.newsFiles = f;
            if (f.length > 0)
                this.newAlert1File = f[0].fileName;
            if (f.length > 1)
                this.newAlert2File = f[1].fileName;
            for (var i = 2; i < Math.ceil((f.length - 2) / 2.0) + 2; i++)
                this.newsFiles1.push(this.newsFiles[i]);
            for (var i = Math.ceil((f.length - 2) / 2.0) + 2; i < f.length; i++)
                this.newsFiles2.push(this.newsFiles[i]);
        });
    }


    downloadFile(fileName: string, newsFlag:string): void {
     
        this.layoutService.getFileFromBackend(fileName, newsFlag)
            .then(
            u => {
                //console.log('u:' + u);
                var file = u._body;
                //console.log('f:' + file);
                this.showFile(file, fileName);
            });
    }

    showFile(data: string, fileName: string) {
        var fileExt = fileName.substring(fileName.lastIndexOf('.') + 1);
       
        var blob = new Blob([data], { type: "application/" + fileExt });
        var url = window.URL.createObjectURL(blob);
      
        var a = document.createElement("a");
        a.href = url;
        a.download = fileName; 
        document.body.appendChild(a);
        a.click();
    }
   
}