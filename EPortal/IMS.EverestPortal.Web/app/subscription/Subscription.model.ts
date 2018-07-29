import { MarketDefinition } from '../shared/models/market-definition';
export class SubClient {
    Id: number;
    Name: string;
    IsMyClient: boolean;
    Subscription: Subscription[] = [];
}

export class Subscription {
    SubscriptionId: number;
    Name: number;
    ClientId: number;
    Country: string;
    Service: string;
    Data: string;
    Source: string;
    StartDate: string;
    EndDate: string;
    Active: boolean;
    LastModified: string;
    ModifiedBy: number;
    Submitted: string;
    Selected: boolean = false;
    //MarketDefinitions: MarketDefinition[] = [];
    serviceTerritory: ServiceTerritory;
}
export class ServiceTerritory
{
    ServiceTerritoryId: number;
    TerritoryBase: string;
}
export class MarketBase {
    Id: number;
    Name: string;
    Suffix: string;
    Description: string;
    DurationTo: string;
    DurationFrom: string;
}

export class ClientMarketBaseDTO {
    Id: number;
    Name: string;
    Suffix: string;
    Submitted: string;
}

export class ClientSubscriptionDTO {
    ClientId :number
    ClientName: string;
    //isMyClient: boolean;
    subscriptions: Subscription;
    MarketBases: MarketBase[] = [];
}
export class ClientMarketBase {
    Id: number;
    ClientId: number;
    MarketBaseId: number;
    MarketBaseName: string;
    Suffix: string;
    Description: string;
    BaseFilterId: number;
    Name: string;
    BaseFilterName: string;
    BaseFilterCriteria: string;
    Values: string;
    BaseFilterValues: string;
    BaseFilterIsEnabled: number;
    DurationFrom: string;
    DurationTo: string;
    selected: boolean;
    isSaved: boolean;
    DeleteStatus?:string;
}
export const months : any[] =   [
    { val: '01', name: 'Jan', selected: true },
    { val: '02', name: 'Feb', selected: false },
    { val: '03', name: 'Mar', selected: false },
    { val: '04', name: 'Apr', selected: false },
    { val: '05', name: 'May', selected: false },
    { val: '06', name: 'Jun', selected: false },
    { val: '07', name: 'Jul', selected: false },
    { val: '08', name: 'Aug', selected: false },
    { val: '09', name: 'Sep', selected: false },
    { val: '10', name: 'Oct', selected: false },
    { val: '11', name: 'Nov', selected: false },
    { val: '12', name: 'Dec', selected: false }
];
export const months2: any[] = [
    { val: '01', name: 'Jan', selected: true },
    { val: '02', name: 'Feb', selected: false },
    { val: '03', name: 'Mar', selected: false },
    { val: '04', name: 'Apr', selected: false },
    { val: '05', name: 'May', selected: false },
    { val: '06', name: 'Jun', selected: false },
    { val: '07', name: 'Jul', selected: false },
    { val: '08', name: 'Aug', selected: false },
    { val: '09', name: 'Sep', selected: false },
    { val: '10', name: 'Oct', selected: false },
    { val: '11', name: 'Nov', selected: false },
    { val: '12', name: 'Dec', selected: false }
];