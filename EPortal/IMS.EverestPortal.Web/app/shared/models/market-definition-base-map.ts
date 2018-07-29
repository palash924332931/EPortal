import { AdditionalFilter } from './additional-filter';
import { MarketBase } from './market-base';

export class MarketDefinitionBaseMap {
    Id: number;
    Name: string;
    MarketBaseId:number;
    MarketBase: MarketBase;
    BaseFilters?:any[];
    Filters: AdditionalFilter[];
    DataRefreshType: string;
    Selected?:boolean;
    CurrentStatus?:string;
}

