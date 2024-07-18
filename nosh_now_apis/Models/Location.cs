namespace MyApp.Models
{
    public class Location : IModel
    {
        public int Id { get; set;}
        public string Phone { get; set;}
        public string LocationName { get; set;}
        public string Coordinator { get; set;}
        public bool Default { get; set;}    
        public int EaterId { get; set;}  
        public virtual Eater Eater{ get; set;}
    }
}