import { Component, ViewChild, ElementRef, OnInit, Pipe, PipeTransform, Renderer, Input } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable } from 'rxjs/Observable';
import { PackSearch } from '../../app/shared/model'
import { AutoCompleteService } from '../components/autocomplete/autocom.service';
import { Atc, Nec, Manufacturer, Molecule, SearchFilterCondition, Product } from '../components/autocomplete/autocom.model';
import { SearchFilter } from '../../app/shared/model';
import { PackSearchService } from '../packSearch/pack-search.service';
import { Filter } from '../shared/component/p-autocomplete/p-autocom.model';
import { PackDescSearch } from '../../app/shared/model';
import { ClientService } from '../shared/services/client.service';
import { MktPackSeachService } from '../market-view/mktPackSearch.service';

@Component({
    selector: 'packDescription-search',
    templateUrl: '../../app/packDescSearch/packDesc-search.html',
    providers: [PackSearchService, AutoCompleteService, ClientService, MktPackSeachService]
})
export class PackDescSearchComponent {
    @Input() clientid: string;
    model: PackSearch = new PackSearch();
    atcList: Atc[] = [];
    necList: Nec[] = [];
    mfrList: Manufacturer[] = [];
    moleculeList: Molecule[] = [];
    errorMessage: string = '';
    searchFltr: SearchFilter[] = [];
    packDescription: PackDescSearch[] = [];
    recCount: number;
    packDescriptionResultTableSetting: any;

    constructor(private _autocompleteService: AutoCompleteService, private packSearchService: PackSearchService, private clientService: ClientService, private mktPackSeachService: MktPackSeachService) {
        this.model.ATC = "";
        this.model.PackDescription = "";
    }
    ngOnInit() {

        //autocom
        //this._autocompleteService.getAutocompleteList<Atc>('Atc', [])
        //    .subscribe(list => { this.atcList = <Atc[]>list; }, error => this.errorMessage = <any>error);

        //this._autocompleteService.getAutocompleteList<Nec>('Nec', [])
        //    .subscribe(list => { this.necList = <Nec[]>list; }, error => this.errorMessage = <any>error);

        //this._autocompleteService.getAutocompleteList<Molecule>('Molecule', [])
        //    .subscribe(list => { this.moleculeList = <Molecule[]>list; }, error => this.errorMessage = <any>error);

        this.recCount = -1;
        this.bindPackSearchResultTable();
    }
    observableSource(keyword: any) {
        var filter: SearchFilter[] = [];
        filter.push({ Criteria: "PackDescription", Value: keyword });

        return this.packSearchService
            .getPackDescResult(filter);

    }
    onPackDescriptionSelected(selection: any) {
        if (selection != undefined && selection != "") {
            if (selection.PackDescription != undefined) { this.model.PackDescription = selection.PackDescription; } else { this.model.PackDescription = selection; }
        } else {
            this.model.PackDescription = "";
        }
    }
    observableManufacturer(keyword: any) {

        var filter: SearchFilterCondition[] = [];
        filter.push(new SearchFilterCondition("Manufacturer", keyword + "*", 'Add'));
        return this._autocompleteService.
            getAutocompleteList<Manufacturer>("Manufacturer", filter);

    }
    onManufacturerSelected(selection: any) {
        if (selection != undefined && selection != "") {
            if (selection.Org_Long_Name != undefined) {
                this.model.Manufacturer = selection.Org_Long_Name;
            }
        } else {
            this.model.Manufacturer = "";
        }
    }
    onATCSelected(selection: any) {
        if (selection != undefined && selection != "") {
            if (selection.ATC_Code != undefined) { this.model.ATC = selection.ATC_Code; }
        } else {
            this.model.ATC = "";
        }
    }

    onNECSelected(selection: any) {
        if (selection != undefined && selection != "") {
            if (selection.NEC_Code != undefined) { this.model.NEC = selection.NEC_Code; }
        } else {
            this.model.NEC = "";
        }
    }

    getATC(keyword: any): Observable<any> {
        var filter: Filter[] = [];
        filter.push(new Filter("ATC", keyword, 'Add'));
        return this._autocompleteService.getAutocompleteList<Atc>('Atc', filter);
    }

    getNEC(keyword: any): Observable<any> {
        var filter: Filter[] = [];
        filter.push(new Filter("NEC", keyword, 'Add'));
        return this._autocompleteService.getAutocompleteList<Nec>('Nec', filter);
    }

