import { Level } from './level';

export class Group {
    Id: number;
    GroupNumber: string;
    CustomGroupNumber: string;
    CustomGroupNumberSpace: string;
    Name: string;
    ParentId: number;
    Children: Group[];
    IsOrphan: boolean;
    PaddingLeft: number;
    ParentGroupNumber: string;
    TerritoryId:number|null;
    collapse?:boolean;

}