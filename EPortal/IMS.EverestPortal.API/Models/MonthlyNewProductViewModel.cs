using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class MonthlyNewProductViewModel
    {
        public int MonthlyNewProductId { get; set; }
         public String MonthlyNewProductTitle { get ;set;}
         public String MonthlyNewProductDescription {get;set;}
         public DateTime? MonthlyNewProductCreatedOn { get; set; }
         public DateTime? MonthlyNewProductModifiedOn { get; set; }
    }
}