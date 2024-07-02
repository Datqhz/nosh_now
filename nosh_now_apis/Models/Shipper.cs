namespace MyApp.Models
{
    public class Shipper : IModel
    {
        public int Id { get; set;}
        public string DisplayName { get; set;}
        public byte[] Avatar { get; set;}
        public string Phone { get; set;}
        public string Email { get; set;}
        public string VehicleName { get; set;}
        public string MomoPayment { get; set;}
        public string Coordinator { get; set;}
        public bool Status { get; set;}
        public int AccountId { get; set;}  
        public int VehicleTypeId { get; set;}
        public virtual Account Account{ get; set;}
        public virtual VehicleType VehicleType{ get; set;}
        public virtual ICollection<Order> Orders{ get; set;}
    }
}