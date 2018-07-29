using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Territory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class TerritoryAuditLog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 1;
            Territory val = (Territory)(object)cName;

            var result = _db.Territories_History.Where(i => i.TerritoryId == val.Id).OrderByDescending(x => x.Version).FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;

            Territories_History trrHistory = new Territories_History();

            val.CopyProperties(trrHistory);
            trrHistory.Version = Version;
            trrHistory.TerritoryId = val.Id;
            trrHistory.ModifiedDate = DateTime.Now;
            trrHistory.UserId = UserId;

            Levels_History lvlHistory = null;
            foreach(Level lvl in val.Levels)
            {
                lvlHistory = new Levels_History();
                lvl.CopyProperties(lvlHistory);
                lvlHistory.TerritoryId = lvl.TerritoryId;
                lvlHistory.TerritoryVersion = Version;

                if (trrHistory.Levelss == null)
                    trrHistory.Levelss = new List<Levels_History>();

                trrHistory.Levelss.Add(lvlHistory);

            }

            OutletBrickAllocations_History obaHistory = null;
            foreach(OutletBrickAllocation obAlloc in val.OutletBrickAllocation)
            {
                obaHistory = new OutletBrickAllocations_History();
                obAlloc.CopyProperties(obaHistory);
                obaHistory.TerritoryId = obAlloc.TerritoryId;
                obaHistory.TerritoryVersion = Version;

                if (trrHistory.OutletBrickAllocations == null)
                    trrHistory.OutletBrickAllocations = new List<OutletBrickAllocations_History>();

                trrHistory.OutletBrickAllocations.Add(obaHistory);
            }

            var grp = _db.Groups.Where(i => i.TerritoryId == val.Id).ToList();
            Groups_History gHistory = null;
            foreach(Group g in grp)
            {
                gHistory = new Groups_History();
                g.CopyProperties(gHistory);
                gHistory.TerritoryId = g.TerritoryId;
                gHistory.TerritoryVersion = Version;
                gHistory.GroupId = g.Id;

                if (trrHistory.Groups == null)
                    trrHistory.Groups = new List<Groups_History>();
                trrHistory.Groups.Add(gHistory);
            }
            if (grp != null && grp.Count>0)
                trrHistory.RootGroup_id = grp.Where(i => i.Parent == null).FirstOrDefault().Id;

            _db.Territories_History.Add(trrHistory);
            _db.SaveChanges();
        }
    }
}