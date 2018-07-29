import { ViewChild, Component, OnInit, ElementRef, Renderer, HostListener } from "@angular/core";
import { Router, NavigationStart } from "@angular/router";
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { ReportService } from '../Report/report.service';
import { ReportFilterService } from '../Report/reportfilter.service';
import { Observable } from 'rxjs/Observable';
import { Filter, Molecule } from '../shared/component/p-autocomplete/p-autocom.model';
import { PMultiSelectComponent } from '../shared/component/p-multiselect/p-multiselect.component';
import { ClientService } from '../shared/services/client.service';
import { ModalDirective } from 'ng2-bootstrap';
import { ReportFilter } from './reportfilter.model';
import { AuthService } from '../security/auth.service';
import { UserPermission } from '../shared/model';
import { ConfigUserAction } from '../shared/services/config.userAction';

@Component({
    selector: `report-filter`,
    templateUrl: `../../app/Report/report-filter.html`,
    providers: [ReportFilterService],
    styleUrls: ['../../app/Report/report-filter.css']
})

export class ReportFilterComponent {
    @ViewChild('errModal') errModal: ModalDirective

    @ViewChild('createCustomFilterModal') createCustomFilterModal: ModalDirective;
    @ViewChild('updateCustomFilterModal') updateCustomFilterModal: ModalDirective;
    @ViewChild('deleteCustomFilterModal') deleteCustomFilterModal: ModalDirective;

    @ViewChild('warningAboutReportModal') warningAboutReportModal: ModalDirective;

    @ViewChild('txtFilterName') txtFilterName: ElementRef;

    @HostListener('document:keydown', ['$event'])
    handleKeyboardEvent(event: KeyboardEvent) {
        console.log(event);
        let x = event.keyCode;
        if (x === 27) {
            console.log('KeyDown!');
            this.reset();
            
        }
    }
    params: any = {
      //  clientIds : this.GetClientIDList()
        //[1, 2]
    }

    
    GetClientIDList() {

        //alert(this.selectedSection);

        let fieldID = [];
        let fieldclientNo = [];
        let terrIds = [];
        let terrNames = [];
        var result1 = this.fieldsByModule.filter(f => f.FieldName == 'Name' && f.TableName == 'Clients');

        if (result1.length > 0) {
            let clientField = result1[0];
            let values = clientField.fieldValues;
            fieldID = values.map(function (f) {
              return  f.Value
            });
        }

        var resultClientNo = this.fieldsByModule.filter(f => f.FieldName == 'IRPClientNo' && f.TableName == 'IRP.ClientMap');

        if (resultClientNo.length > 0) {
            let clientField = resultClientNo[0];
            let values = clientField.fieldValues;
            fieldclientNo = values.map(function (f) {
                return f.Value
            });
        }


        var resultTerrId = this.fieldsByModule.filter(f => f.FieldName == 'ID' && f.TableName == 'Territories');

        if (resultTerrId.length > 0) {
            let clientField = resultTerrId[0];
            let values = clientField.fieldValues;
            terrIds = values.map(function (f) {
                return f.Value
            });
        }

        var resultTerrNames = this.fieldsByModule.filter(f => f.FieldName == 'Name' && f.TableName == 'Territories');

        if (resultTerrNames.length > 0) {
            let clientField = resultTerrNames[0];
            let values = clientField.fieldValues;
            terrNames = values.map(function (f) {
                return f.Value
            });
        }
        let MktDefIds =[]
        var resultMktDefIds = this.fieldsByModule.filter(f => f.FieldName == 'ID' && f.TableName == 'MarketDefinitions');

        if (resultMktDefIds.length > 0) {
            let clientField = resultMktDefIds[0];
            let values = clientField.fieldValues;
            MktDefIds = values.map(function (f) {
                return f.Value
            });
        }

        let MktDefNames = []
        var resultMktDefNames = this.fieldsByModule.filter(f => f.FieldName == 'Name' && f.TableName == 'MarketDefinitions');

        if (resultMktDefNames.length > 0) {
            let clientField = resultMktDefNames[0];
            let values = clientField.fieldValues;
            MktDefNames = values.map(function (f) {
                return f.Value
            });
        }

             
       

        //this.params.clientIds = fieldID;

        //fieldID = [1, 2];

        this.params = {
            clientIds: fieldID  ,
            clientNos: fieldclientNo,
            TerritoryIds: terrIds,
            TerritoryNames: terrNames,
            MarketDefIds: MktDefIds,
            MarketDefNames: MktDefNames,
            ModuleID : this.selectedSection
                    
        }
      //  }
    }

