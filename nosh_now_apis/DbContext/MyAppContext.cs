using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using MyApp.Models;

namespace MyApp.DbContexts
{
    public class MyAppContext : DbContext
    {
        public DbSet<Role> Role { get; set; }
        public DbSet<Account> Account { get; set; }
        public DbSet<Manager> Manager { get; set; }
        public DbSet<Merchant> Merchant { get; set; }
        public DbSet<Eater> Eater { get; set; }
        public DbSet<Shipper> Shipper { get; set; }
        public DbSet<Category> Category { get; set; }
        public DbSet<OrderStatus> OrderStatus { get; set; }
        public DbSet<VehicleType> VehicleType { get; set; }
        public DbSet<PaymentMethod> PaymentMethod { get; set; }

        public DbSet<Food> Food { get; set; }
        public DbSet<Location> Location { get; set; }
        public DbSet<Order> Order { get; set; }
        public DbSet<OrderDetail> OrderDetail { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseMySQL($"server=db;port=3306;database=nosh_db;user=root;password=123456");
                // optionsBuilder.UseMySQL($"server=127.0.0.1;port=3306;database=nosh_db;user=root;password=123456");
                optionsBuilder.EnableSensitiveDataLogging(true);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Role>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.RoleName).IsRequired();
            });
            modelBuilder.Entity<Account>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.Email).IsRequired();
                entity.Property(e => e.Password).IsRequired();
                entity.Property(e => e.CreatedDate).HasDefaultValueSql("CURRENT_TIMESTAMP(6)");
                entity.HasOne(e => e.Role)
                    .WithMany(role => role.Accounts)
                    .HasForeignKey(e => e.RoleId);
            });
            modelBuilder.Entity<Manager>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.Phone).IsRequired();
                entity.Property(e => e.Email).IsRequired();
                entity.Property(e => e.DisplayName).IsRequired();
                entity.Property(e => e.Avatar).IsRequired();
                entity.Property(e => e.AccountId).IsRequired();
                entity.HasOne(e => e.Account)
                    .WithOne(account => account.Manager)
                    .HasForeignKey<Manager>(e => e.AccountId);
            });
            modelBuilder.Entity<Eater>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.Phone).IsRequired();
                entity.Property(e => e.Email).IsRequired();
                entity.Property(e => e.DisplayName).IsRequired();
                entity.Property(e => e.Avatar).IsRequired();
                entity.Property(e => e.AccountId).IsRequired();
                entity.HasOne(e => e.Account)
                    .WithOne(account => account.Eater)
                    .HasForeignKey<Eater>(e => e.AccountId);
            });
            modelBuilder.Entity<Merchant>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.Phone).IsRequired();
                entity.Property(e => e.Email).IsRequired();
                entity.Property(e => e.DisplayName).IsRequired();
                entity.Property(e => e.Avatar).IsRequired();
                entity.Property(e => e.Status).HasDefaultValue(true);
                entity.Property(e => e.AccountId).IsRequired();
                entity.Property(e => e.OpeningTime).IsRequired();
                entity.Property(e => e.ClosingTime).IsRequired();
                entity.Property(e => e.Coordinator).IsRequired();
                entity.Property(e => e.CategoryId).IsRequired();
                entity.HasOne(e => e.Account)
                    .WithOne(account => account.Merchant)
                    .HasForeignKey<Merchant>(e => e.AccountId);
                entity.HasOne(e => e.Category)
                    .WithMany(category => category.Merchants)
                    .HasForeignKey(e => e.CategoryId);
            });
            modelBuilder.Entity<Shipper>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.DisplayName).IsRequired();
                entity.Property(e => e.Avatar).IsRequired();
                entity.Property(e => e.Phone).IsRequired();
                entity.Property(e => e.Email).IsRequired();
                entity.Property(e => e.VehicleName).IsRequired();
                entity.Property(e => e.MomoPayment).IsRequired();
                entity.Property(e => e.Coordinator).IsRequired();
                entity.Property(e => e.Status).HasDefaultValue(true);
                entity.Property(e => e.AccountId).IsRequired();
                entity.Property(e => e.VehicleTypeId).IsRequired();
                entity.HasOne(e => e.Account)
                    .WithOne(account => account.Shipper)
                    .HasForeignKey<Shipper>(e => e.AccountId);
                entity.HasOne(e => e.VehicleType)
                    .WithMany(type => type.Shippers)
                    .HasForeignKey(e => e.VehicleTypeId);
            });
            modelBuilder.Entity<Category>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.CategoryName).IsRequired();
            });
            modelBuilder.Entity<OrderStatus>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.StatusName).IsRequired();
                entity.Property(e => e.Step).IsRequired();
            });
            modelBuilder.Entity<PaymentMethod>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.MethodName).IsRequired();
                entity.Property(e => e.MethodImage).IsRequired();
            });
            modelBuilder.Entity<VehicleType>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.TypeName).IsRequired();
                entity.Property(e => e.Icon).IsRequired();
            });
            modelBuilder.Entity<Food>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.FoodName).IsRequired();
                entity.Property(e => e.FoodImage).IsRequired();
                entity.Property(e => e.FoodDescribe).IsRequired();
                entity.Property(e => e.Price).IsRequired();
                entity.Property(e => e.Status).IsRequired();
                entity.Property(e => e.Status).HasDefaultValue(1); // is selling
                entity.Property(e => e.MerchantId).IsRequired();
                entity.HasOne(e => e.Merchant)
                    .WithMany(merchant => merchant.Foods)
                    .HasForeignKey(e => e.MerchantId);
            });
            modelBuilder.Entity<Location>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.LocationName).IsRequired();
                entity.Property(e => e.Phone).IsRequired();
                entity.Property(e => e.Coordinator).IsRequired();
                entity.Property(e => e.Default).HasDefaultValue(false);
                entity.Property(e => e.EaterId).IsRequired();
                entity.HasOne(e => e.Eater)
                    .WithMany(eater => eater.Locations)
                    .HasForeignKey(e => e.EaterId);
            });
            modelBuilder.Entity<Order>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.OrderedDate).IsRequired();
                entity.Property(e => e.OrderedDate).HasDefaultValueSql("CURRENT_TIMESTAMP(6)");
                entity.Property(e => e.ShipmentFee).IsRequired();
                entity.Property(e => e.ShipmentFee).HasDefaultValue(0);
                entity.Property(e => e.StatusId).IsRequired();
                entity.Property(e => e.MerchantId).IsRequired();
                entity.Property(e => e.EaterId).IsRequired();
                entity.HasOne(e => e.Eater)
                    .WithMany(eater => eater.Orders)
                    .HasForeignKey(e => e.EaterId);
                entity.HasOne(e => e.Status)
                    .WithMany(status => status.Orders)
                    .HasForeignKey(e => e.StatusId);
                entity.HasOne(e => e.Merchant)
                    .WithMany(merchant => merchant.Orders)
                    .HasForeignKey(e => e.MerchantId);
                entity.HasOne(e => e.Shipper)
                    .WithMany(shipper => shipper.Orders)
                    .HasForeignKey(e => e.ShipperId);
                entity.HasOne(e => e.PaymentMethod)
                    .WithMany(paymentMethod => paymentMethod.Orders)
                    .HasForeignKey(e => e.MethodId);
            });
            modelBuilder.Entity<OrderDetail>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.OrderId).IsRequired();
                entity.Property(e => e.FoodId).IsRequired();
                entity.Property(e => e.Quantity).IsRequired();
                entity.Property(e => e.Price).IsRequired();
                entity.HasOne(e => e.Food)
                    .WithMany(food => food.OrderDetails)
                    .HasForeignKey(e => e.FoodId);
                entity.HasOne(e => e.Order)
                    .WithMany(order => order.OrderDetails)
                    .HasForeignKey(e => e.OrderId);
            });
        }
    }
}