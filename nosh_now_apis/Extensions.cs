using MyApp.Controllers;
using MyApp.Dtos.Response;
using MyApp.Models;

namespace MyApp.Extensions
{
    public static class Extension
    {
        public static RoleResponseDto AsDto(this Role role)
        {
            return new RoleResponseDto
            (
                role.Id,
                role.RoleName
            );
        }
        public static AccountResponseDto AsDto(this Account account)
        {
            return new AccountResponseDto
            (
                account.Id,
                account.Email,
                account.Role?.AsDto()
            );
        }
        public static CategoryResponseDto AsDto(this Category category)
        {
            return new CategoryResponseDto
            (
                category.Id,
                category.CategoryName,
                category.CategoryImage
            );
        }
        public static VehicleTypeResponseDto AsDto(this VehicleType type)
        {
            return new VehicleTypeResponseDto
            (
                type.Id,
                type.TypeName,
                type.Icon
            );
        }
        public static OrderStatusResponseDto AsDto(this OrderStatus status)
        {
            return new OrderStatusResponseDto
            (
                status.Id,
                status.StatusName,
                status.Step
            );
        }
        public static PaymentMethodResponseDto AsDto(this PaymentMethod method)
        {
            return new PaymentMethodResponseDto
            (
                method.Id,
                method.MethodName,
                method.MethodImage
            );
        }
        public static ManagerResponseDto AsDto(this Manager manager)
        {
            return new ManagerResponseDto
            (
                manager.Id,
                manager.DisplayName,
                manager.Avatar,
                manager.Phone,
                manager.Email,
                manager.Account?.AsDto()
            );
        }
        public static EaterResponseDto AsDto(this Eater eater)
        {
            return new EaterResponseDto
            (
                eater.Id,
                eater.DisplayName,
                eater.Avatar,
                eater.Phone,
                eater.Email,
                eater.Account?.AsDto()
            );
        }
        public static MerchantResponseDto AsDto(this Merchant merchant)
        {
            return new MerchantResponseDto
            (
                merchant.Id,
                merchant.DisplayName,
                merchant.Avatar,
                merchant.Phone,
                merchant.Email,
                merchant.OpeningTime,
                merchant.ClosingTime,
                merchant.Coordinator,
                merchant.Status,
                merchant.Account?.AsDto(),
                merchant.Category?.AsDto()
            );
        }
        public static ShipperResponseDto AsDto(this Shipper shipper)
        {
            return new ShipperResponseDto
            (
                shipper.Id,
                shipper.DisplayName,
                shipper.Avatar,
                shipper.Phone,
                shipper.Email,
                shipper.VehicleName,
                shipper.MomoPayment,
                shipper.Coordinator,
                shipper.Status,
                shipper.Account?.AsDto(),
                shipper.VehicleType?.AsDto()
            );
        }
        public static LocationResponseDto AsDto(this Location location)
        {
            return new LocationResponseDto
            (
                location.Id,
                location.LocationName,
                location.Coordinator,
                location.Default,
                location.Eater?.AsDto()
            );
        }
        public static OrderResponseDto AsDto(this Order order)
        {
            return new OrderResponseDto
            (
                order.Id,
                order.OrderedDate,
                order.ShipmentFee,
                order.Status?.AsDto(),
                order.Merchant?.AsDto(),
                order.Eater?.AsDto(),
                order.Shipper?.AsDto(),
                order.PaymentMethod?.AsDto()
            );
        }
        public static FoodResponseDto AsDto(this Food food)
        {
            return new FoodResponseDto
            (
                food.Id,
                food.FoodName,
                food.FoodImage,
                food.FoodDescribe,
                food.Price,
                food.Status,
                food.Merchant?.AsDto()
            );
        }
        public static OrderDetailResponseDto AsDto(this OrderDetail orderDetail)
        {
            return new OrderDetailResponseDto
            (
                orderDetail.Id,
                orderDetail.OrderId,
                orderDetail.Food?.AsDto(),
                orderDetail.Price,
                orderDetail.Quantity,
            );
        }
    }
}