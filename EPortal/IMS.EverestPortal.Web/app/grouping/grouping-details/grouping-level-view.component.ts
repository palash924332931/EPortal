import { Component, Input, Output, EventEmitter } from '@angular/core';
import { MarketAttribute, MarketGroup, MarketGroupFilter } from '../../shared/models/grouping/grouping-model'
import { GroupingService } from '../../shared/services/grouping.service';

@Component({
    selector: 'groupinglevelview',
    templateUrl: '../../../app/grouping/grouping-details/grouping-level-view.html'
})

export class GroupingLevelViewComponent {
    @Input() marketattribute: MarketAttribute[] = [];
    @Input() marketgroup: MarketGroup;
    @Input() levelorder: number;
    @Input() marketGroupFilter: MarketGroupFilter[] = [];
    @Output() selectGroupEvent: EventEmitter<any> = new EventEmitter();
    @Output() editGroupEvent: EventEmitter<any> = new EventEmitter();
    @Output() removeGroupEvent: EventEmitter<any> = new EventEmitter();
    @Output() applyFilterOnGroup: EventEmitter<any> = new EventEmitter() || null;
    public islockDef:boolean=false;
    ngOnInit() {
       this.islockDef = GroupingService.isLockDef;
    }

    isFilterApplied(marketGroup: MarketGroup, marketAttribute: MarketAttribute): boolean {
        let filteredGroup = this.marketGroupFilter.filter((rec: MarketGroupFilter) => {
            if (rec.GroupId == marketGroup.GroupId && rec.AttributeId == marketAttribute.AttributeId) {
                return true;
            } else {
                return false;
            }
        });
        if (filteredGroup.length > 0)
            return true;
        return false;
    }

    selectGroup(marketGroup: MarketGroup, marketAttribute: MarketAttribute, levelOrder: number) {
        this.selectGroupEvent.emit({ MarketGroup: marketGroup, MarketAttribute: marketAttribute, LevelOrder: levelOrder });
    }

    fnSelectGroup(evt) {
        this.selectGroupEvent.emit({ MarketGroup: evt.MarketGroup, MarketAttribute: evt.MarketAttribute, LevelOrder: evt.LevelOrder });
    }

    editGroup(marketGroup: MarketGroup, marketAttribute: MarketAttribute) {
        this.editGroupEvent.emit({ MarketGroup: marketGroup, MarketAttribute: marketAttribute });
    }

    fnEditGroup(evt) {
        this.editGroupEvent.emit({ MarketGroup: evt.MarketGroup, MarketAttribute: evt.MarketAttribute });
    }

    removeGroup(marketGroup: MarketGroup, marketAttribute: MarketAttribute) {
        this.removeGroupEvent.emit({ MarketGroup: marketGroup, MarketAttribute: marketAttribute });
    }

    fnRemoveGroup(evt) {
        this.removeGroupEvent.emit({ MarketGroup: evt.MarketGroup, MarketAttribute: evt.MarketAttribute });
    }

    fnGenerateFilter(selectedMarketGroup: MarketGroup, marketAttribute: MarketAttribute) {
        this.applyFilterOnGroup.emit({ MarketGroup: selectedMarketGroup, MarketAttribute: marketAttribute });
    }

    fnApplyFilterOnGroup(evt: any) {
        this.applyFilterOnGroup.emit({ MarketGroup: evt.MarketGroup, MarketAttribute: evt.MarketAttribute });
    }
}