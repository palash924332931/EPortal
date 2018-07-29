using IMS.EverestPortal.API.Controllers;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.EverestPortal.API.Interfaces
{
    public interface IPacksProvider
    {
        Task<PackResultResponse> GetPacksSearchResult(ICollection<Filter> searchParams);

        Task<List<PackDescResult>> GetPackDescription(ICollection<Filter> searchParams);

        Task<DataTable> GetPacksForExcel(string[] columns, ICollection<Filter> searchParams);
    }
}
