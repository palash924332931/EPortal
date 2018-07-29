import { BaseFilter } from './base-filter-new';
import { Dimension } from './marketbase/dimension';

export class MarketBase {
    Id?: number;
    Name: string;
    Suffix: string;
    Description: string;
    DurationTo: string;
    DurationFrom: string;
    GuiId: string;
    BaseType: string;
    Filters: BaseFilter[];
    Dimension?: Dimension[];
}

export class MarketBaseDetails {
    public MarketBase: MarketBase;
    public Dimension: Dimension[];
    public PxRList?: any[];
}
