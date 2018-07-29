import { MarketDefinition } from './market-definition';

export class Client {
    Id: number;
    Name: string;
    IsMyClient: boolean;
    MarketDefinitions: MarketDefinition[] = [];
}