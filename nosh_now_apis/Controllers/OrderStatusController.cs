using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Extensions;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/order-status")]
    public class OrderStatusController : ControllerBase
    {

        private readonly IOrderStatusRepository orderStatusRepository;
        public OrderStatusController(IOrderStatusRepository orderStatusRepository)
        {
            this.orderStatusRepository = orderStatusRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await orderStatusRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await orderStatusRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"OrderStatus has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }
        [HttpPost]
        public async Task<IActionResult> CreateOrderStatus(CreateOrderStatus createOrderStatus)
        {
            var data = await orderStatusRepository.FindByName(createOrderStatus.statusName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Order status name =  {createOrderStatus.statusName} was used."
                });
            }
            var orderStatusCreated = await orderStatusRepository.Insert(new OrderStatus
            {
                StatusName = createOrderStatus.statusName,
                Step = createOrderStatus.step
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = orderStatusCreated.Id }, orderStatusCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderStatus(UpdateOrderStatus updateOrderStatus)
        {
            var orderStatus = await orderStatusRepository.GetById(updateOrderStatus.id);
            if(orderStatus == null){
                return NotFound(new
                {
                    error = "OrderStatus doesn't exits!"
                });
            }
            var data = await orderStatusRepository.FindByName(updateOrderStatus.statusName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"OrderStatus name =  {updateOrderStatus.statusName} was used."
                });
            }
            orderStatus.StatusName = updateOrderStatus.statusName;
            orderStatus.Step = updateOrderStatus.step;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var orderStatusUpdated = await orderStatusRepository.Update(orderStatus);
                scope.Complete();
                return Ok(orderStatusUpdated);
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await orderStatusRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"OrderStatus has id = {id} doesn't exist."
                });
            }
            await orderStatusRepository.Delete(id);
            return Ok(data);
        }

        [HttpGet("order-process")]
        public async Task<IActionResult> GetAllWithoutInitAndCancelStatus()
        {
            var data = await orderStatusRepository.GetAllStatusWithoutInitAndCancelStatus();
            return Ok(data.Select(s => s.AsDto()).ToList());
        }
    }
}