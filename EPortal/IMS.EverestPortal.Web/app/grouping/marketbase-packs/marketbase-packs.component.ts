import { Component, OnInit, Input, Output, ViewChild, EventEmitter } from '@angular/core';
import { ActivatedRoute, Route, RouterModule, Router } from '@angular/router';
import { AlertService } from '../../shared/component/alert/alert.service'
import { GroupingService } from '../../shared/services/grouping.service';
import { GroupingDetailsComponent } from '../grouping-details/grouping-details.component';
import { MarketDefinition } from '../../shared/models/market-definition';
import { GroupingTreeStructure, MarketAttribute, MarketGroup, MarketGroupPack, MarketGroupView, MarketGroupFilter, MarketDefinitionDetails, MarketDefinitionPacks } from '../../shared/models/grouping/grouping-model'
import { DynamicPackMarketBase } from '../../shared/models/dynamic-pack-market-base';

declare var jQuery: any;
@Component({
  selector: 'app-marketbase-packs',
  templateUrl: '../../../app/grouping/marketbase-packs/marketbase-packs.component.html',
  styleUrls: ['../../../app/grouping/marketbase-packs/marketbase-packs.component.css']
})
export class MarketbasePacksComponent implements OnInit {
  @Input() public dynamicPacksData: MarketDefinitionPacks[];
  @Input() public staticPacksData: MarketDefinitionPacks[];
  @Input() public marketDefinition: MarketDefinition;
  @Input() public clientId: number = 0;
  @Input() public marketDefId: number = 0;
  @Output() fnCallBackPackComponent: EventEmitter<any> = new EventEmitter() || null;
  public dynamicTableBind: any;
  public savedDynamicPackMarketbase: MarketDefinitionPacks[] = [];
  public savedStaticPackMarketBase: MarketDefinitionPacks[] = [];
  public savedMarketDefinitionBaseMap: any[] = [];
  public staticTableBind: any;
  public staticPackMarketBase: MarketDefinitionPacks[] = [];
  public dynamicPackMarketBase: MarketDefinitionPacks[] = [];
  public enabledDynamicTableFooterBtns: boolean = false;
  public enabledStaticTableFooterBtns: boolean = false;
  public IsActiveGrouping: boolean = false;
  public marketDefinitionDetails: MarketDefinitionDetails;
  public isEditMarketDef: boolean;
  public changeDetectionInPackComponent: boolean = false;
  public changeDetectionInGroupingComponent: boolean = false;
  public loadGroupView: boolean = false;
  public JSON: any;
  public activeReflowMarketDefContent: boolean = false;
  public activeReflowAvailablePackContent: boolean = false;
  public islockDef: boolean = false;
  constructor(private alertService: AlertService, private groupingService: GroupingService, private router: Router) { }
  @ViewChild('groupingDetails') groupingDetails: GroupingDetailsComponent;
  ngOnInit() {
    this.JSON = JSON;
    this.fnBindStaticTable();
    this.fnBindDynamicTable();
    this.dynamicPackMarketBase = (this.dynamicPacksData);
    this.staticPackMarketBase = this.staticPacksData;

    this.savedDynamicPackMarketbase = JSON.parse(JSON.stringify(this.dynamicPacksData));
    this.savedStaticPackMarketBase = JSON.parse(JSON.stringify(this.staticPacksData));
    this.savedMarketDefinitionBaseMap = JSON.parse(JSON.stringify(GroupingService.marketDefinitionBaseMap));
    console.log("packs component");
    console.log(GroupingService.marketDefinitionBaseMap);
    this.loadGroupView = true;
    this.islockDef = GroupingService.isLockDef;
  }
  isViewMode() {
    return true;
  }

