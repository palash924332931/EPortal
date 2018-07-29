using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("Module")]
    public class Module
    {
        public int ModuleID { get; set; }
        public string ModuleName { get; set; }
        public bool IsActive { get; set; }
        public int SectionID { get; set; }

        public virtual Section section { get; set; }
    }
}