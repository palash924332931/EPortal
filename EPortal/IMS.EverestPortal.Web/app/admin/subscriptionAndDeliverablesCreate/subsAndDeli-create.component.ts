import { Component, OnInit } from "@angular/core";
import { SubscriptionAndDeliverablesCreateService } from "./subsAndDeli-create.service";
import { ClientService } from '../../shared/services/client.service';
import { TabDirective, TabsetComponent } from 'ng2-bootstrap';


import { IMyDpOptions } from 'mydatepicker';

@Component({
    selector: "subsdeli-create",
    templateUrl: "../../../app/admin/subscriptionAndDeliverablesCreate/subsAndDeli-create.html",
    //styleUrls: ['../../app/admin/subscriptionAndDeliverablesCreate/subsAndDeli-create.css'],
    styleUrls: ['../../../app/admin/subscriptionAndDeliverablesCreate/subsAndDeli-create.component.css'],
    providers: [SubscriptionAndDeliverablesCreateService],
})

export class SubscriptionAndDeliverableCreateComponent implements OnInit {

    public isSubUpdate: boolean = false;
    public isDeliUpdate: boolean = false;


    public clients: any[] = [];
    public subscriptionClient: any;
    public deliverableClient: any;

    public subscriptions: any = [];
    public selectedSubscription: any;

    public selecteDeliSubscription: any;

    public countries: any[] = [];
    public country: any;

    public services: any[] = [];
    public service: any;

    public territoryBases: any[] = [];
    public territoryBase: any;

    public sources: any[] = [];
    public source: any;


    public dataTypes: any[] = [];
    public dataType: any;

    public durationStartDate: any;
    public durationEndDate: any;

    public durationStartDateDeli: any;
    public durationEndDateDeli: any;

    public reportNo: any;

    //deliverables values
    //selectedDeliverables

    public deliverablesSubscriptions: any = [];
    public selectedDeliSubscription: any;


    public deliverables: any = [];
    public selectedDeliverable: any;

    public deliveryTypes: any[] = [];
    public deliveryType: any;

    public frequencyTypes: any[] = [];
    public frequencyType: any;

    public frequencies: any[] = [];
    public frequency: any;

    public periods: any[] = [];
    public period: any;

    public reportWriters: any[] = [];
    public reportWriter: any;



    //datepicker components

    public myDatePickerOptions: IMyDpOptions = {
        dateFormat: 'mmm yyyy',
        editableDateField: false
    };

    constructor(private subsAndDeliService: SubscriptionAndDeliverablesCreateService,
        private clientService: ClientService) {

    }

    clearSelectionSubcription(): void {
        this.subscriptionClient = null;
        this.selectedSubscription = null;
        this.country = null;
        this.service = null;
        this.source = null;
        this.dataType = null;
        this.durationStartDate = null;
        this.durationEndDate = null;
        this.territoryBase = null;
        this.subscriptions = [];
    }

    clearSelectionDeliverables(): void {
        this.deliverableClient = null;
        this.selectedDeliSubscription = null;
        this.selectedDeliverable = null;
        this.deliveryType = null;
        this.reportWriter = null;
        this.period = null;
        this.durationStartDateDeli = null;
        this.durationEndDateDeli = null;
        this.reportNo = null;
        this.frequencyType = null;
        this.frequency = null;
        this.restriction = null;
    }

    //component init event
    ngOnInit(): void {
        this.loadSubscriptionDropdowns();
        this.loadDeliverablesDropdowns();
    }

    loadSubscriptionDropdowns(): void {
        this.GetDatatypes();
        this.GetClients(); this.GetCountries(); this.GetServices(); this.GetSources();
        this.GetTerritoryBases();
    }

    loadDeliverablesDropdowns(): void {
        this.GetDeliveryTypes();
        this.GetFrequencyTypes();
        this.GetPeriods();
        // this.GetRestictions();       
    }

    onSubscriptionClientChange(client: any) {
        let id = client.Id;
        this.GetSubscriptionsByClientId(id);
    }

    onSubscriptionChange(subscription: any) {
        let id = subscription.Id;
        this.GetSubscriptions(id);
    }

    onDeliClientChange(client: any) {
        let id = client.Id;
        this.GetSubscriptionsByClientId(id, true);
    }

    onDeliSubcriptionChange(subscription: any) {
        let id = subscription.Id;
        this.GetDeliverablesBySubscription(id);
        this.GetRestictions();
    }

    onFrequencyTypeChange(fType: any) {
        let id = fType.Id;
        this.GetFrequencies(id);
    }

    onDeliveryTypeChange(deliveryType: any) {
        let id = deliveryType.Id;
        this.GetReportWriters(id);
    }

    onDeliverableChange(deliverable: any) {
        let id = deliverable.Id;
        this.GetDeliverable(id);
        this.GetRestictions();
    }


