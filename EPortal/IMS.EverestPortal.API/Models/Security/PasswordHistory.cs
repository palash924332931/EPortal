using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("PasswordHistory")]
    public class PasswordHistory
    {
        public int ID { get; set; }
        public int UserID { get; set; }
        public string Password { get; set; }
        public DateTime CreatedDate { get; set; }
        public virtual User user { get; set; }
    }
}