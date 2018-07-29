import { Level } from './level';
import { Group } from './group';
import { CONSTANTS } from '../../constants';
import { OutletBrickAllocation } from './brick-allocation';


export class Territory {
    Id: number;
    Name: string;
    Client_Id: number;
    IsBrickBased: boolean;
    IsUsed: boolean;
    SRA_Client: string;
    SRA_Suffix: string;
    AD: string;
    LD: string;
    DimensionID?: string;
    Levels: Level[];
    RootGroup: Group;
    GuiId: string;
    static maxChild: number = 0;
    OrphanGroups: Group[];
    public groupsInLevel: any[] = [];
    OutletBrickAllocation: OutletBrickAllocation[];
    public listOfGroups: Group[] = [];
    public selectedGroup: Group;
    static IsOrphanExistsInStructure: number;
    IsReferenced: boolean;


    constructor() {
        this.Levels = [];
        var firstLevel: Level = { Id: 1, LevelNumber: 1, LevelIDLength: 0, Name: 'Australia', LevelColor: '', BackgroundColor: '' };
        var firstGroup: Group = { Id: 1, GroupNumber: '11', CustomGroupNumber: '', CustomGroupNumberSpace: '', Name: 'Australia', IsOrphan: false, PaddingLeft: 130, ParentId: null, Children: null, ParentGroupNumber: null, TerritoryId: 0 };
        this.Levels.push(firstLevel);
        this.RootGroup = firstGroup;
    }

    updateLevelColor() {
        for (let i = 0; i < this.Levels.length; i++) {
            this.Levels[i].LevelColor = CONSTANTS.LEVEL_COLORS[i].levelColor;
            this.Levels[i].BackgroundColor = CONSTANTS.LEVEL_COLORS[i].backgroundColor;
        }
    }

    addLevel(currentLevelId: number, item: Level): boolean {
        if (this.Levels.length < 6) {
            if (currentLevelId == this.Levels.length) {
                var newLevel: Level = { Id: currentLevelId + 1, LevelNumber: currentLevelId + 1, LevelIDLength: item.LevelIDLength, Name: item.Name, LevelColor: '', BackgroundColor: '' };
                this.Levels.push(newLevel);
                this.updateLevelColor();
                return true;
            }
            else {
                this.Levels.push(new Level());
                for (let i = this.Levels.length - 2; i > currentLevelId - 1; i--) {
                    var newLevel: Level = { Id: i + 2, LevelNumber: i + 2, LevelIDLength: this.Levels[i].LevelIDLength, Name: this.Levels[i].Name, LevelColor: '', BackgroundColor: '' };
                    this.Levels[i + 1] = newLevel;
                }

                var newLevel: Level = { Id: currentLevelId + 1, LevelNumber: currentLevelId + 1, LevelIDLength: item.LevelIDLength, Name: item.Name, LevelColor: '', BackgroundColor: '' };
                this.Levels[currentLevelId] = newLevel;
                this._groupUpdate(this.RootGroup, this.RootGroup, currentLevelId + 1);
                //console.log(this.RootGroup);
                this.updateLevelColor();
                return true;
            }
        }
        return false;
    }


    deleteLevel(deleteLevelId: number): boolean {
        this.OrphanGroups = [];
        if (this.Levels.length == 1) return false;
        else {
            if (deleteLevelId === this.Levels.length) {
                if (this._levelGroupCount(this.RootGroup, deleteLevelId - 1) > 0)
                    this.deleteLevelGroup(this.RootGroup, this.RootGroup, deleteLevelId);
                this.Levels.splice(deleteLevelId - 1, 1);
            }
            else {
                this.deleteLevelGroup(this.RootGroup, this.RootGroup, deleteLevelId);
                this.Levels.splice(deleteLevelId - 1, 1);
                for (let i = 0; i < this.Levels.length; i++) {
                    this.Levels[i].LevelNumber = i + 1;
                }
            }
            this.updateLevelColor();
            //console.log('final tree: ', this.RootGroup);
            return true;
        }
    }

    dummy: any;


