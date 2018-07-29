import { Component, OnInit, DoCheck, ViewChild, HostListener } from '@angular/core';
import { Directive, ElementRef, Renderer } from '@angular/core';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { CookieService } from 'angular2-cookie/services/cookies.service';
import { GroupingService } from '../../shared/services/grouping.service';
import { ComponentCanDeactivate, DeactivateGuard } from '../../security/deactivate-guard';
import { ClientMarketBase } from '../../shared/models/client-market-base';
import { MarketDefinitionBaseMap } from '../../shared/models/market-definition-base-map';
import { MarketDefinition } from '../../shared/models/market-definition';
import { GroupingDetailsComponent } from '../grouping-details/grouping-details.component';
import { MarketbasePacksComponent } from '../marketbase-packs/marketbase-packs.component';
import { AlertService } from '../../shared/component/alert/alert.service'
import { ConfigService } from '../../config.service';
import { AuthService } from '../../security/auth.service';
import { Observable } from 'rxjs/Observable';
declare var jQuery: any;
@Component({
  selector: 'app-marketbase-setup',
  templateUrl: '../../../app/grouping/marketbase-setup/marketbase-setup.component.html',
  styleUrls: ['../../../app/grouping/marketbase-setup/marketbase-setup.component.css']
})
export class MarketbaseSetupComponent implements OnInit, DoCheck, ComponentCanDeactivate {
  constructor(private groupingService: GroupingService, private deactiveGuard: DeactivateGuard, private route: ActivatedRoute, private router: Router, private alertService: AlertService, private _cookieService: CookieService, private authService: AuthService)
  { this.loginUserObj = this._cookieService.getObject('CurrentUser'); }

  @ViewChild('groupingDetails') groupingDetails: GroupingDetailsComponent;
  @ViewChild('marketbasePacks') marketbasePacks: MarketbasePacksComponent;
  @HostListener('window:beforeunload')
  canDeactivate(): Observable<boolean> | boolean {
    if (this.marketSetupChangedDetected == true) { // Here add condition to check for any unsaved changes
      //alert("tab close if condition");
      if (this.authService.isTimeout == true)
        return true;
      else
        return false; // return false will show alert to the user
    }
    else {
      //to release lock
      try {
        this.deactiveGuard.fnReleaseLock(this.loginUserObj.UserID, this.selectedMarketDefId, 'Market Module', this.lockType, 'Release Lock').then(result => { this.alertService.fnLoading(false); });
      } catch (ex) {
        this.alertService.fnLoading(false);
      }
      this.alertService.fnLoading(false);
      return true;
    }
  }
  public marketbaseTitle: string = "";
  public marketDefinition: MarketDefinition = new MarketDefinition();
  public marketDefinitionBaseMap: MarketDefinitionBaseMap[] = [];
  public savedMarketDefinitionBaseMap: MarketDefinitionBaseMap[] = [];
  public selectedMarketbaseMap: MarketDefinitionBaseMap;
  public marketbaseTableBind: any;
  public selectedGroupDefId: number = 0;
  public selectedClientId: number = 0;
  public selectedMarketDefId: number = 0;
  public isEditMarketDef: boolean = false;
  public isEnabledSaveBtn: boolean = false;
  public marketSetupChangedDetected: boolean = false;

  //Permission Variables 
  public canCreateMarket: boolean = true;
  public canFilter: boolean = true;
  public canAddToMarketDefinition: boolean = true;
  public canEditMarket: boolean = true;
  public canAddDelMarketBase: boolean = true;
  public canpackListFromMarketbase: boolean = true;
  public canpackListFromPackList: boolean = true;
  public canpacksToGroup: boolean = true;
  public canfactorToGroup: boolean = true;
  public canfactorToPack: boolean = true;
  public canchangeGroupNo_def: boolean = true;
  public canchangeGroupNo: boolean = true;
  public canAddgroupName: boolean = true;
  public canEditContent: boolean = true;
  public isAdmin: boolean = true;
  public tempUserData: any[] = [];

  //for autocomplete
  public filtersApplied: any = [];
  public atcDependencyArray: any[] = [];
  public necDependencyArray: any[] = [];
  public mfrDependencyArray: any[] = [];
  public productDependencyArray: any[] = [];
  public moleculeDependencyArray: any[] = [];
  public operationOnNaGroup: boolean = false;
  public isNAGroupMessageShow: boolean = false;
  public marketBaseGenericErrorMgs: string;
  public factorOrGroupGenericErrorMgs: string;
  public lockType: string;
  public islockDef: boolean = false;
  public dynamicPacks: any[] = [];
  public staticPacks: any[] = [];
  public toggleTitle: string = '';
  public breadCrumbUrl: string = '';
  public IsActiveMarketBaseSetup: boolean = true;
  public IsActivePacks: boolean = false;
  public IsActiveGrouping: boolean = false;
  public loginUserObj: any;
  public selectedMarketBaseForAutoCom: ClientMarketBase[] = [];

  //Autocomplete list
  atc1List: any[]; atc2List: any[]; atc3List: any[]; atc4List: any[]; nec1List: any[]; nec2List: any[]; nec3List: any[]; nec4List: any[]; moleculeList: any[]; manufacturerList: any[]; productList: any[]; poisonScheduleList: any[];
  atc1Selection: any; atc2Selection: any; atc3Selection: any; atc4Selection: any; nec1Selection: any; nec2Selection: any; nec3Selection: any; nec4Selection: any; moleculeSelection: any; manufacturerSelection: any; productSelection: any; formList: any[] = [];

  ngOnInit() {
    //define the lock
    GroupingService.isLockDef = false;
    //for breadCrumbUrl
    if (jQuery(".dropdown-menu li:contains('My Markets')").length > 0) {
      this.toggleTitle = "My Markets";
      //this.breadCrumbUrl = "/market/My-Client";
      this.breadCrumbUrl = "/markets/mymarkets";
    }
    else {
      this.toggleTitle = ConfigService.clientFlag ? "My Clients" : "All Clients";
      this.breadCrumbUrl = ConfigService.clientFlag ? "/market/My-Client" : "/marketAllClient/All-Client";
    }

    //to bind marketbase modal table
    this.alertService.fnLoading(true);//to set loading 
    GroupingService.marketDefinitionBaseMap = [];
    this.savedMarketDefinitionBaseMap = [];
    GroupingService.dynamicPacksList = [];
    let paramID: string = this.route.snapshot.params['id'];
    this.lockType = this.route.snapshot.params['id2'];
    if (this.lockType == 'View Lock') {
      GroupingService.isLockDef = true;
      this.islockDef = true;
    }

    if (paramID != "" && paramID != "undefined" && typeof paramID != 'undefined') {
      if (paramID.indexOf('|') > 0) {
        this.isEditMarketDef = true;
        this.selectedClientId = Number(paramID.split("|")[0]);
        this.selectedMarketDefId = Number(paramID.split("|")[1]);
        //jQuery(".market-title").html(this.lockType == 'View Lock' ? "View Market" : 'Edit Market');

        //to lock history
        this.deactiveGuard.fnNewLock(this.loginUserObj.UserID, this.selectedMarketDefId, "Market Module", this.lockType, "Create Lock")
          .then(result => { })
          .catch((err: any) => { });
      } else {
        this.selectedClientId = Number(paramID);
      }

    } else {
      this.isEditMarketDef = false;
      this.selectedClientId = 0;
      this.selectedMarketDefId = 0;
    }
    // this.subscribeToMarketBaseList();
    // this.createMarketLink = '/marketCreate/' + this.editableClientID;
    // this.checkUserClientAccess(this.editableClientID);


    this.fnBindMarketBaseList();
    this.fnGetMarketBaseList();
  }

  ngDoCheck() {

  }
  fnBacktoPreviousState() {
    this.alertService.confirm("Changes made to the market base selection criteria will not apply to the pack allocation. Would you like to proceed?",
      () => {
        this.marketDefinitionBaseMap = JSON.parse(JSON.stringify(this.savedMarketDefinitionBaseMap));
        this.marketSetupChangedDetected = false;
        return false;
      },
      () => { });
  }

  fnCheckChangeDetectionInMarketSetup() {
    if (JSON.stringify(this.marketDefinitionBaseMap) == JSON.stringify(GroupingService.marketDefinitionBaseMap)) {
      this.marketSetupChangedDetected = false;
    } else {
      this.marketSetupChangedDetected = true;
    }
  }

  //to show the list of market marketbase
  ShowMarketBaseDialog() {
    jQuery("#MarketbaseListModal").modal('show');
  }

  //bind marketbase using p-table
  fnBindMarketBaseList() {
    this.marketbaseTableBind = {
      tableID: "marketbase-table",
      tableClass: "table table-border ",
      tableName: "Add Market Base",
      enableSerialNo: false,
      tableRowIDInternalName: "Id",
      tableColDef: [
        { headerName: ' ', width: '5%', internalName: 'UsedMarketBaseStatus', className: "marketbase-select", sort: false, type: "checkbox-all", onClick: "true" },
        { headerName: 'Available Market Bases', width: '95%', internalName: 'MarketBaseName', className: "marketbase-name", sort: true, type: "", onClick: "" }

      ],
      enableSearch: true,
      pageSize: 10,
      displayPaggingSize: 3,
      enabledStaySeletedPage: true,
      enabledCellClick: true,
      columnNameSetAsClass: 'DeleteStatus'
    };
  }