  fnDeleteFromMktDef(): void {
    let selectedDynamicObject: any[] = [];
    let selectMarketBaseArray: any[] = [];
    let isDynamicType: boolean = false;
    let dynamicPacks = this.dynamicPackMarketBase || []
    let recordID: any;
    jQuery(".checkbox-dynamic-table").each((i, ele) => {
      if (jQuery(ele).prop("checked") == true) {
        recordID = jQuery(ele).attr("data-sectionvalue");
        selectedDynamicObject.push(recordID);
      }
    });

    if (selectedDynamicObject.length > 0) {
      //to check data resfresh type
      selectedDynamicObject.forEach((element: any) => {
        this.dynamicPackMarketBase.forEach((rec: any, index: any) => {
          if (rec.Id == element) {
            if (rec.DataRefreshType == "dynamic") {
              isDynamicType = true;
              let marketBaseName = this.dynamicPackMarketBase.filter((rec: any) => { if (rec.Id == recordID) { return true } else { return false } })[0].MarketBase;
              if (selectMarketBaseArray.indexOf(marketBaseName) < 0) {
                selectMarketBaseArray.push(marketBaseName);
              }
            }
          }
        });
      });

      //end of check
      if (isDynamicType) {
        this.alertService.confirm("By deleting the pack/s from the market definition this will result in the market base " + selectMarketBaseArray + " data refresh setting changing from dynamic to static. Any new packs loaded into this market base will not automatically insert into the market definition.",
          () => {
            //to set refresh status
            for (let i = 0; i < selectMarketBaseArray.length; i++) {
              GroupingService.marketDefinitionBaseMap.forEach((part: any) => {
                console.log("part", part)
                if (part.Name == selectMarketBaseArray[i]) {
                  part.DataRefreshType = "static";
                }
              });

              //to disable footer btns of dynamic table
              this.enabledDynamicTableFooterBtns = false;
            }

            //to change data-refresh type dynamic to static
            for (let i = 0; i < selectMarketBaseArray.length; i++) {
              this.dynamicPackMarketBase.forEach(function (part, index) {
                if (part.MarketBase.includes(selectMarketBaseArray[i])) {
                  part.DataRefreshType = "static";
                }
              });
            }


            //to shift dynamic to static table
            selectedDynamicObject.forEach((item: any) => {
              var selectedDynamicInfo = this.dynamicPackMarketBase.filter((rec: any) => rec.Id == item)[0];
              this.dynamicPackMarketBase.splice(this.dynamicPackMarketBase.indexOf(selectedDynamicInfo), 1);//remove form dynamic
              this.staticPackMarketBase.push(selectedDynamicInfo);//push in static
            });

            this.alertService.alert("Pack/s have moved to ‘Available Pack List’ and the market base <b>" + selectMarketBaseArray + "’s</b> data refresh setting has changed to static. Any new packs loaded into this market base will not automatically insert into the market definition.");
          },
          () => {

          });
      } else {
        //to shift dynamic to static
        selectedDynamicObject.forEach((item: any) => {
          var selectedDynamicInfo = this.dynamicPackMarketBase.filter((rec: any) => rec.Id == item)[0];
          this.dynamicPackMarketBase.splice(this.dynamicPackMarketBase.indexOf(selectedDynamicInfo), 1);//remove form dynamic
          this.staticPackMarketBase.push(selectedDynamicInfo);//push in static
        });

        this.alertService.alert("Packs move to Available Pack List from Market Definition Content.");
        //to disable footer btns of dynamic table
        this.enabledDynamicTableFooterBtns = false;
        return;
      }


    } else {
      this.alertService.alert("Please select item(s) to remove from market definition list.");
      return;
    }

    this.fnCheckChangeDetectionInPacks();
  }

