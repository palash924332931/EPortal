using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("ClientRelease")]
    public class ClientRelease
    {
        public int Id { get; set; }
        public int  ClientId { get; set; }

        public bool? CapitalChemist { get; set; }

        public bool? Census { get; set; }

        public bool? OneKey { get; set; }

        public virtual Client client { get; set; }
    }
}