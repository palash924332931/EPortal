using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("Action")]
    public class Action
    {
        public int ActionID { get; set; }
        public string ActionName { get; set; }
        public bool IsActive { get; set; }
        public int ModuleID { get; set; }

        public virtual Module module { get; set; }
    }
}