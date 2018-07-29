import { Component, OnInit, DoCheck, Input, Output, ViewChild, EventEmitter } from '@angular/core';
import { NgModel } from '@angular/forms';
import { ModalDirective } from 'ng2-bootstrap';
import { GroupingTreeStructure, MarketAttribute, MarketGroup, MarketGroupPack, MarketGroupView, MarketGroupFilter, MarketDefinitionPacks } from '../../shared/models/grouping/grouping-model'
import { DynamicPackMarketBase } from '../../shared/models/dynamic-pack-market-base';
import { GroupingService } from '../../shared/services/grouping.service';
import { NgForm } from '@angular/forms';
import { AlertService } from '../../shared/component/alert/alert.service'

declare var jQuery: any;

@Component({
    selector: 'app-grouping-details',
    templateUrl: '../../../app/grouping/grouping-details/grouping-details.component.html',
    styleUrls: ['../../../app/grouping/grouping-details/grouping-details.component.css']
})

export class GroupingDetailsComponent implements OnInit, DoCheck {
    @ViewChild('marketAttributeModal') marketAttributeModal: ModalDirective;
    @ViewChild('groupingModal') groupingModal: ModalDirective;
    @ViewChild('sortableMarketGroupModal') sortableMarketGroupModal: ModalDirective;
    //@ViewChild('deleteAttributeModal') deleteAttributeModal: ModalDirective;
    @Input() public dynamicPacks: MarketDefinitionPacks[];
    @Input() public marketDefId: number = 0;
    @Input() public loadGroupView: boolean = false;
    //@Output() fnShowPacksComponent: EventEmitter<any> = new EventEmitter() || null;
    @Output() fnToCheckModificatoinOnGroupingScreen: EventEmitter<any> = new EventEmitter() || null;
    //public destinationPacks: any[] = [];
    public groupingTreeStructure: GroupingTreeStructure = new GroupingTreeStructure();
    public marketAttributes: MarketAttribute[] = [];
    public marketGroupPack: MarketGroupPack[] = [];
    public tempMarketGroupPack: MarketGroupPack[] = [];
    public groupName: string;
    public attributeName: string;
    public selectedMarketAttribute: MarketAttribute;
    public selectedMarketGroup: MarketGroup;
    public marketGroupView: MarketGroupView[] = [];
    public tempMarketGroupView: MarketGroupView[] = [];
    public isMarketAttributeNameExist: boolean = false;
    public isGroupNameExist: boolean = false;
    public addMoreGroups: boolean = false;
    //public isMarketGroupExist: boolean = false;
    public selectedGroup: MarketGroup;
    public selectedAttribute: MarketAttribute;
    public marketGroupFilter: MarketGroupFilter[] = [];
    public attributeNameMaxlengthError: boolean = false;
    public groupNameMaxlengthError: boolean = false;
    public levelOrder: number = 0;
    public isFilterApplied: boolean = false;
    public islockDef: boolean = false;
    public selectedMarketBaseDependencyArray: any[] = [];
    atc1List: any[]; atc2List: any[]; atc3List: any[]; atc4List: any[]; nec1List: any[]; nec2List: any[]; nec3List: any[]; nec4List: any[]; moleculeList: any[]; manufacturerList: any[]; productList: any[]; poisonScheduleList: any[]; formList: any[] = [];
    atc1Selection: any; atc2Selection: any; atc3Selection: any; atc4Selection: any; nec1Selection: any; nec2Selection: any; nec3Selection: any; nec4Selection: any; moleculeSelection: any; manufacturerSelection: any; productSelection: any;
    atcDependencyArray = []; necDependencyArray = [];
    filtersApplied = [];
    includeExcludeArray = [{
        checkboxExcludeATC1: true, checkboxExcludeATC2: true, checkboxExcludeATC3: true, checkboxExcludeATC4: true, checkboxExcludeNEC1: true, checkboxExcludeNEC2: true, checkboxExcludeNEC3: true, checkboxExcludeNEC4: true,
        checkboxExcludeMFR: true, checkboxExcludePRODUCT: true, checkboxExcludeMOLECULE: true, checkboxExcludePOISON: true, checkboxExcludeFORM: true
    }];
    sortableMarketGroup: MarketGroup[] = [];
    isCustomSortEnable: boolean = false;
    sortableMarketAttribute: MarketAttribute;
    sortSelection: string = null;

    constructor(private groupingService: GroupingService, private alertService: AlertService) { }

    ngOnInit() {
        //Bind source table for packs
        this.configureSourceTableForPacks();
        this.loadSourceTable(true, this.dynamicPacks);

        //Bind destination table
        this.configureDestinationTable();
        this.loadDestinationTable();
        this.selectedMarketGroup = null;
        this.islockDef = GroupingService.isLockDef;
        // console.log("dynamic packs:", this.dynamicPacks);
        // console.log("Market definition base maps:");
        // console.log(GroupingService.marketDefinitionBaseMap);
        this.selectedMarketBaseDependencyArray = [];
        if (GroupingService.marketDefinitionBaseMap != null) {
            GroupingService.marketDefinitionBaseMap.forEach((rec: any) => {
                let baseFilters = rec.BaseFilters || [];
                if (baseFilters.length > 0) {
                    if (baseFilters[0].Name != "Molecule") {
                        this.selectedMarketBaseDependencyArray.push({ BaseFilterValues: baseFilters[0].Values, BaseFilterName: baseFilters[0].Name, IsRestricted: baseFilters[0].IsRestricted });
                    }
                }
            });

        }
    }
    ngDoCheck() {
        if (this.loadGroupView == true && this.marketDefId > 0) {
            this.GetMarketGroupView();
            this.loadGroupView = false;
        }
    }

    public GetMarketGroupView(): void {
        let mktAttributes: MarketAttribute[] = [];

        this.marketAttributes = [];
        this.groupingService.getMarketGroupView(this.marketDefId)
            .subscribe((data: any) => {
                if (data != null) {
                    //To set filter in variable
                    this.marketGroupFilter = data.MarketGroupFilter || [];

                    //Update market group pack
                    if (data.MarketGroupPacks != null) {
                        this.marketGroupPack = data.MarketGroupPacks;
                        this.tempMarketGroupPack = Object.assign([], data.MarketGroupPacks);

                        this.marketGroupPack.forEach((rec: any) => {
                            let groupPack = this.dynamicPacks.filter(p => p.PFC == rec.PFC);
                            if (groupPack.length == 0)
                                this.marketGroupPack = this.marketGroupPack.filter(p => p.PFC != rec.PFC);
                        });
                    }

                    //Update market group view
                    if (data.MarketGroupView != null) {
                        this.marketGroupView = data.MarketGroupView;
                        this.tempMarketGroupView = Object.assign([], data.MarketGroupView);
                    }

                    //Get market attributes
                    let marketGroupVw = this.marketGroupView
                        .filter(m => m.IsAttribute == true)
                        .sort((a, b) => {
                            if (a.OrderNo < b.OrderNo)
                                return -1;
                            else if (a.OrderNo > b.OrderNo)
                                return 1;
                            else
                                return 0;
                        });
                    marketGroupVw.forEach((ma: MarketGroupView) => {
                        let attributeExist = this.marketAttributes.filter(m => m.AttributeId == ma.AttributeId);
                        if (attributeExist.length == 0) {
                            this.marketAttributes.push({
                                Id: ma.Id, AttributeId: ma.AttributeId, Name: ma.AttributeName,
                                OrderNo: ma.OrderNo, MarketDefinitionId: ma.MarketDefinitionId,
                                MarketGroups: [{
                                    Id: 10, GroupId: ma.GroupId, IsInherited: false,
                                    MarketDefinitionId: ma.MarketDefinitionId, Name: ma.GroupName,
                                    MarketGroups: this.getNestedMarketGroups(this.marketGroupView, ma.GroupId, ma.AttributeId),
                                    GroupOrderNo: +ma.GroupOrderNo
                                }]
                            });
                        }
                        else {
                            attributeExist[0].MarketGroups.push({
                                Id: 10, GroupId: ma.GroupId, IsInherited: false,
                                MarketDefinitionId: ma.MarketDefinitionId, Name: ma.GroupName,
                                MarketGroups: this.getNestedMarketGroups(this.marketGroupView, ma.GroupId, ma.AttributeId),
                                GroupOrderNo: +ma.GroupOrderNo
                            });
                        }
                    });
                }
            }, (error) => {
            });
    }

    private getNestedMarketGroups(marketGroupView: MarketGroupView[], groupId: number, attributeId: number): MarketGroup[] {
        let group = marketGroupView.filter(g => g.ParentId == groupId && g.AttributeId == attributeId);
        if (group.length > 0) {
            let marketGrp: MarketGroup[] = [];
            group.forEach((g: MarketGroupView) => {
                marketGrp.push(
                    {
                        Id: g.Id, GroupId: g.GroupId, Name: g.GroupName, IsInherited: true, MarketDefinitionId: g.MarketDefinitionId,
                        MarketGroups: this.getNestedMarketGroups(marketGroupView, g.GroupId, g.AttributeId),
                        GroupOrderNo: +g.GroupOrderNo
                    });
            });
            return marketGrp;
            //return [{
            //    Id: group[0].Id, GroupId: group[0].GroupId, Name: group[0].GroupName, IsInherited: true, MarketDefinitionId: group[0].MarketDefinitionId,
            //    MarketGroups: this.getNestedMarketGroups(marketGroupView, group[0].GroupId, group[0].AttributeId)
            //}];
        }
        else {
            return [];
        }
    }



