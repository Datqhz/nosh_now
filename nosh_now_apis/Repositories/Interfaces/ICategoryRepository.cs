using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface ICategoryRepository : IRepository<Category>
    {
        Task<IEnumerable<Category>> FindByName(string name);
    }
}