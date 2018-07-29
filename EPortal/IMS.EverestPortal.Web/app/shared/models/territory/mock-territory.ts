import { Level } from './level';
import { Group } from './group';
import { Territory } from './territory';

export const Levels: Level[] = [

    { Id: 2, LevelNumber: 2, LevelIDLength: 1, Name: 'Level 2', LevelColor: '', BackgroundColor: '' },
    { Id: 3, LevelNumber: 3, LevelIDLength: 2, Name: 'Level 3', LevelColor: '', BackgroundColor: '' }
];

//export const Groups_Level2: Group2[] = [
//    { Id: 20, Group_Id: 20, Name: 'Group 20', ParentId: 10, LevelId: 3, Children: null },
//    { Id: 21, Group_Id: 21, Name: 'Group 21', ParentId: 10, LevelId: 3, Children: null },
//    { Id: 22, Group_Id: 22, Name: 'Group 22', ParentId: 11, LevelId: 3, Children: null },
//    { Id: 23, Group_Id: 23, Name: 'Group 23', ParentId: 11, LevelId: 3, Children: null },
//    { Id: 24, Group_Id: 24, Name: 'Group 24', ParentId: 12, LevelId: 3, Children: null },
//    { Id: 25, Group_Id: 25, Name: 'Group 25', ParentId: 12, LevelId: 3, Children: null }
//];

//export const Groups_Level1: Group[] = [
//    { Id: 2, Group_Id: 10, Name: 'Group 10', ParentId: 1, LevelId: 2, Children: null },
//    { Id: 3, Group_Id: 11, Name: 'Group 11', ParentId: 1, LevelId: 2, Children: null },
//    //{ Id: 12, GroupId: 12, Name: 'Group 12', ParentId: 0, Children: [Groups_Level2[4], Groups_Level2[5]] },
//];
//export const Groups_Level0: Group[] = [
//    { Id: 1, Group_Id: 1, Name: 'Australia 01', ParentId: 111, LevelId: 1, Children: [Groups_Level1[0], Groups_Level1[1]] },//null
//];


//Levels[0].Groups.push(Groups_Level0[0]);

//Levels[1].Groups.push(Groups_Level1[0]);
//Levels[1].Groups.push(Groups_Level1[1]);


var territory: Territory = new Territory();
territory.Levels.push(Levels[0]);
territory.Levels.push(Levels[1]);
territory.Name = "T1";


///////////////////////////////////////////////

export const LEVEL1_GROUP: Group = { Id: 1, GroupNumber: '11', CustomGroupNumber: '', CustomGroupNumberSpace: '', Name: 'Australia', IsOrphan: false, PaddingLeft: 130, ParentId: null, Children: null, ParentGroupNumber: null,TerritoryId:null };
export const LEVEL2_GROUPS: Group[] = [
    { Id: 2, GroupNumber: '21', CustomGroupNumber: '', CustomGroupNumberSpace: '', Name: 'NSW', IsOrphan: false, PaddingLeft: 130, ParentId: 1, Children: null, ParentGroupNumber: '11',TerritoryId:null },
    { Id: 2, GroupNumber: '22', CustomGroupNumber: '', CustomGroupNumberSpace: '', Name: 'VIC', IsOrphan: false, PaddingLeft: 130, ParentId: 1, Children: null, ParentGroupNumber: '11',TerritoryId:null }
];


territory.RootGroup.Children.push(LEVEL2_GROUPS[0]);
territory.RootGroup.Children.push(LEVEL2_GROUPS[1]);

///////////////////////////////////////////////

export const MOCK_TERRITORY: Territory = territory;
