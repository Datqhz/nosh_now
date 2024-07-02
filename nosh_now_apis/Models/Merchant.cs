namespace MyApp.Models
{
    public class Merchant : IModel
    {
        public int Id { get; set;}
        public string DisplayName { get; set;}
        public byte[] Avatar { get; set;}
        public string Phone { get; set;}
        public string Email { get; set;}
        public string OpeningTime { get; set;}
        public string ClosingTime { get; set;}
        public string Coordinator { get; set;}
        public bool Status { get; set;}
        public int AccountId { get; set;}  
        public int CategoryId { get; set;}
        public virtual Account Account{ get; set;}
        public virtual Category Category{ get; set;}
        public virtual ICollection<Order> Orders{ get; set;}
        public virtual ICollection<Food> Foods{ get; set;}
    }
}