using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class LockedDefinition
    {
        public string Module { get; set; }
        public string Name { get; set; }
        public int? ID { get; set; }
        public int LockHistoryID { get; set; }
        public string LockedBy { get; set; }
        public DateTime? LockedTime { get; set; }
    }
}