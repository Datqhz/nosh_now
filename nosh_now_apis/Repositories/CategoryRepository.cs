using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repository
{
    public class CategoryRepository : ICategoryRepository
    {
        private readonly MyAppContext _context;
        public CategoryRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Category> Delete(int Id)
        {
            var category = await _context.Category.FindAsync(Id);
            _context.Category.Remove(category);
            await Save();
            return category;
        }

        public async Task<IEnumerable<Category>> FindByName(string name)
        {
            return await _context.Category.Where(c => c.CategoryName == name).ToListAsync();
        }

        public async Task<IEnumerable<Category>> GetAll()
        {
            return await _context.Category.ToListAsync();
        }
        public async Task<Category> GetById(int id)
        {
            return await _context.Category.FindAsync(id);
        }
        public async Task<Category> Insert(Category entity)
        {
            var newCategory = await _context.Category.AddAsync(entity);
            await Save();
            return newCategory.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Category> Update(Category entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}