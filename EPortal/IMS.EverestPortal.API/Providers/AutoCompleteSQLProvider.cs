using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.DAL;
using Newtonsoft.Json;
using IMS.EverestPortal.API.Models.Report;
using System.Text;
using System.Linq.Dynamic;
using IMS.EverestPortal.API.DAL.Interfaces;

namespace IMS.EverestPortal.API.Providers
{
    public class AutoCompleteSQLProvider : IAutoCompleteProvider
    {
        IDIMProductExpanded dimProductExpanded = null;

        public AutoCompleteSQLProvider()
        {
            //refactor to use DI
            dimProductExpanded = new DIMProductExpanded();
        }

        public AutoCompleteSQLProvider(IDIMProductExpanded dimProductExpanded)
        {
            this.dimProductExpanded = dimProductExpanded;
        }

        private readonly int numberOfItems = 10;

        public string GetAtc([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                if (searchParams == null || searchParams.Count == 0)
                {
                    var query = db.ReportParameters.Select(atc1 => new { ATC_Code = atc1.ATC1_Code, ATC_Desc = atc1.ATC1_Desc })
                    .Union(db.ReportParameters.Select(atc2 => new { ATC_Code = atc2.ATC2_Code, ATC_Desc = atc2.ATC2_Desc }))
                    .Union(db.ReportParameters.Select(atc3 => new { ATC_Code = atc3.ATC3_Code, ATC_Desc = atc3.ATC3_Desc }))
                    .Where(atc => !string.IsNullOrEmpty(atc.ATC_Code) && !string.IsNullOrEmpty(atc.ATC_Desc))
                    .Distinct().OrderBy(x => x.ATC_Code).Take(numberOfItems).ToList();

                    jsonString = JsonConvert.SerializeObject(query, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            PreserveReferencesHandling = PreserveReferencesHandling.Objects
                        });
                }
                else
                {
                    var value = searchParams.ToArray()[0].Value;
                    if (value.Length == 1)
                    {
                        var query = db.ReportParameters.Select(atc1 => new { ATC_Code = atc1.ATC1_Code, ATC_Desc = atc1.ATC1_Desc })
                        .Union(db.ReportParameters.Select(atc2 => new { ATC_Code = atc2.ATC2_Code, ATC_Desc = atc2.ATC2_Desc }))
                        .Union(db.ReportParameters.Select(atc3 => new { ATC_Code = atc3.ATC3_Code, ATC_Desc = atc3.ATC3_Desc }))
                        .Where(atc => (atc.ATC_Code.Contains(value))
                        && !string.IsNullOrEmpty(atc.ATC_Code) && !string.IsNullOrEmpty(atc.ATC_Desc))
                        .Distinct().OrderBy(x => x.ATC_Code).Take(numberOfItems).ToList();

                        jsonString = JsonConvert.SerializeObject(query, Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                PreserveReferencesHandling = PreserveReferencesHandling.Objects
                            });
                    }
                    else
                    {
                        var query = db.ReportParameters.Select(atc1 => new { ATC_Code = atc1.ATC1_Code, ATC_Desc = atc1.ATC1_Desc })
                        .Union(db.ReportParameters.Select(atc2 => new { ATC_Code = atc2.ATC2_Code, ATC_Desc = atc2.ATC2_Desc }))
                        .Union(db.ReportParameters.Select(atc3 => new { ATC_Code = atc3.ATC3_Code, ATC_Desc = atc3.ATC3_Desc }))
                        .Where(atc => (atc.ATC_Code.Contains(value) || atc.ATC_Desc.Contains(value))
                        && !string.IsNullOrEmpty(atc.ATC_Code) && !string.IsNullOrEmpty(atc.ATC_Desc))
                        .Distinct().OrderBy(x => x.ATC_Code).Take(numberOfItems).ToList();

                        jsonString = JsonConvert.SerializeObject(query, Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                PreserveReferencesHandling = PreserveReferencesHandling.Objects
                            });
                    }
                }
            }
            return jsonString;
        }

        public async Task<string> GetAtc1([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }
                //AddFilter(query, searchParams);

                var atcs = query.Select(a => new Atc1() { ATC1_Code = a.ATC1_Code, ATC1_Desc = a.ATC1_Desc })
                    .Where(x => !string.IsNullOrEmpty(x.ATC1_Code) && !string.IsNullOrEmpty(x.ATC1_Desc))
                    .Distinct().OrderBy(x => x.ATC1_Code).Take(numberOfItems).ToList();

                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }

        public async Task<string> GetAtc2([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Atc2() { ATC2_Code = a.ATC2_Code, ATC2_Desc = a.ATC2_Desc })
                     .Where(x => !string.IsNullOrEmpty(x.ATC2_Code) && !string.IsNullOrEmpty(x.ATC2_Desc))
                    .Distinct().OrderBy(x => x.ATC2_Code).Take(numberOfItems).ToList();

                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }

        public async Task<string> GetAtc3([FromBody] ICollection<Filter> searchParams)
        {
            try
            {
                string jsonString = string.Empty;

                using (var db = new EverestPortalContext())
                {
                    IQueryable<ReportParamList> query = null;
                    if (searchParams == null || searchParams.Count == 0)
                    {
                        query = db.ReportParameters.Select(a => a);
                    }
                    else
                    {
                        string whereClause = dimProductExpanded.GetFilter(searchParams);
                        query = db.ReportParameters.Select(a => a).Where(whereClause);
                    }
                    //AddFilter(query, searchParams);

                    var atcs = query.Select(a => new Atc3() { ATC3_Code = a.ATC3_Code, ATC3_Desc = a.ATC3_Desc })
                         .Where(x => !string.IsNullOrEmpty(x.ATC3_Code) && !string.IsNullOrEmpty(x.ATC3_Desc))
                        .Distinct().OrderBy(x => x.ATC3_Code).Take(numberOfItems).ToList();


                    jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            PreserveReferencesHandling = PreserveReferencesHandling.Objects
                        });
                }
                return jsonString;
            }
            catch (Exception exc)
            {
                //log 
                throw (exc);
            }
        }

        public async Task<string> GetAtc4([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Atc4() { ATC4_Code = a.ATC4_Code, ATC4_Desc = a.ATC4_Desc })
                     .Where(x => !string.IsNullOrEmpty(x.ATC4_Code) && !string.IsNullOrEmpty(x.ATC4_Desc))
                    .Distinct().OrderBy(x => x.ATC4_Code).Take(numberOfItems).ToList();


                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }

        public async Task<string> GetManufacturer([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize)
        {
            string jsonString = string.Empty;
            
            var result = dimProductExpanded.GetManufacturer(searchParams, currentPage, pageSize);
            if (result != null && result.Data != null)
            {
                jsonString = JsonConvert.SerializeObject(result.Data, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }

        public async Task<string> GetMolecule([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                if (searchParams == null || searchParams.Count == 0)
                {
                    var query = db.ReportParameters.Join(db.Molecules,
                            product => product.FCC,
                            molecule => molecule.FCC,
                            (product, molecule) => new { product, molecule });

                    var atcs = query.Select(x =>
                        new Molecule()
                        {
                            //MoleculeId = x.molecule.Molecule,
                            //Synonym = x.molecule.Synonym,
                            //Parent = x.molecule.Parent,
                            Description = x.molecule.Description
                        })
                         .Where(x => !string.IsNullOrEmpty(x.Description))
                        .Distinct().OrderBy(x => x.Description).Take(numberOfItems).ToList();

                    jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams, true);
                    var query = db.ReportParameters.Join(db.Molecules,
                            product => product.FCC,
                            molecule => molecule.FCC,
                            (product, molecule) => new { product, molecule })
                            .Where(whereClause);

                    var atcs = query.Select(x =>
                        new Molecule()
                        {
                            //MoleculeId = x.molecule.Molecule,
                            //Synonym = x.molecule.Synonym,
                            //Parent = x.molecule.Parent,
                            Description = x.molecule.Description
                        })
                         .Where(x => !string.IsNullOrEmpty(x.Description))
                        .Distinct().OrderBy(x => x.Description).Take(numberOfItems).ToList();

                    jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
                }
            }

            return jsonString;
        }


        public async Task<string> GetPoisonSchedule([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);                    
                }

                var atcs = query.Select(a => new PoisonSchedule() { Poison_Schedule = a.Poison_Schedule, Poison_Schedule_Desc = a.Poison_Schedule_Desc })
                    .Where(x => !string.IsNullOrEmpty(x.Poison_Schedule_Desc) && !string.IsNullOrEmpty(x.Poison_Schedule_Desc))
                    .Distinct().OrderBy(x => x.Poison_Schedule_Desc).Take(numberOfItems).ToList();

                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }
        public async Task<string> GetForm([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }
                //AddFilter(query, searchParams);

                var atcs = query.Select(a => new Form() { Form_Desc_Abbr = a.Form_Desc_Abbr, Form_Desc_Short = a.Form_Desc_Short })
                    .Where(x => !string.IsNullOrEmpty(x.Form_Desc_Abbr) && !string.IsNullOrEmpty(x.Form_Desc_Abbr))
                    .Distinct().OrderBy(x => x.Form_Desc_Abbr).Take(numberOfItems).ToList();

                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }
        public string GetNec([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                if (searchParams == null || searchParams.Count == 0)
                {
                    var query = db.ReportParameters.Select(nec1 => new { NEC_Code = nec1.NEC1_Code, NEC_Desc = nec1.NEC1_Desc })
                                        .Union(db.ReportParameters.Select(nec2 => new { NEC_Code = nec2.NEC2_Code, NEC_Desc = nec2.NEC2_desc }))
                                        .Union(db.ReportParameters.Select(nec3 => new { NEC_Code = nec3.NEC3_Code, NEC_Desc = nec3.NEC3_Desc }))
                                        .Where(nec => !string.IsNullOrEmpty(nec.NEC_Code) && !string.IsNullOrEmpty(nec.NEC_Desc))
                                        .Distinct().OrderBy(x => x.NEC_Code).Take(numberOfItems).ToList();

                    jsonString = JsonConvert.SerializeObject(query, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            PreserveReferencesHandling = PreserveReferencesHandling.Objects
                        });
                }
                else
                {
                    var value = searchParams.ToArray()[0].Value;
                    var query = db.ReportParameters.Select(nec1 => new { NEC_Code = nec1.NEC1_Code, NEC_Desc = nec1.NEC1_Desc })
                                        .Union(db.ReportParameters.Select(nec2 => new { NEC_Code = nec2.NEC2_Code, NEC_Desc = nec2.NEC2_desc }))
                                        .Union(db.ReportParameters.Select(nec3 => new { NEC_Code = nec3.NEC3_Code, NEC_Desc = nec3.NEC3_Desc }))
                                        .Where(nec => (nec.NEC_Code.Contains(value) || nec.NEC_Desc.Contains(value))
                                        && !string.IsNullOrEmpty(nec.NEC_Code) && !string.IsNullOrEmpty(nec.NEC_Desc))
                                        .Distinct().OrderBy(x => x.NEC_Code).Take(numberOfItems).ToList();

                    jsonString = JsonConvert.SerializeObject(query, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
                }
            }
            return jsonString;
        }

        public async Task<string> GetNec1([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Nec1() { NEC1_Code = a.NEC1_Code, NEC1_Desc = a.NEC1_Desc })
                    .Where(x => !string.IsNullOrEmpty(x.NEC1_Code) && !string.IsNullOrEmpty(x.NEC1_Desc))
                    .Distinct().OrderBy(x => x.NEC1_Code).Take(numberOfItems).ToList();


                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }

            return jsonString;
        }

        public async Task<string> GetNec2([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Nec2() { NEC2_Code = a.NEC2_Code, NEC2_Desc = a.NEC2_desc })
                    .Where(x => !string.IsNullOrEmpty(x.NEC2_Code) && !string.IsNullOrEmpty(x.NEC2_Desc))
                    .Distinct().OrderBy(x => x.NEC2_Code).Take(numberOfItems).ToList();


                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }

            return jsonString;
        }

        public async Task<string> GetNec3([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Nec3() { NEC3_Code = a.NEC3_Code, NEC3_Desc = a.NEC3_Desc })
                    .Where(x => !string.IsNullOrEmpty(x.NEC3_Code) && !string.IsNullOrEmpty(x.NEC3_Desc))
                    .Distinct().OrderBy(x => x.NEC3_Code).Take(numberOfItems).ToList();


                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }

            return jsonString;
        }

        public async Task<string> GetNec4([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Nec4() { NEC4_Code = a.NEC4_Code, NEC4_Desc = a.NEC4_Desc })
                    .Where(x => !string.IsNullOrEmpty(x.NEC4_Code) && !string.IsNullOrEmpty(x.NEC4_Desc))
                    .Distinct().OrderBy(x => x.NEC4_Code).Take(numberOfItems).ToList();


                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }

            return jsonString;
        }

        public async Task<string> GetProduct([FromBody] ICollection<Filter> searchParams)
        {
            string jsonString = string.Empty;

            using (var db = new EverestPortalContext())
            {
                IQueryable<ReportParamList> query = null;
                if (searchParams == null || searchParams.Count == 0)
                {
                    query = db.ReportParameters.Select(a => a);
                }
                else
                {
                    string whereClause = dimProductExpanded.GetFilter(searchParams);
                    query = db.ReportParameters.Select(a => a).Where(whereClause);
                }

                var atcs = query.Select(a => new Product() { Id = a.Prod_cd.HasValue ? a.Prod_cd.Value.ToString() : "", ProductName = a.ProductName, Product_Long_Name = a.Product_Long_Name })
                    .Where(x => !string.IsNullOrEmpty(x.ProductName))
                    .Distinct().OrderBy(x => x.Product_Long_Name).Take(numberOfItems).ToList();


                jsonString = JsonConvert.SerializeObject(atcs, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });
            }
            return jsonString;
        }

        //private string GetFilter(ICollection<Filter> searchParams, bool isMoleculeFilter = false)
        //{
        //    StringBuilder str = new StringBuilder();
        //    Dictionary<string, ICollection<Filter>> list = new Dictionary<string, ICollection<Filter>>();
        //    Filter searchFilter = null;

        //    foreach (Filter filter in searchParams)
        //    {

        //        //to query either description or code based on search text
        //        if (filter.Criteria.IndexOf("S_") > -1)
        //        {
        //            int j = 0;
        //            switch (filter.Criteria.ToLower())
        //            {
        //                case "s_atc1_code":
        //                    {
        //                        if (filter.Value.Length > 1)
        //                        {
        //                            if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc1_code"; }
        //                            //else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc1_code"; }
        //                            else { filter.Criteria = "atc1_desc"; }
        //                        }
        //                        else { filter.Criteria = "atc1_desc"; }
        //                        break;
        //                    }
        //                case "s_atc2_code":
        //                    {
        //                        if (filter.Value.Length > 1)
        //                        {
        //                            if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc2_desc"; }
        //                            else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc2_code"; }
        //                            else { filter.Criteria = "atc2_desc"; }
        //                        }
        //                        else { filter.Criteria = "atc2_desc"; }
        //                        break;
        //                    }
        //                case "s_atc3_code":
        //                    {
        //                        if (filter.Value.Length > 1)
        //                        {
        //                            if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc3_desc"; }
        //                            else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc3_code"; }
        //                            else { filter.Criteria = "atc3_desc"; }
        //                        }
        //                        else { filter.Criteria = "atc3_desc"; }
        //                        break;
        //                    }
        //                case "s_atc4_code":
        //                    {
        //                        if (filter.Value.Length > 1)
        //                        {
        //                            if (filter.Value.Substring(1, 1) == "*") { filter.Criteria = "atc4_desc"; }
        //                            else if (int.TryParse(filter.Value.Substring(1, 1), out j)) { filter.Criteria = "atc4_code"; }
        //                            else { filter.Criteria = "atc4_desc"; }
        //                        }
        //                        else { filter.Criteria = "atc4_desc"; }
        //                        break;
        //                    }
        //                case "s_nec1_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec1_code"; } else { filter.Criteria = "nec1_desc"; } break; }
        //                case "s_nec2_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec2_code"; } else { filter.Criteria = "nec2_desc"; } break; }
        //                case "s_nec3_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec3_code"; } else { filter.Criteria = "nec3_desc"; } break; }
        //                case "s_nec4_code": { if (filter.Value.Length > 0 && int.TryParse(filter.Value.Substring(0, 1), out j)) { filter.Criteria = "nec4_code"; } else { filter.Criteria = "nec4_desc"; } break; }

        //            }
        //        }
        //        if (filter.Value.Substring(filter.Value.Length - 1, 1) != "*")
        //        {
        //            if (!list.ContainsKey(filter.Criteria)) { list.Add(filter.Criteria, new List<Filter>()); }
        //            list[filter.Criteria].Add(filter);
        //        }
        //        else { searchFilter = filter; }
        //    }

        //    string previousAttribute = "";
        //    foreach (ICollection<Filter> filterList in list.Values)
        //    {
        //        if (filterList.First() != null)
        //        {
        //            if (filterList.First().Condition.ToLower() == "restrict" || (previousAttribute != "" && previousAttribute.Substring(0, 3) != filterList.First().Criteria.Substring(0, 3)))
        //            {
        //                str.Append(" AND ");
        //            }
        //            else
        //            {
        //                str.Append(" OR ");
        //            }
        //        }
        //        else
        //        {
        //            str.Append(" OR ");
        //        }
        //        previousAttribute = filterList.First().Criteria;
        //        //if (filterList.First() != null && filterList.First().Condition.ToLower() == "restrict") { str.Append("-"); }


        //        str.Append("(");
        //        string filterQuery = string.Join(" OR ",
        //            filterList
        //            .Where(f => !string.IsNullOrWhiteSpace(f.Value))
        //            .Select(f => GetCriteria(f.Criteria, f.Value, f.Condition, isMoleculeFilter))
        //            );
        //        str.Append(filterQuery);
        //        str.Append(")");

        //    }
        //    if (str.Length > 0)
        //    {
        //        if (str[2] == 'R')
        //        {
        //            str.Remove(0, 4);
        //        }
        //        else
        //        {
        //            str.Remove(0, 5);
        //        }

        //        str.Append(" AND ");
        //    }
        //    str.Append(GetCriteria(searchFilter.Criteria, searchFilter.Value, searchFilter.Condition, isMoleculeFilter));
        //    return str.ToString();
        //}

        //private string GetCriteria(string criteria, string value, string condition, bool isMoleculeFilter)
        //{
        //    //build pack search filter
        //    string result = "";
        //    StringBuilder str = new StringBuilder();

        //    string[] attrValues = value.Split(',');
        //    str.Append("(");
        //    foreach (string val in attrValues)
        //    {
        //        if (condition.ToLower() == "restrict")
        //            str.Append("!");

        //        if (isMoleculeFilter)
        //        {
        //            if (criteria.ToLower() == "molecule" || criteria.ToLower() == "description")
        //                str.Append("molecule.");
        //            else
        //                str.Append("product.");
        //        }

        //        switch (criteria.ToLower())
        //        {
        //            case "atc4_code": case "atc4": { str.Append("ATC4_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc3_code": case "atc3": { str.Append("ATC3_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc2_code": case "atc2": { str.Append("ATC2_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc1_code": case "atc1": { str.Append("ATC1_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec4_code": case "nec4": { str.Append("NEC4_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec3_code": case "nec3": { str.Append("NEC3_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec2_code": case "nec2": { str.Append("NEC2_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec1_code": case "nec1": { str.Append("NEC1_Code.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc4_desc": { str.Append("ATC4_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc3_desc": { str.Append("ATC3_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc2_desc": { str.Append("ATC2_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "atc1_desc": { str.Append("ATC1_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec4_desc": { str.Append("NEC4_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec3_desc": { str.Append("NEC3_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec2_desc": { str.Append("NEC2_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "nec1_desc": { str.Append("NEC1_Desc.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "product": case "productname": { str.Append("Product_Long_Name.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "packdescription": { str.Append("Pack_Description.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "manufacturer":
        //            case "mfr":
        //                {
        //                    str.Append("Org_Long_Name.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")");
        //                    str.Append(" OR ");
        //                    if (isMoleculeFilter)
        //                        str.Append("product.");
        //                    str.Append("Org_Abbr.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break;
        //                }
        //            case "org_long_name": { str.Append("Org_Long_Name.Contains(\""); str.Append(val.Replace("*", "").ToUpper() + "\")"); break; }
        //            case "flagging": { if (value.ToLower() != "all") { str.Append("FRM_Flgs5_Desc.Contains(\""); str.Append(val.Replace("*", "") + "\")"); } break; }
        //            case "branding": { if (value.ToLower() != "all") { str.Append("Frm_Flgs3_Desc.Contains(\""); str.Append(val.Replace("*", "") + "\")"); } break; }
        //            case "molecule": case "description": { str.Append("DESCRIPTION.Contains(\""); str.Append(val.ToUpper().Replace("*", "") + "\")"); break; }
        //                //case "orderby":
        //                //    {
        //                //        string[] values = value.Split(',');
        //                //        result = "sort=" + values[0] + values[1] == "asc" ? " asc" : " desc";
        //                //        return result;
        //                //    }
        //        }
        //        str.Append(" OR ");
        //    }
        //    str.Remove(str.Length - 4, 4);
        //    str.Append(")");
        //    return str.ToString();

        //}
    }
}