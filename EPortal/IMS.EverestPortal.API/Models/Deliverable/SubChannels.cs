using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("SubChannels")]
    public class SubChannels
    {
        [Key]
        [Column(Order = 1)]
        public int DeliverableId { get; set; }
        [Key]
        [Column(Order = 2)]
        public int EntityTypeId { get; set; }
    }
}