namespace MyApp.Models
{
    public class PaymentMethod : IModel
    {
        public int Id { get; set;}
        public string MethodName { get; set;}
        public byte[] MethodImage { get; set;}
        public virtual ICollection<Order> Orders{ get; set;}
    }
}