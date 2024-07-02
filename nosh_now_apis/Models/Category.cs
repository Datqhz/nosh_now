namespace MyApp.Models
{
    public class Category : IModel
    {
        public int Id { get; set;}
        public string CategoryName { get; set;}
        public byte[] CategoryImage { get; set;}
        public virtual ICollection<Merchant> Merchants { get; set;}
    }
}