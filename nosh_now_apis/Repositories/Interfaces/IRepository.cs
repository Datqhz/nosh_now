

using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IRepository<T> where T : IModel
    {
        Task<IEnumerable<T>> GetAll();
        Task<T> GetById(int id);
        Task<T> Insert(T entity);
        Task<T> Update(T entity);
        Task<T> Delete(int id);
        Task Save();
    }
}