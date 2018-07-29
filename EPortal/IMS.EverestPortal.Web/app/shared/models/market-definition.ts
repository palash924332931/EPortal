import { MarketDefinitionBaseMap } from './market-definition-base-map';
import { DynamicPackMarketBase } from './dynamic-pack-market-base';

export class MarketDefinition {
    Id: number;
    Name: string;
    ClientId:number;
    Description: string;
    MarketDefinitionBaseMaps: MarketDefinitionBaseMap[];
    MarketDefinitionPacks: DynamicPackMarketBase[];
    GuiId: string;
}

export class MarketDefDTO {
    Id: number;
    Name: string;
    ClientId: number;
    Description: string;
    GuiId: string;
    LastSaved: string;
    Submitted: string;
}
