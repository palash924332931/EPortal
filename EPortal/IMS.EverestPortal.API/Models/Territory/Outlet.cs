using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Territory
{ 
    [Table("tblOutlet")]
    public class Outlet
    {

        [Column("Outlet")]
        public string OutletId { get; set; }
        [Column("OutletName")]
        public string OutletName { get; set; }
        [Column("Address")]
        public string Address { get; set; }
    }
}