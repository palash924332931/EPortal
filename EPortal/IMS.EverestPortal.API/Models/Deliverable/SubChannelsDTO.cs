using IMS.EverestPortal.API.Models.Subscription;
using System.Collections.Generic;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    public class SubChannelsDTO
    {
        public List<EntityType> EntityTypes { get; set; }
        public DataType DataType { get; set; }
    }
}