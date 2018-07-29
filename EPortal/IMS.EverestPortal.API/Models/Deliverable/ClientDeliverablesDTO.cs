using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    public class ClientDeliverablesDTO
    {
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public bool isMyClient { get; set; }

        public DeliverablesDTO deliverables { get; set; }
        public List<ClientMarketDefDTO> marketDefs { get; set; }
        public List<ClientTerritoryDTO> territories { get; set; }
        public List<ClientDTO> clients { get; set; }
    }
    public class ClientDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsThirdparty { get; set; }
        public bool isDeleted { get; set; }
    }
    public class ClientMarketDefDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int clientId { get; set; }
        public List<MarketBaseDTO> marketBaseDTOs { get; set; }
        public bool isDeleted { get; set; }
    }
    public class MarketBaseDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string DurationFrom { get; set; }
        public string DurationTo { get; set; }
    }
    public class ClientTerritoryDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string TerritoryBase { get; set; }
        public int clientId { get; set; }
        public bool isDeleted { get; set; }
        //public bool IsUsed { get; set; }
    }
    public class DeliverablesDTO
    {
        public int ClientId { get; set; }
        public string ClientName { get; set; }

        public int DeliverableId { get; set; }
        public int DeliveryTypeId { get; set; }
        public String DisplayName { get; set; }
        public int SubscriptionId { get; set; }
        public int ReportWriterId { get; set; }
        public string ReportWriterName { get; set; }
        public int FrequencyTypeId { get; set; }
        public int? RestrictionId { get; set; }
        public string RestrictionName { get; set; }
        public int PeriodId { get; set; }
        public string PeriodName { get; set; }
        public int? FrequencyId { get; set; }
        public string FrequencyName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool? probe { get; set; }
        public bool? PackException { get; set; }
        public bool? Census { get; set; }
        public bool? OneKey { get; set; }
        public bool IsProbeAvailable { get; set; }
        public bool IsPackExcAvailable { get; set; }
        public bool IsCensusAvailable { get; set; }
        public bool IsOneKeyAvailable { get; set; }
        public DateTime LastModified { get; set; }
        public int ModifiedBy { get; set; }
        public int SubServiceTerritoryId { get; set; }
        public bool? Mask { get; set; }
        public List<ClientMarketDefDTO> marketDefs { get; set; }
        public List<ClientTerritoryDTO> territories { get; set; }
        public List<ClientDTO> clients { get; set; }
        public string LockType { get; set; }
        public string Submitted { get; set; }

        public int? ReportNo { get; set; }

        public List<SubChannelsDTO> SubChannelsDTO { get; set; }
    }
    public class SubscriptionDTO
    {
        public int SubscriptionId { get; set; }
        public string Name { get; set; }

        public int ClientId { get; set; }
        public string CountryId { get; set; }
        public string ServiceId { get; set; }
        public string DataTypeId { get; set; }
        public string SourceId { get; set; }
        public string Country { get; set; }
        public string Service { get; set; }
        public string Data { get; set; }
        public string Source { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        //public int ServiceTerritoryId { get; set; }
        public bool Active { get; set; }
        public DateTime LastModified { get; set; }
        public int ModifiedBy { get; set; }
        public string DisplayName
        {
            get
            {
                return this.Country + " " + Service + " " + Data + " " + Source;
            }
            set
            {
                value = this.Country + " " + Service + " " + Data + " " + Source;
            }
        }
        //public virtual MarketBase MarketBase { get; set; }

        //public virtual Client client { get; set; }
        //public virtual ServiceTerritory serviceTerritory { get; set; }


    }
    public class RestrictionDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}