import { Component, OnInit, DoCheck,AfterViewInit, Input, Output, OnChanges, SimpleChange, ChangeDetectionStrategy, KeyValueDiffers, EventEmitter, Renderer } from '@angular/core';
import { PTableFilterComponent } from './p-table-pipe';
import { PagerService } from './p-table-pagger';

declare var jQuery: any;
@Component({
  selector: 'app-p-table',
  changeDetection: ChangeDetectionStrategy.Default,
  templateUrl: '../../../../app/shared/component/p-table/p-table.component.html',
  styleUrls: ['../../../../app/shared/component/p-table/p-table.component.css'],
  providers: [PagerService],

})

export class PTableComponent implements OnInit, DoCheck,AfterViewInit {
  @Input() public pTableSetting: IPTableSetting;
  @Input() pTableMasterData: any[];
  @Output() checkboxCallbackFn: EventEmitter<any> = new EventEmitter<any>() || null;
  @Output() customActivityOnRecord: EventEmitter<any> = new EventEmitter<any>() || null;
  @Output() callbackFnOnPageChange: EventEmitter<any> = new EventEmitter<any>() || null;
  @Output() radioButtonCallbackFn: EventEmitter<any> = new EventEmitter<any>() || null;
  @Output() cellClickCallbackFn: EventEmitter<any> = new EventEmitter<any>() || null;
  @Output() customReflowFn: EventEmitter<any> = new EventEmitter<any>() || null;
  @Output() serversideCallbackFn: EventEmitter<any> = new EventEmitter<any>() || null;
  public editUpdateColumn: boolean = true;
  public noRecord = true;
  public pageSize: number = 3;
  public showingPageDetails: string;
  public pTableData: any[] = [{}];
  public pTableDatalength: number = 0;
  public startPageNo: number = 0;
  public totalColspan = 0;
  public maximumPaggingDisplay: number;
  public pageNo: number = 0;
  differ: any;
  public rowLimitArray: any[] = [10, 20, 50, 100, 200, 500, 1000];
  public enabledPagination: boolean = true;
  public globalSearchValue: string = "";
  public individualColumnFilterSortingUp: boolean = true;

  //for table smart filter
  public filterCustomColumnName: string;
  public filterColumnTitle: string;
  public customFilterUniqueArray: any[] = [];
  public columnWiseMasterData: any[] = [];
  public filterItemsCheckedAll: boolean = false;
  public popupFilterColor: string = 'black';
  public storedFilteredInfo: any[] = [];
  public columnSearchValue: string = "";
  public pTableColumnSearch: string = "";
  public pTableColumnCustomizationList: any[] = [];
  public pTableColumnReorder: any[] = [];
  public settingsTabs: any[] = [{ tab: "columnShowHide", tabName: "Col. Show/Hide", active: true }];
  public activeReflow: boolean = false;
  public customReflowActive: boolean = false;
  public defaultSortingExecuted: boolean = false;


  public pModalSetting: any = {
    modalTitle: "",
    modalSaveBtnCaption: "Save"

  };
  pager: any = {};
  pagedItems: any[];
  constructor(private pagerService: PagerService, private differs: KeyValueDiffers, public renderer: Renderer) {
    this.differ = differs.find({}).create(null);
  }


  ngOnInit() {
    if (this.pTableSetting["enableSerialNo"]) {
      this.totalColspan = this.totalColspan + 1;
    }
    if (this.pTableSetting["enableCheckbox"]) {
      this.totalColspan = this.totalColspan + 1;
    }
    if (this.pTableSetting["enabledEditBtn"] || this.pTableSetting["enabledDeleteBtn"]) {
      this.totalColspan = this.totalColspan + 1;
    }

    if (this.pTableSetting["enableRadioButton"]) {
      this.totalColspan = this.totalColspan + 1;
    }

    if (this.pTableSetting["enabledReordering"]) {
      this.settingsTabs.push({ tab: "columnOrder", tabName: "Col. Reorder", active: false });
    }

    this.pTableSetting["radioBtnColumnHeader"] = this.pTableSetting["radioBtnColumnHeader"] || 'Select';
    this.pTableSetting["checkboxColumnHeader"] = this.pTableSetting["checkboxColumnHeader"] || '';

    this.totalColspan = this.totalColspan + this.pTableSetting["tableColDef"].length;
    this.maximumPaggingDisplay = this.pTableSetting["displayPaggingSize"] || 10;
    if (!this.pTableSetting["enablePagination"] && this.pTableSetting["enablePagination"] != undefined) {
      this.enabledPagination = false;
      this.pageSize = 10000;
    } else {
      this.pageSize = this.pTableSetting["pageSize"] || 10;
    }

    //for advanced column filter 
    this.storedFilteredInfo = [];
    this.columnSearchValue = "";
    this.globalSearchValue = "";
    //console.log("call ng init..");
    jQuery("#" + this.pTableSetting["tableID"] + " .column-filter-active").css('color', 'white');

    this.pTableColumnCustomizationList = JSON.parse(JSON.stringify(this.pTableSetting.tableColDef)) || [];
    this.pTableColumnReorder = JSON.parse(JSON.stringify(this.pTableSetting.tableColDef)) || [];
  }

