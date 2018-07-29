using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("UserType")]
    public class UserType
    {
        public int UserTypeID { get; set; }
        public string UserTypeName { get; set; }
        public bool IsActive { get; set; }
    }
}