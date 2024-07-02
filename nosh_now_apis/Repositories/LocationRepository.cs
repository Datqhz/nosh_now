using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class LocationRepository : ILocationRepository
    {
        private readonly MyAppContext _context;
        public LocationRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Location> Delete(int Id)
        {
            var location = await _context.Location.FindAsync(Id);
            _context.Location.Remove(location);
            await Save();
            return location;
        }

        public async Task<IEnumerable<Location>> FindByEater(int eaterId)
        {
            return await _context.Location.Where(o => o.EaterId == eaterId).ToListAsync();
        }

        public async Task<IEnumerable<Location>> GetAll()
        {
            return await _context.Location.ToListAsync();
        }
        public async Task<Location> GetById(int id)
        {
            return await _context.Location.FindAsync(id);
        }

        public async Task<Location> GetDefaultByEater(int eaterId)
        {
            return await _context.Location.Where(o => o.Default == true &&o.EaterId == eaterId).FirstOrDefaultAsync();
        }

        public async Task<Location> Insert(Location entity)
        {
            var newLocation = await _context.Location.AddAsync(entity);
            await Save();
            return newLocation.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Location> Update(Location entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}