    deleteLevelGroup(root: Group, parent: Group, deleteLevelId: number): boolean {
        //console.log('root : ', root, 'parent: ', parent, 'deleteLevelId ', deleteLevelId, 'orphans: ', this.OrphanGroups);

        if (+root.GroupNumber.charAt(0) == deleteLevelId - 1) {
            if (this.Levels.length == deleteLevelId) {
                if (typeof parent.Children != 'undefined' && parent.Children) {
                    root.Children.splice(0, root.Children.length);
                }
            }
            else {
                if (typeof root.Children != 'undefined' && root.Children) {
                    var deletedNodesForGroups: Group[] = [];
                    root.Children.forEach(
                        x => +x.GroupNumber.charAt(0) == +root.GroupNumber.charAt(0) + 1 && !x.Children && deletedNodesForGroups.push(x)
                    );
                    deletedNodesForGroups && deletedNodesForGroups.forEach(x => root.Children.splice(root.Children.indexOf(x), 1));

                }

                if (root.Children) {
                    for (let i = 0; i < root.Children.length; i++) {
                        if (+root.Children[i].GroupNumber.charAt(0) > +root.GroupNumber.charAt(0) + 1) {
                            this._shiftGroups(root.Children[i], 'left');
                            this._shiftCustomGroupNumber(root.Children[i], root, 'left', root.CustomGroupNumber, root.CustomGroupNumberSpace);
                            this._decreasePaddingLeft(root, deleteLevelId + 1);
                        }
                    }
                }

                root.Children && root.Children.forEach(
                    x => x.Children && !x.IsOrphan && x.Children.forEach(
                        y => { y.IsOrphan = true, this.OrphanGroups.push(y) }
                    )
                );

                //this.OrphanGroups.forEach(x => this._shiftGroups(x, 'left'));

                //root = this._shelterOrphanGroups(root, this.OrphanGroups);
                //console.log('after shelter: ', root);
                //this.OrphanGroups = [];

                if (this.OrphanGroups.length > 0) {
                    if (root.Children.length <= this.OrphanGroups.length) {
                        root = this._shelterOrphanGroups(root, this.OrphanGroups);
                        this.OrphanGroups = [];
                    }

                    else if (root.Children.length > this.OrphanGroups.length) {
                        root = this._shelterOrphanGroups(root, this.OrphanGroups);
                        root.Children.splice(root.Children.length - 1, (root.Children.length - this.OrphanGroups.length));
                        this.OrphanGroups = [];
                    }
                }


            }
            return true;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => { this.deleteLevelGroup(x, root, deleteLevelId), console.log('current x', x) });
            }
            return true;
        }
    }


    editLevel(currentLevel: any, editedInfo: any) {
        this._groupUpdateCustomNumber(this.RootGroup, this.RootGroup, currentLevel.LevelNumber, this.Levels[currentLevel.LevelNumber - 1].LevelIDLength, editedInfo.LevelIDLength);
        this.Levels[currentLevel.LevelNumber - 1].Name = editedInfo.Name;
        this.Levels[currentLevel.LevelNumber - 1].LevelIDLength = editedInfo.LevelIDLength;

    }

    private _groupUpdateCustomNumber(root: Group, parent: Group, currentLevelId: number, prevLength: number, currLength: number): boolean {
        if (+root.GroupNumber.charAt(0) == currentLevelId) {
            var cusGroupNums: string[] = root.CustomGroupNumberSpace.split(" ");
            var ownCustomerGroup = cusGroupNums[cusGroupNums.length - 1];
            if (currLength > prevLength) {
                ownCustomerGroup = this.zeroFill(ownCustomerGroup, currLength, 0);
            }
            else if (currLength < prevLength) {
                //ownCustomerGroup = ownCustomerGroup.substr(currLength - prevLength);
                ownCustomerGroup = ownCustomerGroup.substr(prevLength - currLength, ownCustomerGroup.length);
            }
            root.CustomGroupNumber = parent.CustomGroupNumber + ownCustomerGroup;
            root.CustomGroupNumberSpace = parent.CustomGroupNumberSpace + " " + ownCustomerGroup;
            this._shiftCustomGroupNumber(root, parent, "right", root.CustomGroupNumber, root.CustomGroupNumberSpace);
            return true;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this._groupUpdateCustomNumber(x, root, currentLevelId, prevLength, currLength));
        }

        return true;
    }

    async fnBindDropdownForGroups(root: Group) {
        if (+root.GroupNumber.charAt(0) == this.Levels.length) {

        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            let tempRoot: any = JSON.parse(JSON.stringify(root));
            tempRoot.Children = null;
            this.listOfGroups.push(tempRoot);
            root.Children.forEach(x => this.fnBindDropdownForGroups(x));
        } else {
            let tempRoot: any = JSON.parse(JSON.stringify(root));
            tempRoot.Children = null;
            this.listOfGroups.push(root);
        }
    }

    fnFindGroupUsingGroupId(root: Group, groupNumber: number) {
        if (+root.GroupNumber == +groupNumber) {
            this.selectedGroup = root;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this.fnFindGroupUsingGroupId(x, groupNumber));
        } else {
            // return root;
        }
    }



    private _numberOfNonOrphanChildren(parent: Group): number {
        var count = 0;
        parent.Children.forEach(x => !x.IsOrphan && count++);
        return count;
    }


    private _groupUpdate(root: Group, parent: Group, currentLevelId: number): boolean {
        if (+root.GroupNumber.charAt(0) == currentLevelId) {
            root.IsOrphan = true;
            root.PaddingLeft = 447;
            //alert('current level: ' + currentLevelId + 'padding: '+ root.PaddingLeft);
            this._shiftGroups(root, 'right');
            this._shiftCustomGroupNumber(root, parent, 'left', parent.CustomGroupNumber, parent.CustomGroupNumberSpace);
            return true;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this._groupUpdate(x, root, currentLevelId));
        }

        return true;
    }


    private _decreasePaddingLeft(root: Group, currentLevelId: number) {
        if (+root.GroupNumber.charAt(0) == currentLevelId - 1) {
            //root.IsOrphan = true;
            var offset = this._levelGroupCount(root, currentLevelId - 2) == 0 ? 187 : 130;
            //root.PaddingLeft = ((currentLevelId - 2) * 317) - offset;
            root.PaddingLeft = 130;
            //alert('current level: ' + currentLevelId + 'padding: '+ root.PaddingLeft);
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this._decreasePaddingLeft(x, currentLevelId));
        }
    }


    private _shiftGroups(root: Group, direction: string) {
        if (!root) return;
        else {
            if (direction == 'left') {
                root.GroupNumber = (+root.GroupNumber.charAt(0) - 1).toString() + root.GroupNumber.substr(1);
            }
            else {
                root.GroupNumber = (+root.GroupNumber.charAt(0) + 1).toString() + root.GroupNumber.substr(1);
            }
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this._shiftGroups(x, direction));
            }
        }
    }

    private _shiftCustomGroupNumber(root: Group, parent: Group, direction: string, deleteCustomGroupNumber: string, deleteCustomGroupNumberSpace: string) {
        if (!root) return;
        else {
            if (direction == 'left') {
                var LevelNumber = +root.GroupNumber.charAt(0);
                var preFix = root.CustomGroupNumber.substr(0, (root.CustomGroupNumber.length - this.Levels[LevelNumber - 1].LevelIDLength));
                root.CustomGroupNumberSpace = root.CustomGroupNumberSpace.substr(deleteCustomGroupNumberSpace.length);
                root.CustomGroupNumber = root.CustomGroupNumber.substr(deleteCustomGroupNumber.length);
            }
            else {
                var cusGroupNums: string[] = root.CustomGroupNumberSpace.split(" ");
                root.CustomGroupNumber = parent.CustomGroupNumber + cusGroupNums[cusGroupNums.length - 1];
                root.CustomGroupNumberSpace = parent.CustomGroupNumberSpace + " " + cusGroupNums[cusGroupNums.length - 1];
            }
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this._shiftCustomGroupNumber(x, root, direction, deleteCustomGroupNumber, deleteCustomGroupNumberSpace));
            }
        }
    }



    private _shelterOrphanGroups(tempParent: Group, orphans: Group[]): Group {
        for (let i = 0; i < orphans.length; i++) {

            this._shiftGroups(orphans[i], 'left');
            if (typeof tempParent.Children[i] != 'undefined' && tempParent.Children[i]) {
                this._shiftCustomGroupNumber(tempParent.Children[i], tempParent, 'left', tempParent.Children[i].CustomGroupNumber, tempParent.Children[i].CustomGroupNumberSpace);
            }
            tempParent.Children[i] = orphans[i];
            tempParent.Children[i].ParentGroupNumber = tempParent.GroupNumber;
        }
        return tempParent;
    }


    public _levelGroupCount(root: Group, parentLevelID: number): number {
        var count = 0;
        if (+root.GroupNumber.charAt(0) === parentLevelID) {
            if (typeof root.Children == 'undefined' || !root.Children) {
                root.Children = [];
            }
            return root.Children.length;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => count += this._levelGroupCount(x, parentLevelID));
        }
        return count;
    }

    private _levelMaximumGroupNumber(root: Group, parentLevelID: number): number {

        if (+root.GroupNumber.charAt(0) === parentLevelID) {
            if (typeof root.Children == 'undefined' || !root.Children) {
                root.Children = [];
            }
            for (let i = 0; i < root.Children.length; i++) {
                var gNumber: number = +root.Children[i].GroupNumber.substring(1);
                if (Territory.maxChild < gNumber) {
                    Territory.maxChild = gNumber;
                }
            }
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this._levelMaximumGroupNumber(x, parentLevelID));
        }
        return Territory.maxChild;
    }

    addGroup(root: Group, parent: Group, item: Group): boolean {
        if (parent === root) {
            if (typeof root.Children == 'undefined' || !root.Children) {
                root.Children = [];
            }
            var parentLevelID: number = +parent.GroupNumber.charAt(0);
            var newGroupNumber = (parentLevelID + 1) + "" + (this._levelMaximumGroupNumber(this.RootGroup, parentLevelID) + 1);
            var newGroup: Group = { Id: 1, GroupNumber: newGroupNumber, CustomGroupNumber: item.CustomGroupNumber, CustomGroupNumberSpace: item.CustomGroupNumberSpace, Name: item.Name, IsOrphan: false, PaddingLeft: 130, ParentId: 0, Children: null, ParentGroupNumber: parent.GroupNumber, TerritoryId: 0 };
            root.Children.push(newGroup);
            return true;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.addGroup(x, parent, item));
            }
        }
    }

    editGroup(root: Group, parent: Group, editedGroup: any, editedGroupInfo: any) {
        if (editedGroup.GroupNumber === root.GroupNumber && editedGroup.Name == root.Name) {
            //console.log("group details:" + root);
            root.CustomGroupNumber = editedGroupInfo.CustomGroupNumber;
            root.CustomGroupNumberSpace = editedGroupInfo.CustomGroupNumberSpace;
            root.Name = editedGroupInfo.Name;
            return false;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.every(x => this.editGroup(x, root, editedGroup, editedGroupInfo));
            }
            return true;
        }
    }


    deleteGroup(root: Group, parent: Group, delGroup: Group): boolean {
        if (delGroup.GroupNumber === root.GroupNumber && delGroup.ParentGroupNumber === parent.GroupNumber) {
            var groupPosition: number = parent.Children.indexOf(delGroup);
            parent.Children.splice(groupPosition, 1);
            return true;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.deleteGroup(x, root, delGroup));
            }
            return true;
        }
    }

    deleteGroupForLinkToParent(root: Group, parent: Group, delGroup: Group, oldParentGroupNumber: string): boolean {
        if (delGroup.GroupNumber === root.GroupNumber && oldParentGroupNumber != '' && oldParentGroupNumber === parent.GroupNumber) {
            var groupPosition: number = parent.Children.indexOf(delGroup);
            if (root.IsOrphan) {
                parent.Children.splice(groupPosition, 1);
            }
            return true;
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.deleteGroupForLinkToParent(x, root, delGroup, oldParentGroupNumber));
            }
            return true;
        }
    }


    linkToParentGroup(root: Group, childGroup: Group, linkToParentGroupNumber: string): void {
        if (linkToParentGroupNumber === root.GroupNumber) {
            if (typeof root.Children == 'undefined' || !root.Children) {
                root.Children = [];
            }
            root.Children.push(childGroup);
            root.Children[root.Children.length - 1].ParentGroupNumber = linkToParentGroupNumber;
            root.Children[root.Children.length - 1].PaddingLeft = 130;
            root.Children[root.Children.length - 1].IsOrphan = false;

            this._shiftCustomGroupNumber(root.Children[root.Children.length - 1], root, 'right', root.Children[root.Children.length - 1].CustomGroupNumber, root.Children[root.Children.length - 1].CustomGroupNumberSpace);
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this.linkToParentGroup(x, childGroup, linkToParentGroupNumber));
            }
        }
    }


    sortByPropertyDESC(property: any): any {
        return function (x: any, y: any) {
            return ((x[property] === y[property]) ? 0 : ((x[property] < y[property]) ? 1 : -1));
        }
    }

    private _sortByOrphanStatus(parent: Group): Group {
        var orphans: Group[] = [];
        var nonOrphans: Group[] = [];
        var tempGroup = new Group();
        tempGroup.Children = [];

        for (let i = 0; i < parent.Children.length; i++) {
            if (parent.Children[i].IsOrphan)
                orphans.push(parent.Children[i]);
            else
                nonOrphans.push(parent.Children[i]);
        }

        orphans && orphans.forEach(x => tempGroup.Children.push(x));
        nonOrphans && nonOrphans.forEach(y => tempGroup.Children.push(y));

        return tempGroup;
    }

    async ifOrphanExistsInTree(root: Group) {
        if (root.IsOrphan) { Territory.IsOrphanExistsInStructure = 1; }
        else if (root.CustomGroupNumber == '01' && !root.Children) return 0;
        else if (typeof root.Children != 'undefined' && root.Children) {
            //root.Children.forEach(x => count = count + this.ifOrphanExistsInTree(x));
            root.Children.forEach(x => this.ifOrphanExistsInTree(x));
        }
        return Territory.IsOrphanExistsInStructure;
    }

    IsOrphanExistsInTree(root: Group): number {
        var count = 0;
        if (root.CustomGroupNumber == '01' && !root.Children) return 0;
        else if (root.IsOrphan) return 1;
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => count = count + this.IsOrphanExistsInTree(x));
        }
        return count;
    }

    isLeaf(groupNode: Group): boolean {
        return +groupNode.GroupNumber.charAt(0) === this.Levels.length;
    }

    //updateGroupId(groupToDelete: Group): boolean {
    //    var levelId = +groupToDelete.Id.toString().charAt(0);
    //    for (let i = 0; i < this.Levels.length; i++) {
    //        var numberOfGroups = this.Levels[i].Groups.length;
    //        for (let j = 0; j < numberOfGroups; j++) {
    //            this.Levels[i].Groups[j].Id = +(i + '' + (j));
    //            if (typeof this.Levels[i].Groups[j].Children != 'undefined' && this.Levels[i].Groups[j].Children) {
    //                this.Levels[i].Groups[j].Children = this.Levels[i].Groups[j].Children.filter((thing, index, self) => self.findIndex((t) => { return t.Id === thing.Id }) === index)
    //            }
    //        }
    //    }

    //    return true;
    //}

    zeroFill(CustomGroupNumber: any, PaddingZero: number, Character: any): string {
        //var pad_char = typeof Character !== 'undefined' ? Character : '0';
        var pad_char = '0';
        PaddingZero = PaddingZero++;
        var temp = CustomGroupNumber.toString().length;
        //console.log("digit len length " + temp);
        //console.log("new array length " + PaddingZero);
        var diff = PaddingZero - (+temp);
        diff = diff++;
        //console.log("diff" + diff);
        var pad = new Array(diff + 1).join(pad_char);
        //console.log("pad..." + pad);
        //console.log("return...." + (pad + CustomGroupNumber));//.slice(-pad.length)
        return (pad + CustomGroupNumber);
    }

    public parentNodeLevelOne: string = "";
    public parentNodeLevelTwo: string = "";
    public parentNodeLevelThree: string = "";
    public parentNodeLevelFour: string = "";

    public _groupsInLevel(root: Group, levelID: number, parentGroupName: string = ""): void {
        if (+root.GroupNumber.charAt(0) === levelID) {
            var tempId = root.CustomGroupNumberSpace ? root.CustomGroupNumberSpace.split(' ') : '0';
            var returnObj = { NodeCode: root.CustomGroupNumberSpace, NodeName: root.Name, ParentNodeLevelOne: this.parentNodeLevelOne, ParentNodeLevelTwo: this.parentNodeLevelTwo, ParentNodeLevelThree: this.parentNodeLevelThree, ParentNodeLevelFour: this.parentNodeLevelFour, LevelName: this.getLevelFromGroupNumber(root.GroupNumber).Name, GroupNumber: root.GroupNumber, CustomGroupNumberSpace: root.CustomGroupNumberSpace, BrickOutletCount: 0 };
            this.groupsInLevel.push(returnObj);
            return;
        }

        else if (typeof root.Children != 'undefined' && root.Children) {
            if (+root.GroupNumber.charAt(0) === 2) {
                this.parentNodeLevelOne = root.Name;
            } else if (+root.GroupNumber.charAt(0) === 3) {
                this.parentNodeLevelTwo = root.Name;
            } else if (+root.GroupNumber.charAt(0) === 4) {
                this.parentNodeLevelThree = root.Name;
            } else if (+root.GroupNumber.charAt(0) === 5) {
                this.parentNodeLevelFour = root.Name;
            }

            root.Children.forEach(x => this._groupsInLevel(x, levelID, root.Name));
        }
        return;

    }

    /**
       public _groupsInLevel(root: Group, levelID: number,parentGroupName:string=""): void {
        if (+root.GroupNumber.charAt(0) === levelID) {
            console.log(parentGroupName);
            var tempId = root.CustomGroupNumberSpace ? root.CustomGroupNumberSpace.split(' ') : '0';
            var returnObj = { NodeCode: root.CustomGroupNumberSpace, NodeName: root.Name,ParentNodeName:parentGroupName, LevelName: this.getLevelFromGroupNumber(root.GroupNumber).Name, GroupNumber: root.GroupNumber, CustomGroupNumberSpace: root.CustomGroupNumberSpace, BrickOutletCount: 0 };
            this.groupsInLevel.push(returnObj);
            return;
        }

        else if (typeof root.Children != 'undefined' && root.Children) {

            root.Children.forEach(x => this._groupsInLevel(x, levelID,root.Name));
        }
        return;

    }
     */
    public returnGroup: Group;
    async getGroupsPassingId(root: Group, groupNumber: number) {
        if (+root.GroupNumber === groupNumber) {
            this.returnGroup = root;
            return false;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this.getGroupsPassingId(x, groupNumber));
        } else {
            return false;
        }
        return false;
    }

    getLevelFromGroupNumber(groupNumber: string): Level {
        return this.Levels[+groupNumber.charAt(0) - 1];
    }
    fnChangeDetectionInTerritorySetup(tempTerritory: Territory, currentTerritory: Territory): boolean {
        if (JSON.stringify(tempTerritory.RootGroup) == JSON.stringify(currentTerritory.RootGroup) && JSON.stringify(tempTerritory.Levels) == JSON.stringify(currentTerritory.Levels)) {
            return false;
        } else {
            return true;
        }
    }

    // update collapse expaned flag in saved Territory
    async fnUpdateCollapseExpandFlag(root: Group, data: Group) {
        if (+root.GroupNumber === +data.GroupNumber) {
            root.collapse = data.collapse;
            this.returnGroup = root;
            return false;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => this.fnUpdateCollapseExpandFlag(x, data));
        } else {
            return false;
        }
        return false;
    }

    async fnReorderOfTerritoryGroups(root: Group, orderBy: any) {
        let colName = "CustomGroupNumber";
        if (typeof root.Children != 'undefined' && root.Children) {
            if (orderBy == 'desc') {
                root.Children.sort((n1, n2) => {
                    if (n1[colName] < n2[colName]) { return 1; }
                    if (n1[colName] > n2[colName]) { return -1; }
                });
            } else {
                root.Children.sort((n1, n2) => {
                    if (n1[colName] > n2[colName]) { return 1; }
                    if (n1[colName] < n2[colName]) { return -1; }
                    return 0;
                });
            }

            root.Children.forEach(x => this.fnReorderOfTerritoryGroups(x, orderBy));
        } else {
            return false;
        }
        return false;
    }

}