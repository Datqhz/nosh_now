using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class EaterRepository : IEaterRepository
    {
        private readonly MyAppContext _context;
        public EaterRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Eater> Delete(int Id)
        {
            var eater = await _context.Eater.FindAsync(Id);
            _context.Eater.Remove(eater);
            await Save();
            return eater;
        }

        public async Task<IEnumerable<Eater>> FindContainRegex(string regex)
        {
            return await _context.Eater
                                .FromSqlRaw("SELECT * FROM Eater WHERE DisplayName REGEXP {0}", regex)
                                .Select(e => new Eater
                                {
                                    Id = e.Id,
                                    DisplayName = e.DisplayName,
                                    Avatar = e.Avatar,
                                    Phone = e.Phone,
                                    Email = e.Email,
                                    AccountId = e.AccountId,
                                    Account = new Account
                                    {
                                        Id = e.Account.Id,
                                        Email = e.Account.Email,
                                        CreatedDate = e.Account.CreatedDate
                                    }
                                })
                                .ToListAsync();
        }

        public async Task<IEnumerable<Eater>> GetAll()
        {
            return await _context.Eater.ToListAsync();
        }
        public async Task<Eater> GetById(int id)
        {
            return await _context.Eater.FindAsync(id);
        }
        public async Task<Eater> Insert(Eater entity)
        {
            var newEater = await _context.Eater.AddAsync(entity);
            await Save();
            return newEater.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Eater> Update(Eater entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}