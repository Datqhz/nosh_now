namespace MyApp.Models
{
    public class Eater : IModel
    {
        public int Id { get; set;}
        public string DisplayName { get; set;}
        public byte[] Avatar { get; set;}
        public string Phone { get; set;}
        public string Email { get; set;}
        public int AccountId { get; set;}  
        public virtual Account Account{ get; set;}
        public virtual ICollection<Location> Locations{ get; set;}
        public virtual ICollection<Order> Orders{ get; set;}
    }
}