using Microsoft.EntityFrameworkCore;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Repositories
{
    public class ShipperRepository : IShipperRepository
    {
        private readonly MyAppContext _context;
        public ShipperRepository(MyAppContext context)
        {
            this._context = context;
        }
        public async Task<Shipper> Delete(int Id)
        {
            var shipper = await _context.Shipper.FindAsync(Id);
            _context.Shipper.Remove(shipper);
            await Save();
            return shipper;
        }

        public async Task<IEnumerable<Shipper>> FindContainRegex(string regex)
        {
            return await _context.Shipper
                                .FromSqlRaw("SELECT * FROM Shipper WHERE DisplayName REGEXP {0}", regex)
                                .Select(e => new Shipper
                                {
                                    Id = e.Id,
                                    DisplayName = e.DisplayName,
                                    Avatar = e.Avatar,
                                    Phone = e.Phone,
                                    Email = e.Email,
                                    VehicleName = e.VehicleName,
                                    MomoPayment = e.MomoPayment,
                                    Coordinator = e.Coordinator,
                                    AccountId = e.AccountId,
                                    Status = e.Status,
                                    Account = new Account
                                    {
                                        Id = e.Account.Id,
                                        Email = e.Account.Email,
                                        CreatedDate = e.Account.CreatedDate
                                    },
                                    VehicleType = new VehicleType
                                    {
                                        Id = e.VehicleType.Id,
                                        TypeName = e.VehicleType.TypeName,
                                        Icon = e.VehicleType.Icon
                                    }
                                })
                                .ToListAsync();
        }

        public async Task<IEnumerable<Shipper>> GetAll()
        {
            return await _context.Shipper.ToListAsync();
        }
        public async Task<Shipper> GetById(int id)
        {
            return await _context.Shipper.FindAsync(id);
        }
        public async Task<Shipper> Insert(Shipper entity)
        {
            var newShipper = await _context.Shipper.AddAsync(entity);
            await Save();
            return newShipper.Entity;
        }
        public async Task Save()
        {
            await _context.SaveChangesAsync();
        }
        public async Task<Shipper> Update(Shipper entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await Save();
            return _context.Entry(entity).Entity;
        }
    }
}