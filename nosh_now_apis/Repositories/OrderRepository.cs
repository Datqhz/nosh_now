using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class OrderRepository : IOrderRepository
    {
        private readonly MyAppContext _context;
        public OrderRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Order> Delete(int Id)
        {
            var order = await _context.Order.FindAsync(Id);
            _context.Order.Remove(order);
            await Save();
            return order;
        }

        public async Task<IEnumerable<Order>> FindByEater(int eaterId)
        {
            return await _context.Order.Where(o => o.EaterId == eaterId).ToListAsync();
        }

        public async Task<IEnumerable<Order>> FindByMerchant(int merchantId)
        {
            return await _context.Order.Where(o => o.MerchantId == merchantId).ToListAsync();
        }

        public async Task<Order> FindByMerchantAndEater(int merchantId, int eaterId)
        {
#pragma warning disable CS8603 // Possible null reference return.
            return await _context.Order
            .Where(o => o.StatusId == 1 && o.MerchantId == merchantId && o.EaterId == eaterId)
            .Include(o => o.OrderDetails)
            .Select(o => new Order
            {
                Id = o.Id,
                OrderedDate = o.OrderedDate,
                ShipmentFee = o.ShipmentFee,
                Phone = o.Phone,
                Coordinator = o.Coordinator,
                Status = new OrderStatus
                {
                    Id = o.Status.Id,
                    StatusName = o.Status.StatusName,
                    Step = o.Status.Step
                },
                Eater = new Eater
                {
                    Id = o.Eater.Id,
                    DisplayName = o.Eater.DisplayName,
                    Avatar = o.Eater.Avatar,
                    Phone = o.Eater.Phone,
                    Email = o.Eater.Email,
                    AccountId = o.Eater.AccountId,
                    Account = new Account
                    {
                        Id = o.Eater.Account.Id,
                        Email = o.Eater.Account.Email,
                        CreatedDate = o.Eater.Account.CreatedDate
                    }
                },
                Merchant = new Merchant
                {
                    Id = o.Merchant.Id,
                    DisplayName = o.Merchant.DisplayName,
                    Avatar = o.Merchant.Avatar,
                    Phone = o.Merchant.Phone,
                    Email = o.Merchant.Email,
                    OpeningTime = o.Merchant.OpeningTime,
                    ClosingTime = o.Merchant.ClosingTime,
                    Coordinator = o.Merchant.Coordinator,
                    Status = o.Merchant.Status,
                    AccountId = o.Merchant.AccountId,
                    CategoryId = o.Merchant.CategoryId,
                    Account = new Account
                    {
                        Id = o.Merchant.Account.Id,
                        Email = o.Merchant.Account.Email,
                        CreatedDate = o.Merchant.Account.CreatedDate
                    },
                    Category = new Category
                    {
                        Id = o.Merchant.Category.Id,
                        CategoryName = o.Merchant.Category.CategoryName,
                        CategoryImage = o.Merchant.Category.CategoryImage
                    }
                },
            })
            .FirstOrDefaultAsync();
#pragma warning restore CS8603 // Possible null reference return.
            // return await _context.Order
            // .Where(o => o.StatusId == 1 && o.MerchantId == merchantId && o.EaterId == eaterId)
            // .FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<Order>> FindByShipper(int shipperId)
        {
            return await _context.Order.Where(o => o.ShipperId == shipperId).ToListAsync();
        }

        public async Task<IEnumerable<Order>> GetAll()
        {
            return await _context.Order.ToListAsync();
        }

        public async Task<IEnumerable<Order>> GetAllInitialize()
        {
            return await _context.Order.Where(o => o.StatusId == 1).ToListAsync();
        }

        public async Task<Order> GetById(int id)
        {
#pragma warning disable CS8603 // Possible null reference return.
            return await _context.Order.Where(o => o.Id == id).Include(o => o.OrderDetails).Select(o => new Order
            {
                Id = o.Id,
                OrderedDate = o.OrderedDate,
                ShipmentFee = o.ShipmentFee,
                Phone = o.Phone,
                Coordinator = o.Coordinator,
                Status = new OrderStatus
                {
                    Id = o.Status.Id,
                    StatusName = o.Status.StatusName,
                    Step = o.Status.Step
                },
                Eater = new Eater
                {
                    Id = o.Eater.Id,
                    DisplayName = o.Eater.DisplayName,
                    Avatar = o.Eater.Avatar,
                    Phone = o.Eater.Phone,
                    Email = o.Eater.Email,
                    AccountId = o.Eater.AccountId,
                    Account = new Account
                    {
                        Id = o.Eater.Account.Id,
                        Email = o.Eater.Account.Email,
                        CreatedDate = o.Eater.Account.CreatedDate
                    }
                },
                Merchant = new Merchant
                {
                    Id = o.Merchant.Id,
                    DisplayName = o.Merchant.DisplayName,
                    Avatar = o.Merchant.Avatar,
                    Phone = o.Merchant.Phone,
                    Email = o.Merchant.Email,
                    OpeningTime = o.Merchant.OpeningTime,
                    ClosingTime = o.Merchant.ClosingTime,
                    Coordinator = o.Merchant.Coordinator,
                    Status = o.Merchant.Status,
                    AccountId = o.Merchant.AccountId,
                    CategoryId = o.Merchant.CategoryId,
                    Account = new Account
                    {
                        Id = o.Merchant.Account.Id,
                        Email = o.Merchant.Account.Email,
                        CreatedDate = o.Merchant.Account.CreatedDate
                    },
                    Category = new Category
                    {
                        Id = o.Merchant.Category.Id,
                        CategoryName = o.Merchant.Category.CategoryName,
                        CategoryImage = o.Merchant.Category.CategoryImage
                    }
                }

            }).FirstOrDefaultAsync();
#pragma warning restore CS8603 // Possible null reference return.
            // return await _context.Order.FindAsync(id);
        }
        public async Task<Order> Insert(Order entity)
        {
            var newOrder = await _context.Order.AddAsync(entity);
            await Save();
            return newOrder.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Order> Update(Order entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}