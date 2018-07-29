using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.EverestPortal.API.AuditReport
{
    interface IAuditReport
    {
        dynamic GenerateReport(int Id, int startversion, int endVersion, string report);
    }
}
