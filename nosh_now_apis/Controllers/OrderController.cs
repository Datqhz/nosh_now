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
    [Route("api/order")]
    public class OrderController :ControllerBase
    {
        private readonly IOrderRepository orderRepository;
        private readonly IEaterRepository eaterRepository;
        private readonly IMerchantRepository merchantRepository;
        private readonly IShipperRepository shipperRepository;
        public OrderController(IOrderRepository orderRepository, IEaterRepository eaterRepository,MerchantRepository merchantRepository, IShipperRepository shipperRepository)
        {
            this.orderRepository = orderRepository;
            this.eaterRepository = eaterRepository;
            this.merchantRepository = merchantRepository;
            this.shipperRepository = shipperRepository;
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
        public async Task<IActionResult> CreateOrder(CreateOrder createOrder)
        {
            var eater = await eaterRepository.GetById(createOrder.eaterId);
            if(eater == null)
            {
                return NotFound(new 
                {
                    error = $"Account has id = {createOrder.eaterId} doesn't exist."
                });
            }
            var orderCreated = await orderRepository.Insert(new Order
            {
                ShipmentFee = 0,
                MerchantId = createOrder.merchantId,
                EaterId = createOrder.eaterId,
                StatusId = 1
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = orderCreated.Id }, orderCreated.AsDto());
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