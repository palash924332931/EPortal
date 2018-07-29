using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("ClientMFR")]
    public class ClientMFR
    {
        
        public int Id { get; set; }
        public int  ClientId { get; set; }

        public int? MFRId { get; set; }
        
        public virtual Client client { get; set; }
    }
}