import { Component, ViewChild, OnInit, EventEmitter,Input,Output } from '@angular/core';
import { ModalDirective } from 'ng2-bootstrap';

@Component({
    selector: 'p-monthpicker',
    templateUrl: '../../../../app/shared/component/p-monthpicker/p-monthpicker.component.html',
    styleUrls: ['../../../../app/shared/component/p-monthpicker/p-monthpicker.component.css']
})

export class PMonthPickerComponent {

    months: any = [];
    currentYear: number = new Date().getFullYear();
    selectedMonthYear: string;

    @Input("selectedValue") selectedValue: string;

    @Output() onSave = new EventEmitter<any>();

    @ViewChild('lgMonthpickerModal') lgMonthpickerModal: ModalDirective;

    ngOnInit(): void {
        this.getMonth();
        this.setCurrentMonth();
        this.setSelectedValue();
        if (this.selectedValue) {
            this.selectedMonthYear = this.selectedValue;
            let month = this.selectedValue.split(' ')[0];
            let year = Number(this.selectedValue.split(' ')[1]);
            this.currentYear = year;
            this.selectMonth(months.filter((m: any) => m.name == month)[0])
        }
        //Update select value
    }
    showPopUp(): void {
        this.lgMonthpickerModal.show();
    }

    getMonth() {
        this.months = months;
    }

    setCurrentMonth(): void {
        var m = new Date().getMonth();        
        this.selectMonth(months[m])
    }

    selectMonth(month: any) {
        for (let it in this.months) {
            if (this.months[it].val == month.val)
                this.months[it].selected = true;
            else
                this.months[it].selected = false;
        }
        this.setSelectedValue();
    }

    previousYear() {
        this.currentYear--;
        this.setSelectedValue();
    }
    nextYear() {
        this.currentYear++;
        this.setSelectedValue();
    }

    save(): void {
        //console.log(this.selectedMonthYear);
        this.onSave.emit(this.selectedMonthYear);
    }

    setSelectedValue(): void {       
        var sMonth = this.months.filter((m: any) => m.selected)[0].name;
        this.selectedMonthYear = sMonth + ' ' + this.currentYear;
    }
}

const months: any[] = [
    { val: '01', name: 'Jan', selected: false },
    { val: '02', name: 'Feb', selected: false },
    { val: '03', name: 'Mar', selected: false },
    { val: '04', name: 'Apr', selected: false },
    { val: '05', name: 'May', selected: false },
    { val: '06', name: 'Jun', selected: false },
    { val: '07', name: 'Jul', selected: false },
    { val: '08', name: 'Aug', selected: false },
    { val: '09', name: 'Sep', selected: false },
    { val: '10', name: 'Oct', selected: false },
    { val: '11', name: 'Nov', selected: false },
    { val: '12', name: 'Dec', selected: false }
];