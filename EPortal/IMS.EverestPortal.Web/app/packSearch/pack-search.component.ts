import { Component, ViewChild, ElementRef, OnInit, Pipe, PipeTransform, Renderer } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { PackSearchService } from './pack-search.service';
import { PackSearch, PackSearchFilter } from '../../app/shared/model'
import { SearchFilter } from '../../app/shared/model';
import { PaginationComponent } from 'ng2-bootstrap/ng2-bootstrap';
import { NgModel } from '@angular/forms';
import { Observable } from 'rxjs/Observable';
import { CsvService } from "angular2-json2csv";
import { PackSearchColumns } from './packSearch.columns';
import { SearchByNamePipe } from './search-pipe';
import { PackSearchResult } from '../../app/shared/model'
import { PackResultResponse } from '../../app/shared/model'

import { Atc, Nec, Manufacturer, Molecule, SearchFilterCondition, Product } from '../components/autocomplete/autocom.model';
import { Filter } from '../shared/component/p-autocomplete/p-autocom.model';
import { AutoCompleteService } from '../components/autocomplete/autocom.service';
import { ClientService } from '../shared/services/client.service';
import { PAutoCompleteComponent } from '../shared/component/p-autocomplete/p-autocom.component';

declare var jQuery: any;

@Component({
    selector: 'pack-search',
    templateUrl: '../../app/packSearch/pack-search.html',
    styleUrls: ['../../app/shared/component/p-table/p-table.component.css'],
    providers: [PackSearchService, SearchByNamePipe, AutoCompleteService]

    /*styleUrls: ['../../app/content/css/custom.css','../../app/content/css/news-section.css','../../app/content/css/side-bar.css','../../app/content/css/myClient.css']*/
})
export class PackSearchComponent {
    @ViewChild("atcAutocomplete") atcAutocomplete: PAutoCompleteComponent;
    @ViewChild("necAutocomplete") necAutocomplete: PAutoCompleteComponent;
    @ViewChild("moleculeAutocomplete") moleculeAutocomplete: PAutoCompleteComponent;
    @ViewChild("packAutocomplete") packAutocomplete: PAutoCompleteComponent;
    @ViewChild("manufacturerAutocomplete") manufacturerAutocomplete: PAutoCompleteComponent;
    @ViewChild("productAutocomplete") productAutocomplete: PAutoCompleteComponent;

    model: PackSearch = new PackSearch();
    packSearchFilter: PackSearchFilter = new PackSearchFilter();

    pack: PackSearchResult[] = [];
    recCount: number;
    errorMessage: string = '';
    isLoading: boolean = true;
    searchFltr: SearchFilter[] = [];
    packDescription: any;
    Columns: any = {};
    tempColumns: any[] = [];
    headerColumns: any = {};
    SortBy: string = "";//This param is used to determine which column to use for sorting
    Direction: number = 1;//1 is ascending -1 is descending
    isAsc: boolean = true;
    isSearch: boolean = false;
    searchName: string = "";
    colSearch: string = "";
    visibleColumns: any[] = [];
    isAdvanceSearch: boolean = false;
    startRecNo: number = 0;
    isExport: boolean = false;
    //autocom
    atcList: Atc[] = [];
    necList: Nec[] = [];
    mfrList: Manufacturer[] = [];
    moleculeList: Molecule[] = [];
    showMsg: boolean = false;
    public rowLimitArray: any[] = [10, 20, 50, 100, 200, 500, 1000];
    // Start Pagination 
    public totalItems: number = this.pack.length;
    public currentPage: number = 1;
    public itemsPerPage: number = 10;
    public rowPerPage: number = 10;

