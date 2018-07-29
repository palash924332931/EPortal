using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using Microsoft.Practices.ServiceLocation;
using Newtonsoft.Json;
using SolrNet;
using SolrNet.Attributes;
using SolrNet.Commands.Parameters;
using SolrNet.DSL;
using SolrNet.Exceptions;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Xml.Linq;
using System.Xml;
using System.IO;
using System.Data;
using System.ComponentModel;
using System.Web;
using System.Text;
using OfficeOpenXml;
using OfficeOpenXml.Drawing.Chart;
using OfficeOpenXml.Table.PivotTable;
using System.Drawing;
using System.Configuration;
using IMS.EverestPortal.API.Models.packSearch;
using System.Data.SqlClient;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Providers;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class PacksController : ApiController
    {
        private EverestPortalContext dbContext = new EverestPortalContext();
        private readonly string packsSolrURL = ConfigurationManager.AppSettings["solrPackSearchURL"];
        private IPacksProvider packsProvider = null;
        public PacksController()
        {
            //refactor to use DI
            //packsProvider = new PacksSolrProvider();
            packsProvider = new PacksSQLProvider();
        }

        public PacksController(IPacksProvider packsProvider)
        {
            this.packsProvider = packsProvider;
        }

        // Not converted Solr to SQL because does not found any code which refers to this method 
        // GET: api/Packs
        public ICollection<Pack> Get()
        {
            var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Pack>>();
            //var results = solr.Query(new SolrQueryByField("id", "SP2514N"));

            List<Filter> parameters = new List<Filter>();
            // parameters.Add(new Filter() {Criteria="PackID", Value="\"30\"*" });
            var r = solr.Query(SolrQuery.All, new QueryOptions
            {
                Rows = 10,
                FilterQueries = BuildFilterQueries(parameters)
            });

            return r;

            //List<Pack> packs = new List<Pack>();
            //string resultContent = null;
            //using (var client = new HttpClient())
            //{
            //    client.BaseAddress = new Uri("http://localhost:8983/solr/test/select");
            //    client.DefaultRequestHeaders
            //        .Accept
            //        .Add(new MediaTypeWithQualityHeaderValue("application/json"));

            //    var result = await client.GetAsync("?q=*:*&fl=PackID&rows=10");
            //    resultContent = result.Content.ReadAsStringAsync().Result;
            //    Console.WriteLine(resultContent);                


            //}

            //var xDoc = XDocument.Parse(resultContent);
            //dynamic root = new ExpandoObject();
            //XmlToDynamic.Parse(root, xDoc.Elements().First());            

            //return root;
        }


        // Not converted Solr to SQL because does not found any code which refers to this method 
        [Route("api/GetPackResult")]
        [HttpGet]
        public async Task<ICollection<PackWithMarketBase>> GetPacksWithMarketBases([FromUri] int type, string searchString)
        {
            var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Pack>>();
            List<Pack> lstPack = new List<Pack>();

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(packsSolrURL);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                string url = "?q=ProductName:" + searchString + "*&rows=20&fl=ProductName&fl=PackID";
                var result = await client.GetAsync(url);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                lstPack.Add(ParsePack(node));
            }

            //create colleciton <packwithmarketbase>
            List<PackWithMarketBase> lstPackMarket = new List<PackWithMarketBase>();

            foreach (Pack item in lstPack)
            {
                // get market base names - from database
                //create packwithmarketbase
                //add to collection
                var query = from mkt in dbContext.MarketBases
                            where mkt.pack.Any(p => p.Id == item.Id)
                            select mkt;
                foreach (var x in query)
                {
                    PackWithMarketBase obj = new PackWithMarketBase
                    {
                        Pack = item.Id,
                        MarketBase = x.Name

                    };
                    lstPackMarket.Add(obj);
                }


            }

            return lstPackMarket;//return collection<packswithmarketbase>
        }

        [Route("api/GetPacksSearchResult")]
        [HttpPost]
        public async Task<string> GetPacksSearchResult([FromBody] ICollection<Filter> searchParams)
        {
            List<PackResult> lstPack = new List<PackResult>();
            string jsonResponse = string.Empty;


            var retObject = await packsProvider.GetPacksSearchResult(searchParams);
            if (retObject != null)
                jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(retObject);

            return jsonResponse;
        }

        [Route("api/GetPacksDescResult")]
        [HttpPost]
        public async Task<ICollection<PackDescResult>> GetPacksDescResult([FromBody] ICollection<Filter> searchParams)
        {
            return await packsProvider.GetPackDescription(searchParams);

        }
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
        private string getPackDescriptionCriteria(string criteria, string value)
        {
            string result = " ";
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
                case "packdescription": { return "Pack_Long_Name like '" + value.ToUpper() + "%'"; }
                case "manufacturer": { return "Org_Long_Name like '" + value.ToUpper() + "%'"; }
                case "productname": { return "ProductName like '" + value.ToUpper() + "%'"; }
                case "molecule": { return "Description like '%" + value.ToUpper() + "%'"; }
                case "pfc": { return "PFC like '" + value.ToUpper() + "%'"; }
                case "apn": { return "APN like '" + value.ToUpper() + "%'"; }
            }

            if (!string.IsNullOrEmpty(cri))
            {
                //starts with

                result = cri + " like '%" + value.ToUpper() + "%'";

            }
            return result;
        }

        //private PackResult ParsePackFromXML(XmlNode packXmlNode)
        //{

        //    PackResult p = new PackResult();
        //    foreach (XmlNode node in packXmlNode.ChildNodes)
        //    {
        //        string attr = node.Attributes["name"]?.InnerText;

        //        switch (attr.ToLower())
        //        {
        //            case "pack_long_name": { p.Pack_Description = node.InnerText; break; }
        //            case "frm_flgs3_desc": { p.Frm_Flgs3_Desc = node.InnerText; break; }
        //            case "frm_flgs5_desc": { p.FRM_Flgs5_Desc = node.InnerText; break; }
        //            case "atc4_desc": { p.ATC4_Desc = node.InnerText; break; }
        //            case "nec4_desc": { p.NEC4_Desc = node.InnerText; break; }
        //            case "org_long_name": { p.Org_Long_Name = node.InnerText; break; }
        //            case "molecules": { p.Molecules = getMolecules(node); break; }

        //            case "packid": { p.PackID = node.InnerText; break; }
        //            case "prod_cd": { p.Prod_cd = node.InnerText; break; }
        //            case "pack_cd": { p.Pack_cd = node.InnerText; break; }
        //            case "pfc": { p.PFC = node.InnerText; break; }
        //            case "productname": { p.ProductName = node.InnerText; break; }
        //            case "product_long_name": { p.Product_Long_Name = node.InnerText; break; }
        //            //case "pack_long_name": { p.Pack_Long_Name = node.InnerText; break; }
        //            case "fcc": { p.FCC = node.InnerText; break; }
        //            case "atc1_code": { p.ATC1_Code = node.InnerText; break; }
        //            case "atc1_desc": { p.ATC1_Desc = node.InnerText; break; }
        //            case "atc2_code": { p.ATC2_Code = node.InnerText; break; }
        //            case "atc2_desc": { p.ATC2_Desc = node.InnerText; break; }
        //            case "atc3_code": { p.ATC3_Code = node.InnerText; break; }
        //            case "atc3_desc": { p.ATC3_Desc = node.InnerText; break; }
        //            case "atc4_code": { p.ATC4_Code = node.InnerText; break; }

        //            case "frm_flgs1": { p.FRM_Flgs1 = node.InnerText; break; }
        //            case "frm_flgs1_desc": { p.FRM_Flgs1_Desc = node.InnerText; break; }
        //            case "frm_flgs2": { p.FRM_Flgs2 = node.InnerText; break; }
        //            case "frm_flgs2_desc": { p.FRM_Flgs2_Desc = node.InnerText; break; }
        //            case "frm_flgs3": { p.FRM_Flgs3 = node.InnerText; break; }
        //            case "frm_flgs4": { p.FRM_Flgs4 = node.InnerText; break; }
        //            case "frm_flgs4_desc": { p.FRM_Flgs4_Desc = node.InnerText; break; }
        //            case "frm_flgs5": { p.FRM_Flgs5 = node.InnerText; break; }
        //            case "frm_flgs6": { p.FRM_Flgs6 = node.InnerText; break; }
        //            case "pbs_formulary": { p.PBS_Formulary = node.InnerText; break; }
        //            case "pbs_formulary_date": { p.PBS_Formulary_Date = node.InnerText; break; }
        //            case "stdy_ind1_code": { p.Stdy_Ind1_Code = node.InnerText; break; }
        //            case "study_indicators1": { p.Study_Indicators1 = node.InnerText; break; }
        //            case "stdy_ind2_code": { p.Stdy_Ind2_Code = node.InnerText; break; }
        //            case "study_indicators2": { p.Study_Indicators2 = node.InnerText; break; }
        //            case "stdy_ind3_code": { p.Stdy_Ind3_Code = node.InnerText; break; }
        //            case "study_indicators3": { p.Study_Indicators3 = node.InnerText; break; }
        //            case "stdy_ind4_code": { p.Stdy_Ind4_Code = node.InnerText; break; }
        //            case "study_indicators4": { p.Study_Indicators4 = node.InnerText; break; }
        //            case "stdy_ind5_code": { p.Stdy_Ind5_Code = node.InnerText; break; }
        //            case "study_indicators5": { p.Study_Indicators5 = node.InnerText; break; }
        //            case "stdy_ind6_code": { p.Stdy_Ind6_Code = node.InnerText; break; }
        //            case "study_indicators6": { p.Study_Indicators6 = node.InnerText; break; }
        //            case "packlaunch": { p.PackLaunch = node.InnerText; break; }
        //            case "prod_lch": { p.Prod_lch = node.InnerText; break; }
        //            case "org_code": { p.Org_Code = node.InnerText; break; }
        //            case "org_abbr": { p.Org_Abbr = node.InnerText; break; }
        //            case "org_short_name": { p.Org_Short_Name = node.InnerText; break; }

        //            case "out_td_dt": { p.Out_td_dt = node.InnerText; break; }
        //            case "prtd_price": { p.Prtd_Price = node.InnerText; break; }
        //            case "pk_size": { p.pk_size = node.InnerText; break; }
        //            case "vol_wt_uns": { p.vol_wt_uns = node.InnerText; break; }
        //            case "vol_wt_meas": { p.vol_wt_meas = node.InnerText; break; }
        //            case "strgh_uns": { p.strgh_uns = node.InnerText; break; }
        //            case "strgh_meas": { p.strgh_meas = node.InnerText; break; }
        //            case "conc_unit": { p.Conc_Unit = node.InnerText; break; }
        //            case "conc_meas": { p.Conc_Meas = node.InnerText; break; }
        //            case "recommended_retail_price": { p.Recommended_Retail_Price = node.InnerText; break; }
        //            case "ret_price_effective_date": { p.Ret_Price_Effective_Date = node.InnerText; break; }
        //            case "editable_pack_description": { p.Editable_Pack_Description = node.InnerText; break; }
        //            case "form_desc_abbr": { p.Form_Desc_Abbr = node.InnerText; break; }
        //            case "form_desc_short": { p.Form_Desc_Short = node.InnerText; break; }
        //            case "form_desc_long": { p.Form_Desc_Long = node.InnerText; break; }
        //            case "nfc1_code": { p.NFC1_Code = node.InnerText; break; }
        //            case "nfc1_desc": { p.NFC1_Desc = node.InnerText; break; }
        //            case "nfc2_code": { p.NFC2_Code = node.InnerText; break; }
        //            case "nfc2_desc": { p.NFC2_Desc = node.InnerText; break; }
        //            case "nfc3_code": { p.NFC3_Code = node.InnerText; break; }
        //            case "nfc3_desc": { p.NFC3_Desc = node.InnerText; break; }
        //            case "price_effective_date": { p.Price_Effective_Date = node.InnerText; break; }
        //            case "last_amd": { p.Last_amd = node.InnerText; break; }
        //            case "pbs_start_date": { p.PBS_Start_Date = node.InnerText; break; }
        //            case "pbs_end_date": { p.PBS_End_Date = node.InnerText; break; }
        //            case "supplier_code": { p.Supplier_Code = node.InnerText; break; }
        //            case "supplier_product_code": { p.Supplier_Product_Code = node.InnerText; break; }

        //            case "apn": { p.APN = node.InnerText; break; }
        //            case "nec1_code": { p.NEC1_Code = node.InnerText; break; }
        //            case "nec1_desc": { p.NEC1_Desc = node.InnerText; break; }
        //            case "nec1_longdesc": { p.NEC1_LongDesc = node.InnerText; break; }
        //            case "nec2_code": { p.NEC2_Code = node.InnerText; break; }
        //            case "nec2_desc": { p.NEC2_desc = node.InnerText; break; }
        //            case "nec2_longdesc": { p.NEC2_LongDesc = node.InnerText; break; }
        //            case "nec3_code": { p.NEC3_Code = node.InnerText; break; }
        //            case "nec3_desc": { p.NEC3_Desc = node.InnerText; break; }
        //            case "nec3_longdesc": { p.NEC3_LongDesc = node.InnerText; break; }
        //            case "nec4_code": { p.NEC4_Code = node.InnerText; break; }
        //            case "nec4_longdesc": { p.NEC4_LongDesc = node.InnerText; break; }

        //            case "ch_segment_code": { p.CH_Segment_Code = node.InnerText; break; }
        //            case "ch_segment_desc": { p.CH_Segment_Desc = node.InnerText; break; }
        //            case "who1_code": { p.WHO1_Code = node.InnerText; break; }
        //            case "who1_desc": { p.WHO1_Desc = node.InnerText; break; }
        //            case "who2_code": { p.WHO2_Code = node.InnerText; break; }
        //            case "who2_desc": { p.WHO2_Desc = node.InnerText; break; }
        //            case "who3_code": { p.WHO3_Code = node.InnerText; break; }
        //            case "who3_desc": { p.WHO3_Desc = node.InnerText; break; }
        //            case "who4_code": { p.WHO4_Code = node.InnerText; break; }
        //            case "who4_desc": { p.WHO4_Desc = node.InnerText; break; }
        //            case "who5_code": { p.WHO5_Code = node.InnerText; break; }
        //            case "who5_desc": { p.WHO5_Desc = node.InnerText; break; }
        //            case "compound_indicator": { p.Compound_Indicator = node.InnerText; break; }
        //            case "compound_ind_desc": { p.Compound_Ind_Desc = node.InnerText; break; }
        //            case "poison_schedule": { p.Poison_Schedule = node.InnerText; break; }
        //            case "poison_schedule_desc": { p.Poison_Schedule_Desc = node.InnerText; break; }
        //            case "additional_strength": { p.Additional_Strength = node.InnerText; break; }
        //            case "additional_pack_info": { p.Additional_Pack_Info = node.InnerText; break; }
        //            case "trade_product_pack_id": { p.Trade_Product_Pack_ID = node.InnerText; break; }
        //        }

        //    }
        //    return p;
        //}

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
        private Pack ParsePack(XmlNode packXmlNode)
        {

            Pack p = new Pack();
            foreach (XmlNode node in packXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "productname": { p.ProductName = node.InnerText; break; }
                    case "packid": { p.Id = node.InnerText; break; }
                }

            }
            return p;
        }

        //private string BuildFilter(ICollection<Filter> parameters)
        //{
        //    // string samples = string.Join(",", list.Select(x => x.sample));

        //    parameters.Aggregate(f => f.)

        //}

        private ICollection<ISolrQuery> BuildFilterQueries(ICollection<Filter> parameters)
        {
            var queriesFromFacets = from p in parameters
                                    select (ISolrQuery)Query.Field(p.Criteria).Is(p.Value);
            return queriesFromFacets.ToList();
        }

        public class XmlToDynamic
        {
            public static void Parse(dynamic parent, XElement node)
            {
                if (node.HasElements)
                {
                    if (node.Elements(node.Elements().First().Name.LocalName).Count() > 1)
                    {
                        //list
                        var item = new ExpandoObject();
                        var list = new List<dynamic>();
                        foreach (var element in node.Elements())
                        {
                            Parse(list, element);
                        }

                        AddProperty(item, node.Elements().First().Name.LocalName, list);
                        AddProperty(parent, node.Name.ToString(), item);
                    }
                    else
                    {
                        var item = new ExpandoObject();

                        foreach (var attribute in node.Attributes())
                        {
                            AddProperty(item, attribute.Name.ToString(), attribute.Value.Trim());
                        }

                        //element
                        foreach (var element in node.Elements())
                        {
                            Parse(item, element);
                        }

                        AddProperty(parent, node.Name.ToString(), item);
                    }
                }
                else
                {
                    AddProperty(parent, node.Name.ToString(), node.Value.Trim());
                }
            }

            private static void AddProperty(dynamic parent, string name, object value)
            {
                if (parent is List<dynamic>)
                {
                    (parent as List<dynamic>).Add(value);
                }
                else
                {
                    (parent as IDictionary<String, object>)[name] = value;
                }
            }
        }

        // GET: api/Packs/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/Packs
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/Packs/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Packs/5
        public void Delete(int id)
        {
        }

        [Route("api/export")]
        [HttpPost]
        public async Task<HttpResponseMessage> ExportToExcel(string options)
        {
            var eOptions = JsonConvert.DeserializeObject<Options>(options);
            var columns = eOptions.exportOptions;
            var searchParams = eOptions.filterOptions;

            List<PackResult> lstPack = new List<PackResult>();
            DataTable dt = new DataTable("pack");

            dt = await packsProvider.GetPacksForExcel(columns, searchParams);

            MemoryStream stream = new MemoryStream();
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
            if (eOptions.Type.Equals("csv", StringComparison.InvariantCultureIgnoreCase))
            {
                StreamWriter writer = new StreamWriter(stream);
                writer.Write(GetCSVString(dt));
                writer.Flush();
                stream.Position = 0;
                result.Content = new StreamContent(stream);
                result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
                result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = "PackSearch.csv" };
            }

            if (eOptions.Type.Equals("xlsx"))
            {
                stream = GetExcelStream(dt, eOptions.exportOptions);
                // Reset Stream Position
                stream.Position = 0;
                result.Content = new StreamContent(stream);

                // Generic Content Header
                result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

                //Set Filename sent to client
                result.Content.Headers.ContentDisposition.FileName = "PackSearch.xlsx";

            }

            return result;
        }

        public string GetCSVString(DataTable dtContacts)
        {
            //DataTable dtContacts = ToDataTable(Packresults);
            StringBuilder sb = new StringBuilder();
            for (int colCount = 0; colCount < dtContacts.Columns.Count; colCount++)
            {
                sb.Append(dtContacts.Columns[colCount].ColumnName);
                if (colCount != dtContacts.Columns.Count - 1)
                {
                    sb.Append(",");
                }
                else
                {
                    sb.AppendLine();
                }
            }

            for (int rowCount = 0; rowCount < dtContacts.Rows.Count; rowCount++)
            {
                for (int colCount = 0; colCount < dtContacts.Columns.Count; colCount++)
                {
                    if (dtContacts.Columns[colCount].Caption.ToLower() == "apn" || dtContacts.Columns[colCount].Caption.ToLower() == "pfc" ||
                        dtContacts.Columns[colCount].Caption.ToLower() == "fcc" || dtContacts.Columns[colCount].Caption.ToLower() == "packid" ||
                        dtContacts.Columns[colCount].Caption.ToLower() == "prod_cd" || dtContacts.Columns[colCount].Caption.ToLower() == "org_code" ||
                        dtContacts.Columns[colCount].Caption.ToLower() == "pk_size")
                        sb.Append("\t" + dtContacts.Rows[rowCount][colCount]);
                    else
                        sb.Append(dtContacts.Rows[rowCount][colCount]);

                    if (colCount != dtContacts.Columns.Count - 1)
                    {
                        sb.Append(",");
                    }
                }
                if (rowCount != dtContacts.Rows.Count - 1)
                {
                    sb.AppendLine();
                }
            }

            return sb.ToString();
        }

        //public async Task<HttpResponseMessage> GetPackSearcResultsForExport(ICollection<Filter> searchParams, string[] columns)
        //{
        //    List<PackResult> lstPack = new List<PackResult>();

        //    var sObj = searchParams.FirstOrDefault(p => p.Criteria == "start");
        //    if (sObj != null) searchParams.Remove(sObj);
        //    string rows = searchParams.FirstOrDefault(p => p.Criteria == "rows").Value;
        //    int noRows = 10;
        //    int.TryParse(rows, out noRows);
        //    var rObj = searchParams.FirstOrDefault(p => p.Criteria == "rows");

        //    if (rObj != null) searchParams.Remove(rObj);

        //    var filterQuery = "";
        //    if (searchParams != null)
        //    {
        //        filterQuery = string.Join("+AND+",
        //        searchParams
        //        .Where(f => !string.IsNullOrWhiteSpace(f.Value))
        //        .Select(f => getCriteria(f.Criteria, f.Value))
        //    );
        //    }
        //    if (string.IsNullOrWhiteSpace(filterQuery)) { filterQuery = "*:*"; }
        //    var filterCols = "";

        //    if (columns.Length > 0)
        //        filterCols = string.Join(",", columns);

        //    if (!string.IsNullOrWhiteSpace(filterCols)) { filterQuery += "&fl=" + filterCols + "&rows=1000000"; }

        //    var client = new HttpClient();

        //    client.BaseAddress = new Uri(packsSolrURL);
        //    client.DefaultRequestHeaders
        //        .Accept
        //        .Add(new MediaTypeWithQualityHeaderValue("application/json"));

        //    return await client.GetAsync("?q=" + filterQuery);

        //}



        public static MemoryStream GetExcelStream(DataTable list1, string[] columns)
        {
            ExcelPackage pck = new ExcelPackage();

            // get the handle to the existing worksheet
            var wsData = pck.Workbook.Worksheets.Add("Pack Search");
            var dataRange = wsData.Cells["A1"].LoadFromDataTable(list1, true);

            //var dataRange = wsData.Cells["A1"].LoadFromCollection
            //        (from s in list1
            //         select s,
            //       true);


            var headerCells = wsData.Cells[1, 1, 1, wsData.Dimension.End.Column];
            var headerFont = headerCells.Style.Font;
            headerFont.Bold = true;
            dataRange.AutoFitColumns();
            pck.Save();
            MemoryStream output = new MemoryStream();
            pck.SaveAs(output);
            return output;
        }

        public static DataTable ToDataTable<T>(ICollection<T> data)
        {
            PropertyDescriptorCollection properties =
                TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            return table;
        }



        //public static DataTable ConvertXmlNodeListToDataTable(XmlNodeList xnl, DataTable dt)
        //{

        //    int ColumnsCount = dt.Columns.Count;
        //    foreach (XmlNode i in xnl)
        //    {
        //        if (i.Attributes != null)
        //        {
        //            DataRow dr = dt.NewRow();
        //            foreach (XmlNode childNode in i.ChildNodes)
        //            {
        //                if (childNode != null)
        //                {
        //                    string colName = childNode.Attributes[0].Value;
        //                    string colVal = childNode.InnerText;
        //                    dr[colName] = colVal;
        //                }
        //            }
        //            dt.Rows.Add(dr);
        //        }
        //    }

        //    try
        //    {
        //        if (dt.Columns.Contains("Pack_Description")) dt.Columns["Pack_Description"].ColumnName = "Pack Description";
        //        if (dt.Columns.Contains("Org_Long_Name")) dt.Columns["Org_Long_Name"].ColumnName = "Manufacturer";
        //        if (dt.Columns.Contains("FRM_Flgs5_Desc")) dt.Columns["FRM_Flgs5_Desc"].ColumnName = "Flagging";
        //        if (dt.Columns.Contains("Frm_Flgs3_Desc")) dt.Columns["Frm_Flgs3_Desc"].ColumnName = "Branding";
        //        if (dt.Columns.Contains("ProductName")) dt.Columns["ProductName"].ColumnName = "Product Description";
        //        if (dt.Columns.Contains("ATC4_Desc")) dt.Columns["ATC4_Desc"].ColumnName = "ATC4";
        //        if (dt.Columns.Contains("NEC4_Desc")) dt.Columns["NEC4_Desc"].ColumnName = "NEC4";
        //        if (dt.Columns.Contains("APN")) dt.Columns["APN"].ColumnName = "APN/EAN/GTIN (barcode)";
        //        if (dt.Columns.Contains("MOLECULES")) dt.Columns["MOLECULES"].ColumnName = "Molecules";
        //    }
        //    catch (Exception)
        //    {

        //        throw;
        //    }

        //    //dt.AcceptChanges();
        //    return dt;

        //}

        [Route("api/GetPackDescSearchResult")]
        [HttpPost]
        public string GetPackDescSearchResult([FromBody] ICollection<Filter> searchParams)
        {
            string filterQuery = "";
            string finalString = "";
            int clientid = 0;
            if (searchParams != null)
            {
                var rObj = searchParams.FirstOrDefault(p => p.Criteria == "ClientId");
                if (rObj != null)
                {
                    Int32.TryParse(rObj.Value, out clientid);
                }

                filterQuery = string.Join(" AND ",
                searchParams
                .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                .Select(f => getPackDescriptionCriteria(f.Criteria, f.Value))
            );
            }
            string filterQueryTrim = filterQuery.TrimEnd();
            string lastWord = filterQueryTrim.Split(' ').Last();
            if (lastWord.Trim() == "AND")
            {
                finalString = filterQueryTrim.Remove(filterQueryTrim.LastIndexOf(" ")).Trim();
            }
            string ConnectionString = "EverestPortalConnection";
            DataTable packRes = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("GetPacksFromClientMarketBase", conn))
                    {
                        cmd.Parameters.AddWithValue("@Clientid", clientid);
                        cmd.Parameters.AddWithValue("@searchString", finalString);



                        using (var da = new SqlDataAdapter(cmd))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            da.Fill(packRes);
                        }

                    }
                }
                var json = JsonConvert.SerializeObject(packRes, Newtonsoft.Json.Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

                return json;
            }
            catch (Exception ex)
            {

                var json = JsonConvert.SerializeObject(packRes, Newtonsoft.Json.Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

                return json;
            }


        }



    }
    //thest two class should move to model.
    public class PackWithMarketBase
    {
        public string Pack { get; set; }
        public string MarketBase { get; set; }
    }
    public class PackDescResult
    {
        public string PackDescription { get; set; }
        public string Manufacturer { get; set; }
        public string ATC { get; set; }
        public string NEC { get; set; }
        public string Molecule { get; set; }
        public string Flagging { get; set; }
        public string Branding { get; set; }

    }
    public class PackResultResponse
    {
        public int recCount { get; set; }
        public List<PackResult> packResult { get; set; }

    }
}