    fnSaveMarketGroupView(): void {
        this.groupingService.saveMarketGroupView(this.marketDefId, this.marketGroupView, this.marketGroupPack)
            .subscribe((res) => {
            }, (error) => {
            });
    }
    fnReturnGroupDetails(): any {
        return { MarketGroupView: this.marketGroupView || [], MarketGroupPack: this.marketGroupPack || [], MarketGroupFilter: this.marketGroupFilter }
    }

    fnAddNewAttribute(): void {
        this.attributeName = "";
        this.selectedMarketAttribute = null;
        this.marketAttributeModal.show();
        setTimeout(() => {
            document.getElementById("attributeName").focus();
        }, 1000);
    }

    fnEditAttribute(marketAttribute: MarketAttribute): void {
        if (marketAttribute != null) {
            this.selectedMarketAttribute = marketAttribute;
            this.attributeName = this.selectedMarketAttribute.Name;
            this.marketAttributeModal.show();
            setTimeout(() => {
                document.getElementById("attributeName").focus();
            }, 1000);
        }
    }

    fnShowAttributeDeleteModal(marketAttribute: MarketAttribute): void {
        if (marketAttribute != null && marketAttribute.MarketGroups != null) {
            this.selectedMarketAttribute = marketAttribute;
            if (marketAttribute.MarketGroups.length > 0) {
                //this.isMarketGroupExist = true;
                this.alertService.alert("This attribute has groups underneath, please delete the groups before removing this attribute.");
            }
            else {
                //this.isMarketGroupExist = false;
                this.alertService.confirmAsync("Would you like to delete this attribute?",
                    async () => {
                        if (this.selectedMarketAttribute != null) {
                            const index: number = this.marketAttributes.indexOf(this.selectedMarketAttribute);
                            if (index !== -1)
                                this.marketAttributes.splice(index, 1);
                            //this.deleteAttributeModal.hide();
                        }
                    },
                    () => {

                    });
            }
            //this.deleteAttributeModal.show();
        }
    }

    //fnRemoveAttribute(): void {
    //    if (this.selectedMarketAttribute != null) {
    //        const index: number = this.marketAttributes.indexOf(this.selectedMarketAttribute);
    //        if (index !== -1)
    //            this.marketAttributes.splice(index, 1);
    //        this.deleteAttributeModal.hide();
    //    }
    //}

    //fnCloseDeleteAttributeModal(): void {
    //    this.selectedMarketAttribute = null;
    //    this.deleteAttributeModal.hide();
    //}

    async fnSaveAttribute(marketAttributeForm: NgForm) {
        if (this.validateMarketAttributeName(this.attributeName)) {
            if (this.selectedMarketAttribute == null) {
                let attributeId = await this.groupingService.uniqueID();
                let orderNo = await this.fnGetOrderNo();
                this.marketAttributes.push({ Id: 1, AttributeId: +attributeId, Name: this.attributeName, OrderNo: orderNo, MarketDefinitionId: this.marketDefId, MarketGroups: [] });

                //let groupViewRecord = {
                //    Id: 100, AttributeId: +attributeId, ParentId: +attributeId, GroupId: +groupId,
                //    IsAttribute: true, GroupName: this.groupName, AttributeName: rec.Name, OrderNo: +rec.OrderNo,
                //    MarketDefinitionId: +this.marketDefId
                //};
                //this.fnAddRecordInGroupView(groupViewRecord);
            }
            else {
                this.selectedMarketAttribute.Name = this.attributeName;

                let groupView = this.marketGroupView.filter(v => v.AttributeId == this.selectedMarketAttribute.AttributeId && v.IsAttribute == true);
                groupView.forEach((gv: MarketGroupView) => {
                    gv.AttributeName = this.attributeName;
                });
            }

            this.marketAttributeModal.hide();
            setTimeout(() => { marketAttributeForm.reset(); }, 1000);
        }
    }

    fnCancelAttribute(): void {
        this.isMarketAttributeNameExist = false;
        this.marketAttributeModal.hide();
    }

    public isAttributeNameEmpty: boolean = false;
    public isAttrNameHasEmptySpaceAtLastChar: boolean = false;
    public attributeNameChange(marketAttributeForm: NgForm): void {
        this.isAttributeNameEmpty = false;
        if (this.attributeName.trim() == "") {
            this.isAttributeNameEmpty = true;
            marketAttributeForm.form.controls['attributeName'].setErrors({ 'incorrect': true });
            this.isAttrNameHasEmptySpaceAtLastChar = false;
            this.attributeNameMaxlengthError = false;
        }
        else if (this.attributeName[this.attributeName.length - 1] === ' ') {
            this.isAttrNameHasEmptySpaceAtLastChar = true;
            marketAttributeForm.form.controls['attributeName'].setErrors({ 'incorrect': true });
            this.isAttributeNameEmpty = false;
            this.attributeNameMaxlengthError = false;

        }
        else if (this.attributeName.length > 25) {
            this.isAttributeNameEmpty = false;
            this.isAttrNameHasEmptySpaceAtLastChar = false;
            this.attributeNameMaxlengthError = true;
            marketAttributeForm.form.controls['attributeName'].setErrors({ 'incorrect': true });
        }
        else {
            this.isAttributeNameEmpty = false;
            this.isAttrNameHasEmptySpaceAtLastChar = false;
            this.attributeNameMaxlengthError = false;
            if (this.validateMarketAttributeName(this.attributeName)) {
                this.isMarketAttributeNameExist = false;
            }
            else {
                this.isMarketAttributeNameExist = true;
                marketAttributeForm.form.controls['attributeName'].setErrors({ 'incorrect': true });
            }
        }
    }

    private validateMarketAttributeName(attributeName: string): boolean {
        var item: MarketAttribute[] = [];
        if (this.selectedMarketAttribute == null) {
            item = this.marketAttributes
                .filter(m => m.Name.toLowerCase().trim() === attributeName.toLowerCase().trim());
        }
        else {
            item = this.marketAttributes
                .filter(m => m.Name.toLowerCase().trim() === attributeName.toLowerCase().trim()
                    && m.AttributeId != this.selectedMarketAttribute.AttributeId);
        }

        if (item.length == 0) {
            return true;
        }
        return false;
    }

    fnAddNewGroup(marketAttribute: MarketAttribute) {
        this.groupName = "";
        this.selectedMarketGroup = null;
        this.selectedMarketAttribute = marketAttribute;
        this.groupingModal.show();
        setTimeout(() => {
            document.getElementById("groupName").focus();
        }, 1000);
    }

    fnEditGroup(event: any): void {
        if (event != null && event.MarketGroup && event.MarketAttribute != null) {
            if (event.MarketAttribute != null && event.MarketGroup != null) {
                this.selectedMarketGroup = event.MarketGroup;
                this.selectedMarketAttribute = event.MarketAttribute;
                this.groupName = this.selectedMarketGroup.Name;
                this.groupingModal.show();
                setTimeout(() => {
                    document.getElementById("groupName").focus();
                }, 1000);
            }
        }
    }

    fnRemoveGroup(event: any): void {
        if (event != null && event.MarketGroup && event.MarketAttribute != null) {
            this.alertService.confirmAsync("Would you like to delete this group?",
                async () => {
                    let groupId: number = event.MarketGroup.GroupId;

                    if (event.MarketGroup.IsInherited == true) {
                        const index: number = this.marketAttributes.indexOf(event.MarketAttribute);
                        if (index != -1) {
                            this.removeEachMarketGroup(this.marketAttributes[index].MarketGroups, groupId);
                        }
                        //delete market group view
                        let groupViewByGroupId = this.marketGroupView.filter(m => m.GroupId == groupId && m.AttributeId == event.MarketAttribute.AttributeId);
                        groupViewByGroupId.forEach((m: MarketGroupView) => {
                            const index: number = this.marketGroupView.indexOf(m);
                            if (index !== -1) {
                                this.marketGroupView.splice(index, 1);
                            }
                        });

                        let groupViewByParentId = this.marketGroupView.filter(m => m.ParentId == groupId && m.AttributeId == event.MarketAttribute.AttributeId);
                        groupViewByParentId.forEach((m: MarketGroupView) => {
                            const index: number = this.marketGroupView.indexOf(m);
                            if (index !== -1) {
                                this.marketGroupView.splice(index, 1);
                            }
                        });
                    }
                    else {
                        this.marketAttributes.forEach((rec: MarketAttribute) => {
                            this.removeEachMarketGroup(rec.MarketGroups, groupId);
                        });
                        //delete market group view
                        let groupViewByGroupId = this.marketGroupView.filter(m => m.GroupId == groupId);
                        groupViewByGroupId.forEach((m: MarketGroupView) => {
                            const index: number = this.marketGroupView.indexOf(m);
                            if (index !== -1) {
                                this.marketGroupView.splice(index, 1);
                            }
                        });

                        let groupViewByParentId = this.marketGroupView.filter(m => m.ParentId == groupId);
                        groupViewByParentId.forEach((m: MarketGroupView) => {
                            const index: number = this.marketGroupView.indexOf(m);
                            if (index !== -1) {
                                this.marketGroupView.splice(index, 1);
                            }
                        });

                        //Remove market group packs
                        this.marketGroupPack = this.marketGroupPack.filter(p => p.GroupId != groupId);
                    }

                },
                () => {
                });
        }
    }

    removeEachMarketGroup(marketGroup: MarketGroup[], groupId: number): void {
        marketGroup.forEach((g: MarketGroup) => {
            if (g.GroupId == groupId) {
                const index: number = marketGroup.indexOf(g);
                if (index !== -1) {
                    marketGroup.splice(index, 1);
                }
            }
            if (g.MarketGroups.length > 0) {
                this.removeEachMarketGroup(g.MarketGroups, groupId);
            }
        });
    }

