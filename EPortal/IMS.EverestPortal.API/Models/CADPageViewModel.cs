using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class CADPageViewModel
    {

        public int CADPageId { get; set; }
        public String CADPageTitle { get; set; }
        public String CADPageDescription { get; set; }
        public DateTime? CadPageCreatedOn { get; set; }
        public DateTime? CadPageModifiedOn { get; set; }
    }
}