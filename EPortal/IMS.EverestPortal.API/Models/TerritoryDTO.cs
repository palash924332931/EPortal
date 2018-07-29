using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class TerritoryDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Client_Id { get; set; }
        public Boolean IsBrickBased { get; set; }
        public Boolean IsUsed { get; set; }
        public string SRA_Client { get; set; }
        public string SRA_Suffix { get; set; }
        public string LD { get; set; }
        public string AD { get; set; }
        public string GuiId { get; set; }
        public Int32? DimensionID { get; set; }
        //public DateTime? LastSaved { get; set; }
        public string Submitted { get; set; }
    }
}