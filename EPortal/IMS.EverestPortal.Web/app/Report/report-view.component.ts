import { ViewChild,Component, OnInit, Input } from '@angular/core';
import { Router } from "@angular/router";
import { ReportService } from '../Report/report.service';
import { Location } from '@angular/common';
import { ReportFilterService } from '../Report/reportfilter.service';
import { ClientService } from '../shared/services/client.service';
import { DomSanitizer } from '@angular/platform-browser';
import { ModalDirective } from 'ng2-bootstrap';
import { Observable } from 'rxjs/Observable';



@Component({
    selector: `report-view`,
    templateUrl: `../../app/Report/report-view.html`,
    providers: [ReportFilterService],
    styleUrls: ['../../app/Report/report-view.css','../../app/shared/component/p-table/p-table.component.css']
})



export class ReportViewComponent {
    @ViewChild('warningAboutReportModal') warningAboutReportModal: ModalDirective;

    searchQuery: any = {};
    downLoadQuery: any = {};
    appliedFilters: any[] = [];
    filterName: any = {};
    selected: boolean = true;
    OutofMemoryError: string;

    reports: any[] = [];
    public reportTableBind: any;
    public reportTableColumnDef: any[] = []
    public columns: any[] = [];
    @Input() selectedcolumns: string[] = [];

    //Sort
    isAsc: boolean = false;
    SortBy: string = "";//This param is used to determine which column to use for sorting
    Direction: number = 1;//1 is ascending -1 is descending
    orderBy: string = "";
    orderColumn: string = "";
    ReportName: string = "";
    Sort(key: string, dir: boolean) {
        dir = !dir;
          for (let it in this.columns) {               
                if (key == this.columns[it].name)
                    this.columns[it].sorted = true;
                else
                    this.columns[it].sorted = false;
            }
            this.SortBy = key;
            this.Direction = this.isAsc == true ? 1 : -1;
            this.isAsc = dir;// == 1 ? true : false;
            //console.log("dir" + this.Direction + "isAsc: " + this.isAsc);
           
            this.orderBy = this.isAsc ? "asc" : "desc";
            this.orderColumn = key;
            this.searchQuery.orderBy = this.orderBy;            
            this.searchQuery.orderColumn = this.orderColumn;
            this.loadReport(this.searchQuery);
           // this.isAsc = !this.isAsc;
      
            
    }

    constructor(private reportService: ReportService,
        private reportFilterService: ReportFilterService,
        private location: Location,
        private clientService: ClientService, private router: Router) {
        
    }   

    ngOnInit(): void {
        this.searchQuery = this.reportService.getSearchQuery();
        if (!this.searchQuery) {
            this.router.navigateByUrl('/report');
            return;
        }
        this.appliedFilters = this.searchQuery.fields;
        this.filterName = this.searchQuery.prevFilter;

        if (!this.searchQuery) return;
        if (!this.searchQuery.fields) return;

        for (let field of this.appliedFilters) {

            let selectedValues = field.fieldValues.map(function (fv) {
                return fv.Text;
            }).join(',');

            field.selectedValues = selectedValues;
        }
       
        this.searchQuery.CurrentPage = 1;
        this.searchQuery.NumberOfRecords = this.itemsPerPage;
        
        this.loadReport(this.searchQuery);
    }

    loadReport(query: any): void {

        this.clientService.fnSetLoadingAction(true);               
        this.reportFilterService.GetReports(query)

            .finally(() => {
                this.clientService.fnSetLoadingAction(false);
            })
            .subscribe((res) => { console.log(res), this.LoadGrid(res) }),
            (err => {
                this.handleError;
                //this.warningAboutReportModal.show()
            }
            ),
            (() => console.log("search completd"));
    }

   
    gridData: any[] = [];
    public ReportTableSettings = {

        tableID: "static-table",
        tableClass: "table table-border ",
        tableName: "Pack Search",
        tableRowIDInternalName: "PFC",

        tableColDef: [],
        enableSearch: false,
        pageSize: 500,

        tableHeaderFooterVisibility: false,
        enablePagination: false,
        enabledColumnFilter: false,
        enabledFixedHeader: true,
        enabledServerSideAction: true,
        defaultSorting: { sortingOrder: "asc" },
        pTableStyle: {

            tableOverflow: true,
            overflowContentWidth: '160%',
            overflowContentHeight: '428px',

        }

    };

    public cellFixedWidth: number = 0;

    serversideFuntion(event : any) {
        console.log(event);

        //this.orderBy = this.isAsc ? "asc" : "desc";
        //this.orderColumn = event.colName;
        //this.searchQuery.orderBy = event.orderTo;
        //this.searchQuery.orderColumn = this.orderColumn;
        //this.loadReport(this.searchQuery);
    }
    getVisibleHeaderColumns(): string[] {
        this.ReportTableSettings.tableColDef = [];
        let visibleCell = this.columns.filter(col => col.visible == true) || [];
        this.cellFixedWidth = 100 / visibleCell.length;
        console.log("visibleCell", visibleCell)
        //************ bind table column***********************//

        if (visibleCell.length < 7) {
            this.ReportTableSettings.pTableStyle.overflowContentWidth = "100%";
        }
        this.columns.forEach((rec: any) => {
            if (rec.visible) {
                this.ReportTableSettings.tableColDef.push({ headerName: rec.name, width: this.cellFixedWidth + '%', internalName: rec.name, sort: true, type: "", onClick: "", visible: rec.visible });
            }
        });

        return this.columns.filter(col => col.visible == true).map(function (col) {
            return col;
        });

       
        //this.ptable="100%"; if(numOfCol<5){ this.ReportTableSettings.pTableStyle.overflowContentWidth="100%"}
    }
    
