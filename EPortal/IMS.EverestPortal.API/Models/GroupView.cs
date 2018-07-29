using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class GroupViewList
    {
        public int Id { get; set; }
        public int AttributeId { get; set; }
        public int ParentId { get; set; }
        public int GroupId { get; set; }
        public bool IsAttribute { get; set; }
        public string GroupName { get; set; }
        public string AttributeName { get; set; }
        public int OrderNo { get; set; }
        public int MarketDefinitionId { get; set; }
        public int GroupOrderNo { get; set; }
    }

}