  ngDoCheck() {
    var changes = this.differ.diff(this.pTableMasterData);
    if (changes) {
      this.pTableData = this.pTableMasterData || [];
      this.pTableDatalength = this.pTableData.length || 0;

      if (this.pTableSetting.DisabledTableReset) {
        this.fnShowPreviousFilteredState();
      } else {
        this.storedFilteredInfo = [];
        this.columnSearchValue = "";
        this.globalSearchValue = "";
        jQuery("#" + this.pTableSetting["tableID"] + " .column-filter-active").css('color', 'white');
      }


      //set page state
      if (this.pTableSetting.enabledStaySeletedPage && this.pageNo > 0) {
        this.setPage(this.pageNo);
      } else {
        this.setPage(1);
      }
      this.pTableColumnCustomizationList = JSON.parse(JSON.stringify(this.pTableSetting.tableColDef)) || [];
    }
  }

  ngAfterViewInit(){
       //for default sorting
    if (!this.defaultSortingExecuted) {
      this.defaultSortingExecuted = true;
      this.filterDataWithSorting();
    }
  }


  fnClickPTableCell(event: any, isCellClick: boolean = false, currentCellName: string, activeClickForThisCell: string, data: any) {
    if (isCellClick && (activeClickForThisCell == "Yes" || activeClickForThisCell == "true")) {
      this.cellClickCallbackFn.emit({ cellName: currentCellName, record: data, event: event });
    } else {
      return;
    }

  }

  fnTotalColspanCalCulate() {
    let colspan = 0;
    if (this.pTableSetting["enableSerialNo"]) {
      colspan = colspan + 1;
    }
    if (this.pTableSetting["enableCheckbox"]) {
      colspan = colspan + 1;
    }
    if (this.pTableSetting["enabledEditBtn"] || this.pTableSetting["enabledDeleteBtn"]) {
      colspan = colspan + 1;
    }

    if (this.pTableSetting["enableRadioButton"]) {
      colspan = colspan + 1;
    }

    colspan = colspan + this.pTableSetting["tableColDef"].length;
    return colspan
  }

  fnSaveModalInfo() {
    // this.fnActionOnSaveBtn.emit(this.modalSaveFnParam);
  }

  fnEditRecord(record: any) {
    jQuery("#customModal").modal("show");
  }

  fnDeleteRecord(record: any) {

  }
  async fnFilterPTable(args: any, executionType: boolean = false) {
    let execution = false;
    args = args.trim();
    //this.pTableData=JSON.parse( JSON.stringify( this.pTableMasterData))||[];    
    if (args && this.pTableMasterData && this.pTableMasterData.length > 0) {
      let filterKeys = Object.keys(this.pTableMasterData[0]);
      this.pTableData = await this.pTableMasterData.filter((item: any, index: any, array: any) => {
        let returnVal = false;
        for (let i = 0; i < this.pTableSetting["tableColDef"].length; i++) {
          if (typeof item[this.pTableSetting["tableColDef"][i]["internalName"]] == "string") {
            if (item[this.pTableSetting["tableColDef"][i]["internalName"]].toLowerCase().includes(args.toLowerCase())) {
              returnVal = true
            }
          } else if (typeof item[this.pTableSetting["tableColDef"][i]["internalName"]] == "number") {
            if (item[this.pTableSetting["tableColDef"][i]["internalName"]].toString().indexOf(args.toString()) > -1) {
              returnVal = true;
            }

          } else {
            //returnVal = false;
          }

        }

        return returnVal;
      });

    } else {
      this.pTableData = this.pTableMasterData;
    }

    if (executionType) {
    } else {
      this.storedFilteredInfo = [];
      jQuery("#" + this.pTableSetting["tableID"] + " .column-filter-active").css('color', 'white');
      this.setPage(1);
    }

  }