  fnAddtoMktDef(): void {
    let selectedStaticObject: any[] = [];
    jQuery(".checkbox-static-table").each(function () {
      if (jQuery(this).prop("checked") == true) {
        selectedStaticObject.push(jQuery(this).attr("data-sectionvalue"));
      }
    });

    if (selectedStaticObject.length > 0) {
      //to shift packs from static to dynamic
      selectedStaticObject.forEach((item: any) => {
        var selectedStaticInfo = this.staticPackMarketBase.filter((rec: MarketDefinitionPacks) => rec.Id == item)[0];
        this.staticPackMarketBase.splice(this.staticPackMarketBase.indexOf(selectedStaticInfo), 1);
        this.dynamicPackMarketBase.push(selectedStaticInfo);
      });

      //to disable footer button of static table
      this.enabledStaticTableFooterBtns = false;
    } else {
      this.alertService.alert("Please select any items from available pack list.");
      return;
    }

    this.fnCheckChangeDetectionInPacks();
  }

  fnCheckboxDynamicTableClick(event: any) {
    if (jQuery(".checkbox-dynamic-table:checked").length > 0) {
      this.enabledDynamicTableFooterBtns = true;
    } else {
      this.enabledDynamicTableFooterBtns = false;
    }
  }

  fnDynamicTablePageChange(event: any) {
    this.enabledDynamicTableFooterBtns = false;
  }

  fnStaticTablePageChange(event: any) {
    this.enabledStaticTableFooterBtns = false;
  }

  fnCheckboxStaticTableClick(event: any) {
    if (jQuery(".checkbox-static-table:checked").length > 0) {
      this.enabledStaticTableFooterBtns = true;
    } else {
      this.enabledStaticTableFooterBtns = false;
    }
  }

  fnMoveToGroupSetup() {
    this.groupingDetails.ngOnInit();
    this.IsActiveGrouping = true;
  }

  //fnShowPacksComponent(event: any) {
  //  this.IsActiveGrouping = false;
  //}

  async fnBackToMarketSetupComponent() {
    //console.log(JSON.stringify(this.dynamicPackMarketBase || []) == JSON.stringify(GroupingService.dynamicPacksList || []))   
    let dynamicList = this.dynamicPackMarketBase || [];
    let groupingDynamicPackList = GroupingService.dynamicPacksList || [];
    if ((dynamicList.length == groupingDynamicPackList.length) && !this.changeDetectionInGroupingComponent) {
      if (this.IsActiveGrouping) {
        this.groupingDetails.fnCallDuringBackModule();
        this.IsActiveGrouping = false;
      }
      else {
        this.fnCallBackPackComponent.emit({ marketDefId: this.marketDefId || 0, dynamicPacksList: this.dynamicPackMarketBase || [] });
      }
    } else if (this.dynamicPackMarketBase.length == 0 && this.IsActiveGrouping == true) {
      this.groupingDetails.fnCallDuringBackModule();
      this.IsActiveGrouping = false;
    }
    else if (this.dynamicPackMarketBase.length > 0) {
      if (this.IsActiveGrouping) {
        this.groupingDetails.fnCallDuringBackModule();
      }
      await this.fnSaveMarketGroupDetails("saved and back");
      // await this.alertService.confirmAsync("Changes have been made to the market definition criteria for Pack allocation, Please save these.",
      //   async () => {
      //     await this.fnSaveMarketGroupDetails("saved and back");
      //   },
      //   () => {
      //     this.dynamicPackMarketBase == JSON.parse(JSON.stringify(GroupingService.dynamicPacksList));
      //     this.fnCallBackPackComponent.emit("event");
      //   });
    } else if (this.dynamicPackMarketBase.length == 0) {
      this.alertService.confirm("There are no packs available in the market definition content. Do you want to back?",
        () => {
          this.fnCallBackPackComponent.emit({ marketDefId: this.marketDefId || 0, dynamicPacksList: this.dynamicPackMarketBase || [] });
        },
        () => { });
    }

  }

