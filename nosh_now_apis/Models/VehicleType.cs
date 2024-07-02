namespace MyApp.Models
{
    public class VehicleType : IModel
    {
        public int Id { get; set;}
        public string TypeName { get; set;}
        public byte[] Icon { get; set;}
        public virtual ICollection<Shipper> Shippers{ get; set;}
    }
}