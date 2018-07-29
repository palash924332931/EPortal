using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    public class ClientSubscriptionDTO
    {
        //public int SubscriptionId { get; set; }
        //public string Name { get; set; }
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        //public bool isMyClient { get; set; }
        //public string Service { get; set; }
        //public string Data { get; set; }
        //public string Source { get; set; }
        //public DateTime StartDate { get; set; }
        //public DateTime EndDate { get; set; }
        //public bool Active { get; set; }
        //public DateTime LastModified { get; set; }
        //public int ModifiedBy { get; set; }
        public SubscriptionDTO subscription { get; set; }
        public List<MarketBase> MarketBase { get; set; }

        public List<ClientMarketBaseDTO> MarkeBaseDto { get; set; }

    }

    public class ClientMarketBaseDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        
        public string Suffix { get; set; }
        public string Submitted { get; set; }
    }
    public class ClientMarketBase
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public int MarketBaseId { get; set; }
        public string MarketBaseName { get; set; }
        public string Description { get; set; }
        public int BaseFilterId { get; set; }
        public string Name { get; set; }
        public string BaseFilterName { get; set; }
        public string BaseFilterCriteria { get; set; }
        public string Values { get; set; }
        public string BaseFilterValues { get; set; }
        public bool BaseFilterIsEnabled { get; set; }
        public string DurationFrom { get; set; }
        public string DurationTo { get; set; }
     
    }
    public class SubscriptionDTO
    {
        public int SubscriptionId { get; set; }
        public string Name { get; set; }
        public int ClientId { get; set; }
        public int CountryId { get; set; }
        public int ServiceId { get; set; }
        public int DataTypeId { get; set; }
        public int SourceId { get; set; }
        public string Country { get; set; }
        public string Service { get; set; }
        public string Data { get; set; }
        public string Source { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int ServiceTerritoryId { get; set; }
        public bool Active { get; set; }
        public DateTime LastModified { get; set; }
        public int ModifiedBy { get; set; }

        public virtual ServiceTerritory serviceTerritory { get; set; }
        public string Submitted { get; set; }
        public bool Selected { get; set; }
    }
}