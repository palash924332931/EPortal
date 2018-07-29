using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("UserRole")]
    public class UserRole
    {
        [Key]
        public int UserRolesID { get; set; }
        public int UserID { get; set; }
        public int RoleID { get; set; }

        public virtual Role role { get; set; }
        public virtual User user { get; set; }
    }
}