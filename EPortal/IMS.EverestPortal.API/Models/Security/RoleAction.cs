using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("RoleAction")]
    public class RoleAction
    {
        public int RoleActionID { get; set; }
        public int RoleID { get; set; }
        public int ActionID { get; set; }
        public int AccessPrivilegeID { get; set; }

        public virtual Role role { get; set; }
        public virtual Action action { get; set; }
        public virtual AccessPrivilege accessPrivilage { get; set; }
    }
}