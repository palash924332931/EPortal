using IMS.EverestPortal.API.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using IMS.EverestPortal.API.Models;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Xml;
using IMS.EverestPortal.API.Models.packSearch;
using System.Text;
using System.Configuration;
using IMS.EverestPortal.API.Controllers;
using System.Data;

namespace IMS.EverestPortal.API.Providers
{
    public class PacksSolrProvider : IPacksProvider
    {
        private readonly string packsSolrURL = ConfigurationManager.AppSettings["solrPackSearchURL"];

        public async Task<PackResultResponse> GetPacksSearchResult(ICollection<Filter> searchParams)
        {
            //Need to implement solr query to filter results based on the searchParams
            //This method should return the result with colums Pack Description, Manufacturer, ATC, NEC, Molecule, Flagging, Branding
            List<PackResult> lstPack = new List<PackResult>();
            string jsonResponse = string.Empty;

            string pageStart = searchParams.FirstOrDefault(p => p.Criteria == "start").Value;
            var sObj = searchParams.FirstOrDefault(p => p.Criteria == "start");

            searchParams.Remove(sObj);

            string rows = searchParams.FirstOrDefault(p => p.Criteria == "rows").Value;
            int noRows = 10;
            int.TryParse(rows, out noRows);
            var rObj = searchParams.FirstOrDefault(p => p.Criteria == "rows");

            if (rObj != null) searchParams.Remove(rObj);

            var filterQuery = "";
            if (searchParams != null)
            {
                filterQuery = string.Join("+AND+",
                searchParams
                .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                .Select(f => getCriteria(f.Criteria, f.Value))
            );
            }

            if (string.IsNullOrWhiteSpace(filterQuery))
            {
                filterQuery = "*:*";
            }
            filterQuery += "&start=" + pageStart;

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(packsSolrURL);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync("?q=" + filterQuery + "&rows=" + noRows);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                lstPack.Add(ParsePackFromXML(node));
            }


            // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

            // return lstPack;
            PackResultResponse retObject = new PackResultResponse();
            retObject.packResult = lstPack;
            XmlNodeList nodeList = doc.SelectNodes("/response/result");
            foreach (XmlNode node in nodeList)
            {
                string id = node.Attributes["numFound"].Value;
                int rCnt = 0;
                int.TryParse(id, out rCnt);
                retObject.recCount = rCnt;
            }

            return retObject;
        }

        public async Task<List<PackDescResult>> GetPackDescription(ICollection<Filter> searchParams)
        {
            //Need to implement solr query to filter results based on the searchParams
            //This method should return the result with colums Pack Description, Manufacturer, ATC, NEC, Molecule, Flagging, Branding
            List<PackDescResult> lstPack = new List<PackDescResult>();


            var filterQuery = "";
            if (searchParams != null)
            {
                filterQuery = string.Join("+AND+",
                searchParams
                .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                .Select(f => getCriteria(f.Criteria, f.Value))
                );

                //query sorting the result by pack description
                if (searchParams.Any(x => string.Equals(x.Criteria, "PackDescription", StringComparison.InvariantCultureIgnoreCase)))
                {
                    filterQuery = string.Format("{0}&sort={1}", filterQuery, "Pack_Long_Name asc");
                }
            }
            if (string.IsNullOrWhiteSpace(filterQuery)) { filterQuery = "*:*"; }

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(packsSolrURL);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync("?q=" + filterQuery + "&rows=20");
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                lstPack.Add(ParsePackDescFromXML(node));
            }
            var res = lstPack.GroupBy(p => p.PackDescription).Select(g => g.First()).ToList();

            // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

