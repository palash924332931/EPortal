using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Grouping
{
    public class MarketGroupMapping
    {
        [DataMember]
        public int Id { get; set; }

        [DataMember]
        public int ParentId { get; set; }
        [DataMember]
        public int GroupId { get; set; }
        [DataMember]
        public bool IsAttribute { get; set; }
    }
}