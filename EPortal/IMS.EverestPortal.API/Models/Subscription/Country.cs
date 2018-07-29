using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("Country")]
    public class Country
    {
        public int CountryId { get; set; }
        public string Name { get; set; }
        public string ISOCode { get; set; }
    }
}