  setPage(page: number) {
    this.pageNo = page;
    this.pager = this.pagerService.getPager(this.pTableData.length, page, this.pageSize, this.maximumPaggingDisplay);
    if (page < 1 || page > this.pager.totalPages) {
      if (page - 1 <= this.pager.totalPages && this.pager.totalPages != 0) {
        if (page <= 0) {
          this.setPage(1);
        } else {
          this.setPage(page - 1);
        }
        return
      }
    }
    //this.pager = this.pagerService.getPager(this.pTableData.length, page, this.pageSize, this.maximumPaggingDisplay);
    if (this.pTableData.length == 0) {
      this.pagedItems = [];
      //jQuery(".table tbody tr").remove();
    } else {
      this.pagedItems = this.pTableData.slice(this.pager.startIndex, this.pager.endIndex + 1);
    }

    this.pTableDatalength = this.pTableData.length;
    //showing page number
    this.startPageNo = (this.pager.currentPage - 1) * this.pager.pageSize + 1;
    let endPageNo = 0;
    if (this.pTableData.length == 0) {
      this.startPageNo = 0;
    }

    if ((this.pager.currentPage) * this.pager.pageSize < this.pTableData.length) {
      endPageNo = (this.pager.currentPage) * this.pager.pageSize;
    } else {
      endPageNo = this.pTableData.length;
    }

    if (this.pTableData.length == this.pTableMasterData.length) {
      this.showingPageDetails = 'Showing ' + this.startPageNo + ' to ' + endPageNo + ' of ' + this.pTableData.length + ' records';
    } else {
      this.showingPageDetails = 'Showing ' + this.startPageNo + ' to ' + endPageNo + ' of ' + this.pTableData.length + ' records (filtered from ' + this.pTableMasterData.length + ' total records)';
    }

    //to remove checkbox 
    if (this.pTableSetting["enableCheckbox"]) {
      jQuery("#" + this.pTableSetting["tableID"] + " th input.p-table-select-all").prop("checked", false);
      jQuery("#" + this.pTableSetting["tableID"] + " td input.checkbox-" + this.pTableSetting["tableID"]).prop("checked", false);
    }

    //call the function after the page changes
    this.callbackFnOnPageChange.emit({ pageNo: page });   

  }

  fnRemoveSpace(data:any){
      return data.replace(/ /g, "_");
  }

  fnColumnSorting(colName: any, pTableID: any, isSorting: boolean = true) {
    let colNameWithSpace=this.fnRemoveSpace(colName);
    if (!isSorting) {
      return;
    }
    if (jQuery("#" + pTableID + " thead th." + colNameWithSpace).hasClass("sorting")) {
      jQuery("#" + pTableID + " thead th.sorting-active").addClass("sorting").removeClass("sorting-down").removeClass("sorting-up");
      jQuery("#" + pTableID + " thead th." + colNameWithSpace).addClass("sorting-up").removeClass("sorting");
      // this.pTableData = this.pTableData.sort((n1, n2) => {
      //   if (n1[colName] > n2[colName]) { return 1; }
      //   if (n1[colName] < n2[colName]) { return -1; }
      //   return 0;
      // });

      this.pTableSetting.defaultSorting = { sortingColumn: colName, sortingOrder: "asc" };
    } else if (jQuery("#" + pTableID + " thead th." + colNameWithSpace).hasClass("sorting-up")) {
      jQuery("#" + pTableID + " thead th." + colNameWithSpace).addClass("sorting-down").removeClass("sorting-up");
      // this.pTableData = this.pTableData.sort((n1, n2) => {
      //   if (n1[colName] < n2[colName]) { return 1; }
      //   if (n1[colName] > n2[colName]) { return -1; }
      //   return 0;
      // });
      this.pTableSetting.defaultSorting = { sortingColumn: colName, sortingOrder: "desc" }
    } else if (jQuery("#" + pTableID + " thead th." + colNameWithSpace).hasClass("sorting-down")) {
      jQuery("#" + pTableID + " thead th." + colNameWithSpace).addClass("sorting-up").removeClass("sorting-down");
      this.pTableSetting.defaultSorting = { sortingColumn: colName, sortingOrder: "asc" };
      // this.pTableData = this.pTableData.sort((n1, n2) => {
      //   if (n1[colName] > n2[colName]) { return 1; }
      //   if (n1[colName] < n2[colName]) { return -1; }
      //   return 0;
      // });
    }
    
    //for serverside call
    if(this.pTableSetting.enabledServerSideAction){
      this.serversideCallbackFn.emit({ action: 'Sorting', colName: colName,orderTo: this.pTableSetting.defaultSorting.sortingOrder,pageNo:1 });
      return
    }

    this.filterDataWithSorting();
    this.setPage(1);
  }

