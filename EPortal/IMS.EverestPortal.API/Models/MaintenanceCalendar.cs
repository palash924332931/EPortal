using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class MaintenanceCalendar
    {
        public int ID { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public DateTime? Schedule_From { get; set; }
        public DateTime? Schedule_To { get; set; }
        public DateTime? ActionDate { get; set; }
    }
}