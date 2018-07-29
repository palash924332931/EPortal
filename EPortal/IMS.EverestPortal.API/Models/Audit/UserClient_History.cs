using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class UserClient_History
    {

        public int Id { get; set; }
        public int UserID { get; set; }
        public int UserVersion { get; set; }
        public int ClientID { get; set; }
        [ForeignKey("UserID,UserVersion")]
        public virtual User_History user { get; set; }
    }
}