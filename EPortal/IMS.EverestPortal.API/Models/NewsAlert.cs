using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class NewsAlert
    {
        private int _newsAlertId;
        private string _newsAlertTitle;
        private string _newsAlertDescription;
        private string _newsAlertImageUrl;
        private string _newsAlertAltImage;
        //public string _newsAlertDetailedNews;
        private DateTime? _newsAlertCreatedOn;
        private string _newsAlertCreatedBy;
        private DateTime? _newsAlertModifiedOn;
        private string _newsAlertModifiedBy;

        public Int32 newsAlertId { get { return _newsAlertId; } set { _newsAlertId = value; } }
        public String newsAlertTitle { get { return _newsAlertTitle; } set { _newsAlertTitle = value; } }
        public String newsAlertDescription { get { return _newsAlertDescription; } set { _newsAlertDescription = value; } }
        public String newsAlertImageUrl { get { return _newsAlertImageUrl; } set { _newsAlertImageUrl = value; } }
        public String newsAlertAltImage { get { return _newsAlertAltImage; } set { _newsAlertAltImage = value; } }
        public DateTime? newsAlertCreatedOn { get { return _newsAlertCreatedOn; } set { _newsAlertCreatedOn = value; } }
        public String newsAlertCreatedBy { get { return _newsAlertCreatedBy; } set { _newsAlertCreatedBy = value; } }
        public DateTime? newsAlertModifiedOn { get { return _newsAlertModifiedOn; } set { _newsAlertModifiedOn = value; } }
        public String newsAlertModifiedBy { get { return _newsAlertModifiedBy; } set { _newsAlertModifiedBy = value; } }

    }
}