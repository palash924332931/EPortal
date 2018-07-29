using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class CADPage
    {
        private int _cadPageId;
        private string _cadPageTitle;
        private string _cadPageDescription;
        private string _cadPagePharmacyFileUrl;
        private string _cadPageHospitalFileUrl;
        private DateTime? _cadPageCreatedOn;
        private string _cadPageCreatedBy;
        private DateTime? _cadPageModifiedOn;
        private string _cadPageModifiedBy;

        public int cadPageId { get { return _cadPageId; } set { _cadPageId = value; } }
        public String cadPageTitle { get { return _cadPageTitle; } set { _cadPageTitle = value; } }
        public String cadPageDescription { get { return _cadPageDescription; } set { _cadPageDescription = value; } }
        public String cadPagePharmacyFileUrl { get { return _cadPagePharmacyFileUrl; } set { _cadPagePharmacyFileUrl = value; } }
        public String cadPageHospitalFileUrl { get { return _cadPageHospitalFileUrl; } set { _cadPageHospitalFileUrl = value; } }
        public DateTime? cadPageCreatedOn { get { return _cadPageCreatedOn; } set { _cadPageCreatedOn = value; } }
        public String cadPageCreatedBy { get { return _cadPageCreatedBy; } set { _cadPageCreatedBy = value; } }
        public DateTime? cadPageModifiedOn { get { return _cadPageModifiedOn; } set { _cadPageModifiedOn = value; } }
        public String cadPageModifiedBy { get { return _cadPageModifiedBy; } set { _cadPageModifiedBy = value; } }

    }
}