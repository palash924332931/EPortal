
export class ClientMarketBase {
    Id: number;
    ClientId: number;
    ClientName: string;
    MarketBaseId: number;
    MarketBaseName: string;
    Description: string;
    BaseFilterId: number;
    BaseFilterName: string;
    BaseFilterCriteria: string;
    BaseFilterValues: string;
    BaseFilterIsEnabled: boolean;
    IsRestricted:boolean;
    IsBaseFilterType:boolean;
    UsedMarketBaseStatus:string;
    DeleteStatus?:string;
}