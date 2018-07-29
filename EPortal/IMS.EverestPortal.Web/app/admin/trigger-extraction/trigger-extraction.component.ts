import { Component, OnInit } from '@angular/core';
import { TriggerExtractionService } from '../../../app/admin/trigger-extraction/trigger-extraction.service';
import { ClientService } from '../../shared/services/client.service';
import { Client } from '../../user/user-management.model';




@Component({
  selector: 'trigger-extraction',
  templateUrl: '../../../app/admin/trigger-extraction/trigger-extraction.component.html',
  styleUrls: ['../../../app/admin/trigger-extraction/trigger-extraction.component.css']
})
export class TriggerExtractionComponent implements OnInit {

    private deliverables: any[];
    private clients: Client[];

    constructor(private clientService: ClientService, private extractionService: TriggerExtractionService) { }

  ngOnInit() {

      //get all clients user has access to
      this.loadClients();
  }

  loadClients() {
      this.extractionService.GetClients()
          .finally(() => this.clientService.fnSetLoadingAction(false))
          .subscribe(
          p => (this.clients = p,  
              this.clientService.fnSetLoadingAction(false)),
          e => console.log(e),
          () => this.clientService.fnSetLoadingAction(false),
      );
  }

  getDeliverables(client: any) {
      this.extractionService.GetDeliverables(client.ClientId)
          .finally(() => this.clientService.fnSetLoadingAction(false))
          .subscribe(
          p => (this.clients = p.data,
              this.clientService.fnSetLoadingAction(false)),
          e => console.log(e),
          () => this.clientService.fnSetLoadingAction(false),
      );
  }

}