  //to get list of market Bases
  fnGetMarketBaseList() {
    this.groupingService.fnGetMarketBases(this.selectedClientId, this.selectedMarketDefId, this.selectedMarketDefId > 0 ? 'According to MarketDef' : 'All Market Base').subscribe(
      (data: any) => {
        this.processMarketBases(data);
        //to load market def
        if (this.selectedMarketDefId > 0) {
          this.fnLoadMarketDef();
        }
      },
      (err: any) => {
        this.alertService.fnLoading(false);
        console.log(err);
      },
      () => console.log('market bases loaded')
    );
  }

  //to pull old record
  async fnLoadMarketDef() {
    this.alertService.fnLoading(true);
    this.groupingService.fnGetMarketDef(this.selectedClientId, this.selectedMarketDefId).subscribe(
      (data: MarketDefinition) => {
        if (data == undefined || data == null) {
          return false;
        } else {
          this.marketbaseTitle = data.Name;
          //map old basemap to current UI
          data.MarketDefinitionBaseMaps.forEach((rec: MarketDefinitionBaseMap) => {
            rec.BaseFilters = this.fnFindMarketbaseFilters(rec.MarketBaseId) || [];
            rec.MarketBase = null;
            rec.Selected = true;
            this.marketDefinitionBaseMap.push(rec);
          });

          GroupingService.marketDefinitionBaseMap = JSON.parse(JSON.stringify(this.marketDefinitionBaseMap));
          this.savedMarketDefinitionBaseMap = JSON.parse(JSON.stringify(this.marketDefinitionBaseMap));
          GroupingService.marketDefinition = { Id: data.Id, Name: this.marketbaseTitle, ClientId: this.selectedClientId, Description: '', MarketDefinitionBaseMaps: this.marketDefinitionBaseMap, MarketDefinitionPacks: null, GuiId: "" };
          this.marketDefinition = { Id: data.Id, Name: this.marketbaseTitle, ClientId: this.selectedClientId, Description: '', MarketDefinitionBaseMaps: this.marketDefinitionBaseMap, MarketDefinitionPacks: null, GuiId: "" };
        }
        this.alertService.fnLoading(false);
      },
      (err: any) => {
        this.alertService.fnLoading(false);
      },
      () => console.log('market bases loaded')
    );
  }

  fnRelocateMarketTiles() {
    /*if (this.authService.selectedMarketModule == "" || this.authService.selectedMarketModule == null) {
        this.router.navigate(['market/My-Client/' + this.editableClientID]);
    } else {
        if (this.authService.selectedMarketModule == "mymarkets") {
            this.router.navigate(['markets/' + this.authService.selectedMarketModule + '/' + this.editableClientID]);
        } else {
            this.router.navigate(['market/My-Client/' + this.editableClientID]);
        }
    }*/
    if (JSON.stringify(this.marketDefinitionBaseMap) == JSON.stringify(GroupingService.marketDefinitionBaseMap)) {
      this.alertService.confirm("Do you want to return back to <b>Market Definition</b> view?",
        () => {
          this.router.navigate(['market/My-Client/' + this.selectedClientId]);
          return
        },
        () => { });
    } else {
      this.alertService.confirm("Changes made to the market definition setup will not apply. Would you like to proceed?",
        () => {
          this.router.navigate(['market/My-Client/' + this.selectedClientId]);
          return
        },
        () => { });
    }



  }

  isViewMode() {
    return true;
  }

  listOfMarketBases: ClientMarketBase[] = [];
  listOfAllMarketBases: ClientMarketBase[] = [];
  processMarketBases(data: ClientMarketBase[]) {
    let marketBases = data || [];
    this.listOfAllMarketBases = data || [];
    this.listOfMarketBases = [];
    //for unique record
    if (marketBases.length > 0) {
      let flag: any[] = [];
      for (var i = 0; i < marketBases.length; i++) {
        if (!flag[marketBases[i].Id]) {
          flag[marketBases[i].Id] = true;
          if (marketBases[i].DeleteStatus == 'Deleted') {
            marketBases[i].UsedMarketBaseStatus = null;
          }
          this.listOfMarketBases.push(marketBases[i]);
          //console.log(this.listOfMarketBases);
        }
      }
    }


    //this.enabledMarketBaseTable = this.marketBasesForView.filter((rec: ClientMarketBase) => { if (rec.UsedMarketBaseStatus == 'true' || rec.UsedMarketBaseStatus == 'True') { return true; } else { return false } }).length > 0 ? true : false;
    console.log(this.listOfMarketBases)
    this.alertService.fnLoading(false);
  }

  //to add or remove from tabular format
  fnMarketBaseTableCellClick(event: any) {
    console.log(event.event.target.checked);
    let marketBase: ClientMarketBase = event.record;
    if (event.cellName == "UsedMarketBaseStatus") {
      if (event.event.target.checked) {
        //check for queue 
        if (marketBase.DeleteStatus == 'Deleted') {
          this.alertService.alert("Marketbase <b>" + marketBase.MarketBaseName + "</b> will be deleted in overnight process. Please select another marketbase.",
            () => {
              this.listOfMarketBases.forEach((recod: ClientMarketBase) => {
                if (recod.MarketBaseId == event.record.MarketBaseId) {
                  recod.UsedMarketBaseStatus = 'false';
                }
              });
            });
          return false;
        }

        //to push item into marketDefinitionBaseMap
        this.marketDefinitionBaseMap.push({ Id: 10, Name: marketBase.MarketBaseName, MarketBaseId: marketBase.Id, MarketBase: null, Filters: [], BaseFilters: this.fnFindMarketbaseFilters(marketBase.Id) || [], DataRefreshType: "dynamic" })
        console.log(this.marketDefinitionBaseMap);
        this.listOfMarketBases.forEach((recod: ClientMarketBase) => { // to remove from marketbase list
          if (recod.MarketBaseId == event.record.MarketBaseId) {
            recod.UsedMarketBaseStatus = 'true';
            setTimeout(() => {
              //this.fnDefaultSelectMarketBase(recod.MarketBaseId);
            }, 500);

          }
        });

        //to add in marketDefinitionBaseMap
        this.marketDefinitionBaseMap.forEach((record: MarketDefinitionBaseMap) => {
          if (record.MarketBaseId == marketBase.Id) {
            record.CurrentStatus = 'New';
            record.Selected = true;
          }
        });

      } else {
        //remove from the marketDefinitionBaseMap
        this.marketDefinitionBaseMap.splice(this.marketDefinitionBaseMap.indexOf(this.marketDefinitionBaseMap.filter((rec: any) => { if (rec.MarketBaseId == marketBase.Id) { return true } else { return false } })[0]), 1);

        this.listOfMarketBases.forEach((recod: ClientMarketBase) => {
          if (recod.MarketBaseId == event.record.MarketBaseId) {
            recod.UsedMarketBaseStatus = 'false';
          }
        });
      }
      //this.fnMarketSetupChangeDetection();

    } else if (event.cellName == "p-table-select-all") {
      if (event.event.target.checked) {
        this.listOfMarketBases.forEach((recod: ClientMarketBase) => {
          if (recod.UsedMarketBaseStatus == 'false') {
            if (recod.DeleteStatus != 'Deleted') {
              this.marketDefinitionBaseMap.push({ Id: 10, Name: recod.MarketBaseName, MarketBaseId: recod.Id, MarketBase: null, Filters: [], DataRefreshType: "dynamic" })
              recod.UsedMarketBaseStatus = 'true';
            }
          }

          setTimeout(() => {
            //this.fnDefaultSelectMarketBase(recod.MarketBaseId);
          }, 500);
        });
      } else {
        this.listOfMarketBases.forEach((recod: ClientMarketBase) => {
          recod.UsedMarketBaseStatus = 'false';
          this.marketDefinitionBaseMap = [];
        });
      }

      //this.fnMarketSetupChangeDetection();
    }

    this.fnCheckChangeDetectionInMarketSetup()
  }

  //to find marketbase filters
  fnFindMarketbaseFilters(marketbaseId: number) {
    let marketbaseFilter = [];
    this.listOfAllMarketBases.forEach((rec: any) => {
      if (marketbaseId == rec.MarketBaseId) {
        marketbaseFilter.push({ Id: 1, Name: rec.BaseFilterName, Criteria: rec.BaseFilterCriteria, Values: rec.BaseFilterValues, IsEnabled: rec.BaseFilterIsEnabled, MarketBaseId: rec.MarketBaseId, IsRestricted: rec.IsRestricted, IsBaseFilterType: rec.IsBaseFilterType });
      }

    });

    return marketbaseFilter
  }

  //to change static dynamic type
  fnChangeDataRefreshType(type: string, data: any) {
    if (type == 'dynamic') {
      this.marketDefinitionBaseMap.forEach((rec: any) => {
        if (rec.MarketBaseId == data.MarketBaseId) {
          rec.DataRefreshType = 'dynamic';
        }
      });
    } else {
      this.marketDefinitionBaseMap.forEach((rec: any) => {
        if (rec.MarketBaseId == data.MarketBaseId) {
          rec.DataRefreshType = 'static';
        }
      });
    }

    console.log(this.marketDefinitionBaseMap);
    this.fnCheckChangeDetectionInMarketSetup();
  }

