using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/paymentMethod")]
    public class PaymentMethodController : ControllerBase
    {

        private readonly IPaymentMethodRepository paymentMethodRepository;
        public PaymentMethodController(IPaymentMethodRepository paymentMethodRepository)
        {
            this.paymentMethodRepository = paymentMethodRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await paymentMethodRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await paymentMethodRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Payment method has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }
        [HttpPost]
        public async Task<IActionResult> CreatePaymentMethod(CreatePaymentMethod createPaymentMethod)
        {
            var data = await paymentMethodRepository.FindByName(createPaymentMethod.methodName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Payment method name =  {createPaymentMethod.methodName} was used."
                });
            }
            var paymentMethodCreated = await paymentMethodRepository.Insert(new PaymentMethod
            {
                MethodName = createPaymentMethod.methodName,
                MethodImage = Convert.FromBase64String(createPaymentMethod.image)
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = paymentMethodCreated.Id }, paymentMethodCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdatePaymentMethod(UpdatePaymentMethod updatePaymentMethod)
        {
            var paymentMethod = await paymentMethodRepository.GetById(updatePaymentMethod.id);
            if(paymentMethod == null){
                return NotFound(new
                {
                    error = "Payment method doesn't exits!"
                });
            }
            var data = await paymentMethodRepository.FindByName(updatePaymentMethod.methodName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Payment method name =  {updatePaymentMethod.methodName} was used."
                });
            }
            if(!string.IsNullOrEmpty(updatePaymentMethod.image))
            {
                paymentMethod.MethodImage = Convert.FromBase64String(updatePaymentMethod.image);
            }
            paymentMethod.MethodName = updatePaymentMethod.methodName;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var paymentMethodUpdated = await paymentMethodRepository.Update(paymentMethod);
                scope.Complete();
                return Ok(paymentMethodUpdated);
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await paymentMethodRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Payment method has id = {id} doesn't exist."
                });
            }
            await paymentMethodRepository.Delete(id);
            return Ok(data);
        }
    }
}