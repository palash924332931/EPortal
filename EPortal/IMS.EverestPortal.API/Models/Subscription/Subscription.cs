using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("Subscription")]
    public class Subscription
    {
        public int SubscriptionId { get; set; }
        public string Name { get; set; }
        public int ClientId { get; set; }
        public int CountryId { get; set; }
        public int ServiceId { get; set; }
        public int DataTypeId { get; set; }
        public int SourceId { get; set; }
        //public string Country { get; set; }
        //public string Service { get; set; }
        //public string Data { get; set; }
        //public string Source { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int ServiceTerritoryId { get; set; }
        public bool Active { get; set; }
        public DateTime LastModified { get; set; }
        public int ModifiedBy { get; set; }

        //public virtual MarketBase MarketBase { get; set; }

        public virtual Client client { get; set; }
        public virtual ServiceTerritory serviceTerritory { get; set; }

        public virtual Country country { get; set; }
        public virtual Source source { get; set; }
        public virtual DataType dataType { get; set; }
        public virtual Service service { get; set; }

    }
   
}