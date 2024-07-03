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
    public class OrderDetailController :ControllerBase
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
        public async Task<IActionResult> CreateOrder(CreateOrderDetail createOrder)
        {
            var order = await orderRepository.GetById(createOrder.orderId);
            if(order == null)
            {
                return NotFound(new 
                {
                    error = $"Order has id = {createOrder.orderId} doesn't exist."
                });
            }
            var food = await foodRepository.GetById(createOrder.foodId);
            if(food == null)
            {
                return NotFound(new 
                {
                    error = $"Food has id = {createOrder.foodId} doesn't exist."
                });
            }
            var orderDetailCreated = await orderDetailRepository.Insert(new OrderDetail
            {
                FoodId = createOrder.foodId,
                OrderId = createOrder.orderId,
                Price = createOrder.price,
                Quantity = createOrder.quantity
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = orderDetailCreated.Id }, orderDetailCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrder(UpdateOrder updateOrder)
        {
            var order = await orderRepository.GetById(updateOrder.id);
            if(order == null){
                return NotFound(new
                {
                    error = "Order doesn't exits!"
                });
            }
            order.OrderedDate = DateTime.Now;
            order.ShipmentFee = updateOrder.ShipmentFee;
            order.StatusId = updateOrder.statusId;
            if(updateOrder.shipperId != 0)
            {
                order.ShipperId = updateOrder.shipperId;
            }
            order.MethodId = updateOrder.methodId;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var orderUpdated = await orderRepository.Update(order);
                scope.Complete();
                return Ok(orderUpdated.AsDto());
            }
        }
        
    }
}