    async fnSaveGroup(groupingModalForm: NgForm) {
        if (this.validateGroupName(this.groupName)) {
            if (this.selectedMarketGroup == null) {
                let groupId = await this.groupingService.uniqueID();
                let groupOrderNo = await this.getMaxGroupOrderNo();
                groupId = groupId.toString() + groupOrderNo.toString();
                this.marketAttributes.forEach((rec: MarketAttribute) => {
                    if (rec.AttributeId == this.selectedMarketAttribute.AttributeId) {
                        rec.MarketGroups.push({ Id: 100, GroupId: +groupId, Name: this.groupName, IsInherited: false, MarketDefinitionId: this.marketDefId, MarketGroups: [], GroupOrderNo: +groupOrderNo });
                        //let groupViewRecord = { Id: 100, AttributeId: rec.AttributeId, ParentId: rec.AttributeId, GroupId: +groupId, IsAttribute: true, GroupName: this.groupName, AttributeName: rec.Name, OrderNo: rec.OrderNo, MarketDefinitionId: this.marketDefId };
                        let groupViewRecord = {
                            Id: 100, AttributeId: +rec.AttributeId, ParentId: +rec.AttributeId, GroupId: +groupId,
                            IsAttribute: true, GroupName: this.groupName, AttributeName: rec.Name, OrderNo: +rec.OrderNo,
                            MarketDefinitionId: +this.marketDefId, GroupOrderNo: +groupOrderNo
                        };
                        this.fnAddRecordInGroupView(groupViewRecord);
                    }
                });
            }
            else {
                if (this.selectedMarketGroup != null) {
                    this.selectedMarketGroup.Name = this.groupName;

                    this.marketAttributes.forEach((m: MarketAttribute) => {
                        if (m.MarketGroups != null) {
                            this.updateMarketGroupName(m.MarketGroups);
                        }
                    });

                    this.marketGroupView.forEach((m: MarketGroupView) => {
                        if (m.GroupId == this.selectedMarketGroup.GroupId) {
                            m.GroupName = this.groupName;
                        }
                    });
                }
            }
        }
        this.openGroupingAccordion();
        if (!this.addMoreGroups) {
            this.groupingModal.hide();
            groupingModalForm.reset();
        }
        else {
            groupingModalForm.reset();
            groupingModalForm.controls['addMoreGroups'].setValue(true);
        }


        this.checkModificatoinOnGroupingScreen()
    }

    openGroupingAccordion(): void {
        if (this.selectedMarketAttribute != null) {
            let linkObj = $('#AddGroup' + this.selectedMarketAttribute.AttributeId);
            if (linkObj != null) {
                let isExist: number = linkObj[0].className.indexOf('collapsed');
                if (isExist !== -1)
                    $('#AddGroup' + this.selectedMarketAttribute.AttributeId).click();
            }
        }
    }

    updateMarketGroupName(marketGroup: MarketGroup[]): void {
        marketGroup.forEach((g: MarketGroup) => {
            if (g.GroupId == this.selectedMarketGroup.GroupId) {
                g.Name = this.groupName;
            }
            if (g.MarketGroups.length > 0) {
                this.updateMarketGroupName(g.MarketGroups);
            }
        });
    }

    async fnCancelGroup() {
        this.isGroupNameExist = false;
        this.groupingModal.hide();
    }

    private validateGroupName(groupName: string): boolean {
        var item: MarketGroup[] = [];
        if (this.selectedMarketGroup == null) {
            item = this.selectedMarketAttribute.MarketGroups
                .filter(m => m.Name.toLowerCase().trim() === groupName.toLowerCase().trim());
        }
        else {
            item = this.selectedMarketAttribute.MarketGroups
                .filter(m => m.Name.toLowerCase().trim() === groupName.toLowerCase().trim()
                    && m.GroupId != this.selectedMarketGroup.GroupId);
        }

        if (item.length == 0) {
            return true;
        }
        return false;
    }

    public isGroupNameEmpty: boolean = false;
    public isGrpNameHasEmptySpaceAtLastChar: boolean = false;
    public groupNameChange(groupingModalForm: NgForm): void {
        this.isGroupNameEmpty = false;
        if (this.groupName.trim() == "") {
            this.isGroupNameEmpty = true;
            groupingModalForm.form.controls['groupName'].setErrors({ 'incorrect': true });
            this.isGrpNameHasEmptySpaceAtLastChar = false;
            this.groupNameMaxlengthError = false;
        }
        else if (this.groupName[this.groupName.length - 1] === ' ') {
            this.isGrpNameHasEmptySpaceAtLastChar = true;
            groupingModalForm.form.controls['groupName'].setErrors({ 'incorrect': true });
            this.isGroupNameEmpty = false;
            this.groupNameMaxlengthError = false;
        }
        else if (this.groupName.length > 25) {
            this.groupNameMaxlengthError = true;
            groupingModalForm.form.controls['groupName'].setErrors({ 'incorrect': true });
            this.isGroupNameEmpty = false;
            this.isGrpNameHasEmptySpaceAtLastChar = false;
        }
        else {
            this.isGroupNameEmpty = false;
            this.isGrpNameHasEmptySpaceAtLastChar = false;
            this.groupNameMaxlengthError = false;
            if (this.validateGroupName(this.groupName)) {
                this.isGroupNameExist = false;
            }
            else {
                this.isGroupNameExist = true;
                groupingModalForm.form.controls['groupName'].setErrors({ 'incorrect': true });
            }
        }
    }

    fnAddRecordInGroupView(groupViewRecord: MarketGroupView) {
        this.marketGroupView.push(groupViewRecord);
        console.log("group view details:");
        console.log(this.marketGroupView);

    }

    async fnGetOrderNo() {
        let maxId = 0;
        this.marketAttributes.forEach(element => {
            if (element.OrderNo > maxId) {
                maxId = element.OrderNo;
            }
        });

        return maxId + 1;
    }

    public bindDroupdownDataSet: any[] = [];

    fnSelectGroup(event: any) {
        if (event != null && event.MarketGroup && event.MarketAttribute != null && event.LevelOrder != null) {
            this.bindDroupdownDataSet = [];
            this.selectedMarketGroup = event.MarketGroup;
            this.selectedMarketAttribute = event.MarketAttribute;
            this.levelOrder = event.LevelOrder;
            this.marketAttributes.forEach((rec: MarketAttribute) => {
                if (this.selectedMarketAttribute.OrderNo > rec.OrderNo) {
                    this.bindDroupdownDataSet.push({ Name: rec.Name, AttributeId: rec.AttributeId });
                }
            });

            if (!this.IsSourceSelectionPacks) {
                this.IsSourceSelectionPacks = true;
                //Bind source table for packs
                this.configureSourceTableForPacks();
            }
            this.loadSourceTable(true, this.dynamicPacks);
            //Bind destination table
            this.configureDestinationTable();
            //Bind destination table
            this.loadDestinationTable();

            this.uncheckSourceAndDestinationCheckbox();

        }
    }

    public groupsForSelectedDroupdown: any[] = [];
    public IsSourceSelectionPacks: boolean = true;

    fnChangeSourcetDD(event) {
        this.groupsForSelectedDroupdown = [];
        let selectedDDAttribute = JSON.parse((event.target.value));
        if (selectedDDAttribute.AttributeId != 0) {
            this.IsSourceSelectionPacks = false;
            this.marketAttributes.forEach((rec: MarketAttribute) => {
                if (rec.AttributeId == selectedDDAttribute.AttributeId) {
                    rec.MarketGroups.forEach((group: MarketGroup) => {
                        this.groupsForSelectedDroupdown.push({ Name: group.Name, AttributeId: rec.AttributeId, GroupId: group.GroupId, IsInherited: group.IsInherited });
                    });
                }
            });
            //  this.bindDroupdownDataSet.push({Name:attribute.Name,AttributeId:rec.AttributeId,GroupId:group.GroupId,IsInherited:group.IsInherited});
            console.log(this.groupsForSelectedDroupdown);
            //this.fnBindSourceTableForGroup();
            this.configureSourceTableForGroup()

            this.destinationTableData = [];
        } else {

            this.IsSourceSelectionPacks = true;
            //Bind source table for packs
            this.configureSourceTableForPacks();
            this.loadSourceTable(true, this.dynamicPacks);
            //Bind destination table
            this.loadDestinationTable();
        }
    }

    fnMarketBaseTableCellClick(event: Event) {
        //debugger;
    }

    fnMoveGroupOrPacks() {
        if (!this.IsSourceSelectionPacks) {
            this.moveGroups();
        } else {
            this.movePacks();
            //Bind source table
            this.loadSourceTable(true, this.dynamicPacks);
        }
        this.uncheckSourceAndDestinationCheckbox();
    }

    checkModificatoinOnGroupingScreen(): void {
        if ((JSON.stringify(this.marketGroupView) != JSON.stringify(this.tempMarketGroupView)) ||
            (JSON.stringify(this.marketGroupPack) != JSON.stringify(this.tempMarketGroupPack))) {
            this.fnToCheckModificatoinOnGroupingScreen.emit({ IsChanged: true });
        }
        else {
            this.fnToCheckModificatoinOnGroupingScreen.emit({ IsChanged: false });
        }
    }

