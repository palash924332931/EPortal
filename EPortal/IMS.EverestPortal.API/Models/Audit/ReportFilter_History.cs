using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("ReportFilters_History")]
    public partial class ReportFilter_History
    {

        [Key]
        [Required]
        public int FilterID { get; set; }
        public int Version { get; set; }
        public string FilterName { get; set; }
        public string FilterType { get; set; }
        public string FilterDescription { get; set; }
        public string SelectedFields { get; set; }
        public Nullable<int> ModuleID { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        //[DataMember]
        public int UserId { get; set; }
        //[DataMember]
        public bool? IsSentToTDW { get; set; }
        //[DataMember]
        public DateTime? TDWTransferDate { get; set; }
        //[DataMember]
        public int? TDWUserId { get; set; }
    }
}