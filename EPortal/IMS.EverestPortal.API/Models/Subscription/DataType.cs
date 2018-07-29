using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("DataType")]
    public class DataType
    {
        public int DataTypeId { get; set; }
        public string Name { get; set; }
        public bool IsChannel { get; set; }
    }
}