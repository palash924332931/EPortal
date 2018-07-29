export class OutletBrick {
    Code: string;
    Name: string;
    Address: string;
    BannerGroup: string;
    State: string;
    Panel: string;
    Type: string;
    BrickOutletLocation:string;
}

export class OutletBrickAllocation {
    NodeCode: string;
    NodeName: string;
    BrickOutletCode: string;
    BrickOutletName: string;
    Address: string;
    BannerGroup: string;
    State: string;
    Panel: string;
    BrickOutletLocation:string;
    LevelName: string;
    CustomGroupNumberSpace: string;
    Type: string;
}

export class OutletBrickAllocationCount {
    NodeCode: string;
    NodeName: string;
    ParentNodeLevelOne?: string;
    ParentNodeLevelTwo?: string;
    ParentNodeLevelThree?: string;
    ParentNodeLevelFour?: string;
    GroupNumber: number;
    BrickOutletCount: number;
    LevelName: string;
    CustomGroupNumberSpace: string;
    Type: string;
}