using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Autocomplete
{
    public class Dimension
    {
        public int Id { get; set; }
        public int DimensionId { get; set; }
        public int MarketbaseId { get; set; }
        public string DimensionName { get; set; }
    }
}