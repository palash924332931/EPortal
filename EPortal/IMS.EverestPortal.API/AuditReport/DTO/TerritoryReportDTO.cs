using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class TerritoryReportDTO
    {
        public List<TerritoryChangeDTO> TerritoryDefinitionChanges { get; set; }
        public List<TerritoryAllocationChangeDTO> TerritoryAllocationChanges { get; set; }
        public List<TerritoryGroupChangeDTO> TerritoryGroupChanges { get; set; }
    }

    public class TerritoryGroupChangeDTO
    {
        public string GroupNames { get; set; }
        public string ID { get; set; }
        public string ParentGroups { get; set; }
        public string Action { get; set; }
        public int VersionNumber { get; set; }
        public string SubmittedBy { get; set; }
        public string DateTime { get; set; }

    }

    public class TerritoryChangeDTO
    {
        public string TerritoryDefinitionName { get; set; }
        public string SRAClient { get; set; }
        public string SRASuffix { get; set; }
        public string LD { get; set; }
        public string AD { get; set; }        

        public int VersionNumber { get; set; }
        public string SubmittedBy { get; set; }
        public string DateTime { get; set; }
        //public int BrickOutletDeleted { get; set; }
        //public int BrickOutletAdded { get; set; }

    }

    public class TerritoryAllocationChangeDTO
    {
        public string BrickOrOutletCode { get; set; }
        public string BrickOrOutletName { get; set; }
        public string Group { get; set; }
        public string ParentGroups { get; set; }
        public string ID { get; set; }
        public string Action { get; set; }
        public int VersionNumber { get; set; }
        public string SubmittedBy { get; set; }
        public string DateTime { get; set; }
    }
}