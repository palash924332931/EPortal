using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.EverestPortal.API.Audit
{
    public interface IAuditLog
    {
        void SaveVersion<T>(T cName, int UserId);

    }
}
