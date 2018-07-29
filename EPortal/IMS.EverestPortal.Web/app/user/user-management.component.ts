import { Component, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigService } from '../config.service';
import { User } from './user-management.model';
import { Role, Client } from './user-management.model';
import { UserManagementService } from './user-management.service';
import { ModalDirective } from 'ng2-bootstrap';
import { ClientService } from '../shared/services/client.service';
import { ConfigUserAction } from '../shared/services/config.userAction';

declare var jQuery: any;


@Component({
    selector: 'user-management',
    templateUrl: '../../app/user/user-management.html',
    styleUrls: ['../../app/user/user-management.css']
})
export class UserManagementComponent implements OnInit {
    @ViewChild('errModal') errModal: ModalDirective
    @ViewChild('lgUserModal') lgUserModal: ModalDirective
    @ViewChild('deleteUserModal') deleteUserModal: ModalDirective


    model: User;
    roles: Role[] = [];
    initialRoles: Role[] = [];
    clients: Client;
    userList: User[] = [];
    filteredUsers: any[] = [];
    userManagementTableBind: any;
    searchUser: string = "";
    EditMode: boolean = false;
    roleid: number;
    validMsg: string = "";
    usrTitle: string;
    IsVerificationEmailSent: boolean = false;
    IsExternalRole: boolean = false;
    public modalTitle = '<span >Do you want to  Deactivate the user?</span>';
    public modalSaveBtnVisibility: boolean = false;
    public modalSaveFnParameter: string = "";
    public modalBtnCapton: string = "Save";
    public modalCloseBtnCaption: string = "Cancel";
    isModifyInternalRole: boolean = false;
    isEditModal: boolean = false;

    constructor(private clientService: ClientService, private cookieService: CookieService, private userManagementService: UserManagementService, private authService: AuthService) {

    }
    ngOnInit() {
        this.model = new User();
        this.EditMode = false;
        this.clientService.fnSetLoadingAction(true);
        this.loadClients();
        this.loadRoles();
        this.loadUsers();
        // this.searchUsers();
        this.userManagementTableBind = {
            tableID: "static-table",
            tableClass: "table table-border ",
            tableName: "User Management",
            tableRowIDInternalName: "Id",
            tableColDef: [
                { headerName: 'First Name', width: '12%', internalName: 'FirstName', className: "static-pack-description", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Last Name', width: '12%', internalName: 'LastName', className: "static-market-base", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'User Name', width: '15%', internalName: 'UserName', className: "static-pack-description", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Email', width: '15%', internalName: 'Email', className: "static-market-base", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Role', width: '8%', internalName: 'RoleName', className: "static-pack-description", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Client Names', width: '14%', internalName: 'ClientNames', className: "static-pack-description", sort: false, type: "", onClick: "", visible: true },
                { headerName: 'Maintenance Period Reminder', width: '7%', internalName: 'MaintenancePeriodEmail', className: "static-market-base", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'News Alert Reminder', width: '8%', internalName: 'NewsAlertEmail', className: "static-market-base", sort: true, type: "", onClick: "", visible: true },
                { headerName: 'Active', width: '5%', internalName: 'IsActive', className: "static-market-base", sort: true, type: "checkbox", onClick: "Yes", visible: true },

            ],

            enabledCellClick: true,
            enableSerialNo: false,
            enableSearch: true,
            enabledEditBtn: true,
            enabledDeleteBtn: true,
            enablePagination: true,
            pageSize: 15,
            displayPaggingSize: 3,
            enabledStaySeletedPage: true,
            enablePTableDataLength: false,
        };

        this.loadUserAccess();

    }

