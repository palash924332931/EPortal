import { Component, Input, Output, EventEmitter } from '@angular/core';
import { Group } from '../shared/models/territory/group';
import { Level } from '../shared/models/territory/level';
import { TerritoryComponent } from '../territory/territory.component';
import { CONSTANTS } from '../shared/constants';



declare var jQuery: any;

@Component({
    selector: 'groupview',
    templateUrl: '../../app/territory/groupview.component.html'
})
export class GroupViewComponent {
    defaultGroupNumber: string;
    IsAvailableGroupNumber: boolean = false;
    MaxGrpIdEachLevel: number[] = [];
    private parentList: Group[] = [];

    @Input() rootgroup: any[] = [];

    private _isBrickExists(data: Group): boolean {
        var result = false;
        for (let node of TerritoryComponent.territoryNodes) {
            if (node.GroupNumber && +node.GroupNumber.charAt(0) === TerritoryComponent.Levels.length && node.BrickOutletCount > 0 && node.GroupNumber == data.GroupNumber) {
                result = true;
                break;
            }
        }
        return result;
    }
    public isBrickExistsToGroupDelete:boolean=false;
    public checkBrickExistsInLastNode(data: Group) {        
        if (TerritoryComponent.brickDetailsUnderTerritory.length > 0) {
            var result = false;
            if (+data.GroupNumber.charAt(0) == TerritoryComponent.Levels.length) {//to ensure that this is last level
                for (let node of TerritoryComponent.brickDetailsUnderTerritory) {
                    if (data.GroupNumber && +data.GroupNumber.charAt(0) === TerritoryComponent.Levels.length && node.NodeCode == data.CustomGroupNumberSpace) {
                        this.isBrickExistsToGroupDelete = true;
                        break;
                    }
                }
            } else {
                data.Children.every(x => {
                    this.checkBrickExistsInLastNode(x);
                    return !this.isBrickExistsToGroupDelete;
                });
            }

        } else {
            this.isBrickExistsToGroupDelete = false;
        }

        return this.isBrickExistsToGroupDelete;
    }
    fnActionOnGroup(action: string, data: Group, nextLevelOrphanNodes: number,groupDisabledFlag:boolean=false) {
        if(groupDisabledFlag|| this.getGlobalDisableFlag()){//to check disabled 
            return false;
        }


        if (action === "add") {
            if (nextLevelOrphanNodes > 0) {
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalTitle = "There are parentless group(s) in next level. Please assign parent for them before proceeding.";
                TerritoryComponent.modalCloseBtnCaption = "Close";
                jQuery("#nextModal").modal("show");
            }
            else {
                //console.log("from Group View: Add group Modal show...");
                TerritoryComponent.clickedParent = data;
                TerritoryComponent.GroupIdFlag = true;
            }
        }
        else if (action == "edit") {
            jQuery("#groupIdEditCheckErrorMessage").html("");
            TerritoryComponent.clickedParent = data;
            console.log("Group Name:" + data.Name);
            jQuery("#editedGroupName").val(data.Name);
            var LevelNumber = +TerritoryComponent.clickedParent.GroupNumber.charAt(0);
            console.log("TerritoryComponent.Levels[+data.GroupNumber.charAt(0)].LevelIDLength...." + TerritoryComponent.Levels[LevelNumber - 1].LevelIDLength);
            console.log("data.GroupNumber.charAt(0)...." + LevelNumber);
            console.log("data.CustomGroupNumber.length..." + data.CustomGroupNumber.length);
            // jQuery("#editedGroupID").val(data.CustomGroupNumber);// no prefix, only user given group id will be shown// need to check


            var preFix = data.CustomGroupNumber.substr(0, (data.CustomGroupNumber.length - TerritoryComponent.Levels[LevelNumber - 1].LevelIDLength));
            var ownNumber = data.CustomGroupNumber.substr((data.CustomGroupNumber.length - TerritoryComponent.Levels[LevelNumber - 1].LevelIDLength), TerritoryComponent.Levels[LevelNumber - 1].LevelIDLength);

            console.log('prefix: ', preFix, 'ownNumber: ', ownNumber);

            jQuery("#inputGroupPrefixID").html(preFix);
            jQuery("#editedGroupID").val(data.CustomGroupNumber.substr((data.CustomGroupNumber.length - TerritoryComponent.Levels[LevelNumber - 1].LevelIDLength), TerritoryComponent.Levels[LevelNumber - 1].LevelIDLength));// no prefix, only user given group id will be shown
            //substr((root.Children[i].CustomGroupNumber.length - PaddedGroupId.length), PaddedGroupId.length)
            jQuery("#editGroupModal").modal('show');
            setTimeout(function(){jQuery("#editedGroupName").focus();}, 500);
        }
        else if (action === "delete") {
            TerritoryComponent.clickedParent = data;
            this.isBrickExistsToGroupDelete=false;
            if(+data.GroupNumber.charAt(0) < TerritoryComponent.Levels.length && this.checkBrickExistsInLastNode(data)){//not leaf but node exists
                TerritoryComponent.modalTitle = "Deleting group <b>" + data.Name + "</b> from <b>" + this.getLevelName(data) + "</b> level will delete associated groups from subsequent level(s) <b>" + this.getLevelName(data,"subsequent") + "</b>. This will also delete allocated <b>"+ TerritoryComponent.staticBrickOutletType.toLowerCase()+"s</b>  to the groups of <b>" + this.getLevelName(data,"lastLevel") + "</b> level. Would you like to proceed?";
            }else if(+data.GroupNumber.charAt(0) < TerritoryComponent.Levels.length && !this.checkBrickExistsInLastNode(data)){//not leaf and has no node 
                TerritoryComponent.modalTitle = "Deleting group <b>" + data.Name + "</b> from <b>" + this.getLevelName(data) + "</b> level will delete associated groups from subsequent level(s) <b>" + this.getLevelName(data,"subsequent") + "</b>. Would you like to proceed?";
            }else if(+data.GroupNumber.charAt(0) == TerritoryComponent.Levels.length && this.checkBrickExistsInLastNode(data)){// leaf and has node                 
                TerritoryComponent.modalTitle = "Deleting group <b>" + data.Name + "</b> from <b>" + this.getLevelName(data) + "</b> level will delete allocated <b>"+ TerritoryComponent.staticBrickOutletType.toLowerCase()+"s</b>  to the group. Would you like to proceed?";
            }else if(+data.GroupNumber.charAt(0) == TerritoryComponent.Levels.length && !this.checkBrickExistsInLastNode(data)){// leaf and has no node 
                TerritoryComponent.modalTitle = "Do you want to delete group <b>" + data.Name + "</b> from <b>" + this.getLevelName(data) + "</b> level?";                
            }
            TerritoryComponent.modalSaveBtnVisibility = true;
            TerritoryComponent.modalSaveFnParameter = "Delete Group";
            TerritoryComponent.modalBtnCapton = "Yes";
            TerritoryComponent.modalCloseBtnCaption = "Cancel";
            jQuery("#nextModal").modal("show");
        }
        else if (action === "linkToParent") {
            TerritoryComponent.clickedParent = data;
            if (this.getParentList().length == 0) {
                TerritoryComponent.modalTitle = "There are no available nodes to link as parent of group <b>" + data.Name + "<b>.";
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalSaveFnParameter = "";
                TerritoryComponent.modalCloseBtnCaption = "Ok";
                jQuery("#nextModal").modal("show");
                return;
            }
            else if (this.getParentList().length > 0 || !data.IsOrphan) {
                TerritoryComponent.generateLinkToParentModal=true;
                jQuery("#linkToParentModal").modal('show');
            }
            else {
                TerritoryComponent.modalTitle = "Add new Group in previous level before proceeding";
                TerritoryComponent.modalSaveBtnVisibility = false;
                TerritoryComponent.modalSaveFnParameter = "";
                TerritoryComponent.modalCloseBtnCaption = "Ok";
                jQuery("#nextModal").modal("show");
            }


        }
        return;
    }

