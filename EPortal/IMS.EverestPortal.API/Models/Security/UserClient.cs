using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("UserClient")]
    public class UserClient
    {
        public int UserClientID { get; set; }
        public int UserID { get; set; }
        public int ClientID { get; set; }

        public virtual User user { get; set; }
        public virtual Client client { get; set; }
    }
}