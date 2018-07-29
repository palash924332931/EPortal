using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class PopularLinksViewModel
    {

         public Int32 PopularLinkId { get ;set;}
         public String PopularLinkTitle { get ;set;}
         public String PopularLinkDescription { get; set; }
         public DateTime? PopularLinkCreatedOn { get; set; }
         public DateTime? PopularLinkModifiedOn { get; set; }
         public string PopularLinkFilePath { get; set; }
    }
}