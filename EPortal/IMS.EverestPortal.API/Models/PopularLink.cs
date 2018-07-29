using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMS.EverestPortal.API.Models
{
    public class PopularLink
    {
        private int _popularLinkId;
        private string _popularLinkTitle;
        private string _popularLinkDescription;
        private short _popularLinkDisplayOrder;
        private DateTime? _popularLinkCreatedOn;
        private string _popularLinkCreatedBy;
        private DateTime? _popularLinkModifiedOn;
        private string _popularLinkModifiedBy;

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 popularLinkId { get { return _popularLinkId; } set { _popularLinkId = value; } }
        public String popularLinkTitle { get { return _popularLinkTitle; } set { _popularLinkTitle = value; } }
        public String popularLinkDescription { get { return _popularLinkDescription; } set { _popularLinkDescription = value; } }
        public short popularLinkDisplayOrder { get { return _popularLinkDisplayOrder; } set { _popularLinkDisplayOrder = value; } }
        public DateTime? popularLinkCreatedOn { get { return _popularLinkCreatedOn; } set { _popularLinkCreatedOn = value; } }
        public String popularLinkCreatedBy { get { return _popularLinkCreatedBy; } set { _popularLinkCreatedBy = value; } }
        public DateTime? popularLinkModifiedOn { get { return _popularLinkModifiedOn; } set { _popularLinkModifiedOn = value; } }
        public String popularLinkModifiedBy { get { return _popularLinkModifiedBy; } set { _popularLinkModifiedBy = value; } }

    }
}