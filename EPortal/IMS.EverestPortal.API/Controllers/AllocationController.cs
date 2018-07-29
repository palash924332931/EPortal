using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using IMS.EverestPortal.API.Models.Security;
using System.Web.Http.Cors;
using System.Security.Claims;
using IMS.EverestPortal.API.Audit;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize(Roles = "Internal Production,Internal GTM,Internal Admin,Internal Support")]
    public class AllocationController : ApiController
    {       
        /// <summary>
        /// Gets the user with assinged clients counts
        /// </summary>
        /// <returns>Users</returns>
        [Route("api/allocation/GetUsersWithClientAssignedCount")]
        [HttpGet]
        [Authorize]
        public HttpResponseMessage GetUsersWithClients()
        {            
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var userClients = (from user in context.Users
                                   join
                                   //uType in context.userType on user.UserTypeID equals uType.UserTypeID
                                   uRole in context.userRole on user.UserID equals uRole.UserID
                                  join
                                  clUser in context.userClient on user.UserID equals clUser.UserID
                                   
                                  into gCUsers
                                  from clUser in gCUsers.DefaultIfEmpty()
                                  //where uType.UserTypeName != "External users"
                                  where uRole.role.IsExternal==false
                                   select new
                                  {
                                      userID = user.UserID,
                                      userMailId = user.UserName,
                                      userName = user.FirstName +" "+user.LastName,
                                      clientID = clUser.ClientID == null ? 0: clUser.ClientID
                                  }).ToList();


                var userCLientsCount = userClients.GroupBy(x => x.userID).Select(x => new {
                    userId=x.Key,
                    userName =x.First().userName,                    
                    count = x.Where(y=>y.clientID!=0).Count()
                });

                var result = new
                {
                    data = userCLientsCount.OrderBy(o => o.userName)
                };
               
                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;

            }
           
        }

        /// <summary>
        /// Gets the Clients with assigned user count
        /// </summary>
        /// <returns>Clients collection</returns>
        [Route("api/allocation/GetClientsWithUserAssignedCount")]
        [HttpGet]
        public HttpResponseMessage GetClientsWithUser()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clientUsers = (from client in context.Clients
                                    join clUser in context.userClient on client.Id equals clUser.ClientID  
                                   into gCUsers
                                   from nUser in gCUsers.Where(clUser => clUser.user.userType.UserTypeName != "External users").DefaultIfEmpty()
                                   select new
                                   {
                                       clientId = client.Id,
                                       clientName = client.Name,
                                       userID = nUser.UserID == null ? 0 : nUser.UserID
                                   }).ToList();


                var userCLientsCount = clientUsers.GroupBy(x => x.clientId).Select(x => new {
                    clientId = x.Key,
                    clientName = x.First().clientName,
                    count = x.Where(y => y.userID != 0).Count()
                });

                var result = new
                {
                    data = userCLientsCount.OrderBy(o => o.clientName)
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;

            }

        }


        /// <summary>
        /// Allocates the users with the clients
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [Route("api/allocation/AllocateUserWithClients")]
        [HttpPost]
        public HttpResponseMessage Allocate([FromBody]RequestAllocation request)
        {
            var users = request.Users;
            var clients = request.Clients;
            var actionUser = request.ActionUser;
            Allocate(users, clients, actionUser);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        /// <summary>
        /// adds the new users and clients to userClients
        /// </summary>
        /// <param name="users"></param>
        /// <param name="clients"></param>
        private static void Allocate(IEnumerable<int> users, IEnumerable<int> clients, int actionUser)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                foreach (var userId in users)
                {
                    foreach (var clientId in clients)
                    {
                        if (!context.userClient.Any(x => (x.UserID == userId && x.ClientID == clientId)))//Checks If already User Assigned to Client
                            context.userClient.Add(new UserClient { UserID = userId, ClientID = clientId });
                    };
                }
                context.SaveChanges();

                foreach(var userId in users)
                {
                    var objClient = context.Users.SingleOrDefault(p => p.UserID == userId);
                    IAuditLog log = AuditFactory.GetInstance(typeof(User).Name);
                    log.SaveVersion<User>(objClient, actionUser);
                }
            }
        }

        /// <summary>
        /// Removes the assigend user or clients
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [Route("api/allocation/Delete")]
        [HttpPost]
        public HttpResponseMessage Delete([FromBody]RequestAllocation request)
        {
            var users = request.Users;
            var clients = request.Clients;
            var actionUser = request.ActionUser;
            DeleteAllocation(users, clients, actionUser);
            return Request.CreateResponse(HttpStatusCode.NoContent);
        }

        /// <summary>
        /// Deletes the user clients for the supllied users and clients
        /// </summary>
        /// <param name="users"></param>
        /// <param name="clients"></param>
        private static void DeleteAllocation(IEnumerable<int> users, IEnumerable<int> clients, int actionUser)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var userClientsToDelete = context.userClient.Where(x => users.Contains(x.UserID) && clients.Contains(x.ClientID));
                context.userClient.RemoveRange(userClientsToDelete);
                context.SaveChanges();
            }

            using (EverestPortalContext context = new EverestPortalContext())
            {
                foreach (int userid in users)
                {
                    var objClient = context.Users.SingleOrDefault(p => p.UserID == userid);
                    IAuditLog log = AuditFactory.GetInstance(typeof(User).Name);
                    log.SaveVersion<User>(objClient, actionUser);
                }
            }
        }

        /// <summary>
        /// Reallocates the assigned users or clients to another users or clients
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [Route("api/allocation/Reallocate")]
        [HttpPost]
        public HttpResponseMessage Reallocate([FromBody]RequestAllocation request)
        {
            DeleteAllocation(request.Users, request.Clients,request.ActionUser);
            Allocate(request.ReallocatedUsers, request.ReallocatedClients,request.ActionUser);
            return Request.CreateResponse(HttpStatusCode.Created);
        }

        [Route("api/allocation/GetClientByUser")]
        [HttpGet]
        public HttpResponseMessage GetClientsByUser([FromUri]int id)
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = (from client in context.Clients
                                   join
                                   clUser in context.userClient on client.Id equals clUser.ClientID
                                   where clUser.UserID == id
                                   select new
                                   {
                                       clientId = client.Id,
                                       clientName = client.Name
                                   }).ToList();


               
                var result = new
                {
                    data = clients.OrderBy(o => o.clientName)
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }

        [Route("api/allocation/GetUserByClient")]
        [HttpGet]
        public HttpResponseMessage GetUsersByClient([FromUri]int id)
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var users = (from user in context.Users
                             join
                             uType in  context.userType on user.UserTypeID equals uType.UserTypeID
                             join
                             clUser in context.userClient on user.UserID equals clUser.UserID
                             where clUser.ClientID == id && uType.UserTypeName != "External users"
                            
                             select new
                               {
                                   userId = user.UserID,
                                   userName = user.UserName
                               }).ToList();



                var result = new
                {
                    data = users.OrderBy(o => o.userName)
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }

        [Route("api/allocation/ToReallocateUsers")]
        [HttpPost]
        public HttpResponseMessage GetToReallocateUsers([FromBody]RequestAllocation request)
        {
            var clients = request.ReallocatedClients;            
            using(EverestPortalContext context = new EverestPortalContext())
            {
                
                var userClients = (from user in context.Users
                                   join
                                   uType in context.userType on user.UserTypeID equals uType.UserTypeID
                                   join
                                   clUser in context.userClient on user.UserID equals clUser.UserID

                                   into gCUsers
                                   from clUser in gCUsers.DefaultIfEmpty()
                                   where uType.UserTypeName != "External users"
                                   select new
                                   {
                                       userID = user.UserID,
                                       userName = user.UserName,
                                       clientID = clUser.ClientID == null ? 0 : clUser.ClientID
                                   }).ToList();

                var toReallocationUser = userClients.GroupBy(x => x.userID)
                                .Where(g => !g.Any(gi => clients.Contains(gi.clientID)))
                                .Select(x => new {
                                    userId = x.Key,
                                    userName = x.First().userName
                                }).OrderBy(x => x.userName);

               
               
                var response = new
                {
                    data = toReallocationUser
                };

               return Request.CreateResponse(HttpStatusCode.OK, response);
            }
           
        }



        [Route("api/allocation/ToReallocateClients")]
        [HttpPost]
        public HttpResponseMessage GetToReallocateClients([FromBody]RequestAllocation request)
        {
            var users = request.ReallocatedUsers;
            using (EverestPortalContext context = new EverestPortalContext())
            {
               
                var clientUsers = (from client in context.Clients
                                   join
                                   clUser in context.userClient on client.Id equals clUser.ClientID
                                   into gCUsers

                                   from clUser in gCUsers.DefaultIfEmpty()
                                   where clUser.user.userType.UserTypeName != "External users"
                                   
                                   select new
                                   {
                                       clientId = client.Id,
                                       clientName = client.Name,
                                       userID = clUser.UserID == null ? 0 : clUser.UserID
                                   }).ToList();

                var toReallocationClient = clientUsers.GroupBy(x => x.clientId)
                                .Where(g => !g.Any(gi => users.Contains(gi.userID)))
                                .Select(x => new {
                                    clientId = x.Key,
                                    clientName = x.First().clientName
                                }).OrderBy(x=>x.clientName);



                var response = new
                {
                    data = toReallocationClient
                };

                return Request.CreateResponse(HttpStatusCode.OK, response);
            }

        }

    }
}
