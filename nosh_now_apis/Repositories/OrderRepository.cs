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
            return await _context.Order.Where(o => o.EaterId == eaterId && o.StatusId != 1).Include(o => o.Eater)
                        .Include(o => o.Status)
                        .Include(o => o.Merchant)
                        .Include(o => o.Shipper)
                        .Include(o => o.PaymentMethod)
                        .Include(o => o.OrderDetails)
                        .OrderByDescending(o => o.OrderedDate)
                        .ToListAsync();
        }

        public async Task<IEnumerable<Order>> FindByMerchant(int merchantId)
        {
            return await _context.Order.Where(o => o.MerchantId == merchantId && o.StatusId != 1).Include(o => o.Eater)
                        .Include(o => o.Status)
                        .Include(o => o.Merchant)
                        .Include(o => o.Shipper)
                        .Include(o => o.PaymentMethod)
                        .Include(o => o.OrderDetails)
                        .OrderByDescending(o => o.OrderedDate)
                        .ToListAsync();
        }

        public async Task<Order> FindByMerchantAndEater(int merchantId, int eaterId)
        {// Possible null reference return.
#pragma warning disable CS8603 // Possible null reference return.
            return await _context.Order
                        .Where(o => o.StatusId == 1 && o.MerchantId == merchantId && o.EaterId == eaterId)
                        .Include(o => o.Eater)
                        .Include(o => o.Status)
                        .Include(o => o.Merchant)
                        .Include(o => o.Shipper)
                        .Include(o => o.PaymentMethod)
                        .Include(o => o.OrderDetails)
                        .FirstOrDefaultAsync();
#pragma warning restore CS8603 // Possible null reference return.
        }

        public async Task<IEnumerable<Order>> FindByShipper(int shipperId)
        {
            return await _context.Order.Where(o => o.ShipperId == shipperId && o.StatusId != 1)
                        .Include(o => o.Eater)
                        .Include(o => o.Status)
                        .Include(o => o.Merchant)
                        .Include(o => o.Shipper)
                        .Include(o => o.PaymentMethod)
                        .Include(o => o.OrderDetails)
                        .OrderByDescending(o => o.OrderedDate)
                        .ToListAsync();
        }

        public async Task<IEnumerable<Order>> GetAll()
        {
            return await _context.Order.ToListAsync();
        }

        public async Task<IEnumerable<Order>> GetAllWaitingToPickedUp()
        {
            return await _context.Order.Where(o => o.StatusId == 2).Include(o => o.Eater)
                        .Include(o => o.Status)
                        .Include(o => o.Merchant)
                        .Include(o => o.Shipper)
                        .Include(o => o.PaymentMethod)
                        .Include(o => o.OrderDetails).ToListAsync();
        }

        public async Task<Order> GetById(int id)
        {
            return await _context.Order
                        .Include(o => o.Eater)
                        .Include(o => o.Status)
                        .Include(o => o.Merchant)
                        .Include(o => o.Shipper)
                        .Include(o => o.PaymentMethod)
                        .Include(o => o.OrderDetails)
                        .FirstOrDefaultAsync(o => o.Id == id);
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