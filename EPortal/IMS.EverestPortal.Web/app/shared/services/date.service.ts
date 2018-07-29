import { Injectable } from '@angular/core';

@Injectable()
export class DateService {

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
    }
}