    private moveGroups(): void {
        //let isSelected: boolean = false;
        jQuery("#source-table tbody tr .p-table-checkbox .checkbox-source-table").each((i, ele) => {
            if (jQuery(ele).prop("checked") == true) {
                let groupID = jQuery(ele).attr("data-sectionvalue");

                let filterGroup: MarketGroup[] = [];
                let attributeId: number = this.selectedMarketAttribute.AttributeId;
                this.marketAttributes.forEach((m: MarketAttribute) => {
                    if (filterGroup.length === 0) {
                        filterGroup = m.MarketGroups.filter(g => g.GroupId == groupID);
                        //attributeId = m.AttributeId;
                    }
                });

                this.selectedMarketGroup.MarketGroups.push({
                    Id: 100, GroupId: +groupID, Name: filterGroup[0].Name, IsInherited: true,
                    MarketDefinitionId: this.marketDefId, MarketGroups: [], GroupOrderNo: +filterGroup[0].GroupOrderNo
                });

                let groupViewRecord = {
                    Id: 100, AttributeId: +attributeId, ParentId: +this.selectedMarketGroup.GroupId, GroupId: +groupID,
                    IsAttribute: false, GroupName: filterGroup[0].Name, AttributeName: this.selectedMarketGroup.Name,
                    OrderNo: 0, MarketDefinitionId: +this.marketDefId, GroupOrderNo: +filterGroup[0].GroupOrderNo
                };

                this.fnAddRecordInGroupView(groupViewRecord);
                jQuery(ele).attr("checked", false);
                jQuery(ele).attr("disabled", true);
                //isSelected = true;
            }
        });

        //if (isSelected) {
        //    jQuery('input[name="group"]').prop('checked', false);
        //}

        this.checkModificatoinOnGroupingScreen();
    }

    private movePacks(): void {
        //let packs = Object.assign([], this.dynamicPacks);
        let isSelected: boolean = false;
        jQuery("#source-table tbody tr .p-table-checkbox .checkbox-source-table").each((i, ele) => {
            if (jQuery(ele).prop("checked") == true) {
                let PFC = jQuery(ele).attr("data-sectionvalue");
                //let dynamicPack = packs.filter(p => p.PFC == PFC);
                let dynamicPack = this.dynamicPacks.filter(p => p.PFC == PFC);

                if (dynamicPack.length > 0) {
                    //const index: number = packs.indexOf(dynamicPack[0]);
                    //if (index !== -1) {
                    //    packs.splice(index, 1);
                    //}

                    let mktPacks = this.marketGroupPack.filter(p => p.GroupId == this.selectedMarketGroup.GroupId);
                    let count = mktPacks.filter(p => p.PFC == PFC);
                    if (count.length === 0) {
                        let groupPack = {
                            Id: 100, PFC: dynamicPack[0].PFC, GroupId: +this.selectedMarketGroup.GroupId,
                            MarketDefinitionId: + this.marketDefId
                        };

                        this.marketGroupPack.push(groupPack);
                        //this.destinationPacks.push(dynamicPack[0]);
                    }
                    jQuery(ele).attr("checked", false);
                    isSelected = true;
                }
            }
        });

        if (isSelected) {
            //jQuery('input[name="group"]').prop('checked', false);
            //Load destination table
            this.loadDestinationTable(true);
        }

        this.checkModificatoinOnGroupingScreen();

        //this.fnBindSourceTable();
        //this.sourceTableData = packs;
    }

    fnRemovePacks(): void {
        let isSelected: boolean = false;
        jQuery("#destination-table tbody tr .p-table-checkbox .checkbox-destination-table").each((i, ele) => {
            if (jQuery(ele).prop("checked") == true) {
                let PFC = jQuery(ele).attr("data-sectionvalue");
                //let destinationPack = this.destinationPacks.filter(p => p.PFC == PFC);
                let destinationPack = this.dynamicPacks.filter(p => p.PFC == PFC);

                //delete packs
                if (destinationPack.length > 0) {
                    //const index: number = this.destinationPacks.indexOf(destinationPack[0]);
                    //if (index !== -1) {
                    //    this.destinationPacks.splice(index, 1);
                    //}

                    let groupPack = this.marketGroupPack.filter(m => m.PFC == destinationPack[0].PFC && m.GroupId == this.selectedMarketGroup.GroupId);
                    if (groupPack.length > 0) {
                        const i: number = this.marketGroupPack.indexOf(groupPack[0]);
                        if (i !== -1) {
                            this.marketGroupPack.splice(i, 1);
                            jQuery(ele).attr("checked", false);
                        }
                    }
                    //this.dynamicPacks.push(destinationPack[0]);
                    isSelected = true;
                }
            }
        });

        if (isSelected) {
            //jQuery('input[name="group"]').prop('checked', false);

            //Bind destination table
            this.loadDestinationTable(true);
            //Bind source table
            this.loadSourceTable(true, this.dynamicPacks);
        }

        this.checkModificatoinOnGroupingScreen();
        this.uncheckSourceAndDestinationCheckbox();

    }

    private uncheckSourceAndDestinationCheckbox() {
        jQuery("#source-table tbody tr .p-table-checkbox .checkbox-source-table").each((i, ele) => {
            jQuery(ele).attr("checked", false);
        });
        jQuery(".select-all-source-table").prop("checked", false);

        jQuery("#destination-table tbody tr .p-table-checkbox .checkbox-destination-table").each((i, ele) => {
            jQuery(ele).prop("checked", false);
        });
        jQuery(".select-all-destination-table").prop("checked", false);
    }

    public loadDestinationTable(isLoadDestinationData: boolean = true): void {
        if (this.selectedMarketGroup != null) {
            this.filteredItems = new Array();
            this.filteredItems.push(this.selectedMarketGroup.GroupId);
            if (this.selectedMarketGroup.MarketGroups != undefined)
                this.getNestedGroupId(this.selectedMarketGroup.MarketGroups, this.selectedMarketGroup.Name);
            //let mktPacks = this.marketGroupPack.filter(p => this.filteredItems.includes(p.GroupId));

            let mktPacks = this.marketGroupPack.filter(p => {
                let index = this.filteredItems.indexOf(p.GroupId);
                if (index != -1)
                    return true;
                else
                    return false;
            });

            let destinationPack: any[] = [];
            let groupId = this.selectedMarketGroup.GroupId;
            mktPacks.forEach((rec: any) => {
                let groupPack = this.dynamicPacks.filter(p => p.PFC == rec.PFC);
                if (groupPack.length > 0) {
                    if (rec.GroupId == groupId) {
                        groupPack[0].FromGroup = 'Yes';
                    }
                    else {
                        groupPack[0].FromGroup = '';
                    }
                    let isPackExist = destinationPack.filter(d => d.PFC == groupPack[0].PFC);
                    if (isPackExist.length === 0)
                        destinationPack.push(groupPack[0]);
                }
            });
            this.destinationTableData = [];
            if (isLoadDestinationData) {
                this.destinationTableData = destinationPack;
            }
        }
        else {
            this.destinationTableData = [];
        }

        setTimeout(() => {
            if (this.selectedMarketGroup == null || this.selectedMarketGroup == undefined) {
                jQuery("input[name='group']").attr("checked", false);
            }

            jQuery("#destination-table tbody tr .p-table-checkbox .checkbox-destination-table").each((i, ele) => {
                let PFC = jQuery(ele).attr("data-sectionvalue");
                let currentGroupPack = this.marketGroupPack.filter(m => m.GroupId === this.selectedMarketGroup.GroupId && m.PFC == PFC);
                if (currentGroupPack.length == 0) {
                    jQuery(ele).attr("disabled", true);
                }
                else {
                    jQuery(ele).attr("disabled", false);
                }
            });
        }, 500);
    }

    filteredItems: any[] = new Array();
    private getNestedGroupId(marketGroup: MarketGroup[], selectedGroupName: string): void {
        if (marketGroup.length > 0) {
            marketGroup.forEach(mkt => {
                let index = this.filteredItems.indexOf(mkt.GroupId);
                if (index == -1)
                    this.filteredItems.push(mkt.GroupId);

                if (mkt.MarketGroups.length > 0)
                    this.getNestedGroupId(mkt.MarketGroups, mkt.Name)
                else {
                    this.marketAttributes.forEach(attr => {
                        if (this.selectedMarketAttribute.AttributeId != attr.AttributeId) {
                            attr.MarketGroups.forEach(grp => {
                                if (grp.Name == mkt.Name) {
                                    this.getNestedGroupId(grp.MarketGroups, grp.Name)
                                }
                            });
                        }
                    });
                }
            });
        }
        else {
            this.marketAttributes.forEach(attr => {
                if (this.selectedMarketAttribute.AttributeId != attr.AttributeId) {
                    attr.MarketGroups.forEach(grp => {
                        if (grp.Name == selectedGroupName && grp.MarketGroups.length > 0) {
                            this.getNestedGroupId(grp.MarketGroups, grp.Name)
                        }
                    });
                }
            });
        }
    }

    private loadSourceTable(isPackBind: boolean, data: any[]): void {
        //if (isPackBind) {
        //    this.configureSourceTableForPacks();
        //}
        //else {
        //    this.configureSourceTableForGroup();
        //}
        this.sourceTableData = data;
    }

