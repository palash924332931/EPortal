using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.DAL.Interfaces;
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
using System.Configuration;
using IMS.EverestPortal.API.Models.Subscription;

namespace IMS.EverestPortal.API.Providers
{
    public class ReleaseSolrProvider : IReleaseProvider
    {
        private readonly string solrManufacturerUrl = ConfigurationManager.AppSettings["solrManufacturerUrl"] + "/select";
        private readonly string packsSolrURL = ConfigurationManager.AppSettings["solrPackSearchURL"];
        IDIMProductExpanded dimProductExpanded = null;

        public ReleaseSolrProvider()
        {
            //refactor to use DI
            dimProductExpanded = new DIMProductExpanded();
        }

        public ReleaseSolrProvider(IDIMProductExpanded dimProductExpanded)
        {
            this.dimProductExpanded = dimProductExpanded;
        }

        public async Task<FilterResult<Manufacturer>> GetManufacturer(int currentPage, int pageSize, string description)
        {
            var query = string.Empty;
            var start = (currentPage - 1) * pageSize;
            description = description.Replace(" ", @"\ ");
            query = string.Format("?q=Org_Long_Name:(*{0}*)&sort=Org_Long_Name asc&rows={1}&start={2}",
                description, pageSize, start);

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(solrManufacturerUrl);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync(query);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            List<Manufacturer> MFRs = new List<Manufacturer>();

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                MFRs.Add(ParseManufacturer(node));
            }

            int rCount = 0;
            XmlNodeList nodeList = doc.SelectNodes("/response/result");
            foreach (XmlNode node in nodeList)
            {
                rCount = Convert.ToInt32(node.Attributes["numFound"].Value);
            }

            return new FilterResult<Manufacturer>
            {
                Data = MFRs,
                TotalCount = rCount
            };
        }

        public async Task<FilterResult<ReleasePack>> GetPackDescription(int currentPage, int pageSize, string description)
        {
            var query = string.Empty;
            var start = (currentPage - 1) * pageSize;
            description = description.Replace(" ", @"\ ");
            query = string.Format("?q=Pack_Description:(*{0}*)&sort=Pack_Description asc&rows={1}&start={2}",
                description, pageSize, start);

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(packsSolrURL);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync(query);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            List<ReleasePack> packs = new List<ReleasePack>();

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                packs.Add(ParsePack(node));
            }

            int rCount = 0;
            XmlNodeList nodeList = doc.SelectNodes("/response/result");
            foreach (XmlNode node in nodeList)
            {
                rCount = Convert.ToInt32(node.Attributes["numFound"].Value);
            }

            return new FilterResult<ReleasePack>
            {
                Data = packs,
                TotalCount = rCount
            };
        }

        public async Task<FilterResult<ReleasePack>> GetPacksByProduct(IEnumerable<ReleasePack> packs, int currentPage, int pageSize)
        {
            var query = string.Empty;

            var products = packs.Select(x => x.ProductGroupName.ToUpper().Trim().Replace(" ", @"\ "));
            var productStringValue = String.Join(" ", products);

            query = string.Format("?q=ProductName:({0})&rows=" + pageSize,
                productStringValue);

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(packsSolrURL);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync(query);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            List<ReleasePack> packsByProduct = new List<ReleasePack>();

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                packsByProduct.Add(ParsePack(node));
            }

            return new FilterResult<ReleasePack>
            {
                Data = packsByProduct
            };
        }

        public async Task<FilterResult<ReleasePack>> GetPacksByFCC(int clientID, int currentPage, int pageSize)
        {
            string delimiter = " ";
            var packids = string.Empty;

            List<ReleasePack> packs = new List<ReleasePack>();
            List<ClientPackException> clientPacks = new List<ClientPackException>();

            using (EverestPortalContext context = new EverestPortalContext())
            {
                clientPacks = context.ClientPackException.Where(x => x.ClientId == clientID).ToList();
                var temp = clientPacks.Select(x => Convert.ToString(x.PackExceptionId)).ToList();
                if (temp.Count() > 0)
                    packids = temp.Aggregate((i, j) => i + delimiter + j);
            }

            var query = string.Format("?q=FCC:({0})&rows=" + pageSize, packids);
            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(packsSolrURL);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync(query);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
                packs.Add(ParsePack(node));

            int rCount = 0;
            XmlNodeList nodeList = doc.SelectNodes("/response/result");

            foreach (XmlNode node in nodeList)
                rCount = Convert.ToInt32(node.Attributes["numFound"].Value);

            foreach (var pack in packs)
            {
                var aClientPack = clientPacks.FirstOrDefault(x => x.PackExceptionId == pack.Id);
                pack.ProductLevel = aClientPack.ProductLevel;
                pack.ExpiryDate = SetExpiryDate(aClientPack.ExpiryDate);
            }
            
            //taking the distinct values
            var distinct = packs.GroupBy(i => i.Id).Select(i => i.First()).ToList();

            return new FilterResult<ReleasePack>
            {
                Data = distinct.OrderBy(x => x.ProductName).ToList(),
                TotalCount = rCount
            };
        }

        public async Task<FilterResult<Manufacturer>> GetManufacturerByMFRsId(int clientID, int currentPage, int pageSize)
        {
            string delimiter = " ";
            var mfrs = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clientMfrs = context.ClientMFR.Where(x => x.ClientId == clientID).Select(x => x.MFRId).ToList();
                var temp = clientMfrs.Select(x => Convert.ToString(x));
                if (temp.Count() > 0) mfrs = temp.Aggregate((i, j) => i + delimiter + j);
            };

            var query = string.Format("?q=Org_Code:({0})&rows=" + pageSize, mfrs);

            string resultContent = null;
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(solrManufacturerUrl);
                client.DefaultRequestHeaders
                    .Accept
                    .Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var result = await client.GetAsync(query);
                resultContent = result.Content.ReadAsStringAsync().Result;
            }

            List<Manufacturer> MFRs = new List<Manufacturer>();

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(resultContent);
            foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
            {
                MFRs.Add(ParseManufacturer(node));
            }

            int rCount = 0;
            XmlNodeList nodeList = doc.SelectNodes("/response/result");
            foreach (XmlNode node in nodeList)
            {
                rCount = Convert.ToInt32(node.Attributes["numFound"].Value);
            }

            MFRs = MFRs.Distinct().ToList();

            return new FilterResult<Manufacturer>
            {
                Data = MFRs.OrderBy(x => x.Org_Long_Name).ToList(),
                TotalCount = rCount
            };
        }

        #region Private Methods
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

        private ReleasePack ParsePack(XmlNode packXmlNode)
        {

            ReleasePack p = new ReleasePack();
            foreach (XmlNode node in packXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "fcc": { p.Id = int.Parse(node.InnerText); break; }
                    case "pack_description": { p.ProductName = node.InnerText; break; }
                    case "productname": { p.ProductGroupName = node.InnerText; break; }
                }

            }
            return p;
        }

        private static string SetExpiryDate(DateTime? date)
        {
            var dateString = string.Empty;
            if (String.IsNullOrEmpty(Convert.ToString(date)))
            {
                dateString = String.Format("{0} {1}", "Dec", DateTime.Now.Year);
            }
            else
            {
                dateString = Convert.ToDateTime(date).ToString("MMM yyyy");

            }
            return dateString;
        }
        #endregion
    }
}