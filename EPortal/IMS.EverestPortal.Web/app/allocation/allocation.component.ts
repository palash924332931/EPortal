import { Component, OnInit, ViewChild, HostListener } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { AllocationService } from './allocation.service';
import { ClientService } from '../shared/services/client.service';
import { ModalDirective, PaginationComponent } from 'ng2-bootstrap';



@Component({
    selector: 'allocation',
    templateUrl: '../../app/allocation/allocation.html',
    providers: [AllocationService, ClientService],
    styleUrls: ['../../app/subscription/subscription.component.css']
})

export class AllocationComponent implements ComponentCanDeactivate {

    @ViewChild('lgModalAllocation') lgModalAllocation: ModalDirective
   
    @HostListener('window:beforeunload')
    canDeactivate(): Observable<boolean> | boolean {
        // insert logic to check if there are pending changes here;
        // returning true will navigate without confirmation
        // returning false will show a confirm dialog before navigating away
       // alert("Inside Deactivate");
        return true;
    }



    private users: any[];
    private clients: any[];
    selectedUsers: any[] = [];
    selectedClients: any[] = [];
    showDetails: boolean = false;

    //Users Details
    clientsByUser: any[] = [];
    selectedUser: any;
    showUserDetails: boolean = false;
    reAllocateUserName: string = "";
    toUser: any;
    reallocateUsers: any[];
    checkedUser: any[] = [];
    searchUser: string = "";
    searchClient: string = "";
    filteredUsers: any[] = [];


    //Clients Details
    usersByClient: any[] = [];
    selectedClient: any;
    showClientDetails: boolean = false;
    reAllocateClientName: string = "";
    toClient: any;
    reallocateClients: any[];
    filteredClients: any[] = [];





    constructor(private allocationService: AllocationService, private cookieService: CookieService, private clientService: ClientService) {

        //window.onbeforeunload = function (e) {
        //    //this.lgModalAllocation.show();
        //    return 'Dialog text here.';
        //};
    };


    ngOnInit(): void {
        this.loadUser(); this.loadClients();
    }

