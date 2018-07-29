namespace IMS.EverestPortal.API.Models
{
    public class UsersViewModel
    {
        public int UserID { get; set; }
        public string   UserName{ get; set; }
        public bool IsMyClient { get; set; }
    }
    public class UserEmail
    {
        public string Email { get; set; }
    }
}