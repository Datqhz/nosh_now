using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class ManagerRepository : IRepository<Manager>
    {
        private readonly MyAppContext _context;
        public ManagerRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Manager> Delete(int Id)
        {
            var manager = await _context.Manager.FindAsync(Id);
            _context.Manager.Remove(manager);
            await Save();
            return manager;
        }
        public async Task<IEnumerable<Manager>> GetAll()
        {
            return await _context.Manager.ToListAsync();
        }
        public async Task<Manager> GetById(int id)
        {
            return await _context.Manager.FindAsync(id);
        }
        public async Task<Manager> Insert(Manager entity)
        {
            var newManager = await _context.Manager.AddAsync(entity);
            await Save();
            return newManager.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Manager> Update(Manager entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}