    getMoleculeList(keyword: any): Observable<any> {

        var filter: Filter[] = [];
        filter.push(new Filter("Description", "*" + keyword + "*", 'Add'));
        return this._autocompleteService.getAutocompleteList<Molecule>("Molecule", filter);
    }
    onMoleculeSelected(selection: any) {
        if (selection != undefined && selection != "") {
            if (selection.Description != undefined) { this.model.Molecule = selection.Description; }
        } else {
            this.model.Molecule = "";
        }
    }
    observableProductName(keyword: any) {
        var filter: SearchFilterCondition[] = [];
        filter.push(new SearchFilterCondition("ProductName", keyword + "*", 'Add'));
        return this._autocompleteService.
            getAutocompleteList<Product>("Product", filter);

    }
    onProductDescriptionSelected(selection: any) {
        if (selection != undefined && selection != "") {
            if (selection.ProductName != undefined) {
                this.model.ProductName = selection.ProductName;
            }
        } else {
            this.model.ProductName = "";
        }
    }


    valuechange(modelNm: string, ev: any) {

        if (modelNm == 'apn') {
            if (this.model.APN.toString().match(/[a-z]/i)) this.model.APN = null
        }
        else if (modelNm == 'pfc') {
            if (this.model.PFC.toString().match(/[a-z]/i)) this.model.PFC = null
        }
    }
    performSearch(form: any) {
        this.searchFltr = this.buildSearchFilter(this.searchFltr);
        this.clientService.fnSetLoadingAction(true);
        this.mktPackSeachService
            .getSearchResult(this.searchFltr)
            .subscribe(
            p => { this.packDescription = p, this.recCount = p.length, console.log('p.length' + p.length), this.clientService.fnSetLoadingAction(false), this.setPackDescriptionPagination() },
            e => { this.errorMessage = e, this.recCount = 0, this.clientService.fnSetLoadingAction(false) }
            );
    }
    ResetFilter() {
        this.model.PackDescription = '';
        this.model.Manufacturer = '';
        this.model.ProductName = '';
        this.model.ATC = '';
        this.model.NEC = '';
        this.model.Molecule = '';
        this.model.PFC = null;
        this.model.APN = null;
        this.packDescription = [];
        this.recCount = -1;

    }
    buildSearchFilter(searchFilter: SearchFilter[]): SearchFilter[] {
        searchFilter[0] = { Criteria: "PackDescription", Value: (this.model.PackDescription ? this.model.PackDescription : "") };
        searchFilter[1] = { Criteria: "Manufacturer", Value: (this.model.Manufacturer ? this.model.Manufacturer : "") };
        searchFilter[2] = { Criteria: "ATC", Value: (this.model.ATC ? this.model.ATC : "") };
        searchFilter[3] = { Criteria: "NEC", Value: (this.model.NEC ? this.model.NEC : "") };
        searchFilter[4] = { Criteria: "Molecule", Value: (this.model.Molecule ? this.model.Molecule : "") };
        searchFilter[5] = { Criteria: "PFC", Value: (this.model.PFC ? this.model.PFC.toString() : "") };
        searchFilter[6] = { Criteria: "APN", Value: (this.model.APN ? this.model.APN.toString() : "") };
        searchFilter[7] = { Criteria: "ProductName", Value: (this.model.ProductName ? this.model.ProductName : "") };
        searchFilter[8] = { Criteria: "ClientId", Value: this.clientid };

        return searchFilter;
    }
    clearPackDescription() {
        //this.packDescription = '';
        this.model.PackDescription = '';
    }

    onManufacturerCleared() {
        this.model.Manufacturer = '';
    }

    onProductDescriptionCleared() {
        this.model.ProductName = '';
    }

    onMoleculeCleared() {
        this.model.Molecule = '';
    }

    onATCCleared() {
        this.model.ATC = '';
    }

    onNECCleared() {
        this.model.NEC = '';
    }
    Collapse() {
        this.ResetFilter();
    }


    public totalItems: number = this.packDescription.length;
    public userCurrentPage: number = 1;
    public itemsPerPage: number = 500;
    public packDescriptionByPage: PackDescSearch[] = [];



    public pageChanged(event: any): void {
        this.userCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.packDescriptionByPage = this.packDescription.slice(startIndex, endIndex)
    }

    setPackDescriptionPagination(): void {
        this.totalItems = this.packDescription.length;
        this.pageChanged({ page: 1, itemsPerPage: this.itemsPerPage })
    }

    bindPackSearchResultTable() {
        this.packDescriptionResultTableSetting = {
            tableID: "pack-search-table",
            tableClass: "table table-border ",
            tableName: "Pack Search Result",
            tableRowIDInternalName: "Id",
            tableColDef: [
                { headerName: 'Pack Name', width: '50%', internalName: 'Pack', className: "static-pack-description", sort: true, type: "", onClick: "" },
                { headerName: 'Market Base', width: '50%', internalName: 'MarketBase', className: "static-market-base", sort: true, type: "", onClick: "" }

            ],
            enableSearch: true,
            enablePagination: true,
            pageSize: 500,
            displayPaggingSize: 3,
            enabledFixedHeader: true,
            pTableStyle: {
                tableOverflowY: true,
                overflowContentHeight: '488px'
            }
        };
    }

}