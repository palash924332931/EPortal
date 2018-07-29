using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class MonthlyNewProduct
    {
        private int _monthlyNewProductId;
        private string _monthlyNewProductTitle;
        private string _monthlyNewProductDescription;
        private string _monthlyNewProductFileUrl;
        private DateTime? _monthlyNewProductCreatedOn;
        private string _monthlyNewProductCreatedBy;
        private DateTime? _monthlyNewProductModifiedOn;
        private string _monthlyNewProductModifiedBy;

        public int monthlyNewProductId { get { return _monthlyNewProductId; } set { _monthlyNewProductId = value; } }
        public String monthlyNewProductTitle { get { return _monthlyNewProductTitle; } set { _monthlyNewProductTitle = value; } }
        public String monthlyNewProductDescription { get { return _monthlyNewProductDescription; } set { _monthlyNewProductDescription = value; } }
        public String monthlyNewProductFileUrl { get { return _monthlyNewProductFileUrl; } set { _monthlyNewProductFileUrl = value; } }
        public DateTime? monthlyNewProductCreatedOn { get { return _monthlyNewProductCreatedOn; } set { _monthlyNewProductCreatedOn = value; } }
        public String monthlyNewProductCreatedBy { get { return _monthlyNewProductCreatedBy; } set { _monthlyNewProductCreatedBy = value; } }
        public DateTime? monthlyNewProductModifiedOn { get { return _monthlyNewProductModifiedOn; } set { _monthlyNewProductModifiedOn = value; } }
        public String monthlyNewProductModifiedBy { get { return _monthlyNewProductModifiedBy; } set { _monthlyNewProductModifiedBy = value; } }

    }
}