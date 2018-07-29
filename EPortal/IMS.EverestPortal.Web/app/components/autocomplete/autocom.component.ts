import { Component, OnInit,DoCheck, OnChanges, EventEmitter, Output, Input,KeyValueDiffers} from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Http } from '@angular/http';
import { AutoCompleteService } from './autocom.service';
import { Atc, Atc1, Atc2, Atc3, Atc4, Nec, Nec1, Nec2, Nec3, Nec4, Manufacturer, Molecule, Filter, Product } from './autocom.model';


@Component({
    selector: 'autocomplete',
    templateUrl: '../../../app/components/autocomplete/autocom.component.html',
    providers: [AutoCompleteService],
    styleUrls: ['../../../app/components/autocomplete/autocom.component.css']
})
export class AutoCompleteComponent implements OnInit,DoCheck {
    autoComList: any[] = [];
    errorMessage: string = '';
    @Output() onSelection = new EventEmitter<any>();
    @Output() onClear = new EventEmitter<any>();
    autoComSelected: any[] = [];
    @Input() AutoComType: string;
    @Input() multiSelect: boolean = false;
    @Input() appliedFilters:any;
    @Input() marketBaseArray:any;//pass base filter name and other info using this array
    valuePropertyName: string;
    displayPropertyName: string;
    selectedItem: string = '';
    differ: any;
    textVisible: boolean = true;


    ngOnInit(): void {
        var autoType: any = null;
        if (!this.multiSelect) { this.textVisible = true; }
        if (this.AutoComType != undefined && !this.multiSelect) {
            switch (this.AutoComType.toLowerCase()) {
                case 'atc': { this.getAutocompleteList<Atc>(Atc.GetURLPath()); autoType = Atc; break; }
                case 'atc1': { this.getAutocompleteList<Atc1>(Atc1.GetURLPath()); autoType = Atc1; break; }
                case 'atc2': { this.getAutocompleteList<Atc2>(Atc2.GetURLPath()); autoType = Atc2; break; }
                case 'atc3': { this.getAutocompleteList<Atc3>(Atc3.GetURLPath()); autoType = Atc3; break; }
                case 'atc4': { this.getAutocompleteList<Atc4>(Atc4.GetURLPath()); autoType = Atc4; break; }
                case 'nec': { this.getAutocompleteList<Nec>(Nec.GetURLPath()); autoType = Nec; break; }
                case 'nec1': { this.getAutocompleteList<Nec1>(Nec1.GetURLPath()); autoType = Nec1; break; }
                case 'nec2': { this.getAutocompleteList<Nec2>(Nec2.GetURLPath()); autoType = Nec2; break; }
                case 'nec3': { this.getAutocompleteList<Nec3>(Nec3.GetURLPath()); autoType = Nec3; break; }
                case 'nec4': { this.getAutocompleteList<Nec4>(Nec4.GetURLPath()); autoType = Nec4; break; }
                case 'manufacturer': { this.getAutocompleteList<Manufacturer>(Manufacturer.GetURLPath()); autoType = Manufacturer; break; }
                case 'molecule': { this.getAutocompleteList<Molecule>(Molecule.GetURLPath()); autoType = Molecule; break; }

            }
        }
        if (autoType != undefined) {
            this.valuePropertyName = autoType.GetCodeName();
            this.displayPropertyName = autoType.GetDescName();
        }
    }

