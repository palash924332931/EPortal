import { Component, OnInit } from "@angular/core";
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { MasterDataService } from "./masterData.service";
import { ClientService } from '../../shared/services/client.service';
import { EntityType } from '../../deliverables/deliverables.model';
import { NgForm } from '@angular/forms';
import { AuthService } from '../../security/auth.service';
import { UserPermission } from '../../shared/model';
import { ConfigUserAction } from '../../shared/services/config.userAction';

@Component({
    selector: "master-data",
    templateUrl: "../../../app/admin/subscriptionAndDeliverablesCreate/masterData.html",
    styleUrls: ['../../../app/deliverables/deliverables.css','../../../app/admin/subscriptionAndDeliverablesCreate/masterData.css'],
    providers: [MasterDataService],
})

export class MasterDataComponent {
   
    public options: any[] = ['Country', 'DataType', 'Delivery Type', 'Frequency','Frequency Type','Period','Service','Source','TerritoryBase'];
    public selectedOption: any = this.options[0] ;//sets the default value to master data dropdown
    public country: any = {};
    public service: any = {};
    public serviceTerritory: any = {};
    public dataType: any = {};
    public source: any = {};
    public deliveryType: any = {};
    public period: any = {};
    public frequencyType: any = {};
    public frequency: any = {};

    //messages
    public message: any = "";
    public deleteMessage: any = "";
    
    public isSuccess: boolean = false;

    public countries: any[] = [];
    public services: any[] = [];
    public serviceTerritories: any[] = [];
    public dataTypes: any[] = [];
    public dataTypesForSuchannel: any[] = [];
    public sources: any[] = [];
    public deliveryTypes: any[] = [];
    public periods: any[] = [];
    public frequencyTypes: any[] = [];
    public frequencies: any[] = [];

    //subchannel
    subChannelMessage: string = '';
    entityTypeId: number;
    entityTypes: EntityType[] = [];
    selectedEntityType: EntityType = new EntityType();
    isSubchannelUpdate: boolean = false;
    usrObj: any;

    constructor(private masterDataService: MasterDataService,
        private clientService: ClientService, private authService: AuthService, private cookieService: CookieService) {

    }

    //component init event
    ngOnInit(): void {
        this.GetCountries();//loads the countries
        this.GetServices();//loads the services
        this.GetTerritoryBase();// loads the service territories
        this.GetDatatypes(); // loads the service territories
        this.GetSources();
        this.GetDeliveryTypes();
        this.GetPeriods();
        this.GetFrequencyTypes();
        this.GetFrequencies();
        this.GetEntityTypes();
        this.LoadUserAccess();
    }

    LoadUserAccess() {
        this.usrObj = this.cookieService.getObject('CurrentUser');
        if (this.usrObj) {
            var roleid: number = this.usrObj.RoleID;
            this.authService.getInitialRoleAccess('Data Channel', 'Data Channel', roleid).subscribe(
                (data: any) => {
                    this.CheckAccess(data);
                },
                (err: any) => {
                },
                () => console.log('data loaded')
            );
        }
    }

    ViewDataChannel: boolean = false;
    AddDataChannel: boolean = false;
    DeleteDataChannel: boolean = false;
    AddNewSubchannel: boolean = false;
    DeleteSubchannel: boolean = false;
    ModifyNameOfChannel: boolean = false;
    ModifyNameOfSubchannel: boolean = false;

    CheckAccess(data: UserPermission[]) {
        this.ViewDataChannel = false;
        this.AddDataChannel = false;
        this.DeleteDataChannel = false;
        this.AddNewSubchannel = false;
        this.DeleteSubchannel = false;
        this.ModifyNameOfChannel = false;
        this.ModifyNameOfSubchannel = false;

        for (let it in data) {
            if (data[it].ActionName == ConfigUserAction.ViewDataChannel && data[it].Privilage == 'View') {
                this.ViewDataChannel = true;
            }

            if (data[it].ActionName == ConfigUserAction.AddDataChannel && data[it].Privilage == 'Add') {
                this.AddDataChannel = true;
            }

            if (data[it].ActionName == ConfigUserAction.DeleteDataChannel && data[it].Privilage == 'Delete') {
                this.DeleteDataChannel = true;
            }

            if (data[it].ActionName == ConfigUserAction.AddNewSubchannel && data[it].Privilage == 'Add') {
                this.AddNewSubchannel = true;
            }

            if (data[it].ActionName == ConfigUserAction.DeleteSubchannel && data[it].Privilage == 'Delete') {
                this.DeleteSubchannel = true;
            }

            if (data[it].ActionName == ConfigUserAction.ModifyNameOfChannel && data[it].Privilage == 'Edit') {
                this.ModifyNameOfChannel = true;
            }

            if (data[it].ActionName == ConfigUserAction.ModifyNameOfSubchannel && data[it].Privilage == 'Edit') {
                this.ModifyNameOfSubchannel = true;
            }
        }

        if (!this.ViewDataChannel) {
            let index = this.options.indexOf('DataType');
            if (index != -1) {
                this.options.splice(index, 1);
            }
        }
    }

