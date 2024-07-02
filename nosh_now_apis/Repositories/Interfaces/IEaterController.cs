using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IEaterRepository : IRepository<Eater>
    {
        Task<IEnumerable<Eater>> FindContainRegex(string regex);
    }
}