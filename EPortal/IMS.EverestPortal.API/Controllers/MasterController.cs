using System.Linq;
using System.Web.Http;
using Newtonsoft.Json;
using System.Web.Http.Cors;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using IMS.EverestPortal.API.DAL;
using System.Net.Http;
using System;
using IMS.EverestPortal.API.Models;
using System.Collections.Generic;
using System.Data.Entity.Migrations;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class MasterController : ApiController
    {
        private EverestPortalContext _db = new EverestPortalContext();
        // GET: Master
        [Route("api/CommonLockHistories")]
        [HttpGet]
        public string LockHistories(int UserId, int DefId, string DocType, string LockType, string Status)
        {
            List<LockHistory> lockHistory = new List<LockHistory>();
            DateTime currentDatetime = DateTime.Now;
            if (Status == "Release Lock")
            {
                _db.Database.ExecuteSqlCommand("Delete from LockHistories Where LockType='" + LockType + "' and UserId=" + UserId + " and DefId='" + DefId + "'");

            }
            else if (Status == "Release Lock All")
            {
                _db.Database.ExecuteSqlCommand("Delete from LockHistories Where UserId=" + UserId );
            }
            else if (Status == "Create Lock")
            {
                lockHistory = _db.Database.SqlQuery<LockHistory>("Select *,'' as UserName from LockHistories Where DefId='" + DefId + "' and UserId='" + UserId + "' and DocType='" + DocType + "' and LockType='" + LockType + "' and Status='Active'").ToList();
                //lockHistory.Add(new LockHistory { Id = 1, UserId= UserId, DefId= DefId,DocType= DocType, LockType= LockType,Status= "Active", LockTime= DateTime.Now});
                if (lockHistory.Count() > 0)
                {
                    _db.Database.ExecuteSqlCommand("Update LockHistories set LockTime='" + Convert.ToDateTime(currentDatetime) + "' Where DefId='" + DefId + "' and UserId='" + UserId + "' and DocType='" + DocType + "' and Status='Active'");
                }
                else
                {
                    _db.LockHistories.Add(new LockHistory { Id = 1, UserId = UserId, DefId = DefId, DocType = DocType, LockType = LockType, Status = "Active", LockTime = currentDatetime, ReleaseTime = null });
                    _db.SaveChanges();

                }
            }
            
            var json = JsonConvert.SerializeObject(lockHistory, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });

            return json;
        }



        [Route("api/getCommonLockHistories")]
        [HttpGet]
        public string getDefinitionLockHistories(int UserId, int DefId, string DocType, string LockType, string Status)
        {
            List<LockHistory> lockHistory = new List<LockHistory>();
            if (Status=="Check for Delete") {
                lockHistory = _db.Database.SqlQuery<LockHistory>("Select LH.Id as Id, LH.DocType as DocType,LH.DefId as DefId,LH.ReleaseTime as ReleaseTime, LH.LockType as LockType,LH.UserId as UserId, LH.LockTime as LockTime,[User].FirstName+' ' +[User].LastName as Status from [LockHistories] LH,[User] Where LH.DefId='" + DefId + "' and LH.DocType='" + DocType + "' and LH.Status='Active' and LH.UserId=[User].UserID").ToList();
            }
            else
            {
                //lockHistory = _db.Database.SqlQuery<LockHistory>("Select LH.Id as Id, LH.DocType as DocType,LH.DefId as DefId,LH.ReleaseTime as ReleaseTime, LH.LockType as LockType,LH.UserId as UserId, LH.LockTime as LockTime,[User].FirstName+' ' +[User].LastName as Status from [LockHistories] LH,[User] Where LH.DefId='" + DefId + "' and LH.DocType='" + DocType + "' and LH.LockType='" + LockType + "' and LH.Status='Active' and LH.UserId=[User].UserID").ToList();
                var lockHistoryDetails = _db.Database.SqlQuery<lockHistoriesDetails>(" Select LH.Id as Id, LH.DocType as DocType,LH.DefId as DefId,LH.ReleaseTime as ReleaseTime, LH.LockType as LockType,LH.UserId as LockUserId, LH.LockTime as LockTime,URM.FirstName+' ' +URM.LastName as LockUserName,1 as CurrentUserId , URM.IsExternal LockUserType, URM2.IsExternal CurrentUserType " +
                    " From[LockHistories] LH LEFT JOIN vw_UserRoleMapping URM ON URM.UserId = LH.UserID LEFT JOIN vw_UserRoleMapping URM2 ON URM2.UserId = '"+ UserId + "' Where LH.DefId = '" + DefId + "' and LH.DocType = '" + DocType + "' and LH.LockType = '" + LockType + "' and LH.Status = 'Active'").ToList();

               

                var jsonReturn = JsonConvert.SerializeObject(lockHistoryDetails, Formatting.Indented,
                  new JsonSerializerSettings
                  {
                      ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                  });

                return jsonReturn;
            }


            var json = JsonConvert.SerializeObject(lockHistory, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


            return json;
        }

    }

    class lockHistoriesDetails
    {
        public int Id { get; set; }
        public int DefId { get; set; }
        public string DocType { get; set; }
        public string LockType { get; set; }
        public DateTime? LockTime { get; set; }
        public DateTime? ReleaseTime { get; set; }
        public string Status { get; set; }
        public int UserId { get; set; }
        public int LockUserId { get; set; }
        public string LockUserName { get; set; }
        public int CurrentUserId { get; set; }
        public Boolean LockUserType { get; set; }
        public Boolean CurrentUserType { get; set; }
    }

}