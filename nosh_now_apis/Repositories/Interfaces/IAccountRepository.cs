using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IAccountRepository : IRepository<Account>
    {
        Task<Account> FindByEmail(string email);
    }
}