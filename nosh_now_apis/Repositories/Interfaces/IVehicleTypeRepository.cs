using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IVehicleTypeRepository : IRepository<VehicleType>
    {
        Task<IEnumerable<VehicleType>> FindByName(string name);
    }
}