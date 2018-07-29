using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("ClientPackException")]
    public class ClientPackException
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public int? PackExceptionId { get; set; }
        public bool ProductLevel { get; set; }

        public DateTime? ExpiryDate { get; set; }
        public virtual Client client { get; set; }
    }
}