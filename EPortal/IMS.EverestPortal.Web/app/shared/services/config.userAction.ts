import { Injectable } from '@angular/core';

@Injectable()
export class ConfigUserAction {

    public static readonly ViewContent: string = 'View Content';
    public static readonly marketdefinition : string = 'market definition under market base';
    public static readonly marketdefinitionName: string = 'market definition name';
    public static readonly marketbaseToMarktDef: string = 'market base to market definition';
    public static readonly filterMarketbase: string = 'filter to market base in market definition';
    public static readonly packListFromMarketbase: string = 'packs to market definition pack list from market base';
    public static readonly packListFromPackList: string = 'packs to market definition pack list from pack list';
    public static readonly packsToGroup: string = 'packs to group';
    public static readonly factorToGroup: string = 'factor to group';
    public static readonly factorToPack: string = 'factor to pack';
    public static readonly changeGroupNumber_default: string = 'change group number (not default)';
    public static readonly changeGroupNumber: string = 'change group number';
    public static readonly groupName: string = 'group name';
    public static readonly globalNavigation: string = 'Use global navigation toolbar';

    //subscription
    public static readonly SubscriptionService: string = 'market base';
    //Territory
    public static readonly TerritoryDefinition: string = 'Territory Defintions';
    public static readonly EditTerritoryDefinitionForInternalClient: string = 'Edit content of internal client';

    //Release
    public static readonly ReleaseOneKey: string = 'Releases OneKey';
    public static readonly ReleaseCensus: string = 'Releases Census';
    public static readonly ReleasePackExeception: string = 'Releases Pack Exceptions';
    public static readonly ReleaseAllClients: string = 'All Clients';
    
    //Deliverables
    public static readonly deliveryContent: string = 'Content';
    public static readonly delliveryMktDef: string = 'Market Definition';
    public static readonly delliveryTerDef: string = 'Territory Definition';
    public static readonly deliverables: string = 'Deliverables';
    public static readonly deliverablesClient: string = 'Deliverables Client';
    public static readonly duplicatedeliverables: string = 'duplicate deliverables';
    public static readonly updateSubchannel: string = 'Update sub-channels';
    public static readonly updateIRPReportNumber: string = 'Update IRP report number';

    //Admin
    public static readonly ModifyInternalRole: string = 'Can change internal user role';
   


    public static readonly territoryLevel: string = 'territory level';
    public static readonly territoryGroup: string = 'territory group';
    public static readonly territoryOutlets: string = 'bricks/outlets to groups';

    //Admin
    public static readonly ModifyTileNames: string = 'Modify Tile names';
    public static readonly ModifyPopularLinks: string = 'Modify popular links';
    
    //Reporting
    public static readonly SelectSectionType: string = 'Select section type';
    public static readonly ModifyDefaultFilter: string = 'Modify default filter';

    //Data Channel
    public static readonly ViewDataChannel: string = 'View data channel';
    public static readonly AddDataChannel: string = 'Add data channel';
    public static readonly DeleteDataChannel: string = 'Delete data channel';
    public static readonly AddNewSubchannel: string = 'Add new subchannel';
    public static readonly DeleteSubchannel: string = 'Delete sub channel';
    public static readonly ModifyNameOfChannel: string = 'Modify name of channel';
    public static readonly ModifyNameOfSubchannel: string = 'Modify name of sub channel';
}