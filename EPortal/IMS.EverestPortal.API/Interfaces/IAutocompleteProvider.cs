using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using IMS.EverestPortal.API.Models;

namespace IMS.EverestPortal.API.Interfaces
{
    public interface IAutoCompleteProvider
    {
        string GetAtc(ICollection<Filter> searchParams);
        Task<string> GetAtc1(ICollection<Filter> searchParams);
        Task<string> GetAtc2(ICollection<Filter> searchParams);
        Task<string> GetAtc3(ICollection<Filter> searchParams);
        Task<string> GetAtc4(ICollection<Filter> searchParams);
        Task<string> GetManufacturer(ICollection<Filter> searchParams, int currentPage = 1, int pageSize = 10);
        Task<string> GetMolecule(ICollection<Filter> searchParams);
        Task<string> GetPoisonSchedule(ICollection<Filter> searchParams);
        Task<string> GetForm(ICollection<Filter> searchParams);
        string GetNec(ICollection<Filter> searchParams);
        Task<string> GetNec1(ICollection<Filter> searchParams);
        Task<string> GetNec2(ICollection<Filter> searchParams);
        Task<string> GetNec3(ICollection<Filter> searchParams);
        Task<string> GetNec4(ICollection<Filter> searchParams);
        Task<string> GetProduct(ICollection<Filter> searchParams);
    }
}