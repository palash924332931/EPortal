export class Frequency {
    FrequencyId: number;
    Name: string;
    FrequencyTypeId: number;
}
export class Period {
    PeriodId: number;
    Name: string;
}
//export class Restriction {
//    RestrictionId: number;
//    Name: string;
//}
export class Restriction {
    Id: number;
    name: string;
}
export class ReportWriter {
    ReportWriterId: number;
    Code: string;
    Name: string;
}
export class ClientMarketDefDTO {
    Id: number;
    Name: string;
    clientId: number;
    marketBaseDTOs: MarketBaseDTO[];
    selected: boolean;
    isSaved: boolean;
    isDeleted: boolean;
}
export class MarketBaseDTO {
    Id: number;
    Name: string;
    Description: string;
    DurationFrom: string;
    DurationTo: string;
}
export class ClientTerritoryDTO {
    Id: number;
    Name: string
    TerritoryBase: string;
    clientId: number;
    selected: boolean;
    isSaved: boolean;
    isDeleted: boolean;
}
export class ClientsDTO {
    Id: number;
    Name: string;
    IsThirdparty: boolean;
    selected: boolean;
    isSaved: boolean;
    isDeleted: boolean;
}
export class DeliverablesDTO {
    ClientId: number;
    ClientName: string;

    DeliverableId: number;
    DeliveryTypeId: number;
    DisplayName: string;
    SubscriptionId: number;
    ReportWriterId: number;
    ReportWriterName :string
    FrequencyTypeId: number;
    RestrictionId: number;
    RestrictionName: string;
    PeriodId: number;
    PeriodName: string;
    FrequencyId: number;
    FrequencyName: string;
    StartDate: string
    EndDate: string
    probe: boolean;
    PackException: boolean;
    Census: boolean;
    OneKey: boolean;
    IsProbeAvailable: boolean;
    IsPackExcAvailable: boolean;
    IsCensusAvailable: boolean;
    IsOneKeyAvailable: boolean;
    LastModified: string;
    ModifiedBy: number
    SubServiceTerritoryId: number;
    Mask?: boolean;
    marketDefs: ClientMarketDefDTO[];
    territories: ClientTerritoryDTO[];
    clients: ClientsDTO[];
    LockType: string;
    Selected: boolean;

    SubChannelsDTO: SubChannelsDTO[];
}

//Subchannels
export class SubChannelsDTO {
    EntityTypes: EntityType[];
    DataType: DataType;
}

export class DataType {
    DataTypeId: number;
    Name: string;
    IsSelected: boolean;
}

export class EntityType {
    EntityTypeId: number;
    EntityTypeCode: string;
    EntityTypeName: string;
    DataTypeId: number;
    Abbrev: string;
    Display: string;
    Description: string;
    IsActive: boolean;
    IsSelected: boolean;
}

export class PeriodForFrequency {
    FrequencyTypeId: number;
    PeriodId: number;
}