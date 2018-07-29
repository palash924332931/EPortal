using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class ListingsViewModel
    {
         public int ListingId {get;set;}
         public String ListingTitle { get;set;}
         public String ListingDescription { get; set; }
         public DateTime? ListingCreatedOn { get; set; }
         public DateTime? ListingModifiedOn { get; set; }

    }
}