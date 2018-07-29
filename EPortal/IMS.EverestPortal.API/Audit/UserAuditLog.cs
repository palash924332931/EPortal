using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class UserAuditLog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 0;
            User val = (User)(object)cName;

            var result = _db.User_History.Where(i => i.UserID == val.UserID).OrderByDescending(x => x.Version).FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;
            User_History obj = new User_History();

            val.CopyProperties(obj);
            obj.UserID = val.UserID;
            obj.Version = Version;
            obj.ModifiedDate = DateTime.Now;
            obj.ModifiedUserId = UserId;

            _db.User_History.Add(obj);
            _db.SaveChanges();

            UserRole_History roleHistory = new UserRole_History();
            var role = _db.userRole.Where(i => i.UserID == val.UserID).FirstOrDefault();
            role.CopyProperties(roleHistory);
            roleHistory.UserVersion = Version;

            _db.UserRole_History.Add(roleHistory);
            _db.SaveChanges();
            

            var client = _db.userClient.Where(i => i.UserID == val.UserID).ToList();

            foreach(UserClient clnt in client)
            {
                UserClient_History clientHistory = new UserClient_History();
                clnt.CopyProperties(clientHistory);
                clientHistory.UserVersion = Version;
                _db.UserClient_History.Add(clientHistory);
                _db.SaveChanges(); 
            }
        }
    }
}