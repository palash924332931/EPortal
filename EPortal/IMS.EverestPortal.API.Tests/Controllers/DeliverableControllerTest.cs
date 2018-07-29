using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.Deliverable;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;

namespace IMS.EverestPortal.API.Tests.Controllers
{
    [TestClass]
    public class DeliverableControllerTest
    {
        API.Controllers.DeliverablesController deliverableController = new API.Controllers.DeliverablesController();
       [TestMethod]
       public void GetDeliverablesByclientTest()
       {
            try
            {
                var clientId = 41;
                    var resultString = deliverableController.GetDeliverablesByClient(clientId);
                    List<DeliverablesDTO> DeliverablesDTOList = new List<DeliverablesDTO>();
                    DeliverablesDTOList = JsonConvert.DeserializeObject<List<DeliverablesDTO>>(resultString);
                Assert.IsTrue(DeliverablesDTOList.Count > 0);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }


        [TestMethod]
        public void GetDeliverableByDeiverableIdTest()
        {
            try
            {
                var clientId = 41;
                var deliverableId = 361;
                var resultString = deliverableController.GetDeliverableByID(deliverableId,clientId);
                DeliverablesDTO DeliveryObj = new DeliverablesDTO();
                DeliveryObj = JsonConvert.DeserializeObject<DeliverablesDTO>(resultString);
                Assert.IsNotNull(DeliveryObj);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }


        [TestMethod]
        public void UpdateDeliverableTest()
        {
            try
            {
                var updateDeliverable = new DeliverablesDTO();
                updateDeliverable.ClientId = 41;
                updateDeliverable.DeliverableId = 361;
                updateDeliverable.SubscriptionId = 4960;
                updateDeliverable.FrequencyId = 2;
                updateDeliverable.FrequencyTypeId = 2;
                updateDeliverable.PeriodId = 7;
                updateDeliverable.ReportWriterId = 38;
                updateDeliverable.RestrictionId = 1;
                updateDeliverable.probe = false;
                updateDeliverable.Census = false;
                updateDeliverable.PackException = false;
                updateDeliverable.OneKey = false;
                updateDeliverable.ReportNo  = 2;
                updateDeliverable.StartDate = DateTime.Now;
                updateDeliverable.LastModified = DateTime.Now;
                var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                var endDate = new DateTime(DateTime.Now.Year, 12, 1);
                updateDeliverable.StartDate = startDate;
                updateDeliverable.EndDate =  endDate;

                updateDeliverable.marketDefs = deliverableController.GetClientMarketDefDTO(updateDeliverable.DeliverableId);
                updateDeliverable.territories = deliverableController.GetDeliverablesTerritories(updateDeliverable.DeliverableId);
                updateDeliverable.clients = deliverableController.GetDeliverablesClientList(updateDeliverable.DeliverableId);
                updateDeliverable.clients = deliverableController.GetDeliverablesClientList(updateDeliverable.DeliverableId);
                //Subchannels
                updateDeliverable.SubChannelsDTO = deliverableController.GetSubchannels(updateDeliverable.DeliverableId);

                updateDeliverable.ReportNo = deliverableController.getIRPReportNo(updateDeliverable.DeliverableId);

                deliverableController.UpdateDeliverables(updateDeliverable);
                EverestPortalContext dbContext = new EverestPortalContext();

                Deliverables ObjDelivery = new Deliverables();
                using (var transaction = dbContext.Database.BeginTransaction())
                {
                    ObjDelivery = dbContext.deliverables.Where(p => p.DeliverableId == updateDeliverable.DeliverableId).SingleOrDefault();
                }

                Assert.IsNotNull(ObjDelivery);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public void GetFrequencyTest()
        {
            try
            {               
               var clientId = 41;
               var deliverableId = 361;
               var resultString = deliverableController.getFrequncy(deliverableId,clientId);
               List<Frequency> frequencies = JsonConvert.DeserializeObject<List<Frequency>>(resultString);
               Assert.IsTrue(frequencies.Count > 0);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }


        [TestMethod]
        public void GetPeriodTest()
        {
            try
            {
                var clientId = 6;
                var deliverableId = 361;
                var resultString = deliverableController.getPeriod(deliverableId, clientId);
                List<Period> Periods = JsonConvert.DeserializeObject<List<Period>>(resultString);
                Assert.IsTrue(Periods.Count > 0);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }


        [TestMethod]
        public void GetRestrictionLevelTest()
        {
            try
            {
                var clientId = 41;
                var deliverableId = 361;
                var resultString = deliverableController.getRestrictions(deliverableId, "", clientId);
                List<RestrictionDTO> restrictions = JsonConvert.DeserializeObject<List<RestrictionDTO>>(resultString);
                Assert.IsTrue(restrictions.Count > 0);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod]
        public void GetReportWriterTest()
        {
            try
            {
                var clientId = 41;
                var deliverableId = 361;
                var resultString = deliverableController.getReportWriters(deliverableId,  clientId);
                List<ReportWriter> reportWriters = JsonConvert.DeserializeObject<List<ReportWriter>>(resultString);
                Assert.IsTrue(reportWriters.Count > 0);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

    }
}
