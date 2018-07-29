using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class ClientMarketBases
    {
        public ClientMarketBases()
        {

        }
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public int ClientId { get; set; }
        [DataMember]
        public int MarketBaseId { get; set; }

    }
}