  filterDataWithSorting() {
    if (this.pTableSetting.defaultSorting != null) {
     // console.log(this.pTableSetting.tableID + "sorting--ok");
      let colName = this.pTableSetting.defaultSorting.sortingColumn;
      let shortingOrder = this.pTableSetting.defaultSorting.sortingOrder;
      if (shortingOrder == 'asc') {
        this.pTableData = this.pTableData.sort((n1, n2) => {
          if (n1[colName] > n2[colName]) { return 1; }
          if (n1[colName] < n2[colName]) { return -1; }
          return 0;
        });
        jQuery("#" + this.pTableSetting.tableID + " thead th." + colName).addClass("sorting-up").removeClass("sorting-down");
      } else if (shortingOrder == 'desc') {
        this.pTableData = this.pTableData.sort((n1, n2) => {
          if (n1[colName] < n2[colName]) { return 1; }
          if (n1[colName] > n2[colName]) { return -1; }
          return 0;
        });

        jQuery("#" + this.pTableSetting.tableID + " thead th." + colName).addClass("sorting-down").removeClass("sorting-up");
      }

    }

  }
  fnOperationOnCheckBox(event: any, args: string) {
    if (event.target.checked) {
      jQuery(".checkbox-" + args).prop("checked", true);
    } else {
      jQuery(".checkbox-" + args).prop("checked", false);
    }

    this.checkboxCallbackFn.emit({ checkedStatus: event.target.checked, record: "", type: "all-select" });
  }

  fnIndividualCheckboxAction(e: any, recordInfo: any, args: string) {
    let unchecked = jQuery('.checkbox-' + args + ':checkbox:not(:checked)');
    if (unchecked.length === 0) {
      jQuery(".select-all-" + args).prop("checked", true);
    }
    else if (unchecked.length > 0) {
      jQuery(".select-all-" + args).prop("checked", false);
    }
    this.checkboxCallbackFn.emit({ checkedStatus: e.target.checked, record: recordInfo, type: "individual" });
  }
  fnIndividualRadioAction(e: any, recordInfo: any) {
    this.radioButtonCallbackFn.emit({ checkedStatus: e.target.checked, record: recordInfo, type: "individual" });
  }
  fnChangePTableRowLength(records: number) {
    this.pageSize = records;
    this.setPage(1);
  }

  public start: any;
  public pressed: any; public startX: any; public startWidth: any;

  private fnResizeColumn(event: any) {
    this.start = event.target;
    this.pressed = true;
    this.startX = event.x;
    this.startWidth = jQuery(this.start).parent().width();
    this.initResizableColumns();
  }

  public initResizableColumns() {
    this.renderer.listenGlobal('body', 'mousemove', (event: any) => {
      if (this.pressed) {
        let width = this.startWidth + (event.x - this.startX);
        jQuery(this.start).parent().css({ 'min-width': width, 'max-   width': width });
        let index = jQuery(this.start).parent().index() + 1;
        jQuery('#' + this.pTableSetting.tableID + ' tr td:nth-child(' + index + ')').css({ 'min-width': width, 'max-width': width });
      }
    });
    this.renderer.listenGlobal('body', 'mouseup', (event: any) => {
      if (this.pressed) {
        this.pressed = false;
      }
    });
  }


  public filterAlignment: string = 'arrow_box_center';
  fnIndividualColumnFilterContext(columnDef: any, event: any) {
    this.individualColumnFilterSortingUp = true;
    this.filterCustomColumnName = columnDef.internalName;
    this.filterColumnTitle = columnDef.headerName;
    this.columnSearchValue = "";
    this.columnWiseMasterData = this.fnFindUniqueColumnWithCheckedFlag(this.pTableData, this.filterCustomColumnName) || [];
    this.customFilterUniqueArray = JSON.parse(JSON.stringify(this.columnWiseMasterData));
    //sorting
    this.customFilterUniqueArray = this.customFilterUniqueArray.sort((n1, n2) => {
      if (n1["data"] > n2["data"]) { return 1; }
      if (n1["data"] < n2["data"]) { return -1; }
      return 0;
    });

    let xPostion = 0;
    //to checked all
    this.filterItemsCheckedAll = true;
    //console.log(event);
    //to set position of pop-up
    let totalScreenX = window.screen.width;
    if (event.pageX - 150 > 5 && event.pageX + 150 < totalScreenX) {
      xPostion = event.pageX - 144;
      this.filterAlignment = 'arrow_box_center';
    } else if (event.pageX + 150 < totalScreenX) {//left has no space
      xPostion = event.pageX + (event.pageX - 144);
      this.filterAlignment = 'arrow_box_left';
    } else if (event.pageX - 150 > 5) {//right has no space
      xPostion = totalScreenX - 320;
      this.filterAlignment = 'arrow_box_right';
    } else if (event.pageX + 290 > totalScreenX) {
      xPostion = totalScreenX - 320;
    } else {
      xPostion = event.pageX;
      this.filterAlignment = 'arrow_box_center';
    }
    let yPosition = event.pageY + 17;
    //let yPosition = '136';
    let ofset = { "top": yPosition, "left": xPostion };
    //let ofset = { "top": event.pageY - event.target.offsetParent.offsetTop - event.target.offsetTop - event.view.scrollY, "left": event.pageX - event.target.offsetParent.offsetLeft - event.target.offsetLeft - event.view.scrollX };
    //jQuery("#fitlerInfo").css(ofset).show();
    jQuery("#" + this.pTableSetting.tableID + "-fitlerInfo").css(ofset).show();

    //to set color of filter popup icon
    let checkFilterApplied = this.storedFilteredInfo.filter((rec: any) => { if (rec.columnName == this.filterCustomColumnName) { return true } else { return false } }) || [];
    this.popupFilterColor = 'black';
    if (checkFilterApplied.length > 0) {
      this.popupFilterColor = 'red';
    }
  }

