using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public static class GetDifference
    {
        public static List<DifferenceClass> GetObjectDifference<T>(this T val1, T val2,List<string> CompareProp)
        {
            List<DifferenceClass> variances = new List<DifferenceClass>();
            PropertyInfo[] fi = val1.GetType().GetProperties();
            foreach (PropertyInfo f in fi)
            {
                if (!CompareProp.Contains(f.Name))
                    continue;

                DifferenceClass v = new DifferenceClass();
                v.PropName = f.Name;
                v.valA = f.GetValue(val1);
                v.valB = f.GetValue(val2);
                if (v.valA!=null && !v.valA.Equals(v.valB))
                    variances.Add(v);

            }
            return variances;
        }
    }
}