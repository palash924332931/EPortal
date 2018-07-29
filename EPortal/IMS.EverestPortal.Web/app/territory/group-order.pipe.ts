import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: 'order', pure: false })
export class OrderArray implements PipeTransform {
    transform(value: any[], colName: string, orderBy: string = 'asc'): any[] {
        if (orderBy == 'desc') {
            return value.sort((n1, n2) => {
                if (typeof n1[colName] == 'string') {
                    if (n1[colName].toLowerCase() < n2[colName].toLowerCase()) { return 1; }
                    if (n1[colName].toLowerCase() > n2[colName].toLowerCase()) { return -1; }
                } else {
                    if (n1[colName] < n2[colName]) { return 1; }
                    if (n1[colName] > n2[colName]) { return -1; }
                }
            });
        } else {
            return value.sort((n1, n2) => {
                if (typeof n1[colName] == 'string') {
                    if (n1[colName].toLowerCase() > n2[colName].toLowerCase()) { return 1; }
                    if (n1[colName].toLowerCase() < n2[colName].toLowerCase()) { return -1; }
                } else {
                    if (n1[colName] > n2[colName]) { return 1; }
                    if (n1[colName] < n2[colName]) { return -1; }
                }
                return 0;
            });
        }
    }
}