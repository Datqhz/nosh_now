using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Extensions;
using MyApp.Models;
using MyApp.Repositories;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/order-detail")]
    public class OrderDetailController : ControllerBase
    {
        private readonly IOrderRepository orderRepository;
        private readonly IFoodRepository foodRepository;
        private readonly IOrderDetailRepository orderDetailRepository;
        public OrderDetailController(IOrderRepository orderRepository, IFoodRepository foodRepository,
         IOrderDetailRepository orderDetailRepository)
        {
            this.orderRepository = orderRepository;
            this.foodRepository = foodRepository;
            this.orderDetailRepository = orderDetailRepository;
        }
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await orderRepository.GetAll();
            return Ok(data.Select(order => order.AsDto()).ToList());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await orderRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Order has id = {id} doesn't exist."
                });
            }
            return Ok(data.AsDto());
        }

        [HttpPost]
        public async Task<IActionResult> CreateOrderDetail(CreateOrderDetail createOrderDetail)
        {
            var order = await orderRepository.GetById(createOrderDetail.orderId);
            if (order == null)
            {
                return NotFound(new
                {
                    error = $"Order has id = {createOrderDetail.orderId} doesn't exist."
                });
            }
            var food = await foodRepository.GetById(createOrderDetail.foodId);
            if (food == null)
            {
                return NotFound(new
                {
                    error = $"Food has id = {createOrderDetail.foodId} doesn't exist."
                });
            }
            var orderDetailCreated = await orderDetailRepository.Insert(new OrderDetail
            {
                FoodId = createOrderDetail.foodId,
                OrderId = createOrderDetail.orderId,
                Price = createOrderDetail.price,
                Quantity = createOrderDetail.quantity
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = orderDetailCreated.Id }, orderDetailCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderDetail(UpdateOrderDetail updateOrderDetail)
        {
            var orderDetail = await orderDetailRepository.GetById(updateOrderDetail.id);
            if (orderDetail == null)
            {
                return NotFound(new
                {
                    error = "Order doesn't exits!"
                });
            }
            if (updateOrderDetail.quantity > 0)
            {
                orderDetail.Quantity = updateOrderDetail.quantity;
                orderDetail.Price = updateOrderDetail.price;
                using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    var orderUpdated = await orderDetailRepository.Update(orderDetail);
                    scope.Complete();
                    return Ok(orderUpdated.AsDto());
                }
            }
            var orderDetailDeleted = await orderDetailRepository.Delete(orderDetail.Id);
            return Ok(orderDetailDeleted);
        }

        [HttpPut("multiple")]
        public async Task<IActionResult> UpdateMultipleOrderDetail(List<UpdateOrderDetail> updateOrderDetails)
        {
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                foreach (var item in updateOrderDetails)
                {
                    if (item.quantity == 0)
                    {
                        await orderDetailRepository.Delete(item.id);
                    }
                    else
                    {
                        var detail = await orderDetailRepository.GetById(item.id);
                        detail.Quantity = item.quantity;
                        await orderDetailRepository.Update(detail);
                    }
                }
                scope.Complete();
                return Ok("Update successful!");
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await orderDetailRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"order detail has id = {id} doesn't exist."
                });
            }
            await orderDetailRepository.Delete(id);
            return Ok(data);
        }
        [HttpGet("order/{id}")]
        public async Task<IActionResult> GetByOrderId(int id)
        {
            var data = await orderDetailRepository.FindByOrder(id);
            var order = await orderRepository.GetById(id);
            if (order.Status.Id == 1)
            {
                using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    foreach (var orderDetail in data)
                    {
                        orderDetail.Price = orderDetail.Food.Price;
                        await orderDetailRepository.Update(orderDetail);
                    }
                    scope.Complete();
                }

            }
            return Ok(data.Select(orderDetail => orderDetail.AsDto()).ToList());
        }
    }
}