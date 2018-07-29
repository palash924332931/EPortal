using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("PeriodForFrequency")]
    public class PeriodForFrequency
    {
        [Key, Column(Order = 0)]
        public int FrequencyTypeId { get; set; }
        [Key, Column(Order = 1)]
        public int PeriodId { get; set; }
    }
}