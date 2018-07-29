using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace IMS.EverestPortal.API.Controllers
{
    public class UnlockController : ApiController
    {
        /// <summary>
        /// This method get the locked deliverables, territories, market definition
        /// </summary>
        /// <param name="clientId">Client ID</param>
        /// <returns>Return list of locked definitions</returns>
        [HttpGet]
        [Route("api/GetLockedDefinitions")]
        public IEnumerable<LockedDefinition> GetLockedDefinitions(int clientId)
        {
            IEnumerable<LockedDefinition> lockedDefinition = null;
            if (clientId > 0)
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    lockedDefinition = 
                        //get locked territory 
                        context.LockHistories
                        .Join(context.Users, l => l.UserId, u => u.UserID, (lockhistories, users) => new { lockhistories, users })
                        .Join(context.Territories, l => l.lockhistories.DefId, t => t.Id, (locks, territories) => new { locks, territories })
                        .Where(l => l.territories.Client_Id == clientId && l.locks.lockhistories.DocType == "Territory Module")
                        .Select(l => new LockedDefinition
                        {
                            LockHistoryID = l.locks.lockhistories.Id,
                            ID = l.territories.DimensionID,
                            Module = "Territory",
                            Name = l.territories.Name + " (" + l.territories.SRA_Client + l.territories.SRA_Suffix + ")",
                            LockedBy = l.locks.users.FirstName + " " + l.locks.users.LastName,
                            LockedTime = l.locks.lockhistories.LockTime
                        })
                        //get locked market definition
                        .Union(context.LockHistories
                        .Join(context.Users, l => l.UserId, u => u.UserID, (lockhistories, users) => new { lockhistories, users })
                        .Join(context.MarketDefinitions, l => l.lockhistories.DefId, t => t.Id, (locks, markets) => new { locks, markets })
                        .Where(l => l.markets.ClientId == clientId && l.locks.lockhistories.DocType == "Market Module")
                        .Select(l => new LockedDefinition
                        {
                            LockHistoryID = l.locks.lockhistories.Id,
                            ID = l.markets.DimensionId,
                            Module = "Market",
                            Name = l.markets.Name,
                            LockedBy = l.locks.users.FirstName + " " + l.locks.users.LastName,
                            LockedTime = l.locks.lockhistories.LockTime
                        }))
                        //get locked delivery
                        .Union(context.LockHistories
                        .Join(context.Users, l => l.UserId, u => u.UserID, (lockhistories, users) => new { lockhistories, users })
                        .Join(context.deliverables, l => l.lockhistories.DefId, t => t.DeliverableId, (locks, deliverables) => new { locks, deliverables })
                        .GroupJoin(context.DeliveryReports, d => d.deliverables.DeliverableId, d => d.DeliverableId, (deliverables, reports) => new { deliverables, reports })
                        .SelectMany(temp => temp.reports.DefaultIfEmpty(), (temp, p) => new { deliverables = temp.deliverables, reports = p })
                        .Where(l => l.deliverables.deliverables.subscription.ClientId == clientId && l.deliverables.locks.lockhistories.DocType == "Delivery Module")

                        .Select(l => new LockedDefinition
                        {
                            LockHistoryID = l.deliverables.locks.lockhistories.Id,
                            ID = l.deliverables.deliverables.DeliveryTypeId==3 ? l.reports.ReportNo : null,
                            Module = "Deliverables",
                            Name = l.deliverables.deliverables.subscription.country.Name + " " + l.deliverables.deliverables.subscription.service.Name
                            + " " + l.deliverables.deliverables.subscription.dataType.Name + " " + l.deliverables.deliverables.subscription.source.Name + " "
                            + l.deliverables.deliverables.deliveryType.Name + " " + l.deliverables.deliverables.frequencyType.Name,
                            LockedBy = l.deliverables.locks.users.FirstName + " " + l.deliverables.locks.users.LastName,
                            LockedTime = l.deliverables.locks.lockhistories.LockTime
                        })).Distinct().ToList();
                }
            }
            return lockedDefinition;
        }

        /// <summary>
        /// Unlock definitions
        /// </summary>
        /// <param name="lockHistoriesID">List of lockhistories id</param>
        /// <returns>On suceess true</returns>
        [HttpPost]
        [Route("api/UnlockDefinitions")]
        public Boolean UnlockDefinitions(ICollection<int> lockHistoriesID)
        {
            if (lockHistoriesID.Count > 0)
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    context.LockHistories.RemoveRange(context.LockHistories.Where(l => lockHistoriesID.Contains(l.Id)));
                    context.SaveChanges();
                    return true;
                }
            }
            return false;
        }
    }
}
