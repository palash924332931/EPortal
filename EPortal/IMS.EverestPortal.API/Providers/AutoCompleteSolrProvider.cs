using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Models;
using System.Configuration;
using Newtonsoft.Json;
using SolrNet;
using Microsoft.Practices.ServiceLocation;
using SolrNet.Commands.Parameters;
using System.Text;
using System.Net.Http.Headers;
using System.Net.Http;

namespace IMS.EverestPortal.API.Providers
{
    public class AutoCompleteSolrProvider : IAutoCompleteProvider
    {
        private readonly string packsSolrURL = ConfigurationManager.AppSettings["solrPackSearchURL"];
        private readonly string solrAtc1Url = ConfigurationManager.AppSettings["solrAtc1Url"] + "/select";
        private readonly string solrAtc2Url = ConfigurationManager.AppSettings["solrAtc2Url"] + "/select";
        private readonly string solrAtc3Url = ConfigurationManager.AppSettings["solrAtc3Url"] + "/select";
        private readonly string solrAtc4Url = ConfigurationManager.AppSettings["solrAtc4Url"] + "/select";
        private readonly string solrNec1Url = ConfigurationManager.AppSettings["solrNec1Url"] + "/select";
        private readonly string solrNec2Url = ConfigurationManager.AppSettings["solrNec2Url"] + "/select";
        private readonly string solrNec3Url = ConfigurationManager.AppSettings["solrNec3Url"] + "/select";
        private readonly string solrNec4Url = ConfigurationManager.AppSettings["solrNec4Url"] + "/select";
        private readonly string solrMoleculeUrl = ConfigurationManager.AppSettings["solrMoleculeUrl"] + "/select";
        private readonly string solrManufacturerUrl = ConfigurationManager.AppSettings["solrManufacturerUrl"] + "/select";
        private readonly string solrProductUrl = ConfigurationManager.AppSettings["solrProductUrl"] + "/select";
        private readonly string packsName = ConfigurationManager.AppSettings["packsName"];