    constructor(private packSearchService: PackSearchService, private _csvService: CsvService,
        private _autocompleteService: AutoCompleteService, public renderer: Renderer, private clientService: ClientService) {
        this.model.ATC = "";
        this.model.PackDescription = "";
        this.Columns = PackSearchColumns;
    }
    ngOnInit() {
        //let eventObservable = Observable.fromEvent(this.input.nativeElement, 'keyup')
        //eventObservable.subscribe();
        this.tempColumns = PackSearchColumns;
        this.headerColumns = PackSearchColumns;
        this.isAdvanceSearch = false;
        this.getVisibleHeaderColumns();

        this.model.Flagging = "All";
        this.model.Branding = "All";

        this.showMsg = false

        this.itemsPerPage = 500;
        this.rowPerPage = 500;
    }
    public cellFixedWidth: number = 0;
    getVisibleHeaderColumns(): string[] {
        this.packSearchTableSettings.tableColDef = [];
        console.log("PackSearchColumns", PackSearchColumns);
        let visibleCell = PackSearchColumns.filter(col => col.visible == true) || [];
        this.cellFixedWidth = 100 / visibleCell.length;
        console.log("visibleCell", visibleCell, "this.cellFixedWidth", this.cellFixedWidth);

        //************ bind table column***********************//

        PackSearchColumns.forEach((rec: any) => {
            if (rec.visible) {
                this.packSearchTableSettings.tableColDef.push({ headerName: rec.colText, width: this.cellFixedWidth + '%', internalName: rec.colName, sort: rec.sortable, type: "", onClick: "", visible: rec.visible });
            }
        });

        return PackSearchColumns.filter(col => col.visible == true).map(function (col) {
            return col;
        });
    }


    public packSearchTableSettings = {
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
        pTableStyle: {
            tableOverflow: true,
            overflowContentWidth: '160%',
            overflowContentHeight: '428px',
        }
    };

    //getATC(keyword: any): Observable<any> {
    //    var filter: Filter[] = [];
    //    filter.push(new Filter("ATC", keyword, 'Add'));
    //    return this._autocompleteService.getAutocompleteList<Atc>('Atc', filter);
    //}

    //getNEC(keyword: any): Observable<any> {
    //    var filter: Filter[] = [];
    //    filter.push(new Filter("NEC", keyword, 'Add'));
    //    return this._autocompleteService.getAutocompleteList<Nec>('Nec', filter);
    //}

    //getMoleculeList(keyword: any): Observable<any> {

    //    var filter: Filter[] = [];
    //    filter.push(new Filter("Description", "*" + keyword + "*", 'Add'));
    //    return this._autocompleteService.getAutocompleteList<Molecule>("Molecule", filter);
    //}

