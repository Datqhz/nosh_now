using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/category")]
    public class CategoryController : ControllerBase
    {

        private readonly ICategoryRepository categoryRepository;
        public CategoryController(ICategoryRepository categoryRepository)
        {
            this.categoryRepository = categoryRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await categoryRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await categoryRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Category has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }
        [HttpPost]
        public async Task<IActionResult> CreateCategory(CreateCategory createCategory)
        {
            var data = await categoryRepository.FindByName(createCategory.categoryName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Category name =  {createCategory.categoryName} was used."
                });
            }
            var categoryCreated = await categoryRepository.Insert(new Category
            {
                CategoryName = createCategory.categoryName,
                CategoryImage = Convert.FromBase64String(createCategory.image)
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = categoryCreated.Id }, categoryCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateCategory(UpdateCategory updateCategory)
        {
            var category = await categoryRepository.GetById(updateCategory.id);
            if (category == null)
            {
                return NotFound(new
                {
                    error = "Category doesn't exits!"
                });
            }
            // var data = await categoryRepository.FindByName(updateCategory.categoryName);
            // if (data.Any())
            // {
            //     return BadRequest(new
            //     {
            //         error = $"Category name =  {updateCategory.categoryName} was used."
            //     });
            // }
            if (!string.IsNullOrEmpty(updateCategory.image))
            {
                category.CategoryImage = Convert.FromBase64String(updateCategory.image);
            }
            category.CategoryName = updateCategory.categoryName;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var categoryUpdated = await categoryRepository.Update(category);
                scope.Complete();
                return Ok(categoryUpdated);
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await categoryRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Category has id = {id} doesn't exist."
                });
            }
            await categoryRepository.Delete(id);
            return Ok(data);
        }
    }
}