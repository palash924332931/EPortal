using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("ResetToken")]
    public class ResetToken
    {
        public int ID { get; set; }
        public int UserID { get; set; }
        public string Token { get; set; }
        public DateTime ExpiryDate { get; set; }
        public virtual User user { get; set; }
    }
}