  fnActivateMarketBase(data: MarketDefinitionBaseMap, event: any) {
    if (event.target.checked) {
      this.marketDefinitionBaseMap.forEach((record: MarketDefinitionBaseMap) => {
        if (record.MarketBaseId == data.MarketBaseId) {
          record.Selected = true;
        }
      });
    }
    else {
      this.marketDefinitionBaseMap.forEach((record: MarketDefinitionBaseMap) => {
        if (record.MarketBaseId == data.MarketBaseId) {
          record.Selected = false;
          record.DataRefreshType = "dynamic";
          record.Filters = [];
        }
      });
    }

    this.fnCheckChangeDetectionInMarketSetup();
  }

  async fnGeneratePacks() {
    let newAddedMarketbaseMap = [];
    let modifiedMarketbaseMap = [];
    this.alertService.fnLoading(true);
    if (this.IsActiveMarketBaseSetup) {
      if (this.marketbaseTitle == "") {
        this.alertService.fnLoading(false);
        this.alertService.alert("Market definition name is required");
        return;
      } else if (this.marketbaseTitle.length >= 26) {
        this.alertService.fnLoading(false);
        this.alertService.alert("This label exceeds the 25 character limitation. Please review.");
        return;
      } else if (this.marketbaseTitle.match(/^[-/+()&/,\w\s]*$/) == null) {
        this.alertService.fnLoading(false);
        this.alertService.alert("Only alphanumeric and special characters +,-,_,&,/,(,) are allowed. Please review.", );
        jQuery("#newsTitle").focus();
        return;
      } else {
        let breakExecution;
        if (this.selectedMarketDefId > 0) {
          try {
            await this.groupingService.checkEditForMarketDefDuplication(this.selectedClientId, this.selectedMarketDefId, this.marketbaseTitle).then(result => { breakExecution = result; });
          } catch (ex) {
            this.alertService.fnLoading(false);
          }
        } else {
          try {
            await this.groupingService.checkCreateMarketDefDuplication(this.selectedClientId, this.marketbaseTitle.trim()).then(result => { breakExecution = result; });
          } catch (ex) {
            this.alertService.fnLoading(false);
            console.log("error new entry");
          }
        }

        if (breakExecution == 'false') {
          this.alertService.fnLoading(false);
          this.alertService.alert("Market definition <b>" + this.marketbaseTitle.trim() + "</b> already exists. Please try again with a different label. ");
          jQuery("#newsTitle").focus();
          return;
        }
      }

      // asign market name changes
      this.marketDefinition.Name = this.marketbaseTitle;
      GroupingService.marketDefinition.Name = this.marketbaseTitle;
      /*****************************Find out change history **********************************************/
      if (this.selectedMarketDefId > 0) {
        newAddedMarketbaseMap = this.marketDefinitionBaseMap.filter((rec: MarketDefinitionBaseMap) => { if (rec.CurrentStatus == 'New') { return true } }) || [];
        modifiedMarketbaseMap = this.marketDefinitionBaseMap.filter((rec: MarketDefinitionBaseMap) => { if (rec.CurrentStatus == 'Modified') { return true } }) || [];

      }

      console.log(this.marketDefinitionBaseMap);
      /********************************************************************/
      // if (newAddedMarketbaseMap.length > 0 && modifiedMarketbaseMap.length == 0) {
      //   this.fnGeneratePacksForAddedMarketbase(newAddedMarketbaseMap);
      // }

      //no change and packs avaialbe
      if (JSON.stringify(this.marketDefinitionBaseMap) == JSON.stringify(GroupingService.marketDefinitionBaseMap) && GroupingService.dynamicPacksList.length > 0) {
        console.log("no packs generation process");
        this.marketDefinition.Name = this.marketbaseTitle;
        GroupingService.marketDefinition.Name = this.marketbaseTitle;
        this.fnSetFlagToGoPacksComponent();
      }
      //to check if any change
      else if (this.selectedMarketDefId > 0 && JSON.stringify(this.marketDefinitionBaseMap) == JSON.stringify(GroupingService.marketDefinitionBaseMap)) {
        console.log("pull packs from DB");
        await this.fnGetMarketDefinitionPacks();
        GroupingService.dynamicPacksList = JSON.parse(JSON.stringify(this.dynamicPacks));
        console.log("check GroupingService.dynamicPacksList 1");
        console.log(GroupingService.dynamicPacksList);
        this.fnSetFlagToGoPacksComponent();
      } else {
        //to generate new packs
        this.alertService.fnLoading(false);
        await this.alertService.confirmAsync("Changes have been made to the Market Definition. Would you like to apply these?",
          async () => {
            this.dynamicPacks = [];
            this.staticPacks = [];
            this.alertService.fnLoading(true);
            await this.subscribeToAvailablePackList();
            GroupingService.marketDefinitionBaseMap = JSON.parse(JSON.stringify(this.marketDefinitionBaseMap));
            this.savedMarketDefinitionBaseMap = JSON.parse(JSON.stringify(this.marketDefinitionBaseMap));
            this.marketSetupChangedDetected = false;
            GroupingService.marketDefinition = { Id: this.selectedMarketDefId, Name: this.marketbaseTitle, ClientId: this.selectedClientId, Description: '', MarketDefinitionBaseMaps: this.marketDefinitionBaseMap, MarketDefinitionPacks: null, GuiId: "" };
            this.marketDefinition = { Id: this.selectedMarketDefId, Name: this.marketbaseTitle, ClientId: this.selectedClientId, Description: '', MarketDefinitionBaseMaps: this.marketDefinitionBaseMap, MarketDefinitionPacks: null, GuiId: "" };
            if (this.dynamicPacks.length == 0 && this.staticPacks.length == 0) {
              this.alertService.fnLoading(false);
              this.alertService.alert("There are no packs available in the market definition content. Please review.");
              console.log("check GroupingService.dynamicPacksList 2");
              console.log(GroupingService.dynamicPacksList);
              return false;
            } else {
              GroupingService.dynamicPacksList = JSON.parse(JSON.stringify(this.dynamicPacks));
              this.fnSetFlagToGoPacksComponent();
            }
          },
          () => {
            this.alertService.fnLoading(false);
            return false;
          });

      }
    } else if (this.IsActivePacks) {
      this.IsActiveGrouping = true;
      this.IsActivePacks = false;
      this.IsActiveMarketBaseSetup = false;
    }
  }

  async fnGeneratePacksForAddedMarketbase(marketDefinitionBaseMap: any[]) {
    let staticFinalQuery = "";
    let dynamicFinalQuery = "";
    for (let i = 0; i < marketDefinitionBaseMap.length; i++) {
      if (marketDefinitionBaseMap[i].DataRefreshType == 'static') {
        let staticQuery = this._buildQuery(marketDefinitionBaseMap[i]);
        if (staticFinalQuery == '')
          staticFinalQuery = staticQuery;
        else {
          staticFinalQuery = staticFinalQuery + ' UNION ' + staticQuery;
          //console.log('....staticFinalQuery:', staticFinalQuery);

        }
      }

      else if (marketDefinitionBaseMap[i].DataRefreshType == 'dynamic') {
        let dynamicQuery = this._buildQuery(marketDefinitionBaseMap[i]);
        if (dynamicFinalQuery == '')
          dynamicFinalQuery = dynamicQuery;

        else {
          dynamicFinalQuery = dynamicFinalQuery + ' UNION ' + dynamicQuery;
        }
      }
    }

    //add a service .....    
    //Params are : staticFinalQuery,dynamicFinalQuery,marketdefId
  }

  async fnSaveMarketName() {
    if (this.marketbaseTitle == "") {
      this.alertService.fnLoading(false);
      this.alertService.alert("Market definition name is required");
      return false;
    } else if (this.marketbaseTitle.match(/^[-/+()&/,\w\s]*$/) == null) {
      this.alertService.fnLoading(false);
      this.alertService.alert("Only alphanumeric and special characters +,-,_,&,/,(,) are allowed. Please review.");
      jQuery("#newsTitle").focus();
      return;
    } else {
      let breakExecution;
      if (this.selectedMarketDefId > 0) {
        try {
          await this.groupingService.checkEditForMarketDefDuplication(this.selectedClientId, this.selectedMarketDefId, this.marketbaseTitle).then(result => { breakExecution = result; });
        } catch (ex) {
          this.alertService.fnLoading(false);
        }
      } else {
        try {
          await this.groupingService.checkCreateMarketDefDuplication(this.selectedClientId, this.marketbaseTitle.trim()).then(result => { breakExecution = result; });
        } catch (ex) {
          this.alertService.fnLoading(false);
          console.log("error new entry");
        }
      }

      if (breakExecution == 'false') {
        this.alertService.fnLoading(false);
        this.alertService.alert("Market definition <b>" + this.marketbaseTitle.trim() + "</b> already exists. Please try again with a different label. ");
        jQuery("#newsTitle").focus();
        return;
      }
    }

    //to save name
    await this.alertService.confirmAsync("Do you want to update market definition name?",
      async () => {
        this.alertService.fnLoading(true);
        await this.groupingService.updateMarketDefinitionName(this.selectedClientId, this.selectedMarketDefId, this.marketbaseTitle.trim())
          .then(result => {
            this.alertService.fnLoading(false);
            this.isEnabledSaveBtn = false;
            GroupingService.marketDefinition.Name = this.marketbaseTitle;
            this.marketDefinition.Name = this.marketbaseTitle;
            this.marketSetupChangedDetected = false;
            this.alertService.alert("Market definition name has been updated successfully.");
          }).catch(ex => {
            console.log("fail");
            this.alertService.fnLoading(false);
          });

      },
      () => { }
    );

  }

