import { Component, OnInit, DoCheck, OnChanges, EventEmitter, Output, Input, KeyValueDiffers } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Http } from '@angular/http';
import { AutoCompleteService } from './p-autocom.service';
import { PackSearchService } from '../../../packSearch/pack-search.service';
import { Atc, Atc1, Atc2, Atc3, Atc4, Nec, Nec1, Nec2, Nec3, Nec4, Manufacturer, Molecule, Filter, Product, PackDescription, Dimension,PxR } from './p-autocom.model';

declare var jQuery: any;

@Component({
    selector: 'p-autocomplete',
    templateUrl: '../../../../app/shared/component/p-autocomplete/p-autocom.component.html',
    providers: [AutoCompleteService, PackSearchService],
    styleUrls: ['../../../../app/shared/component/p-autocomplete/p-autocom.component.css']
})
export class PAutoCompleteComponent implements OnInit, DoCheck {
    autoComList: any[] = [];
    errorMessage: string = '';
    @Output() onSelection = new EventEmitter<any>();
    @Output() onClear = new EventEmitter<any>();
    autoComSelected: any[] = [];
    @Input() AutoComType: string;
    @Input() multiSelect: boolean = false;
    @Input() appliedFilters: any;
    @Input() marketBaseArray: any[] = [];//pass base filter name and other info using this array
    @Input() dependencyArray: any;
    @Input() singleselect: string = undefined;
    @Input() valuePropertyName: string;
    @Input() displayPropertyName: string;
    selectedItem: string = '';
    differ: any;
    isDisabled: boolean = false;

    ngOnInit(): void {
        //var autoType: any = null;
        //if (this.AutoComType != undefined) {
        //    switch (this.AutoComType.toLowerCase()) {
        //        case 'atc': { this.getAutocompleteList<Atc>(Atc.GetURLPath()); autoType = Atc; break; }
        //        case 'atc1': { this.getAutocompleteList<Atc1>(Atc1.GetURLPath()); autoType = Atc1; break; }
        //        case 'atc2': { this.getAutocompleteList<Atc2>(Atc2.GetURLPath()); autoType = Atc2; break; }
        //        case 'atc3': { this.getAutocompleteList<Atc3>(Atc3.GetURLPath()); autoType = Atc3; break; }
        //        case 'atc4': { this.getAutocompleteList<Atc4>(Atc4.GetURLPath()); autoType = Atc4; break; }
        //        case 'nec': { this.getAutocompleteList<Nec>(Nec.GetURLPath()); autoType = Nec; break; }
        //        case 'nec1': { this.getAutocompleteList<Nec1>(Nec1.GetURLPath()); autoType = Nec1; break; }
        //        case 'nec2': { this.getAutocompleteList<Nec2>(Nec2.GetURLPath()); autoType = Nec2; break; }
        //        case 'nec3': { this.getAutocompleteList<Nec3>(Nec3.GetURLPath()); autoType = Nec3; break; }
        //        case 'nec4': { this.getAutocompleteList<Nec4>(Nec4.GetURLPath()); autoType = Nec4; break; }
        //        case 'manufacturer': { this.getAutocompleteList<Manufacturer>(Manufacturer.GetURLPath()); autoType = Manufacturer; break; }
        //        case 'molecule': { this.getAutocompleteList<Molecule>(Molecule.GetURLPath()); autoType = Molecule; break; }
        //        case 'product': { this.getAutocompleteList<Molecule>(Product.GetURLPath()); autoType = Molecule; break; }

        //    }
        //}
        //if (autoType != undefined) {
        //    this.valuePropertyName = autoType.GetCodeName();
        //    this.displayPropertyName = autoType.GetDescName();
        //}
    }

