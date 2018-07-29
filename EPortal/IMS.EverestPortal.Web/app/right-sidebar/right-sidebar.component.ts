import { Component, Input, OnInit } from "@angular/core";
import { LayoutService } from '../shared/layout.service';
import { PopularLinks } from '../shared/model';
import { CommonService } from '../shared/common';
import { ConfigService } from '../config.service';

@Component({
    selector: 'app-right-sidebar',
    templateUrl: '../../app/right-sidebar/right-sidebar.component.html',
    styleUrls: ['../../app/content/css/side-bar.css']
})
export class RightSidebarComponent implements OnInit {

    popularLinks: PopularLinks[];
    popularLinksFolderPath: string = ConfigService.getWebAppUrl("PopularLinks/");

    constructor(private _layoutService: LayoutService) {
    }

    ngOnInit(): void {
        var t = CommonService.getCookie("token");
        if (t != null && t != '') {
            this.getLinks();
        }
    }

    async getLinks() {

        await this._layoutService.getPopularLinks().then((d) => {
            this.popularLinks = d;
        });
    }

    openLink(url: string): void {
        if (url != "" && url != null) {
            var isExist = url.indexOf("http");
            if (isExist === -1)
                url = "http://" + url;
            window.open(url, '_blank');
        }
    }

}