  fnCallBackPackComponent(event: any) {
    if (event.marketDefId > 0 && this.isEditMarketDef == false) {
      this.isEditMarketDef = true;
      this.selectedMarketDefId = event.marketDefId;
    }
    this.marketDefinitionBaseMap = JSON.parse(JSON.stringify(GroupingService.marketDefinitionBaseMap));
    this.savedMarketDefinitionBaseMap = JSON.parse(JSON.stringify(GroupingService.marketDefinitionBaseMap));
    this.IsActivePacks = false;
    this.IsActiveMarketBaseSetup = true;
  }

  fnSetFlagToGoPacksComponent() {
    console.log("Market definition:");
    console.log(GroupingService.marketDefinition);
    this.alertService.fnLoading(false);
    this.IsActivePacks = true;
    this.IsActiveMarketBaseSetup = false;
    this.IsActiveGrouping = false;
  }
  //to get packs from DB
  async fnGetMarketDefinitionPacks() {
    await this.groupingService.fnGetMarketDefinitionPacks(this.selectedClientId, this.selectedMarketDefId)
      .then(result => {
        this.dynamicPacks = result.filter((rec: any) => rec.Alignment == "dynamic-right" || rec.Alignment == null) || [];
        this.staticPacks = result.filter((rec: any) => rec.Alignment == "static-left") || [];
      })
      .catch((err: any) => {
        console.log(err);
        this.alertService.fnLoading(false);
        //this.mmErrModal.show(); 
        if (err.status == 0) {
          this.alertService.alert("System has failed to connect with server due to network problem.");
        } else {
          this.alertService.alert(err.Message);
        }
      });
  }
  async fnSaveGrouping() {
    //this.groupingDetails.fnSaveMarketGroupView();
    this.marketbasePacks.fnSaveMarketGroupDetails();

  }