    loadUser() {
        this.allocationService.GetUsers()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.users = this.SetSelectedValue(p.data),
                this.filteredUsers = this.SetSelectedValue(p.data),
                this.clientService.fnSetLoadingAction(false),
                this.searchUsers(),
                this.setUserPagination(),
                this.selectedUsers = []
            ),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }


    loadClients() {
        this.allocationService.GetClients()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clients = this.SetSelectedValue(p.data),
                this.filteredClients = this.SetSelectedValue(p.data),
                this.clientService.fnSetLoadingAction(false),
                this.setClientPagination(),
                this.searchClients(), this.selectedClients = []),

            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    //Allocate
    Allocate() {        
        this.selectedUsers = this.getSelectedValues(this.filteredUsers, 'userId');
        this.selectedClients = this.getSelectedValues(this.filteredClients, 'clientId');

        var usrObj: any = this.cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }

        var req = {
            Users: this.selectedUsers,
            Clients: this.selectedClients,
            ActionUser: userid
        };
        
        this.clientService.fnSetLoadingAction(true);//to set loading true
        this.allocationService.Allocate(req)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (console.log(p), this.clientService.clearCacheClients()),
            e => (console.log(e)),
            () => (this.loadUser(), this.loadClients(), this.setUserPagination(), this.setClientPagination(),
                this.showDetails = false, this.clientService.fnSetLoadingAction(false))
            );
    }


    //Deallocate
    reallocateUser() {

        var selectedUser = [this.selectedUser.userId];
        var selectedClients = this.getSelectedValues(this.clientsByUser, 'clientId');
        var reAllocatedToUser = [this.toUser];

        var usrObj: any = this.cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }

        var request = {
            Users: selectedUser,
            Clients: selectedClients,
            ReallocatedUsers: reAllocatedToUser,
            ReallocatedClients: selectedClients,
            ActionUser: userid
        };

        this.clientService.fnSetLoadingAction(true);

        this.allocationService.reAllocate(request)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            r => (this.loadUser(), this.loadClients(), this.getClientsByUser(this.selectedUser),
                this.lgModalAllocation.hide(), this.clientService.fnSetLoadingAction(false), this.toUser = "", this.clientService.clearCacheClients()),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    reallocateClient() {

        var selectedClient = [this.selectedClient.clientId];
        var selectedUsers = this.getSelectedValues(this.usersByClient, 'userId');
        var reAllocatedToClient = [this.toClient];

        var usrObj: any = this.cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }

        var request = {
            Users: selectedUsers,
            Clients: selectedClient,
            ReallocatedUsers: selectedUsers,
            ReallocatedClients: reAllocatedToClient,
            ActionUser: userid
        };

        this.clientService.fnSetLoadingAction(true);

        this.allocationService.reAllocate(request)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            r => (this.loadClients(), this.loadUser(), this.getUsersByClient(this.selectedClient),
                this.lgModalAllocation.hide(), this.clientService.fnSetLoadingAction(false), this.toClient = "", this.clientService.clearCacheClients()),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    setToReallocateUser() {
        this.reallocateUsers = [];
        var request = {
            ReallocatedClients: this.getSelectedValues(this.clientsByUser, 'clientId')
        }
        this.allocationService.getToReallocateUser(request)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            r => (this.reallocateUsers = r.data, this.lgModalAllocation.show()),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
        this.selectAllSummaryClient = false;
    }

    setToReallocateClient() {
        this.reallocateClients = [];
        var request = {
            ReallocatedUsers: this.getSelectedValues(this.usersByClient, 'userId')
        }
        this.allocationService.getToReallocateClient(request)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            r => (this.reallocateClients = r.data, this.lgModalAllocation.show()),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );

        this.selectAllSummaryUser = false;
    }

    isClientDeleteDisabled: boolean = true;
    updateDetailClientSelection(evt: any): void {
        this.isClientDeleteDisabled = !(this.getSelectedValues(this.clientsByUser, 'clientId').length > 0)
        if (!evt)
            this.selectAllSummaryClient = false;
    }

    isUserDeleteDisabled: boolean = true;
    updateDetailUserSelection(evt: any): void {
        this.isUserDeleteDisabled = !(this.getSelectedValues(this.usersByClient, 'userId').length > 0)
        if (!evt)
            this.selectAllSummaryUser = false;
    }


    //Removes clients from assigned user
    RemoveClientsFromUser(user: any): void {
        var Users = [user.userId];
        var clients = this.getSelectedValues(this.clientsByUser, 'clientId')

        var usrObj: any = this.cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }

        var req = {
            Users: Users,
            Clients: clients,
            ActionUser: userid
        };
        this.clientService.fnSetLoadingAction(true)
        this.allocationService.delete(req)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(r => this.clientService.clearCacheClients(),
             e => console.log(e),
            () => (this.loadUser(), this.loadClients(), this.getClientsByUser(user), this.clientService.fnSetLoadingAction(false))
            );

        this.selectAllSummaryClient = false;
    }

    //Removes users from assigned client
    RemoveUsersFromClient(client: any): void {
        var clients = [client.clientId];
        var users = this.getSelectedValues(this.usersByClient, 'userId')

        var usrObj: any = this.cookieService.getObject('CurrentUser');
        var userid;
        if (usrObj) {
            userid = usrObj.UserID;
        }

        var req = {
            Users: users,
            Clients: clients,
            ActionUser: userid
        };
        this.clientService.fnSetLoadingAction(true)
        this.allocationService.delete(req)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(r => this.clientService.clearCacheClients()
            , e => console.log(e),
            () => (this.loadClients(), this.loadUser(), this.getUsersByClient(client), this.clientService.fnSetLoadingAction(false))
            );

        this.selectAllSummaryUser = false;
    }

    //Get User details and allocated clients
    getClientsByUser(user: any): void {
        if (user.count > 0) {
            this.clientService.fnSetLoadingAction(true);
            this.allocationService.GetClientbyUserId(user.userId)
                .finally(() => this.clientService.fnSetLoadingAction(false))
                .subscribe(
                r => (this.setSelectedUserDetails(user, r.data)),
                e => console.log(e),
                () => this.clientService.fnSetLoadingAction(false),
            )
        }
    }



    //Get Clients details and allocated users
    getUsersByClient(client: any): void {
        if (client.count > 0) {
            this.clientService.fnSetLoadingAction(true);
            this.allocationService.GetUsersbyClientId(client.clientId)
                .finally(() => this.clientService.fnSetLoadingAction(false))
                .subscribe(
                r => (this.setSelectedClientDetails(client, r.data)),
                e => console.log(e),
                () => this.clientService.fnSetLoadingAction(false),
            )
        }
    }

    setSelectedUserDetails(user: any, clientsByUser: any[]): void {
        this.isClientDeleteDisabled = true;
        this.selectedUser = user;
        this.clientsByUser = this.SetSelectedValue(clientsByUser);
        this.showDetails = true; this.showUserDetails = true; this.showClientDetails = false;
        this.reAllocateUserName = this.selectedUser.userName;
        this.setclientsByUserPagination();
        this.clientService.fnSetLoadingAction(false);
        //this.reallocateUsers = this.users.filter(x => x.userId != user.userId); 
    }

    setSelectedClientDetails(client: any, usersByClient: any[]): void {
        this.isUserDeleteDisabled = true;
        this.selectedClient = client;
        this.usersByClient = this.SetSelectedValue(usersByClient);
        this.showDetails = true; this.showClientDetails = true; this.showUserDetails = false;
        this.reAllocateClientName = this.selectedClient.clientName;
        this.setusersByClientPagination();
        this.clientService.fnSetLoadingAction(false);
        //this.reallocateClients = this.clients.filter(x => x.clientId != client.clientId);
    }

    SetSelectedValue(data: any[]): any[] {
        for (let d of data) {
            d.selected = false;
        }

        return data
    }

    getSelectedValues(data: any[], key: string): any[] {
        var selectedValues = data.filter(d => d.selected).map(function (x) {
            return x[key];
        });

        return selectedValues;
    }

    updateSelection(evt: any): void {

        this.selectedUsers = this.getSelectedValues(this.users, 'userId');
        this.selectedClients = this.getSelectedValues(this.clients, 'clientId');

    }

    searchUsers(): void {
        this.filteredUsers = this.users.filter(x => x.userName.toLowerCase()
            .indexOf(this.searchUser.toLowerCase()) >= 0);
        this.setUserPagination();
    }

    searchClients(): void {
        this.filteredClients = this.clients.filter(x => x.clientName.toLowerCase()
            .indexOf(this.searchClient.toLowerCase()) >= 0);
        this.setClientPagination();
    }


    //Pagination

    public usertotalItems: number = this.filteredUsers.length;
    public userCurrentPage: number = 1;
    public itemsPerPage: number = 15;
    public userByPage: any[] = [];



    public userPageChanged(event: any): void {
        this.userCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.userByPage = this.filteredUsers.slice(startIndex, endIndex)
    }

    setUserPagination(): void {
        this.usertotalItems = this.filteredUsers.length;
        this.userPageChanged({ page: 1, itemsPerPage: this.itemsPerPage })
    }

    public clienttotalItems: number = this.filteredClients.length;
    public clientCurrentPage: number = 1;
    public clientByPage: any[] = [];


    public clientPageChanged(event: any): void {
        this.clientCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.itemsPerPage;
        var endIndex = startIndex + this.itemsPerPage;
        this.clientByPage = this.filteredClients.slice(startIndex, endIndex)
    }

    setClientPagination(): void {
        this.clienttotalItems = this.filteredClients.length;
        this.clientPageChanged({ page: 1, itemsPerPage: this.itemsPerPage });
    }


    //clientsByUser pagination
    clientsByUserPerPage: any[];
    public clientsByUsertotalItems: number = this.clientsByUser.length;
    public clientsByuserCurrentPage: number = 1;
    public clientsByitemsPerPage: number = 8;

    public clientsByUserPageChanged(event: any): void {
        this.clientsByuserCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.clientsByitemsPerPage;
        var endIndex = startIndex + this.clientsByitemsPerPage;
        this.clientsByUserPerPage = this.clientsByUser.slice(startIndex, endIndex)
    }

    setclientsByUserPagination(): void {
        this.clientsByUsertotalItems = this.clientsByUser.length;
        this.clientsByUserPageChanged({ page: 1, itemsPerPage: this.clientsByitemsPerPage })
    }


    //usersByClient pagination
    usersByClientPerPage: any[];
    public usersByClienttotalItems: number = this.usersByClient.length;
    public usersByClientCurrentPage: number = 1;
    public usersByClientitemsPerPage: number = 8;

    public usersByClientPageChanged(event: any): void {
        this.clientsByuserCurrentPage = event.page;
        var startIndex = (event.page - 1) * this.usersByClientitemsPerPage;
        var endIndex = startIndex + this.usersByClientitemsPerPage;
        this.usersByClientPerPage = this.usersByClient.slice(startIndex, endIndex)
    }

    setusersByClientPagination(): void {
        this.usersByClienttotalItems = this.usersByClient.length;
        this.usersByClientPageChanged({ page: 1, itemsPerPage: this.usersByClientitemsPerPage })
    }

    //select all for summary Panels functionality

    public selectAllSummaryUser: boolean = false;
    updateAllSummaryUser(selectAll: boolean): void {
        for (let user of this.usersByClient) {
            user.selected = selectAll;
        }
        if (this.usersByClient.length > 0)
            this.isUserDeleteDisabled = !selectAll;
    }

    public selectAllSummaryClient: boolean = false;
    updateAllSummaryClient(selectAll: boolean): void {
        for (let client of this.clientsByUser) {
            client.selected = selectAll;
        }
        if (this.clientsByUser.length > 0)
            this.isClientDeleteDisabled = !selectAll;
    }

}



import { CanDeactivate } from '@angular/router';
import { Observable } from 'rxjs/Observable';

export interface ComponentCanDeactivate {
    canDeactivate: () => boolean | Observable<boolean>;
}

export class PendingChangesGuard implements CanDeactivate<ComponentCanDeactivate> {
    canDeactivate(component: ComponentCanDeactivate): boolean | Observable<boolean> {
        // if there are no pending changes, just allow deactivation; else confirm first
        return component.canDeactivate() ?
            true :
            // NOTE: this warning message will only be shown when navigating elsewhere within your angular app;
            // when navigating away from your angular app, the browser will show a generic warning message
            // see http://stackoverflow.com/a/42207299/7307355
            confirm('WARNING: You have unsaved changes. Press Cancel to go back and save these changes, or OK to lose these changes.');
    }
}

