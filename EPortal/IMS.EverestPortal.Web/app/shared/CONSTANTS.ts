import { Injectable } from '@angular/core';

@Injectable()
export class CONSTANTS {

    public static LEVEL_COLORS = [
        { level: 0, color: 'blue', levelColor: '#25b4ff', backgroundColor: '#D7ECF6' },
        { level: 1, color: 'purple', levelColor: '#9933CC', backgroundColor: '#E9D8EF' },
        { level: 2, color: 'green', levelColor: '#84bd00', backgroundColor: '#D2EECF' },
        { level: 3, color: 'yellow', levelColor: '#ffcf34', backgroundColor: '#F8F0DF' },
        { level: 4, color: 'dark blue', levelColor: '#297dfd', backgroundColor: '#D7ECF6' },
        { level: 5, color: 'orange', levelColor: '#e35205', backgroundColor: '#fbe5da' }

    ];
    public static months: any[] = [
        { val: '01', name: 'Jan', selected: true },
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
    public static months2: any[] = [
        { val: '01', name: 'Jan', selected: true },
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
}


