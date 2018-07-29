import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from "@angular/forms";
import { RouterModule, ActivatedRoute, Routes } from '@angular/router';
import { HttpModule } from '@angular/http';
import { HashLocationStrategy, LocationStrategy } from '@angular/common';

import { NgIdleModule } from '@ng-idle/core'; // this includes the core NgIdleModule but includes keepalive providers for easy wireup
import { ErrorHandler } from '@angular/core';

import { AppComponent } from './app.component';
import { AdminComponent } from './home/admin/admin.component';
import { LayoutComponent } from './shared/layout.component';

//territory components
import { TerritoryDefinitionComponent } from './territorydefinition/territorydefinition.component';
import { GroupViewComponent } from './territory/groupview.component';
import { LevelViewComponent } from './territorydefinition/levelview.component';

import { TerritoryViewComponent } from './territorydefinition/territory-view.component';
import { TerritoryComponent } from './territory/territory.component';
import { BricksAllocationComponent } from './territory/bricks-allocation/bricks.allocation.component';
import { OrderArray } from './territory/group-order.pipe';

//import data 
import { ImportComponent } from './importData/import.component';

//market components
import { MarketViewComponent } from './market-view/market-view.component';
import { MarketCreateComponent } from './market-view/market-create.component';
import { DropdownComponent } from './market-view/dropdown.component';
import { ModalDialog } from './market-view/ModalDialog';
import { RightSidebarComponent } from './right-sidebar/right-sidebar.component';
import { loginComponent } from './login/login.component';
import { LogoutComponent } from './logout/logout.component';
import { MarketBaseComponent } from './marketbase/marketbase.component';


//pack search
import { PackSearchComponent } from './packSearch/pack-search.component';
import { PTableComponent } from './shared/component/p-table/p-table.component';
import { PAutoCompleteComponent } from './shared/component/p-autocomplete/p-autocom.component';
import { PMonthPickerComponent } from './shared/component/p-monthpicker/p-monthpicker.component';
import { PMultiSelectComponent } from './shared/component/p-multiselect/p-multiselect.component';
import { MakeDraggable,MakeDroppable } from './shared/component/drag-n-drop/drag.n.drop.component';

//Allocation Component
import { AllocationComponent, PendingChangesGuard } from './allocation/allocation.component';

//Release Component
import { ReleaseComponent } from './subscriptionRelease/release.component';
import { AuditVersionComponent } from './AuditVersioning/AuditVersioning.component';

//Report components
import { ReportFilterComponent } from './Report/report-filter.component';
import { ReportViewComponent } from './Report/report-view.component';
import { ReportService } from './Report/report.service';


//autocomplete
import { AutoCompleteComponent } from './components/autocomplete/autocom.component';
import { Ng2AutoCompleteModule } from 'ng2-auto-complete';

//components component
import { ComponentsComponent } from './components/components.component';

//ng2-bootstrap
import { PaginationModule, TabsModule } from 'ng2-bootstrap';
import { ModalModule } from 'ng2-bootstrap';
//security
import { AuthGuard } from './security/auth-guard.service';
import { AuthService } from './security/auth.service';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { GlobalErrorHandler } from './security/everestErrorHandler';
import { DeactivateGuard } from './security/deactivate-guard';

//alert modules
import { AlertModule } from './shared/component/alert/alert.module';

//DatePicker
import { MyDatePickerModule } from 'mydatepicker';

//common client service
import { ClientService } from './shared/services/client.service';
import { TerritoryDefinitionService } from './shared/services/territorydefinition.service';

//client search filtering
import { Pipe, PipeTransform } from '@angular/core';

//Export CSV
import { CsvService } from "angular2-json2csv";
//popover
import { PopoverModule } from 'ngx-popover';
import { SearchByNamePipe } from './packSearch/search-pipe';

import { OnlyNumber } from './shared/directive/onlynumber.directive';
//subscription
import { SubscriptionViewComponent } from './subscription/subscription-view.component';
import { SubscriptionService } from './subscription/subscription.service';

import { UiSwitchModule } from '../node_modules/angular2-ui-switch/src/index'
//deliverable
import { DeliverablesEditComponent } from './deliverables/deliverables-edit.component';
import { DeliverableService } from './deliverables/deliverables-edit.service';
import { ReleaseService } from './subscriptionRelease/release.service';

import { UserManagementComponent } from './user/user-management.component';
import { UserManagementService } from './user/user-management.service';

import { PackDescSearchComponent } from './PackDescSearch/packDescSearch.component';

//extraction
import { TriggerExtractionComponent } from './admin/trigger-extraction/trigger-extraction.component';
import { TriggerExtractionService } from './admin/trigger-extraction/trigger-extraction.service';

