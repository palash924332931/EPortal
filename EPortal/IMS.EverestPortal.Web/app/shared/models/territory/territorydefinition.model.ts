﻿export class Territory {
    constructor(
        public Id: number,
        public Name: string,
        public Client_Id: number,
        public IsBrickBased: boolean,
        public SRA_Client: string,
        public SRA_Suffix: string,
        public AD:string,
        public LD:string,
        public RootLevel: Level,
        public DimensionID?:string,
        public RootGroup?: Group,
        public Allocations?: Allocation[]
    ) { }
}

export class TerritoryDTO {
    constructor(
        public Id: number,
        public Name: string,
        public Client_Id: number,
        public IsBrickBased: boolean,
        public SRA_Client: string,
        public SRA_Suffix: string,
        public AD: string,
        public LD: string,
        public LastSaved: string,
        public Submitted: string,
        public Selected: boolean,
    ) { }
}

export class Level {
    constructor(
        public Id: number,
        public Name: string,
        public Parent?: Level,
        public Child?: Level
    ) { }
}

export class Group {
    constructor(
        public id: number,
        public Name: string,
        public GroupIdPrefix: number,
        public Level: number,
        public Parent?: Group,
        public Children?: Group[]
    ) { }

    GroupId(): string {
        return 'group';
        //var groupid = this.GroupIdPrefix.toString();
        //let current : Group = this;
        //while (current.Parent != null) {
        //    groupid = current.Parent.GroupIdPrefix + '-' + groupid;
        //    current = current.Parent;
        //}

        //return groupid;
    }
}


export class Allocation {
    constructor(

    ) { }
}