   fnTerritoryCollapseExpand(data:Group){
       if(data.collapse==false || data.collapse==null){
            data.collapse=true;
       }else{
           data.collapse=false;
       }
     TerritoryComponent.IsChangedInCollapsExpaned=true;
     TerritoryComponent.collapseExpanedClickedNode=data;
   }
    public getLevelName(groupInfo: Group, status: string = "current"): string {
        if (status == "next") {
            return TerritoryComponent.Levels[Number(groupInfo.GroupNumber.charAt(0))].Name;
        }else if(status=='subsequent'){
            let levels=" ";
            for(let i=+groupInfo.GroupNumber.charAt(0);i<TerritoryComponent.Levels.length;i++){
                levels=levels+TerritoryComponent.Levels[i].Name+","
            }
            return levels.slice(0, -1);

        }else if(status=="lastLevel"){
             return TerritoryComponent.Levels[Number(TerritoryComponent.Levels.length)-1].Name;
        } else {
            return TerritoryComponent.Levels[Number(groupInfo.GroupNumber.charAt(0)) - 1].Name;
        }
    }
    public getParentList(): Group[] {
        this.parentList = [];
        if (typeof TerritoryComponent.clickedParent != 'undefined' && TerritoryComponent.clickedParent) {
            var currrentParentGroupNumber: string = TerritoryComponent.clickedParent.ParentGroupNumber || "";
            this._getParentList(TerritoryComponent.Groups, +TerritoryComponent.clickedParent.GroupNumber.charAt(0) - 1, currrentParentGroupNumber);
        }
        return this.parentList;
    }
    private _getParentList(root: Group, parenLlevelId: number, parentGroupNumber: string): void {
        if (+root.GroupNumber.charAt(0) === parenLlevelId && !root.IsOrphan && root.GroupNumber != parentGroupNumber) {
            this.parentList.push(root);
        }
        else if (+root.GroupNumber.charAt(0) === parenLlevelId && !root.IsOrphan && TerritoryComponent.clickedParent.IsOrphan) {
            this.parentList.push(root);
        }
        else {
            if (typeof root.Children != 'undefined' && root.Children) {
                root.Children.forEach(x => this._getParentList(x, parenLlevelId, parentGroupNumber));
            }
        }
    }