    LoadGrid(res: any): void {
        this.reports = res.data;
        if (this.reports != null && this.reports.length > 0) {
            this.reports.forEach(function (v) {
                for (let p in v) {                    
                    if (p == "Product Price") {
                        if (v[p] != null) {
                            v[p] = v[p].toFixed(2);
                        }
                    }
                }
            });
        }        
        let data = res.data;
        this.columns = this.getColumns();
        this.getVisibleHeaderColumns();
        if (this.columns && this.columns.length > 0) {
            this.gridData = res.data;
        }
        this.totalRecordCounts = res.TotalCount; 
        
    }

    getColumns(): string[] {

        if (this.columns && this.columns.length > 0) {
            return this.columns;
        }
        let cols = [];
        let columnsDefinition = [];
        if (this.reports && this.reports.length > 0) {
            let obj = this.reports[0];            
            cols = Object.keys(obj);
            for (let c of cols) {
                let cd:any = {};
                cd.sorted = false;
                cd.visible = true;
                cd.name = c;
                columnsDefinition.push(cd);
            }
        }
        return columnsDefinition;
    }

    getReportName(id: number, type: string): string {
        let ReportName: string
        if (id == 1) {
            ReportName = "ECPMarketReport" + type;
        }
        if (id == 2) {
            ReportName = "ECPSubscriptionDeliverablesReport" + type;
        }
        if (id == 3) {
            ReportName = "ECPTerritoriesReport" + type;
        }
        if (id == 6) {
            ReportName = "ECPAllocationReport "+ type;
        }
        if (id == 7) {
            ReportName = "ECPReleaseReport " + type;
        }

        if (id == 8) {
            ReportName = "ECPUserMangementReport " + type;
        }
        return ReportName;
    }

    handleError(error: any): Promise<any> {
        let errMsg: string;
        const body = error.json() || '';
        const err = body.error || JSON.stringify(body);
        errMsg = `${error.status} - ${error.statusText || ''} ${err}`;

        alert(errMsg);
        console.error('An error occurred', error);
        return Promise.reject(error.message || error);
    }

    back(): void {

        this.reportService.setSearchQuery(this.searchQuery);
        this.location.back();
    }

    exportCSV(): void {
        this.searchQuery = this.reportService.getSearchQuery();
        this.downLoadQuery = {
            columns: this.searchQuery.columns,
            fields: this.searchQuery.fields,
            sectionId: this.searchQuery.sectionId,
        };
        this.downLoadQuery.ExportType = "csv";
        this.clientService.fnSetLoadingAction(true); 
        this.reportFilterService.downloadReport(this.downLoadQuery)
            .finally(() => {
                this.clientService.fnSetLoadingAction(false)
            })
            .subscribe((res) => {
                var downloadUrl = URL.createObjectURL(res);
                let sectionIdvalue: number = this.downLoadQuery.sectionId;

                const pdfUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetapplication/pdf' }));

                if (navigator.msSaveOrOpenBlob) {
                    navigator.msSaveOrOpenBlob(res, this.getReportName(sectionIdvalue, ".csv"));
                }
                else {
                    const anchor = document.createElement('a');
                    anchor.download = this.getReportName(sectionIdvalue, ".csv");
                    anchor.href = pdfUrl;
                    anchor.click();
                }               
            }),
            (err => console.log(err)),
            (() => console.log("export excel completd"));
    }

    exportXLS(): void {
        this.searchQuery = this.reportService.getSearchQuery();
        this.downLoadQuery = {
            columns: this.searchQuery.columns,
            fields: this.searchQuery.fields,
            sectionId: this.searchQuery.sectionId,
            //this.searchQuery.section
        };
        this.downLoadQuery.ExportType = "xlsx";
        this.clientService.fnSetLoadingAction(true);     
        this.reportFilterService.downloadReport(this.downLoadQuery)
            .finally(() => {
                this.clientService.fnSetLoadingAction(false)
            })
            .catch(error => Observable.throw(error))
            .subscribe((res) => {
                var downloadUrl = URL.createObjectURL(res);
                let sectionIdvalue: number = this.downLoadQuery.sectionId;
                
              const pdfUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetapplication/pdf' }));

              if (navigator.msSaveOrOpenBlob) {
                  navigator.msSaveOrOpenBlob(res, this.getReportName(sectionIdvalue, ".xlsx"));
              }
              else {
                  const anchor = document.createElement('a');
                  anchor.download = this.getReportName(sectionIdvalue, ".xlsx");
                  //`ECPReport.xlsx`;
                  anchor.href = pdfUrl;
                  anchor.click();
              }
                
                //console.log(downloadUrl);
               // window.open(downloadUrl , "_blank");
                 }),
            (err => console.log(err)),
            (() => console.log("export excel completd"));
    }

        
    reportByPage: any[];
    public totalRecordCounts: number = this.gridData.length;
    public recordCurrentPage: number = 1;
    public itemsPerPage: number = 500;

    public pageChanged(event: any): void {
        this.searchQuery.CurrentPage = event.page;
        this.searchQuery.NumberOfRecords = this.itemsPerPage;
        this.loadReport(this.searchQuery);
    }

    setRecordPagination(): void {
        this.totalRecordCounts = this.gridData.length;
        this.pageChanged({ page: 1, itemsPerPage: this.itemsPerPage })
    }

}