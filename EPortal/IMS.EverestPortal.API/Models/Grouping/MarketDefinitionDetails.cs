using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Grouping
{
    public class MarketDefinitionDetails
    {
        public MarketDefinition MarketDefinition { get; set; }
        public List<GroupView> GroupView { get; set; }
        public List<MarketGroupPacks> MarketGroupPack { get; set; }

        public List<MarketGroupFilter> MarketGroupFilter { get; set; }
    }
}