    performSearch(form: any) {
        this.isSearch = true;
        this.isExport = false;
        this.showMsg = false;
        this.currentPage = 1;
        //this.model.searchOptions, this.model.searchString;
        // console.log('Model= ' + (this.model.Flagging ? this.model.Flagging : "blank"));
        this.clientService.fnSetLoadingAction(true);
        //this.rowPerPage = this.itemsPerPage;
        this.itemsPerPage = this.rowPerPage;

        //this.searchFltr = this.buildSearchFilter(this.searchFltr);
        this.buildSearchFilter();
        this.packSearchService
            .getPackSearchResult(this.packSearchFilter)
            .subscribe(
            p => {
                this.pack = p.packResult;
                this.recCount = p.recCount;
                this.itemsPerPage = (this.recCount < this.itemsPerPage ? this.recCount : this.itemsPerPage);
                this.clientService.fnSetLoadingAction(false);
            },
            e => { this.clientService.fnSetLoadingAction(false); }
            );

        if (this.pack.length > 0) this.showMsg = true;
        // console.log("search" + this.pack);
        //console.log("error" + this.errorMessage);
    }
    ResetFilter() {
        //alert("reset");
        this.atcAutocomplete.clearList();
        this.necAutocomplete.clearList();
        this.productAutocomplete.clearList();
        this.packAutocomplete.clearList();
        this.manufacturerAutocomplete.clearList();
        this.moleculeAutocomplete.clearList();

        this.atcList = [];
        this.model.PackDescription = '';
        this.packDescription = '';
        this.model.Manufacturer = '';
        this.model.ATC = '';
        this.model.NEC = '';
        this.model.Molecule = '';
        this.model.PFC = null;
        this.model.APN = null;
        this.pack = [];
        this.model.ProductName = '';
        this.model.Flagging = "All";
        this.model.Branding = "All";
        this.showMsg = false
        this.rowPerPage = 500;
        this.itemsPerPage = 500;
        this.SortBy = "";
        this.Direction = 1;

    }
    buildSearchFilter(): void {
        this.SortBy = (this.SortBy == "" ? "PackDescription" : this.SortBy); // default pack description
        //searchFilter[0] = { Criteria: "PackDescription", Value: (this.model.PackDescription ? this.model.PackDescription : "") };
        //searchFilter[1] = { Criteria: "Manufacturer", Value: (this.model.Manufacturer ? this.model.Manufacturer : "") };
        //searchFilter[2] = { Criteria: "ATC", Value: (this.model.ATC ? this.model.ATC : "") };
        //searchFilter[3] = { Criteria: "NEC", Value: (this.model.NEC ? this.model.NEC : "") };
        //searchFilter[4] = { Criteria: "Molecule", Value: (this.model.Molecule ? this.model.Molecule : "") };
        //searchFilter[5] = { Criteria: "Flagging", Value: (this.isAdvanceSearch ? (this.model.Flagging ? this.model.Flagging : "") : "")  };
        //searchFilter[6] = { Criteria: "Branding", Value: (this.isAdvanceSearch ? (this.model.Branding ? this.model.Branding : ""): "") };
        //searchFilter[7] = { Criteria: "PFC", Value: (this.isAdvanceSearch ? (this.model.PFC ? this.model.PFC.toString() : "") : "") };
        //searchFilter[8] = { Criteria: "APN", Value: (this.isAdvanceSearch ? (this.model.APN ? this.model.APN.toString() : "") : "") };
        //searchFilter[9] = { Criteria: "ProductName", Value: (this.model.ProductName ? this.model.ProductName : "") };
        //searchFilter[10] = { Criteria: "Orderby", Value: (this.SortBy + "," + this.Direction) };

        this.packSearchFilter.Flagging = { Criteria: "Flagging", Value: (this.isAdvanceSearch ? (this.model.Flagging ? this.model.Flagging : "") : "") };
        this.packSearchFilter.Branding = { Criteria: "Branding", Value: (this.isAdvanceSearch ? (this.model.Branding ? this.model.Branding : "") : "") };
        this.packSearchFilter.PFC = { Criteria: "PFC", Value: (this.isAdvanceSearch ? (this.model.PFC ? this.model.PFC.toString() : "") : "") };
        this.packSearchFilter.APN = { Criteria: "APN", Value: (this.isAdvanceSearch ? (this.model.APN ? this.model.APN.toString() : "") : "") };
        this.packSearchFilter.Orderby = { Criteria: "Orderby", Value: (this.SortBy + "," + this.Direction) };

        if (this.isExport == false) {
            //searchFilter[11] = { Criteria: "start", Value: this.startRecNo.toString() };
            //searchFilter[12] = { Criteria: "rows", Value: this.itemsPerPage.toString() };
            this.packSearchFilter.Start = { Criteria: "start", Value: this.startRecNo.toString() };
            this.packSearchFilter.Rows = { Criteria: "rows", Value: this.itemsPerPage.toString() };
        }

        //return searchFilter;
    }
    Close() {

        //console.log('close click is working');

    }

    public get getColumns() {
        if (this.searchName != "")
            this.Columns = this.Columns.filter(function (el: any) {
                return el.colName.indexOf(this.searchName) != -1;
            });
        return this.Columns;
    }
    onKey(value: string) {
        //console.log(value + ' | ');
        var searchTerm = value;
        this.Columns = this.tempColumns;
        this.Columns = this.Columns.filter(function (el: any) {
            return el.colName.indexOf(searchTerm) != -1;
        });
        //this.Columns = this.Columns.slice(1);
    }
    packByPage: PackSearchResult[] = [];



    public setPage(pageNo: number): void {
        this.currentPage = pageNo;
    }

