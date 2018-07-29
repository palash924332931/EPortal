using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("EntityType")]
    public class EntityType
    {
        [Key]
        public int EntityTypeId { get; set; }
        [Required]
        [MaxLength(50)]
        public string EntityTypeCode { get; set; }
        [Required]
        [MaxLength(200)]
        public string EntityTypeName { get; set; }
        public int? DataTypeId { get; set; }
        [Required]
        [MaxLength(50)]
        public string Abbrev { get; set; }
        [Required]
        [MaxLength(200)]
        public string Display { get; set; }
        [Required]
        [MaxLength(200)]
        public string Description { get; set; }
        [Required]
        public bool IsActive { get; set; }
        [NotMapped]
        public bool IsSelected { get; set; }
    }
}