using IMS.EverestPortal.API.Common.Extension;
using IMS.EverestPortal.API.Controllers;
using IMS.EverestPortal.API.DAL.Interfaces;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.packSearch;
using IMS.EverestPortal.API.Models.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic;
using System.Text;
using System.Web.Http;

namespace IMS.EverestPortal.API.DAL
{
    public class DIMProductExpanded : IDIMProductExpanded
    {
        public FilterResult<Manufacturer> GetManufacturer([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize)
        {
            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var pagedList = query
                    .Select(a => new Manufacturer()
                    {
                        Org_Code = a.Org_Code ?? 0,
                        Org_Abbr = a.Org_Abbr,
                        Org_Short_Name = a.Org_Short_Name,
                        Org_Long_Name = a.Org_Long_Name
                    })
                    .Where(x => !string.IsNullOrEmpty(x.Org_Abbr) && !string.IsNullOrEmpty(x.Org_Long_Name))
                    .Distinct().OrderBy(x => x.Org_Long_Name).ToPagedList(currentPage, pageSize);

                var result = new FilterResult<Manufacturer>
                {
                    Data = pagedList.ToList(),
                    TotalCount = pagedList.TotalCount,
                    PageCount = pagedList.PageCount,
                    CurrentPage = pagedList.Page,
                    PageSize = pagedList.PageSize
                };

                return result;
            }
        }

        public FilterResult<ReleasePack> GetPackDescription([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize)
        {
            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var pagedList = query
                            .Select(a => new ReleasePack()
                            {
                                Id = a.FCC ?? 0,
                                ProductLevel = false,
                                ProductName = a.Pack_Description,
                                ProductGroupName = a.ProductName,
                                ExpiryDate = null
                            })
                            .Where(x => !string.IsNullOrEmpty(x.ProductName) && !string.IsNullOrEmpty(x.ProductGroupName))
                            .Distinct().OrderBy(x => x.ProductName).ToPagedList(currentPage, pageSize);

                var result = new FilterResult<ReleasePack>
                {
                    Data = pagedList.ToList(),
                    TotalCount = pagedList.TotalCount,
                    PageCount = pagedList.PageCount,
                    CurrentPage = pagedList.Page,
                    PageSize = pagedList.PageSize
                };

                return result;
            }

        }

        public FilterResult<PackDescResult> GetPackDescriptionForAutocomplete([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize)
        {
            string orderName = string.Empty, orderClause = "Pack_Long_Name asc";
            var orderBy = searchParams.FirstOrDefault(x => x.Criteria == "Orderby");
            if (orderBy != null)
            {
                searchParams.Remove(orderBy);
                string[] values = orderBy?.Value.Split(',');
                if (values.Length > 0 && values != null)
                {
                    orderName = values[0].ToString();
                    switch (orderName.ToLower())
                    {
                        case "packdescription": { orderName = "Pack_Long_Name"; break; }
                        case "manufacturer": { orderName = "Org_Long_Name"; break; }
                        case "flagging": { orderName = "FRM_Flgs5_Desc"; break; }
                        case "branding": { orderName = "Frm_Flgs3_Desc"; break; }
                        case "molecule": { orderName = "MOLECULES"; break; }
                        case "pfc": { orderName = "PFC"; break; }
                        case "apn": { orderName = "APN"; break; }
                        case "productname": { orderName = "ProductName"; break; }
                    }
                }
                if (!string.IsNullOrEmpty(orderName))
                    orderClause = orderName + (values[1] == "1" ? " asc" : " desc");
            }

            string whereClause = GetFilterForPacks(searchParams).Replace("product.", "");
            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query;

                if (string.IsNullOrWhiteSpace(whereClause))
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var list = query
                             .Select(a => new PackDescResult()
                             {
                                 PackDescription = a.Pack_Long_Name
                                 //,
                                 //Manufacturer = res.Org_Long_Name,
                                 //ATC = res.ATC4_Desc,
                                 //NEC = res.NEC4_Desc,
                                 //Molecule = res.Molecules,
                                 //Flagging = res.FRM_Flgs5_Desc,
                                 //Branding = res.Frm_Flgs3_Desc
                             })
                             .Where(x => !string.IsNullOrEmpty(x.PackDescription))
                             .Distinct().OrderBy(x => x.PackDescription).ToPagedList(currentPage, pageSize);

                var result = new FilterResult<PackDescResult>
                {
                    Data = list.ToList(),
                    TotalCount = list.TotalCount,
                    PageCount = list.PageCount,
                    CurrentPage = list.Page,
                    PageSize = list.PageSize
                };

                return result;
            }

        }