  fnRelocateMarketTiles() {
    let dynamicPack = this.dynamicPackMarketBase || [];
    let grouingDynamicPack = GroupingService.dynamicPacksFinal || [];
    console.log("dynamicPack", dynamicPack, "grouingDynamicPack", grouingDynamicPack, "savedDynamic", this.savedDynamicPackMarketbase);
    let confirmationMessage = this.IsActiveGrouping ? 'Changes made to grouping will not apply. Would you like to proceed?' :
      'Changes made to the market definition setup will not apply. Would you like to proceed?';
    if (!this.IsActiveGrouping) {
      //if (this.dynamicPackMarketBase.length == this.savedDynamicPackMarketbase.length) {
      if (JSON.stringify(this.dynamicPackMarketBase) == JSON.stringify(this.savedDynamicPackMarketbase)) {
        this.alertService.confirm("Do you want to return back to <b>Market Definition</b> view?",
          () => {
            this.router.navigate(['market/My-Client/' + this.clientId]);
            return
          },
          () => { });
      } else {
        this.alertService.confirm(confirmationMessage,
          () => {
            this.router.navigate(['market/My-Client/' + this.clientId]);
            return
          },
          () => { });
      }
    } else {
      if (!this.changeDetectionInGroupingComponent && ((this.dynamicPackMarketBase.length == this.savedDynamicPackMarketbase.length))) {
        this.alertService.confirm("Do you want to return back to <b>Market Definition</b> view?",
          () => {
            this.router.navigate(['market/My-Client/' + this.clientId]);
            return
          },
          () => { });
      } else {
        this.alertService.confirm(confirmationMessage,
          () => {
            this.router.navigate(['market/My-Client/' + this.clientId]);
            return
          },
          () => { });
      }

    }

  }

  fnToCheckModificatoinOnGroupingScreen(event: any): void {
    if (event != null && event.IsChanged != null) {
      this.changeDetectionInGroupingComponent = event.IsChanged;
    }
  }