  fnCustomFilterSelectAll(event: any) {
    if (event.target.checked) {
      this.filterItemsCheckedAll = true;
      this.customFilterUniqueArray.forEach((rec: any) => {
        rec.checked = true;
      });
    } else {
      this.filterItemsCheckedAll = false;
      this.customFilterUniqueArray.forEach((rec: any) => {
        rec.checked = false;
      });
    }

  }

  fnCustomFilterIndividualRecord() {
    setTimeout(() => {
      let unSelectedRecords = this.customFilterUniqueArray.filter((rec: any) => {
        if (rec.checked == true) {
          return true;
        } else {
          return false;
        }
      }) || [];

      console.log("unSelectedRecords.length", unSelectedRecords.length, "this.customFilterUniqueArray.length", this.customFilterUniqueArray.length);
      this.filterItemsCheckedAll = unSelectedRecords.length == this.customFilterUniqueArray.length ? true : false;
    }, 300);

  }

  fnSortColumnWiseFilterData() {
    if (this.individualColumnFilterSortingUp == true) {
      this.customFilterUniqueArray = this.customFilterUniqueArray.sort((n1, n2) => {
        if (n1["data"] < n2["data"]) { return 1; }
        if (n1["data"] > n2["data"]) { return -1; }
        return 0;
      });
      this.individualColumnFilterSortingUp = false;
    }
    else {
      this.customFilterUniqueArray = this.customFilterUniqueArray.sort((n1, n2) => {
        if (n1["data"] > n2["data"]) { return 1; }
        if (n1["data"] < n2["data"]) { return -1; }
        return 0;
      });
      this.individualColumnFilterSortingUp = true;
    }
  }


  fnApplyCustomFilter() {
    if (this.customFilterUniqueArray.length != this.customFilterUniqueArray.filter((rec: any) => rec.checked == true).length || this.columnSearchValue != "") {
      this.pTableData = this.fnCustomFilterFromMasterArray(this.pTableData, this.filterCustomColumnName, this.customFilterUniqueArray.filter((rec: any) => rec.checked == true)) || [];
      jQuery("#" + this.pTableSetting["tableID"] + " #filter-icon-" + this.filterCustomColumnName).css('color', 'red');
      jQuery("#" + this.pTableSetting.tableID + "-fitlerInfo").hide();
      if (this.storedFilteredInfo.length > 0) {
        this.storedFilteredInfo = this.storedFilteredInfo.filter((rec: any) => { if (rec.columnName == this.filterCustomColumnName) { return false } else { return true } }) || [];
        this.storedFilteredInfo.push({ columnName: this.filterCustomColumnName, checkedItem: this.customFilterUniqueArray.filter((rec: any) => { if (rec.checked) { return true } else { return false } }) });
      } else {
        this.storedFilteredInfo.push({ columnName: this.filterCustomColumnName, checkedItem: this.customFilterUniqueArray.filter((rec: any) => { if (rec.checked) { return true } else { return false } }) });
      }

      this.setPage(1);
    } else {
      jQuery("#" + this.pTableSetting.tableID + "-fitlerInfo").hide();
    }

  }

  fnFilterPTableColumn(arg: string) {
    if (this.columnSearchValue.trim() != "") {
      this.filterItemsCheckedAll = false;
      this.customFilterUniqueArray = this.columnWiseMasterData.filter((rec: any) => {
        if (rec.data == null) {
          return false
        } else {
          if (rec.data.toLowerCase().includes(this.columnSearchValue.toLowerCase())) { return true }
          else { return false }
        }
      }) || [];
    } else {
      this.filterItemsCheckedAll = true;
      this.customFilterUniqueArray = JSON.parse(JSON.stringify(this.columnWiseMasterData));
    }

  }

  fnCustomFilterFromMasterArray(masterObject: any[], findKey: any, data: any[]): any[] {
    var o = {}, i, outer: any, l = masterObject.length, filteredData: any = [];
    for (outer = 0; outer < data.length; outer++) {
      let filterMasterData = masterObject.filter((record: any) => record['' + findKey + ''] == data[outer]["data"]) || [];
      filteredData = filteredData.concat(filterMasterData);
    }
    //console.log(filteredData)
    this.filterItemsCheckedAll = true;
    return filteredData;
  }

