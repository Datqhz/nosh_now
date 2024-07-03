using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class OrderDetailRepository : IOrderDetailRepository
    {
        private readonly MyAppContext _context;
        public OrderDetailRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<OrderDetail> Delete(int Id)
        {
            var orderDetail = await _context.OrderDetail.FindAsync(Id);
            _context.OrderDetail.Remove(orderDetail);
            await Save();
            return orderDetail;
        }

        public async Task<IEnumerable<OrderDetail>> FindByOrder(int orderId)
        {
            return await _context.OrderDetail.Where(o => o.OrderId == orderId).Include(o => o.Food).ToListAsync();
        }

        public async Task<IEnumerable<OrderDetail>> GetAll()
        {
            return await _context.OrderDetail.ToListAsync();
        }
        public async Task<OrderDetail> GetById(int id)
        {
            return await _context.OrderDetail.FindAsync(id);
        }
        public async Task<OrderDetail> Insert(OrderDetail entity)
        {
            var newOrderDetail = await _context.OrderDetail.AddAsync(entity);
            await Save();
            return newOrderDetail.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<OrderDetail> Update(OrderDetail entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}