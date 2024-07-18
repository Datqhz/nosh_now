using Microsoft.VisualStudio.TextTemplating;

namespace MyApp.Models
{
    public class Order : IModel
    {
        public int Id { get; set; }
        public DateTime OrderedDate { get; set; }
        public double ShipmentFee { get; set; }
        public string? Phone { get; set; }
        public string? Coordinator { get; set; }
        public int StatusId { get; set; }
        public int MerchantId { get; set; }
        public int EaterId { get; set; }
        public int? ShipperId { get; set; }
        public int? MethodId { get; set; }
        public virtual Eater Eater { get; set; }
        public virtual OrderStatus Status { get; set; }
        public virtual Merchant Merchant { get; set; }
        public virtual Shipper Shipper { get; set; }
        public virtual PaymentMethod PaymentMethod { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }


        public double CalcTotal()
        {
            double total = 0;
            foreach (OrderDetail detail in OrderDetails)
            {
                total += detail.Price * detail.Quantity;
            }
            return total + ShipmentFee;
        }
        new public String ToString()
        {
            return $"Id: {Id}, OrderedDate: {OrderedDate}, ShipmentFee: {ShipmentFee},totalPay: {0} Phone: {Phone}, Coordinator: {Coordinator}, StatusId: {StatusId}, MerchantId: {MerchantId}, EaterId: {EaterId}, ShipperId: {ShipperId}, MethodID: {MethodId}";
        }
    }
}