        public string GetAtc([FromBody] ICollection<Filter> searchParams)
        {
            var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Atc>>();
            var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("ATC_Code", Order.ASC) } });

            string jsonString = string.Empty;
            jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                new JsonSerializerSettings
                {
                    PreserveReferencesHandling = PreserveReferencesHandling.Objects
                });

            return jsonString;
        }

        public async Task<string> GetAtc1(ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Atc1>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("ATC1_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Atc1");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetAtc2( ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Atc2>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("ATC2_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Atc2");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetAtc3([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Atc3>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("ATC3_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Atc3");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetAtc4([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Atc4>>();
                SolrQuery q = new SolrQuery("*:*");
                var r = solr.Query(q, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("ATC4_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Atc4");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetManufacturer([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Manufacturer>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("Org_Long_Name", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Manufacturer");



                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetMolecule([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Molecule>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("Description", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Molecule");

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public string GetNec([FromBody] ICollection<Filter> searchParams)
        {
            var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Nec>>();
            var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("NEC_Code", Order.ASC) } });

            string jsonString = string.Empty;
            jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                new JsonSerializerSettings
                {
                    PreserveReferencesHandling = PreserveReferencesHandling.Objects
                });

            return jsonString;
        }

        public async Task<string> GetNec1([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Nec1>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("NEC1_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Nec1");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetNec2([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Nec2>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("NEC2_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Nec2");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetNec3([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Nec3>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("NEC3_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;

            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Nec3");

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetNec4([FromBody] ICollection<Filter> searchParams)
        {
            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Nec4>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("NEC4_Code", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Nec4");



                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
        }

        public async Task<string> GetProduct([FromBody] ICollection<Filter> searchParams)
        {

            if (searchParams == null || searchParams.Count == 0)
            {
                var solr = ServiceLocator.Current.GetInstance<ISolrOperations<Product>>();
                var r = solr.Query(SolrQuery.All, new QueryOptions() { OrderBy = new SortOrder[] { new SortOrder("Product_Long_Name", Order.ASC) } });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(r, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }
            else
            {
                List<Object> result = await GetFilteredList(searchParams, "Product");


                // lstPack.Add(new PackResult { PackDescription = "Pack Description1", Manufacturer = "manufacture1", ATC = "ATC1", NEC = "NEC1", Molecule = "Molecule1", Flagging = "Flagging", Branding = "Branding" });

                string jsonString = string.Empty;
                jsonString = JsonConvert.SerializeObject(result, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                return jsonString;
            }

            
        }


        private async Task<List<Object>> GetFilteredList(ICollection<Filter> searchParams, string type)
        {
            var filterQuery = "";

            string queryCode = ""; string solrUrl = null;
            switch (type.ToLower())
            {
                case "atc1": { queryCode = "ATC1_Code"; solrUrl = solrAtc1Url; break; }
                case "atc2": { queryCode = "ATC2_Code"; solrUrl = solrAtc2Url; break; }
                case "atc3": { queryCode = "ATC3_Code"; solrUrl = solrAtc3Url; break; }
                case "atc4": { queryCode = "ATC4_Code"; solrUrl = solrAtc4Url; break; }
                case "nec1": { queryCode = "NEC1_Code"; solrUrl = solrNec1Url; break; }
                case "nec2": { queryCode = "NEC2_Code"; solrUrl = solrNec2Url; break; }
                case "nec3": { queryCode = "NEC3_Code"; solrUrl = solrNec3Url; break; }
                case "nec4": { queryCode = "NEC4_Code"; solrUrl = solrNec4Url; break; }
                case "molecule": { queryCode = "FCC"; solrUrl = solrMoleculeUrl; break; }
                case "manufacturer": { queryCode = "Org_Code"; solrUrl = solrManufacturerUrl; break; }
                case "product": { queryCode = "Product_Long_Name"; solrUrl = solrProductUrl; break; }

            }

            //sample join query
            //*:*&fq={!join from=ATC4_Code to=ATC4_Code fromIndex=packs}ATC1_Code:A+AND+Org_Long_Name:ALCON
            filterQuery = joinFilters(searchParams);

            if (string.IsNullOrWhiteSpace(filterQuery)) { filterQuery = "*:*"; }

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(solrUrl);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var sortBy = (queryCode.ToLower() == "fcc") ? "Description" : queryCode;
                switch (queryCode.ToLower())
                {
                    case "fcc":
                        {
                            sortBy = "Description";
                            break;
                        }
                    case "org_code":
                        {
                            sortBy = "Org_Long_Name";
                            break;
                        }
                }
                var q = "?q=*:*";
                if (type.ToLower() == "molecule")
                {
                    var val = searchParams.Single(x => x.Criteria.ToLower() == "description");
                    if (val != null)
                    {
                        q = "?q=Description:*" + val.Value.ToUpper();
                    }
                }
                var queryResult = await client.GetAsync(q + "&sort=" + sortBy + " asc&fq={!join from=" + queryCode + " to=" + queryCode + " fromIndex=" + packsName + "}" + filterQuery);
                resultContent = queryResult.Content.ReadAsStringAsync().Result;
            }

            List<Object> result = new List<Object>();
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            doc.LoadXml(resultContent);
            foreach (System.Xml.XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                switch (type.ToLower())
                {
                    case "atc1": { result.Add(ParseATC1(node)); break; }
                    case "atc2": { result.Add(ParseATC2(node)); break; }
                    case "atc3": { result.Add(ParseATC3(node)); break; }
                    case "atc4": { result.Add(ParseATC4(node)); break; }
                    case "nec1": { result.Add(ParseNEC1(node)); break; }
                    case "nec2": { result.Add(ParseNEC2(node)); break; }
                    case "nec3": { result.Add(ParseNEC3(node)); break; }
                    case "nec4": { result.Add(ParseNEC4(node)); break; }
                    case "molecule": { result.Add(ParseMolecule(node)); break; }
                    case "manufacturer": { result.Add(ParseManufacturer(node)); break; }
                    case "product": { result.Add(ParseProduct(node)); break; }

                }
            }

            return result;
        }

        private string joinFilters(ICollection<Filter> filters)
        {
            StringBuilder str = new StringBuilder();
            Dictionary<string, ICollection<Filter>> list = new Dictionary<string, ICollection<Filter>>();
            Filter searchFilter = null;
            foreach (Filter filter in filters)
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

            string previousAttribute = "";

            foreach (ICollection<Filter> filterList in list.Values)
            {
                if (filterList.First() != null)
                {
                    if (filterList.First().Condition.ToLower() == "restrict" || (previousAttribute != "" && previousAttribute.Substring(0, 3) != filterList.First().Criteria.Substring(0, 3)))
                    {
                        str.Append("+AND+");
                    }
                    else
                    {
                        str.Append("+OR+");
                    }
                }
                else
                {
                    str.Append("+OR+");
                }
                previousAttribute = filterList.First().Criteria;
                if (filterList.First() != null && filterList.First().Condition.ToLower() == "restrict") { str.Append("-"); }


                str.Append("(");
                string filterQuery = string.Join("+OR+",
                    filterList
                    .Where(f => !string.IsNullOrWhiteSpace(f.Value))
                    .Select(f => getCriteria(f.Criteria, f.Value))
                    );
                str.Append(filterQuery);
                str.Append(")");

            }
            if (str.Length > 0)
            {
                if (str[2] == 'R')
                {
                    str.Remove(0, 4);
                }
                else
                {
                    str.Remove(0, 5);
                }

                str.Append("+AND+");
            }
            str.Append(getCriteria(searchFilter.Criteria, searchFilter.Value));

            return str.ToString();
        }

        private string getCriteria(string criteria, string value)
        {
            //build pack search filter

            string result = "";
            StringBuilder str = new StringBuilder();


            string[] attrValues = value.Split(',');
            str.Append("(");
            foreach (string val in attrValues)
            {

                switch (criteria.ToLower())
                {
                    case "atc4_code": case "atc4": { str.Append("ATC4_Code:"); str.Append(val.ToUpper()); break; }
                    case "atc3_code": case "atc3": { str.Append("ATC3_Code:"); str.Append(val.ToUpper()); break; }
                    case "atc2_code": case "atc2": { str.Append("ATC2_Code:"); str.Append(val.ToUpper()); break; }
                    case "atc1_code": case "atc1": { str.Append("ATC1_Code:"); str.Append(val.ToUpper()); break; }
                    case "nec4_code": case "nec4": { str.Append("NEC4_Code:"); str.Append(val.ToUpper()); break; }
                    case "nec3_code": case "nec3": { str.Append("NEC3_Code:"); str.Append(val.ToUpper()); break; }
                    case "nec2_code": case "nec2": { str.Append("NEC2_Code:"); str.Append(val.ToUpper()); break; }
                    case "nec1_code": case "nec1": { str.Append("NEC1_Code:"); str.Append(val.ToUpper()); break; }
                    case "atc4_desc": { str.Append("ATC4_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "atc3_desc": { str.Append("ATC3_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "atc2_desc": { str.Append("ATC2_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "atc1_desc": { str.Append("ATC1_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "nec4_desc": { str.Append("NEC4_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "nec3_desc": { str.Append("NEC3_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "nec2_desc": { str.Append("NEC2_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "nec1_desc": { str.Append("NEC1_Desc:*"); str.Append(val.ToUpper()); break; }
                    case "product": case "productname": { str.Append("Product_Long_Name:*"); str.Append(val.ToUpper().Replace(" ", "\\ ") + "*"); break; }
                    case "packdescription": { str.Append("Pack_Description:*"); str.Append(val.ToUpper().Replace(" ", "\\ ") + "*"); ; break; }
                    case "manufacturer": case "mfr": case "org_long_name": { str.Append("Org_Long_Name:"); str.Append(val.ToUpper().Replace(" ", "\\ ") + "*"); break; }
                    case "flagging": { if (value.ToLower() != "all") { str.Append("FRM_Flgs5_Desc:"); str.Append(val); } break; }
                    case "branding": { if (value.ToLower() != "all") { str.Append("Frm_Flgs3_Desc:"); str.Append(val); } break; }
                    case "molecule": case "description": { str.Append("MOLECULES:*"); str.Append(val.ToUpper().Replace(" ", "\\ ").Replace("+", "\\+").Replace(")", "\\)").Replace("(", "\\(") + "*"); break; }
                    case "orderby":
                        {
                            string[] values = value.Split(',');
                            result = "sort=" + values[0] + values[1] == "asc" ? " asc" : " desc";
                            return result;
                        }
                }
                str.Append("+OR+");
            }
            str.Remove(str.Length - 4, 4);
            str.Append(")");
            return str.ToString();

        }

        private Atc1 ParseATC1(System.Xml.XmlNode atc4XmlNode)
        {

            Atc1 p = new Atc1();
            foreach (System.Xml.XmlNode node in atc4XmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "atc1_code": { p.ATC1_Code = node.InnerText; break; }
                    case "atc1_desc": { p.ATC1_Desc = node.InnerText; break; }
                }

            }
            return p;
        }
        private Atc2 ParseATC2(System.Xml.XmlNode atc4XmlNode)
        {

            Atc2 p = new Atc2();
            foreach (System.Xml.XmlNode node in atc4XmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "atc2_code": { p.ATC2_Code = node.InnerText; break; }
                    case "atc2_desc": { p.ATC2_Desc = node.InnerText; break; }
                }

            }
            return p;
        }
        private Atc3 ParseATC3(System.Xml.XmlNode atc3XmlNode)
        {

            Atc3 p = new Atc3();
            foreach (System.Xml.XmlNode node in atc3XmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "atc3_code": { p.ATC3_Code = node.InnerText; break; }
                    case "atc3_desc": { p.ATC3_Desc = node.InnerText; break; }
                }

            }
            return p;
        }
        private Atc4 ParseATC4(System.Xml.XmlNode atc4XmlNode)
        {

            Atc4 p = new Atc4();
            foreach (System.Xml.XmlNode node in atc4XmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "atc4_code": { p.ATC4_Code = node.InnerText; break; }
                    case "atc4_desc": { p.ATC4_Desc = node.InnerText; break; }
                }

            }
            return p;
        }

        private Nec4 ParseNEC4(System.Xml.XmlNode necXmlNode)
        {

            Nec4 p = new Nec4();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "nec4_code": { p.NEC4_Code = node.InnerText; break; }
                    case "nec4_desc": { p.NEC4_Desc = node.InnerText; break; }
                }

            }
            return p;
        }
        private Nec1 ParseNEC1(System.Xml.XmlNode necXmlNode)
        {

            Nec1 p = new Nec1();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "nec1_code": { p.NEC1_Code = node.InnerText; break; }
                    case "nec1_desc": { p.NEC1_Desc = node.InnerText; break; }
                }

            }
            return p;
        }
        private Nec2 ParseNEC2(System.Xml.XmlNode necXmlNode)
        {

            Nec2 p = new Nec2();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "nec2_code": { p.NEC2_Code = node.InnerText; break; }
                    case "nec2_desc": { p.NEC2_Desc = node.InnerText; break; }
                }

            }
            return p;
        }
        private Nec3 ParseNEC3(System.Xml.XmlNode necXmlNode)
        {

            Nec3 p = new Nec3();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "nec3_code": { p.NEC3_Code = node.InnerText; break; }
                    case "nec3_desc": { p.NEC3_Desc = node.InnerText; break; }
                }

            }
            return p;
        }

        private Manufacturer ParseManufacturer(System.Xml.XmlNode necXmlNode)
        {

            Manufacturer p = new Manufacturer();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "org_code": { p.Org_Code = int.Parse(node.InnerText); break; }
                    case "org_abbr": { p.Org_Abbr = node.InnerText; break; }
                    case "org_long_name": { p.Org_Long_Name = node.InnerText; break; }
                }

            }
            return p;
        }

        private Molecule ParseMolecule(System.Xml.XmlNode necXmlNode)
        {

            Molecule p = new Molecule();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "molecule": { p.MoleculeId = int.Parse(node.InnerText); break; }
                    case "description": { p.Description = node.InnerText; break; }
                }

            }
            return p;
        }

        private Product ParseProduct(System.Xml.XmlNode necXmlNode)
        {

            Product p = new Product();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "prod_cd": { p.Id = node.InnerText; break; }
                    case "productname": { p.ProductName = node.InnerText; break; }
                    case "product_long_name": { p.Product_Long_Name = node.InnerText; break; }
                }

            }
            return p;
        }

        public Task<string> GetPoisonSchedule(ICollection<Filter> searchParams)
        {
            throw new NotImplementedException();
        }

        public Task<string> GetForm(ICollection<Filter> searchParams)
        {
            throw new NotImplementedException();
        }
    }
}