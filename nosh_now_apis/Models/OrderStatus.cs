namespace MyApp.Models
{
    public class OrderStatus : IModel
    {
        public int Id { get; set;}
        public string StatusName { get; set;}
        public int Step { get; set;}
        public virtual ICollection<Order> Orders { get; set;}
    }
}