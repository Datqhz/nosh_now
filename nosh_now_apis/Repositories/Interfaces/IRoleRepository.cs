using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IRoleRepository : IRepository<Role>
    {
        Task<IEnumerable<Role>> FindByName(string name);
    }
}