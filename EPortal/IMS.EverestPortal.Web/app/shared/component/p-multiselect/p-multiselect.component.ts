import { Component, Input, forwardRef,Output,EventEmitter } from '@angular/core';
import { NG_VALUE_ACCESSOR, ControlValueAccessor } from '@angular/forms';
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';
import { Filter, Molecule } from '../p-autocomplete/p-autocom.model';
import { AutoCompleteService } from '../p-autocomplete/p-autocom.service';

const noop = () => {
};

export const CUSTOM_INPUT_CONTROL_VALUE_ACCESSOR: any = {
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => PMultiSelectComponent),
    multi: true
};

@Component({
    selector: 'p-multiselect',
    templateUrl: '../../../../app/shared/component/p-multiselect/p-multiselect.component.html',
    styleUrls: ['../../../../app/shared/component/p-multiselect/p-multiselect.component.css'],
    providers: [AutoCompleteService, CUSTOM_INPUT_CONTROL_VALUE_ACCESSOR]
})

export class PMultiSelectComponent implements ControlValueAccessor {

    @Input("fieldName") field: string;
    @Input("tableName") tableName: string;
    @Input("filterName") filterName: string;
    @Input("options") options: any[];
    @Input("params") params: any;

    @Output() onValueSelection = new EventEmitter<any>();
    //selections: any[] = [];
    
    selected: any = "";
    searched: boolean = false;
    private searchTerms = new Subject<string>();
    values: Observable<any[]>;
    searchValue: string = "";

    //NgModel Changes
    private innerValue: any = '';


    //Placeholders for the callbacks which are later providesd
    //by the Control Value Accessor
    private onChangeCallback: (_: any) => void = noop;
    private onTouchedCallback: () => void = noop;

    constructor(public _autocompleteService: AutoCompleteService) {

    }

    //get accessor
    get selections(): any {
        return this.innerValue;
    };

    //set accessor including call the onchange callback
    set selections(v: any) {
        if (v !== this.innerValue) {
            this.innerValue = v;
            this.onChangeCallback(v);
        }
    }

    //Set touched on blur
    onBlur() {
        this.onTouchedCallback();
    }

    //From ControlValueAccessor interface
    writeValue(value: any) {
        if (value !== this.innerValue) {
            this.innerValue = value;
        }
    }

    //From ControlValueAccessor interface
    registerOnChange(fn: any) {
        this.onChangeCallback = fn;
    }

    //From ControlValueAccessor interface
    registerOnTouched(fn: any) {
        this.onTouchedCallback = fn;
    }

    remove(index: number): void {
        this.selections.splice(index, 1);
        this.onValueSelection.emit(this.selections);
    }

    search(term: string): void { 
        this.searchTerms.next(term);
    }

    ngOnInit(): void {


        this.values = this.searchTerms
            .debounceTime(300)        // wait 300ms after each keystroke before considering the term
            .distinctUntilChanged()   // ignore if next search term is same as previous
            .switchMap(term => term   // switch to new observable each time the term changes
                // return the http search observable
                ? (this.options && this.options.length > 0) ?
                    Observable.of<any[]>(this.filterOptiosByString(term)) : this._autocompleteService.getMultiSelectList({ fieldName: this.field, tableName: this.tableName, filterName: this.filterName, fieldValue: term, parameters: this.params })
                // or the observable of empty heroes if there was no search term
                : Observable.of<any[]>([]))
            .catch(error => {
                // TODO: add real error handling
                console.log(error);
                return Observable.of<any[]>([]);
            });
    }

    filterOptiosByString(value: string) {
        let values = this.options.filter(function (val) {
            let tempName = val.Text.toLowerCase();
            //var temp = tempName.indexOf(value.toLowerCase());
            if (tempName.toLowerCase().indexOf(value.toLowerCase()) != -1){
                return true;
            }
            return false;
        });
        return values.slice(0,20);
    }

    onSelection(selectedValue: any) {
        if (selectedValue && selectedValue.Value) {
            delete selectedValue.$id;
            if (!this.selections) {
                this.selections = [];

                //selectedValue.Id = this.selections.length + 1;
                this.selections.push(selectedValue);
            } else {
                if (!(this.selections.filter(v => v.Value == selectedValue.Value).length > 0))//checks already exists

                    //selectedValue.Id = this.selections.length + 1;
                    this.selections.push(selectedValue);
            }
        }

        this.clearSelection();
        this.onValueSelection.emit(this.selections);
    }

    clearSelection() {
        this.searchValue = "";
        this.search(this.searchValue);

        this.onValueSelection.emit(this.selections);
    }

}       