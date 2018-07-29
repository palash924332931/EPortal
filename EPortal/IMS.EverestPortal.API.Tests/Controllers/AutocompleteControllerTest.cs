using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IMS.EverestPortal.API.Controllers;
using IMS.EverestPortal.API.Models;
using Newtonsoft.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SolrNet;
using SolrNet.Impl;
using System.Configuration;
using System.Web.Http;

namespace IMS.EverestPortal.API.Tests.Controllers
{
    [TestClass]
    public class AutocompleteControllerTest
    {
        private static readonly string solrPackUrl = ConfigurationManager.AppSettings["solrPackUrl"];
        private static readonly string solrAtc1Url = ConfigurationManager.AppSettings["solrAtc1Url"];
        private static readonly string solrAtc2Url = ConfigurationManager.AppSettings["solrAtc2Url"];
        private static readonly string solrAtc4Url = ConfigurationManager.AppSettings["solrAtc4Url"];
        private static readonly string solrAtc3Url = ConfigurationManager.AppSettings["solrAtc3Url"];
        private static readonly string solrAtcUrl = ConfigurationManager.AppSettings["solrAtcUrl"];
        private static readonly string solrNecUrl = ConfigurationManager.AppSettings["solrNecUrl"];
        private static readonly string solrNec1Url = ConfigurationManager.AppSettings["solrNec1Url"];
        private static readonly string solrNec2Url = ConfigurationManager.AppSettings["solrNec2Url"];
        private static readonly string solrNec3Url = ConfigurationManager.AppSettings["solrNec3Url"];
        private static readonly string solrNec4Url = ConfigurationManager.AppSettings["solrNec4Url"];
        private static readonly string solrManufacturerUrl = ConfigurationManager.AppSettings["solrManufacturerUrl"];
        private static readonly string solrMoleculeUrl = ConfigurationManager.AppSettings["solrMoleculeUrl"];
        private static readonly string solrProductUrl = ConfigurationManager.AppSettings["solrProductUrl"];


        [AssemblyInitialize()]
        public static void AssemblyInit(TestContext context)
        {
            GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;

            SolrNet.Startup.Init<Pack>(new SolrConnection(solrPackUrl));
            SolrNet.Startup.Init<Atc>(new SolrConnection(solrAtcUrl));
            SolrNet.Startup.Init<Atc1>(new SolrConnection(solrAtc1Url));
            SolrNet.Startup.Init<Atc2>(new SolrConnection(solrAtc2Url));
            SolrNet.Startup.Init<Atc3>(new SolrConnection(solrAtc3Url));
            SolrNet.Startup.Init<Atc4>(new SolrConnection(solrAtc4Url));
            SolrNet.Startup.Init<Nec>(new SolrConnection(solrNecUrl));
            SolrNet.Startup.Init<Nec1>(new SolrConnection(solrNec1Url));
            SolrNet.Startup.Init<Nec2>(new SolrConnection(solrNec2Url));
            SolrNet.Startup.Init<Nec3>(new SolrConnection(solrNec3Url));
            SolrNet.Startup.Init<Nec4>(new SolrConnection(solrNec4Url));
            SolrNet.Startup.Init<Manufacturer>(new SolrConnection(solrManufacturerUrl));
            SolrNet.Startup.Init<Molecule>(new SolrConnection(solrMoleculeUrl));
            SolrNet.Startup.Init<Product>(new SolrConnection(solrProductUrl));
        }

        [TestMethod]
        public void GetAtc()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                string atcString = autocom.GetAtc(null);
                Atc[] atcs = JsonConvert.DeserializeObject<Atc[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 6000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task GetAtc1()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                string atcString = await autocom.GetAtc1(null);
                Atc1[] atcs = JsonConvert.DeserializeObject<Atc1[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task GetAtc1WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "S_ATC1_Code", Value = "a*" });
                string atcString = await autocom.GetAtc1(filters);
                Atc1[] atcs = JsonConvert.DeserializeObject<Atc1[]>(atcString);