  async fnSaveMarketGroupDetails(action: any = "") {
    this.alertService.fnLoading(false);
    if (this.dynamicPackMarketBase.length == 0) {
      this.alertService.fnLoading(false);
      this.alertService.alert("There are no packs available in the market definition content. Please review.");
      return;
    }
    let confirmationMessage = this.IsActiveGrouping ? 'Changes have been made to the grouping. Would you like to save these?' :
      'Changes have been made to the market definition criteria for pack allocation. Would you like to save these?';
    await this.alertService.confirmAsync(confirmationMessage,
      async () => {
        this.changeDetectionInGroupingComponent = false;
        this.alertService.fnLoading(true);
        this.dynamicPackMarketBase.forEach(function (part, index) {
          part.Alignment = "dynamic-right";
        });
        this.staticPackMarketBase.forEach(function (part, index) {
          part.Alignment = "static-left";
        });
        GroupingService.dynamicPacksFinal = JSON.parse(JSON.stringify(this.dynamicPackMarketBase.concat(this.staticPackMarketBase))) || [];
        GroupingService.marketDefinition.MarketDefinitionPacks = JSON.parse(JSON.stringify(GroupingService.dynamicPacksFinal)) || [];
        GroupingService.marketDefinition.MarketDefinitionBaseMaps = JSON.parse(JSON.stringify(GroupingService.marketDefinitionBaseMap)) || [];
        GroupingService.dynamicPacksList == JSON.parse(JSON.stringify(this.dynamicPackMarketBase));
        let groupDetails: any = this.groupingDetails.fnReturnGroupDetails();

        //let filter: MarketGroupFilter[] = [{ Id: 10, Name: "Test", Criteria: "Citeria", IsEnabled: true,IsAttribute:false, Values: "Values", AttributeId: 11, GroupId: 12, MarketDefinitionId: 13 }];

        this.marketDefinitionDetails = {
          MarketDefinition: GroupingService.marketDefinition, GroupView: groupDetails.MarketGroupView || [],
          MarketGroupPack: groupDetails.MarketGroupPack || [],
          MarketGroupFilter: groupDetails.MarketGroupFilter || []
        };

        this.groupingService.fnSaveMarketGroupDetails(JSON.stringify(this.marketDefinitionDetails), this.clientId, this.marketDefId).subscribe(
          data => {
            this.alertService.fnLoading(false);
            // if (this.marketDefId < 1) {
            //   this.marketDefId = data.Id;
            //   this.isEditMarketDef = true;
            //   this.savedDynamicPackMarketbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase || []));
            //   this.savedStaticPackMarketBase = JSON.parse(JSON.stringify(this.staticPackMarketBase || []));
            //   this.router.navigate(['group/' + this.clientId + '|' + this.marketDefId + '/Edit Lock']);
            // }

            let successMessage = this.IsActiveGrouping ? 'Grouping content saved successfully.' : 'Market definition content saved successfully.';
            this.alertService.alert(successMessage,
              () => {
                if (this.marketDefId < 1) {
                  this.marketDefId = data.Id;
                  this.isEditMarketDef = true;
                  this.savedDynamicPackMarketbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase || []));
                  this.savedStaticPackMarketBase = JSON.parse(JSON.stringify(this.staticPackMarketBase || []));
                  this.router.navigate(['group/' + this.clientId + '|' + this.marketDefId + '/Edit Lock']);
                } else {
                  this.savedDynamicPackMarketbase = JSON.parse(JSON.stringify(this.dynamicPackMarketBase || []));
                  this.savedStaticPackMarketBase = JSON.parse(JSON.stringify(this.staticPackMarketBase || []));
                }

                if (action == "saved and back") {
                  if (this.IsActiveGrouping) {
                    this.IsActiveGrouping = false;
                  }
                  else {
                    this.fnCallBackPackComponent.emit({ marketDefId: data.Id, dynamicPacksList: this.dynamicPackMarketBase });
                  }
                }
              });

            this.changeDetectionInGroupingComponent = false;
            this.changeDetectionInPackComponent = false;
          },
          //saved alert here             
          (err: any) => {
            this.alertService.fnLoading(false);
            console.log(err);
          },
          () => console.log("edited client list: ")
        );
      },
      () => {
        if (action == "saved and back") {
          this.dynamicPackMarketBase == JSON.parse(JSON.stringify(GroupingService.dynamicPacksList));
          if (this.IsActiveGrouping) {
            this.IsActiveGrouping = false;
          }
          else {
            this.fnCallBackPackComponent.emit({ marketDefId: this.marketDefId, dynamicPacksList: this.dynamicPackMarketBase });
          }
        }
      });
  }

  fnCheckChangeDetectionInPacks() {
    if (JSON.stringify(this.dynamicPackMarketBase) == JSON.stringify(GroupingService.dynamicPacksFinal)) {
      this.changeDetectionInPackComponent = false;
    } else {
      this.changeDetectionInPackComponent = true;
    }
  }

  fnBacktoPreviousState() {
    let confirmationMessage = this.IsActiveGrouping ? 'Changes made to the grouping will not apply to the pack allocation. Would you like to proceed?' :
      'Changes made to the market base selection criteria will not apply to the pack allocation. Would you like to proceed?';
    this.alertService.confirm(confirmationMessage,
      () => {
        this.dynamicPackMarketBase = JSON.parse(JSON.stringify(this.savedDynamicPackMarketbase));
        this.staticPackMarketBase = JSON.parse(JSON.stringify(this.savedStaticPackMarketBase));
        GroupingService.marketDefinitionBaseMap = JSON.parse(JSON.stringify(this.savedMarketDefinitionBaseMap));
        this.changeDetectionInPackComponent = false;

        if (this.changeDetectionInGroupingComponent) {
          this.groupingDetails.marketGroupView = JSON.parse(JSON.stringify(this.groupingDetails.tempMarketGroupView));
          this.groupingDetails.marketGroupPack = JSON.parse(JSON.stringify(this.groupingDetails.tempMarketGroupPack));
          this.changeDetectionInGroupingComponent = false;
          this.groupingDetails.GetMarketGroupView();
          this.groupingDetails.loadDestinationTable();
        }

        return false;
      },
      () => { });
  }

  public factorVal: string = "";
  async fnAddOrEditFactor() {
    //read record from table 
    jQuery("#dynamic-table tbody tr .checkbox-dynamic-table").each((i, ele) => {
      if (jQuery(ele).prop("checked") == true) {
        let recordID = jQuery(ele).attr("data-sectionvalue");
        this.factorVal = "";
        this.dynamicPackMarketBase.forEach((element: MarketDefinitionPacks) => {
          if (element.Id == recordID && (element.Factor != "" && element.Factor != null)) {
            this.factorVal = element.Factor;
          }
        });
      }
    });

    jQuery("#factorModal").modal("show");
  }

  public factorErrorMgs: string = "";
  fnOnChangeFactorValue() {
      if (this.factorVal!=null && this.factorVal != "") {
        if (isNaN(+this.factorVal)) {
            this.factorErrorMgs = "only decimal value is allowed.";
        } else {
            var arrayOfStrings = this.factorVal.toString().split(".");
            if (arrayOfStrings[0].length > 8) { this.factorErrorMgs = "More than 8 digits before decimal is not allowed"; }
            else if (arrayOfStrings.length > 1 && arrayOfStrings[1].length > 4) { this.factorErrorMgs = "More than 4 digits after decimal is not allowed"; }            
            else {
                this.factorErrorMgs = "";
            }
        }
    } else {
      this.factorErrorMgs = "";
    }
  }

  fnApplyFactor() {
    let selectedId: any[] = [];
    jQuery("#factorModal").modal("hide");
    jQuery("#dynamic-table tbody tr .checkbox-dynamic-table").each((i, ele) => {
      if (jQuery(ele).prop("checked") == true) {
        let recordID = jQuery(ele).attr("data-sectionvalue");
        selectedId.push(recordID);
      }
    });

    selectedId.forEach((rec: any) => {
      this.dynamicPackMarketBase.forEach((element: MarketDefinitionPacks) => {
        if (element.Id == rec && (this.factorVal != "" && this.factorVal != null)) {
          element.Factor = this.factorVal;
        }
      });
    });
    jQuery(".select-all-dynamic-table").prop("checked", false);
    jQuery("#dynamic-table tbody tr .checkbox-dynamic-table").prop("checked", false);
  }

  //for custom reflow
  fnCustomReflowSetting(event: string) {
    if (event == 'static-table') {
      //activeReflowAvailablePackContent
      if (this.activeReflowAvailablePackContent) {
        jQuery("#" + event + "-fitlerInfo").hide();
        this.activeReflowAvailablePackContent = false;
      } else {
        this.activeReflowAvailablePackContent = true;
      }
    } else if (event == 'dynamic-table') {
      if (this.activeReflowMarketDefContent) {
        jQuery("#" + event + "-fitlerInfo").hide();
        this.activeReflowMarketDefContent = false;
      } else {
        this.activeReflowMarketDefContent = true;
      }
    }

  }


  fnBindStaticTable() {
    // Static Table Starts
    this.staticTableBind = {
      tableID: "static-table",
      tableClass: "table table-border ",
      tableName: "Available Pack List",
      enableSerialNo: false,
      tableRowIDInternalName: "Id",
      tableColDef: [
        { headerName: 'PFC', width: '20%', internalName: 'PFC', className: "static-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
        { headerName: 'Pack Name', width: '50%', internalName: 'Pack', className: "static-pack-description", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Market Base', width: '30%', internalName: 'MarketBase', className: "static-market-base", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Product', width: '20%', internalName: 'Product', className: "dynamic-product", sort: true, type: "", onClick: "", visible: false },
        { headerName: 'Manufacturer', width: '20%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "", visible: false },
        { headerName: 'ATC4 Code', width: '8%', internalName: 'ATC4', className: "dynamic-atc4", sort: true, type: "", onClick: "", visible: false },
        { headerName: 'NEC4 Code', width: '8%', internalName: 'NEC4', className: "dynamic-nec4", sort: true, type: "", onClick: "", visible: false },
        { headerName: 'Molecule', width: '30%', internalName: 'Molecule', className: "dynamic-Molecule", sort: true, type: "", onClick: "", visible: false },

      ],
      columnNameSetAsClass: 'ChangeFlag',
      enableSearch: true,
      enableCheckbox: true,
      enableRecordCreateBtn: false,
      enablePagination: true,
      pageSize: 500,
      displayPaggingSize: 3,
      enabledStaySeletedPage: true,
      enablePTableDataLength: false,
      enabledColumnSetting: true,
      enabledColumnFilter: true,
      enabledReflow: true,
      enabledCustomReflow: true,
      enabledFixedHeader: true,
      enabledDynamicTableWidth: true,
      defaultSorting:{sortingColumn:"Pack",sortingOrder:"asc"},
      // pTableStyle: {
      //   tableOverflow: true,
      //   tableOverflowY: true,
      //   overflowContentHeight: '428px',
      //   overflowContentWidth: '98%'
      // }

      pTableStyle: {
        tableOverflow: false,
        tableOverflowY: true,
        maxColumnForDynamicWidth: 4,
        overflowContentWidth: '100%',
        overflowContentHeight: '428px',
        dynamicOverflowContentWidth: '150%'
      }
    };
    // Static table ends
  }

  fnBindDynamicTable() {
    //Dynamic Table starts
    this.dynamicTableBind = {
      tableID: "dynamic-table",
      tableClass: "table table-border ",
      tableName: "Market Definition Content",
      enableSerialNo: false,
      tableRowIDInternalName: "Id",
      tableColDef: [
        { headerName: 'PFC', width: '6%', internalName: 'PFC', className: "dynamic-pfc", sort: true, type: "", onClick: "", visible: true, alwaysVisible: true },
        { headerName: 'Pack Name', width: '15%', internalName: 'Pack', className: "dynamic-pack-name", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Market Base', width: '9%', internalName: 'MarketBase', className: "dynamic-market-base", sort: true, type: "", onClick: "", visible: true },
        // { headerName: 'Group #', width: '4%', internalName: 'GroupNumber', className: "dynamic-group-no", sort: true, type: "", onClick: "", visible: true },
        // { headerName: 'Group Name', width: '8%', internalName: 'GroupName', className: "dynamic-group-name", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Factor', width: '5%', internalName: 'Factor', className: "dynamic-factor", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Product', width: '9%', internalName: 'Product', className: "dynamic-product", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Manufacturer', width: '9%', internalName: 'Manufacturer', className: "dynamic-manufacturer", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'ATC4 Code', width: '9%', internalName: 'ATC4', className: "dynamic-atc4", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'NEC4 Code', width: '8%', internalName: 'NEC4', className: "dynamic-nec4", sort: true, type: "", onClick: "", visible: true },
        { headerName: 'Molecule', width: '30%', internalName: 'Molecule', className: "dynamic-Molecule", sort: true, type: "", onClick: "", visible: true },
      ],
      enableSearch: true,
      enableCheckbox: true,
      enablePagination: true,
      enableRecordCreateBtn: false,
      pageSize: 500,
      displayPaggingSize: 10,
      enablePTableDataLength: false,
      columnNameSetAsClass: 'ChangeFlag',
      enabledStaySeletedPage: true,
      enabledColumnResize: true,
      enabledColumnSetting: true,
      enabledColumnFilter: true,
      enabledCustomReflow: true,
      enabledFixedHeader: true,
      defaultSorting:{sortingColumn:"Pack",sortingOrder:"asc"},
      pTableStyle: {
        tableOverflow: true,
        overflowContentWidth: '150%',
        overflowContentHeight: '428px',
        paginationPosition: 'left',
      }
    };
    //Dynamic Table ends
  }
}