    GetFrequencies(): void {
        this.clientService.fnSetLoadingAction(true);
        this.frequencies = [];
        this.masterDataService.GetFrequencies()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.frequencies = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }
    GetFrequencyTypes(): void {
        this.clientService.fnSetLoadingAction(true);
        this.frequencyTypes = [];
        this.masterDataService.GetFrequencyTypes()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.frequencyTypes = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetPeriods(): void {
        this.clientService.fnSetLoadingAction(true);
        this.periods = [];
        this.masterDataService.GetPeriods()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.periods = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetCountries(): void {
        this.clientService.fnSetLoadingAction(true);
        this.countries = [];
        this.masterDataService.GetCountries()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.countries = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetServices(): void {
        this.clientService.fnSetLoadingAction(true);
        this.services = []
        this.masterDataService.GetServices()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.services = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetTerritoryBase(): void {
        this.clientService.fnSetLoadingAction(true);
        this.serviceTerritories = [];
        this.masterDataService.GetTerritoryBases()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.serviceTerritories = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetDatatypes(): void {
        this.clientService.fnSetLoadingAction(true);
        this.dataTypes = [];
        this.masterDataService.GetDatatypes()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => {
                this.dataTypes = p.data;

                this.dataTypesForSuchannel = this.dataTypes.filter(d => d.IsChannel == true);
            },
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetSources(): void {
        this.clientService.fnSetLoadingAction(true);
        this.sources = [];
        this.masterDataService.GetSources()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.sources = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetDeliveryTypes(): void {
        this.clientService.fnSetLoadingAction(true);
        this.deliveryTypes = [];
        this.masterDataService.GetDeliveryTypes()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.deliveryTypes = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    setCountry(country: any): void {
        this.country = {};
        if (country) {
            this.country.countryId = country.CountryId;
            this.country.CountryName = country.Name;
            this.country.isocode = country.ISOCode;
        }
    }

    setService(m: any): void {
        this.service = {};
        if (m) {
            this.service.ServiceId = m.ServiceId;
            this.service.ServiceName = m.Name;
        }  
    }

    setTerritoryBase(m: any): void {
        this.serviceTerritory = {};
        if (m) {
            this.serviceTerritory.ServiceTerritoryId = m.ServiceTerritoryId;
            this.serviceTerritory.TerritoryBase = m.TerritoryBase;
        }
    }

    IsChannelSaved: boolean = false;
    setDataType(m: any): void {
        this.IsChannelSaved = false;
        this.dataType = {};
        if (m) {
            this.dataType.DataTypeId = m.DataTypeId;
            this.dataType.DataTypeName = m.Name;
            this.dataType.IsChannel = m.IsChannel;

            this.IsChannelSaved = m.IsChannel;
        }
    }


    setSource(m: any): void {
        this.source = {};
        if (m) {
            this.source.SourceId = m.SourceId;
            this.source.SourceName = m.Name;
        }
    }

    setDeliveryType(m: any): void {
        this.deliveryType = {};
        if (m) {
            this.deliveryType.DeliveryTypeId = m.DeliveryTypeId;
            this.deliveryType.DeliveryTypeName = m.Name;
        }
    }

    setPeriod(m: any): void {
        this.period = {};
        if (m) {
            this.period.PeriodId = m.PeriodId;
            this.period.PeriodName = m.Name;
            this.period.Number = m.Number;
        }
    }

    setFrequencyType(m: any): void {
        this.frequencyType = {};
        if (m) {
            this.frequencyType.FrequencyTypeId = m.FrequencyTypeId;
            this.frequencyType.FrequencyTypeName = m.Name;
            this.frequencyType.DefaultYears = m.DefaultYears;
        }
    }

    setFrequency(m: any): void {
        this.frequency = {};
        if (m) {
            this.frequency.FrequencyId = m.FrequencyId;
            this.frequency.FrequencyName = m.Name;
            this.frequency.FrequencyTypeId = m.FrequencyTypeId;
        }
    }

    //save or creates the country 
    updateCountry(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var country = {
            CountryName: this.country.CountryName,
            CountryId: id == 0 ? this.country.countryId : id,
            ISOcode: this.country.isocode,
            action : action
        };
        this.masterDataService.UpdateCountry(country)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetCountries(), this.setCountry(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }   

    updateService(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            ServiceName: this.service.ServiceName,
            ServiceId: id == 0 ? this.service.ServiceId : id,           
            action: action
        };
        this.masterDataService.UpdateService(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetServices(), this.setService(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updateTerritoryBase(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            TerritoryBase: this.serviceTerritory.TerritoryBase,
            ServiceTerritoryId: id == 0 ? this.serviceTerritory.ServiceTerritoryId : id,
            action: action
        };
        this.masterDataService.UpdateTerritoryBase(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetTerritoryBase(), this.setTerritoryBase(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updateDataType(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            DataTypeName: this.dataType.DataTypeName,
            DataTypeId: id == 0 ? this.dataType.DataTypeId : id,
            IsChannel: this.dataType.IsChannel,
            action: action
        };
        this.masterDataService.UpdateDataType(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetDatatypes(), this.setDataType(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updateSource(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            SourceName: this.source.SourceName,
            SourceId: id == 0 ? this.source.SourceId : id,
            action: action
        };
        this.masterDataService.UpdateSource(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetSources(), this.setSource(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updateDeliveryType(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            DeliveryTypeName: this.deliveryType.DeliveryTypeName,
            DeliveryTypeId: id == 0 ? this.deliveryType.DeliveryTypeId : id,
            action: action
        };
        this.masterDataService.UpdateDeliveryType(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetDeliveryTypes(), this.setDeliveryType(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updatePeriod(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            PeriodName: this.period.PeriodName,
            Number: this.period.Number,
            PeriodId: id == 0 ? this.period.PeriodId : id,
            action: action
        };
        this.masterDataService.UpdatePeriod(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetPeriods(), this.setPeriod(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updateFrequencyType(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            FrequencyTypeName: this.frequencyType.FrequencyTypeName,
            DefaultYears: this.frequencyType.DefaultYears,
            FrequencyTypeId: id == 0 ? this.frequencyType.FrequencyTypeId : id,
            action: action
        };
        this.masterDataService.UpdateFrequencyType(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetFrequencyTypes(), this.setFrequencyType(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    updateFrequency(action: string = "update", id: any = 0): void {
        this.clientService.fnSetLoadingAction(true);
        var updateEntity = {
            FrequencyName: this.frequency.FrequencyName,
            FrequencyTypeId: this.frequency.FrequencyTypeId,
            DefaultYears: this.frequencyType.DefaultYears,
            FrequencyId: id == 0 ? this.frequency.FrequencyId : id,
            action: action
        };
        this.masterDataService.UpdateFrequency(updateEntity)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(p => {
                (action == "delete") ? this.deleteMessage = p.msg : this.message = p.msg,
                    this.isSuccess = p.isSuccess, this.GetFrequencies(), this.setFrequency(null)
            },
            e => console.log(e),
            () => (this.clientService.fnSetLoadingAction(false), this.hideMessage()));
    }

    onMasterOptionsChange(value:any): void {
        this.isSuccess = false;
        this.message = "";
        this.deleteMessage = "";
    }

    onlyNumberKey(event) {
        return (event.charCode == 8 || event.charCode == 0) ? null : event.charCode >= 48 && event.charCode <= 57;
    }

    hideMessage() {
        setTimeout(() => {
            this.deleteMessage = "";
            this.message = "";
            //this will be executed in the next cycle            
        }, 5000);
    }  

    subchannelScreenSelection(subChannelForm: NgForm, tabSelection: boolean) {
        this.isSubchannelUpdate = tabSelection;
        subChannelForm.reset();
        this.subChannelMessage = '';
    }

    entityTypeNameChange() {
        if (this.selectedEntityType != null && this.selectedEntityType.EntityTypeId > 0) {
            let copyEntity = JSON.parse(JSON.stringify(this.entityTypes));

            let entity = copyEntity.filter(x => x.EntityTypeId == this.selectedEntityType.EntityTypeId);
            if (entity.length > 0) {
                this.selectedEntityType = entity[0];
            }
            this.subChannelMessage = '';
        }
    }

    GetEntityTypes() {
        this.masterDataService.getEntityTypes()
            .subscribe((data: EntityType[]) => {
                if (data != null){
                    this.entityTypes = data;
                }
            },
            err => { }
        );
    }

    saveSubchannel(subChannelForm: NgForm) {
        this.clientService.fnSetLoadingAction(true);

        if (this.selectedEntityType != null) {
            this.masterDataService.saveSubchannel(this.selectedEntityType)
                .subscribe((data: boolean) => {
                    if (data == true) {
                        this.isSuccess = true;
                        if (this.selectedEntityType.EntityTypeId == 0 || this.selectedEntityType.EntityTypeId == null) {
                            this.subChannelMessage = 'Subchannel successfully created.';
                        }
                        else {
                            this.subChannelMessage = 'Subchannel successfully updated.';
                        }

                        this.GetEntityTypes();
                        subChannelForm.reset();
                    }
                    else {
                        this.isSuccess = false;
                        this.subChannelMessage = 'Error occurred.';
                    }
                },
                err => {
                    this.isSuccess = false;
                    this.subChannelMessage = 'Error occurred.';
                },
                () => {
                    this.clientService.fnSetLoadingAction(false);
                    setTimeout(() => {
                        this.subChannelMessage = '';
                    }, 5000);
                });
        }
    }

    cancelSubchannel(subChannelForm: NgForm) {
        subChannelForm.reset();
    }

    deleteSubchannel(subChannelForm: NgForm) {
        this.clientService.fnSetLoadingAction(true);

        if (this.selectedEntityType != null && this.selectedEntityType.EntityTypeId != null && this.selectedEntityType.EntityTypeId != undefined) {
            this.masterDataService.deleteSubchannel(this.selectedEntityType.EntityTypeId)
                .subscribe((data: boolean) => {
                    if (data == true) {
                        this.isSuccess = true;
                        this.subChannelMessage = 'Subchannel successfully deleted.'
                        subChannelForm.reset();
                    }
                    else {
                        this.isSuccess = false;
                        this.subChannelMessage = 'Error occurred.';
                    }
                },
                err => {
                    this.isSuccess = false;
                    this.subChannelMessage = 'Error occurred.';
                },
                () => {
                    this.clientService.fnSetLoadingAction(false);
                    setTimeout(() => {
                        this.subChannelMessage = '';
                    }, 5000);
                });
        }
    }

    subchannelChanges(fieldName: string, subChannelForm: NgForm) {
        if (fieldName != null && fieldName != '') {
            let copyEntity: EntityType[] = JSON.parse(JSON.stringify(this.entityTypes));

            if (this.selectedEntityType != null) {
                if (this.selectedEntityType.EntityTypeId > 0) {
                    copyEntity = copyEntity.filter(x => x.EntityTypeId != this.selectedEntityType.EntityTypeId);
                }

                let entity: EntityType[] = [];
                switch (fieldName.toLowerCase()) {
                    case 'entitytypecode': {
                        entity = copyEntity.filter(x => x.EntityTypeCode.toLowerCase().trim() == this.selectedEntityType.EntityTypeCode.toLowerCase().trim());
                        if (entity.length > 0) {
                            subChannelForm.form.controls['entityTypeCode'].setErrors({ 'incorrect': true });
                        }
                        break;
                    }
                    case 'abbrev': {
                        entity = copyEntity.filter(x => x.Abbrev.toLowerCase().trim() == this.selectedEntityType.Abbrev.toLowerCase().trim());
                        if (entity.length > 0) {
                            subChannelForm.form.controls['abbrev'].setErrors({ 'incorrect': true });
                        }
                        break;
                    }
                    case 'display': {
                        entity = copyEntity.filter(x => x.Display.toLowerCase().trim() == this.selectedEntityType.Display.toLowerCase().trim());
                        if (entity.length > 0) {
                            subChannelForm.form.controls['display'].setErrors({ 'incorrect': true });
                        }
                        break;
                    }
                    case 'description': {
                        entity = copyEntity.filter(x => x.Description.toLowerCase().trim() == this.selectedEntityType.Description.toLowerCase().trim());
                        if (entity.length > 0) {
                            subChannelForm.form.controls['description'].setErrors({ 'incorrect': true });
                        }
                        break;
                    }
                }
            }
            
        }
    }


}