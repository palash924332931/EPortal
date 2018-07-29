using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("FileType")]
    public class FileType
    {
        public int FileTypeId { get; set; }
        public string Name { get; set; }
    }
}