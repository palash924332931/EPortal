using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Subscription;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace IMS.EverestPortal.API.Controllers
{
    [Authorize]
    public class masterDataController : ApiController
    {
        //Gets the country collection for the subscriptions
        [Route("api/masterData/GetCountries")]
        [HttpGet]
        public HttpResponseMessage GetCountries()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var countries = context.Countries.ToList();
                var response = new
                {
                    data = countries
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetServices")]
        [HttpGet]
        public HttpResponseMessage GetServices()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var Services = context.Services.ToList();
                var response = new
                {
                    data = Services
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetTerritoryBases")]
        [HttpGet]
        public HttpResponseMessage GetTerritoryBases()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.serviceTerritory.ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        [Route("api/masterData/GetDataTypes")]
        [HttpGet]
        public HttpResponseMessage GetDataTypes()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.DataTypes.ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetDeliveryTypes")]
        [HttpGet]
        public HttpResponseMessage GetDeliveryTypes()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.DeliveryTypes.ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetPeriods")]
        [HttpGet]
        public HttpResponseMessage GetPeriods()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.Periods.ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetFrequencyTypes")]
        [HttpGet]
        public HttpResponseMessage GetFrequencyTypes()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.FrequencyTypes.ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetFrequencies")]
        [HttpGet]
        public HttpResponseMessage GetFrequencies()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.Frequencies.Select(f => new
                {
                    f.FrequencyId,
                    f.Name,
                    FrequencyTypeName = f.frequencyType.Name,
                    f.FrequencyTypeId
                }).ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetSources")]
        [HttpGet]
        public HttpResponseMessage GetSources()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var masterCollection = context.Sources.ToList();
                var response = new
                {
                    data = masterCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }



        [Route("api/country/update")]
        [HttpPost]
        public HttpResponseMessage updateCountries([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteCountry = context.Countries.FirstOrDefault(c => c.CountryId == request.CountryId);
                    context.Countries.Remove(deleteCountry);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.CountryId != null && request.CountryId != 0)
                {
                    if (context.Countries.Any(x => (x.Name.Equals(request.CountryName, StringComparison.InvariantCultureIgnoreCase)
                                        && x.CountryId != request.CountryId)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateCountry = context.Countries.FirstOrDefault(c => c.CountryId == request.CountryId);
                        updateCountry.Name = request.CountryName;
                        updateCountry.ISOCode = request.ISOcode;
                        isSuccess = true;
                    }
                }
                else
                {
                    if (context.Countries.Any(x => x.Name.Equals(request.CountryName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var country = new Country() { Name = request.CountryName, ISOCode = request.ISOcode };
                        context.Countries.Add(country);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/source/update")]
        [HttpPost]
        public HttpResponseMessage updateSource([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteCountry = context.Sources.FirstOrDefault(c => c.SourceId == request.SourceId);
                    context.Sources.Remove(deleteCountry);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.SourceId != null && request.SourceId != 0)
                {

                    if (context.Sources.Any(s => s.Name.Equals(request.SourceName, StringComparison.InvariantCultureIgnoreCase)
                    && s.SourceId != request.SourceId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateCountry = context.Sources.FirstOrDefault(c => c.SourceId == request.SourceId);
                        updateCountry.Name = request.SourceName;
                        isSuccess = true;
                    }

                }
                else
                {
                    if (context.Sources.Any(s => s.Name.Equals(request.SourceName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new Source() { Name = request.SourceName };
                        context.Sources.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/datatype/update")]
        [HttpPost]
        public HttpResponseMessage updatedatatype([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteCountry = context.DataTypes.FirstOrDefault(c => c.DataTypeId == request.DataTypeId);
                    context.DataTypes.Remove(deleteCountry);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.DataTypeId != null && request.DataTypeId != 0)
                {

                    if (context.DataTypes.Any(s => s.Name.Equals(request.DataTypeName, StringComparison.InvariantCultureIgnoreCase)
                    && s.DataTypeId != request.DataTypeId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateCountry = context.DataTypes.FirstOrDefault(c => c.DataTypeId == request.DataTypeId);
                        updateCountry.Name = request.DataTypeName;
                        updateCountry.IsChannel = request.IsChannel;
                        isSuccess = true;
                    }

                }
                else
                {
                    if (context.DataTypes.Any(s => s.Name.Equals(request.DataTypeName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var dataType = new DataType() { Name = request.DataTypeName, IsChannel = request.IsChannel };
                        context.DataTypes.Add(dataType);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/territoryBase/update")]
        [HttpPost]
        public HttpResponseMessage updateTerritoryBase([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {
                    var deleteEntity = context.serviceTerritory.FirstOrDefault(c => c.ServiceTerritoryId == request.ServiceTerritoryId);
                    context.serviceTerritory.Remove(deleteEntity);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.ServiceTerritoryId != null && request.ServiceTerritoryId != 0)
                {

                    if (context.serviceTerritory.Any(s => s.TerritoryBase.Equals(request.TerritoryBase, StringComparison.InvariantCultureIgnoreCase)
                    && s.ServiceTerritoryId != request.ServiceTerritoryId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateEntity = context.serviceTerritory.FirstOrDefault(c => c.ServiceTerritoryId == request.ServiceTerritoryId);
                        updateEntity.TerritoryBase = request.TerritoryBase;
                        isSuccess = true;
                    }
                }
                else
                {
                    if (context.serviceTerritory.Any(s => s.TerritoryBase.Equals(request.TerritoryBase, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new ServiceTerritory() { TerritoryBase = request.TerritoryBase };
                        context.serviceTerritory.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/deliverytype/update")]
        [HttpPost]
        public HttpResponseMessage updateDeliveryType([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteEntity = context.DeliveryTypes.FirstOrDefault(c => c.DeliveryTypeId == request.DeliveryTypeId);
                    context.DeliveryTypes.Remove(deleteEntity);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.DeliveryTypeId != null && request.DeliveryTypeId != 0)
                {

                    if (context.DeliveryTypes.Any(s => s.Name.Equals(request.DeliveryTypeName, StringComparison.InvariantCultureIgnoreCase)
                    && s.DeliveryTypeId != request.DeliveryTypeId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateEntity = context.DeliveryTypes.FirstOrDefault(c => c.DeliveryTypeId == request.DeliveryTypeId);
                        updateEntity.Name = request.DeliveryTypeName;
                        isSuccess = true;
                    }
                }
                else
                {
                    if (context.DeliveryTypes.Any(s => s.Name.Equals(request.DeliveryTypeName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new DeliveryType() { Name = request.DeliveryTypeName };
                        context.DeliveryTypes.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/period/update")]
        [HttpPost]
        public HttpResponseMessage updatePeriod([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteEntity = context.Periods.FirstOrDefault(c => c.PeriodId == request.PeriodId);
                    context.Periods.Remove(deleteEntity);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.PeriodId != null && request.PeriodId != 0)
                {

                    if (context.Periods.Any(s => s.Name.Equals(request.PeriodName, StringComparison.InvariantCultureIgnoreCase)
                    && s.PeriodId != request.PeriodId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateEntity = context.Periods.FirstOrDefault(c => c.PeriodId == request.PeriodId);
                        updateEntity.Name = request.PeriodName;
                        updateEntity.Number = request.Number;
                        isSuccess = true;
                    }

                }
                else
                {
                    if (context.Periods.Any(s => s.Name.Equals(request.PeriodName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new Period() { Name = request.PeriodName, Number = request.Number };
                        context.Periods.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/frequencytype/update")]
        [HttpPost]
        public HttpResponseMessage updateFrequencyType([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteEntity = context.FrequencyTypes.FirstOrDefault(c => c.FrequencyTypeId == request.FrequencyTypeId);
                    context.FrequencyTypes.Remove(deleteEntity);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.FrequencyTypeId != null && request.FrequencyTypeId != 0)
                {

                    if (context.FrequencyTypes.Any(s => s.Name.Equals(request.FrequencyTypeName, StringComparison.InvariantCultureIgnoreCase)
                    && s.FrequencyTypeId != request.FrequencyTypeId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateEntity = context.FrequencyTypes.FirstOrDefault(c => c.FrequencyTypeId == request.FrequencyTypeId);
                        updateEntity.Name = request.FrequencyTypeName;
                        updateEntity.DefaultYears = request.DefaultYears;
                        isSuccess = true;
                    }

                }
                else
                {
                    if (context.FrequencyTypes.Any(s => s.Name.Equals(request.FrequencyTypeName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new FrequencyType() { Name = request.FrequencyTypeName, DefaultYears = request.DefaultYears };
                        context.FrequencyTypes.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/frequency/update")]
        [HttpPost]
        public HttpResponseMessage updateFrequency([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteEntity = context.Frequencies.FirstOrDefault(c => c.FrequencyId == request.FrequencyId);
                    context.Frequencies.Remove(deleteEntity);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.FrequencyId != null && request.FrequencyId != 0)
                {
                    if (context.Frequencies.Any(s => s.Name.Equals(request.FrequencyName, StringComparison.InvariantCultureIgnoreCase)
                    && s.FrequencyId != request.FrequencyId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateEntity = context.Frequencies.FirstOrDefault(c => c.FrequencyId == request.FrequencyId);
                        updateEntity.Name = request.FrequencyName;
                        updateEntity.FrequencyTypeId = request.FrequencyTypeId;
                        isSuccess = true;
                    }

                }
                else
                {
                    if (context.Frequencies.Any(s => s.Name.Equals(request.FrequencyName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new Frequency() { Name = request.FrequencyName, FrequencyTypeId = request.FrequencyTypeId };
                        context.Frequencies.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/service/update")]
        [HttpPost]
        public HttpResponseMessage updateServices([FromBody]requestMasterData request)
        {
            var msg = "successfully saved";
            var isSuccess = false;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (Convert.ToString(request.Action).Equals("delete", StringComparison.InvariantCultureIgnoreCase))
                {

                    var deleteEntity = context.Services.FirstOrDefault(c => c.ServiceId == request.ServiceId);
                    context.Services.Remove(deleteEntity);
                    context.SaveChanges();
                    msg = "Successfully removed";
                    var deleteResponse = new
                    {
                        msg,
                        isSuccess = true
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, deleteResponse);
                    return message;
                }


                if (request.ServiceId != null && request.ServiceId != 0)
                {
                    if (context.Services.Any(s => s.Name.Equals(request.ServiceName, StringComparison.InvariantCultureIgnoreCase)
                    && s.ServiceId != request.ServiceId))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var updateEntity = context.Services.FirstOrDefault(c => c.ServiceId == request.ServiceId);
                        updateEntity.Name = request.ServiceName;
                        isSuccess = true;
                    }

                }
                else
                {
                    if (context.Services.Any(s => s.Name.Equals(request.ServiceName, StringComparison.InvariantCultureIgnoreCase)))
                    {
                        msg = "Name already exists";
                        isSuccess = false;
                    }
                    else
                    {
                        var newEntity = new Service() { Name = request.ServiceName };
                        context.Services.Add(newEntity);
                        isSuccess = true;
                    }
                };

                context.SaveChanges();
                var response = new
                {
                    msg,
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/masterData/GetEntityTypes")]
        [HttpGet]
        public List<EntityType> GetEntityTypes()
        {
            List<EntityType> entityTypes = null;
            using (var context = new EverestPortalContext())
            {
                entityTypes = context.EntityTypes.Where(e => e.DataTypeId != null).OrderBy(e => e.EntityTypeName).ToList();
            }
            return entityTypes;
        }

        [Route("api/masterData/SaveSubchannel")]
        [HttpPost]
        public bool SaveSubchannel([FromBody]EntityType entityType)
        {
            bool result = false;
            if (entityType != null)
            {
                using (var context = new EverestPortalContext())
                {
                    if (entityType.EntityTypeId == 0) //Add a new record
                    {
                        var isExist = context.EntityTypes.FirstOrDefault(e =>
                            e.EntityTypeName == entityType.EntityTypeCode.Trim() ||
                            e.Abbrev == entityType.Abbrev.Trim() ||
                            e.Display == entityType.Display.Trim() ||
                            e.Description == entityType.Description.Trim()
                        );

                        if (isExist != null)
                        {
                            return false;
                        }

                        var entity = new EntityType()
                        {
                            EntityTypeCode = entityType.EntityTypeCode.Trim(),
                            EntityTypeName = entityType.Display.Trim(),
                            DataTypeId = entityType.DataTypeId,
                            Abbrev = entityType.Abbrev.Trim(),
                            Display = entityType.Display.Trim(),
                            Description = entityType.Description.Trim(),
                            IsActive = entityType.IsActive
                        };

                        context.EntityTypes.Add(entity);
                    }
                    else //Update existing record
                    {
                        var isExist = context.EntityTypes.FirstOrDefault(e =>
                            (e.EntityTypeName == entityType.EntityTypeCode.Trim() ||
                            e.Abbrev == entityType.Abbrev.Trim() ||
                            e.Display == entityType.Display.Trim() ||
                            e.Description == entityType.Description.Trim()) &&
                            e.EntityTypeId != entityType.EntityTypeId
                        );

                        if (isExist != null)
                        {
                            return false;
                        }

                        var entity = context.EntityTypes.SingleOrDefault(e => e.EntityTypeId == entityType.EntityTypeId);
                        if (entity != null)
                        {
                            entity.EntityTypeCode = entityType.EntityTypeCode.Trim();
                            entity.EntityTypeName = entityType.EntityTypeName.Trim();
                            entity.DataTypeId = entityType.DataTypeId;
                            entity.Abbrev = entityType.Abbrev.Trim();
                            entity.Display = entityType.Display.Trim();
                            entity.Description = entityType.Description.Trim();
                            entity.IsActive = entityType.IsActive;
                        }

                        //If enity type is inactive then delete all respective subchannels
                        if (!entityType.IsActive)
                        { 
                            var subchannels = context.SubChannels.Where(s => s.EntityTypeId == entityType.EntityTypeId).ToList();
                            context.SubChannels.RemoveRange(subchannels);
                        }
                    }

                    context.SaveChanges();
                    result = true;
                }
            }

            return result;
        }

        [Route("api/masterData/DeleteSubchannel")]
        [HttpPost]
        public bool DeleteSubchannel(int entityTypeId)
        {
            bool result = false;
            if (entityTypeId > 0)
            {
                using (var context = new EverestPortalContext())
                {
                    var entityType = context.EntityTypes.Where(e => e.EntityTypeId == entityTypeId).ToList();
                    context.EntityTypes.RemoveRange(entityType);

                    var subchannels = context.SubChannels.Where(s => s.EntityTypeId == entityTypeId).ToList();
                    context.SubChannels.RemoveRange(subchannels);

                    context.SaveChanges();
                    result = true;
                }
            }
            return result;
        }
    }

    public class requestMasterData
    {

        public string Action { get; set; }
        //country 
        public int CountryId { get; set; }
        public string CountryName { get; set; }
        public string ISOcode { get; set; }

        //Service
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }

        //service Territory
        public int ServiceTerritoryId { get; set; }
        public string TerritoryBase { get; set; }

        //datatype
        public int DataTypeId { get; set; }
        public string DataTypeName { get; set; }
        public bool IsChannel { get; set; }

        //source
        public int SourceId { get; set; }
        public string SourceName { get; set; }

        //delivery type       
        public int DeliveryTypeId { get; set; }
        public string DeliveryTypeName { get; set; }

        //period
        public int PeriodId { get; set; }
        public string PeriodName { get; set; }
        public int Number { get; set; }

        //frequency type

        public int FrequencyTypeId { get; set; }
        public string FrequencyTypeName { get; set; }
        public string DefaultYears { get; set; }

        //frequency
        public int FrequencyId { get; set; }
        public string FrequencyName { get; set; }

    }
}
