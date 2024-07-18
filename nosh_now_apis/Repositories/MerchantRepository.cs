using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class MerchantRepository : IMerchantRepository
    {
        private readonly MyAppContext _context;
        public MerchantRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Merchant> Delete(int Id)
        {
            var merchant = await _context.Merchant.FindAsync(Id);
            _context.Merchant.Remove(merchant);
            await Save();
            return merchant;
        }

        public async Task<IEnumerable<Merchant>> FindContainRegex(string regex)
        {
            return await _context.Merchant
                                .FromSqlRaw("SELECT * FROM Merchant WHERE DisplayName REGEXP {0}", regex)
                                .Select(e => new Merchant
                                {
                                    Id = e.Id,
                                    DisplayName = e.DisplayName,
                                    Avatar = e.Avatar,
                                    Phone = e.Phone,
                                    Email = e.Email,
                                    OpeningTime = e.OpeningTime,
                                    ClosingTime = e.ClosingTime,
                                    Coordinator = e.Coordinator,
                                    Status = e.Status,
                                    AccountId = e.AccountId,
                                    CategoryId = e.CategoryId,
                                    Account = new Account
                                    {
                                        Id = e.Account.Id,
                                        Email = e.Account.Email,
                                        CreatedDate = e.Account.CreatedDate
                                    },
                                    Category = new Category
                                    {
                                        Id = e.Category.Id,
                                        CategoryName = e.Category.CategoryName,
                                    }
                                })
                                .ToListAsync();
        }

        public async Task<IEnumerable<Merchant>> GetAll()
        {
            return await _context.Merchant.ToListAsync();
        }

        public async Task<IEnumerable<Merchant>> GetAllMerchantIsOpening()
        {
            return await _context.Merchant
                                .Where(m => m.Status == true)
                                .Select(e => new Merchant
                                {
                                    Id = e.Id,
                                    DisplayName = e.DisplayName,
                                    Avatar = e.Avatar,
                                    Phone = e.Phone,
                                    Email = e.Email,
                                    OpeningTime = e.OpeningTime,
                                    ClosingTime = e.ClosingTime,
                                    Coordinator = e.Coordinator,
                                    Status = e.Status,
                                    AccountId = e.AccountId,
                                    CategoryId = e.CategoryId,
                                    Account = new Account
                                    {
                                        Id = e.Account.Id,
                                        Email = e.Account.Email,
                                        CreatedDate = e.Account.CreatedDate,
                                        Role = new Role{
                                            Id = e.Account.Role.Id,
                                            RoleName = e.Account.Role.RoleName,
                                        }
                                    },
                                    Category = new Category
                                    {
                                        Id = e.Category.Id,
                                        CategoryName = e.Category.CategoryName,
                                        CategoryImage = e.Category.CategoryImage
                                    }
                                })
                                .ToListAsync();
        }

        public async Task<Merchant> GetById(int id)
        {
            return await _context.Merchant.FindAsync(id);
        }
        public async Task<Merchant> Insert(Merchant entity)
        {
            var newMerchant = await _context.Merchant.AddAsync(entity);
            await Save();
            return newMerchant.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Merchant> Update(Merchant entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}