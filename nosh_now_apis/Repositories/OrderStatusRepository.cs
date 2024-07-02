using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class OrderStatusRepository : IOrderStatusRepository
    {
        private readonly MyAppContext _context;
        public OrderStatusRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<OrderStatus> Delete(int Id)
        {
            var orderStatus = await _context.OrderStatus.FindAsync(Id);
            _context.OrderStatus.Remove(orderStatus);
            await Save();
            return orderStatus;
        }

        public async Task<IEnumerable<OrderStatus>> FindByName(string name)
        {
            return await _context.OrderStatus.Where(c => c.StatusName == name).ToListAsync();
        }

        public async Task<IEnumerable<OrderStatus>> GetAll()
        {
            return await _context.OrderStatus.ToListAsync();
        }
        public async Task<OrderStatus> GetById(int id)
        {
            return await _context.OrderStatus.FindAsync(id);
        }
        public async Task<OrderStatus> Insert(OrderStatus entity)
        {
            var newOrderStatus = await _context.OrderStatus.AddAsync(entity);
            await Save();
            return newOrderStatus.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<OrderStatus> Update(OrderStatus entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}