import { Pipe,PipeTransform } from '@angular/core';

@Pipe({
    name: 'SearchByNamePipe',
    pure: false
})
    
export class SearchByNamePipe {
    transform(data: any[], searchTerm: string): any[] {
        //console.log(searchTerm);
        //console.log("data" + data[0]);
        searchTerm = searchTerm;
        
        if (searchTerm != '')
            return data ? data.filter(m => m.colText.toLowerCase().indexOf(searchTerm.toLowerCase()) >= 0) : data;
        else
            return data;
    }
}