//grouping
import { MarketbaseSetupComponent } from './grouping/marketbase-setup/marketbase-setup.component';
import { MarketbasePacksComponent } from './grouping/marketbase-packs/marketbase-packs.component';
import { GroupingDetailsComponent } from './grouping/grouping-details/grouping-details.component';
import { GroupingService } from './shared/services/grouping.service';
import { MarketAttributeModalComponent } from './grouping/modal/market-attribute-modal.component';
import { GroupingModalComponent } from './grouping/modal/grouping-modal.component';
import { GroupingLevelViewComponent } from './grouping/grouping-details/grouping-level-view.component';
//maintenance 
import { SubscriptionAndDeliverableCreateComponent } from './admin/subscriptionAndDeliverablesCreate/subsAndDeli-create.component';
import { MasterDataComponent } from './admin/subscriptionAndDeliverablesCreate/masterData.component';
//Boolean pipe
import { CamelCaseBooleanPipe } from './shared/pipe/camelcase-boolean.pipe';

//unlock definition
import { UnlockComponent } from './unlock/unlock.component';

//drag and drop
import { DndModule } from 'ng2-dnd';

@Pipe({ name: 'filter' })
export class FilterPipe implements PipeTransform {
    transform(value: any[], exponent: string): any {
        
        if (value && exponent) {
            const exp = exponent.toUpperCase();
            const res = value.filter(_ => {
                if (_.Name) return _.Name.toUpperCase().startsWith(exp);
                return true;
            });
           
            return res;
        }
        return value;
    }
}


