import { MarketDefinitionBaseMap } from './../market-definition-base-map';
import { DynamicPackMarketBase } from './../dynamic-pack-market-base';
import { MarketDefinition } from './../market-definition';

export class GroupingTreeStructure {
    MarketAttributes: MarketAttribute[];
    MarketGroupPacks: MarketGroupPack[];
}


export class MarketAttribute {
    Id: number;
    AttributeId: number;
    Name: string;
    OrderNo: number;
    MarketDefinitionId: number;
    MarketGroups: MarketGroup[];
}

export class MarketGroup {
    Id: number;
    GroupId: number;
    Name: string;
    IsInherited: boolean;
    MarketDefinitionId: number;
    MarketGroups: MarketGroup[];
    GroupOrderNo: number;
}


export class MarketGroupPack {
    Id: number;
    PFC: string;
    GroupId: number;
    MarketDefinitionId: number;
}

export class MarketGroupView {
    Id: number;
    AttributeId: number;
    ParentId: number;
    GroupId: number;
    IsAttribute: boolean;
    GroupName: string;
    AttributeName: string;
    OrderNo: number;
    MarketDefinitionId: number;
    GroupOrderNo: number;
}

export class MarketGroupFilter {
    Id: number;
    Name: string;
    Criteria: string;
    Values: string;
    IsEnabled: boolean;
    GroupId: number;
    IsAttribute: boolean;
    AttributeId: number;
    MarketDefinitionId: number;
}

export class MarketDefinitionDetails {
    MarketDefinition: MarketDefinition;
    GroupView: MarketGroupView[];
    MarketGroupPack: MarketGroupPack[];
    MarketGroupFilter: MarketGroupFilter[];
}

export class MarketDefinitionPacks {
    Id: number;
    ATC1: string;
    ATC2: string;
    ATC3: string;
    ATC4: string;
    NEC1: string;
    NEC2: string;
    NEC3: string;
    NEC4: string;
    Branding: string;
    Flagging: string;
    Manufacturer: string;
    Molecule: string;
    Product: string;
    Form: string;
    PoisonSchedule: string;
    Pack: string;
    MarketBaseId: string;
    MarketBase: string;
    GroupNumber: string;
    GroupName: string;
    Factor: string;
    PFC: string;
    DataRefreshType: string;
    StateStatus: string;
    Alignment: string;
    ChangeFlag: string;
    FromGroup: string;
}

