using IMS.EverestPortal.API.Controllers;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.packSearch;
using IMS.EverestPortal.API.Providers;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.EverestPortal.API.Tests.Controllers
{
    [TestClass]
    public class PacksControllerTest
    {
        //private IPacksProvider packsProvider = null;
        //public PacksController()
        //{
        //    //refactor to use DI
        //    //packsProvider = new PacksSolrProvider();
        //    packsProvider = new PacksSQLProvider();
        //}

        //public PacksController(IPacksProvider packsProvider)
        //{
        //    this.packsProvider = packsProvider;
        //}

        [TestMethod]
        public async Task GetPacksSearchResult()
        {
            API.Controllers.PacksController packsController = new API.Controllers.PacksController();

            ICollection<Models.Filter> searchParams = new List<Models.Filter>()
            {
                new Models.Filter { Criteria = "PackDescription", Value = "" },
                new Models.Filter { Criteria = "Manufacturer", Value = "" },
                new Models.Filter { Criteria = "ATC", Value = "" },
                new Models.Filter { Criteria = "NEC", Value = "" },
                new Models.Filter { Criteria = "Molecule", Value = "" },
                new Models.Filter { Criteria = "Flagging", Value = "" },
                new Models.Filter { Criteria = "Branding", Value = "" },
                new Models.Filter { Criteria = "PFC", Value = "" },
                new Models.Filter { Criteria = "APN", Value = "" },
                new Models.Filter { Criteria = "ProductName", Value = "" },
                new Models.Filter { Criteria = "Orderby", Value = "PackDescription,1" },
                new Models.Filter { Criteria = "start", Value = "0" },
                new Models.Filter { Criteria = "rows", Value = "500" }
            };

            var result = await packsController.GetPacksSearchResult(searchParams);

            Assert.IsNotNull(result);
            Assert.IsTrue(result.Count() > 0);
        }

        [TestMethod]
        public async Task GetPacksSearchResultWithFilter()
        {
            API.Controllers.PacksController packsController = new API.Controllers.PacksController();

            ICollection<Models.Filter> searchParams = new List<Models.Filter>()
            {
                new Models.Filter { Criteria = "PackDescription", Value = "10 DAY DETOX KIT" },
                new Models.Filter { Criteria = "Manufacturer", Value = "" },
                new Models.Filter { Criteria = "ATC", Value = "" },
                new Models.Filter { Criteria = "NEC", Value = "" },
                new Models.Filter { Criteria = "Molecule", Value = "" },
                new Models.Filter { Criteria = "Flagging", Value = "" },
                new Models.Filter { Criteria = "Branding", Value = "" },
                new Models.Filter { Criteria = "PFC", Value = "" },
                new Models.Filter { Criteria = "APN", Value = "" },
                new Models.Filter { Criteria = "ProductName", Value = "" },
                new Models.Filter { Criteria = "Orderby", Value = "PackDescription,1" },
                new Models.Filter { Criteria = "start", Value = "0" },
                new Models.Filter { Criteria = "rows", Value = "500" }
            };

            var result = await packsController.GetPacksSearchResult(searchParams);

            Assert.IsNotNull(result);
            Assert.IsTrue(result.Count() > 0);
        }

    }
}