    tempFieldName: string = "MarketBaseName";
    temp: string[] = [];
    
    title :string = "Report View"
    filterName: string;
    selections: any = [];
    model: any = {};
    selected: any = "";
    selectedValues: any[] = [];
    
    filters: any[]; 
    selectedClientIDs: any[] = [];
    selectedClientNames: any[] = [];

    user: any = {};
    fieldsByModule: any[] = [];
    updatedFields: any[] = [];
    searchQuery: any = {};
    previousStateQuery: any = {};
    isSelectSectionType: boolean = false;
    isModifyDefaultFilter: boolean = false;
    selectedFilterName: string = '';

    constructor(private reportService: ReportService,
        private _reportFilterService: ReportFilterService, private clientService: ClientService,
        private _cookieService: CookieService, private router: Router, private renderer: Renderer, private authService: AuthService) {

        this.router.events
            .filter(e => e instanceof NavigationStart)
            .pairwise().subscribe((lastPreviousRoutes) => {

                if (lastPreviousRoutes.length == 2) {
                    if (lastPreviousRoutes[0].url != '/reportView' && lastPreviousRoutes[0].url != '/report') {
                        this.reportService.setSearchQuery(null);
                    }
                }
            });

    }

   
    ngOnInit(): void {
        this.user = this._cookieService.getObject('CurrentUser');
        this.getSection();

        //Set any precvious any search query any available
        this.previousStateQuery = this.reportService.getSearchQuery();

        
        //for (var f of this.fieldsByModule) {
        //    this.selectAllShowColumn = f.selected && this.selectAllShowColumn;
        //}  

        this.loadUserData();
    }

