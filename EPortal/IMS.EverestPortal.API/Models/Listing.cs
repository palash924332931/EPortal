using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Listing
    {
        private int _listingId;
        private string _listingTitle;
        private string _listingDescription;
        private string _listingPharmacyFileUrl;
        private string _listingHospitalFileUrl;
        private DateTime? _listingCreatedOn;
        private string _listingCreatedBy;
        private DateTime? _listingModifiedOn;
        private string _listingModifiedBy;

        public int listingId { get { return _listingId; } set { _listingId = value; } }
        public String listingTitle { get { return _listingTitle; } set { _listingTitle = value; } }
        public String listingDescription { get { return _listingDescription; } set { _listingDescription = value; } }
        public String listingPharmacyFileUrl { get { return _listingPharmacyFileUrl; } set { _listingPharmacyFileUrl = value; } }
        public String listingHospitalFileUrl { get { return _listingHospitalFileUrl; } set { _listingHospitalFileUrl = value; } }
        public DateTime? listingCreatedOn { get { return _listingCreatedOn; } set { _listingCreatedOn = value; } }
        public String listingCreatedBy { get { return _listingCreatedBy; } set { _listingCreatedBy = value; } }
        public DateTime? listingModifiedOn { get { return _listingModifiedOn; } set { _listingModifiedOn = value; } }
        public String listingModifiedBy { get { return _listingModifiedBy; } set { _listingModifiedBy = value; } }

    }
}