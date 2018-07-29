using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Email
    {
        public string contentType { get; set; }
        public string link { get; set; }
        public string fileName { get; set; }
        public string contentDesc { get; set; }
    };
}