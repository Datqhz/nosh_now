namespace MyApp.Models
{
    public class Account : IModel
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public DateTime CreatedDate { get; set;}
        public int RoleId { get; set; }
        public virtual Role Role {get; set;}
        public virtual Eater Eater{ get; set; }
        public virtual Merchant Merchant{ get; set; }
        public virtual Shipper Shipper{ get; set; }
        public virtual Manager Manager{ get; set; }
    }
}