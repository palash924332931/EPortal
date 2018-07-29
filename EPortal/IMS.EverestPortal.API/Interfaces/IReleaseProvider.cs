using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace IMS.EverestPortal.API.Interfaces
{
    public interface IReleaseProvider
    {
        Task<FilterResult<Manufacturer>> GetManufacturer(int currentPage, int pageSize, string description);

        Task<FilterResult<ReleasePack>> GetPackDescription(int currentPage, int pageSize, string description);

        Task<FilterResult<ReleasePack>> GetPacksByProduct(IEnumerable<ReleasePack> packs, int currentPage, int pageSize);

        Task<FilterResult<ReleasePack>> GetPacksByFCC(int clientID, int currentPage, int pageSize);

        Task<FilterResult<Manufacturer>> GetManufacturerByMFRsId(int clientID, int currentPage, int pageSize);
    }
}
