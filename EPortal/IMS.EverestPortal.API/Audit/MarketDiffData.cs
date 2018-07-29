using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class MarketDiffData
    {
        public string MarketDef { get; set; }
        public List<Difference> DiffMarketDeff { get; set; }

        public List<MarketDataPack> DiffMarketPack { get; set; }
    }

    public class MarketDataPack
    {
        public string PackName { get; set; }
        public string PFC { get; set; }
        public List<Difference> DiffMarketPack { get; set; }
    }
}