using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("DeliveryTerritory")]
    public class DeliveryTerritory
    {
        public int DeliveryTerritoryId { get; set; }
        public int DeliverableId { get; set; }
        public int TerritoryId { get; set; }

        public virtual Deliverables deliverables { get; set; }
        public virtual Territory.Territory territory { get; set; }
    }
}