  setSelectedMarketBase(marketbaseMap: MarketDefinitionBaseMap) {
    console.log(marketbaseMap);
    let marketBaseName = marketbaseMap.Name;
    this.selectedMarketbaseMap = marketbaseMap;
    this.atcDependencyArray = []; this.necDependencyArray = [];
    this.filtersApplied = [];
    this.includeExcludeArray = [{
      checkboxExcludeATC1: true, checkboxExcludeATC2: true, checkboxExcludeATC3: true, checkboxExcludeATC4: true, checkboxExcludeNEC1: true, checkboxExcludeNEC2: true, checkboxExcludeNEC3: true, checkboxExcludeNEC4: true,
      checkboxExcludeMFR: true, checkboxExcludePRODUCT: true, checkboxExcludeMOLECULE: true, checkboxExcludePOISON: true, checkboxExcludeFORM: true
    }];

    this.selectedMarketBaseForAutoCom = this.listOfMarketBases.filter((record: ClientMarketBase, index: any) => {
      if (record.MarketBaseId == marketbaseMap.MarketBaseId) {
        return true;
      } else {
        return false;
      }
    });

    this.atc1List = []; this.atc2List = []; this.atc3List = []; this.atc4List = []; this.nec1List = []; this.nec2List = []; this.nec3List = []; this.nec4List = []; this.moleculeList = []; this.manufacturerList = []; this.productList = []; this.poisonScheduleList = [];
    jQuery("div.packSearchModalPanel .selected-checkbox input[type='checkbox']").prop("checked", false);
    if (this.selectedMarketbaseMap.Filters.length > 0) {
      this.selectedMarketbaseMap.Filters.forEach((rec: any) => {
        if (rec.Criteria.toLowerCase() == 'atc 1') {
          this.atc1List = this.fnCSVFromArray(rec.Values, 'Atc1');
          this.filtersApplied = this.filtersApplied.concat(this.atc1List)
          this.includeExcludeArray[0].checkboxExcludeATC1 = rec.IsEnabled;
          jQuery(".checkbox-atc1").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'atc 2') {
          this.atc2List = this.fnCSVFromArray(rec.Values, 'Atc2');
          this.filtersApplied = this.filtersApplied.concat(this.atc2List);
          this.includeExcludeArray[0].checkboxExcludeATC2 = rec.IsEnabled;
          jQuery(".checkbox-atc2").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'atc 3') {
          this.atc3List = this.fnCSVFromArray(rec.Values, 'Atc3');
          this.filtersApplied = this.filtersApplied.concat(this.atc3List)
          this.includeExcludeArray[0].checkboxExcludeATC3 = rec.IsEnabled;
          jQuery(".checkbox-atc3").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'atc 4') {
          this.atc4List = this.fnCSVFromArray(rec.Values, 'Atc4');
          this.filtersApplied = this.filtersApplied.concat(this.atc4List);
          this.includeExcludeArray[0].checkboxExcludeATC4 = rec.IsEnabled;
          jQuery(".checkbox-atc4").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'nec 1') {
          this.nec1List = this.fnCSVFromArray(rec.Values, 'Nec1');
          this.filtersApplied = this.filtersApplied.concat(this.nec1List);
          this.includeExcludeArray[0].checkboxExcludeNEC1 = rec.IsEnabled;
          jQuery(".checkbox-nec1").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'nec 2') {
          this.nec2List = this.fnCSVFromArray(rec.Values, 'Nec2');
          this.filtersApplied = this.filtersApplied.concat(this.nec2List);
          this.includeExcludeArray[0].checkboxExcludeNEC2 = rec.IsEnabled;
          jQuery(".checkbox-nec2").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'nec 3') {
          this.nec3List = this.fnCSVFromArray(rec.Values, 'Nec3');
          this.filtersApplied = this.filtersApplied.concat(this.nec3List);
          this.includeExcludeArray[0].checkboxExcludeNEC3 = rec.IsEnabled;
          jQuery(".checkbox-nec3").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'nec 4') {
          this.nec4List = this.fnCSVFromArray(rec.Values, 'Nec4');
          this.filtersApplied = this.filtersApplied.concat(this.nec4List);
          this.includeExcludeArray[0].checkboxExcludeNEC4 = rec.IsEnabled;
          jQuery(".checkbox-nec4").prop("checked", true);
        }
        else if (rec.Criteria.toLowerCase() == 'product') {
          this.productList = this.fnCSVFromArray(rec.Values, 'Product');
          this.filtersApplied = this.filtersApplied.concat(this.productList);
          this.includeExcludeArray[0].checkboxExcludePRODUCT = rec.IsEnabled;
          jQuery(".checkbox-product").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'molecule') {
          this.moleculeList = this.fnCSVFromArray(rec.Values, 'Molecule');
          this.filtersApplied = this.filtersApplied.concat(this.moleculeList);
          this.includeExcludeArray[0].checkboxExcludeMOLECULE = rec.IsEnabled;
          jQuery(".checkbox-molecule").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'mfr') {
          this.manufacturerList = this.fnCSVFromArray(rec.Values, 'mfr');
          this.filtersApplied = this.filtersApplied.concat(this.manufacturerList);
          this.includeExcludeArray[0].checkboxExcludeMFR = rec.IsEnabled;
          jQuery(".checkbox-mfr").prop("checked", true);
        } else if (rec.Criteria.toLowerCase() == 'flagging') {
          jQuery("#v11").val(rec.Values.replace(/'/g, '')).change();
          jQuery(".checkbox-flagging").prop("checked", true);
        }
        else if (rec.Criteria.toLowerCase() == 'branding') {
          jQuery("#v12").val(rec.Values.replace(/'/g, '')).change();
          jQuery(".checkbox-branding").prop("checked", true);
        }
        else if (rec.Criteria.toLowerCase() == 'poisonschedule') {
          this.poisonScheduleList = this.fnCSVFromArray(rec.Values, 'poisonschedule');
          this.filtersApplied = this.filtersApplied.concat(this.poisonScheduleList);
          this.includeExcludeArray[0].checkboxExcludePOISON = rec.IsEnabled;
          jQuery(".checkbox-poisonSchedule").prop("checked", true);
        }
        else if (rec.Criteria.toLowerCase() == 'form') {
          this.poisonScheduleList = this.fnCSVFromArray(rec.Values, 'form');
          this.filtersApplied = this.filtersApplied.concat(this.poisonScheduleList);
          this.includeExcludeArray[0].checkboxExcludePOISON = rec.IsEnabled;
          jQuery(".checkbox-form").prop("checked", true);
        }
      });
    }
    //to remove all filter
    if (this.filtersApplied.length == 0) {
      this.filtersApplied.push({ Code: "", FilterName: "" });
    }
    this.atcDependencyArray = this.atc1List.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || [];
    this.necDependencyArray = this.nec1List.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || [];

    //to remove all disabled 
    jQuery(".autocom-content").removeClass("disabled-content");
    jQuery(".autocom-content .filter-container").removeClass("disabled");
    if (isNaN(+marketBaseName[3]) == false) {//to disabled
      if (marketBaseName[0].toLowerCase() == "a") {
        for (var i = Number(marketBaseName[3]); i >= 0; i--) {
          jQuery(".autocom-content-Atc" + i).addClass("disabled-content");
          jQuery(".autocom-content-Atc" + i + " .filter-container").first().addClass("disabled");
        }
      } else if (marketBaseName[0].toLowerCase() == "n") {
        for (var i = Number(marketBaseName[3]); i >= 0; i--) {
          jQuery(".autocom-content-Nec" + i).addClass("disabled-content");
          jQuery(".autocom-content-Nec" + i + " .filter-container").first().addClass("disabled-content");
        }
      }

    }
    jQuery("#marketbaseMapfFlterModal").modal("show");

  }

  fnMarketNameChangeDetection() {
    if (this.isEditMarketDef == true) {
      if (this.marketbaseTitle != GroupingService.marketDefinition.Name) {
        this.isEnabledSaveBtn = true;
      } else {
        this.isEnabledSaveBtn = false;
      }
    } else {
      this.isEnabledSaveBtn = false;
    }
  }

  fnGoToBackScreen() {
    if (this.IsActivePacks) {
      this.IsActivePacks = false;
      this.IsActiveMarketBaseSetup = true;
      this.IsActiveGrouping = false;
    } else if (this.IsActiveGrouping) {
      this.IsActiveGrouping = false;
      this.IsActivePacks = true;
      this.IsActiveMarketBaseSetup = false;
    }
  }



  async subscribeToAvailablePackList() {
    var ADDfilterCondition = '';
    var BASEfilterCondition = '';
    var query = '';
    var finalQuery = '';

    var staticQuery = '';
    var dynamicQuery = '';
    var staticFinalQuery = '';
    var dynamicFinalQuery = '';
    for (var i = 0; i < this.marketDefinitionBaseMap.length; i++) {
      //var marketdefbasemap = this.client_packList.MarketDefinitions[i].MarketDefinitionBaseMaps;
      // console.log('marketdefbasemap.length=', marketdefbasemap.length);
      //  for (var j = 0; j < marketdefbasemap.length; j++) {
      if (this.marketDefinitionBaseMap[i].DataRefreshType == 'static') {
        staticQuery = this._buildQuery(this.marketDefinitionBaseMap[i]);
        if (staticFinalQuery == '')
          staticFinalQuery = staticQuery;
        else {
          staticFinalQuery = staticFinalQuery + ' UNION ' + staticQuery;
          //console.log('....staticFinalQuery:', staticFinalQuery);

        }
      }

      else if (this.marketDefinitionBaseMap[i].DataRefreshType == 'dynamic') {
        dynamicQuery = this._buildQuery(this.marketDefinitionBaseMap[i]);
        if (dynamicFinalQuery == '')
          dynamicFinalQuery = dynamicQuery;

        else {
          dynamicFinalQuery = dynamicFinalQuery + ' UNION ' + dynamicQuery;
          //console.log('....dynamicFinalQuery:', dynamicFinalQuery);
        }
      }
      // }

      // this.clientService.fnSetLoadingAction(false);

    }


    //this.clientService.getAvailablePackList(finalQuery);
    var initialDynamicQuery: string = '';
    if (dynamicFinalQuery != '') {
      initialDynamicQuery = dynamicFinalQuery;
      dynamicFinalQuery = 'SELECT ROW_NUMBER() OVER(ORDER BY PACK)+5000 as \'Id\', * FROM ( ' + dynamicFinalQuery + ' )D';
      dynamicFinalQuery = this._buildQueryForConcatenation(dynamicFinalQuery, 'dynamic');
      dynamicFinalQuery = this._deleteTemporaryTables() + dynamicFinalQuery;
      console.log('....full dynamic finalQuery:', dynamicFinalQuery);
    }

    if (staticFinalQuery != '') {
      if (dynamicFinalQuery != '') {
        staticFinalQuery = staticFinalQuery + ' AND PFC not in (select distinct PFC from (' + initialDynamicQuery + ')PFC)\n';
      }
      staticFinalQuery = 'SELECT ROW_NUMBER() OVER(ORDER BY PACK)+1000 as \'Id\', * FROM ( ' + staticFinalQuery + ' )S';
      staticFinalQuery = this._buildQueryForConcatenation(staticFinalQuery, 'static');
      staticFinalQuery = this._deleteTemporaryTables() + staticFinalQuery;
      console.log('....full staticFinalQuery:', staticFinalQuery);
    }

    await this.groupingService.getDynamicAvailablePackList(dynamicFinalQuery, this.selectedClientId).then(result => { this.dynamicPacks = result || []; console.log(result) }).catch((err: any) => { this.alertService.fnLoading(false); });
    await this.groupingService.getStaticAvailablePackList(staticFinalQuery, this.selectedClientId).then(data => { this.staticPacks = data || []; console.log(data) }).catch((err: any) => { this.alertService.fnLoading(false); });
    //this.alertService.fnLoading(false);
  }


  public tempFiltersForMolecule = [];

  private _buildQuery(marketDefinitionBaseMap: any): string {
    var addfilter = marketDefinitionBaseMap.Filters || [];
    var baseName = marketDefinitionBaseMap.Name;
    var baseId = marketDefinitionBaseMap.MarketBaseId;
    var basefilter = marketDefinitionBaseMap.BaseFilters || [];
    let DataRefreshType = marketDefinitionBaseMap.DataRefreshType;
    var logicalORflag = false;
    var restrictedValue = false;
    let BASEfilterCondition = "";
    let ADDfilterCondition = "";
    let query = "";
    //console.log('base filter: ', basefilter);
    //console.log('addfilter.length=', addfilter.length);
    if (addfilter.length > 0) {
      for (var k = 0; k < addfilter.length; k++) {
        var criteria = '';
        if (addfilter[k].Criteria == 'MFR' || addfilter[k].Criteria == 'Manufacturer')
          criteria = 'Org_Long_Name';
        else if (addfilter[k].Criteria == 'Molecule') {
          criteria = 'Description';
        }
        else if (addfilter[k].Criteria == 'Flagging')
          criteria = 'FRM_Flgs5_Desc';
        else if (addfilter[k].Criteria == 'Branding')
          criteria = 'Frm_Flgs3_Desc';
        else if (addfilter[k].Criteria == 'Product')
          criteria = 'ProductName';
        else if (addfilter[k].Criteria == 'PoisonSchedule')
          criteria = 'Poison_Schedule';
        else if (addfilter[k].Criteria == 'Form')
          criteria = 'Form_Desc_Abbr';

        if (criteria != '') {
          var values = addfilter[k].Values;
          console.log('add criteria=', criteria);
          console.log('add filter values=', values);
          //values = "( '" + values.replace(",", "' , '") + "' )";

          console.log('add values filter:', values);
          if (criteria != 'Description') {
            values = "( " + values + " )";
            //ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' and ';
            if (addfilter[k].IsEnabled) {
              ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
            } else {
              ADDfilterCondition = ADDfilterCondition + criteria + ' not in ' + values + ' OR ';
            }

          }
          else if (values != "") {
            let tempFiltersForMolecule = values.replace(/',/g, "'|");
            if (tempFiltersForMolecule.indexOf('|') > 0) {// for multiple molecule
              var tempArr: any[] = tempFiltersForMolecule.split('|');
              tempArr.forEach((item: any) => {
                item = "(\'%" + item.replace(/'/g, '') + "%\')";
                //ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + item + ' or ';
                if (addfilter[k].IsEnabled) {
                  ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + item + ' OR ';
                } else {
                  ADDfilterCondition = ADDfilterCondition + criteria + ' not like ' + item + ' OR ';
                }
              });

            } else {
              values = "(\'%" + values.replace(/'/g, '') + "%\')";
              //ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + values + ' or ';
              if (addfilter[k].IsEnabled) {
                ADDfilterCondition = ADDfilterCondition + criteria + ' like ' + values + ' OR ';
              } else {
                ADDfilterCondition = ADDfilterCondition + criteria + ' not like ' + values + ' OR ';
              }
            }
            ADDfilterCondition = '( ' + ADDfilterCondition.substring(0, ADDfilterCondition.length - 4) + ' )';
            ADDfilterCondition += ' and ';

          }
        }

      }
      var first = true;
      var second = true;
      for (var k = 0; k < addfilter.length; k++) {
        var criteria = '';
        if (addfilter[k].Criteria == 'ATC 1' || addfilter[k].Criteria == 'ATC1') {
          if (first) { first = false; criteria = '#ATC1_Code'; }
          else criteria = 'ATC1_Code';
        }

        else if (addfilter[k].Criteria == 'ATC 2' || addfilter[k].Criteria == 'ATC2') {
          if (first) { first = false; criteria = '#ATC2_Code'; }
          else criteria = 'ATC2_Code';
        }
        else if (addfilter[k].Criteria == 'ATC 3' || addfilter[k].Criteria == 'ATC3') {
          if (first) { first = false; criteria = '#ATC3_Code'; }
          else criteria = 'ATC3_Code';
        }
        else if (addfilter[k].Criteria == 'ATC 4' || addfilter[k].Criteria == 'ATC4') {
          if (first) { first = false; criteria = '#ATC4_Code'; }
          else criteria = 'ATC4_Code';
        }

        if (criteria != '') {
          var values = addfilter[k].Values;
          console.log('add criteria=', criteria);
          console.log('add filter values=', values);
          // values = "( '" + values.replace(",", "' , '") + "' )";
          values = "( " + values + " )";
          console.log('add values filter:', values);
          //ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
          if (addfilter[k].IsEnabled) {
            ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
          } else {
            ADDfilterCondition = ADDfilterCondition + criteria + ' not in ' + values + ' OR ';
          }
          logicalORflag = true;
        }

      }

      if (logicalORflag) {
        ADDfilterCondition = ADDfilterCondition + '@ ) and ';
        ADDfilterCondition = ADDfilterCondition.replace("OR @", " ");
        ADDfilterCondition = ADDfilterCondition.replace("#", " ( ");
        logicalORflag = false;
      }


      for (var m = 0; m < addfilter.length; m++) {
        var criteria = '';
        if (addfilter[m].Criteria == 'NEC1' || addfilter[m].Criteria == 'NEC 1') {
          if (second) { second = false; criteria = '#NEC1_Code'; console.log("criteria NEC1" + criteria); }
          else criteria = 'NEC1_Code';
        }
        else if (addfilter[m].Criteria == 'NEC2' || addfilter[m].Criteria == 'NEC 2') {
          if (second) { second = false; criteria = '#NEC2_Code'; }
          else criteria = 'NEC2_Code';
        }
        else if (addfilter[m].Criteria == 'NEC3' || addfilter[m].Criteria == 'NEC 3') {
          if (second) { second = false; criteria = '#NEC3_Code'; }
          else criteria = 'NEC3_Code';
        }
        else if (addfilter[m].Criteria == 'NEC4' || addfilter[m].Criteria == 'NEC 4') {
          if (second) { second = false; criteria = '#NEC4_Code'; }
          else criteria = 'NEC4_Code';
        }

        if (criteria != '') {
          var values = addfilter[m].Values;
          console.log('add criteria=', criteria);
          console.log('add filter values=', values);
          // values = "( '" + values.replace(",", "' , '") + "' )";
          values = "( " + values + " )";
          console.log('add values filter:', values);
          //ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
          if (addfilter[m].IsEnabled) {
            ADDfilterCondition = ADDfilterCondition + criteria + ' in ' + values + ' OR ';
          } else {
            ADDfilterCondition = ADDfilterCondition + criteria + ' not in ' + values + ' OR ';
          }


          console.log(addfilter[m].IsEnabled);

          logicalORflag = true;
        }


      }

      if (logicalORflag) {
        ADDfilterCondition = ADDfilterCondition + '@ )';
        ADDfilterCondition = ADDfilterCondition.replace("OR @", " ");
        console.log("ADDfilterCondition..." + ADDfilterCondition);
        ADDfilterCondition = ADDfilterCondition.replace("#", " ( ");
        console.log("ADDfilterCondition$$..." + ADDfilterCondition);
      }
      else {
        ADDfilterCondition = ADDfilterCondition + '@';
        ADDfilterCondition = ADDfilterCondition.replace("and @", " ");
        ADDfilterCondition = ADDfilterCondition.replace("OR @", " ");

      }


      console.log('ADDfilterCondition:', ADDfilterCondition);
    }


    // for non restrcit 
    console.log('non restrict basefilter.length=', basefilter.length);
    for (var m = 0; m < basefilter.length; m++) {
      var criteria1 = '';
      if ((basefilter[m].Criteria == 'ATC 1' || basefilter[m].Criteria == 'ATC1') && !basefilter[m].IsRestricted)
        criteria1 = 'ATC1_Code';
      else if ((basefilter[m].Criteria == 'ATC 2' || basefilter[m].Criteria == 'ATC2') && !basefilter[m].IsRestricted)
        criteria1 = 'ATC2_Code';
      else if ((basefilter[m].Criteria == 'ATC 3' || basefilter[m].Criteria == 'ATC3') && !basefilter[m].IsRestricted)
        criteria1 = 'ATC3_Code';
      else if ((basefilter[m].Criteria == 'ATC 4' || basefilter[m].Criteria == 'ATC4') && !basefilter[m].IsRestricted)
        criteria1 = 'ATC4_Code';
      else if ((basefilter[m].Criteria == 'MFR' || basefilter[m].Criteria == 'Manufacturer') && !basefilter[m].IsRestricted)
        criteria1 = 'Org_Long_Name';
      else if ((basefilter[m].Criteria == 'NEC1' || basefilter[m].Criteria == 'NEC 1') && !basefilter[m].IsRestricted)
        criteria1 = 'NEC1_Code';
      else if ((basefilter[m].Criteria == 'NEC2' || basefilter[m].Criteria == 'NEC 2') && !basefilter[m].IsRestricted)
        criteria1 = 'NEC2_Code';
      else if ((basefilter[m].Criteria == 'NEC3' || basefilter[m].Criteria == 'NEC 3') && !basefilter[m].IsRestricted)
        criteria1 = 'NEC3_Code';
      else if ((basefilter[m].Criteria == 'NEC4' || basefilter[m].Criteria == 'NEC 4') && !basefilter[m].IsRestricted)
        criteria1 = 'NEC4_Code';
      else if ((basefilter[m].Criteria == 'Molecule') && !basefilter[m].IsRestricted) {
        criteria1 = 'Description';
      }
      else if ((basefilter[m].Criteria == 'Flagging') && !basefilter[m].IsRestricted)
        criteria1 = 'FRM_Flgs5_Desc';
      else if ((basefilter[m].Criteria == 'Branding') && !basefilter[m].IsRestricted)
        criteria1 = 'Frm_Flgs3_Desc';
      else if ((basefilter[m].Criteria == 'Product') && !basefilter[m].IsRestricted)
        criteria1 = 'ProductName';
      else if ((basefilter[m].Criteria == 'PACK') && !basefilter[m].IsRestricted)
        criteria1 = 'PFC';
      else if ((basefilter[m].Criteria == 'PoisonSchedule') && !basefilter[m].IsRestricted)
        criteria1 = 'Poison_Schedule';
      else if ((basefilter[m].Criteria == 'Form') && !basefilter[m].IsRestricted)
        criteria1 = 'Form_Desc_Abbr';

      // var criteria1 = basefilter[m].Criteria;
      if (criteria1.length > 0) {
        var values = basefilter[m].Values;
        console.log('basecriteria=', criteria1);
        console.log('basefilter values=', values);
        //values = "( '" + values.replace(",", "' , '") + "' )";
        values = "( " + values + " )";
        console.log('base values filter:', values);
        BASEfilterCondition = BASEfilterCondition + criteria1 + ' in ' + values + ' and ';
      }


    }
    if (BASEfilterCondition.length > 0) {
      BASEfilterCondition = BASEfilterCondition + '@';
      BASEfilterCondition = BASEfilterCondition.replace("and @", " ");
      console.log('filterCondition:', BASEfilterCondition);
    }
    BASEfilterCondition = BASEfilterCondition + ' and#';
    //for restrict check
    console.log('restrict basefilter.length=', basefilter.length);
    for (var m = 0; m < basefilter.length; m++) {
      var criteria1 = '';
      if ((basefilter[m].Criteria == 'ATC 1' || basefilter[m].Criteria == 'ATC1') && basefilter[m].IsRestricted)
        criteria1 = 'ATC1_Code';
      else if ((basefilter[m].Criteria == 'ATC 2' || basefilter[m].Criteria == 'ATC2') && basefilter[m].IsRestricted)
        criteria1 = 'ATC2_Code';
      else if ((basefilter[m].Criteria == 'ATC 3' || basefilter[m].Criteria == 'ATC3') && basefilter[m].IsRestricted)
        criteria1 = 'ATC3_Code';
      else if ((basefilter[m].Criteria == 'ATC 4' || basefilter[m].Criteria == 'ATC4') && basefilter[m].IsRestricted)
        criteria1 = 'ATC4_Code';
      else if ((basefilter[m].Criteria == 'MFR' || basefilter[m].Criteria == 'Manufacturer') && basefilter[m].IsRestricted)
        criteria1 = 'Org_Long_Name';
      else if ((basefilter[m].Criteria == 'NEC1' || basefilter[m].Criteria == 'NEC 1') && basefilter[m].IsRestricted)
        criteria1 = 'NEC1_Code';
      else if ((basefilter[m].Criteria == 'NEC2' || basefilter[m].Criteria == 'NEC 2') && basefilter[m].IsRestricted)
        criteria1 = 'NEC2_Code';
      else if ((basefilter[m].Criteria == 'NEC3' || basefilter[m].Criteria == 'NEC 3') && basefilter[m].IsRestricted)
        criteria1 = 'NEC3_Code';
      else if ((basefilter[m].Criteria == 'NEC4' || basefilter[m].Criteria == 'NEC 4') && basefilter[m].IsRestricted)
        criteria1 = 'NEC4_Code';
      else if ((basefilter[m].Criteria == 'Molecule') && basefilter[m].IsRestricted) {
        criteria1 = 'Description';
      }
      else if ((basefilter[m].Criteria == 'Flagging') && basefilter[m].IsRestricted)
        criteria1 = 'FRM_Flgs5_Desc';
      else if ((basefilter[m].Criteria == 'Branding') && basefilter[m].IsRestricted)
        criteria1 = 'Frm_Flgs3_Desc';
      else if ((basefilter[m].Criteria == 'Product') && basefilter[m].IsRestricted)
        criteria1 = 'ProductName';
      else if ((basefilter[m].Criteria == 'PACK') && basefilter[m].IsRestricted)
        criteria1 = 'PFC';
      else if ((basefilter[m].Criteria == 'PoisonSchedule') && basefilter[m].IsRestricted)
        criteria1 = 'Poison_Schedule';
      else if ((basefilter[m].Criteria == 'Form') && basefilter[m].IsRestricted)
        criteria1 = 'Form_Desc_Abbr';

      // var criteria1 = basefilter[m].Criteria;
      if (criteria1.length > 0) {
        var values = basefilter[m].Values;
        console.log('basecriteria=', criteria1);
        console.log('basefilter values=', values);
        // values = "( '" + values.replace(",", "' , '") + "' )";
        values = "( " + values + " )";
        console.log('base values filter:', values);
        BASEfilterCondition = BASEfilterCondition + criteria1 + ' not in ' + values + ' and ';
        restrictedValue = true;
      }


    }
    if (restrictedValue) {
      BASEfilterCondition = BASEfilterCondition.replace("and#", " and ");
      BASEfilterCondition = BASEfilterCondition + '@';
      BASEfilterCondition = BASEfilterCondition.replace("and @", " ");
      console.log('filterCondition:', BASEfilterCondition);
    }
    else if (!restrictedValue) {
      BASEfilterCondition = BASEfilterCondition.replace("and#", " ");
      console.log('filterCondition:', BASEfilterCondition);
    }

    if (addfilter.length > 0) {
      query = ' SELECT DISTINCT ATC1_CODE as ATC1, ATC2_CODE as ATC2, ATC3_CODE as ATC3, NEC1_CODE as NEC1, NEC2_CODE as NEC2, NEC3_CODE as NEC3, FRM_Flgs5_Desc AS Flagging, FRM_Flgs3_Desc AS Branding, Poison_Schedule AS PoisonSchedule, Form_Desc_Abbr as Form, Pack_Description AS Pack , \'' + baseName + '\' AS MarketBase, \'' + baseId + '\' AS MarketBaseId'
        + ', \'\' AS GroupNumber, \'\' AS GroupName, \'\' AS Factor, PFC,  Org_Long_Name AS Manufacturer, ATC4_Code AS ATC4, NEC4_Code AS NEC4, \'' + DataRefreshType + '\' AS DataRefreshType' + ', ProductName AS Product' + ', dm.Description As Molecule' + ', DIMProduct_Expanded.CHANGE_FLAG AS ChangeFlag'
        + ' from DIMProduct_Expanded left JOIN dbo.DMMoleculeConcat dm ON DIMProduct_Expanded.FCC = dm.FCC ' +
        ' WHERE ' + BASEfilterCondition + ' AND  ' + ADDfilterCondition + ' AND (DIMProduct_Expanded.CHANGE_FLAG IS NULL OR DIMProduct_Expanded.CHANGE_FLAG <> \'D\')';
    }
    else {
      query = ' SELECT DISTINCT ATC1_CODE as ATC1, ATC2_CODE as ATC2, ATC3_CODE as ATC3, NEC1_CODE as NEC1, NEC2_CODE as NEC2, NEC3_CODE as NEC3, FRM_Flgs5_Desc AS Flagging, FRM_Flgs3_Desc AS Branding, Poison_Schedule AS PoisonSchedule, Form_Desc_Abbr as Form, Pack_Description AS Pack , \'' + baseName + '\' AS MarketBase, \'' + baseId + '\' AS MarketBaseId'
        + ', \'\' AS GroupNumber, \'\' AS GroupName, \'\' AS Factor, PFC,  Org_Long_Name AS Manufacturer, ATC4_Code AS ATC4, NEC4_Code AS NEC4, \'' + DataRefreshType + '\' AS DataRefreshType' + ', ProductName AS Product' + ', dm.Description As Molecule' + ', DIMProduct_Expanded.CHANGE_FLAG AS ChangeFlag'
        + ' from DIMProduct_Expanded left JOIN dbo.DMMoleculeConcat dm ON DIMProduct_Expanded.FCC = dm.FCC ' +
        ' WHERE ' + BASEfilterCondition + ' AND (DIMProduct_Expanded.CHANGE_FLAG IS NULL OR DIMProduct_Expanded.CHANGE_FLAG <> \'D\')';
    }
    BASEfilterCondition = '';
    ADDfilterCondition = '';

    console.log('query:', query);
    return query;
  }

  private _deleteTemporaryTables() {
    var statement = 'IF OBJECT_ID(\'tempdb..#td\') IS NOT NULL DROP TABLE #td;\n\nIF OBJECT_ID(\'tempdb..#ts\') IS NOT NULL DROP TABLE #ts;\n\n';
    return statement;
  }

  private _buildQueryForConcatenation(query: string, queryType: string): string {
    var tempTable: string;
    if (queryType == 'static') {
      index = '1000';
      tempTable = '#ts';
    }
    else {
      index = '50000';
      tempTable = '#td';
    }
    var index = (queryType == 'static') ? '1000' : '50000';
    query = 'select ATC1, ATC2, ATC3, NEC1, NEC2, NEC3, Flagging, Branding, PoisonSchedule, Form, Pack, MarketBase, MarketBaseId, GroupNumber, GroupName, Factor, PFC, Manufacturer, ATC4, NEC4, DataRefreshType, Product, Molecule, ChangeFlag into ' + tempTable + ' from(' + query + ')A;\n\n';

    //var moleculeConcatQuery = '';
    //moleculeConcatQuery += 'Select distinct A.Pack, A.GroupNumber, A.GroupName, A.Factor, A.Manufacturer, A.ATC4, A.NEC4, A.DataRefreshType, A.Product, substring(A.Molecule, 2, 5000) Molecule, A.ChangeFlag, A.MarketBaseId, A.MarketBase ';
    //moleculeConcatQuery += 'into #m from (SELECT b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Product, b.ChangeFlag, b.MarketBaseId, b.MarketBase, ';
    //moleculeConcatQuery += '(SELECT \',\' + a.Molecule FROM #t a WHERE a.Pack = b.Pack and a.NEC4 = b.NEC4 and a.Manufacturer = b.Manufacturer and a.MarketBaseId = b.MarketBaseId ';
    //moleculeConcatQuery += 'FOR XML PATH(\'\'))[Molecule] FROM #t b ';
    //moleculeConcatQuery += 'GROUP BY b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Product, b.ChangeFlag, b.MarketBaseId, b.MarketBase)A order by A.Pack;\n\n';

    //query += moleculeConcatQuery;

    var queryToConcat = 'SELECT ROW_NUMBER() OVER(ORDER BY PACK)+' + index + ' as \'Id\', * FROM (  ';
    queryToConcat += 'Select distinct A.ATC1, A.ATC2, A.ATC3, A.NEC1, A.NEC2, A.NEC3, A.Flagging, A.Branding, A.PoisonSchedule, A.Form, A.Pack, A.GroupNumber, A.GroupName, A.Factor, A.PFC, A.Manufacturer, A.ATC4, A.NEC4, A.DataRefreshType, A.Product, A.Molecule, A.ChangeFlag, ';
    queryToConcat += 'substring(A.MarketBase, 2, 200) MarketBase, substring(A.MarketBaseId, 2, 200) MarketBaseId ';
    queryToConcat += 'from ';
    queryToConcat += '( SELECT ';
    queryToConcat += 'b.ATC1, b.ATC2, b.ATC3, b.NEC1, b.NEC2, b.NEC3, b.Flagging, b.Branding, b.PoisonSchedule, b.Form, b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.PFC, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Product, b.Molecule, b.ChangeFlag, ';
    queryToConcat += '(SELECT \',\' + a.MarketBase FROM ' + tempTable + ' a WHERE a.Pack = b.Pack and a.NEC4 = b.NEC4 and a.Manufacturer = b.Manufacturer and a.PFC = b.PFC ';
    queryToConcat += 'FOR XML PATH(\'\'))[MarketBase], ';
    queryToConcat += '(SELECT \',\' + a.MarketBaseId FROM ' + tempTable + ' a ';
    queryToConcat += 'WHERE a.Pack = b.Pack and a.NEC4 = b.NEC4 and a.Manufacturer = b.Manufacturer and a.PFC = b.PFC FOR XML PATH(\'\')) [MarketBaseId] FROM ' + tempTable + ' b ';
    queryToConcat += 'GROUP BY b.ATC1, b.ATC2, b.ATC3, b.NEC1, b.NEC2, b.NEC3, b.Flagging, b.Branding, b.PoisonSchedule, b.Form, b.Pack, b.GroupNumber, b.GroupName, b.Factor, b.PFC, b.Manufacturer, b.ATC4, b.NEC4, b.DataRefreshType, b.Molecule, b.Product, b.ChangeFlag, b.MarketBaseId )A \n\n';
    queryToConcat += ' )X';
    query += queryToConcat;


    console.log('AFTER CONCAT inside function:', query);
    return query;
  }


  //autocomplete selection handlers
  public onATC1Selected(selected: any) { this.atc1List = selected || []; if (this.atc1List.length > 0) { jQuery(".checkbox-atc1").prop("checked", true); } else { jQuery(".checkbox-atc1").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc2List).concat(this.atc3List).concat(this.atc4List) || []; }
  public onATC2Selected(selected: any) { this.atc2List = selected || []; if (this.atc2List.length > 0) { jQuery(".checkbox-atc2").prop("checked", true); } else { jQuery(".checkbox-atc2").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc3List).concat(this.atc4List) || []; }
  public onATC3Selected(selected: any) { this.atc3List = selected || []; if (this.atc3List.length > 0) { jQuery(".checkbox-atc3").prop("checked", true); } else { jQuery(".checkbox-atc3").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc4List) || []; }
  public onATC4Selected(selected: any) { this.atc4List = selected || []; if (this.atc4List.length > 0) { jQuery(".checkbox-atc4").prop("checked", true); } else { jQuery(".checkbox-atc4").prop("checked", false) } this.atcDependencyArray = selected.concat(this.atc1List).concat(this.atc2List).concat(this.atc3List) || []; }
  public onNEC1Selected(selected: any) { this.nec1List = selected || []; if (this.nec1List.length > 0) { jQuery(".checkbox-nec1").prop("checked", true); } else { jQuery(".checkbox-nec1").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec2List).concat(this.nec3List).concat(this.nec4List) || []; }
  public onNEC2Selected(selected: any) { this.nec2List = selected || []; if (this.nec2List.length > 0) { jQuery(".checkbox-nec2").prop("checked", true); } else { jQuery(".checkbox-nec2").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec3List).concat(this.nec4List) || []; }
  public onNEC3Selected(selected: any) { this.nec3List = selected || []; if (this.nec3List.length > 0) { jQuery(".checkbox-nec3").prop("checked", true); } else { jQuery(".checkbox-nec3").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec4List) || []; }
  public onNEC4Selected(selected: any) { this.nec4List = selected || []; if (this.nec4List.length > 0) { jQuery(".checkbox-nec4").prop("checked", true); } else { jQuery(".checkbox-nec4").prop("checked", false) } this.necDependencyArray = selected.concat(this.nec1List).concat(this.nec2List).concat(this.nec3List) || []; }
  public onMoleculeSelected(selected: any) { this.moleculeList = selected || []; if (this.moleculeList.length > 0) { jQuery(".checkbox-molecule").prop("checked", true); } else { jQuery(".checkbox-molecule").prop("checked", false) } }
  public onManufacturerSelected(selected: any) { this.manufacturerList = selected || []; if (this.manufacturerList.length > 0) { jQuery(".checkbox-mfr").prop("checked", true); } else { jQuery(".checkbox-mfr").prop("checked", false) } }
  public onProductSelected(selected: any) { this.productList = selected || []; if (this.productList.length > 0) { jQuery(".checkbox-product").prop("checked", true); } else { jQuery(".checkbox-product").prop("checked", false) } }
  public onPoisonScheduleSelected(selected: any) { this.poisonScheduleList = selected || []; if (this.poisonScheduleList.length > 0) { jQuery(".checkbox-poisonschedule").prop("checked", true); } else { jQuery(".checkbox-poisonschedule").prop("checked", false) } }
  public onFormSelected(selected: any) { this.formList = selected || []; if (this.formList.length > 0) { jQuery(".checkbox-form").prop("checked", true); } else { jQuery(".checkbox-form").prop("checked", false) } }

  checkboxExcludeATC1: boolean = true; checkboxExcludeATC2: boolean = true; checkboxExcludeATC3: boolean = true; checkboxExcludeATC4: boolean = true; checkboxExcludeNEC1: boolean = true; checkboxExcludeNEC2: boolean = true; checkboxExcludeNEC3: boolean = true; checkboxExcludeNEC4: boolean = true; checkboxExcludeMFR: boolean = true; checkboxExcludeProduct: boolean = true; checkboxExcludeMolecule: boolean = true;
  includeExcludeArray = [{
    checkboxExcludeATC1: true, checkboxExcludeATC2: true, checkboxExcludeATC3: true, checkboxExcludeATC4: true, checkboxExcludeNEC1: true, checkboxExcludeNEC2: true, checkboxExcludeNEC3: true, checkboxExcludeNEC4: true,
    checkboxExcludeMFR: true, checkboxExcludePRODUCT: true, checkboxExcludeMOLECULE: true, checkboxExcludePOISON: true, checkboxExcludeFORM: true
  }];

  fnApplyAdditionalFilters() {
    let AdditionalFilter = [];
    console.log(this.selectedMarketbaseMap);
    jQuery("div#marketbaseMapfFlterModal .selected-checkbox input[type='checkbox']").each((i, ele) => {
      if (jQuery(ele).prop("checked")) {
        let checkboxID = jQuery(ele).attr("name");
        if (checkboxID.toLowerCase() == 'atc1' && this.atc1List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "ATC 1", Values: this.getCSV(this.atc1List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC1, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC1 });
        }
        if (checkboxID.toLowerCase() == 'atc2' && this.atc2List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "ATC 2", Values: this.getCSV(this.atc2List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC2, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC2 });
        }
        if (checkboxID.toLowerCase() == 'atc3' && this.atc3List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "ATC 3", Values: this.getCSV(this.atc3List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC3, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC3 });
        }
        if (checkboxID.toLowerCase() == 'atc4' && this.atc4List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "ATC 4", Values: this.getCSV(this.atc4List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeATC4, IsExclude: this.includeExcludeArray[0].checkboxExcludeATC4 });
        }

        if (checkboxID.toLowerCase() == 'nec1' && this.nec1List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "NEC 1", Values: this.getCSV(this.nec1List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC1, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC1 });
        }
        if (checkboxID.toLowerCase() == 'nec2' && this.nec2List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "NEC 2", Values: this.getCSV(this.nec2List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC2, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC2 });
        }
        if (checkboxID.toLowerCase() == 'nec3' && this.nec3List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "NEC 3", Values: this.getCSV(this.nec3List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC3, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC3 });
        }
        if (checkboxID.toLowerCase() == 'nec4' && this.nec4List.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "NEC 4", Values: this.getCSV(this.nec4List, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeNEC4, IsExclude: this.includeExcludeArray[0].checkboxExcludeNEC4 });
        }

        if (checkboxID.toLowerCase() == 'mfr' && this.manufacturerList.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "MFR", Values: this.getCSV(this.manufacturerList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeMFR, IsExclude: this.includeExcludeArray[0].checkboxExcludeMFR });
        }
        if (checkboxID.toLowerCase() == 'product' && this.productList.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "Product", Values: this.getCSV(this.productList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludePRODUCT, IsExclude: this.includeExcludeArray[0].checkboxExcludePRODUCT });
        }
        if (checkboxID.toLowerCase() == 'molecule' && this.moleculeList.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "Molecule", Values: this.getCSV(this.moleculeList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeMOLECULE, IsExclude: this.includeExcludeArray[0].checkboxExcludeMOLECULE });
        }
        if (checkboxID.toLowerCase() == 'flagging' && jQuery("#v11").val() != "") {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "Flagging", Values: "'" + jQuery("#v11").val() + "'", IsEnabled: true, IsExclude: true });
        }
        if (checkboxID.toLowerCase() == 'branding' && jQuery("#v12").val() != "") {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "Branding", Values: "'" + jQuery("#v12").val() + "'", IsEnabled: true, IsExclude: true });
        }
        if (checkboxID.toLowerCase() == 'poisonschedule' && this.poisonScheduleList.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "PoisonSchedule", Values: this.getCSV(this.poisonScheduleList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludePOISON, IsExclude: this.includeExcludeArray[0].checkboxExcludePOISON });
        }
        if (checkboxID.toLowerCase() == 'form' && this.formList.length > 0) {
          AdditionalFilter.push({ Id: 1, Name: "filter-" + this.selectedMarketbaseMap.MarketBaseId, Criteria: "Form", Values: this.getCSV(this.formList, 'Code'), IsEnabled: this.includeExcludeArray[0].checkboxExcludeFORM, IsExclude: this.includeExcludeArray[0].checkboxExcludeFORM });
        }
      }
    });

    //to assign additional filter under marketbase maps
    this.marketDefinitionBaseMap.forEach((rec: MarketDefinitionBaseMap) => {
      if (rec.MarketBaseId == this.selectedMarketbaseMap.MarketBaseId) {
        if (JSON.stringify(rec.Filters || []) != JSON.stringify(AdditionalFilter || [])) {
          rec.Filters = AdditionalFilter || [];
          if (rec.CurrentStatus != 'New') {
            rec.CurrentStatus = 'Modified';
          }
        }
      }
    });


    console.log(this.includeExcludeArray);
    console.log(this.marketDefinitionBaseMap);
    this.fnCheckChangeDetectionInMarketSetup();
  }

  fnChangeFilterDropDown(event: any, type: any) {
    if (type == 'Flagging') {
      jQuery(".checkbox-flagging").prop("checked", true);
    } else if (type == 'Branding') {
      jQuery(".checkbox-branding").prop("checked", true);
    }
    console.log(event.target);
  }
  private getCSV(arr: any[], key: string) {
    arr = arr.filter((rec: any, index: any) => { if (rec.Code != "") { return true; } else { return false; } })
    let values = arr.map(function (obj) {
      return "'" + obj[key] + "'";
    }).join(',');

    console.log(values);
    return values;
  }

  private fnCSVFromArray(values: string, filterName) {
    let returnAry: any[] = [];
    let formatValues = values.replace(/',/g, "'|");
    if (formatValues.indexOf('|') > 0) {// for multiple molecule
      var tempArr: any[] = formatValues.split('|');
      tempArr.forEach((item: any) => {
        returnAry.push({ Code: item.replace(/'/g, ""), FilterName: filterName.toLowerCase() });
      });
    } else {
      returnAry.push({ Code: values.replace(/'/g, ""), FilterName: filterName.toLowerCase() });
    }

    return returnAry;
  }

  private getCSVForMolecule(arr: any[], key: string) {
    arr = arr.filter((rec: any, index: any) => { if (rec.Code != "") { return true; } else { return false; } })
    return arr.map(function (obj) {
      return "'" + obj[key] + "'";
    }).join('|');
  }
}


