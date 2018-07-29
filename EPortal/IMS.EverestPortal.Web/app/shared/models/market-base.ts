import { BaseFilter } from './base-filter';
export class MarketBase {
    Id: number;
    Name: string;
    Suffix: string;
    Description: string;
    DurationTo: string;
    DurationFrom: string;
    GuiId: string;
    BaseType:string;
    Filters: BaseFilter[];
}