    private loadUserAccess() {
        var usrObj: any = this.cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('Admin', 'User management', roleid).subscribe(
                (data: any) => (this.checkAccess(data)),
                (err: any) => {
                    console.log(err);
                }
            );
        }
    }

    private checkAccess(data: UserPermission[]) {
        for (let p of data) {
            if (p.ActionName == ConfigUserAction.ModifyInternalRole) {
                this.isModifyInternalRole = true;
            }
        }
    }

    fnActivityOnRecord(event: any) {

        if (event.action == "edit-item") {
            //action for edit item
            //console.log("You have click to edit item");
            this.EditUser(event.record);

        }

        if (event.action == "delete-item") {
            //action for delete
            //console.log("You have click to delete item");
            this.showDeleteUserModal(event.record);
        }
    }

    fnIndividualCheckboxAction(e: any) {
        //console.log("You have clicked check box");

        this.UpdateUserStatus(e.record);
    }

    SaveUser(model: User, isValid: boolean) {
        this.validMsg = '';
        if (this.EditMode == false) {
            var isEmailExist = this.userList.findIndex(p => p.Email.trim().toLowerCase() == model.Email.trim().toLowerCase());
            var isUsernameExist = this.userList.findIndex(p => p.UserName.trim().toLowerCase() == model.UserName.trim().toLowerCase());
            if (isUsernameExist > -1) {
                this.validMsg = "User Name already exist";
                return;
            }
            else if (isEmailExist > -1) {
                this.validMsg = "Email already exist";
                return;
            }

        }
        if (this.EditMode == true) {
            var isEmailExist = this.userList.findIndex(p => p.Email.trim().toLowerCase() == model.Email.trim().toLowerCase() && p.UserID != model.UserID);
            var isUsernameExist = this.userList.findIndex(p => p.UserName.trim().toLowerCase() == model.UserName.trim().toLowerCase() && p.UserID != model.UserID);
            if (isUsernameExist > -1) {
                this.validMsg = "User Name already exist";
                return;
            }
            else if (isEmailExist > -1) {
                this.validMsg = "Email already exist";
                return;
            }

        }
        if (this.IsExternalRole && this.model.ClientID == 0) {
            this.validMsg = "Client is required";
            return;
        }
        //console.log(model, isValid);
        if (isValid) {
            var usrObj: any = this.cookieService.getObject('CurrentUser');
            var userid;
            if (usrObj) {
                userid = usrObj.UserID;
            }
            this.clientService.fnSetLoadingAction(true);
            model.ActionUser = userid;
            this.userManagementService.AddUser(model)
                .subscribe(
                r => { console.log('user added'), this.lgUserModal.hide(); this.loadUsers(); this.validMsg; },
                e => { console.log("error" + e), alert('Error while saving') }
                );
        }

    }
    showDeleteUserModal(user: User) {

        this.usrTitle = 'Delete User';
        this.validMsg = '';
        Object.assign(this.model, user);
        //this.roles = this.initialRoles;
        //if (!this.isModifyInternalRole) {
        //    let r = this.initialRoles.filter(i => i.RoleID == this.model.RoleID);
        //    if (r.length > 0) {
        //        if (r[0].IsExternal) {
        //            this.roles = this.initialRoles.filter(i => i.IsExternal);
        //        }
        //    }
        //}
        //this.roleChange(this.model.RoleID);

        this.deleteUserModal.show();
    }
    DeleteUser(model: User) {
        this.validMsg = '';

        var usrObj: any = this.cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;

            this.clientService.fnSetLoadingAction(true);
            model.ActionUser = userid;
            this.userManagementService.DeleteUser(model)
                .subscribe(
                r => { console.log('user deleted'), this.deleteUserModal.hide(); this.loadUsers(); this.validMsg; },
                e => { console.log("error" + e), alert('Error while saving') }
                );
            this.clientService.fnSetLoadingAction(false);

        }

    }
    request: any;
    public btnModalSaveClick(action: string, link: string): void {
        debugger;
        if (action == "update_status") {
            this.clientService.fnSetLoadingAction(true);
            this.userManagementService.UpdateUserStatus(this.request)
                .subscribe(
                r => { console.log('user status updated'), jQuery("#nextModal").modal("hide"); this.loadUsers(); this.validMsg = ''; },
                e => { console.log("error" + e), jQuery("#nextModal").modal("hide"), alert('Error while saving') }
                );

        }
    }

    fnModalCloseClick(action: string) {

        this.loadUsers();
        jQuery("#nextModal").modal("hide");
    }
    UpdateUserStatus(user: User) {
        this.modalSaveBtnVisibility = true;
        this.modalSaveFnParameter = "update_status";
        this.modalBtnCapton = "Yes";
        if (user.IsActive == true)
            this.modalTitle = '<span>Do you want to Deactivate the user ' + user.FirstName + ' ' + user.LastName + ' ?</span>';
        else
            this.modalTitle = '<span>Do you want to Activate the user ' + user.FirstName + ' ' + user.LastName + ' ?</span>';

        this.request = {
            userid: user.UserID,
            isActive: (user.IsActive == true ? false : true)
        }
        jQuery("#nextModal").modal("show");
        //e.preventDefault();
        //e.stopImmediatePropagation();

        return false;
    }
    private loadClients(): void {
        this.userManagementService.getClients().subscribe(
            (response: any) => {
                this.clients = response;
            },
            (error: any) => {
            }
        );

    }
    private loadRoles() {
        this.userManagementService.getRoles()
            .subscribe(
            (data: Role[]) => {
                this.roles = data
                Object.assign(this.initialRoles, data);
            },
            (err: any) => {
                this.errModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('data loaded')
            );
    }

    roleChange(id: any): void {
        for (var item in this.roles) {
            if (this.roles[item].RoleID == id) {
                this.IsExternalRole = this.roles[item].IsExternal;
                break;
            }
        }

        if (this.IsExternalRole === false) {
            this.model.ClientID = 0;
        }
        this.validMsg = "";
    }

    searchUsers(): void {
        console.log(this.searchUser);
        this.filteredUsers = this.userList.filter(x => x.UserName.toLowerCase()
            .indexOf(this.searchUser.toLowerCase()) >= 0);
        this.itemsPerPage = this.filteredUsers.length;
        this.setUserPagination();
    }


    public usertotalItems: number = this.userList.length;
    public userCurrentPage: number = 1;
    public itemsPerPage: number = 15;
    public userByPage: any[] = [];




    public userPageChanged(event: any): void {
        this.userCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        if (this.searchUser) {
            this.userByPage = this.filteredUsers.slice(startIndex, endIndex)
        }
        else {
            this.userByPage = this.userList.slice(startIndex, endIndex)
        }
    }

    setUserPagination(): void {
        console.log('this.userList.length-' + this.filteredUsers.length);
        if (this.searchUser) {
            this.usertotalItems = this.filteredUsers.length;
        }
        else {
            this.usertotalItems = this.userList.length;
        }
        this.userPageChanged({ page: 1, itemsPerPage: this.itemsPerPage })
    }
    private loadUsers() {
        this.userManagementService.getUsers()
            .subscribe(
            (data: any) => { this.userList = data, this.setUserPagination(); this.clientService.fnSetLoadingAction(false); },
            (err: any) => {
                this.errModal.show(); this.clientService.fnSetLoadingAction(false);
                console.log(err);
            },
            () => console.log('data loaded')
            );
    }
    AddUser() {
        this.usrTitle = 'Add User';
        this.EditMode = false;
        this.IsVerificationEmailSent = false;
        this.validMsg = '';
        this.model = new User();
        this.IsExternalRole = false;
        this.isEditModal = false;
        this.roles = this.initialRoles;
        if (!this.isModifyInternalRole) {
            this.roles = this.initialRoles.filter(i => i.IsExternal);
        }
        this.lgUserModal.show();
    }
    EditUser(user: User) {
        this.usrTitle = 'Edit User';
        this.validMsg = '';
        this.EditMode = true;
        this.IsVerificationEmailSent = false;
        Object.assign(this.model, user);
        this.roles = this.initialRoles;
        if (!this.isModifyInternalRole) {
            let r = this.initialRoles.filter(i => i.RoleID == this.model.RoleID);
            if (r.length > 0) {
                if (r[0].IsExternal) {
                    this.roles = this.initialRoles.filter(i => i.IsExternal);
                }
            }
        }
        this.roleChange(this.model.RoleID);
        this.isEditModal = true;
        this.lgUserModal.show();

    }
    Close() {
        this.EditMode = false;
        this.lgUserModal.hide();
    }
    CloseDelete() {
        this.deleteUserModal.hide();
    }

    ResendAccountVerificationEmail(user: User): void {
        this.userManagementService.ResendAccountVerificationEmail(user)
            .subscribe(
            r => {
                if (r) {
                    this.IsVerificationEmailSent = true;
                }
            },
            e => { console.log("error" + e), alert('Error while sending') }
            );
    }

}