    getAutoComList(keyword: any): Observable<any> {
       // console.log("filters:"+ JSON.stringify( this.appliedFilters));
        var filter: Filter[] = [];
        //take filter form marketbase
        filter.push(new Filter("Manufacturer", "Alcon"))


        var autoType: any = null;
        var returnMethod: any = null;

        if (this.AutoComType != undefined) {
            switch (this.AutoComType.toLowerCase()) {
                case 'atc': { returnMethod = this.autoComList; break; }
                case 'atc1': { filter.push(new Filter("ATC1_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Atc1>("ATC1", filter); autoType = Atc1; break; }
                case 'atc2': { filter.push(new Filter("ATC2_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Atc2>("ATC2", filter); autoType = Atc2; break; }
                case 'atc3': { filter.push(new Filter("ATC3_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Atc3>("ATC3", filter); autoType = Atc3; break; }
                case 'atc4': { filter.push(new Filter("ATC4_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Atc4>("ATC4", filter); autoType = Atc4; break; }
                case 'nec': { this.getAutocompleteList<Nec>(Nec.GetURLPath()); autoType = Nec; break; }
                case 'nec1': { filter.push(new Filter("NEC1_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Nec1>("NEC1", filter); autoType = Nec1; break; }
                case 'nec2': { filter.push(new Filter("NEC2_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Nec2>("NEC2", filter); autoType = Nec2; break; }
                case 'nec3': { filter.push(new Filter("NEC3_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Nec3>("NEC3", filter); autoType = Nec3; break; }
                case 'nec4': { filter.push(new Filter("NEC4_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Nec4>("NEC4", filter); autoType = Nec4; break; }
                case 'manufacturer': { filter.push(new Filter("Org_Code", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Manufacturer>("Manufacturer", filter); autoType = Manufacturer; break; }
                case 'molecule': { filter.push(new Filter("Description", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Molecule>("Molecule", filter); autoType = Molecule; break; }
                case 'product': { filter.push(new Filter("ProductName", keyword + "*")); returnMethod = this._autocompleteService.getAutocompleteList<Product>("Product", filter); autoType = Product; break; }

            }
        }

        if (autoType != undefined) {
            this.valuePropertyName = autoType.GetCodeName();
            this.displayPropertyName = autoType.GetDescName();
        }


        return returnMethod;
    }

    getAutocompleteList<T>(listType: string): void {
        var filter: Filter[] = [];
        for (var item in this.marketBaseArray) {
            var values = this.marketBaseArray[item].split(' ');

        }

        this._autocompleteService.getAutocompleteList<T>(listType, filter)
            .subscribe(list => { this.autoComList = <any>list; }, error => this.errorMessage = <any>error);
    }

    clearText() {
        this.selectedItem = '';
        this.onClear.emit();
    }

    removeFilter(filterCode: string, filterValue: string) {
        var index = this.findIndexByAttr(this.autoComSelected, filterCode, filterValue);
        if (index > -1) { this.autoComSelected.splice(index, 1); }
        this.onSelection.emit(this.autoComSelected);
    }    
    private findIndexByAttr(arr: any[], attr: string, value: string) {
        for (var i = 0; i < arr.length; i += 1) {
            if (arr[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    onAutoTextSelection(selectedAutoObject: any) {
        if (selectedAutoObject != undefined && this.checkAttribute(selectedAutoObject) && this.autoComSelected.indexOf(selectedAutoObject) == -1) {
            this.autoComSelected.push(selectedAutoObject);
        }
        if (String(this.multiSelect) ===  "true"  ) {
            this.onSelection.emit(this.autoComSelected);
        }
        else {
            this.onSelection.emit(selectedAutoObject);
        }

    }

    private showTextbox() {
        this.textVisible = true;
        alert('show');
    }
    private hideTextbox() {
        this.textVisible = false;
        alert('hide');
    }

    //replace with type check on base class
    private checkAttribute(selectedAutoObject: any) {
        if (selectedAutoObject.ATC_Code != undefined || selectedAutoObject.ATC1_Code != undefined
            || selectedAutoObject.ATC2_Code != undefined || selectedAutoObject.ATC3_Code != undefined || selectedAutoObject.ATC4_Code != undefined ||
            selectedAutoObject.NEC_Code != undefined || selectedAutoObject.NEC1_Code != undefined
            || selectedAutoObject.NEC2_Code != undefined || selectedAutoObject.NEC3_Code != undefined || selectedAutoObject.NEC4_Code != undefined || selectedAutoObject.Org_Code != undefined || selectedAutoObject.MoleculeId != undefined) {
            return true;
        }
        return false;
    }
    ngDoCheck() {
        var changes = this.differ.diff(this.appliedFilters);//to detect any changes of applied filters
          if(changes) {
                //console.log("changes"+ JSON.stringify(this.appliedFilters));
                this.AutoComType='';
                this.autoComSelected=JSON.parse(JSON.stringify( this.appliedFilters))||[];//assign values
                //console.log("marketBaseArray:  " + JSON.stringify(this.marketBaseArray));
                //alert(this.marketBaseArray);
          }
    }
        constructor(private _autocompleteService: AutoCompleteService,private differs: KeyValueDiffers) {
         this.differ = differs.find({}).create(null);  
    }
}

