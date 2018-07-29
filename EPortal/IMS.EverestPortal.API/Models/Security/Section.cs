using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("Section")]
    public class Section
    {
        public int SectionID { get; set; }
        public string SectionName { get; set; }
        public bool IsActive { get; set; }
    }
}