  async fnApplyCustomCustomization() {
    // //for header fixed 
    let visibleColumnCount = 0;
    this.pTableColumnCustomizationList.forEach((rec: colDef) => {
      if (rec.visible == true) {
        visibleColumnCount = visibleColumnCount + 1;
        //console.log(rec);
      }
    });
    let colWidth = (100 / visibleColumnCount).toFixed(5);

    this.pTableSetting.tableColDef.forEach((rec: any) => {
      let columnLooping = this.pTableColumnCustomizationList.filter((record: any) => { if (record.internalName == rec.internalName) { return true } else { return false } }) || [];
      if (columnLooping.length > 0) {
        rec.visible = columnLooping[0].visible;
        rec.width = colWidth.toString() + '%'
      } else {
        rec.visible = false;
      }
    });
    this.setPage(1);

    //assign again 
    if (this.storedFilteredInfo.length > 0) {
      this.pTableData = JSON.parse(JSON.stringify(this.pTableMasterData)) || [];
      this.storedFilteredInfo.forEach((rec: any) => {
        jQuery("#" + this.pTableSetting["tableID"] + " #filter-icon-" + rec.columnName).css('color', 'white');
      });
      this.storedFilteredInfo = [];
      this.setPage(1);
    }

    //await this.fnShowPreviousFilteredState();   
    this.pTableColumnCustomizationList = JSON.parse(JSON.stringify(this.pTableSetting.tableColDef));
    this.pTableColumnReorder = JSON.parse(JSON.stringify(this.pTableSetting.tableColDef)) || [];

    //to set dynamic table width
    if (this.pTableSetting.enabledDynamicTableWidth) {
      let columnLooping = this.pTableSetting.tableColDef.filter((record: colDef) => { if (record.visible == true || record.visible == null) { return true } else { return false } }) || [];
      if (columnLooping.length > 3) {
        //this.pTableSetting.pTableStyle.overflowContentWidth = '150%';
        this.pTableSetting.pTableStyle.overflowContentWidth = '150%';
        this.pTableSetting.pTableStyle.tableOverflowX = true;
      } else {
        this.pTableSetting.pTableStyle.overflowContentWidth = '100%';
        this.pTableSetting.pTableStyle.tableOverflowX = false;
      }
    }

  }


  fnPTableColumnCustomizationSearch(searchVal: string) {
    this.pTableColumnCustomizationList = this.pTableSetting.tableColDef.filter((record: any) => { if (record.headerName.toLowerCase().includes(searchVal.toLowerCase())) { return true } else { return false } }) || [];
  }

  fnFindUniqueColumnWithCheckedFlag(objectSet: any[], findKey: any, ): any[] {
    var o = {}, i, l = objectSet.length, r = [];
    for (i = 0; i < l; i++) { o[objectSet[i][findKey]] = objectSet[i][findKey]; };
    for (i in o) r.push({ checked: true, data: o[i] });
    return r;
  }
  async clearFilterFromFilterPopup() {
    this.pTableData = JSON.parse(JSON.stringify(this.pTableMasterData));
    if (this.globalSearchValue.trim() != "") {
      await this.fnFilterPTable(this.globalSearchValue, true);
    }
    //to remove filter from storedFilteredInfo variable
    if (this.storedFilteredInfo.length > 0) {
      this.storedFilteredInfo = this.storedFilteredInfo.filter((rec: any) => { if (rec.columnName == this.filterCustomColumnName) { return false } else { return true } }) || [];
    }

    if (this.storedFilteredInfo.length > 0) {
      this.storedFilteredInfo.forEach((rec: any) => {
        this.pTableData = this.fnCustomFilterFromMasterArray(this.pTableData, rec.columnName, rec.checkedItem) || [];
      });
    }

    jQuery("#" + this.pTableSetting["tableID"] + " #filter-icon-" + this.filterCustomColumnName).css('color', 'white');
    jQuery("#" + this.pTableSetting.tableID + "-fitlerInfo").hide();
    this.setPage(1);
  }

  async fnShowPreviousFilteredState() {
    if (this.storedFilteredInfo.length > 0) {
      this.storedFilteredInfo.forEach((rec: any) => {
        this.pTableData = this.fnCustomFilterFromMasterArray(this.pTableData, rec.columnName, rec.checkedItem) || [];
        jQuery("#" + this.pTableSetting["tableID"] + " #filter-icon-" + rec.columnName).css('color', 'red');
      });
    }
    // this.setPage(1);
  }
  fnCloseCustomFilter() {
    //jQuery("#fitlerInfo").hide();
    jQuery("#" + this.pTableSetting.tableID + "-fitlerInfo").hide();
  }