    public pageChanged(event: any): void {
        //var startIndex = (event.page - 1) * this.itemsPerPage;
        //var endIndex = startIndex + this.itemsPerPage;
        this.startRecNo = (event.page - 1) * this.itemsPerPage;
        this.isExport = false;
        this.clientService.fnSetLoadingAction(true);
        if (this.isSearch == true) {

            //this.searchFltr = this.buildSearchFilter(this.searchFltr);
            this.buildSearchFilter();
            this.packSearchService
                .getPackSearchResult(this.packSearchFilter)
                .subscribe(
                p => {
                    this.pack = p.packResult;
                    this.recCount = p.recCount; this.clientService.fnSetLoadingAction(false);
                },
                e => { this.clientService.fnSetLoadingAction(false); }
                );

        }
        // this.packByPage = this.pack.slice(startIndex, endIndex);
    }

    onATCSelected(selection: any[]) {
        let searchFilters: SearchFilter[] = [];
        if (selection != undefined && selection.length > 0) {
            selection.forEach(s => {
                let searchFilter = new SearchFilter();
                searchFilter.Criteria = "ATC";
                searchFilter.Value = s.Code;
                searchFilters.push(searchFilter);
            });
        }
        this.packSearchFilter.ATC = searchFilters;
        //if (selection != undefined && selection != "") {
        //    if (selection.ATC_Code != undefined) { this.model.ATC = selection.ATC_Code; }
        //} else {
        //    this.model.ATC = "";
        //}
    }

    onNECSelected(selection: any[]) {
        let searchFilters: SearchFilter[] = [];
        if (selection != undefined && selection.length > 0) {
            selection.forEach(s => {
                let searchFilter = new SearchFilter();
                searchFilter.Criteria = "NEC";
                searchFilter.Value = s.Code;
                searchFilters.push(searchFilter);
            });
        }
        this.packSearchFilter.NEC = searchFilters;
        //if (selection != undefined && selection != "") {
        //    if (selection.NEC_Code != undefined) { this.model.NEC = selection.NEC_Code; }
        //} else {
        //    this.model.NEC = "";
        //}
    }

    exportCsv(): void {
        this.isExport = true;
        var visiableCol = this.getVisibleColumns(this.Columns);
        //this.searchFltr = this.buildSearchFilter(this.searchFltr);
        this.buildSearchFilter();
        let filter: SearchFilter[] = [];
        if (this.packSearchFilter != null) {
            this.packSearchFilter.ATC.forEach(a => { filter.push(a); });
            this.packSearchFilter.NEC.forEach(a => { filter.push(a); });
            this.packSearchFilter.Molecule.forEach(a => { filter.push(a); });
            this.packSearchFilter.PackDescription.forEach(a => { filter.push(a); });
            this.packSearchFilter.ProductDescription.forEach(a => { filter.push(a); });
            this.packSearchFilter.Manufacturer.forEach(a => { filter.push(a); });
            filter.push(this.packSearchFilter.Flagging);
            filter.push(this.packSearchFilter.Branding);
            filter.push(this.packSearchFilter.PFC);
            filter.push(this.packSearchFilter.APN);
            filter.push(this.packSearchFilter.Orderby);
            //filter.push(this.packSearchFilter.Start);
            //filter.push(this.packSearchFilter.Rows);
        }

        var Options = {
            filterOptions: filter,
            exportOptions: visiableCol,
            type: "csv"
        };


        this.packSearchService.downloadExcel(Options)
            .finally(() => {
                this.clientService.fnSetLoadingAction(false)
            })
            .subscribe((res) => {
                // console.log('Component'),
                //console.log(res);
                var downloadUrl = URL.createObjectURL(res);

                const pdfUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetapplication/pdf' }));

                if (navigator.msSaveOrOpenBlob) {
                    navigator.msSaveOrOpenBlob(res, `PackSearch.csv`);
                }
                else {
                    const anchor = document.createElement('a');
                    anchor.download = `PackSearch.csv`;
                    anchor.href = pdfUrl;
                    anchor.click();
                }
                //console.log('The download url is ' + downloadUrl);
            }),
            (err => console.log(err)),
            (() => console.log("export csv completd"));
        //this.packSearchService.downloadExcel(Options);
    }

