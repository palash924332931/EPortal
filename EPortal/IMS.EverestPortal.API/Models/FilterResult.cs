using IMS.EverestPortal.API.Common.Extension;
using System.Collections.Generic;

namespace IMS.EverestPortal.API.Models
{
    public class FilterResult<T>
    {
        public List<T> Data { get; set; }
        public int TotalCount { get; set; }
        public int PageCount { get; set; }
        public int CurrentPage { get; set; }
        public int PageSize { get; set; }
    }
}