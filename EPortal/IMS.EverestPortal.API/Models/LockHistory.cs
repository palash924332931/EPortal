using IMS.EverestPortal.API.Models.Security;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class LockHistory
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public int DefId { get; set; }
        [DataMember]
        public string DocType { get; set; }
        [DataMember]
        public string LockType { get; set; }
        [DataMember]
        public DateTime? LockTime { get; set; }
        [DataMember]
        public DateTime? ReleaseTime { get; set; }
        [DataMember]
        public string Status { get; set; }
        [DataMember]
        public int UserId { get; set; }
        [NotMapped]
        public string UserName { get; set; }
        public virtual User user { get; set; }
    }
}