
import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';

@Component({
    selector: 'ng-modal',
    template: `<div class="modal fade packSearchModalWrapperSave" id="{{modalID}}" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="false">
    <div class="modal-dialogSave">

        <div class="modal-content packSearchModalPanel filPSMod">
            <div class="">
                <button type="button" class="close" data-dismiss="modal">&times;</button>

            </div>
            <div class="row">
                <ng-content></ng-content>
                    <div class="col-sm-12"><div class="col-sm-12 filHeadingMod"><span class=""> <div innerHTML={{title}}></div> </span></div></div> 
            </div>
            <div class="row padTop20">
                <div class="col-sm-4 box noPadding noMargin">
                </div>
                <div class="col-sm-4 box noPadding">
                </div>
                <div class="col-sm-2 box noPadding">
                   <div *ngIf="saveBtnVisibility"> <button type="button" [disabled]="disabledSaveBtn" (click)="fnSaveModalInfo()" class="btn btn-outline-primary confirmationBtn pull-right" id="saveNextBtnAction" >{{btnCaption}}</button></div>
                </div>
                <div class="col-sm-2 box">
                    <button type="button" id="btnClose"  class="btn btn-outline-primary pull-left confirmationBtn" (click)="fnCloseModal()">{{closeBtnCaption}}</button>
                </div>
            </div>
        </div>
    </div>
</div>`,

    styles: [`
.btn-outline-primary {
    color: #0275d8;
    background-image: none;
    background-color: transparent;
    border-color: #0275d8;
}

.btn-outline-primary:hover {
    color: white;
    background-image: none;
    background-color: #0275d8;
    border-color: #0275d8;
}
.confirmationBtn{
    padding-left: 21px;
    padding-right: 21px;  

}`],
})
export class ModalDialog implements OnInit {
    @Output() fnActionOnSaveBtn: EventEmitter<string> = new EventEmitter<string>();
    @Output() fnActionOnCloseBtn: EventEmitter<string> = new EventEmitter<string>();
    @Input() public title = "";
    @Input() public modalSaveFnParam: string;
    @Input() public saveBtnVisibility: boolean;
    @Input() public btnCaption: string;
    @Input() public closeBtnCaption: string = "Close";
    @Input() public modalID: string = "nextModal";
    disabledSaveBtn: boolean = false;
    constructor() {
        this.disabledSaveBtn = false;
    }
    ngOnInit(): void {
        this.disabledSaveBtn = false;
    }
    fnSaveModalInfo() {
        this.disabledSaveBtn = true;
        this.fnActionOnSaveBtn.emit(this.modalSaveFnParam);
        setTimeout(() => {
            this.disabledSaveBtn = false;
        }, 2000);
    }
    fnCloseModal() {
        this.fnActionOnCloseBtn.emit(this.modalSaveFnParam);
    }

}