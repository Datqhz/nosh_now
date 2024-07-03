using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class AccountRepository : IAccountRepository
    {
        private readonly MyAppContext _context;
        public AccountRepository(MyAppContext context)
        {
            this._context = context;
        }

        public async Task<int> CountAccountByRoleAndDate(int roleId, DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.Account.Where(f => f.RoleId == roleId);

            if (year.HasValue)
            {
                query = query.Where(f => f.CreatedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.CreatedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.CreatedDate.Date == date.Value.Date);
            }

            return await query.CountAsync();
        }

        public async Task<Account> Delete(int Id)
        {
            var acccount = await _context.Account.FindAsync(Id);
            _context.Account.Remove(acccount);
            await Save();
            return acccount;
        }

        public async Task<Account> FindByEmail(string email)
        {
            return await _context.Account.Where(a => a.Email == email)
            .FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<Account>> GetAll()
        {
            return await _context.Account.ToListAsync();
        }
        public async Task<Account> GetById(int id)
        {
            return await _context.Account.FindAsync(id);
        }
        public async Task<Account> Insert(Account entity)
        {
            var newAccount = await _context.Account.AddAsync(entity);
            await Save();
            return newAccount.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Account> Update(Account entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}