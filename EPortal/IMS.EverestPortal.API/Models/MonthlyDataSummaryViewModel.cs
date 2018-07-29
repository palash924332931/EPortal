using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class MonthlyDataSummaryViewModel
    {

        public int MonthlyDataSummaryId { get; set; }
        public String MonthlyDataSummaryTitle { get; set; }
        public String MonthlyDataSummaryDescription { get; set; }
        public DateTime? MonthlyDataSummaryCreatedOn { get; set; }
        public DateTime? MonthlyDataSummaryModifiedOn { get; set; }
    }
}