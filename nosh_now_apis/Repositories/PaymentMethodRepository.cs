using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class PaymentMethodRepository : IPaymentMethodRepository
    {
        private readonly MyAppContext _context;
        public PaymentMethodRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<PaymentMethod> Delete(int Id)
        {
            var paymentMethod = await _context.PaymentMethod.FindAsync(Id);
            _context.PaymentMethod.Remove(paymentMethod);
            await Save();
            return paymentMethod;
        }

        public async Task<IEnumerable<PaymentMethod>> FindByName(string name)
        {
            return await _context.PaymentMethod.Where(c => c.MethodName == name).ToListAsync();
        }

        public async Task<IEnumerable<PaymentMethod>> GetAll()
        {
            return await _context.PaymentMethod.ToListAsync();
        }
        public async Task<PaymentMethod> GetById(int id)
        {
            return await _context.PaymentMethod.FindAsync(id);
        }
        public async Task<PaymentMethod> Insert(PaymentMethod entity)
        {
            var newPaymentMethod = await _context.PaymentMethod.AddAsync(entity);
            await Save();
            return newPaymentMethod.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<PaymentMethod> Update(PaymentMethod entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}