export class SubscriptionReportDTO {
   
    SubscriptionPeriodChangeDTOs: SubscriptionPeriodChangeDTO[];
    SubscriptionMktBaseNamEChangeDTOs: SubscriptionMktBaseNamEChangeDTO[];
}


export class SubscriptionPeriodChangeDTO {

    startDate: any;
    endDate: any;
    versionNo: number;
    changeduser: string;
    changedDate: any;
}

export class SubscriptionMktBaseNamEChangeDTO {

    MarkdetBaseName: string;
    MktBaseVersion: number;
    versionNo: number;
    changeduser: string;
    changedDate: any;
}

export class clientDTO {
    clientID: number;
    Name: string;
}

export class NameDTO {
    ID: number;
    Name: string;
}

export class VersionDTO {
    ID: number;
    VersionNo: number;
}



export class DeliverablenNameDTO {
    subscriptonID: number;
    DeliverablenName: string;

}


export class DeliverableVersionDTO {
    DeliverableID: number;
    VersionNo: number;
}

