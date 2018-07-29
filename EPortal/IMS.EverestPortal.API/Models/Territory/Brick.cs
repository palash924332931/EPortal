using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Territory
{
    [Table("tblBrick")]
    public class Brick
    {
        [Column("Brick")]
        public string BrickId { get; set; }
        [Column("BrickName")]
        public string BrickName { get; set; }
        [Column("Address")]
        public string Address { get; set; }
    }
}