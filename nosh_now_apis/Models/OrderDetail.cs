namespace MyApp.Models
{
    public class OrderDetail : IModel
    {
        public int Id { get; set;}
        public int Quantity { get; set;}
        public double Price { get; set;}
        public int FoodId { get; set;}
        public int OrderId { get; set;}  
        public virtual Order Order{ get; set;}
        public virtual Food Food{ get; set;}
    }
}