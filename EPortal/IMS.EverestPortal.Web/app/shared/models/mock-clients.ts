import { BaseFilter } from './base-filter';
import { AdditionalFilter } from './additional-filter';
import { MarketBase } from './market-base';
import { MarketDefinitionBaseMap } from './market-definition-base-map';
import { MarketDefinition } from './market-definition';
import { Client } from './client';
import { ClientMarketBase } from './client-market-base';



export const MARKET_BASES: MarketBase[] = [
    //{ Id: 1, Name: 'ATC3 N02B', Description: '', Filters: [{ Id: 1, Name: 'filter1', Criteria: 'ATC3', Values: 'N02B', IsEnabled: true }] },
    //{ Id: 2, Name: 'MNF ALCON', Description: '', Filters: [{ Id: 2, Name: 'filter2', Criteria: 'Manufacturer', Values: 'ALCON', IsEnabled: true }] }
];

//export const FILTER3: AdditionalFilter =
//    { Id: 3, Name: 'filter3', Criteria: 'molecule', Values: 'XYZ', IsEnabled: true };

//export const FILTER4: AdditionalFilter =
//    { Id: 4, Name: 'filter4', Criteria: 'ATC3', Values: 'N02B', IsEnabled: true };

//export const FILTER5: AdditionalFilter =
//    { Id: 4, Name: 'filter5', Criteria: 'ATC4', Values: 'N02B0', IsEnabled: true };

//export const FILTER6: AdditionalFilter =
//    { Id: 4, Name: 'filter6', Criteria: 'ATC3', Values: 'N02B, S01L', IsEnabled: true };

//export const BASE_MAP1: MarketDefinitionBaseMap = {
//    Id: 1, Name: 'ATC3 N02B', MarketBase: MARKET_BASES[0], Filters: [FILTER4, FILTER5], DataRefreshType: 'dynamic'
//};

//export const BASE_MAP2: MarketDefinitionBaseMap = {
//    //Id: 1, Name: 'Manufacturer ALCON', MarketBase: MARKET_BASES[1], Filters: [FILTER6], DataRefreshType: 'dynamic'
//};

//export const MARKET_DEF1: MarketDefinition = {
//    //Id: 1, Name: 'Pain Market', Description: '', MarketDefinitionBaseMaps: [BASE_MAP1, BASE_MAP2]
//};

//export const MARKET_DEF2: MarketDefinition = {
//    //Id: 1, Name: 'Respiratory Market', Description: '', MarketDefinitionBaseMaps: [BASE_MAP1]//, BASE_MAP2
//};

//export const MARKET_DEF3: MarketDefinition = {
//    //Id: 1, Name: 'Child Care Market', Description: '', MarketDefinitionBaseMaps: [BASE_MAP1, BASE_MAP2]
//};

export const CLIENTS: Client[] = [
    //{ Id: 1, Name: 'Client 1', IsMyClient: true, MarketDefinitions: [MARKET_DEF1, MARKET_DEF2] },
    //{ Id: 2, Name: 'Client 2', IsMyClient: false, MarketDefinitions: [MARKET_DEF2] },
    //{ Id: 3, Name: 'Client 3', IsMyClient: true, MarketDefinitions: [MARKET_DEF1, MARKET_DEF2,MARKET_DEF3] },
    //{ Id: 4, Name: 'Client 4', IsMyClient: true, MarketDefinitions: [MARKET_DEF2] },
    //{ Id: 5, Name: 'Client 5', IsMyClient: true, MarketDefinitions: [MARKET_DEF1, MARKET_DEF2] },
    //{ Id: 6, Name: 'Client 6', IsMyClient: false, MarketDefinitions: [MARKET_DEF1, MARKET_DEF2, MARKET_DEF3, MARKET_DEF1] },
    //{ Id: 7, Name: 'Client 7', IsMyClient: true, MarketDefinitions: [MARKET_DEF1] },
    //{ Id: 8, Name: 'Client 8', IsMyClient: true, MarketDefinitions: [MARKET_DEF1, MARKET_DEF2] },
    //{ Id: 9, Name: 'Client 9', IsMyClient: false, MarketDefinitions: [MARKET_DEF1] }
];

export const CLIENT_MARKET_BASES: ClientMarketBase[] = [
    //{ Id: 1, ClientId: 1, ClientName: 'Client 1', MarketBaseId: 1, MarketBaseName: 'ATC3 N02B', Description: 'ATC3 NO2B' },
    //{ Id: 2, ClientId: 1, ClientName: 'Client 1', MarketBaseId: 2, MarketBaseName: 'Molecule XYZ', Description: 'Molecule XYZ' },
    //{ Id: 3, ClientId: 1, ClientName: 'Client 1', MarketBaseId: 3, MarketBaseName: 'MFR Alcon', Description: 'MFR Alcon' },
    //{ Id: 4, ClientId: 1, ClientName: 'Client 1', MarketBaseId: 4, MarketBaseName: 'ATC R01', Description: 'ATC R01' }
];

export const users: any[] = [
    { UserID: 1, RoleID: 1, RoleName: "Client Analyst", EmailId: "user1.analyst@quintilesims.com", username: "User1 Client Analyst" },
    { UserID: 2, RoleID: 1, RoleName: "Client Analyst", EmailId: "user2.analyst@quintilesims.com", username: "User2 Client Analyst" },
    { UserID: 3, RoleID: 2, RoleName: "Client Manager", EmailId: "user1.manager@quintilesims.com", username: "User1 Client Manager" },
    { UserID: 4, RoleID: 2, RoleName: "Client Manager", EmailId: "user2.manager@quintilesims.com", username: "User2 Client Manager" },
    { UserID: 5, RoleID: 3, RoleName: "Internal GTM", EmailId: "user1.gtm@quintilesims.com", username: "User1 Internal GTM" },
    { UserID: 6, RoleID: 3, RoleName: "Internal GTM", EmailId: "user2.gtm@quintilesims.com", username: "User2 Internal GTM" },
    { UserID: 7, RoleID: 4, RoleName: "Internal Admin", EmailId: "user1.admin@quintilesims.com", username: "User1 Internal Admin" },
    { UserID: 8, RoleID: 4, RoleName: "Internal Admin", EmailId: "user2.admin@quintilesims.com", username: "User2 Internal Admin" },
    { UserID: 9, RoleID: 5, RoleName: "Internal Production", EmailId: "user1.production@quintilesims.com", username: "User1 Internal Production" },
    { UserID: 10, RoleID: 5, RoleName: "Internal Production", EmailId: "user2.production@quintilesims.com", username: "User2 Internal Production" },
    { UserID: 11, RoleID: 6, RoleName: "Internal Data Reference", EmailId: "user1.datareference@quintilesims.com", username: "User1 Data Reference" },
    { UserID: 12, RoleID: 6, RoleName: "Internal Data Reference", EmailId: "user2.datareference@quintilesims.com", username: "User2 Data Reference" },
    { UserID: 13, RoleID: 7, RoleName: "Internal Support", EmailId: "user1.support@quintilesims.com", username: "User1 Internal Support" },
    { UserID: 14, RoleID: 7, RoleName: "Internal Support", EmailId: "user2.support@quintilesims.com", username: "User2 Internal Support" }
]