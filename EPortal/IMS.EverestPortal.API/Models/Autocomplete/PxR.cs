using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Autocomplete
{
    public class PxR
    {
        public int Id { get; set; }
        public int MarketbaseId { get; set; }
        public string MarketCode { get; set; }
        public string MarketName { get; set; }
    }
}