@NgModule({
    imports: [BrowserModule, FormsModule, HttpModule, Ng2AutoCompleteModule, ModalModule.forRoot(), UiSwitchModule,AlertModule,
        PopoverModule, PaginationModule.forRoot(), NgIdleModule.forRoot(), MyDatePickerModule, TabsModule.forRoot(),
        DndModule.forRoot(),
        RouterModule.forRoot([
            { path: 'admin', component: AdminComponent, canActivate: [AuthGuard], data: { 'contentadmin': true } },
            { path: 'usermanagement', component: UserManagementComponent, data: { 'usermanagement': true } },
            { path: 'logout', component: LogoutComponent },
            //{ path: 'googlemap', component: GoogleMapComponent },
            { path: 'territories', component: TerritoryDefinitionComponent },
            { path: 'marketCreate', component: MarketCreateComponent,canDeactivate: [DeactivateGuard] },
            { path: 'marketCreate/:id/:id2', component: MarketCreateComponent,canDeactivate: [DeactivateGuard] },
            { path: '', component: LayoutComponent, canActivate: [AuthGuard], data: { 'home' : true } },
            { path: 'market', component: MarketViewComponent },
            { path: 'marketbase', component: MarketBaseComponent },
            { path: 'marketbase/:id', component: MarketBaseComponent ,canDeactivate: [DeactivateGuard]},
            { path: 'subscription/allocation', component: AllocationComponent, canActivate: [AuthGuard], canDeactivate: [PendingChangesGuard], data: { 'allocation': true } },
            { path: 'subscription/release', component: ReleaseComponent, canDeactivate: [DeactivateGuard] },
            { path: 'report', component: ReportFilterComponent, canActivate: [AuthGuard], data: { 'report': true } },
            { path: 'reportView', component: ReportViewComponent, canActivate: [AuthGuard], data: { 'report': true } },
         
                //markets
            { path: 'market/:id', component: MarketViewComponent, canActivate: [AuthGuard] },
            { path: 'markets/:id', component: MarketViewComponent, canActivate: [AuthGuard] },
            { path: 'market/:id/:id2', component: MarketViewComponent, canActivate: [AuthGuard] },//To back market view page from Market Creation page
            { path: 'markets/:id/:id2', component: MarketViewComponent, canActivate: [AuthGuard] },
            { path: 'marketAllClient/:id', component: MarketViewComponent, canActivate: [AuthGuard] },

            //territory
            { path: 'territory/:id', component: TerritoryViewComponent, canActivate: [AuthGuard], data: { 'territory': true } },
            { path: 'territories/:id', component: TerritoryViewComponent, canActivate: [AuthGuard], data: { 'territory': true } },
            { path: 'territoryAllClient/:id', component: TerritoryViewComponent, canActivate: [AuthGuard], data: { 'territory': true } },
            { path: 'territory/:id/:id2', component: TerritoryViewComponent, canActivate: [AuthGuard], data: { 'territory': true } },//To back Territory view page from Territory Creation page
            { path: 'territories/:id/:id2', component: TerritoryViewComponent, canActivate: [AuthGuard], data: { 'territory': true } },
            { path: 'territory-create', component: TerritoryComponent,canDeactivate: [DeactivateGuard] },
            { path: 'territory-create/:id/:id2', component: TerritoryComponent,canDeactivate: [DeactivateGuard] },

            //import
            { path: 'importData', component: ImportComponent, canActivate: [AuthGuard] },

            { path: 'subscription/:id', component: SubscriptionViewComponent, canActivate: [AuthGuard], data: { 'subscription': true } },
            { path: 'subscriptions/:id', component: SubscriptionViewComponent, canActivate: [AuthGuard], data: { 'subscription': true }},
            //{ path: 'subscriptionAllClient/:id', component: SubscriptionViewComponent, canActivate: [AuthGuard], data: { 'subscription': true } },
            { path: 'subscription/:id/:id2', component: SubscriptionViewComponent, canActivate: [AuthGuard], data: { 'subscription': true } },
            //{ path: 'subscriptionAllClient/:id/:id2', component: SubscriptionViewComponent, canActivate: [AuthGuard], data: { 'subscription': true } },
            { path: 'subscriptions/:id/:id2', component: SubscriptionViewComponent, canActivate: [AuthGuard], data: { 'subscription': true } },

            { path: 'deliverablesedit', component: DeliverablesEditComponent, canDeactivate: [DeactivateGuard]},
            { path: 'deliverablesedit/:id/:id2', component: DeliverablesEditComponent, canDeactivate: [DeactivateGuard] },
            { path: 'subscriptionAndDeliverablesCreate', component: SubscriptionAndDeliverableCreateComponent, canActivate: [AuthGuard] },
            { path: 'masterData', component: MasterDataComponent, canActivate: [AuthGuard] },
            

            { path: 'components', component: ComponentsComponent },
            { path: 'pack', component: PackSearchComponent, canActivate: [AuthGuard], data: { 'pack': true } },
            { path: 'extraction', component: TriggerExtractionComponent, canActivate: [AuthGuard], data: { 'admin': true } },
            { path: 'AuditVersioning', component: AuditVersionComponent, canActivate: [AuthGuard], data: { 'audit': true }},
            
            { path: 'group', component: MarketbaseSetupComponent },
            { path: 'group/:id/:id2', component: MarketbaseSetupComponent ,canDeactivate: [DeactivateGuard]},
            { path: 'unlock-module', component: UnlockComponent },
            //{ path: 'login', component: loginComponent },
            { path: '', redirectTo: '/', pathMatch: 'full' },
            { path: '**', redirectTo: '/', pathMatch: 'full' }          

        ])
        
    ],
    declarations: [loginComponent, AppComponent, AdminComponent, LayoutComponent,
        /*territories*/  TerritoryDefinitionComponent, GroupViewComponent, LevelViewComponent, AllocationComponent, ReleaseComponent,
        /*territories*/TerritoryViewComponent, TerritoryComponent, BricksAllocationComponent,OrderArray,
        /*market*/ MarketViewComponent, MarketCreateComponent, ModalDialog, DropdownComponent, RightSidebarComponent, PackSearchComponent, FilterPipe, MarketBaseComponent,
        /*autocomplete */ AutoCompleteComponent, PAutoCompleteComponent,
        /*components*/ ComponentsComponent, AuditVersionComponent,
        /*components*/ ComponentsComponent,
       /*Import*/ ImportComponent,
        /*monthpicker*/PMonthPickerComponent,
       /*multiselect*/ PMultiSelectComponent,
        ReportFilterComponent, ReportViewComponent,       
       //grouping
       MarketbaseSetupComponent,
       MarketbasePacksComponent,
        GroupingDetailsComponent, MarketAttributeModalComponent, GroupingModalComponent, GroupingLevelViewComponent,
        SubscriptionAndDeliverableCreateComponent, MasterDataComponent,
        /*Unlock screen*/ UnlockComponent,
	 /*for custom component*/ PTableComponent, SearchByNamePipe, OnlyNumber, SubscriptionViewComponent, DeliverablesEditComponent, UserManagementComponent, LogoutComponent, PackDescSearchComponent,MakeDraggable,MakeDroppable,
    /*extraction*/ TriggerExtractionComponent,
        CamelCaseBooleanPipe],
    bootstrap: [AppComponent],
    exports:[AlertModule],
    providers: [{ provide: ErrorHandler, useClass: GlobalErrorHandler }, CookieService, AuthGuard, AuthService, PendingChangesGuard, ClientService, TerritoryDefinitionService, CsvService, SearchByNamePipe, SubscriptionService, ReportService, DeliverableService, ReleaseService, TriggerExtractionService, GroupingService
        , UserManagementService,DeactivateGuard, { provide: LocationStrategy, useClass: HashLocationStrategy }]

})

export class AppModule { }
