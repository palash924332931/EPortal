export class Client {
    ClientID: number;
    ClientName: string;
}

export class LockedDefinition {
    Module: string;
    Name: string;
    ID: number;
    LockHistoryID: number;
    LockedBy: string;
    LockedTime?: string;
}