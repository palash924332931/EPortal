using IMS.EverestPortal.API.Controllers;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.packSearch;
using System.Collections.Generic;
using System.Web.Http;

namespace IMS.EverestPortal.API.DAL.Interfaces
{
    public interface IDIMProductExpanded
    {
        FilterResult<Manufacturer> GetManufacturer([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize);

        FilterResult<ReleasePack> GetPackDescription([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize);

        FilterResult<PackResult> GetPacksSearchResult([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize);

        FilterResult<PackDescResult> GetPackDescriptionForAutocomplete([FromBody] ICollection<Filter> searchParams, int currentPage, int pageSize);

        string GetFilter(ICollection<Filter> searchParams, bool isMoleculeFilter = false);
    }
}