  public activeTabName: string = "columnShowHide";
  selectTab(tab: any) {
    this.settingsTabs.forEach((rec: any) => {
      if (rec.tab == tab.tab) {
        rec.active = true;
      } else {
        rec.active = false;
      }
    });
    this.activeTabName = tab.tab;
  }

  fnChangeColumnOrder(colDef: any, index: any, status: string) {
    let old_index = index;
    let new_index: number = 0;
    //to check valid index
    if (index <= 0 && status == 'up') {
      return false;

    } else if (index >= this.pTableColumnReorder.length - 1 && status == 'down') {
      return false;
    }



    if (status == 'up') {
      new_index = index - 1;
    } else {
      new_index = index + 1;
    }

    if (new_index >= this.pTableColumnReorder.length) {
      var k = new_index - this.pTableColumnReorder.length;
      while ((k--) + 1) {
        this.pTableColumnReorder.push(undefined);
      }
    }
    this.pTableColumnReorder.splice(new_index, 0, this.pTableColumnReorder.splice(old_index, 1)[0]);
  }

  fnApplyReorderColumn() {
    this.pTableSetting.tableColDef = JSON.parse(JSON.stringify(this.pTableColumnReorder));
    this.pTableColumnCustomizationList = JSON.parse(JSON.stringify(this.pTableSetting.tableColDef)) || [];
  }

  onDrop(src: any, trg: any) {
    this.fnModeDragDropContent(this.pTableColumnReorder.map(x => x.internalName).indexOf(src.internalName), this.pTableColumnReorder.map(x => x.internalName).indexOf(trg.internalName));

    //myArray.map(x => x.hello).indexOf('stevie')
  }

  fnModeDragDropContent(src: any, trg: any) {
    src = parseInt(src);
    trg = parseInt(trg);

    if (trg >= this.pTableColumnReorder.length) {
      var k = trg - this.pTableColumnReorder.length;
      while ((k--) + 1) {
        this.pTableColumnReorder.push(undefined);
      }
    }
    this.pTableColumnReorder.splice(trg, 0, this.pTableColumnReorder.splice(src, 1)[0]);
    return this; // for testing purposes

  }

  public tempStyle: ptableStyle[] = [];
  fnReflowTable() {
    if (this.pTableSetting.enabledCustomReflow) {
      if (this.customReflowActive) {
        this.customReflowActive = false;
        this.fnResetStyle("retrive");
      } else {
        this.customReflowActive = true;
        this.fnResetStyle("reset");
      }
      this.customReflowFn.emit(this.pTableSetting.tableID);
    } else {
      if (this.activeReflow) {
        jQuery("#" + this.pTableSetting.tableID + "-fitlerInfo").hide();
        this.activeReflow = false;
        this.fnResetStyle("retrive");
      } else {
        this.fnResetStyle("reset");
        this.activeReflow = true;
      }
    }

  }

  fnResetStyle(action: string) {
    if (action == "reset") {
      //remove previous style
      //if (this.pTableSetting.pTableStyle.overflowContentWidth != undefined && this.pTableSetting.pTableStyle.overflowContentWidth != null) {
      if (this.pTableSetting.pTableStyle != undefined && this.pTableSetting.pTableStyle != null) {
        this.tempStyle = [{ tableOverflow: this.pTableSetting.pTableStyle.tableOverflow || false, tableOverflowX: this.pTableSetting.pTableStyle.tableOverflowX || false, tableOverflowY: this.pTableSetting.pTableStyle.tableOverflowY || false, overflowContentWidth: this.pTableSetting.pTableStyle.overflowContentWidth || null, overflowContentHeight: this.pTableSetting.pTableStyle.overflowContentHeight || null }];
        this.pTableSetting.pTableStyle.overflowContentWidth = null;
        this.pTableSetting.pTableStyle.tableOverflowY = true;
        this.pTableSetting.pTableStyle.tableOverflow = false;
      }
    } else if (action == "retrive") {
      //to reset previous style
      if (this.tempStyle.length > 0) {
        this.pTableSetting.pTableStyle.overflowContentWidth = this.tempStyle[0].overflowContentWidth;
        this.pTableSetting.pTableStyle.overflowContentHeight = this.tempStyle[0].overflowContentHeight;
        this.pTableSetting.pTableStyle.tableOverflow = this.tempStyle[0].tableOverflow;
        this.pTableSetting.pTableStyle.tableOverflowX = this.tempStyle[0].tableOverflowX;
        this.pTableSetting.pTableStyle.tableOverflowY = this.tempStyle[0].tableOverflowY;
      }

    }

  }

  fnActivityOnRecord(action: any, recordInfo: any) {
    this.customActivityOnRecord.emit({ action: action, record: recordInfo });
  }

