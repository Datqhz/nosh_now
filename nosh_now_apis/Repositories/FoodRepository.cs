using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class FoodRepository : IFoodRepository
    {
        private readonly MyAppContext _context;
        public FoodRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Food> Delete(int Id)
        {
            var food = await _context.Food.FindAsync(Id);
            _context.Food.Remove(food);
            await Save();
            return food;
        }

        public async Task<IEnumerable<Food>> FindContainRegex(string regex)
        {
            return await _context.Food
                                .FromSqlRaw("SELECT * FROM Food WHERE FoodName REGEXP {0}", regex)
                                .Select(e => new Food
                                {
                                    Id = e.Id,
                                    FoodName = e.FoodName,
                                    FoodImage = e.FoodImage,
                                    FoodDescribe = e.FoodDescribe,
                                    Price = e.Price,
                                    Status = e.Status,
                                    Merchant = new Merchant
                                    {
                                        Id = e.Merchant.Id,
                                        DisplayName = e.Merchant.DisplayName,
                                        Avatar = e.Merchant.Avatar,
                                        Phone = e.Merchant.Phone,
                                        Email = e.Merchant.Email,
                                        OpeningTime = e.Merchant.OpeningTime,
                                        ClosingTime = e.Merchant.ClosingTime,
                                        Coordinator = e.Merchant.Coordinator,
                                        Status = e.Merchant.Status,
                                        AccountId = e.Merchant.AccountId,
                                        CategoryId = e.Merchant.CategoryId,
                                        Account = new Account
                                        {
                                            Id = e.Merchant.Account.Id,
                                            Email = e.Merchant.Account.Email,
                                            CreatedDate = e.Merchant.Account.CreatedDate
                                        },
                                        Category = new Category
                                        {
                                            Id = e.Merchant.Category.Id,
                                            CategoryName = e.Merchant.Category.CategoryName,
                                        }
                                    },
                                })
                                .ToListAsync();
        }

        public async Task<IEnumerable<Food>> GetAll()
        {
            return await _context.Food.ToListAsync();
        }
        public async Task<Food> GetById(int id)
        {
            return await _context.Food.FindAsync(id);
        }

        public async Task<IEnumerable<Food>> GetByMerchantAndIsSelling(int merchantId)
        {
            return await _context.Food.Where(f => f.MerchantId == merchantId && f.Status != 3).Select(e => new Food
            {
                Id = e.Id,
                FoodName = e.FoodName,
                FoodImage = e.FoodImage,
                FoodDescribe = e.FoodDescribe,
                Price = e.Price,
                Status = e.Status,
                Merchant = new Merchant
                {
                    Id = e.Merchant.Id,
                    DisplayName = e.Merchant.DisplayName,
                    Avatar = e.Merchant.Avatar,
                    Phone = e.Merchant.Phone,
                    Email = e.Merchant.Email,
                    OpeningTime = e.Merchant.OpeningTime,
                    ClosingTime = e.Merchant.ClosingTime,
                    Coordinator = e.Merchant.Coordinator,
                    Status = e.Merchant.Status,
                    AccountId = e.Merchant.AccountId,
                    CategoryId = e.Merchant.CategoryId,
                    Account = new Account
                    {
                        Id = e.Merchant.Account.Id,
                        Email = e.Merchant.Account.Email,
                        CreatedDate = e.Merchant.Account.CreatedDate
                    },
                    Category = new Category
                    {
                        Id = e.Merchant.Category.Id,
                        CategoryName = e.Merchant.Category.CategoryName,
                        CategoryImage = e.Merchant.Category.CategoryImage
                    }
                },
            }).ToListAsync();
        }

        public async Task<IEnumerable<Food>> GetByMerchantWithoutCondition(int merchantId)
        {
            return await _context.Food.Where(f => f.MerchantId == merchantId).Select(e => new Food
            {
                Id = e.Id,
                FoodName = e.FoodName,
                FoodImage = e.FoodImage,
                FoodDescribe = e.FoodDescribe,
                Price = e.Price,
                Status = e.Status,
                Merchant = new Merchant
                {
                    Id = e.Merchant.Id,
                    DisplayName = e.Merchant.DisplayName,
                    Avatar = e.Merchant.Avatar,
                    Phone = e.Merchant.Phone,
                    Email = e.Merchant.Email,
                    OpeningTime = e.Merchant.OpeningTime,
                    ClosingTime = e.Merchant.ClosingTime,
                    Coordinator = e.Merchant.Coordinator,
                    Status = e.Merchant.Status,
                    AccountId = e.Merchant.AccountId,
                    CategoryId = e.Merchant.CategoryId,
                    Account = new Account
                    {
                        Id = e.Merchant.Account.Id,
                        Email = e.Merchant.Account.Email,
                        CreatedDate = e.Merchant.Account.CreatedDate
                    },
                    Category = new Category
                    {
                        Id = e.Merchant.Category.Id,
                        CategoryName = e.Merchant.Category.CategoryName,
                    }
                },
            }).ToListAsync();
        }

        public async Task<Food> Insert(Food entity)
        {
            var newFood = await _context.Food.AddAsync(entity);
            await Save();
            return newFood.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Food> Update(Food entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}