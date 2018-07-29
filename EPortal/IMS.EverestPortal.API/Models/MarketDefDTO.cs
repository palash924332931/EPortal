using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class MarketDefDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int ClientId { get; set; }
        public string GuiId { get; set; }
       // public DateTime? LastSaved { get; set; }
        public string Submitted { get; set; }
    }
}