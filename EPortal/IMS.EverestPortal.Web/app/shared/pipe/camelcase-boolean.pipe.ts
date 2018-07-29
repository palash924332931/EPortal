import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: 'camelcaseBoolean'
})

export class CamelCaseBooleanPipe implements PipeTransform {
    transform(value) {
        if (typeof (value) === typeof (true)) {
            return value ? 'True' : 'False';
        }
        else if (typeof (value) === typeof ('string')) {
            if (value.toLowerCase() === 'dynamic') {
                return 'Dynamic';
            }
            else if (value.toLowerCase() === 'static') {
                return 'Static';
            }
            else if (value.indexOf('$$$$$$') > -1){
                return value.replace("$$$$$$", "≠");
            }
        }

        return value;
    }
}