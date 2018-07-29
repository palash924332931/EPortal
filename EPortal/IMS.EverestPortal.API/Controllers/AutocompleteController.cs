using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Interfaces;
using Microsoft.Practices.ServiceLocation;
using Newtonsoft.Json;
using SolrNet;
using SolrNet.Attributes;
using SolrNet.Commands.Parameters;
using SolrNet.DSL;
using SolrNet.Exceptions;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Dynamic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Xml.Linq;
using IMS.EverestPortal.API.Providers;
using System.Data.SqlClient;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class AutocompleteController : ApiController
    {
        IAutoCompleteProvider AutoCompleteProvider = null;
        IAutoCompleteProvider AutoCompleteSqlProvider = null;
        private EverestPortalContext _db = new EverestPortalContext();


        public AutocompleteController()
        {
            //refactor to use DI
            this.AutoCompleteProvider = new AutoCompleteSolrProvider();
            this.AutoCompleteSqlProvider = new AutoCompleteSQLProvider();
        }

        public AutocompleteController(IAutoCompleteProvider autoCompleteProvider)
        {
            //refactor to use DI
            this.AutoCompleteProvider = autoCompleteProvider;
        }


        [HttpPost]
        [Route("api/Autocomplete/Atc")]
        public string GetAtc([FromBody] ICollection<Filter> searchParams)
        {
            //return this.AutoCompleteProvider.GetAtc(searchParams);
            return this.AutoCompleteSqlProvider.GetAtc(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/Atc1")]
        public async Task<string> GetAtc1([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetAtc1(searchParams);

            return await this.AutoCompleteSqlProvider.GetAtc1(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/Atc2")]
        public async Task<string> GetAtc2([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetAtc2(searchParams);
            return await this.AutoCompleteSqlProvider.GetAtc2(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/Atc3")]
        public async Task<string> GetAtc3([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetAtc3(searchParams);
            return await this.AutoCompleteSqlProvider.GetAtc3(searchParams);
        }

        [HttpPost]
        [Route("api/Autocomplete/Atc4")]
        public async Task<string> GetAtc4([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetAtc4(searchParams);
            return await this.AutoCompleteSqlProvider.GetAtc4(searchParams);
        }

        [HttpPost]
        [Route("api/Autocomplete/NEC")]
        public string GetNec([FromBody] ICollection<Filter> searchParams)
        {
            //return this.AutoCompleteProvider.GetNec(searchParams);
            return this.AutoCompleteSqlProvider.GetNec(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/NEC1")]
        public async Task<string> GetNec1([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetNec1(searchParams);
            return await this.AutoCompleteSqlProvider.GetNec1(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/NEC2")]
        public async Task<string> GetNec2([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetNec2(searchParams);
            return await this.AutoCompleteSqlProvider.GetNec2(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/NEC3")]
        public async Task<string> GetNec3([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetNec3(searchParams);
            return await this.AutoCompleteSqlProvider.GetNec3(searchParams);
        }

        [HttpPost]
        [Route("api/Autocomplete/NEC4")]
        public async Task<string> GetNec4([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetNec4(searchParams);
            return await this.AutoCompleteSqlProvider.GetNec4(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/Manufacturer")]
        public async Task<string> GetManufacturer([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetManufacturer(searchParams);
            return await this.AutoCompleteSqlProvider.GetManufacturer(searchParams);
        }

        [HttpPost]
        [Route("api/Autocomplete/Product")]
        public async Task<string> GetProduct([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetProduct(searchParams);
            return await this.AutoCompleteSqlProvider.GetProduct(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/Molecule")]
        public async Task<string> GetMolecule([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetMolecule(searchParams);
            return await this.AutoCompleteSqlProvider.GetMolecule(searchParams);
        }

        [HttpPost]
        [Route("api/Autocomplete/PoisonSchedule")]
        public async Task<string> GetPoisonSchedule([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetMolecule(searchParams);
            return await this.AutoCompleteSqlProvider.GetPoisonSchedule(searchParams);
        }

        [HttpPost]
        [Route("api/Autocomplete/Form")]
        public async Task<string> GetForm([FromBody] ICollection<Filter> searchParams)
        {
            //return await this.AutoCompleteProvider.GetMolecule(searchParams);
            return await this.AutoCompleteSqlProvider.GetForm(searchParams);
        }
        [HttpPost]
        [Route("api/Autocomplete/dimension")]
        public string dimension(int ClientId, string SearchValue, [FromBody] ICollection<Filter> searchParams)
        {
            List<Models.Autocomplete.Dimension> filteredResult = new List<Models.Autocomplete.Dimension>();
            List<Models.Autocomplete.Dimension> result = _db.Database.SqlQuery<Models.Autocomplete.Dimension>("dbo.GetIRPDimensionsForMarketbase @pClientId ", new SqlParameter("pClientId ", ClientId)).ToList();
            if (SearchValue != null && SearchValue != "")
            {
                filteredResult = result.Where(item => item.DimensionName.ToLower().Contains(SearchValue.ToLower())).ToList();
            }
            else
            {
                filteredResult = result;

            }
            var json = JsonConvert.SerializeObject(filteredResult, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });
            return json;

        }

        [HttpPost]
        [Route("api/Autocomplete/pxrcode")]
        public string pxrcode(int ClientId, string SearchValue, [FromBody] ICollection<Filter> searchParams)
        {
            List<Models.Autocomplete.PxR> filteredResult = new List<Models.Autocomplete.PxR>();
            List<Models.Autocomplete.PxR> result = _db.Database.SqlQuery<Models.Autocomplete.PxR>("dbo.GetMIPMKTPxrForMarketbase @pClientId ", new SqlParameter("pClientId ", ClientId)).ToList();
            if (SearchValue != null && SearchValue != "")
            {
                filteredResult = result.Where(item => item.MarketName.ToLower().Contains(SearchValue.ToLower())).ToList();
            }
            else
            {
                filteredResult = result;

            }
            var json = JsonConvert.SerializeObject(filteredResult, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });
            return json;

        }
    }

}
