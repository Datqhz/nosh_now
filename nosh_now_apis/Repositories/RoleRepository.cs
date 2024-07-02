using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class RoleRepository : IRoleRepository
    {
        private readonly MyAppContext _context;
        public RoleRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Role> Delete(int Id)
        {
            var role = await _context.Role.FindAsync(Id);
            _context.Role.Remove(role);
            await Save();
            return role;
        }

        public async Task<IEnumerable<Role>> FindByName(string name)
        {
            return await _context.Role.Where(c => c.RoleName == name).ToListAsync();
        }

        public async Task<IEnumerable<Role>> GetAll()
        {
            return await _context.Role.ToListAsync();
        }
        public async Task<Role> GetById(int id)
        {
            return await _context.Role.FindAsync(id);
        }
        public async Task<Role> Insert(Role entity)
        {
            var newRole = await _context.Role.AddAsync(entity);
            await Save();
            return newRole.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Role> Update(Role entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}