    public getLevelFromGroup(groupNumber: string): Level {
        return TerritoryComponent.Levels[(+groupNumber.charAt(0)) - 1];
    }

    public getNextLevelFromGroup(groupNumber: string): any {
        //return TerritoryComponent.Levels[(+groupNumber.charAt(0))] ? TerritoryComponent.Levels[(+groupNumber.charAt(0))].LevelColor : '#babbaba';
        return CONSTANTS.LEVEL_COLORS[(+groupNumber.charAt(0))] ? CONSTANTS.LEVEL_COLORS[(+groupNumber.charAt(0))].levelColor : '#babbaba';
    }

    public groupVisualCountInLevel(levelId: number, parentGroupNumber: string): number {
        return (this._groupShowCountInLevel(TerritoryComponent.Groups, parentGroupNumber, levelId - 1) + this._groupShowCountInLevel(TerritoryComponent.Groups, parentGroupNumber, levelId));
    }
    private _groupShowCountInLevel(root: Group, parentGroupNumber: string, levelID: number): number {
        var count = 0;
        if (+root.GroupNumber.charAt(0) === levelID && root.ParentGroupNumber === parentGroupNumber) {
            if (!root.IsOrphan) {
                count = 1;
            }
            return count;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => count += this._groupShowCountInLevel(x, parentGroupNumber, levelID));
        }
        return count;
    }

    getGlobalDisableFlag(): boolean {
        return TerritoryComponent.globalDisableFlag;
    }

    public orphanGroupsCountInNextLevel(levelId: number): number {
        return this._orphanGroupsCountInNextLevel(TerritoryComponent.Groups, levelId + 1);
    }

    private _orphanGroupsCountInNextLevel(root: Group, levelID: number): number {
        var count = 0;
        if (+root.GroupNumber.charAt(0) === levelID && +root.GroupNumber.charAt(0) > 1) {
            if (root.IsOrphan) {
                count = 1;
            }
            return count;
        }
        else if (typeof root.Children != 'undefined' && root.Children) {
            root.Children.forEach(x => count += this._orphanGroupsCountInNextLevel(x, levelID));
        }
        return count;
    }

    public isNodeDisabled(groupNumber: string): boolean {
        return TerritoryComponent.Levels.length == this.getLevelFromGroup(groupNumber).LevelNumber;
    }

    public nodehasChild(group: Group): boolean {
        let returnType=true;
        if(TerritoryComponent.Levels.length == this.getLevelFromGroup(group.GroupNumber).LevelNumber){
            returnType=false;
        }

        if(group.Children!=null){
            if(group.Children.length==0){
                returnType=false;
            }
        }else{
            returnType=false;
        }
        
        return returnType;
    }



}