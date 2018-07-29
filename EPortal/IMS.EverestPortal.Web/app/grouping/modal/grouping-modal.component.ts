import { Component, ViewChild, Output, EventEmitter } from '@angular/core';
import { ModalDirective } from 'ng2-bootstrap';
import { NgForm } from '@angular/forms'
//import { MarketAttribute, MarketGroup } from '../../shared/model';
//import { AttributeGroup, MarketAttribute } from '../../shared/model';

@Component({
    selector: 'grouping-modal',
    templateUrl: '../../../app/grouping/modal/grouping-modal.component.html',
    exportAs: 'groupingmodal'
})

export class GroupingModalComponent {
    @ViewChild('groupingModal') groupingModal: ModalDirective;
    @Output() groupingModalSubmit: EventEmitter<any> = new EventEmitter();
    groupingName: string = "";
    //attributeGroup: AttributeGroup;
    //attributeGroupList: AttributeGroup[] = [];
    isEditForm: boolean = true;
    isGroupNameExist: boolean = false;
    marketAttribute: any ;
    marketGroup: any;

    public show(marketGroup: any, marketAttribute: any): void {
        this.isGroupNameExist = false;
        //this.attributeGroup = attributeGroup;
        this.marketGroup = marketGroup;
        this.marketAttribute = marketAttribute;

        if (this.marketGroup != null) {
            //this.groupingName = this.attributeGroup.GroupName;
            this.isEditForm = true;
        }
        else {
            this.groupingName = '';
            this.isEditForm = false;
        }
        this.groupingModal.show();
    }
    
    public hide(): void {
        this.groupingModal.hide();
    }

    //public onSubmit(groupingModalForm: NgForm): void {
    //    if (this.attributeGroup == null) {
    //        this.attributeGroup = new AttributeGroup(0, '');
    //    }
    //    if (this.validateGroupName(this.groupingName, this.attributeGroup)) {
    //        this.groupingModal.hide();
    //        this.attributeGroup.GroupName = this.groupingName;
    //        this.groupingModalSubmit.emit({ attributeGroup: this.attributeGroup, marketAttribute: this.marketAttribute });
    //        setTimeout(() => { groupingModalForm.reset(); }, 1000);
    //    }
    //    else {
    //        this.isGroupNameExist = true;
    //    }
    //}

    private validateGroupName(groupingName: string, marketGroup: any): boolean {
        //var item = marketGroup.Children.filter(
        //    m => m.Name.toLowerCase().trim() === groupingName.toLowerCase().trim()
        //        && m.GroupId !== attributeGroup.GroupID);
        //if (item.length == 0) {
        //    return true;
        //}
        return false;
    }
}