using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IAccountRepository : IRepository<Account>
    {
        Task<Account> FindByEmail(string email);
        Task<int> CountAccountByRoleAndDate(int roleId, DateTime? date = null, int? year = null, int? month = null);
    }
}