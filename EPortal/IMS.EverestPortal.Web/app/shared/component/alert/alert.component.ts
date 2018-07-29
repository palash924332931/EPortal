import { Component, OnInit } from '@angular/core';
import { AlertService } from "./alert.service";

@Component({
  selector: 'alert',
  templateUrl: '../../../../app/shared/component/alert/alert.component.html',
  styleUrls: ['../../../../app/shared/component/alert/alert.component.css']
})
export class AlertComponent implements OnInit {
  loading: boolean;
  message: any;
  constructor(private alertService: AlertService) { }

  ngOnInit() {
    //this function waits for a message from alert service, it gets 
    //triggered when we call this from any other component
    this.alertService.getMessage().subscribe(message => {
      if ((message!=null?message.type:'undefine') == 'loading') {
        if (message.text == "true") {
          this.loading = true;
        } else {
          this.loading = false;
        }
      }
      //console.log( message.noFn());
      this.message = message;
    });

  }

}
