using IMS.EverestPortal.API.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using IMS.EverestPortal.API.Models;
using System.Threading.Tasks;
using IMS.EverestPortal.API.Controllers;
using IMS.EverestPortal.API.DAL.Interfaces;
using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.packSearch;
using System.Data;
using System.Linq.Dynamic;
using System.Dynamic;
using System.Reflection;

namespace IMS.EverestPortal.API.Providers
{
    public class PacksSQLProvider : IPacksProvider
    {
        IDIMProductExpanded dimProductExpanded = null;

        public PacksSQLProvider()
        {
            //refactor to use DI
            dimProductExpanded = new DIMProductExpanded();
        }

        public PacksSQLProvider(IDIMProductExpanded dimProductExpanded)
        {
            this.dimProductExpanded = dimProductExpanded;
        }

        public async Task<PackResultResponse> GetPacksSearchResult(ICollection<Filter> searchFilter)
        {
            PackResultResponse result = new PackResultResponse();
            int noRows = 500, pageStart = 0;

            var rows = searchFilter.FirstOrDefault(p => p.Criteria == "rows");
            if (rows != null)
            {
                int.TryParse(rows.Value, out noRows);
                noRows = noRows == 0 ? 500 : noRows;
                searchFilter.Remove(rows);
            }

            var start = searchFilter.FirstOrDefault(p => p.Criteria == "start");
            if (start != null)
            {
                int.TryParse(start.Value, out pageStart);
                searchFilter.Remove(start);
            }

            int currentPage = (pageStart / noRows) + 1;

            var response = dimProductExpanded.GetPacksSearchResult(searchFilter, currentPage, noRows);
            if (response != null)
            {
                result = new PackResultResponse
                {
                    packResult = response.Data,
                    recCount = response.TotalCount
                };
            }
            return result;
        }

        public async Task<List<PackDescResult>> GetPackDescription(ICollection<Filter> searchFilter)
        {
            //var response = dimProductExpanded.GetPacksSearchResult(searchFilter, 1, 10);
            //if (response != null && response.Data != null)
            //{
            //    var packDescriptionList = response.Data.Select(res => new PackDescResult
            //    {
            //        PackDescription = res.Pack_Long_Name,
            //        Manufacturer = res.Org_Long_Name,
            //        ATC = res.ATC4_Desc,
            //        NEC = res.NEC4_Desc,
            //        Molecule = res.Molecules,
            //        Flagging = res.FRM_Flgs5_Desc,
            //        Branding = res.Frm_Flgs3_Desc
            //    });

            //    var result = packDescriptionList.GroupBy(p => p.PackDescription).Select(g => g.First()).ToList();
            //    return result;
            //}
            //return new List<PackDescResult>();

            var response = dimProductExpanded.GetPackDescriptionForAutocomplete(searchFilter, 1, 10);
            if (response != null && response.Data != null)
            {
                return response.Data;
            }
            return new List<PackDescResult>();
        }

        public async Task<DataTable> GetPacksForExcel(string[] columns, ICollection<Filter> searchParams)
        {
            DataTable dt = new DataTable("pack");

            for (int i = 0; i < columns.Length; i++)
            {
                if (columns[i].ToLower() == "molecules") columns[i] = "Molecules";
            }

            var response = dimProductExpanded.GetPacksSearchResult(searchParams, 1, 200000);
            if (response != null && response.Data != null)
            {
                var result = response.Data.Select(a => Projection(a, columns));
                dt = ConvertListToDataTable(result.ToList(), dt);
            }

            return dt;
        }

        #region Private Methods
        private dynamic Projection(object a, IEnumerable<string> props)
        {
            if (a == null)
            {
                return null;
            }
            IDictionary<string, object> res = new ExpandoObject();
            var type = a.GetType();
            foreach (var pair in props.Select(n => new
            {
                Name = n,
                Property = type.GetProperty(n)
            }))
            {
                res[pair.Name] = pair.Property.GetValue(a, new object[0]);
            }
            return res;
        }

        private DataTable ConvertListToDataTable(List<dynamic> list, DataTable dt)
        {

            int ColumnsCount = dt.Columns.Count;
            foreach (var item in list)
            {
                var obj = (IDictionary<string, object>)item;
                DataRow dr = dt.NewRow();
                foreach (var key in obj.Keys)
                {
                    if (!dt.Columns.Contains(key))
                        dt.Columns.Add(key);
                    dr[key] = obj[key];
                }
                dt.Rows.Add(dr);
            }

            try
            {
                if (dt.Columns.Contains("Pack_Description")) dt.Columns["Pack_Description"].ColumnName = "Pack Description";
                if (dt.Columns.Contains("Org_Long_Name")) dt.Columns["Org_Long_Name"].ColumnName = "Manufacturer";
                if (dt.Columns.Contains("FRM_Flgs5_Desc")) dt.Columns["FRM_Flgs5_Desc"].ColumnName = "Flagging";
                if (dt.Columns.Contains("Frm_Flgs3_Desc")) dt.Columns["Frm_Flgs3_Desc"].ColumnName = "Branding";
                if (dt.Columns.Contains("ProductName")) dt.Columns["ProductName"].ColumnName = "Product Description";
                if (dt.Columns.Contains("ATC4_Desc")) dt.Columns["ATC4_Desc"].ColumnName = "ATC4";
                if (dt.Columns.Contains("NEC4_Desc")) dt.Columns["NEC4_Desc"].ColumnName = "NEC4";
                if (dt.Columns.Contains("APN")) dt.Columns["APN"].ColumnName = "APN/EAN/GTIN (barcode)";
                if (dt.Columns.Contains("MOLECULES")) dt.Columns["MOLECULES"].ColumnName = "Molecules";
            }
            catch (Exception)
            {
                throw;
            }
            return dt;

        }
        #endregion
    }
}