        public FilterResult<PackResult> GetPacksSearchResult([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize)
        {
            string orderName = string.Empty, orderClause = "Pack_Long_Name asc";
            var orderBy = searchParams.FirstOrDefault(x => x.Criteria == "Orderby");
            if (orderBy != null)
            {
                searchParams.Remove(orderBy);
                string[] values = orderBy?.Value.Split(',');
                if (values.Length > 0 && values != null)
                {
                    orderName = values[0].ToString();
                    switch (orderName.ToLower())
                    {
                        case "packdescription": { orderName = "Pack_Long_Name"; break; }
                        case "manufacturer": { orderName = "Org_Long_Name"; break; }
                        case "flagging": { orderName = "FRM_Flgs5_Desc"; break; }
                        case "branding": { orderName = "Frm_Flgs3_Desc"; break; }
                        case "molecule": { orderName = "MOLECULES"; break; }
                        case "pfc": { orderName = "PFC"; break; }
                        case "apn": { orderName = "APN"; break; }
                        case "productname": { orderName = "ProductName"; break; }
                    }
                }
                if (!string.IsNullOrEmpty(orderName))
                    orderClause = orderName + (values[1] == "1" ? " asc" : " desc");
            }

            string whereClause = GetFilterForPacks(searchParams);

            using (var db = new EverestPortalContext())
            {
                IQueryable<PackSearchModal> query;

                if (string.IsNullOrWhiteSpace(whereClause))
                {
                    query = db.ReportParameters.GroupJoin(db.Molecules,
                           product => product.FCC,
                           molecule => molecule.FCC,
                           (product, molecule) => new { Product = product, Molecule = molecule })
                           .SelectMany(
                            m => m.Molecule.DefaultIfEmpty(),
                            (x, y) => new PackSearchModal { Product = x.Product, Molecule = y });
                }
                else
                {
                    query = db.ReportParameters.GroupJoin(db.Molecules,
                           product => product.FCC,
                           molecule => molecule.FCC,
                           (product, molecule) => new { Product = product, Molecule = molecule })
                           .SelectMany(
                            m => m.Molecule.DefaultIfEmpty(),
                            (x, y) => new PackSearchModal { Product = x.Product, Molecule = y })
                           .Where(whereClause);
                }

                var pageList = query
                    .Select(a => new PackResultSql
                    {
                        Molecules = a.Molecule.Description,
                        PackID = a.Product.PackID,
                        Prod_cd = a.Product.Prod_cd.HasValue ? a.Product.Prod_cd.Value.ToString() : "",
                        Pack_cd = a.Product.Pack_cd.HasValue ? a.Product.Pack_cd.Value.ToString() : "",
                        PFC = a.Product.PFC,
                        ProductName = a.Product.ProductName,
                        Product_Long_Name = a.Product.Product_Long_Name,
                        Pack_Description = a.Product.Pack_Description,
                        Pack_Long_Name = a.Product.Pack_Long_Name,
                        FCC = a.Product.FCC.HasValue ? a.Product.FCC.Value.ToString() : "",
                        ATC1_Code = a.Product.ATC1_Code,
                        ATC1_Desc = a.Product.ATC1_Desc,
                        ATC2_Code = a.Product.ATC2_Code,
                        ATC2_Desc = a.Product.ATC2_Desc,
                        ATC3_Code = a.Product.ATC3_Code,
                        ATC3_Desc = a.Product.ATC3_Desc,
                        ATC4_Code = a.Product.ATC4_Code,
                        ATC4_Desc = a.Product.ATC4_Desc,
                        NEC1_Code = a.Product.NEC1_Code,
                        NEC1_Desc = a.Product.NEC1_Desc,
                        NEC1_LongDesc = a.Product.NEC1_LongDesc,
                        NEC2_Code = a.Product.NEC2_Code,
                        NEC2_desc = a.Product.NEC2_desc,
                        NEC2_LongDesc = a.Product.NEC2_LongDesc,
                        NEC3_Code = a.Product.NEC3_Code,
                        NEC3_Desc = a.Product.NEC3_Desc,
                        NEC3_LongDesc = a.Product.NEC3_LongDesc,
                        NEC4_Code = a.Product.NEC4_Code,
                        NEC4_Desc = a.Product.NEC4_Desc,
                        NEC4_LongDesc = a.Product.NEC4_LongDesc,
                        CH_Segment_Code = a.Product.CH_Segment_Code,
                        CH_Segment_Desc = a.Product.CH_Segment_Desc,
                        WHO1_Code = a.Product.WHO1_Code,
                        WHO1_Desc = a.Product.WHO1_Desc,
                        WHO2_Code = a.Product.WHO2_Code,
                        WHO2_Desc = a.Product.WHO2_Desc,
                        WHO3_Code = a.Product.WHO3_Code,
                        WHO3_Desc = a.Product.WHO3_Desc,
                        WHO4_Code = a.Product.WHO4_Code,
                        WHO4_Desc = a.Product.WHO4_Desc,
                        WHO5_Code = a.Product.WHO5_Code,
                        WHO5_Desc = a.Product.WHO5_Desc,
                        FRM_Flgs1 = a.Product.FRM_Flgs1,
                        FRM_Flgs1_Desc = a.Product.FRM_Flgs1_Desc,
                        FRM_Flgs2 = a.Product.FRM_Flgs2,
                        FRM_Flgs2_Desc = a.Product.FRM_Flgs2_Desc,
                        FRM_Flgs3 = a.Product.FRM_Flgs3,
                        Frm_Flgs3_Desc = a.Product.Frm_Flgs3_Desc,
                        FRM_Flgs4 = a.Product.FRM_Flgs4,
                        FRM_Flgs4_Desc = a.Product.FRM_Flgs4_Desc,
                        FRM_Flgs5 = a.Product.FRM_Flgs5,
                        FRM_Flgs5_Desc = a.Product.FRM_Flgs5_Desc,
                        FRM_Flgs6 = a.Product.FRM_Flgs6,
                        Compound_Indicator = a.Product.Compound_Indicator,
                        Compound_Ind_Desc = a.Product.Compound_Ind_Desc,
                        PBS_Formulary = a.Product.PBS_Formulary,
                        PBS_Formulary_Date = a.Product.PBS_Formulary_Date.HasValue ? a.Product.PBS_Formulary_Date.ToString() : "",
                        Poison_Schedule = a.Product.Poison_Schedule,
                        Poison_Schedule_Desc = a.Product.Poison_Schedule_Desc,
                        Stdy_Ind1_Code = a.Product.Stdy_Ind1_Code,
                        Study_Indicators1 = a.Product.Study_Indicators1,
                        Stdy_Ind2_Code = a.Product.Stdy_Ind2_Code,
                        Study_Indicators2 = a.Product.Study_Indicators2,
                        Stdy_Ind3_Code = a.Product.Stdy_Ind3_Code,
                        Study_Indicators3 = a.Product.Study_Indicators3,
                        Stdy_Ind4_Code = a.Product.Stdy_Ind4_Code,
                        Study_Indicators4 = a.Product.Study_Indicators4,
                        Stdy_Ind5_Code = a.Product.Stdy_Ind5_Code,
                        Study_Indicators5 = a.Product.Study_Indicators5,
                        Stdy_Ind6_Code = a.Product.Stdy_Ind6_Code,
                        Study_Indicators6 = a.Product.Study_Indicators6,
                        PackLaunch = a.Product.PackLaunch,
                        Prod_lch = a.Product.Prod_lch,
                        Org_Code = a.Product.Org_Code,
                        Org_Abbr = a.Product.Org_Abbr,
                        Org_Short_Name = a.Product.Org_Short_Name,
                        Org_Long_Name = a.Product.Org_Long_Name,
                        Out_td_dt = a.Product.Out_td_dt,
                        //Prtd_Price = a.Product.Prtd_Price,
                        pk_size = a.Product.pk_size,
                        vol_wt_uns = a.Product.vol_wt_uns,
                        vol_wt_meas = a.Product.vol_wt_meas,
                        strgh_uns = a.Product.strgh_uns,
                        strgh_meas = a.Product.strgh_meas,
                        Conc_Unit = a.Product.Conc_Unit,
                        Conc_Meas = a.Product.Conc_Meas,
                        Additional_Strength = a.Product.Additional_Strength,
                        Additional_Pack_Info = a.Product.Additional_Pack_Info,
                        Recommended_Retail_Price = a.Product.Recommended_Retail_Price.HasValue ? a.Product.Recommended_Retail_Price.Value.ToString() : "",
                        Ret_Price_Effective_Date = a.Product.Ret_Price_Effective_Date.HasValue ? a.Product.Ret_Price_Effective_Date.Value.ToString() : "",
                        Editable_Pack_Description = a.Product.Editable_Pack_Description,
                        APN = a.Product.APN,
                        Trade_Product_Pack_ID = a.Product.Trade_Product_Pack_ID,
                        Form_Desc_Abbr = a.Product.Form_Desc_Abbr,
                        Form_Desc_Short = a.Product.Form_Desc_Short,
                        Form_Desc_Long = a.Product.Form_Desc_Long,
                        NFC1_Code = a.Product.NFC1_Code,
                        NFC1_Desc = a.Product.NFC1_Desc,
                        NFC2_Code = a.Product.NFC2_Code,
                        NFC2_Desc = a.Product.NFC2_Desc,
                        NFC3_Code = a.Product.NFC3_Code,
                        NFC3_Desc = a.Product.NFC3_Desc,
                        Price_Effective_Date = a.Product.Price_Effective_Date.HasValue ? a.Product.Price_Effective_Date.Value.ToString() : "",
                        Last_amd = a.Product.Last_amd.HasValue ? a.Product.Last_amd.Value.ToString() : "",
                        PBS_Start_Date = a.Product.PBS_Start_Date.HasValue ? a.Product.PBS_Start_Date.Value.ToString() : "",
                        PBS_End_Date = a.Product.PBS_End_Date.HasValue ? a.Product.PBS_End_Date.Value.ToString() : "",
                        Supplier_Code = a.Product.Supplier_Code.HasValue ? a.Product.Supplier_Code.Value.ToString() : "",
                        Supplier_Product_Code = a.Product.Supplier_Product_Code,
                    })
                    .GroupBy(x => new
                    {
                        x.PackID,
                        x.Prod_cd,
                        x.Pack_cd,
                        x.PFC,
                        x.ProductName,
                        x.Product_Long_Name,
                        x.Pack_Description,
                        x.Pack_Long_Name,
                        x.FCC,
                        x.ATC1_Code,
                        x.ATC1_Desc,
                        x.ATC2_Code,
                        x.ATC2_Desc,
                        x.ATC3_Code,
                        x.ATC3_Desc,
                        x.ATC4_Code,
                        x.ATC4_Desc,
                        x.NEC1_Code,
                        x.NEC1_Desc,
                        x.NEC1_LongDesc,
                        x.NEC2_Code,
                        x.NEC2_desc,
                        x.NEC2_LongDesc,
                        x.NEC3_Code,
                        x.NEC3_Desc,
                        x.NEC3_LongDesc,
                        x.NEC4_Code,
                        x.NEC4_Desc,
                        x.NEC4_LongDesc,
                        x.CH_Segment_Code,
                        x.CH_Segment_Desc,
                        x.WHO1_Code,
                        x.WHO1_Desc,
                        x.WHO2_Code,
                        x.WHO2_Desc,
                        x.WHO3_Code,
                        x.WHO3_Desc,
                        x.WHO4_Code,
                        x.WHO4_Desc,
                        x.WHO5_Code,
                        x.WHO5_Desc,
                        x.FRM_Flgs1,
                        x.FRM_Flgs1_Desc,
                        x.FRM_Flgs2,
                        x.FRM_Flgs2_Desc,
                        x.FRM_Flgs3,
                        x.Frm_Flgs3_Desc,
                        x.FRM_Flgs4,
                        x.FRM_Flgs4_Desc,
                        x.FRM_Flgs5,
                        x.FRM_Flgs5_Desc,
                        x.FRM_Flgs6,
                        x.Compound_Indicator,
                        x.Compound_Ind_Desc,
                        x.PBS_Formulary,
                        x.PBS_Formulary_Date,
                        x.Poison_Schedule,
                        x.Poison_Schedule_Desc,
                        x.Stdy_Ind1_Code,
                        x.Study_Indicators1,
                        x.Stdy_Ind2_Code,
                        x.Study_Indicators2,
                        x.Stdy_Ind3_Code,
                        x.Study_Indicators3,
                        x.Stdy_Ind4_Code,
                        x.Study_Indicators4,
                        x.Stdy_Ind5_Code,
                        x.Study_Indicators5,
                        x.Stdy_Ind6_Code,
                        x.Study_Indicators6,
                        x.PackLaunch,
                        x.Prod_lch,
                        x.Org_Code,
                        x.Org_Abbr,
                        x.Org_Short_Name,
                        x.Org_Long_Name,
                        x.Out_td_dt,
                        //x.Product.Prtd_Price,
                        x.pk_size,
                        x.vol_wt_uns,
                        x.vol_wt_meas,
                        x.strgh_uns,
                        x.strgh_meas,
                        x.Conc_Unit,
                        x.Conc_Meas,
                        x.Additional_Strength,
                        x.Additional_Pack_Info,
                        x.Recommended_Retail_Price,
                        x.Ret_Price_Effective_Date,
                        x.Editable_Pack_Description,
                        x.APN,
                        x.Trade_Product_Pack_ID,
                        x.Form_Desc_Abbr,
                        x.Form_Desc_Short,
                        x.Form_Desc_Long,
                        x.NFC1_Code,
                        x.NFC1_Desc,
                        x.NFC2_Code,
                        x.NFC2_Desc,
                        x.NFC3_Code,
                        x.NFC3_Desc,
                        x.Price_Effective_Date,
                        x.Last_amd,
                        x.PBS_Start_Date,
                        x.PBS_End_Date,
                        x.Supplier_Code,
                        x.Supplier_Product_Code
                    })
                    .Select(a => new
                    {
                        Molecules = a.Select(x => x.Molecules).ToList(),
                        PackID = a.Key.PackID,
                        Pack_cd = a.Key.Pack_cd,
                        PFC = a.Key.PFC,
                        ProductName = a.Key.ProductName,
                        Product_Long_Name = a.Key.Product_Long_Name,
                        Pack_Description = a.Key.Pack_Description,
                        Pack_Long_Name = a.Key.Pack_Long_Name,
                        FCC = a.Key.FCC,
                        ATC1_Code = a.Key.ATC1_Code,
                        ATC1_Desc = a.Key.ATC1_Desc,
                        ATC2_Code = a.Key.ATC2_Code,
                        ATC2_Desc = a.Key.ATC2_Desc,
                        ATC3_Code = a.Key.ATC3_Code,
                        ATC3_Desc = a.Key.ATC3_Desc,
                        ATC4_Code = a.Key.ATC4_Code,
                        ATC4_Desc = a.Key.ATC4_Desc,
                        NEC1_Code = a.Key.NEC1_Code,
                        NEC1_Desc = a.Key.NEC1_Desc,
                        NEC1_LongDesc = a.Key.NEC1_LongDesc,
                        NEC2_Code = a.Key.NEC2_Code,
                        NEC2_desc = a.Key.NEC2_desc,
                        NEC2_LongDesc = a.Key.NEC2_LongDesc,
                        NEC3_Code = a.Key.NEC3_Code,
                        NEC3_Desc = a.Key.NEC3_Desc,
                        NEC3_LongDesc = a.Key.NEC3_LongDesc,
                        NEC4_Code = a.Key.NEC4_Code,
                        NEC4_Desc = a.Key.NEC4_Desc,
                        NEC4_LongDesc = a.Key.NEC4_LongDesc,
                        CH_Segment_Code = a.Key.CH_Segment_Code,
                        CH_Segment_Desc = a.Key.CH_Segment_Desc,
                        WHO1_Code = a.Key.WHO1_Code,
                        WHO1_Desc = a.Key.WHO1_Desc,
                        WHO2_Code = a.Key.WHO2_Code,
                        WHO2_Desc = a.Key.WHO2_Desc,
                        WHO3_Code = a.Key.WHO3_Code,
                        WHO3_Desc = a.Key.WHO3_Desc,
                        WHO4_Code = a.Key.WHO4_Code,
                        WHO4_Desc = a.Key.WHO4_Desc,
                        WHO5_Code = a.Key.WHO5_Code,
                        WHO5_Desc = a.Key.WHO5_Desc,
                        FRM_Flgs1 = a.Key.FRM_Flgs1,
                        FRM_Flgs1_Desc = a.Key.FRM_Flgs1_Desc,
                        FRM_Flgs2 = a.Key.FRM_Flgs2,
                        FRM_Flgs2_Desc = a.Key.FRM_Flgs2_Desc,
                        FRM_Flgs3 = a.Key.FRM_Flgs3,
                        Frm_Flgs3_Desc = a.Key.Frm_Flgs3_Desc,
                        FRM_Flgs4 = a.Key.FRM_Flgs4,
                        FRM_Flgs4_Desc = a.Key.FRM_Flgs4_Desc,
                        FRM_Flgs5 = a.Key.FRM_Flgs5,
                        FRM_Flgs5_Desc = a.Key.FRM_Flgs5_Desc,
                        FRM_Flgs6 = a.Key.FRM_Flgs6,
                        Compound_Indicator = a.Key.Compound_Indicator,
                        Compound_Ind_Desc = a.Key.Compound_Ind_Desc,
                        PBS_Formulary = a.Key.PBS_Formulary,
                        PBS_Formulary_Date = a.Key.PBS_Formulary_Date,
                        Poison_Schedule = a.Key.Poison_Schedule,
                        Poison_Schedule_Desc = a.Key.Poison_Schedule_Desc,
                        Stdy_Ind1_Code = a.Key.Stdy_Ind1_Code,
                        Study_Indicators1 = a.Key.Study_Indicators1,
                        Stdy_Ind2_Code = a.Key.Stdy_Ind2_Code,
                        Study_Indicators2 = a.Key.Study_Indicators2,
                        Stdy_Ind3_Code = a.Key.Stdy_Ind3_Code,
                        Study_Indicators3 = a.Key.Study_Indicators3,
                        Stdy_Ind4_Code = a.Key.Stdy_Ind4_Code,
                        Study_Indicators4 = a.Key.Study_Indicators4,
                        Stdy_Ind5_Code = a.Key.Stdy_Ind5_Code,
                        Study_Indicators5 = a.Key.Study_Indicators5,
                        Stdy_Ind6_Code = a.Key.Stdy_Ind6_Code,
                        Study_Indicators6 = a.Key.Study_Indicators6,
                        PackLaunch = a.Key.PackLaunch,
                        Prod_lch = a.Key.Prod_lch,
                        Org_Code = a.Key.Org_Code,
                        Org_Abbr = a.Key.Org_Abbr,
                        Org_Short_Name = a.Key.Org_Short_Name,
                        Org_Long_Name = a.Key.Org_Long_Name,
                        Out_td_dt = a.Key.Out_td_dt,
                        //Prtd_Price = a.Key.Prtd_Price,
                        pk_size = a.Key.pk_size,
                        vol_wt_uns = a.Key.vol_wt_uns,
                        vol_wt_meas = a.Key.vol_wt_meas,
                        strgh_uns = a.Key.strgh_uns,
                        strgh_meas = a.Key.strgh_meas,
                        Conc_Unit = a.Key.Conc_Unit,
                        Conc_Meas = a.Key.Conc_Meas,
                        Additional_Strength = a.Key.Additional_Strength,
                        Additional_Pack_Info = a.Key.Additional_Pack_Info,
                        Recommended_Retail_Price = a.Key.Recommended_Retail_Price,
                        Ret_Price_Effective_Date = a.Key.Ret_Price_Effective_Date,
                        Editable_Pack_Description = a.Key.Editable_Pack_Description,
                        APN = a.Key.APN,
                        Trade_Product_Pack_ID = a.Key.Trade_Product_Pack_ID,
                        Form_Desc_Abbr = a.Key.Form_Desc_Abbr,
                        Form_Desc_Short = a.Key.Form_Desc_Short,
                        Form_Desc_Long = a.Key.Form_Desc_Long,
                        NFC1_Code = a.Key.NFC1_Code,
                        NFC1_Desc = a.Key.NFC1_Desc,
                        NFC2_Code = a.Key.NFC2_Code,
                        NFC2_Desc = a.Key.NFC2_Desc,
                        NFC3_Code = a.Key.NFC3_Code,
                        NFC3_Desc = a.Key.NFC3_Desc,
                        Price_Effective_Date = a.Key.Price_Effective_Date,
                        Last_amd = a.Key.Last_amd,
                        PBS_Start_Date = a.Key.PBS_Start_Date,
                        PBS_End_Date = a.Key.PBS_End_Date,
                        Supplier_Code = a.Key.Supplier_Code,
                        Supplier_Product_Code = a.Key.Supplier_Product_Code
                    })
                    .OrderBy(orderClause)
                    .ToPagedList(currentPage, pageSize);

                var res = pageList.Select(x => new PackResult
                {
                    Molecules = string.Join(" | ", x.Molecules.ToList()),
                    PackID = Convert.ToString(x.PackID),
                    Pack_cd = x.Pack_cd,
                    PFC = x.PFC,
                    ProductName = x.ProductName,
                    Product_Long_Name = x.Product_Long_Name,
                    Pack_Description = x.Pack_Description,
                    Pack_Long_Name = x.Pack_Long_Name,
                    FCC = x.FCC,
                    ATC1_Code = x.ATC1_Code,
                    ATC1_Desc = x.ATC1_Desc,
                    ATC2_Code = x.ATC2_Code,
                    ATC2_Desc = x.ATC2_Desc,
                    ATC3_Code = x.ATC3_Code,
                    ATC3_Desc = x.ATC3_Desc,
                    ATC4_Code = x.ATC4_Code,
                    ATC4_Desc = x.ATC4_Desc,
                    NEC1_Code = x.NEC1_Code,
                    NEC1_Desc = x.NEC1_Desc,
                    NEC1_LongDesc = x.NEC1_LongDesc,
                    NEC2_Code = x.NEC2_Code,
                    NEC2_desc = x.NEC2_desc,
                    NEC2_LongDesc = x.NEC2_LongDesc,
                    NEC3_Code = x.NEC3_Code,
                    NEC3_Desc = x.NEC3_Desc,
                    NEC3_LongDesc = x.NEC3_LongDesc,
                    NEC4_Code = x.NEC4_Code,
                    NEC4_Desc = x.NEC4_Desc,
                    NEC4_LongDesc = x.NEC4_LongDesc,
                    CH_Segment_Code = x.CH_Segment_Code,
                    CH_Segment_Desc = x.CH_Segment_Desc,
                    WHO1_Code = x.WHO1_Code,
                    WHO1_Desc = x.WHO1_Desc,
                    WHO2_Code = x.WHO2_Code,
                    WHO2_Desc = x.WHO2_Desc,
                    WHO3_Code = x.WHO3_Code,
                    WHO3_Desc = x.WHO3_Desc,
                    WHO4_Code = x.WHO4_Code,
                    WHO4_Desc = x.WHO4_Desc,
                    WHO5_Code = x.WHO5_Code,
                    WHO5_Desc = x.WHO5_Desc,
                    FRM_Flgs1 = x.FRM_Flgs1,
                    FRM_Flgs1_Desc = x.FRM_Flgs1_Desc,
                    FRM_Flgs2 = x.FRM_Flgs2,
                    FRM_Flgs2_Desc = x.FRM_Flgs2_Desc,
                    FRM_Flgs3 = x.FRM_Flgs3,
                    Frm_Flgs3_Desc = x.Frm_Flgs3_Desc,
                    FRM_Flgs4 = x.FRM_Flgs4,
                    FRM_Flgs4_Desc = x.FRM_Flgs4_Desc,
                    FRM_Flgs5 = x.FRM_Flgs5,
                    FRM_Flgs5_Desc = x.FRM_Flgs5_Desc,
                    FRM_Flgs6 = x.FRM_Flgs6,
                    Compound_Indicator = x.Compound_Indicator,
                    Compound_Ind_Desc = x.Compound_Ind_Desc,
                    PBS_Formulary = x.PBS_Formulary,
                    PBS_Formulary_Date = x.PBS_Formulary_Date,
                    Poison_Schedule = x.Poison_Schedule,
                    Poison_Schedule_Desc = x.Poison_Schedule_Desc,
                    Stdy_Ind1_Code = x.Stdy_Ind1_Code,
                    Study_Indicators1 = x.Study_Indicators1,
                    Stdy_Ind2_Code = x.Stdy_Ind2_Code,
                    Study_Indicators2 = x.Study_Indicators2,
                    Stdy_Ind3_Code = x.Stdy_Ind3_Code,
                    Study_Indicators3 = x.Study_Indicators3,
                    Stdy_Ind4_Code = x.Stdy_Ind4_Code,
                    Study_Indicators4 = x.Study_Indicators4,
                    Stdy_Ind5_Code = x.Stdy_Ind5_Code,
                    Study_Indicators5 = x.Study_Indicators5,
                    Stdy_Ind6_Code = x.Stdy_Ind6_Code,
                    Study_Indicators6 = x.Study_Indicators6,
                    PackLaunch = Convert.ToString(x.PackLaunch),
                    Prod_lch = Convert.ToString(x.Prod_lch),
                    Org_Code = Convert.ToString(x.Org_Code),
                    Org_Abbr = x.Org_Abbr,
                    Org_Short_Name = x.Org_Short_Name,
                    Org_Long_Name = x.Org_Long_Name,
                    Out_td_dt = Convert.ToString(x.Out_td_dt),
                    //Prtd_Price = x.Prtd_Price,
                    pk_size = Convert.ToString(x.pk_size),
                    vol_wt_uns = Convert.ToString(x.vol_wt_uns),
                    vol_wt_meas = x.vol_wt_meas,
                    strgh_uns = Convert.ToString(x.strgh_uns),
                    strgh_meas = x.strgh_meas,
                    Conc_Unit = Convert.ToString(x.Conc_Unit),
                    Conc_Meas = x.Conc_Meas,
                    Additional_Strength = x.Additional_Strength,
                    Additional_Pack_Info = x.Additional_Pack_Info,
                    Recommended_Retail_Price = x.Recommended_Retail_Price,
                    Ret_Price_Effective_Date = x.Ret_Price_Effective_Date,
                    Editable_Pack_Description = x.Editable_Pack_Description,
                    APN = x.APN,
                    Trade_Product_Pack_ID = x.Trade_Product_Pack_ID,
                    Form_Desc_Abbr = x.Form_Desc_Abbr,
                    Form_Desc_Short = x.Form_Desc_Short,
                    Form_Desc_Long = x.Form_Desc_Long,
                    NFC1_Code = x.NFC1_Code,
                    NFC1_Desc = x.NFC1_Desc,
                    NFC2_Code = x.NFC2_Code,
                    NFC2_Desc = x.NFC2_Desc,
                    NFC3_Code = x.NFC3_Code,
                    NFC3_Desc = x.NFC3_Desc,
                    Price_Effective_Date = x.Price_Effective_Date,
                    Last_amd = x.Last_amd,
                    PBS_Start_Date = x.PBS_Start_Date,
                    PBS_End_Date = x.PBS_End_Date,
                    Supplier_Code = x.Supplier_Code,
                    Supplier_Product_Code = x.Supplier_Product_Code
                });

                var result = new FilterResult<PackResult>
                {
                    Data = res.ToList(),
                    TotalCount = pageList.TotalCount,
                    PageCount = pageList.PageCount,
                    CurrentPage = pageList.Page,
                    PageSize = pageList.PageSize
                };

                return result;
            }
        }

        public string GetFilter(ICollection<Filter> searchParams, bool isMoleculeFilter = false)
        {
            StringBuilder str = new StringBuilder();
            Dictionary<string, ICollection<Filter>> list = new Dictionary<string, ICollection<Filter>>();
            Filter searchFilter = null;
            if (searchParams != null)
            {
                var restrictParams = searchParams.Where(s => s.Condition.ToLower() == "restrict").OrderBy(f => f.Criteria).ToList();
                searchParams = searchParams.Where(s => s.Condition.ToLower() != "restrict").OrderBy(f => f.Criteria).ToList();
                foreach (var item in restrictParams)
                {
                    searchParams.Add(item);
                }
            }

            foreach (Filter filter in searchParams)
            {

                //to query either description or code based on search text
                if (filter.Criteria.IndexOf("S_") > -1)
                {
                    int j = 0;
                    switch (filter.Criteria.ToLower())
                    {
                        case "s_atc1_code":
                            {
                                if (filter.Value.Length > 1)
                                {
                                    if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc1_code"; }
                                    //else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc1_code"; }
                                    else { filter.Criteria = "atc1_desc"; }
                                }
                                else { filter.Criteria = "atc1_desc"; }
                                break;
                            }
                        case "s_atc2_code":
                            {
                                if (filter.Value.Length > 1)
                                {
                                    if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc2_desc"; }
                                    else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc2_code"; }
                                    else { filter.Criteria = "atc2_desc"; }
                                }
                                else { filter.Criteria = "atc2_desc"; }
                                break;
                            }
                        case "s_atc3_code":
                            {
                                if (filter.Value.Length > 1)
                                {
                                    if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc3_desc"; }
                                    else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc3_code"; }
                                    else { filter.Criteria = "atc3_desc"; }
                                }
                                else { filter.Criteria = "atc3_desc"; }
                                break;
                            }
                        case "s_atc4_code":
                            {
                                if (filter.Value.Length > 1)
                                {
                                    if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc4_desc"; }
                                    else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc4_code"; }
                                    else { filter.Criteria = "atc4_desc"; }
                                }
                                else { filter.Criteria = "atc4_desc"; }
                                break;
                            }
                        case "s_nec1_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec1_code"; } else { filter.Criteria = "nec1_desc"; } break; }
                        case "s_nec2_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec2_code"; } else { filter.Criteria = "nec2_desc"; } break; }
                        case "s_nec3_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec3_code"; } else { filter.Criteria = "nec3_desc"; } break; }
                        case "s_nec4_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec4_code"; } else { filter.Criteria = "nec4_desc"; } break; }

                    }
                }
                if (filter.Value.Substring(filter.Value.Length - 1, 1) != "*")
                {
                    if (!list.ContainsKey(filter.Criteria)) { list.Add(filter.Criteria, new List<Filter>()); }
                    list[filter.Criteria].Add(filter);
                }
                else { searchFilter = filter; }
            }

            //string previousAttribute = "";
            //foreach (ICollection<Filter> filterList in list.Values)
            //{
            //    if (filterList.First() != null)
            //    {
            //        if (filterList.First().Condition.ToLower() == "restrict" || (previousAttribute != "" && previousAttribute.Substring(0, 3) != filterList.First().Criteria.Substring(0, 3)))
            //        {
            //            str.Append(" AND ");
            //        }
            //        else
            //        {
            //            str.Append(" OR ");
            //        }
            //    }
            //    else
            //    {
            //        str.Append(" OR ");
            //    }
            //    previousAttribute = filterList.First().Criteria;

            //    str.Append("(");
            //    string filterQuery = string.Join(" OR ",
            //        filterList
            //        .Where(f => !string.IsNullOrWhiteSpace(f.Value))
            //        .Select(f => GetCriteria(f.Criteria, f.Value, f.Condition, isMoleculeFilter))
            //        );
            //    str.Append(filterQuery);
            //    str.Append(")");

            //}
            //if (str.Length > 0)
            //{
            //    if (str[2] == 'R')
            //    {
            //        str.Remove(0, 4);
            //    }
            //    else
            //    {
            //        str.Remove(0, 5);
            //    }
            //    if (searchFilter != null)
            //        str.Append(" AND ");
            //}
            //if (searchFilter != null)
            //    str.Append(GetCriteria(searchFilter.Criteria, searchFilter.Value, searchFilter.Condition, isMoleculeFilter));

            Queue<string> filterQueue = new Queue<string>();
            string previousAttribute = string.Empty;
            bool isBracketClosed = false;
            foreach (ICollection<Filter> filterList in list.Values)
            {
                if (!string.IsNullOrEmpty(previousAttribute))
                {
                    if (filterList.First() != null)
                    {
                        if (filterList.First().Condition.ToLower() == "restrict" || (previousAttribute != "" && previousAttribute.Substring(0, 3) != filterList.First().Criteria.Substring(0, 3)))
                        {
                            if (!isBracketClosed)
                            {
                                filterQueue.Enqueue(")");
                                isBracketClosed = true;
                            }
                            filterQueue.Enqueue(" AND ");
                        }
                        else
                        {
                            if (isBracketClosed)
                            {
                                filterQueue.Enqueue("(");
                                isBracketClosed = false;
                            }
                            filterQueue.Enqueue(" OR ");
                        }
                    }
                    else
                    {
                        if (isBracketClosed)
                        {
                            filterQueue.Enqueue("(");
                            isBracketClosed = false;
                        }
                        filterQueue.Enqueue(" OR ");
                    }
                }
                else
                {
                    filterQueue.Enqueue("(");
                    isBracketClosed = false;
                }

                if (isBracketClosed)
                {
                    filterQueue.Enqueue("(");
                    isBracketClosed = false;
                }

                previousAttribute = filterList.First().Criteria;

                string concateString = " OR ";
                if (filterList.First().Condition.ToLower() == "restrict")
                    concateString = " AND ";
                string filterQuery = string.Join(concateString,
                    filterList
                    .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                    .Select(f => GetCriteria(f.Criteria, f.Value, f.Condition, isMoleculeFilter))
                    );

                if (!string.IsNullOrEmpty(filterQuery))
                    filterQueue.Enqueue(string.Format("{0}{1}{2}", "(", filterQuery, ")"));
            }

            if (!isBracketClosed && filterQueue.Count > 0)
                filterQueue.Enqueue(")");

            if (filterQueue.Count > 0 && searchFilter != null)
                filterQueue.Enqueue(" AND ");

            if (searchFilter != null)
                filterQueue.Enqueue(GetCriteria(searchFilter.Criteria, searchFilter.Value, searchFilter.Condition, isMoleculeFilter));

            foreach (string item in filterQueue)
            {
                str.Append(item + " ");
            }

            return str.ToString();
        }

        #region Private Methods

        private string GetCriteria(string criteria, string value, string condition, bool isMoleculeFilter)
        {
            //build pack search filter
            string result = "";
            StringBuilder str = new StringBuilder();

            string[] attrValues = value.Split(',');
            str.Append("(");
            foreach (string val in attrValues)
            {
                if (condition.ToLower() == "restrict")
                    str.Append("!");

                if (isMoleculeFilter)
                {
                    if (criteria.ToLower() == "molecule" || criteria.ToLower() == "description")
                        str.Append("molecule.");
                    else
                        str.Append("product.");
                }

                switch (criteria.ToLower())
                {
                    case "atc4_code": case "atc4": { str.Append("ATC4_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc3_code": case "atc3": { str.Append("ATC3_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc2_code": case "atc2": { str.Append("ATC2_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc1_code": case "atc1": { str.Append("ATC1_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec4_code": case "nec4": { str.Append("NEC4_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec3_code": case "nec3": { str.Append("NEC3_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec2_code": case "nec2": { str.Append("NEC2_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec1_code": case "nec1": { str.Append("NEC1_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc4_desc": { str.Append("ATC4_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc3_desc": { str.Append("ATC3_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc2_desc": { str.Append("ATC2_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "atc1_desc": { str.Append("ATC1_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec4_desc": { str.Append("NEC4_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec3_desc": { str.Append("NEC3_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec2_desc": { str.Append("NEC2_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "nec1_desc": { str.Append("NEC1_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "poison_schedule": { str.Append("Poison_Schedule.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "form": { str.Append("Form_Desc_Short.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "product": case "productname": { str.Append("Product_Long_Name.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "packdescription": { str.Append("Pack_Description.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "manufacturer":
                    case "mfr":
                        {
                            str.Append("Org_Long_Name.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")");
                            str.Append(" OR ");
                            if (isMoleculeFilter)
                                str.Append("product.");
                            str.Append("Org_Abbr.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break;
                        }
                    case "org_long_name": { str.Append("Org_Long_Name.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
                    case "flagging": { if (value.ToLower() != "all") { str.Append("FRM_Flgs5_Desc.Contains(\""); str.Append(val.Replace("*", "") + "\")"); } break; }
                    case "branding": { if (value.ToLower() != "all") { str.Append("Frm_Flgs3_Desc.Contains(\""); str.Append(val.Replace("*", "") + "\")"); } break; }
                    case "molecule": case "description": { str.Append("DESCRIPTION.Contains(\""); str.Append(val.ToUpper().Replace("*", "") + "\")"); break; }
                    case "fcc": { str.Append("FCC.Value.Equals("); str.Append(val.Replace("*", "").ToUpper() + ")"); break; }
                    case "orgcode": { str.Append("Org_Code.Value.Equals("); str.Append(val.Replace("*", "").ToUpper() + ")"); break; }
                        //case "orderby":
                        //    {
                        //        string[] values = value.Split(',');
                        //        result = "sort=" + values[0] + values[1] == "asc" ? " asc" : " desc";
                        //        return result;
                        //    }
                }
                str.Append(" OR ");
            }
            str.Remove(str.Length - 4, 4);
            str.Append(")");
            return str.ToString();

        }

        private string GetFilterForPacks(ICollection<Filter> searchParams)
        {

            searchParams = searchParams.Where(s => s.Value != "").ToList();

            var filterFlagging = searchParams.FirstOrDefault(x => x.Criteria.ToLower() == "flagging" && x.Value.ToLower() == "all");
            if (filterFlagging != null)
                searchParams.Remove(filterFlagging);
            var filterBranding = searchParams.FirstOrDefault(x => x.Criteria.ToLower() == "branding" && x.Value.ToLower() == "all");
            if (filterBranding != null)
                searchParams.Remove(filterBranding);

            Dictionary<string, ICollection<Filter>> list = new Dictionary<string, ICollection<Filter>>();
            foreach (Filter filter in searchParams)
            {
                if (!list.ContainsKey(filter.Criteria))
                {
                    list.Add(filter.Criteria, new List<Filter>());
                }
                list[filter.Criteria].Add(filter);
            }

            StringBuilder query = new StringBuilder();
            var filterQuery = "";
            foreach (ICollection<Filter> filterList in list.Values)
            {
                if (query.Length > 0)
                {
                    query.Append(" AND ");
                }
                query.Append("(");
                
                filterQuery = string.Join(" OR ",
                filterList
                .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                .Select(f => GetCriteriaForPacks(f.Criteria, f.Value)));
                query.Append(filterQuery);
                query.Append(")");
            }

            //var filterQuery = "";
            //if (searchParams != null)
            //{
            //    filterQuery = string.Join(" AND ",
            //    searchParams
            //    .Where(f => !string.IsNullOrWhiteSpace(f.Value))
            //    .Select(f => GetCriteriaForPacks(f.Criteria, f.Value))
            //    );
            //}

            query = query.Replace("AND Remove", "").Replace("Remove AND", "").Replace("Remove", "");
            return query.ToString();
        }
        private string GetCriteriaForPacks(string criteria, string value)
        {
            string cri = null;
            StringBuilder str = new StringBuilder();

            switch (criteria.ToLower())
            {
                case "atc":
                    {
                        if (value.Length < 3) { cri = "ATC1_Code"; }
                        else if (value.Length == 3) { cri = "ATC2_Code"; }
                        else if (value.Length == 4) { cri = "ATC3_Code"; }
                        else if (value.Length == 5) { cri = "ATC4_Code"; }
                        break;
                    }
                case "nec":
                    {
                        if (value.Length < 3) { cri = "NEC1_Code"; }
                        else if (value.Length == 3) { cri = "NEC2_Code"; }
                        else if (value.Length == 4) { cri = "NEC3_Code"; }
                        else if (value.Length == 5) { cri = "NEC4_Code"; }
                        break;
                    }
                case "packdescription": { str.Append("product.Pack_Long_Name.Contains(\""); str.Append(value.ToUpper() + "\")"); break; }
                case "manufacturer": { str.Append("product.Org_Long_Name.Contains(\""); str.Append(value.ToUpper() + "\")"); break; }
                case "productname": { str.Append("product.ProductName.Contains(\""); str.Append(value.ToUpper() + "\")"); break; }
                case "flagging": { if (value.ToLower() != "all") { str.Append("product.FRM_Flgs5_Desc.Contains(\""); str.Append(value.ToUpper() + "\")"); } break; }
                case "branding": { if (value.ToLower() != "all") { str.Append("product.Frm_Flgs3_Desc.Contains(\""); str.Append(value.ToUpper() + "\")"); } break; }
                case "molecule": { str.Append("molecule.DESCRIPTION.Contains(\""); str.Append(value.ToUpper() + "\")"); break; }
                case "pfc": { str.Append("product.PFC.Contains(\""); str.Append(value.ToUpper() + "\")"); break; }
                case "apn": { str.Append("product.APN.Contains(\""); str.Append(value.ToUpper() + "\")"); break; }
            }

            if (!string.IsNullOrEmpty(cri))
            {
                //starts with
                str.Append("product." + cri + ".Contains(\""); str.Append(value.ToUpper() + "\")");

            }
            if (string.IsNullOrWhiteSpace(str.ToString()))
            {
                str.Append("Remove");
            }
            return str.ToString(); ;
        }

        #endregion
    }

    public class PackSearchModal
    {
        public ReportParamList Product { get; set; }
        public MoleculeDetail Molecule { get; set; }
    }
}