    private loadUserData() {
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
            var roleid: Number = usrObj.RoleID;
            this.authService.getInitialRoleAccess('System Reporting', 'Reports', roleid).subscribe(
                (data: any) => (this.checkAccess(data)),
                (err: any) => {
                    console.log(err);
                }
            );
        }
    }

    private checkAccess(data: UserPermission[]) {
        for (let p of data) {
            if (p.ActionName == ConfigUserAction.SelectSectionType) {
                this.isSelectSectionType = true;
            }

            if (p.ActionName == ConfigUserAction.ModifyDefaultFilter) {
                this.isModifyDefaultFilter = true;
            }
        }
    }

    
    checkAllSelected() {
        this.selectAllShowColumn = !(this.fieldsByModule.filter(f => !f.selected).length > 0);
         
    }

    showCreateFilter(): void {
        this.createCustomFilterModal.show();
        //this.txtFilterName.nativeElement.focus();
        setTimeout(() => {            
            this.txtFilterName.nativeElement.focus();
        }, 500)
    }

    updateDateFieldValues(fieldName: string, tableName: string, dateValue : string) {

        let selectedValue = [dateValue];

        var obj = {
            Text: dateValue,
            Value: dateValue
        }
        let temp = [obj];
        let newDate = new Date(dateValue)
        for (var f of this.fieldsByModule) {
                if (f.FieldName == fieldName && f.TableName == tableName) {
                    f.fieldValues = temp;
                    f.filterName = this.searchQuery.prevfilter;
            }
                
        }
        
    }

    setClient(model: any, fieldName:string) {
        this.GetClientIDList();
        console.log(model);
    }

    view(): void {      
        //let fc : Number = this.fieldsByModule.length;
        //if (fc == 0) {
        //    alert ("This request might return 
        //}
        var roleid: Number;
        //if territory and all filter selected
        var usrObj: any = this._cookieService.getObject('CurrentUser');
        if (usrObj) {
             roleid = usrObj.RoleID;
        }
        
       // if (checkAlert) {
            let fieldByModule = this.fieldsByModule.filter(f => f.fieldValues.length > 0);
            if ((this.selectedSection == "3" && fieldByModule.length == 0 && (roleid == 3 || roleid == 4 || roleid == 5 || roleid == 6 || roleid == 7)) || (this.selectedSection == "1" && fieldByModule.length == 0 && (roleid == 3 || roleid == 4 || roleid == 5 || roleid == 6 || roleid == 7))) {
                this.warningAboutReportModal.show();
            }
            else {
            this.setSearchQuery();
            this.reportService.setSearchQuery(this.searchQuery);
            this.router.navigateByUrl('/reportView');
       }
    }

    clickedOK(): void {
        this.warningAboutReportModal.hide();
        this.setSearchQuery();
        this.reportService.setSearchQuery(this.searchQuery);
        this.router.navigateByUrl('/reportView');
    }



    setSearchQuery(): void {
        let showInTableColumns: string[] = [];
        showInTableColumns = this.fieldsByModule.filter(f => f.selected).map(function (x) {
            return x.FieldName;
        });
       let DisplayColumns = this.fieldsByModule.filter(f => f.selected).map(function (x) {
            return x;
        });

        // let fields = 
        this.setUpdatedFields();
        let fieldByModule = this.fieldsByModule.filter(f => f.fieldValues.length > 0);
        this.searchQuery = {
            columnsToDisplay: DisplayColumns,
            columns: showInTableColumns,
            fields: fieldByModule,
            prevQuery: this.fieldsByModule,
            prevSection: this.selectedSection,
            prevFilter: this.selectedFilter,
            filterName: this.txtFilterName,
            sectionId: this.selectedSection,
            prevFilters: this.filters      
        }
    }

    setUpdatedFields(): void {
        this.updatedFields = this.fieldsByModule.filter(f => (f.selected || f.include || f.fieldValues.length > 0));
    }

    getFieldByModule(): void {
        this.fieldsByModule = [];       
        this._reportFilterService.GetFieldsByModule(this.selectedSection, this.user.UserID)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe((res: any) => { this.setFieldValues(res.data) },
            (err: any) => { console.log(err) },
            () => { console.log("Fields for module Loaded") })
    };

    setFieldValues(fields: any[]) {
        for (let f of fields) {
            f.selected = false;
            f.include = true;
            f.fieldValues = [];
        }
        this.fieldsByModule = fields;

        let filterReq = {
            moduleId: this.selectedSection,
            userId: this.user.UserID
        };
        this.loadFilters(filterReq); 
    }

    updateIncludeValues(include:any,field:any) {
        field.include = !include;
        this.setSearchQuery();

        this.canViewReport = false;
        if (this.fieldsByModule.filter(x => x.include).length > 0 && this.fieldsByModule.filter(x => x.selected).length > 0)
            this.canViewReport = true; 
    }

    getFilters(req: any): void {
        this.reportService.GetReportFilters(req).subscribe(
            (res: any) => this.setCustomFilters(res),
            (err: any) => console.log(err)
        );
    }


    customFilters: any[] = [];
    setCustomFilters(response: any): void {
        this.customFilters = response.data;
    }

    selectedFilter: any = "";
    selectedSection: any = "";
    newFilterName: string = "";


    sections: any[] = [];
    getSection() {
        let userTypeId = 2;
        this._reportFilterService.GetSection(userTypeId)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe((res: any) => { this.setSection(res.data), this.getFieldByModule() },
            (err: any) => { console.log(err) },
            () => { console.log("Sections Loaded") });
    }


    onSectionChange(mValue: any, isDropdownChange: false): void {
        let filterReq = {
            moduleId: mValue,
            userId: this.user.UserID
        };
        if (isDropdownChange) {
            this.previousStateQuery = {};
        }
        
        this.getFieldByModule();
        //this.loadFilters(filterReq);
    }

    setSection(data: any) {
        this.selectedSection = "";
        this.sections = data;
        if (this.sections.length > 0) {
            this.selectedSection = this.sections[0].ReportSectionID;
            //let filterReq = {
            //    moduleId: this.selectedSection,
            //    userId: this.user.UserID
            //};               
            //this.loadFilters(filterReq);
        }
       
    }

    isDefaultFilterSelected: boolean = false;
    onChangeFilter(id: number, checkSearchQuery = 0): void {
        this.selectedFilter = id;
        this.isDefaultFilterSelected = this.filters.filter(f => f.FilterID == id)[0].FilterType == "Default";
        this._reportFilterService.GetFilterById(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            (response: any) => { console.log(response.data), this.setSelectedFilterFieldValues(response.data, checkSearchQuery) },
            (err: any) => { console.log(err); },
            () => console.log('data loaded')
            );
        let item = this.filters.filter(f => f.FilterID == id);
        if (item.length > 0) {
            this.selectedFilterName = item[0].FilterName;
        }
        this.setSearchQuery();

    }

    setSelectedFilterFieldValues(selectedFilter: any, checkSearchQuery = 0) {

        let filterSelectedValues = []
        if (selectedFilter.SelectedFields)
        {
           filterSelectedValues = JSON.parse(selectedFilter.SelectedFields);
        }
       

        //clear selection
        for (let f of this.fieldsByModule) {
            f.include = true;
            f.selected = false;
            f.fieldValues = [];

            if (filterSelectedValues && filterSelectedValues.length > 0) {

                let temp = filterSelectedValues.filter(fs => fs.FieldID == f.FieldID)
                if (temp && temp.length) {
                    f.include = temp[0].include;
                    f.selected = temp[0].selected;
                    f.fieldValues = temp[0].fieldValues;
                }
            }
        }
        if (!checkSearchQuery)  this.setPreviousStateValues();
        this.canViewReport = false;
        if (this.fieldsByModule.filter(x => x.selected).length > 0)
            this.canViewReport = true;
        this.checkAllSelected();

        this.GetClientIDList();
    }

    setPreviousStateValues() {
        if (this.previousStateQuery) {
            if (this.previousStateQuery.prevQuery) {
                this.filters = this.previousStateQuery.prevFilters;
                this.fieldsByModule = this.previousStateQuery.prevQuery;
                this.selectedSection = this.previousStateQuery.prevSection;
                this.selectedFilter = this.previousStateQuery.prevFilter;
                this.isDefaultFilterSelected = this.filters.filter(f => f.FilterID == this.selectedFilter)[0].FilterType == "Default";
            }            
        }
    };

    loadFilters(req: any, seletedFilterId = 0) {
               
         this._reportFilterService.GetFilters(req.moduleId, req.userId)
             .finally(() => this.clientService.fnSetLoadingAction(false))
             .subscribe(
             (response: any) => { this.setFilters(response, seletedFilterId)},
                (err: any) => { console.log(err); },
                () => console.log('data loaded')
            );
    }

     setFilters(res: any, selectedFilterId = 0): void {
         //this.fieldsByModule = [];
         this.filters = res.data;
         //console.log(this.filters)

         if (this.filters && this.filters.length > 0) {
             let fid;
             if (selectedFilterId == 0) {
                 fid = this.filters[0].FilterID;
                 this.onChangeFilter(fid);
             } else {
                // fid = selectedFilterId;
                 this.selectedFilter = selectedFilterId;
                 this.isDefaultFilterSelected = false;
                 let item = this.filters.filter(f => f.FilterID == selectedFilterId);

                 if (item.length > 0) {
                     this.selectedFilterName = item[0].FilterName;
                 }
                 this.GetClientIDList();
             }
         }         
     }
    clearSelection() {
        //console.log(this.selected);
        this.selected = "";
    }

    _keyPress(event: any) {       
        if (event.target.value.length >= 100) {
            // invalid character, prevent input
            event.preventDefault();
        }
        //this.isFilterAlreadyExists = false;
    }

    isValidNameContainCustom: boolean = false;
    CreateCustomFilter(filterName: string) {
       
        if (!filterName)
            return;

        if (filterName.toLocaleLowerCase().indexOf('custom') !== -1) {
            this.isValidNameContainCustom = true;
            return;
        }

        this.setUpdatedFields();
        let req = {
            SelectedFields: JSON.stringify(this.updatedFields),           
            FilterName: filterName,
            FilterType: 'Custom',
            ModuleID: this.selectedSection,
            CreatedBy: this.user.UserID
        };
        this.previousStateQuery = {};
        this.clientService.fnSetLoadingAction(true);//to set loading true
        this._reportFilterService.CreateFilter(req)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.setCreateResults(p)),
            e => (console.log(e)),
            () => (this.clientService.fnSetLoadingAction(false))
            );
    }

    isFilterAlreadyExists: boolean = false;
    setCreateResults(id): void {
        if (id == 0) {
            this.isFilterAlreadyExists = true;
            return;
        }
        
        this.loadFilters({
            moduleId: this.selectedSection,
            userId: this.user.UserID
        }, id);

        this.onCreateFilterCancel();
    }

    onCreateFilterCancel(): void {
        this.createCustomFilterModal.hide(), this.newFilterName = "";
        this.isFilterAlreadyExists = false;
        this.isValidNameContainCustom = false;
    }

    confirmUpdate(): void {
        this.updateCustomFilterModal.show();
    }

    UpdateCustomFilter() {     

        this.updateCustomFilterModal.hide();
        this.setUpdatedFields();
        var req = {
            SelectedFields: JSON.stringify(this.updatedFields),
            FilterID: this.selectedFilter,
            //FilterName: 'Custom Filter-Market Updated for test',
            //FilterDescription : 'Filter Updated',
            FilterType: 'Custom',
            //ModuleID: 1,
            UpdatedBy: this.user.UserID
        };
       
        this.clientService.fnSetLoadingAction(true);//to set loading true
        this._reportFilterService.EditCustomFilter(req)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (console.log(p), this.clientService.clearCacheClients()),
            e => (console.log(e)),
            () => (console.log('Update Customm Filter'), this.clientService.fnSetLoadingAction(false))
            );
    }

    DeleteCustomFilter() {
        this.deleteCustomFilterModal.hide()
        this.previousStateQuery = {};
        this.clientService.fnSetLoadingAction(true);//to set loading true        
       this._reportFilterService.DeleteCustomFilter(this.selectedFilter)
           .finally(() => this.clientService.fnSetLoadingAction(false))
           .subscribe(
           p => (this.loadFilters({
               moduleId: this.selectedSection,
               userId: this.user.UserID
           })),
           e => (console.log(e)),
           () => (console.log('Filter Deleted'))
           );
    }

    selectAllShowColumn: boolean = false;
    canViewReport: boolean = false;
    onShowColumnsChange(value: any) {
        if (!value) this.selectAllShowColumn = false;
        this.checkAllSelected();
        this.canViewReport = false;
        if (this.fieldsByModule.filter(x => x.selected).length > 0 )
            this.canViewReport = true;   
               
    }    

    onSelectAll(value: any) {
        this.canViewReport = value;
            for (var f of this.fieldsByModule) {
                f.selected = value;
        }        
    }

   
    reset() {
        this.onChangeFilter(this.filters[0].FilterID);
    }

    clearDateValue(fieldName: string, tableName: string, dateValue: string) {

        let selectedValue = [dateValue];

        var obj = {
            Text: dateValue,
            Value: dateValue
        }
        let temp = [obj];
        let newDate = new Date(dateValue)
        for (var f of this.fieldsByModule) {
            if (f.FieldName == fieldName && f.TableName == tableName) {
                f.fieldValues="";
            }
        }
    }



    }

        


