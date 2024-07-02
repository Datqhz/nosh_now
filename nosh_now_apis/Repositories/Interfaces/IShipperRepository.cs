using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IShipperRepository : IRepository<Shipper>
    {
        Task<IEnumerable<Shipper>> FindContainRegex(string regex);
    }
}