                watch.Stop();
                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task FilterByDescAtc1()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_atc1_code", Value = "a*" });
                string atcString = await autocom.GetAtc1(filters);
                Atc1[] atcs = JsonConvert.DeserializeObject<Atc1[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task GetAtc2()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                string atcString = await autocom.GetAtc2(null);
                Atc2[] atcs = JsonConvert.DeserializeObject<Atc2[]>(atcString);

                watch.Stop();
                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task GetAtc2WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "ATC2_Code", Value = "A01*" });
                string atcString = await autocom.GetAtc2(filters);
                Atc2[] atcs = JsonConvert.DeserializeObject<Atc2[]>(atcString);

                watch.Stop();
                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescAtc2()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_atc2_code", Value = "a*" });
                string atcString = await autocom.GetAtc2(filters);
                Atc2[] atcs = JsonConvert.DeserializeObject<Atc2[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task GetAtc3()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                string atcString = await autocom.GetAtc3(null);
                Atc3[] atcs = JsonConvert.DeserializeObject<Atc3[]>(atcString);

                watch.Stop();
                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task GetAtc3WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "ATC3_Code", Value = "A02A*" });
                string atcString = await autocom.GetAtc3(filters);
                Atc3[] atcs = JsonConvert.DeserializeObject<Atc3[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod]
        public async Task FilterByDescAtc3()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_atc3_code", Value = "a*" });
                string atcString = await autocom.GetAtc3(filters);
                Atc3[] atcs = JsonConvert.DeserializeObject<Atc3[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetAtc4()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                string atcString = await autocom.GetAtc4(null);
                Atc4[] atcs = JsonConvert.DeserializeObject<Atc4[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetAtc4WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "ATC4_Code", Value = "A01A0*" });
                string atcString = await autocom.GetAtc4(filters);
                Atc4[] atcs = JsonConvert.DeserializeObject<Atc4[]>(atcString);

                watch.Stop();
                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescAtc4()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();
                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_atc4_code", Value = "a*" });
                string atcString = await autocom.GetAtc4(filters);
                Atc4[] atcs = JsonConvert.DeserializeObject<Atc4[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(atcs);
                Assert.IsTrue(atcs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public void GetNec()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string atcString = autocom.GetNec(null);
                Nec[] necs = JsonConvert.DeserializeObject<Nec[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec1()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string atcString = await autocom.GetNec1(null);
                Nec1[] necs = JsonConvert.DeserializeObject<Nec1[]>(atcString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec1WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "NEC1_Code", Value = "0*" });
                string necString = await autocom.GetNec1(filters);
                Nec1[] necs = JsonConvert.DeserializeObject<Nec1[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescNec1()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_nec1_code", Value = "0*" });
                string necString = await autocom.GetNec1(filters);
                Nec1[] necs = JsonConvert.DeserializeObject<Nec1[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec2()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string necString = await autocom.GetNec2(null);
                Nec2[] necs = JsonConvert.DeserializeObject<Nec2[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec2WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "NEC2_Code", Value = "0*" });
                string necString = await autocom.GetNec2(filters);
                Nec2[] necs = JsonConvert.DeserializeObject<Nec2[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescNec2()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_nec2_code", Value = "0*" });
                string necString = await autocom.GetNec2(filters);
                Nec2[] necs = JsonConvert.DeserializeObject<Nec2[]>(necString);

                watch.Stop();


                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec3()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string necString = await autocom.GetNec3(null);
                Nec3[] necs = JsonConvert.DeserializeObject<Nec3[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec3WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "NEC3_Code", Value = "0*" });
                string necString = await autocom.GetNec3(filters);
                Nec3[] necs = JsonConvert.DeserializeObject<Nec3[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescNec3()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_nec3_code", Value = "0*" });
                string necString = await autocom.GetNec3(filters);
                Nec3[] necs = JsonConvert.DeserializeObject<Nec3[]>(necString);

                watch.Stop();


                Assert.IsNotNull(necs);
                Assert.IsTrue(necs.Count() > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec4()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string necString = await autocom.GetNec4(null);
                Nec4[] necs = JsonConvert.DeserializeObject<Nec4[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);

                Assert.IsTrue(necs.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetNec4WithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "NEC4_Code", Value = "0*" });
                string necString = await autocom.GetNec4(filters);
                Nec4[] necs = JsonConvert.DeserializeObject<Nec4[]>(necString);

                watch.Stop();

                Assert.IsNotNull(necs);

                Assert.IsTrue(necs.Count() > 0);

                //Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescNec4()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "S_nec4_code", Value = "0*" });
                string necString = await autocom.GetNec4(filters);
                Nec4[] necs = JsonConvert.DeserializeObject<Nec4[]>(necString);

                watch.Stop();


                Assert.IsNotNull(necs);

                Assert.IsTrue(necs.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetManufacturer()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string manufacturerString = await autocom.GetManufacturer(null);
                Manufacturer[] manufacturer = JsonConvert.DeserializeObject<Manufacturer[]>(manufacturerString);

                watch.Stop();

                Assert.IsNotNull(manufacturer);

                Assert.IsTrue(manufacturer.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetManufacturerWithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "Manufacturer", Value = "3*" });
                string manufacturerString = await autocom.GetManufacturer(filters);
                Manufacturer[] manufacturers = JsonConvert.DeserializeObject<Manufacturer[]>(manufacturerString);

                watch.Stop();

                Assert.IsNotNull(manufacturers);

                Assert.IsTrue(manufacturers.Count() > 0);

                //Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescManufacturer()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "Manufacturer", Value = "3*" });
                string necString = await autocom.GetNec4(filters);
                Nec4[] necs = JsonConvert.DeserializeObject<Nec4[]>(necString);

                watch.Stop();


                Assert.IsNotNull(necs);

                Assert.IsTrue(necs.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetMolecule()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string moleculeString = await autocom.GetMolecule(null);
                Molecule[] molecules = JsonConvert.DeserializeObject<Molecule[]>(moleculeString);

                watch.Stop();

                Assert.IsNotNull(molecules);

                Assert.IsTrue(molecules.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetMoleculeWithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "Description", Value = "*" });
                string moleculeString = await autocom.GetMolecule(filters);
                Molecule[] molecules = JsonConvert.DeserializeObject<Molecule[]>(moleculeString);

                watch.Stop();

                Assert.IsNotNull(molecules);

                Assert.IsTrue(molecules.Count() > 0);

                //Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescMolecule()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "Description", Value = "*" });
                string moleculeString = await autocom.GetMolecule(filters);
                Molecule[] molecules = JsonConvert.DeserializeObject<Molecule[]>(moleculeString);

                watch.Stop();


                Assert.IsNotNull(molecules);

                Assert.IsTrue(molecules.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetProduct()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                string productString = await autocom.GetProduct(null);
                Product[] products = JsonConvert.DeserializeObject<Product[]>(productString);

                watch.Stop();

                Assert.IsNotNull(products);

                Assert.IsTrue(products.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task GetProductWithFilter()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>(); filters.Add(new Filter() { Condition = "add", Criteria = "Product", Value = "*" });
                string productString = await autocom.GetProduct(filters);
                Product[] products = JsonConvert.DeserializeObject<Product[]>(productString);

                watch.Stop();

                Assert.IsNotNull(products);

                Assert.IsTrue(products.Count() > 0);

                //Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public async Task FilterByDescProduct()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                API.Controllers.AutocompleteController autocom = new API.Controllers.AutocompleteController();

                List<Filter> filters = new List<Filter>();
                filters.Add(new Filter() { Condition = "add", Criteria = "Product", Value = "*" });
                string productString = await autocom.GetProduct(filters);
                Product[] products = JsonConvert.DeserializeObject<Product[]>(productString);

                watch.Stop();


                Assert.IsNotNull(products);
                 
                Assert.IsTrue(products.Count() > 0);

                ////Assert.IsTrue(atcs.ElementAt(0).ATC1_Code == "A");

                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

    }
}
