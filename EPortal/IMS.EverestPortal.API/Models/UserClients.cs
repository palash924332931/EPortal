using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class UserClients
    {
        private int _id;

        [Key]
        public int ID
        {
            get { return _id; }
            set { _id = value; }
        }

             



        private ICollection<int> _clientID;

        
        public ICollection<int> ClientID
        {
            get { return _clientID; }
            set { _clientID = value; }
        }
        



    }
}