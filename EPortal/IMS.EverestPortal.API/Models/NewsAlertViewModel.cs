using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class NewsAlertViewModel
    {
        public Int32 NewsAlertId { get ; set;}
        public String NewsAlertTitle { get ;set;}
        public String NewsAlertDescription { get; set; }
        public DateTime? NewsAlertCreatedOn { get; set; }
        public DateTime? NewsAlertModifiedOn { get; set; }
    }
}