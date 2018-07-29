using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Filter
    {
        public string Criteria { get; set; }
        public string Value { get; set; }

        public string Condition { get; set; }
    }

    public class Options
    {
        public ICollection<Filter> filterOptions { get; set; }

        public string[] exportOptions { get; set; }

        public string Type { get; set; }


    }

    public class RequestAllocation
    {       
        public IEnumerable<int> Users { get; set; }
        public IEnumerable<int> Clients { get; set; }
        public IEnumerable<int> ReallocatedUsers { get; set; }
        public IEnumerable<int> ReallocatedClients { get; set; }

        public int ActionUser { get; set; }

    };

    public class RequestRelease
    {
        public string Description { get; set; }

        public Pagination Pagination { get; set; }

        public IEnumerable<ReleasePack> Packs { get; set; }
        public IEnumerable<ReleaseClient> Clients { get; set; }
        public IEnumerable<int> Mfrs { get; set; }

        public ReleaseClient Client { get; set; }

    }

    public class ReleaseClient
    {
        public int clientId { get; set; }
        public string clientName { get; set; }
        public bool OneKey { get; set; }
        public bool CapitalChemist { get; set; }
        public bool Census { get; set; }
        public int MfrCount { get; set; }
        public int packCount { get; set; }
        public bool isMyClient { get; set; }
    }

    public class ReleasePack
    {
        public int Id { get; set; }
       
        public bool ProductLevel { get; set; }

        public string ProductName { get; set; }

        public string ProductGroupName { get; set; }

        public string ExpiryDate { get; set; }

    }

    public class Pagination
    {
        public int NoOfItems { get; set; }
        public int CurrentPage { get; set; }
        public int TotalResultCount { get; set; }
    }

    public class ReportConfigParams
    {
        public string tableName { get; set; }
        public string fieldName { get; set; }
        public string fieldValue { get; set; }
        public string filterName { get; set; }
        public Param  parameters { get; set; }

    }

    public class Param
    {
        public int ModuleID { get; set; }
        public List<string> clientIds { get; set; }
        public List<string>  clientNos { get; set; }

        public List<string> TerritoryIds { get; set; }
        public List<string> TerritoryNames { get; set; }


        public List<string> MarketDefIds { get; set; }
        public List<string> MarketDefNames { get; set; }
    }

}