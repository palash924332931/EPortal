using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("AccessPrivilege")]
    public class AccessPrivilege
    {
        public int AccessPrivilegeID { get; set; }
        public string AccessPrivilegeName { get; set; }
        public bool Active { get; set; }
    }
}