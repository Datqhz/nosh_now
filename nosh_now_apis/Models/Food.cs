namespace MyApp.Models
{
    public class Food : IModel
    {
        public int Id { get; set; }
        public string FoodName { get; set; }
        public byte[] FoodImage {get; set; }
        public string FoodDescribe { get; set; }
        public double Price { get; set; }
        public int Status { get; set; } // 1 is sell, 2 is sold out, 3 is stop sell
        public int MerchantId { get; set; }
        public virtual Merchant Merchant { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails{ get; set; }
    }   
}