    getAutoComList(keyword: any): Observable<any> {
        console.log(keyword);
        let marketBaseName = undefined;
        if (this.marketBaseArray != undefined) {
            marketBaseName = this.marketBaseArray["MarketBaseName"];
        }
        jQuery(".PSTBNewAuto-v1").val("");
        var filter: Filter[] = [];
        if (this.marketBaseArray != undefined) {
            if (this.marketBaseArray.length > 0) {
                //console.log("passing market base: "+JSON.stringify(this.marketBaseArray));
                this.marketBaseArray.forEach((rec: any, index: any) => {
                    if (rec.BaseFilterValues.indexOf("',") > 0) {
                        let BaseFilterValuesArray = rec.BaseFilterValues.split("',");
                        for (let i = 0; i < BaseFilterValuesArray.length; i++) {
                            filter.push(new Filter(rec.BaseFilterName, BaseFilterValuesArray[i].replace(/\'/g, ""), rec.IsRestricted == true ? 'Restrict' : 'Add'));
                        }
                    } else {
                        filter.push(new Filter(rec.BaseFilterName, rec.BaseFilterValues.replace(/\'/g, ""), rec.IsRestricted == true ? 'Restrict' : 'Add'));
                    }
                });
            }
        }

        console.log("Filters applied: " + JSON.stringify(filter));


        var autoType: any = null;
        var returnMethod: any = null;
        if (this.AutoComType != undefined) {
            switch (this.AutoComType.toLowerCase()) {
                case 'atc': { filter.push(new Filter("ATC", keyword + "", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Atc>("ATC", filter); autoType = Atc; break; }
                case 'atc1': { filter.push(new Filter("S_ATC1_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Atc1>("ATC1", filter); autoType = Atc1; break; }
                case 'atc2': { filter.push(new Filter("S_ATC2_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Atc2>("ATC2", filter); autoType = Atc2; break; }
                case 'atc3': { filter.push(new Filter("S_ATC3_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Atc3>("ATC3", filter); autoType = Atc3; break; }
                case 'atc4': { filter.push(new Filter("S_ATC4_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Atc4>("ATC4", filter); autoType = Atc4; break; }
                case 'nec': { filter.push(new Filter("NEC", keyword + "", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Atc>("NEC", filter); autoType = Nec; break; }
                case 'nec1': { filter.push(new Filter("S_NEC1_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Nec1>("NEC1", filter); autoType = Nec1; break; }
                case 'nec2': { filter.push(new Filter("S_NEC2_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Nec2>("NEC2", filter); autoType = Nec2; break; }
                case 'nec3': { filter.push(new Filter("S_NEC3_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Nec3>("NEC3", filter); autoType = Nec3; break; }
                case 'nec4': { filter.push(new Filter("S_NEC4_Code", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Nec4>("NEC4", filter); autoType = Nec4; break; }
                case 'manufacturer': { filter.push(new Filter("Manufacturer", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Manufacturer>("Manufacturer", filter); autoType = Manufacturer; break; }
                case 'molecule': { filter.push(new Filter("Description", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Molecule>("Molecule", filter); autoType = Molecule; break; }
                case 'product': { filter.push(new Filter("ProductName", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Product>("Product", filter); autoType = Product; break; }
                case 'packdescription': { filter.push(new Filter("PackDescription", keyword + "", 'Add')); returnMethod = this._packSearchService.getPackDescResult(filter); autoType = PackDescription; break; }
                case 'dimension': { filter.push(new Filter("dimension", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteListForDimensioni<Dimension>("dimension", this.dependencyArray, keyword, filter); autoType = Dimension; break; }
                case 'poisonschedule': { filter.push(new Filter("Poison_Schedule", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Molecule>("PoisonSchedule", filter); autoType = Molecule; break; }
                case 'form': {filter.push(new Filter("form", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Molecule>("Form", filter); autoType = Molecule; break; }
                // case 'pxrcode': {filter.push(new Filter("form", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteList<Molecule>("Form", filter); autoType = Molecule; break; }
                case 'pxrcode': { filter.push(new Filter("pxrcode", keyword + "*", 'Add')); returnMethod = this._autocompleteService.getAutocompleteListGenerate<PxR>("pxrcode", this.dependencyArray, keyword, filter); autoType = PxR; break; }
            
            }
        }
        //if (autoType != undefined) {
        //    this.valuePropertyName = autoType.GetCodeName();
        //    this.displayPropertyName = autoType.GetDescName();
        //}
        return returnMethod;
    }

    getAutocompleteList<T>(listType: string): void {
        //console.log("Market Base Array in get function"+JSON.stringify(this.marketBaseArray));
        var filter: Filter[] = [];

        this._autocompleteService.getAutocompleteList<T>(listType, filter)
            .subscribe(list => { this.autoComList = <any>list; }, error => this.errorMessage = <any>error);
    }

    clearText() {
        this.selectedItem = '';
        this.onClear.emit();
    }

    clearList() {
        this.autoComSelected = [];
        this.onSelection.emit();
    }

    disableMe() {
        this.clearList();
        this.isDisabled = true;
        jQuery(".PSTBNewAuto").css("display", "none");
        jQuery(".glyphicon-remove").css("display", "none");

    }

    enableMe() {
        this.isDisabled = false;
    }

    makeMultiSelect() {
        this.singleselect = undefined;
    }

    makeSingleSelect(marketBaseType: string) {
        if (this.autoComSelected.length > 1) {
            this.clearList();
        }
        this.singleselect = marketBaseType;
    }

    removeFilter(filterObject: any) {
        //console.log("before delete:" + JSON.stringify(this.autoComSelected));
        //console.log("selected record:" + JSON.stringify(filterObject));
        if (this.autoComSelected.indexOf(filterObject) > -1) {

            if (this.AutoComType.toLowerCase() == "atc") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "atc1") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "atc2") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "atc3") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "atc4") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "manufacturer") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == "mfr") { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "nec") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "nec1") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "nec2") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "nec3") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "nec4") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "molecule") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "product") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "packdescription") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
             else if (this.AutoComType.toLowerCase() == "poisonschedule") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }else if (this.AutoComType.toLowerCase() == "form") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }
            else if (this.AutoComType.toLowerCase() == "dimension") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }else if (this.AutoComType.toLowerCase() == "pxrcode") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.splice(this.autoComSelected.indexOf(filterObject), 1);
            }


            //console.log("after delete:" + JSON.stringify(this.autoComSelected));
            this.onSelection.emit(this.autoComSelected);
        }

        setTimeout(function () {
            jQuery(".PSTBNewAuto-v1").val("");
        }, 10);
    }

    private findIndexByAttr(arr: any[], attr: string, value: string) {
        for (var i = 0; i < arr.length; i += 1) {
            if (arr[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }
    //fnOpenAutoText(arrt: any) {
    //    if (this.isDisabled) { return; }
    //    if (this.singleselect != undefined && this.singleselect == this.AutoComType.toLowerCase() && this.autoComSelected.length > 0) { return; }
    //    jQuery(".PSTBNewAuto").val("");
    //    jQuery(".PSTBNewAuto").attr("placeholder", " Search here");
    //    jQuery(".cusGlyphClose").css("display", "none");
    //    if (jQuery(".autocom-" + arrt).css('display') != "none") {
    //        jQuery(".PSTBNewAuto").css("display", "none");
    //    } else {
    //        jQuery(".PSTBNewAuto").css("display", "none");
    //        jQuery(".autocom-" + arrt).css("display", "block");
    //        jQuery(".autocom-clear-text-" + arrt).css("display", "block");
    //    }
    //}
    onAutoTextSelection(selectedAutoObject: any) {
        if (this.singleselect != undefined && this.singleselect == this.AutoComType.toLowerCase() && this.autoComSelected.length > 0) { return };
        if (selectedAutoObject != undefined && this.checkAttribute(selectedAutoObject) && ((this.autoComSelected.indexOf(selectedAutoObject) == -1) || this.AutoComType == 'Dimension')) {
            if (this.AutoComType.toLowerCase() == "atc") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.push({ Code: selectedAutoObject.ATC_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc1") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.push({ Code: selectedAutoObject.ATC1_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc2") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.ATC2_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc3") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.ATC3_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc4") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.ATC4_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "manufacturer") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == "mfr") { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.Org_Long_Name, FilterName: "Mfr" });
            }
            else if (this.AutoComType.toLowerCase() == "nec") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.push({ Code: selectedAutoObject.NEC_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec1") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.NEC1_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec2") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.NEC2_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec3") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.NEC3_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec4") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.NEC4_Code, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "molecule") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.Description, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "product") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.ProductName, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "packdescription") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.PackDescription, FilterName: this.AutoComType });
            }
             else if (this.AutoComType.toLowerCase() == "poisonschedule") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.Poison_Schedule, FilterName: this.AutoComType });
            }
             else if (this.AutoComType.toLowerCase() == "form") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.Form_Desc_Short, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "dimension") {
                let IsDimensionAvailable = false;
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } });
                this.autoComSelected.forEach((rec: any) => {
                    if (rec.DimensionId == selectedAutoObject.DimensionId) {
                        IsDimensionAvailable = true;
                    }
                });
                if (!IsDimensionAvailable) {
                    this.autoComSelected.push({ Code: selectedAutoObject.DimensionName, FilterName: this.AutoComType, DimensionId: selectedAutoObject.DimensionId });
                }
                // this.autoComSelected.push({Code:"1234",FilterName:this.AutoComType});
                //console.log("this.this.appliedFilters: " + JSON.stringify(this.autoComSelected));
            }
             else if (this.AutoComType.toLowerCase() == "pxrcode") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: selectedAutoObject.MarketCode, FilterName: this.AutoComType });
            }
            this.onSelection.emit(this.autoComSelected);

            setTimeout(function () {
                jQuery(".PSTBNewAuto-v1").val("");
            }, 10);

            //if (this.singleselect != undefined && this.singleselect == this.AutoComType.toLowerCase() && this.autoComSelected.length > 0) {
            //    jQuery(".PSTBNewAuto").css("display", "none");
            //    jQuery(".glyphicon-remove").css("display", "none");
            //}
        }
    }

    onEnterClick(event: Event) {
        let _selectedItem = this.selectedItem.trim();
        if (_selectedItem!= '') {
            if (this.AutoComType.toLowerCase() == "atc1") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }) || []; this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc2") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc3") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "atc4") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "manufacturer") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == "mfr") { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: "Mfr" });
            }
            else if (this.AutoComType.toLowerCase() == "nec1") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec2") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec3") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "nec4") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "molecule") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "product") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "poisonschedule") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } }); this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "form") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => {
                    if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) {
                        return true
                    } else {
                        return false
                    }
                });
                this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }
            else if (this.AutoComType.toLowerCase() == "pxrcode") {
                this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => {
                    if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) {
                        return true
                    } else {
                        return false
                    }
                });
                this.autoComSelected.push({ Code: _selectedItem, FilterName: this.AutoComType });
            }

            //else if (this.AutoComType.toLowerCase() == "dimension") {
            //    let IsDimensionAvailable = false;
            //    this.autoComSelected = this.autoComSelected.filter((rec: any, index: any) => { if (rec.FilterName.toLowerCase() == this.AutoComType.toLowerCase()) { return true } else { return false } });
            //    this.autoComSelected.forEach((rec: any) => {
            //        if (rec.DimensionId == this.selectedItem) {
            //            IsDimensionAvailable = true;
            //        }
            //    });
            //    if (!IsDimensionAvailable) {
            //        this.autoComSelected.push({ Code: this.selectedItem, FilterName: this.AutoComType, DimensionId: selectedAutoObject.DimensionId });
            //    }
            //}

            this.onSelection.emit(this.autoComSelected);
            let this_ = this;
            setTimeout(function () {
                this_.selectedItem = '';
            }, 10);
        }
    }

    //replace with type check on base class
    private checkAttribute(selectedAutoObject: any) {
        if (selectedAutoObject.ATC_Code != undefined || selectedAutoObject.ATC1_Code != undefined
            || selectedAutoObject.ATC2_Code != undefined || selectedAutoObject.ATC3_Code != undefined || selectedAutoObject.ATC4_Code != undefined ||
            selectedAutoObject.NEC_Code != undefined || selectedAutoObject.NEC1_Code != undefined
            || selectedAutoObject.NEC2_Code != undefined || selectedAutoObject.NEC3_Code != undefined || selectedAutoObject.NEC4_Code != undefined ||
            selectedAutoObject.Org_Code != undefined || selectedAutoObject.MoleculeId != undefined || selectedAutoObject.ProductName != undefined ||
            selectedAutoObject.PackDescription != undefined || selectedAutoObject.DimensionId != undefined
             || selectedAutoObject.Poison_Schedule != undefined || selectedAutoObject.Form_Desc_Short != undefined||selectedAutoObject.MarketCode != undefined ) {

            return true;
        }
        return false;
    }
    ngDoCheck() {
        var changes = this.differ.diff(this.appliedFilters);//to detect any changes of applied filters        
        if (changes != null) {
            this.autoComSelected = JSON.parse(JSON.stringify(this.appliedFilters)) || [];//assign values               
        }
    }

    constructor(private _autocompleteService: AutoCompleteService,
        private differs: KeyValueDiffers,
        private _packSearchService: PackSearchService
    ) {
        this.differ = differs.find({}).create(null);
    }
}

