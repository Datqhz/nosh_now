using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface ILocationRepository : IRepository<Location>
    {
        Task<IEnumerable<Location>> FindByEater(int eaterId);
        Task<Location> GetDefaultByEater(int eaterId);
    }
}