    exportXls(): void {
        this.isExport = true;
        var visiableCol = this.getVisibleColumns(this.Columns);
        //this.searchFltr = this.buildSearchFilter(this.searchFltr);
        this.buildSearchFilter();
        let filter: SearchFilter[] = [];
        if (this.packSearchFilter != null) {
            this.packSearchFilter.ATC.forEach(a => { filter.push(a); });
            this.packSearchFilter.NEC.forEach(a => { filter.push(a); });
            this.packSearchFilter.Molecule.forEach(a => { filter.push(a); });
            this.packSearchFilter.PackDescription.forEach(a => { filter.push(a); });
            this.packSearchFilter.ProductDescription.forEach(a => { filter.push(a); });
            this.packSearchFilter.Manufacturer.forEach(a => { filter.push(a); });
            filter.push(this.packSearchFilter.Flagging);
            filter.push(this.packSearchFilter.Branding);
            filter.push(this.packSearchFilter.PFC);
            filter.push(this.packSearchFilter.APN);
            filter.push(this.packSearchFilter.Orderby);
            //filter.push(this.packSearchFilter.Start);
            //filter.push(this.packSearchFilter.Rows);
        }
        var Options = {
            filterOptions: filter,
            exportOptions: visiableCol,
            type: "xlsx"
        };


        this.packSearchService.downloadExcel(Options)
            .finally(() => {
                this.clientService.fnSetLoadingAction(false)
            })
            .subscribe((res) => {
                // console.log('Component'),
                //console.log(res);
                var downloadUrl = URL.createObjectURL(res);

                const pdfUrl = (window.URL || window['webkitURL']).createObjectURL(new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetapplication/pdf' }));
                if (navigator.msSaveOrOpenBlob) {
                    navigator.msSaveOrOpenBlob(res, `PackSearch.xlsx`);
                }
                else {
                    const anchor = document.createElement('a');
                    anchor.download = `PackSearch.xlsx`;
                    anchor.href = pdfUrl;
                    anchor.click();
                }
                //console.log('The download url is ' + downloadUrl);
            }),
            (err => console.log(err)),
            (() => console.log("export excel completd"));
        // this.packSearchService.downloadExcel(Options);

    }

    //observableSource(keyword: any) {

    //    var filter: SearchFilter[] = [];
    //    filter.push({ Criteria: "PackDescription", Value: keyword });

    //    return this.packSearchService
    //        .getPackDescResult(filter);

    //}

    //observableManufacturer(keyword: any) {

    //    var filter: SearchFilterCondition[] = [];
    //    filter.push(new SearchFilterCondition("Manufacturer", keyword + "*", 'Add'));
    //    return this._autocompleteService.
    //                getAutocompleteList<Manufacturer>("Manufacturer", filter); 

    //}

    //observableProductName(keyword: any) {

    //    var filter: SearchFilterCondition[] = [];
    //    filter.push(new SearchFilterCondition("ProductName", keyword + "*", 'Add'));
    //    return this._autocompleteService.
    //        getAutocompleteList<Product>("Product", filter);

    //}

    getVisibleColumns(PackSearchColumns: any[]): string[] {
        return PackSearchColumns.filter(col => col.visible === true).map(function (col) {
            return col.colName;
        });
    }

    searchManufacturer(keyword: any) {

        var filter: SearchFilter[] = [];
        filter.push({ Criteria: "Manufacturer", Value: keyword });

        //return this.packSearchService
        //    .getPackSearchResult(filter);

    }

    onPackDescriptionSelected(selection: any[]) {
        let searchFilters: SearchFilter[] = [];
        if (selection != undefined && selection.length > 0) {
            selection.forEach(s => {
                let searchFilter = new SearchFilter();
                searchFilter.Criteria = "PackDescription";
                searchFilter.Value = s.Code;
                searchFilters.push(searchFilter);
            });
        }
        this.packSearchFilter.PackDescription = searchFilters;
        //if (selection != undefined && selection != "") {
        //    if (selection.PackDescription != undefined) { this.model.PackDescription = selection.PackDescription; } else { this.model.PackDescription = selection; }
        //} else {
        //    this.model.PackDescription = "";
        //}
    }

    onManufacturerSelected(selection: any[]) {
        let searchFilters: SearchFilter[] = [];
        if (selection != undefined && selection.length > 0) {
            selection.forEach(s => {
                let searchFilter = new SearchFilter();
                searchFilter.Criteria = "Manufacturer";
                searchFilter.Value = s.Code;
                searchFilters.push(searchFilter);
            });
        }
        this.packSearchFilter.Manufacturer = searchFilters;
        //if (selection != undefined && selection != "") {
        //    if (selection.Org_Long_Name != undefined) { this.model.Manufacturer = selection.Org_Long_Name;
        //    }
        //} else {
        //    this.model.Manufacturer = "";
        //}
    }

    onProductDescriptionSelected(selection: any) {
        let searchFilters: SearchFilter[] = [];
        if (selection != undefined && selection.length > 0) {
            selection.forEach(s => {
                let searchFilter = new SearchFilter();
                searchFilter.Criteria = "ProductName";
                searchFilter.Value = s.Code;
                searchFilters.push(searchFilter);
            });
        }
        this.packSearchFilter.ProductDescription = searchFilters;
        //if (selection != undefined && selection != "") {
        //    if (selection.ProductName != undefined) {
        //        this.model.ProductName = selection.ProductName;
        //    }
        //} else {
        //    this.model.ProductName = "";
        //}
    }

    onMoleculeSelected(selection: any[]) {
        let searchFilters: SearchFilter[] = [];
        if (selection != undefined && selection.length > 0) {
            selection.forEach(s => {
                let searchFilter = new SearchFilter();
                searchFilter.Criteria = "Molecule";
                searchFilter.Value = s.Code;
                searchFilters.push(searchFilter);
            });
        }
        this.packSearchFilter.Molecule = searchFilters;
        //if (selection != undefined && selection != "") {
        //    if (selection.Description != undefined) { this.model.Molecule = selection.Description; }
        //} else {
        //    this.model.Molecule = "";
        //}
    }

    //clearPackDescription() {
    //    this.packDescription = '';
    //    this.model.PackDescription = '';
    //}

    //onManufacturerCleared() {
    //    this.model.Manufacturer = '';
    //}

    //onProductDescriptionCleared() {
    //    this.model.ProductName = '';
    //}

    //onMoleculeCleared() {
    //    this.model.Molecule = '';
    //}

    //onATCCleared() {
    //    this.model.ATC = '';
    //}

    //onNECCleared() {
    //    this.model.NEC = '';
    //}
    setColVisibile() {
        for (let it in this.Columns) {
            //console.log('col' + this.Columns[it].colName);
            if (this.Columns[it].visible == false)
                this.Columns[it].visible = true;
        }
    }
    Sort(key: string, dir: boolean) {
        this.isExport = false;
        if (this.isSearch == true) {
            for (let it in this.Columns) {
                if (key == this.Columns[it].colName && this.Columns[it].sortable == false)
                    return;
                if (key == this.Columns[it].colName)
                    this.Columns[it].sorted = true;
                else
                    this.Columns[it].sorted = false;
            }
            this.SortBy = key;
            this.Direction = this.isAsc == true ? 1 : -1;
            this.isAsc = dir;// == 1 ? true : false;
            //console.log("dir" + this.Direction + "isAsc: " + this.isAsc);
            // console.log('Key' + key + '-' + dir + '-' + this.model.PackDescription);
            this.clientService.fnSetLoadingAction(true);
            //this.searchFltr = this.buildSearchFilter(this.searchFltr);
            this.buildSearchFilter();
            this.packSearchService
                .getPackSearchResult(this.packSearchFilter)
                .subscribe(
                p => {
                    this.pack = p.packResult;
                    this.recCount = p.recCount;
                    this.clientService.fnSetLoadingAction(false);
                },
                e => { this.clientService.fnSetLoadingAction(false); }

                );

        }
        this.isAsc = !this.isAsc;
    }

    checkedColumns(selection: string) {
        for (let it in this.Columns) {
            // console.log('col' + this.Columns[it].colName);
            if (this.Columns[it].colName == selection) {
                if (this.Columns[it].visible == false)
                    this.Columns[it].visible = true;
                else
                    this.Columns[it].visible = false;
            }
        }

        this.packSearchTableSettings.tableColDef = [];
        console.log("PackSearchColumns", PackSearchColumns);
        let visibleCell = this.Columns.filter(col => col.visible == true) || [];
        this.cellFixedWidth = 100 / visibleCell.length;
        console.log("visibleCell", visibleCell, "this.cellFixedWidth", this.cellFixedWidth);

        //************ bind table column***********************//

        this.Columns.forEach((rec: any) => {
            if (rec.visible) {
                this.packSearchTableSettings.tableColDef.push({ headerName: rec.colText, width: this.cellFixedWidth + '%', internalName: rec.colName, sort: rec.sortable, type: "", onClick: "", visible: rec.visible });
            }
        });

        if (this.packSearchTableSettings.tableColDef.length > 13) {
            this.packSearchTableSettings.pTableStyle.overflowContentWidth = "200%";
        } else {
            this.packSearchTableSettings.pTableStyle.overflowContentWidth = "160%";
        }

    }
    ChangeSearchtype() {
        this.isAdvanceSearch = !this.isAdvanceSearch;

    }
    valuechange(modelNm: string, ev: any) {

        if (modelNm == 'apn') {
            if (this.model.APN.toString().match(/[a-z]/i)) this.model.APN = null
        }
        else if (modelNm == 'pfc') {
            if (this.model.PFC.toString().match(/[a-z]/i)) this.model.PFC = null
        }
    }
    ChangeRecLimit(rowlimit: any) {
        this.rowPerPage = rowlimit;
        this.itemsPerPage = rowlimit;
        this.isExport = false;
        this.isSearch = true;
        this.isExport = false;
        this.showMsg = false;
        this.currentPage = 1;
        this.clientService.fnSetLoadingAction(true);
        //this.searchFltr = this.buildSearchFilter(this.searchFltr);
        //console.log('currentPage'+ this.currentPage);
        this.buildSearchFilter();
        this.packSearchService
            .getPackSearchResult(this.packSearchFilter)
            .subscribe(
            p => {
                this.pack = p.packResult,
                    this.recCount = p.recCount,
                    this.itemsPerPage = (this.recCount < this.itemsPerPage ? this.recCount : this.itemsPerPage),
                    this.clientService.fnSetLoadingAction(false)
            }
            ,
            e => { this.clientService.fnSetLoadingAction(false); }

            );
        this.currentPage = 1;
        if (this.pack.length > 0) this.showMsg = true;
    }

    public start: any;
    public pressed: any; public startX: any; public startWidth: any;
    private fnResizeColumn(event: any) {
        //alert('move');
        this.start = event.target;
        this.pressed = true;
        this.startX = event.x;
        this.startWidth = jQuery(this.start).parent().width();
        this.initResizableColumns();
    }

    public initResizableColumns() {
        this.renderer.listenGlobal('body', 'mousemove', (event: any) => {
            if (this.pressed) {
                let width = this.startWidth + (event.x - this.startX);
                jQuery(this.start).parent().css({ 'min-width': width, 'max-   width': width });
                let index = jQuery(this.start).parent().index() + 1;
                jQuery('#mytable' + ' tr td:nth-child(' + index + ')').css({ 'min-width': width, 'max-width': width });
            }
        });
        this.renderer.listenGlobal('body', 'mouseup', (event: any) => {
            if (this.pressed) {
                this.pressed = false;
            }
        });
    }

}