    public isSuccess: boolean = false;
    public subcriptionMessage: any = "";
    createSubcriptions(): void {
        this.clientService.fnSetLoadingAction(true);
        this.subcriptionMessage = "";

        let createReqquest = {
            clientId: this.subscriptionClient.Id,
            sourceId: this.source.Id,
            countryId: this.country.Id,
            dataTypeId: this.dataType.Id,
            startDate: this.getDatefromDatePickerModel(this.durationStartDate),
            endDate: this.getDatefromDatePickerModel(this.durationEndDate),
            serviceId: this.service.Id,
            serviceTerritoryId: this.territoryBase.Id,
            name: this.getSubcriptionName(),
            reportNo: this.reportNo
        }
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.CreateSubscription(createReqquest)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clearSelectionSubcription(),
                this.subcriptionMessage = p.msg, this.isSuccess = p.isSuccess),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        )

    }

    public deliverableMessage: string;
    public isSuccessDeli: boolean;
    createDeliverables(): void {
        this.deliverableMessage = "";
        this.clientService.fnSetLoadingAction(true);

        let createReqquest = {
            clientId: this.deliverableClient.Id,
            subscriptionId: this.selectedDeliSubscription.Id,
            //deliverableId: this.selectedDeliverable.Id,
            deliveryTypeId: this.deliveryType.Id,
            reportWriterId: this.reportWriter.Id,
            periodId: this.period.Id,
            frequencyTypeId: this.frequencyType.Id,
            frequencyId: this.frequency.Id,
            restrictionId: this.restriction.Id,
            startDate: this.getDatefromDatePickerModel(this.durationStartDateDeli),
            endDate: this.getDatefromDatePickerModel(this.durationEndDateDeli),
            reportNo: this.reportNo
        };
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.CreateDeliverable(createReqquest)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clearSelectionDeliverables(),
                this.deliverableMessage = p.msg, this.isSuccessDeli = p.isSuccess),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false)
            )


    }

    updateSubcriptions(): void {
        this.clientService.fnSetLoadingAction(true);
        this.subcriptionMessage = "";

        let updateReqquest = {
            subscriptionId: this.selectedSubscription.Id,
            sourceId: this.source.Id,
            countryId: this.country.Id,
            dataTypeId: this.dataType.Id,
            startDate: this.getDatefromDatePickerModel(this.durationStartDate),
            endDate: this.getDatefromDatePickerModel(this.durationEndDate),
            serviceId: this.service.Id,
            serviceTerritoryId: this.territoryBase.Id,
            name: this.getSubcriptionName()
        }
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.UpdateSubscription(updateReqquest)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clearSelectionSubcription(),
                this.subcriptionMessage = p.msg, this.isSuccess = p.isSuccess),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        )

    }


    updateDeliverables(): void {
        this.deliverableMessage = "";
        this.clientService.fnSetLoadingAction(true);

        let request = {
            //subscriptionId: this.selectedDeliSubscription.Id,
            deliverableId: this.selectedDeliverable.Id,
            deliveryTypeId: this.deliveryType.Id,
            reportWriterId: this.reportWriter.Id,
            periodId: this.period.Id,
            frequencyTypeId: this.frequencyType.Id,
            frequencyId: this.frequency.Id,
            restrictionId: this.restriction.Id,
            startDate: this.getDatefromDatePickerModel(this.durationStartDateDeli),
            endDate: this.getDatefromDatePickerModel(this.durationEndDateDeli),
        };
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.UpdateDeliverable(request)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clearSelectionDeliverables(),
                this.deliverableMessage = p.msg, this.isSuccessDeli = p.isSuccess),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        )


    }

    getSubcriptionName() {
        return `${this.country.Value} ${this.service.Value} ${this.source.Value} ${this.dataType.Value}`
    }
    //gets the datatypes collection for the dropdowns
    GetDatatypes(): void {
        this.dataTypes = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetDatatypes()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.dataTypes = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetClients(): void {
        this.clientService.fnSetLoadingAction(true);
        this.clients = [];
        this.subsAndDeliService.GetClients()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.clients = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetCountries(): void {
        this.clientService.fnSetLoadingAction(true);
        this.countries = [];
        this.subsAndDeliService.GetCountries()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.countries = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetDeliveryTypes(): void {
        this.deliveryTypes = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetDeliveryTypes()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.deliveryTypes = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetFrequencyTypes(): void {
        this.frequencyTypes = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetFrequencyTypes()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.frequencyTypes = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetFrequencies(id: any, frequencyId: any = null): void {
        this.frequencies = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetFrequencies(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.frequencies = p.data, this.frequency = this.frequencies.find(c => c.Id == frequencyId)),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetPeriods(): void {
        this.periods = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetPeriods()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.periods = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    public restrictions: any = [];
    public restriction: any;
    GetRestictions(): void {
        var clientId = 0, deliverableId = 0;
        if (this.deliverableClient) {
            clientId = this.deliverableClient.Id;
        }

        if (this.selectedDeliverable) {
            deliverableId = this.selectedDeliverable.Id;
        }

        this.restrictions = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetRestriction(deliverableId, "", clientId)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.setRestrictions(p)),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    setRestrictions(data: any[]) {
        this.restrictions = [];
        if (data && data.length > 0) {
            this.restrictions = data;
        } else {
            this.restrictions.push({ Id: 1, Name: "National" });
        }
        if (this.restrictionId)
            this.restriction = this.restrictions.find(c => c.Id == this.restrictionId);
    }

    GetReportWriters(id: any, reportWriterId: any = null): void {
        this.reportWriters = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetReportWriters(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.reportWriters = p.data, this.reportWriter = this.reportWriters.find(c => c.Id == reportWriterId)),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    //sets the subscription values for dropdown on client changes for subscriptions and deliverables
    GetSubscriptionsByClientId(id: any, isDeli: boolean = false): void {
        isDeli! ? this.deliverablesSubscriptions = [] : this.subscriptions = [];
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetSubscriptionsByClientId(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (isDeli! ? this.deliverablesSubscriptions = p.data : this.subscriptions = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetSubscriptions(id: any): void {
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetSubscriptions(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.setSubscriptionsValues(p.data)),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetDeliverable(id: any): void {
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetDeliverable(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.setDeliverableValues(p.data)),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetDeliverablesBySubscription(id: any): void {
        this.clientService.fnSetLoadingAction(true);
        this.subsAndDeliService.GetDeliverablesBySubscription(id)
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.deliverables = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    //sets the dropdown values from subscription object
    setSubscriptionsValues(subscription: any) {
        if (subscription) {
            this.country = this.countries.find(c => c.Id == subscription.CountryId);
            this.source = this.sources.find(c => c.Id == subscription.SourceId);
            this.service = this.services.find(c => c.Id == subscription.ServiceId);
            this.dataType = this.dataTypes.find(c => c.Id == subscription.DataTypeId);
            this.territoryBase = this.territoryBases.find(c => c.Id == subscription.ServiceTerritoryId);
            this.durationStartDate = this.setdate(subscription.StartDate);
            this.durationEndDate = this.setdate(subscription.EndDate);
        }
    }

    public restrictionId: any;
    //sets the dropdown values from deliverable object
    setDeliverableValues(deliverable: any) {
        if (deliverable) {
            this.deliveryType = this.deliveryTypes.find(c => c.Id == deliverable.DeliveryTypeId);

            //set report writers dropdown values from delivery type            
            this.GetReportWriters(this.deliveryType.Id, deliverable.ReportWriterId);

            // set frequencies dropdown values from selected frequency type
            this.frequencyType = this.frequencyTypes.find(c => c.Id == deliverable.FrequencyTypeId);

            this.GetFrequencies(this.frequencyType.Id, deliverable.FrequencyId);

            this.restriction = this.restrictions.find(c => c.Id == deliverable.RestrictionId);


            this.restrictionId = deliverable.RestrictionId

            this.period = this.periods.find(c => c.Id == deliverable.PeriodId);

            this.durationStartDateDeli = this.setdate(deliverable.StartDate);
            this.durationEndDateDeli = this.setdate(deliverable.EndDate);
        }
    }

    GetServices(): void {
        this.subsAndDeliService.GetServices()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.services = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetTerritoryBases(): void {
        this.subsAndDeliService.GetTerritoryBases()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.territoryBases = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    GetSources(): void {
        this.subsAndDeliService.GetSources()
            .finally(() => this.clientService.fnSetLoadingAction(false))
            .subscribe(
            p => (this.sources = p.data),
            e => console.log(e),
            () => this.clientService.fnSetLoadingAction(false),
        );
    }

    setdate(date: any): any {
        // public model: any = { date: { year: 2018, month: 10, day: 9 } };
        let dt = this.parseISOString(date);
        return { date: { year: dt.getFullYear(), month: (dt.getMonth() + 1), day: dt.getDate() } };
    }

    //parse iso date string to javascript string
    parseISOString(s) {
        return new Date(s.split('T')[0]);
    }

    getDatefromDatePickerModel(dt: any): any {
        return dt.date.year + '/' + dt.date.month + '/' + dt.date.day;
        //return new Date(dt.date.year + '/' + dt.date.month + '/' + dt.date.day);
    }

    subTabClick(isUpdate) {
        this.isSubUpdate = isUpdate;
    }

    deliTabClick(isUpdate) {
        if (!isUpdate) {
            this.selectedDeliverable = null;
            this.GetRestictions();
        }
        this.isDeliUpdate = isUpdate;
    }
    
}