            return res;
        }

        public async Task<DataTable> GetPacksForExcel(string[] columns, ICollection<Filter> searchParams)
        {
            DataTable dt = new DataTable("pack");

            string resultContent = null;
            for (int i = 0; i < columns.Length; i++)
            {
                if (columns[i].ToLower() == "molecules") columns[i] = "MOLECULES";
                dt.Columns.Add(columns[i], typeof(System.String));
            }

            var solrResult = await GetPackSearcResultsForExport(searchParams, columns);

            resultContent = solrResult.Content.ReadAsStringAsync().Result;

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);

            dt = ConvertXmlNodeListToDataTable(doc.DocumentElement.SelectNodes("/response/result/doc"), dt);

            return dt;
        }

        #region Private Methods
        private string getCriteria(string criteria, string value)
        {
            string result = "*:*";
            string cri = null;

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
                case "packdescription": { return "Pack_Long_Name:*" + value.ToUpper().Replace(" ", "\\ ") + "*"; }
                case "manufacturer": { return "Org_Long_Name:" + value.ToUpper().Replace(" ", "\\ ") + "*"; }
                case "productname": { return "ProductName:" + value.ToUpper().Replace(" ", "\\ ") + "*"; }
                case "flagging": { if (value.ToLower() != "all") { return "FRM_Flgs5_Desc:" + value; } break; }
                case "branding": { if (value.ToLower() != "all") { return "Frm_Flgs3_Desc:" + value; } break; }
                case "molecule": { return "MOLECULES:*" + value.ToUpper().Replace(" ", "\\ ") + "*"; }
                case "pfc": { return "PFC:" + value.ToUpper().Replace(" ", "\\ ") + "*"; }
                case "apn": { return "APN:" + value.ToUpper().Replace(" ", "\\ ") + "*"; }
                //case "start":
                //    {
                //        return "&start=" + value;
                //        break;
                //    }
                case "orderby":
                    {
                        string[] values = value.Split(',');
                        string flnName = values[0].ToString();
                        switch (flnName.ToLower())
                        {
                            case "packdescription": { flnName = "Pack_Long_Name"; break; }
                            case "manufacturer": { flnName = "Org_Long_Name"; break; }
                            case "flagging": { flnName = "FRM_Flgs5_Desc"; break; }
                            case "branding": { flnName = "Frm_Flgs3_Desc"; break; }
                            case "molecule": { flnName = "MOLECULES"; break; }
                            case "pfc": { flnName = "PFC"; break; }
                            case "apn": { flnName = "APN"; break; }
                            case "productname": { flnName = "ProductName"; break; }
                        }
                        result += "&sort=" + flnName + (values[1] == "1" ? " asc" : " desc");
                        return result;
                    }

            }

            if (!string.IsNullOrEmpty(cri))
            {
                //starts with
                result = cri + ":" + value.ToUpper() + "*";

            }
            return result;
        }

        private PackResult ParsePackFromXML(XmlNode packXmlNode)
        {

            PackResult p = new PackResult();
            foreach (XmlNode node in packXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "pack_long_name": { p.Pack_Description = node.InnerText; break; }
                    case "frm_flgs3_desc": { p.Frm_Flgs3_Desc = node.InnerText; break; }
                    case "frm_flgs5_desc": { p.FRM_Flgs5_Desc = node.InnerText; break; }
                    case "atc4_desc": { p.ATC4_Desc = node.InnerText; break; }
                    case "nec4_desc": { p.NEC4_Desc = node.InnerText; break; }
                    case "org_long_name": { p.Org_Long_Name = node.InnerText; break; }
                    case "molecules": { p.Molecules = getMolecules(node); break; }

                    case "packid": { p.PackID = node.InnerText; break; }
                    case "prod_cd": { p.Prod_cd = node.InnerText; break; }
                    case "pack_cd": { p.Pack_cd = node.InnerText; break; }
                    case "pfc": { p.PFC = node.InnerText; break; }
                    case "productname": { p.ProductName = node.InnerText; break; }
                    case "product_long_name": { p.Product_Long_Name = node.InnerText; break; }
                    //case "pack_long_name": { p.Pack_Long_Name = node.InnerText; break; }
                    case "fcc": { p.FCC = node.InnerText; break; }
                    case "atc1_code": { p.ATC1_Code = node.InnerText; break; }
                    case "atc1_desc": { p.ATC1_Desc = node.InnerText; break; }
                    case "atc2_code": { p.ATC2_Code = node.InnerText; break; }
                    case "atc2_desc": { p.ATC2_Desc = node.InnerText; break; }
                    case "atc3_code": { p.ATC3_Code = node.InnerText; break; }
                    case "atc3_desc": { p.ATC3_Desc = node.InnerText; break; }
                    case "atc4_code": { p.ATC4_Code = node.InnerText; break; }

                    case "frm_flgs1": { p.FRM_Flgs1 = node.InnerText; break; }
                    case "frm_flgs1_desc": { p.FRM_Flgs1_Desc = node.InnerText; break; }
                    case "frm_flgs2": { p.FRM_Flgs2 = node.InnerText; break; }
                    case "frm_flgs2_desc": { p.FRM_Flgs2_Desc = node.InnerText; break; }
                    case "frm_flgs3": { p.FRM_Flgs3 = node.InnerText; break; }
                    case "frm_flgs4": { p.FRM_Flgs4 = node.InnerText; break; }
                    case "frm_flgs4_desc": { p.FRM_Flgs4_Desc = node.InnerText; break; }
                    case "frm_flgs5": { p.FRM_Flgs5 = node.InnerText; break; }
                    case "frm_flgs6": { p.FRM_Flgs6 = node.InnerText; break; }
                    case "pbs_formulary": { p.PBS_Formulary = node.InnerText; break; }
                    case "pbs_formulary_date": { p.PBS_Formulary_Date = node.InnerText; break; }
                    case "stdy_ind1_code": { p.Stdy_Ind1_Code = node.InnerText; break; }
                    case "study_indicators1": { p.Study_Indicators1 = node.InnerText; break; }
                    case "stdy_ind2_code": { p.Stdy_Ind2_Code = node.InnerText; break; }
                    case "study_indicators2": { p.Study_Indicators2 = node.InnerText; break; }
                    case "stdy_ind3_code": { p.Stdy_Ind3_Code = node.InnerText; break; }
                    case "study_indicators3": { p.Study_Indicators3 = node.InnerText; break; }
                    case "stdy_ind4_code": { p.Stdy_Ind4_Code = node.InnerText; break; }
                    case "study_indicators4": { p.Study_Indicators4 = node.InnerText; break; }
                    case "stdy_ind5_code": { p.Stdy_Ind5_Code = node.InnerText; break; }
                    case "study_indicators5": { p.Study_Indicators5 = node.InnerText; break; }
                    case "stdy_ind6_code": { p.Stdy_Ind6_Code = node.InnerText; break; }
                    case "study_indicators6": { p.Study_Indicators6 = node.InnerText; break; }
                    case "packlaunch": { p.PackLaunch = node.InnerText; break; }
                    case "prod_lch": { p.Prod_lch = node.InnerText; break; }
                    case "org_code": { p.Org_Code = node.InnerText; break; }
                    case "org_abbr": { p.Org_Abbr = node.InnerText; break; }
                    case "org_short_name": { p.Org_Short_Name = node.InnerText; break; }

                    case "out_td_dt": { p.Out_td_dt = node.InnerText; break; }
                    case "prtd_price": { p.Prtd_Price = node.InnerText; break; }
                    case "pk_size": { p.pk_size = node.InnerText; break; }
                    case "vol_wt_uns": { p.vol_wt_uns = node.InnerText; break; }
                    case "vol_wt_meas": { p.vol_wt_meas = node.InnerText; break; }
                    case "strgh_uns": { p.strgh_uns = node.InnerText; break; }
                    case "strgh_meas": { p.strgh_meas = node.InnerText; break; }
                    case "conc_unit": { p.Conc_Unit = node.InnerText; break; }
                    case "conc_meas": { p.Conc_Meas = node.InnerText; break; }
                    case "recommended_retail_price": { p.Recommended_Retail_Price = node.InnerText; break; }
                    case "ret_price_effective_date": { p.Ret_Price_Effective_Date = node.InnerText; break; }
                    case "editable_pack_description": { p.Editable_Pack_Description = node.InnerText; break; }
                    case "form_desc_abbr": { p.Form_Desc_Abbr = node.InnerText; break; }
                    case "form_desc_short": { p.Form_Desc_Short = node.InnerText; break; }
                    case "form_desc_long": { p.Form_Desc_Long = node.InnerText; break; }
                    case "nfc1_code": { p.NFC1_Code = node.InnerText; break; }
                    case "nfc1_desc": { p.NFC1_Desc = node.InnerText; break; }
                    case "nfc2_code": { p.NFC2_Code = node.InnerText; break; }
                    case "nfc2_desc": { p.NFC2_Desc = node.InnerText; break; }
                    case "nfc3_code": { p.NFC3_Code = node.InnerText; break; }
                    case "nfc3_desc": { p.NFC3_Desc = node.InnerText; break; }
                    case "price_effective_date": { p.Price_Effective_Date = node.InnerText; break; }
                    case "last_amd": { p.Last_amd = node.InnerText; break; }
                    case "pbs_start_date": { p.PBS_Start_Date = node.InnerText; break; }
                    case "pbs_end_date": { p.PBS_End_Date = node.InnerText; break; }
                    case "supplier_code": { p.Supplier_Code = node.InnerText; break; }
                    case "supplier_product_code": { p.Supplier_Product_Code = node.InnerText; break; }

                    case "apn": { p.APN = node.InnerText; break; }
                    case "nec1_code": { p.NEC1_Code = node.InnerText; break; }
                    case "nec1_desc": { p.NEC1_Desc = node.InnerText; break; }
                    case "nec1_longdesc": { p.NEC1_LongDesc = node.InnerText; break; }
                    case "nec2_code": { p.NEC2_Code = node.InnerText; break; }
                    case "nec2_desc": { p.NEC2_desc = node.InnerText; break; }
                    case "nec2_longdesc": { p.NEC2_LongDesc = node.InnerText; break; }
                    case "nec3_code": { p.NEC3_Code = node.InnerText; break; }
                    case "nec3_desc": { p.NEC3_Desc = node.InnerText; break; }
                    case "nec3_longdesc": { p.NEC3_LongDesc = node.InnerText; break; }
                    case "nec4_code": { p.NEC4_Code = node.InnerText; break; }
                    case "nec4_longdesc": { p.NEC4_LongDesc = node.InnerText; break; }

                    case "ch_segment_code": { p.CH_Segment_Code = node.InnerText; break; }
                    case "ch_segment_desc": { p.CH_Segment_Desc = node.InnerText; break; }
                    case "who1_code": { p.WHO1_Code = node.InnerText; break; }
                    case "who1_desc": { p.WHO1_Desc = node.InnerText; break; }
                    case "who2_code": { p.WHO2_Code = node.InnerText; break; }
                    case "who2_desc": { p.WHO2_Desc = node.InnerText; break; }
                    case "who3_code": { p.WHO3_Code = node.InnerText; break; }
                    case "who3_desc": { p.WHO3_Desc = node.InnerText; break; }
                    case "who4_code": { p.WHO4_Code = node.InnerText; break; }
                    case "who4_desc": { p.WHO4_Desc = node.InnerText; break; }
                    case "who5_code": { p.WHO5_Code = node.InnerText; break; }
                    case "who5_desc": { p.WHO5_Desc = node.InnerText; break; }
                    case "compound_indicator": { p.Compound_Indicator = node.InnerText; break; }
                    case "compound_ind_desc": { p.Compound_Ind_Desc = node.InnerText; break; }
                    case "poison_schedule": { p.Poison_Schedule = node.InnerText; break; }
                    case "poison_schedule_desc": { p.Poison_Schedule_Desc = node.InnerText; break; }
                    case "additional_strength": { p.Additional_Strength = node.InnerText; break; }
                    case "additional_pack_info": { p.Additional_Pack_Info = node.InnerText; break; }
                    case "trade_product_pack_id": { p.Trade_Product_Pack_ID = node.InnerText; break; }
                }

            }
            return p;
        }

        private string getMolecules(XmlNode molNode)
        {
            StringBuilder molecules = new StringBuilder();
            foreach (XmlNode node in molNode.ChildNodes)
            {
                molecules.Append(node.InnerText);
                molecules.Append(" | ");
            }
            if (molecules.Length > 0) { molecules.Remove(molecules.Length - 3, 3); }
            return molecules.ToString();
        }

        private PackDescResult ParsePackDescFromXML(XmlNode packXmlNode)
        {

            PackDescResult p = new PackDescResult();
            foreach (XmlNode node in packXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "pack_long_name": { p.PackDescription = node.InnerText; break; }
                    case "frm_flgs3_desc": { p.Branding = node.InnerText; break; }
                    case "frm_flgs5_desc": { p.Flagging = node.InnerText; break; }
                    case "atc4_desc": { p.ATC = node.InnerText; break; }
                    case "nec4_desc": { p.NEC = node.InnerText; break; }
                    case "org_long_name": { p.Manufacturer = node.InnerText; break; }
                    case "molecules": { p.Molecule = getMolecules(node); break; }
                }

            }
            return p;
        }

        private async Task<HttpResponseMessage> GetPackSearcResultsForExport(ICollection<Filter> searchParams, string[] columns)
        {
            List<PackResult> lstPack = new List<PackResult>();

            var sObj = searchParams.FirstOrDefault(p => p.Criteria == "start");
            if (sObj != null) searchParams.Remove(sObj);
            string rows = searchParams.FirstOrDefault(p => p.Criteria == "rows").Value;
            int noRows = 10;
            int.TryParse(rows, out noRows);
            var rObj = searchParams.FirstOrDefault(p => p.Criteria == "rows");

            if (rObj != null) searchParams.Remove(rObj);

            var filterQuery = "";
            if (searchParams != null)
            {
                filterQuery = string.Join("+AND+",
                searchParams
                .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                .Select(f => getCriteria(f.Criteria, f.Value))
            );
            }
            if (string.IsNullOrWhiteSpace(filterQuery)) { filterQuery = "*:*"; }
            var filterCols = "";

            if (columns.Length > 0)
                filterCols = string.Join(",", columns);

            if (!string.IsNullOrWhiteSpace(filterCols)) { filterQuery += "&fl=" + filterCols + "&rows=1000000"; }

            var client = new HttpClient();

            client.BaseAddress = new Uri(packsSolrURL);
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue("application/json"));

            return await client.GetAsync("?q=" + filterQuery);

        }

        private static DataTable ConvertXmlNodeListToDataTable(XmlNodeList xnl, DataTable dt)
        {

            int ColumnsCount = dt.Columns.Count;
            foreach (XmlNode i in xnl)
            {
                if (i.Attributes != null)
                {
                    DataRow dr = dt.NewRow();
                    foreach (XmlNode childNode in i.ChildNodes)
                    {
                        if (childNode != null)
                        {
                            string colName = childNode.Attributes[0].Value;
                            string colVal = childNode.InnerText;
                            dr[colName] = colVal;
                        }
                    }
                    dt.Rows.Add(dr);
                }
            }

            try
            {
                if (dt.Columns.Contains("Pack_Description")) dt.Columns["Pack_Description"].ColumnName = "Pack Description";
                if (dt.Columns.Contains("Org_Long_Name")) dt.Columns["Org_Long_Name"].ColumnName = "Manufacturer";
                if (dt.Columns.Contains("FRM_Flgs5_Desc")) dt.Columns["FRM_Flgs5_Desc"].ColumnName = "Flagging";
                if (dt.Columns.Contains("Frm_Flgs3_Desc")) dt.Columns["Frm_Flgs3_Desc"].ColumnName = "Branding";
                if (dt.Columns.Contains("ProductName")) dt.Columns["ProductName"].ColumnName = "Product Description";
                if (dt.Columns.Contains("ATC4_Desc")) dt.Columns["ATC4_Desc"].ColumnName = "ATC4";
                if (dt.Columns.Contains("NEC4_Desc")) dt.Columns["NEC4_Desc"].ColumnName = "NEC4";
                if (dt.Columns.Contains("APN")) dt.Columns["APN"].ColumnName = "APN/EAN/GTIN (barcode)";
                if (dt.Columns.Contains("MOLECULES")) dt.Columns["MOLECULES"].ColumnName = "Molecules";
            }
            catch (Exception)
            {

                throw;
            }

            //dt.AcceptChanges();
            return dt;

        }
        #endregion
    }
}