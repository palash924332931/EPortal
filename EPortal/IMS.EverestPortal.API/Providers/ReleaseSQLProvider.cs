using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.DAL.Interfaces;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Subscription;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IMS.EverestPortal.API.Providers
{
    public class ReleaseSQLProvider : IReleaseProvider
    {
        IDIMProductExpanded dimProductExpanded = null;

        public ReleaseSQLProvider()
        {
            //refactor to use DI
            dimProductExpanded = new DIMProductExpanded();
        }

        public ReleaseSQLProvider(IDIMProductExpanded dimProductExpanded)
        {
            this.dimProductExpanded = dimProductExpanded;
        }

        public async Task<FilterResult<Manufacturer>> GetManufacturer(int currentPage, int pageSize, string description)
        {
            ICollection<Filter> searchFilter = new List<Filter>();
            searchFilter.Add(new Filter { Condition = "Add", Criteria = "org_long_name", Value = description + "*" });
            var result = dimProductExpanded.GetManufacturer(searchFilter, currentPage, pageSize);
            return result;
        }

        public async Task<FilterResult<ReleasePack>> GetPackDescription(int currentPage, int pageSize, string description)
        {
            ICollection<Filter> searchFilter = new List<Filter>();
            searchFilter.Add(new Filter { Condition = "Add", Criteria = "PackDescription", Value = description + "*" });
            var result = dimProductExpanded.GetPackDescription(searchFilter, currentPage, pageSize);
            return result;
        }

        public async Task<FilterResult<ReleasePack>> GetPacksByProduct(IEnumerable<ReleasePack> packs, int currentPage, int pageSize)
        {
            ICollection<Filter> searchFilter = new List<Filter>();
            foreach (var item in packs)
            {
                searchFilter.Add(new Filter { Condition = "Add", Criteria = "ProductName", Value = item.ProductGroupName});
            }
            var result = dimProductExpanded.GetPackDescription(searchFilter, currentPage, pageSize);
            return result;
        }

        public async Task<FilterResult<ReleasePack>> GetPacksByFCC(int clientID, int currentPage, int pageSize)
        {
            List<string> fccs = new List<string>();
            List<ClientPackException> clientPacks = new List<ClientPackException>();
            using (EverestPortalContext context = new EverestPortalContext())
            {
                clientPacks = context.ClientPackException.Where(x => x.ClientId == clientID).ToList();
                fccs = clientPacks.Select(x => Convert.ToString(x.PackExceptionId)).ToList();
            }
            ICollection<Filter> searchFilter = new List<Filter>();
            foreach (var item in fccs)
            {
                searchFilter.Add(new Filter { Condition = "Add", Criteria = "FCC", Value = item });
            }

            var result = dimProductExpanded.GetPackDescription(searchFilter, currentPage, pageSize);
            foreach (var pack in result.Data)
            {
                var aClientPack = clientPacks.FirstOrDefault(x => x.PackExceptionId == pack.Id);
                pack.ProductLevel = aClientPack.ProductLevel;
                pack.ExpiryDate = SetExpiryDate(aClientPack.ExpiryDate);
            }
            return result;
        }

        public async Task<FilterResult<Manufacturer>> GetManufacturerByMFRsId(int clientID, int currentPage, int pageSize)
        {
            List<string> mfrs = new List<string>();

            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clientMfrs = context.ClientMFR.Where(x => x.ClientId == clientID).Select(x => x.MFRId).ToList();
                mfrs = clientMfrs.Select(x => Convert.ToString(x)).ToList();
            }

            ICollection<Filter> searchFilter = new List<Filter>();
            foreach (var item in mfrs)
            {
                searchFilter.Add(new Filter { Condition = "Add", Criteria = "OrgCode", Value = item });
            }

            var result = dimProductExpanded.GetManufacturer(searchFilter, currentPage, pageSize);
            return result;
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
    }
}