  // onScroll(event, doc) {
  //   //console.log(event)
  //   if (this.pTableSetting.enabledAutoScrolled) {
  //     const scrollBottom = event.target.scrollHeight;
  //     const scrollTop = event.target.scrollTop;
  //     const scrollHeight = event.target.scrollHeight;
  //     const offsetHeight = event.target.offsetHeight;
  //     const scrollPosition = scrollTop + offsetHeight;
  //     const pageHeight = window.screen.height; const scrollTreshold = scrollHeight - pageHeight;
  //     if ((scrollBottom - scrollTop) == offsetHeight) {
  //       this.pageSize = this.pageSize + 10;
  //       this.setPage(1);
  //     }
  //   }
  // }

  fnDownloadCSV() {
    let exportFileName = this.pTableSetting.tableName.replace(/\' '/g, '_')
    let exprtcsv: any[] = [];
    var csvData = this.convertToCSV(this.pTableData);
    var blob = new Blob([csvData], { type: "text/csv;charset=utf-8;" });
    if (navigator.msSaveBlob) { // IE 10+
      navigator.msSaveBlob(blob, this.createFileName(exportFileName))
    } else {
      var link = document.createElement("a");
      if (link.download !== undefined) { // feature detection
        // Browsers that support HTML5 download attribute
        var url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", this.createFileName(exportFileName));
        //link.style = "visibility:hidden";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      }
    }
  }


  private convertToCSV(objarray: any) {
    var array = typeof objarray != 'object' ? JSON.parse(objarray) : objarray;
    var str = '';
    var row = "";
    //for header row 
    this.pTableSetting.tableColDef.forEach((rec: any) => {
      if (rec.visible == null || rec.visible == true) {
        row += rec.headerName + ',';
      }
    })


    /*for (var index in objarray[0]) {
        //Now convert each value to string and comma-separated
        row += index + ',';
    }*/
    row = row.slice(0, -1);
    //append Label row with line break
    str += row + '\r\n';

    for (var i = 0; i < array.length; i++) {
      var line = '';
      //  for (var index in array[i]) {
      //      if (line != '') line += ','
      //      line += JSON.stringify(array[i][index]);
      //  }
      this.pTableSetting.tableColDef.forEach((rec: any) => {
        if (rec.visible == null || rec.visible == true) {
          line += JSON.stringify(array[i][rec.internalName]) + ',';;
        }
      })
      line = line.slice(0, -1);
      str += line + '\r\n';
    }
    return str;
  }

  private createFileName(exportFileName: string): string {
    var date = new Date();
    return (exportFileName + "_" +
      date.toLocaleDateString() + "_" +
      date.toLocaleTimeString()
      + '.csv')
  }

}


export interface IPTableSetting {
  tableID: string,
  tableClass?: "table table-border",
  tableName?: "p-table-name",
  enableSerialNo?: false,
  tableRowIDInternalName?: "Id",
  tableColDef: colDef[],
  enableSearch?: true,
  enableCheckbox?: false,
  checkboxColumnHeader?: string | 'Select';
  checkboxCallbackFn?: null;
  enabledEditBtn?: false,
  enabledDeleteBtn?: false,
  enableRecordCreateBtn?: false,
  pageSize?: 10,
  displayPaggingSize?: 10,
  enableRadioButton?: false,
  radioBtnColumnHeader?: string | 'Select',
  enablePTableDataLength?: false,
  enablePagination?: true,
  enabledCellClick?: false,
  columnNameSetAsClass?: null,
  enabledColumnResize?: false,
  enabledStaySeletedPage?: false,
  enabledColumnFilter?: false,
  DisabledTableReset?: false,
  enabledColumnSetting?: false,
  enabledReordering?: false,
  tableHeaderFooterVisibility?: boolean | true,
  pTableStyle?: ptableStyle,
  enabledCustomReflow?: boolean | false,
  enabledReflow?: boolean | false,
  enabledDownloadBtn?: boolean | false,
  enabledFixedHeader?: boolean | false,
  enabledDynamicTableWidth?: boolean | false,
  enabledServerSideAction?: boolean | false,
  defaultSorting?: { sortingColumn: string; sortingOrder: string } | null;
}

export interface ptableStyle {
  tableOverflow?: boolean | false,
  tableOverflowX?: boolean | false,
  tableOverflowY?: boolean | false,
  overflowContentWidth?: string | '',
  overflowContentHeight?: null,
  paginationPosition?: string | 'right',
  maxColumnForDynamicWidth?: number | null,
  dynamicOverflowContentWidth?: string | '150%',

}
export interface colDef {
  headerName?: string | "",
  width?: string | "",
  internalName?: string,
  className?: string,
  sort?: Boolean | false,
  type?: string,
  onClick?: string | "",
  applyColFilter?: string | "Apply",
  visible?: boolean | true,
  alwaysVisible: boolean | false
}
