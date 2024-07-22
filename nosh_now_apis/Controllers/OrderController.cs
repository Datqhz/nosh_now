using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Dtos.Response;
using MyApp.Extensions;
using MyApp.Models;
using MyApp.Repositories;
using MyApp.Repositories.Interface;
using MyApp.Utils;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/order")]
    public class OrderController : ControllerBase
    {
        private readonly IOrderRepository orderRepository;
        private readonly IEaterRepository eaterRepository;
        private readonly IMerchantRepository merchantRepository;
        private readonly IShipperRepository shipperRepository;
        public OrderController(IOrderRepository orderRepository, IEaterRepository eaterRepository, IMerchantRepository merchantRepository, IShipperRepository shipperRepository)
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
            Console.WriteLine(data.toString());
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
            if (eater == null)
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
                StatusId = 0
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = orderCreated.Id }, orderCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrder(UpdateOrder updateOrder)
        {
            var order = await orderRepository.GetById(updateOrder.id);
            if (order == null)
            {
                return NotFound(new
                {
                    error = "Order doesn't exits!"
                });
            }
            order.OrderedDate = DateTime.Now;
            order.ShipmentFee = updateOrder.shipmentFee;
            order.Coordinator = updateOrder.coordinator;
            order.Phone = updateOrder.phone;
            order.StatusId = updateOrder.statusId;
            order.EaterId = order.Eater.Id;
            order.MerchantId = order.Merchant.Id;
            if (updateOrder.shipperId != 0)
            {
                order.ShipperId = updateOrder.shipperId;
            }
            else
            {
                order.ShipperId = null;
            }
            order.MethodId = updateOrder.methodId;
            Console.WriteLine(order.toString());
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var orderUpdated = await orderRepository.Update(order);
                scope.Complete();
                return Ok(orderUpdated.AsDto());
            }
        }
        [HttpGet("eater/{id}")]
        public async Task<IActionResult> GetByEater(int id)
        {
            var data = await orderRepository.FindByEater(id);
            return Ok(data.Select(order => order.AsDto()).ToList());
        }
        [HttpGet("merchant/{id}")]
        public async Task<IActionResult> GetByMerchant(int id)
        {
            var data = await orderRepository.FindByMerchant(id);
            return Ok(data.Select(order => order.AsDto()).ToList());
        }
        [HttpGet("merchant-eater")]
        public async Task<IActionResult> GetByMerchantAndEater([FromQuery] int merchantId, [FromQuery] int eaterId)
        {
            var data = await orderRepository.FindByMerchantAndEater(merchantId, eaterId);
            if (data == null)
            {
                await orderRepository.Insert(new Order
                {
                    MerchantId = merchantId,
                    EaterId = eaterId,
                    ShipmentFee = 0,
                    StatusId = 1,
                    OrderedDate = DateTime.Now
                });
                data = await orderRepository.FindByMerchantAndEater(merchantId, eaterId);
            }

            return Ok(data.AsDto());
        }
        [HttpGet("shipper/{id}")]
        public async Task<IActionResult> GetByShipper(int id)
        {
            var data = await orderRepository.FindByShipper(id);
            return Ok(data.Select(order => order.AsDto()).ToList());
        }
        [HttpGet("near-by")]
        public async Task<IActionResult> GetOrderNearBy([FromQuery] string coordinator)
        {
            List<OrderAndDistanceResponseDto> orders = new List<OrderAndDistanceResponseDto>();
            var data = await orderRepository.GetAllInitialize();
            foreach (var orderItem in data)
            {
                double distance = DistanceUtil.CalculateDistance(coordinator, orderItem.Coordinator);
                if (distance < 3)
                {
                    orders.Add(new OrderAndDistanceResponseDto(orderItem.AsDto(), distance));
                }
            }
            SortUtil.SortOrderByDistance(orders, 0, orders.Count - 1);
            return Ok(orders);
        }
    }
}