import { Component, ViewChild, Output, EventEmitter } from '@angular/core';
import { NgForm } from '@angular/forms';
import { ModalDirective } from 'ng2-bootstrap';
//import { MarketAttribute, MarketGroup } from '../../shared/model';

@Component({
    selector: 'market-attribute-modal',
    templateUrl: '../../../app/grouping/modal/market-attribute-modal.component.html',
    exportAs: 'marketattributemodal'
})

export class MarketAttributeModalComponent {
    @ViewChild('marketAttributeModal') marketAttributeModal: ModalDirective;
    @Output() marketAttributeModalSubmit: EventEmitter<any> = new EventEmitter();

    marketAttribute: any = null;
    marketGroup: any = null;
    //marketAttributeList: MarketAttribute[] = [];
    attributeName: string = '';
    isMarketAttributeNameExist: boolean = false;
    isEditForm: boolean = true;

    public show(marketGroup: any, marketAttribute: any): void {
        this.isMarketAttributeNameExist = false;
        this.marketGroup = marketGroup;
        this.marketAttribute = marketAttribute;
        if (this.marketGroup != null) {
            this.attributeName = this.marketGroup.Name;
            this.isEditForm = true;
        }
        else {
            this.isEditForm = false;
        }
        this.marketAttributeModal.show();
    }

    public attributeNameChange(marketAttributeForm: NgForm): void {
        if (this.validateMarketAttributeName(this.attributeName)) {
            this.isMarketAttributeNameExist = false;
        }
        else {
            this.isMarketAttributeNameExist = true;
            marketAttributeForm.form.controls['attributeName'].setErrors({'incorrect': true});
        }
    }

    public onSubmit(marketAttributeForm: NgForm): void {
        if (this.validateMarketAttributeName(this.attributeName)) {
            this.marketAttributeModal.hide();
            this.marketGroup.Name = this.attributeName.trim();
            this.marketAttributeModalSubmit.emit(this.marketGroup);
            
            setTimeout(() => { marketAttributeForm.reset(); }, 1000);
        }
        //else {
        //    this.isMarketAttributeNameExist = true;
        //}
    }

    public hide(): void {
        this.marketAttributeModal.hide();
    }

    private validateMarketAttributeName(attributeName: string): boolean {
        if (this.marketGroup == null) {
           // this.marketGroup = new any();
        }

        var item = this.marketAttribute.MarketGroups
            .filter(m => m.Name.toLowerCase().trim() === attributeName.toLowerCase().trim() && m.GroupId != this.marketGroup.GroupId);
        if (item.length == 0) {
            return true;
        }
        return false;
    }
}