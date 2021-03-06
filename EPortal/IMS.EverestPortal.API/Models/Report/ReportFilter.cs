﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace IMS.EverestPortal.API.Models.Report
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("ReportFilters")]
    public partial class ReportFilter
    {

        [Key]
        [Required]
        public int FilterID { get; set; }
        public string FilterName { get; set; }
        public string FilterType { get; set; }
        public string FilterDescription { get; set; }
        public string SelectedFields { get; set; }
        public Nullable<int> ModuleID { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }

      }
    }

