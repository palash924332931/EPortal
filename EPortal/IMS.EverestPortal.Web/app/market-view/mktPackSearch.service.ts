import {Injectable} from "@angular/core";
import { Http, Response, Headers } from '@angular/http';
import 'rxjs/add/operator/map'
import { Observable } from 'rxjs/Observable';
import { PackDescSearch } from '../../app/shared/model';
import { ConfigService } from '../config.service';
import { CommonService } from '../shared/common';
import { AlertService } from '../shared/component/alert/alert.service';

@Injectable()
export class MktPackSeachService{
 private actionUrl: string;
 private headers: Headers;

 constructor(private http: Http, private alertService: AlertService) {
     this.actionUrl = ConfigService.baseWebApiUrl;
        
  }
  private getHeaders(){
    let headers = new Headers();
    headers.set("Access-Control-Allow-Origin", "*");
    headers.append('Content-Type', 'application/json');
    headers.append('Accept', 'application/json');
    return headers;
  }
  getSearchResult(searchParam:any): Observable<PackDescSearch[]> {
      var url = this.actionUrl + '/GetPackDescSearchResult/';
      
        return this.http.post(url, JSON.stringify(searchParam), { headers: CommonService.getHeaders() })
            .map((response: Response) => <PackDescSearch[]>JSON.parse(response.json()))
            .catch((error) => {
                this.alertService.exceptionAlert(error);
                return Observable.throw("");
            });
        
    }
//getSearchResult(stype: string, searchString: string,id : number): Observable<PackDescSearch[]> {
// //let ldata$ =this.http
// //     .get('./app/market-view/data.json')
// //     .map(mapList);
// //     return ldata$;
//    var url = this.actionUrl + '/GetPackDescSearchResult/?type=' + stype + '&searchString=' + searchString + '&clientid=' +id;
//    //let ldata$ = this.http
//    //  .get(`${this.actionUrl}/GetPackResult/?type=1`+searchString, {headers: CommonService.getHeaders()})
//    //    .map(mapList);
//    return this.http.get(url, { headers: CommonService.getHeaders() })
//        .map((response: Response) => <PackDescSearch[]>JSON.parse(response.json()));
//      //return ldata$;
//  }
  private handleError (error: any) {
  let errorMsg = error.message
  return Observable.throw(errorMsg);
}
}
function mapList(response: Response): PackDescSearch[]{
   return response.json().map(toList);
}

function toList(r: PackDescSearch): PackDescSearch{
  let lObj = <PackDescSearch>({
      Pack: r.Pack,
   MarketBase : r.MarketBase,
    });
  return lObj;
  
}

function mapData(response:Response): PackDescSearch{
  return toList(response.json());
}

