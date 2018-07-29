using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class MonthlyDataSummary
    {
        private int _monthlyDataSummaryId;
        private string _monthlyDataSummaryTitle;
        private string _monthlyDataSummaryDescription;
        private string _monthlyDataSummaryFileUrl;
        private DateTime? _monthlyDataSummaryCreatedOn;
        private string _monthlyDataSummaryCreatedBy;
        private DateTime? _monthlyDataSummaryModifiedOn;
        private string _monthlyDataSummaryModifiedBy;

        public int monthlyDataSummaryId { get { return _monthlyDataSummaryId; } set { _monthlyDataSummaryId = value; } }
        public String monthlyDataSummaryTitle { get { return _monthlyDataSummaryTitle; } set { _monthlyDataSummaryTitle = value; } }
        public String monthlyDataSummaryDescription { get { return _monthlyDataSummaryDescription; } set { _monthlyDataSummaryDescription = value; } }
        public String monthlyDataSummaryFileUrl { get { return _monthlyDataSummaryFileUrl; } set { _monthlyDataSummaryFileUrl = value; } }
        public DateTime? monthlyDataSummaryCreatedOn { get { return _monthlyDataSummaryCreatedOn; } set { _monthlyDataSummaryCreatedOn = value; } }
        public String monthlyDataSummaryCreatedBy { get { return _monthlyDataSummaryCreatedBy; } set { _monthlyDataSummaryCreatedBy = value; } }
        public DateTime? monthlyDataSummaryModifiedOn { get { return _monthlyDataSummaryModifiedOn; } set { _monthlyDataSummaryModifiedOn = value; } }
        public String monthlyDataSummaryModifiedBy { get { return _monthlyDataSummaryModifiedBy; } set { _monthlyDataSummaryModifiedBy = value; } }

    }
}