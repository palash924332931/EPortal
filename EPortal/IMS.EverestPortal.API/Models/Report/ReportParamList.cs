using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Report
{
    [Table("DIMProduct_Expanded")]
    public partial class ReportParamList
    {
        [Key]
        [Column(Order = 0)]

        public int PackID { get; set; }

        public int? Prod_cd { get; set; }

        public short? Pack_cd { get; set; }

        [Key]
        [Column(Order = 1)]
        public string PFC { get; set; }

        public string ProductName { get; set; }

        public string Product_Long_Name { get; set; }

        public string Pack_Description { get; set; }

        public string Pack_Long_Name { get; set; }

        public int? FCC { get; set; }

        public string ATC1_Code { get; set; }

        public string ATC1_Desc { get; set; }

        public string ATC2_Code { get; set; }

        public string ATC2_Desc { get; set; }

        public string ATC3_Code { get; set; }

        public string ATC3_Desc { get; set; }

        public string ATC4_Code { get; set; }

        public string ATC4_Desc { get; set; }

        public string NEC1_Code { get; set; }

        public string NEC1_Desc { get; set; }

        public string NEC1_LongDesc { get; set; }

        public string NEC2_Code { get; set; }

        public string NEC2_desc { get; set; }

        public string NEC2_LongDesc { get; set; }

        public string NEC3_Code { get; set; }

        public string NEC3_Desc { get; set; }

        public string NEC3_LongDesc { get; set; }

        public string NEC4_Code { get; set; }

        public string NEC4_Desc { get; set; }

        public string NEC4_LongDesc { get; set; }

        public string CH_Segment_Code { get; set; }

        public string CH_Segment_Desc { get; set; }

        public string WHO1_Code { get; set; }

        public string WHO1_Desc { get; set; }

        public string WHO2_Code { get; set; }

        public string WHO2_Desc { get; set; }

        public string WHO3_Code { get; set; }

        public string WHO3_Desc { get; set; }

        public string WHO4_Code { get; set; }

        public string WHO4_Desc { get; set; }

        public string WHO5_Code { get; set; }

        public string WHO5_Desc { get; set; }

        public string FRM_Flgs1 { get; set; }

        public string FRM_Flgs1_Desc { get; set; }

        public string FRM_Flgs2 { get; set; }

        public string FRM_Flgs2_Desc { get; set; }

        public string FRM_Flgs3 { get; set; }

        public string Frm_Flgs3_Desc { get; set; }

        public string FRM_Flgs4 { get; set; }

        public string FRM_Flgs4_Desc { get; set; }

        public string FRM_Flgs5 { get; set; }

        public string FRM_Flgs5_Desc { get; set; }

        public string FRM_Flgs6 { get; set; }

        public string Compound_Indicator { get; set; }

        public string Compound_Ind_Desc { get; set; }

        public string PBS_Formulary { get; set; }

        public DateTime? PBS_Formulary_Date { get; set; }

        public string Poison_Schedule { get; set; }

        public string Poison_Schedule_Desc { get; set; }

        public string Stdy_Ind1_Code { get; set; }

        public string Study_Indicators1 { get; set; }

        public string Stdy_Ind2_Code { get; set; }

        public string Study_Indicators2 { get; set; }

        public string Stdy_Ind3_Code { get; set; }

        public string Study_Indicators3 { get; set; }

        public string Stdy_Ind4_Code { get; set; }

        public string Study_Indicators4 { get; set; }

        public string Stdy_Ind5_Code { get; set; }

        public string Study_Indicators5 { get; set; }

        public string Stdy_Ind6_Code { get; set; }

        public string Study_Indicators6 { get; set; }

        public DateTime? PackLaunch { get; set; }

        public DateTime? Prod_lch { get; set; }

        public int? Org_Code { get; set; }

        public string Org_Abbr { get; set; }

        public string Org_Short_Name { get; set; }

        public string Org_Long_Name { get; set; }

        public DateTime? Out_td_dt { get; set; }

        public int? pk_size { get; set; }

        public float? vol_wt_uns { get; set; }

        public string vol_wt_meas { get; set; }

        public float? strgh_uns { get; set; }

        public string strgh_meas { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? Conc_Unit { get; set; }

        public string Conc_Meas { get; set; }

        public string Additional_Strength { get; set; }

        public string Additional_Pack_Info { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? Recommended_Retail_Price { get; set; }

       
        public decimal? Prtd_Price { get; set; }

        public DateTime? Ret_Price_Effective_Date { get; set; }

        public string Editable_Pack_Description { get; set; }

        public string APN { get; set; }

        public string Trade_Product_Pack_ID { get; set; }

        public string Form_Desc_Abbr { get; set; }

        public string Form_Desc_Short { get; set; }

        public string Form_Desc_Long { get; set; }

        public string NFC1_Code { get; set; }

        public string NFC1_Desc { get; set; }

        public string NFC2_Code { get; set; }

        public string NFC2_Desc { get; set; }

        public string NFC3_Code { get; set; }

        public string NFC3_Desc { get; set; }

        public DateTime? Price_Effective_Date { get; set; }

        public DateTime? Last_amd { get; set; }

        public DateTime? PBS_Start_Date { get; set; }

        public DateTime? PBS_End_Date { get; set; }

        public decimal? Supplier_Code { get; set; }

        public string Supplier_Product_Code { get; set; }

        public string CHANGE_FLAG { get; set; }

        public DateTime? TIME_STAMP { get; set; }
    }
}