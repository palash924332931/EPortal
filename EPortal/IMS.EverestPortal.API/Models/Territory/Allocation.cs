using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Territory
{
    public class Allocation
    {
        public int Id { get; set;}
        //outlets or bricks
        public ICollection<Outlet> Outlets { get; set; }
        public Group Leaf { get; set; }

    }
}