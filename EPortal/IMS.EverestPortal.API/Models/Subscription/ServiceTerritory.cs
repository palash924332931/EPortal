using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("ServiceTerritory")]
    public class ServiceTerritory
    {
        public int ServiceTerritoryId { get; set; }
        public string TerritoryBase { get; set; }

    }
}