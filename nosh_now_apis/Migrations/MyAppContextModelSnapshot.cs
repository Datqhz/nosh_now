﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using MyApp.DbContexts;

#nullable disable

namespace nosh_now_apis.Migrations
{
    [DbContext(typeof(MyAppContext))]
    partial class MyAppContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.16")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            modelBuilder.Entity("MyApp.Models.Account", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<DateTime>("CreatedDate")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("datetime(6)")
                        .HasDefaultValueSql("CURRENT_TIMESTAMP(6)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("RoleId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("RoleId");

                    b.ToTable("Account");
                });

            modelBuilder.Entity("MyApp.Models.Category", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<byte[]>("CategoryImage")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("CategoryName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Category");
                });

            modelBuilder.Entity("MyApp.Models.Eater", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("AccountId")
                        .HasColumnType("int");

                    b.Property<byte[]>("Avatar")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("DisplayName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.HasIndex("AccountId")
                        .IsUnique();

                    b.ToTable("Eater");
                });

            modelBuilder.Entity("MyApp.Models.Food", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("FoodDescribe")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<byte[]>("FoodImage")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("FoodName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("MerchantId")
                        .HasColumnType("int");

                    b.Property<double>("Price")
                        .HasColumnType("double");

                    b.Property<int>("Status")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasDefaultValue(1);

                    b.HasKey("Id");

                    b.HasIndex("MerchantId");

                    b.ToTable("Food");
                });

            modelBuilder.Entity("MyApp.Models.Location", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("Coordinator")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<bool>("Default")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("tinyint(1)")
                        .HasDefaultValue(false);

                    b.Property<int>("EaterId")
                        .HasColumnType("int");

                    b.Property<string>("LocationName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.HasIndex("EaterId");

                    b.ToTable("Location");
                });

            modelBuilder.Entity("MyApp.Models.Manager", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("AccountId")
                        .HasColumnType("int");

                    b.Property<byte[]>("Avatar")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("DisplayName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.HasIndex("AccountId")
                        .IsUnique();

                    b.ToTable("Manager");
                });

            modelBuilder.Entity("MyApp.Models.Merchant", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("AccountId")
                        .HasColumnType("int");

                    b.Property<byte[]>("Avatar")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<int>("CategoryId")
                        .HasColumnType("int");

                    b.Property<string>("ClosingTime")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Coordinator")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("DisplayName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("OpeningTime")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<bool>("Status")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("tinyint(1)")
                        .HasDefaultValue(true);

                    b.HasKey("Id");

                    b.HasIndex("AccountId")
                        .IsUnique();

                    b.HasIndex("CategoryId");

                    b.ToTable("Merchant");
                });

            modelBuilder.Entity("MyApp.Models.Order", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("Coordinator")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("EaterId")
                        .HasColumnType("int");

                    b.Property<int>("MerchantId")
                        .HasColumnType("int");

                    b.Property<int>("MethodId")
                        .HasColumnType("int");

                    b.Property<DateTime>("OrderedDate")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("datetime(6)")
                        .HasDefaultValueSql("CURRENT_TIMESTAMP(6)");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<double>("ShipmentFee")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("double")
                        .HasDefaultValue(0.0);

                    b.Property<int>("ShipperId")
                        .HasColumnType("int");

                    b.Property<int>("StatusId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("EaterId");

                    b.HasIndex("MerchantId");

                    b.HasIndex("MethodId");

                    b.HasIndex("ShipperId");

                    b.ToTable("Order");
                });

            modelBuilder.Entity("MyApp.Models.OrderDetail", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("FoodId")
                        .HasColumnType("int");

                    b.Property<int>("OrderId")
                        .HasColumnType("int");

                    b.Property<double>("Price")
                        .HasColumnType("double");

                    b.Property<int>("Quantity")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("FoodId");

                    b.HasIndex("OrderId");

                    b.ToTable("OrderDetail");
                });

            modelBuilder.Entity("MyApp.Models.OrderStatus", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("StatusName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("Step")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.ToTable("OrderStatus");
                });

            modelBuilder.Entity("MyApp.Models.PaymentMethod", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<byte[]>("MethodImage")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("MethodName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("PaymentMethod");
                });

            modelBuilder.Entity("MyApp.Models.Role", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("RoleName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Role");
                });

            modelBuilder.Entity("MyApp.Models.Shipper", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("AccountId")
                        .HasColumnType("int");

                    b.Property<byte[]>("Avatar")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("Coordinator")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("DisplayName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("MomoPayment")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<bool>("Status")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("tinyint(1)")
                        .HasDefaultValue(true);

                    b.Property<string>("VehicleName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("VehicleTypeId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("AccountId")
                        .IsUnique();

                    b.HasIndex("VehicleTypeId");

                    b.ToTable("Shipper");
                });

            modelBuilder.Entity("MyApp.Models.VehicleType", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<byte[]>("Icon")
                        .IsRequired()
                        .HasColumnType("longblob");

                    b.Property<string>("TypeName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("VehicleType");
                });

            modelBuilder.Entity("MyApp.Models.Account", b =>
                {
                    b.HasOne("MyApp.Models.Role", "Role")
                        .WithMany("Accounts")
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Role");
                });

            modelBuilder.Entity("MyApp.Models.Eater", b =>
                {
                    b.HasOne("MyApp.Models.Account", "Account")
                        .WithOne("Eater")
                        .HasForeignKey("MyApp.Models.Eater", "AccountId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Account");
                });

            modelBuilder.Entity("MyApp.Models.Food", b =>
                {
                    b.HasOne("MyApp.Models.Merchant", "Merchant")
                        .WithMany("Foods")
                        .HasForeignKey("MerchantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Merchant");
                });

            modelBuilder.Entity("MyApp.Models.Location", b =>
                {
                    b.HasOne("MyApp.Models.Eater", "Eater")
                        .WithMany("Locations")
                        .HasForeignKey("EaterId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Eater");
                });

            modelBuilder.Entity("MyApp.Models.Manager", b =>
                {
                    b.HasOne("MyApp.Models.Account", "Account")
                        .WithOne("Manager")
                        .HasForeignKey("MyApp.Models.Manager", "AccountId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Account");
                });

            modelBuilder.Entity("MyApp.Models.Merchant", b =>
                {
                    b.HasOne("MyApp.Models.Account", "Account")
                        .WithOne("Merchant")
                        .HasForeignKey("MyApp.Models.Merchant", "AccountId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.Category", "Category")
                        .WithMany("Merchants")
                        .HasForeignKey("CategoryId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Account");

                    b.Navigation("Category");
                });

            modelBuilder.Entity("MyApp.Models.Order", b =>
                {
                    b.HasOne("MyApp.Models.Eater", "Eater")
                        .WithMany("Orders")
                        .HasForeignKey("EaterId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.OrderStatus", "Status")
                        .WithMany("Orders")
                        .HasForeignKey("EaterId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.Merchant", "Merchant")
                        .WithMany("Orders")
                        .HasForeignKey("MerchantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.PaymentMethod", "PaymentMethod")
                        .WithMany("Orders")
                        .HasForeignKey("MethodId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.Shipper", "Shipper")
                        .WithMany("Orders")
                        .HasForeignKey("ShipperId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Eater");

                    b.Navigation("Merchant");

                    b.Navigation("PaymentMethod");

                    b.Navigation("Shipper");

                    b.Navigation("Status");
                });

            modelBuilder.Entity("MyApp.Models.OrderDetail", b =>
                {
                    b.HasOne("MyApp.Models.Food", "Food")
                        .WithMany("OrderDetails")
                        .HasForeignKey("FoodId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.Order", "Order")
                        .WithMany("OrderDetails")
                        .HasForeignKey("OrderId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Food");

                    b.Navigation("Order");
                });

            modelBuilder.Entity("MyApp.Models.Shipper", b =>
                {
                    b.HasOne("MyApp.Models.Account", "Account")
                        .WithOne("Shipper")
                        .HasForeignKey("MyApp.Models.Shipper", "AccountId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MyApp.Models.VehicleType", "VehicleType")
                        .WithMany("Shippers")
                        .HasForeignKey("VehicleTypeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Account");

                    b.Navigation("VehicleType");
                });

            modelBuilder.Entity("MyApp.Models.Account", b =>
                {
                    b.Navigation("Eater")
                        .IsRequired();

                    b.Navigation("Manager")
                        .IsRequired();

                    b.Navigation("Merchant")
                        .IsRequired();

                    b.Navigation("Shipper")
                        .IsRequired();
                });

            modelBuilder.Entity("MyApp.Models.Category", b =>
                {
                    b.Navigation("Merchants");
                });

            modelBuilder.Entity("MyApp.Models.Eater", b =>
                {
                    b.Navigation("Locations");

                    b.Navigation("Orders");
                });

            modelBuilder.Entity("MyApp.Models.Food", b =>
                {
                    b.Navigation("OrderDetails");
                });

            modelBuilder.Entity("MyApp.Models.Merchant", b =>
                {
                    b.Navigation("Foods");

                    b.Navigation("Orders");
                });

            modelBuilder.Entity("MyApp.Models.Order", b =>
                {
                    b.Navigation("OrderDetails");
                });

            modelBuilder.Entity("MyApp.Models.OrderStatus", b =>
                {
                    b.Navigation("Orders");
                });

            modelBuilder.Entity("MyApp.Models.PaymentMethod", b =>
                {
                    b.Navigation("Orders");
                });

            modelBuilder.Entity("MyApp.Models.Role", b =>
                {
                    b.Navigation("Accounts");
                });

            modelBuilder.Entity("MyApp.Models.Shipper", b =>
                {
                    b.Navigation("Orders");
                });

            modelBuilder.Entity("MyApp.Models.VehicleType", b =>
                {
                    b.Navigation("Shippers");
                });
#pragma warning restore 612, 618
        }
    }
}
