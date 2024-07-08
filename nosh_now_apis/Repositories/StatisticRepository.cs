using System.Linq;
using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Dtos.Response;
using MyApp.Models;

namespace MyApp.Repositories
{
    public class StatisticRepository : IStatisticRepository
    {
        private readonly MyAppContext _context;
        public StatisticRepository(MyAppContext context)
        {
            this._context = context;
        }

        public async Task<double> CalcTotalEarningOfShipperByDate(int shipperId, DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.Order.Where(order => order.StatusId == 4 && order.ShipperId == shipperId);

            if (year.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.OrderedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Date == date.Value.Date);
            }
            double total = 0;
            var orders = await query.ToListAsync();
            foreach (var order in orders)
            {
                total += order.ShipmentFee;
            }
            return total;
        }

        public async Task<double> CalcTotalRevenueOfMerchantByDate(int merchantId, DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.Order.Where(order => order.StatusId == 4 && order.MerchantId == merchantId);

            if (year.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.OrderedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Date == date.Value.Date);
            }
            double total = 0;
            var orders = await query.Include(order => order.OrderDetails).ToListAsync();
            foreach (var order in orders)
            {
                total += order.CalcTotal() - order.ShipmentFee;
            }
            return total;
        }

        public async Task<double> CalcTotalTransactionAmountByDate(DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.Order.Where(order => order.StatusId == 4);

            if (year.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.OrderedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Date == date.Value.Date);
            }
            double total = 0;
            var orders = await query.Include(order => order.OrderDetails).ToListAsync();
            foreach (var order in orders)
            {
                total += order.CalcTotal();
            }
            return total;
        }

        public async Task<int> CountAccountByRoleAndDate(int roleId, DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.Account.Where(f => f.RoleId == roleId);

            if (year.HasValue)
            {
                query = query.Where(f => f.CreatedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.CreatedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.CreatedDate.Date == date.Value.Date);
            }

            return await query.CountAsync();
        }

        public async Task<int> CountOrderByDate(DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.Order.Where(order => order.StatusId == 4);

            if (year.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.OrderedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Date == date.Value.Date);
            }

            return await query.CountAsync();
        }

        public async Task<int> CountOrderOfUserByRoleAndDate(int roleId, int userId, DateTime? date = null, int? year = null, int? month = null)
        {
            IQueryable<Order> query;
            if(roleId == 3){
                query = _context.Order.Where(order => order.StatusId == 4 && order.MerchantId == userId);
            }else {
                query = _context.Order.Where(order => order.StatusId == 4 && order.ShipperId == userId);
            }
            if (year.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Year == year.Value);
                if (month.HasValue)
                {
                    query = query.Where(f => f.OrderedDate.Month == month.Value);
                }
            }
            else if (date.HasValue)
            {
                query = query.Where(f => f.OrderedDate.Date == date.Value.Date);
            }

            return await query.CountAsync();
        }

        public async Task<IEnumerable<FoodRevenueDto>> Top5Food(int merchantId, DateTime? date = null, int? year = null, int? month = null)
        {
            var query = _context.OrderDetail
                        .Include(od => od.Food)
                        .Include(od => od.Order)
                        .AsQueryable();

            if (date.HasValue)
            {
                query = query.Where(od => od.Order.OrderedDate.Date == date.Value.Date);
            }
            else if (month.HasValue && year.HasValue)
            {
                query = query.Where(od => od.Order.OrderedDate.Month == month.Value && od.Order.OrderedDate.Year == year.Value);
            }
            else if (year.HasValue)
            {
                query = query.Where(od => od.Order.OrderedDate.Year == year.Value);
            }

            var topFoods = await query
                                .Where(od => od.Food.MerchantId == merchantId) 
                                .GroupBy(od => new { od.Food.Id, od.Food.FoodName })
                                .Select(g => new FoodRevenueDto
                                (
                                    g.Key.Id,
                                    g.Key.FoodName,
                                    g.Sum(od => od.Price * od.Quantity)
                                ))
                                .OrderByDescending(fr => fr.revenue)
                                .Take(5)
                                .ToListAsync();

            return topFoods;
        }
    }
}