    public sourceTableBind: any;
    public sourceTableData: any[] = [];
    configureSourceTableForPacks() {
        this.sourceTableBind = {
            tableID: "source-table",
            tableClass: "table table-border ",
            tableName: "Available Packs",
            enableSerialNo: false,
            tableRowIDInternalName: "PFC",
            tableColDef: [
                { headerName: 'PFC', width: '35%', internalName: 'PFC', className: "dynamic-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
                { headerName: 'Pack Name', width: '65%', internalName: 'Pack', className: "dynamic-pack-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Market Base', width: '15%', internalName: 'MarketBase', className: "dynamic-market-base", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Product', width: '15%', internalName: 'Product', className: "dynamic-product", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Manufacturer', width: '8%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'ATC4 Code', width: '7%', internalName: 'ATC4', className: "dynamic-atc4", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'NEC4 Code', width: '7%', internalName: 'NEC4', className: "dynamic-nec4", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Molecule', width: '29%', internalName: 'Molecule', className: "dynamic-Molecule", sort: true, type: "", onClick: "", visible: false },
            ],
            enableSearch: true,
            enableCheckbox: true,
            enablePagination: true,
            enableRecordCreateBtn: false,
            pageSize: 500,
            displayPaggingSize: 10,
            enablePTableDataLength: false,
            columnNameSetAsClass: 'ChangeFlag',
            enabledStaySeletedPage: true,
            enabledColumnResize: true,
            enabledColumnSetting: true,
            enabledColumnFilter: true,
            enabledReflow: true,
            enabledFixedHeader: true,
            enabledDynamicTableWidth: true,
            defaultSorting: { sortingColumn: "Pack", sortingOrder: "asc" },
            pTableStyle: {
                tableOverflow: false,
                tableOverflowY: true,
                maxColumnForDynamicWidth: 3,
                overflowContentWidth: '100%',
                overflowContentHeight: '478px',
                paginationPosition: 'left',
                dynamicOverflowContentWidth: '170%'
            }
        };
        //Dynamic Table ends
    }

    configureSourceTableForGroup() {
        this.sourceTableBind.tableColDef = [
            { headerName: 'Group', width: '100%', internalName: 'Name', className: "dynamic-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
        ]
        this.sourceTableBind.tableName = "Available Groups",
            this.sourceTableBind.tableRowIDInternalName = "GroupId",
            this.sourceTableBind.pTableStyle = {
                tableOverflow: true,
                overflowContentWidth: '100%',
                overflowContentHeight: '478px',
                paginationPosition: 'left',
            }
        //this.sourceTableData = this.groupsForSelectedDroupdown;
        let colName = "Name";
        this.sourceTableData = this.groupsForSelectedDroupdown = this.groupsForSelectedDroupdown.sort((n1, n2) => {
            if (n1[colName] > n2[colName]) { return 1; }
            if (n1[colName] < n2[colName]) { return -1; }
            return 0;
        });

        setTimeout(() => {
            jQuery("#source-table tbody tr .p-table-checkbox .checkbox-source-table").each((i, ele) => {
                let groupID = jQuery(ele).attr("data-sectionvalue");
                if (this.levelOrder > 0) {
                    //jQuery(ele).attr("disabled", true);
                }
                else {
                    if (this.selectedMarketGroup != null) {
                        this.selectedMarketGroup.MarketGroups.forEach(
                            (m) => {
                                if (m.GroupId == groupID) {
                                    jQuery(ele).attr("disabled", true);
                                }
                            });
                    }
                }
            });
        }, 500);

    }

    fnSourceCheckboxAllClick(event: any): void {
        if (!this.IsSourceSelectionPacks) {
            setTimeout(() => {
                jQuery("#source-table tbody tr .p-table-checkbox .checkbox-source-table").each((i, ele) => {
                    let groupID = jQuery(ele).attr("data-sectionvalue");
                    if (this.levelOrder > 0) {
                        //jQuery(ele).attr("disabled", true);
                    }
                    else {
                        if (this.selectedMarketGroup != null) {
                            this.selectedMarketGroup.MarketGroups.forEach(
                                (m) => {
                                    if (m.GroupId == groupID) {
                                        jQuery(ele).prop("checked", false);
                                    }
                                });
                        }
                    }
                });
            }, 500);
        }
    }

    fnDestinationCheckboxAllClick(event: any): void {
        setTimeout(() => {
            jQuery("#destination-table tbody tr .p-table-checkbox .checkbox-destination-table").each((i, ele) => {
                let PFC = jQuery(ele).attr("data-sectionvalue");
                if (PFC > 0 && jQuery(ele).prop("disabled")) {
                    jQuery(ele).attr("checked", false);
                }
            });
        }, 500);
    }

    public destinationTableBind: any;
    public destinationTableData: any[] = [];

    //autocomplete selection handlers
    public onATC1Selected(selected: any) { this.atc1List = selected || []; if (this.atc1List.length > 0) { jQuery(".checkbox-atc1").prop("checked", true); } else { jQuery(".checkbox-atc1").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || []; }
    public onATC2Selected(selected: any) { this.atc2List = selected || []; if (this.atc2List.length > 0) { jQuery(".checkbox-atc2").prop("checked", true); } else { jQuery(".checkbox-atc2").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc3List).concat(this.atc4List) || []; }
    public onATC3Selected(selected: any) { this.atc3List = selected || []; if (this.atc3List.length > 0) { jQuery(".checkbox-atc3").prop("checked", true); } else { jQuery(".checkbox-atc3").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc4List) || []; }
    public onATC4Selected(selected: any) { this.atc4List = selected || []; if (this.atc4List.length > 0) { jQuery(".checkbox-atc4").prop("checked", true); } else { jQuery(".checkbox-atc4").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc3List) || []; }
    public onNEC1Selected(selected: any) { this.nec1List = selected || []; if (this.nec1List.length > 0) { jQuery(".checkbox-nec1").prop("checked", true); } else { jQuery(".checkbox-nec1").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || []; }
    public onNEC2Selected(selected: any) { this.nec2List = selected || []; if (this.nec2List.length > 0) { jQuery(".checkbox-nec2").prop("checked", true); } else { jQuery(".checkbox-nec2").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec3List).concat(this.nec4List) || []; }
    public onNEC3Selected(selected: any) { this.nec3List = selected || []; if (this.nec3List.length > 0) { jQuery(".checkbox-nec3").prop("checked", true); } else { jQuery(".checkbox-nec3").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec4List) || []; }
    public onNEC4Selected(selected: any) { this.nec4List = selected || []; if (this.nec4List.length > 0) { jQuery(".checkbox-nec4").prop("checked", true); } else { jQuery(".checkbox-nec4").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec3List) || []; }
    public onMoleculeSelected(selected: any) { this.moleculeList = selected || []; if (this.moleculeList.length > 0) { jQuery(".checkbox-molecule").prop("checked", true); } else { jQuery(".checkbox-molecule").prop("checked", false) } }
    public onManufacturerSelected(selected: any) { this.manufacturerList = selected || []; if (this.manufacturerList.length > 0) { jQuery(".checkbox-mfr").prop("checked", true); } else { jQuery(".checkbox-mfr").prop("checked", false) } }
    public onProductSelected(selected: any) { this.productList = selected || []; if (this.productList.length > 0) { jQuery(".checkbox-product").prop("checked", true); } else { jQuery(".checkbox-product").prop("checked", false) } }
    public onPoisonScheduleSelected(selected: any) { this.poisonScheduleList = selected || []; if (this.poisonScheduleList.length > 0) { jQuery(".checkbox-poisonschedule").prop("checked", true); } else { jQuery(".checkbox-poisonschedule").prop("checked", false) } }
    public onFormSelected(selected: any) { this.formList = selected || []; if (this.formList.length > 0) { jQuery(".checkbox-form").prop("checked", true); } else { jQuery(".checkbox-form").prop("checked", false) } }

    async fnApplyAdditionalFilters() {
        jQuery("#groupingFilterModal").modal("hide");
        this.alertService.fnLoading(true);
        let AdditionalFilter = [];
        jQuery("div#groupingFilterModal .selected-checkbox input[type='checkbox']").each((i, ele) => {
            if (jQuery(ele).prop("checked")) {
                let checkboxID = jQuery(ele).attr("name");
                console.log("checkboxID: ", checkboxID, this.atc4List);
                if (checkboxID.toLowerCase() == 'atc1' && this.atc1List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-ATC 1", Criteria: "ATC 1", Values: this.getCSV(this.atc1List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC1, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC1 });
                }
                if (checkboxID.toLowerCase() == 'atc2' && this.atc2List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-ATC 2", Criteria: "ATC 2", Values: this.getCSV(this.atc2List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC2, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC2 });
                }
                if (checkboxID.toLowerCase() == 'atc3' && this.atc3List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-ATC 3", Criteria: "ATC 3", Values: this.getCSV(this.atc3List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC3, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC3 });
                }
                if (checkboxID.toLowerCase() == 'atc4' && this.atc4List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-ATC 4", Criteria: "ATC 4", Values: this.getCSV(this.atc4List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC4, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC4 });
                }

                if (checkboxID.toLowerCase() == 'nec1' && this.nec1List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-NEC 1", Criteria: "NEC 1", Values: this.getCSV(this.nec1List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC1, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC1 });
                }
                if (checkboxID.toLowerCase() == 'nec2' && this.nec2List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-NEC 2", Criteria: "NEC 2", Values: this.getCSV(this.nec2List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC2, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC2 });
                }
                if (checkboxID.toLowerCase() == 'nec3' && this.nec3List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-NEC 3", Criteria: "NEC 3", Values: this.getCSV(this.nec3List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC3, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC3 });
                }
                if (checkboxID.toLowerCase() == 'nec4' && this.nec4List.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-NEC 4", Criteria: "NEC 4", Values: this.getCSV(this.nec4List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC4, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC4 });
                }

                if (checkboxID.toLowerCase() == 'mfr' && this.manufacturerList.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-MFR", Criteria: "MFR", Values: this.getCSV(this.manufacturerList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeMFR, IsExclude: this.includeExcludeArray[0].checkboxExcludeMFR });
                }
                if (checkboxID.toLowerCase() == 'product' && this.productList.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-Product", Criteria: "Product", Values: this.getCSV(this.productList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludePRODUCT, IsExclude: this.includeExcludeArray[0].checkboxExcludePRODUCT });
                }
                if (checkboxID.toLowerCase() == 'molecule' && this.moleculeList.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-Molecule", Criteria: "Molecule", Values: this.getCSV(this.moleculeList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeMOLECULE, IsExclude: this.includeExcludeArray[0].checkboxExcludeMOLECULE });
                }
                if (checkboxID.toLowerCase() == 'flagging' && jQuery("#v11").val() != "") {
                    if (jQuery("#v11").val() != 'All') {
                        AdditionalFilter.push({ Id: 1, Name: "filter-Flagging", Criteria: "Flagging", Values: "'" + jQuery("#v11").val() + "'", IsEnabled: true, IsExclude: true });
                    }
                }
                if (checkboxID.toLowerCase() == 'branding' && jQuery("#v12").val() != "") {
                    if (jQuery("#v12").val() != 'All') {
                        AdditionalFilter.push({ Id: 1, Name: "filter-Branding", Criteria: "Branding", Values: "'" + jQuery("#v12").val() + "'", IsEnabled: true, IsExclude: true });
                    }
                }
                if (checkboxID.toLowerCase() == 'poisonschedule' && this.poisonScheduleList.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-Poison", Criteria: "PoisonSchedule", Values: this.getCSV(this.poisonScheduleList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludePOISON, IsExclude: this.includeExcludeArray[0].checkboxExcludePOISON });
                }
                if (checkboxID.toLowerCase() == 'form' && this.formList.length > 0) {
                    AdditionalFilter.push({ Id: 1, Name: "filter-Form", Criteria: "Form", Values: this.getCSV(this.formList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeFORM, IsExclude: this.includeExcludeArray[0].checkboxExcludeFORM });
                }
            }
        });


        //remove previous filter from filter table
        this.marketGroupFilter = this.marketGroupFilter.filter((rec: MarketGroupFilter) => { if (rec.GroupId == this.selectedGroup.GroupId && rec.AttributeId == this.selectedAttribute.AttributeId) { return false; } else { return true } });
        //assign filter into filter table
        AdditionalFilter.forEach((rec: any) => {
            this.marketGroupFilter.push({ Id: 1, Name: rec.Name, Criteria: rec.Criteria, Values: rec.Values, IsEnabled: rec.IsEnabled, IsAttribute: this.selectedGroup.IsInherited, AttributeId: this.selectedAttribute.AttributeId, GroupId: this.selectedGroup.GroupId, MarketDefinitionId: this.marketDefId });
        });
        await this.fnFindPacksForFilter(AdditionalFilter, this.selectedGroup, this.selectedAttribute);
    }

    async fnFindPacksForFilter(filters: any[], group: MarketGroup, attribute: MarketAttribute) {
        let dataSetAfterATCFilterAppply: MarketDefinitionPacks[] = this.dynamicPacks || [];
        let dataSetAfterNECFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterMFRFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterProductFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterMoleculeFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterPoisonFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterFormFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterFlaggingFilterAppply: MarketDefinitionPacks[] = [];
        let dataSetAfterBrandingFilterAppply: MarketDefinitionPacks[] = [];
        let atc1Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'atc 1') { return true; } else { return false; } }) || [];
        let atc2Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'atc 2') { return true; } else { return false; } }) || [];
        let atc3Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'atc 3') { return true; } else { return false; } }) || [];
        let atc4Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'atc 4') { return true; } else { return false; } }) || [];
        let nec1Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'nec 1') { return true; } else { return false; } }) || [];
        let nec2Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'nec 2') { return true; } else { return false; } }) || [];
        let nec3Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'nec 3') { return true; } else { return false; } }) || [];
        let nec4Filter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'nec 4') { return true; } else { return false; } }) || [];

        let mfrFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'mfr') { return true; } else { return false; } }) || [];
        let moleculeFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'molecule') { return true; } else { return false; } }) || [];
        let productFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'product') { return true; } else { return false; } }) || [];
        let poisonFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'poisonschedule') { return true; } else { return false; } }) || [];
        let formFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'form') { return true; } else { return false; } }) || [];
        let flaggingFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'flagging') { return true; } else { return false; } }) || [];
        let brandingFilter = filters.filter((rec: any) => { if (rec.Criteria.toLowerCase() == 'Branding') { return true; } else { return false; } }) || [];
        //for atc type filter
        if (atc1Filter.length > 0 || atc2Filter.length > 0 || atc3Filter.length > 0 || atc4Filter.length > 0) {
            dataSetAfterATCFilterAppply = await this.dynamicPacks.filter((rec: any) => {
                //let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(atc4Filter, rec.ATC4, 'atc4') || false;
                let filterFlagATC1: boolean = this.fnCheckFilterCriteriaForSpecificPack(atc1Filter, rec.ATC1, 'atc1') || false;
                let filterFlagATC2: boolean = this.fnCheckFilterCriteriaForSpecificPack(atc2Filter, rec.ATC2, 'atc2') || false;
                let filterFlagATC3: boolean = this.fnCheckFilterCriteriaForSpecificPack(atc3Filter, rec.ATC3, 'atc3') || false;
                let filterFlagATC4: boolean = this.fnCheckFilterCriteriaForSpecificPack(atc4Filter, rec.ATC4, 'atc4') || false;

                if (filterFlagATC1 || filterFlagATC2 || filterFlagATC3 || filterFlagATC4) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            console.log("after atc filter: ", dataSetAfterATCFilterAppply)
        }

        //for nec type filter
        dataSetAfterNECFilterAppply = dataSetAfterATCFilterAppply || [];
        if (nec1Filter.length > 0 || nec2Filter.length > 0 || nec3Filter.length > 0 || nec4Filter.length > 0) {
            dataSetAfterNECFilterAppply = await dataSetAfterATCFilterAppply.filter((rec: MarketDefinitionPacks) => {
                // let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(nec4Filter, rec.NEC4, 'nec4')||false;
                let filterFlagNEC1: boolean = this.fnCheckFilterCriteriaForSpecificPack(nec1Filter, rec.NEC1, 'nec1') || false;
                let filterFlagNEC2: boolean = this.fnCheckFilterCriteriaForSpecificPack(nec2Filter, rec.NEC2, 'nec2') || false;
                let filterFlagNEC3: boolean = this.fnCheckFilterCriteriaForSpecificPack(nec3Filter, rec.NEC3, 'nec3') || false;
                let filterFlagNEC4: boolean = this.fnCheckFilterCriteriaForSpecificPack(nec4Filter, rec.NEC4, 'nec4') || false;

                if (filterFlagNEC1 || filterFlagNEC2 || filterFlagNEC3 || filterFlagNEC4) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            //console.log("after nec filter nec: ", dataSetAfterNECFilterAppply)
        }

        //for manufacturer filter apply
        dataSetAfterMFRFilterAppply = dataSetAfterNECFilterAppply || [];
        if (mfrFilter.length > 0 && mfrFilter != null) {
            dataSetAfterMFRFilterAppply = await dataSetAfterNECFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(mfrFilter, rec.Manufacturer, 'mfr') || false;
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            //console.log("after mfr filter: ", dataSetAfterMFRFilterAppply)
        }


        //for product filter apply
        dataSetAfterProductFilterAppply = dataSetAfterMFRFilterAppply || [];
        if (productFilter.length > 0 && productFilter != null) {
            dataSetAfterProductFilterAppply = await dataSetAfterMFRFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(productFilter, rec.Product, 'product') || false;
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            // console.log("after product filter: ", dataSetAfterProductFilterAppply)
        }

        //for Poison filter apply
        dataSetAfterPoisonFilterAppply = dataSetAfterProductFilterAppply || [];
        if (poisonFilter.length > 0 && poisonFilter != null) {
            dataSetAfterPoisonFilterAppply = await dataSetAfterProductFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(poisonFilter, rec.PoisonSchedule, 'poisonschedule') || false;
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            // console.log("after product filter: ", dataSetAfterProductFilterAppply)
        }

        //for form filter apply
        dataSetAfterFormFilterAppply = dataSetAfterPoisonFilterAppply || [];
        if (formFilter.length > 0 && formFilter != null) {
            dataSetAfterFormFilterAppply = await dataSetAfterPoisonFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(formFilter, rec.Form, 'form') || false;
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            // console.log("after product filter: ", dataSetAfterProductFilterAppply)
        }

        //for Branding filter apply
        dataSetAfterBrandingFilterAppply = dataSetAfterFormFilterAppply || [];
        if (brandingFilter.length > 0 && brandingFilter != null) {
            dataSetAfterBrandingFilterAppply = await dataSetAfterFormFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(brandingFilter, rec.Branding, 'branding') || false;
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            // console.log("after product filter: ", dataSetAfterProductFilterAppply)
        }

        //for Flagging filter apply
        dataSetAfterFlaggingFilterAppply = dataSetAfterBrandingFilterAppply || [];
        if (flaggingFilter.length > 0 && flaggingFilter != null) {
            dataSetAfterFlaggingFilterAppply = await dataSetAfterBrandingFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(flaggingFilter, rec.Flagging, 'flagging') || false;
                console.log('filterFlag', filterFlag);
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            // console.log("after product filter: ", dataSetAfterProductFilterAppply)
        }



        //for molecule filter apply
        dataSetAfterMoleculeFilterAppply = dataSetAfterFlaggingFilterAppply || [];
        if (moleculeFilter.length > 0 && moleculeFilter != null) {
            dataSetAfterMoleculeFilterAppply = await dataSetAfterFlaggingFilterAppply.filter((rec: MarketDefinitionPacks) => {
                let filterFlag: boolean = this.fnCheckFilterCriteriaForSpecificPack(moleculeFilter, rec.Molecule, 'molecule') || false;
                if (filterFlag) {
                    return true;
                } else {
                    return false
                }

            }) || [];
            //console.log("after molecule filter: ", dataSetAfterMoleculeFilterAppply)
        }



        //to add data in Market Group Packs
        if (atc1Filter.length == 0 && atc2Filter.length == 0 && atc3Filter.length == 0 && atc4Filter.length == 0 && nec1Filter.length == 0 && nec2Filter.length == 0 && nec3Filter.length == 0 && nec4Filter.length == 0 && mfrFilter.length == 0 && productFilter.length == 0 && moleculeFilter.length == 0 && poisonFilter.length == 0 && formFilter.length == 0 && flaggingFilter.length == 0 && brandingFilter.length == 0) {
            dataSetAfterMoleculeFilterAppply = [];

            this.marketGroupPack = this.marketGroupPack.filter(pack => pack.GroupId != this.selectedGroup.GroupId);
            //load destination table
            this.loadDestinationTable()

        } else {
            //remove previous data from destination list 
            this.marketGroupPack = this.marketGroupPack.filter((rec: MarketGroupPack) => {
                if (rec.GroupId == this.selectedGroup.GroupId) {
                    return false;
                } else {
                    return true;
                }
            });

            //to add new pfc in marketgroup packs
            dataSetAfterMoleculeFilterAppply.forEach((rec: MarketDefinitionPacks) => {
                this.marketGroupPack.push({ Id: 0, PFC: rec.PFC, GroupId: this.selectedGroup.GroupId, MarketDefinitionId: this.marketDefId });
            });

            //load destination table
            this.loadDestinationTable();
        }

        console.log('destination ', this.destinationTableData)
        console.log("marketGroupPack", this.marketGroupPack);

        console.log("Final data after filter apply: ", dataSetAfterMoleculeFilterAppply)
        this.alertService.fnLoading(false);
    }

    fnChangeFilterDropDown(event: any, type: any) {
        if (type == 'Flagging') {
            jQuery(".checkbox-flagging").prop("checked", true);
        } else if (type == 'Branding') {
            jQuery(".checkbox-branding").prop("checked", true);
        }
        console.log(event.target);
    }

    fnCheckFilterCriteriaForSpecificPack(filters: any[], packValue: any, filterType: string) {
        if (filters.length == 0 || packValue == null) {
            return false;
        }

        //console.log('filters', filters);
        //console.log(filters[0].Values, filters[0].Criteria);
        let returnResult: boolean = false;
        if (filterType == 'flagging' || filterType == 'branding') {
            if (packValue.toLowerCase() == filters[0].Values.toLowerCase().replace(/'/g, '')) {
                returnResult = true;
            }
        }
        else if (filterType != 'molecule') {
            let filterDetails = this.fnArrayFromCSV(filters[0].Values, filters[0].Criteria.replace(/ /g, "").toLowerCase()) || [];
            if (filters[0].IsEnabled) {
                filterDetails.forEach((rec: any) => {
                    let index = packValue.toString().toLowerCase().indexOf(rec.Code.toString().toLowerCase())
                    if (index != -1 || returnResult) {
                        returnResult = true;
                    }
                    //if (rec.Code.toString().toLowerCase() == packValue.toString().toLowerCase() || returnResult) {
                    //    returnResult = true;
                    //}

                });
            } else {
                filterDetails.forEach((rec: any) => {
                    let index = packValue.toString().toLowerCase().indexOf(rec.Code.toString().toLowerCase())
                    if (index == -1 || returnResult) {
                        returnResult = true;
                    }
                    //if (rec.Code.toString().toLowerCase() != packValue.toString().toLowerCase() || returnResult) {
                    //    returnResult = true;
                    //}
                });
            }
        } else {
            let filterDetails = this.fnArrayFromCSV(filters[0].Values, filters[0].Criteria.replace(/ /g, "").toLowerCase()) || [];
            if (filters[0].IsEnabled) {
                filterDetails.forEach((rec: any) => {
                    let index = packValue.toString().toLowerCase().indexOf(rec.Code.toString().toLowerCase())
                    if (index != -1 || returnResult) {
                        returnResult = true;
                    }
                    //if (packValue.includes(packValue) || returnResult) {
                    //    returnResult = true;
                    //}
                });
            } else {
                filterDetails.forEach((rec: any) => {
                    let index = packValue.toString().toLowerCase().indexOf(rec.Code.toString().toLowerCase())
                    if (index == -1 || returnResult) {
                        returnResult = true;
                    }
                    //if (!packValue.includes(packValue) || returnResult) {
                    //    returnResult = true;
                    //}
                });
            }
        }
        return returnResult;
    }

    fnApplyFilterOnGroup(event: any) {
        console.log(event);
        this.fnGenerateFilterForGroup(event.MarketGroup, event.MarketAttribute);
    }

    fnGenerateFilterForGroup(group: MarketGroup, attribute: MarketAttribute) {
        console.log(group);
        this.selectedGroup = group;
        this.selectedAttribute = attribute;
        let selectedFilterUnderGroup = this.marketGroupFilter.filter((rec: MarketGroupFilter) => { if (rec.GroupId == group.GroupId && rec.AttributeId == attribute.AttributeId) { return true } else { return false; } }) || [];
        this.atcDependencyArray = []; this.necDependencyArray = [];
        this.filtersApplied = [];
        this.includeExcludeArray = [{
            checkboxExcludeATC1: true, checkboxExcludeATC2: true, checkboxExcludeATC3: true, checkboxExcludeATC4: true, checkboxExcludeNEC1: true, checkboxExcludeNEC2: true, checkboxExcludeNEC3: true, checkboxExcludeNEC4: true,
            checkboxExcludeMFR: true, checkboxExcludePRODUCT: true, checkboxExcludeMOLECULE: true, checkboxExcludePOISON: true, checkboxExcludeFORM: true
        }];

        this.atc1List = []; this.atc2List = []; this.atc3List = []; this.atc4List = []; this.nec1List = []; this.nec2List = []; this.nec3List = []; this.nec4List = []; this.moleculeList = []; this.manufacturerList = []; this.productList = [];
        jQuery("div#groupingFilterModal .selected-checkbox input[type='checkbox']").prop("checked", false);
        if (selectedFilterUnderGroup.length > 0) {
            this.isFilterApplied = true;
            selectedFilterUnderGroup.forEach((rec: any) => {
                if (rec.Criteria.toLowerCase() == 'atc 1') {
                    this.atc1List = this.fnArrayFromCSV(rec.Values, 'Atc1');
                    this.filtersApplied = this.filtersApplied.concat(this.atc1List)
                    this.includeExcludeArray[0].checkboxExcludeATC1 = rec.IsEnabled;
                    jQuery(".checkbox-atc1").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'atc 2') {
                    this.atc2List = this.fnArrayFromCSV(rec.Values, 'Atc2');
                    this.filtersApplied = this.filtersApplied.concat(this.atc2List);
                    this.includeExcludeArray[0].checkboxExcludeATC2 = rec.IsEnabled;
                    jQuery(".checkbox-atc2").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'atc 3') {
                    this.atc3List = this.fnArrayFromCSV(rec.Values, 'Atc3');
                    this.filtersApplied = this.filtersApplied.concat(this.atc3List)
                    this.includeExcludeArray[0].checkboxExcludeATC3 = rec.IsEnabled;
                    jQuery(".checkbox-atc3").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'atc 4') {
                    this.atc4List = this.fnArrayFromCSV(rec.Values, 'Atc4');
                    this.filtersApplied = this.filtersApplied.concat(this.atc4List);
                    this.includeExcludeArray[0].checkboxExcludeATC4 = rec.IsEnabled;
                    jQuery(".checkbox-atc4").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'nec 1') {
                    this.nec1List = this.fnArrayFromCSV(rec.Values, 'Nec1');
                    this.filtersApplied = this.filtersApplied.concat(this.nec1List);
                    this.includeExcludeArray[0].checkboxExcludeNEC1 = rec.IsEnabled;
                    jQuery(".checkbox-nec1").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'nec 2') {
                    this.nec2List = this.fnArrayFromCSV(rec.Values, 'Nec2');
                    this.filtersApplied = this.filtersApplied.concat(this.nec2List);
                    this.includeExcludeArray[0].checkboxExcludeNEC2 = rec.IsEnabled;
                    jQuery(".checkbox-nec2").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'nec 3') {
                    this.nec3List = this.fnArrayFromCSV(rec.Values, 'Nec3');
                    this.filtersApplied = this.filtersApplied.concat(this.nec3List);
                    this.includeExcludeArray[0].checkboxExcludeNEC3 = rec.IsEnabled;
                    jQuery(".checkbox-nec3").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'nec 4') {
                    this.nec4List = this.fnArrayFromCSV(rec.Values, 'Nec4');
                    this.filtersApplied = this.filtersApplied.concat(this.nec4List);
                    this.includeExcludeArray[0].checkboxExcludeNEC4 = rec.IsEnabled;
                    jQuery(".checkbox-nec4").prop("checked", true);
                }
                else if (rec.Criteria.toLowerCase() == 'product') {
                    this.productList = this.fnArrayFromCSV(rec.Values, 'Product');
                    this.filtersApplied = this.filtersApplied.concat(this.productList);
                    this.includeExcludeArray[0].checkboxExcludePRODUCT = rec.IsEnabled;
                    jQuery(".checkbox-product").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'molecule') {
                    this.moleculeList = this.fnArrayFromCSV(rec.Values, 'Molecule');
                    this.filtersApplied = this.filtersApplied.concat(this.moleculeList);
                    this.includeExcludeArray[0].checkboxExcludeMOLECULE = rec.IsEnabled;
                    jQuery(".checkbox-molecule").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'mfr') {
                    this.manufacturerList = this.fnArrayFromCSV(rec.Values, 'mfr');
                    this.filtersApplied = this.filtersApplied.concat(this.manufacturerList);
                    this.includeExcludeArray[0].checkboxExcludeMFR = rec.IsEnabled;
                    jQuery(".checkbox-mfr").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'flagging') {
                    jQuery("#v11").val(rec.Values.replace(/'/g, '')).change();
                    jQuery(".checkbox-flagging").prop("checked", true);
                }
                else if (rec.Criteria.toLowerCase() == 'branding') {
                    jQuery("#v12").val(rec.Values.replace(/'/g, '')).change();
                    jQuery(".checkbox-branding").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'poisonschedule') {
                    this.poisonScheduleList = this.fnArrayFromCSV(rec.Values, 'PoisonSchedule');
                    this.filtersApplied = this.filtersApplied.concat(this.poisonScheduleList);
                    this.includeExcludeArray[0].checkboxExcludePOISON = rec.IsEnabled;
                    jQuery(".checkbox-poisonschedule").prop("checked", true);
                } else if (rec.Criteria.toLowerCase() == 'form') {
                    this.formList = this.fnArrayFromCSV(rec.Values, 'Form');
                    this.filtersApplied = this.filtersApplied.concat(this.formList);
                    this.includeExcludeArray[0].checkboxExcludeFORM = rec.IsEnabled;
                    jQuery(".checkbox-form").prop("checked", true);
                }
            });
        }
        else {
            this.isFilterApplied = false;
        }
        //to remove all filter
        if (this.filtersApplied.length == 0) {
            this.filtersApplied.push({ Code: "", FilterName: "" });
        }
        this.atcDependencyArray = this.atc1List.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || [];
        this.necDependencyArray = this.nec1List.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || [];

        //to remove all disabled 
        jQuery(".autocom-content").removeClass("disabled-content");
        jQuery(".autocom-content .filter-container").removeClass("disabled");
        // if (isNaN(+marketBaseName[3]) == false) {//to disabled
        //     if (marketBaseName[0].toLowerCase() == "a") {
        //         for (var i = Number(marketBaseName[3]); i >= 0; i--) {
        //             jQuery(".autocom-content-Atc" + i).addClass("disabled-content");
        //             jQuery(".autocom-content-Atc" + i + " .filter-container").first().addClass("disabled");
        //         }
        //     } else if (marketBaseName[0].toLowerCase() == "n") {
        //         for (var i = Number(marketBaseName[3]); i >= 0; i--) {
        //             jQuery(".autocom-content-Nec" + i).addClass("disabled-content");
        //             jQuery(".autocom-content-Nec" + i + " .filter-container").first().addClass("disabled-content");
        //         }
        //     }

        // }
        jQuery("#groupingFilterModal").modal("show");

    }
    configureDestinationTable() {
        let name = this.selectedMarketGroup != null ? this.selectedMarketGroup.Name + ' - ' : '';
        this.destinationTableBind = {
            tableID: "destination-table",
            tableClass: "table table-border ",
            tableName: name + "Packs",
            enableSerialNo: false,
            tableRowIDInternalName: "PFC",
            tableColDef: [
                { headerName: 'PFC', width: '25%', internalName: 'PFC', className: "dynamic-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
                { headerName: 'Pack Name', width: '55%', internalName: 'Pack', className: "dynamic-pack-name", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'From Group', width: '20%', internalName: 'FromGroup', className: "dynamic-from-group", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Market Base', width: '35%', internalName: 'MarketBase', className: "dynamic-market-base", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Product', width: '%', internalName: 'Product', className: "dynamic-product", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Manufacturer', width: '8%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'ATC4 Code', width: '7%', internalName: 'ATC4', className: "dynamic-atc4", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'NEC4 Code', width: '7%', internalName: 'NEC4', className: "dynamic-nec4", sort: true, type: "", onClick: "", visible: false },
                { headerName: 'Molecule', width: '29%', internalName: 'Molecule', className: "dynamic-Molecule", sort: true, type: "", onClick: "", visible: false },
            ],
            enableSearch: true,
            enableCheckbox: true,
            enablePagination: true,
            pageSize: 500,
            displayPaggingSize: 10,
            enablePTableDataLength: false,
            columnNameSetAsClass: 'ChangeFlag',
            enabledStaySeletedPage: true,
            enabledColumnSetting: true,
            enabledColumnFilter: true,
            enabledReflow: true,
            enabledFixedHeader: true,
            enabledDynamicTableWidth: true,
            pTableStyle: {
                tableOverflow: false,
                tableOverflowY: true,
                overflowContentWidth: '100%',
                overflowContentHeight: '478px',
                paginationPosition: 'left',
                maxColumnForDynamicWidth: 3,
                dynamicOverflowContentWidth: '150%'
            }
        };
    }

    stringify(data: any) {
        return JSON.stringify(data);
    }
    private getCSV(arr: any[], key: string) {
        arr = arr.filter((rec: any, index: any) => { if (rec.Code != "") { return true; } else { return false; } })
        let values = arr.map(function (obj) {
            return "'" + obj[key] + "'";
        }).join(',');

        console.log(values);
        return values;
    }

    //array from csv
    private fnArrayFromCSV(values: string, filterName): any[] {
        let returnAry: any[] = [];
        if (values != undefined) {
            let formatValues = values.replace(/',/g, "'|");
            if (formatValues.indexOf('|') > 0) {// for multiple molecule
                var tempArr: any[] = formatValues.split('|');
                tempArr.forEach((item: any) => {
                    returnAry.push({ Code: item.replace(/'/g, ""), FilterName: filterName.toLowerCase() });
                });
            } else {
                returnAry.push({ Code: values.replace(/'/g, ""), FilterName: filterName.toLowerCase() });
            }
        }



        return returnAry;
    }

    //fnBackToPacksComponent() {
    //    this.fnShowPacksComponent.emit("back");
    //}




    getSortableMarketGroup(marketAttribute: MarketAttribute) {
        this.isCustomSortEnable = false;
        this.sortSelection = null;
        this.sortableMarketGroup = [];
        if (marketAttribute != null && marketAttribute.MarketGroups.length > 0) {
            this.selectedMarketAttribute = marketAttribute;
            this.sortableMarketAttribute = marketAttribute;
            marketAttribute.MarketGroups.forEach(g => {
                this.sortableMarketGroup.push({
                    "Id": g.Id, "GroupId": g.GroupId, "Name": g.Name, "IsInherited": g.IsInherited, "MarketDefinitionId": g.MarketDefinitionId, "MarketGroups": g.MarketGroups, "GroupOrderNo": +g.GroupOrderNo
                });
            });

            this.sortableMarketGroupModal.show();
        }
    }

    sortMarketGroup(sortOrder: string) {
        this.isCustomSortEnable = false;
        switch (sortOrder.toLowerCase()) {
            case 'creational': {
                if (this.sortableMarketGroup.length > 0) {
                    this.sortableMarketGroup.sort((a, b) => {
                        let firstOrderNo = a.GroupId.toString().substring(8, a.GroupId.toString().length);
                        let secondOrderNo = b.GroupId.toString().substring(8, b.GroupId.toString().length);
                        if (firstOrderNo < secondOrderNo)
                            return -1;
                        else if (firstOrderNo > secondOrderNo)
                            return 1;
                        else
                            return 0;
                    });
                }
                break;
            }
            case 'alphabetically': {
                if (this.sortableMarketGroup.length > 0) {
                    this.sortableMarketGroup.sort((a, b) => {
                        if (a.Name.toLowerCase() < b.Name.toLowerCase())
                            return -1;
                        else if (a.Name.toLowerCase() > b.Name.toLowerCase())
                            return 1;
                        else
                            return 0;
                    });
                }
                break;
            }
            case 'custom': {
                this.isCustomSortEnable = true;
                break;
            }
        }
    }

    saveSortedMarketGroup() {
        if (this.sortSelection != null) {
            if (this.sortableMarketGroup.length > 0) {
                this.sortableMarketAttribute.MarketGroups.forEach(g => {
                    let groupOrderNo = this.getSortedGroupOrderNo(g.GroupId);
                    g.GroupOrderNo = +groupOrderNo;
                });
                //marketAttribute.MarketGroups = this.sortableMarketGroup;
            }

            //update nested market group
            let soretdGroup = this.sortableMarketAttribute.MarketGroups;
            this.marketAttributes.filter(a => a.AttributeId != this.selectedMarketAttribute.AttributeId).forEach(m => {
                if (m.MarketGroups != null) {
                    m.MarketGroups.forEach(g => {
                        if (g.MarketGroups != null) {
                            g.MarketGroups.forEach(n => {
                                let nestedGroup = soretdGroup.filter(s => s.GroupId == n.GroupId);
                                if (nestedGroup.length > 0) {
                                    n.GroupOrderNo = nestedGroup[0].GroupOrderNo;
                                }
                            });
                        }
                    });
                }
            });

            //update group view here...
            this.marketGroupView.forEach((m: MarketGroupView) => {
                let nestedGroup = soretdGroup.filter(s => s.GroupId == m.GroupId);
                if (nestedGroup.length > 0) {
                    m.GroupOrderNo = nestedGroup[0].GroupOrderNo;
                }
            });

            this.sortableMarketGroupModal.hide();
        }
    }

    fnCallDuringBackModule() {
        this.selectedMarketGroup = null;
    }

    getSortedGroupOrderNo(groupId: number) {
        let index: number = 0;
        let result: number = 0;
        let breakForeach: boolean = false;
        this.sortableMarketGroup.forEach(s => {
            index += 1;
            if (s.GroupId == groupId) {
                result = index;
            }
        });
        return result;
    }

    async getMaxGroupOrderNo() {
        let maxId = 0;
        if (this.selectedMarketAttribute != null && this.selectedMarketAttribute.MarketGroups != null) {
            this.selectedMarketAttribute.MarketGroups.forEach(element => {
                if (element.GroupOrderNo > maxId) {
                    maxId = element.GroupOrderNo;
                }
            });
        }

        return maxId + 1;
    }


}
