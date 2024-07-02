namespace MyApp.Models
{
    public class Role : IModel
    {
        public int Id { get; set; }
        public string RoleName { get; set; }
        public ICollection<Account> Accounts { get; set; }
    }
}