using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class VehicleTypeRepository : IVehicleTypeRepository
    {
        private readonly MyAppContext _context;
        public VehicleTypeRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<VehicleType> Delete(int Id)
        {
            var vehicleType = await _context.VehicleType.FindAsync(Id);
            _context.VehicleType.Remove(vehicleType);
            await Save();
            return vehicleType;
        }

        public async Task<IEnumerable<VehicleType>> FindByName(string name)
        {
            return await _context.VehicleType.Where(c => c.TypeName == name).ToListAsync();
        }

        public async Task<IEnumerable<VehicleType>> GetAll()
        {
            return await _context.VehicleType.ToListAsync();
        }
        public async Task<VehicleType> GetById(int id)
        {
            return await _context.VehicleType.FindAsync(id);
        }
        public async Task<VehicleType> Insert(VehicleType entity)
        {
            var newVehicleType = await _context.VehicleType.AddAsync(entity);
            await Save();
            return newVehicleType.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<VehicleType> Update(VehicleType entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}