using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IPaymentMethodRepository : IRepository<PaymentMethod>
    {
        Task<IEnumerable<PaymentMethod>> FindByName(string name);
    }
}