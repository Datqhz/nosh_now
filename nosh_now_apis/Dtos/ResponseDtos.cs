

using System.Text.Json.Serialization;
using MyApp.Models;

namespace MyApp.Dtos.Response
{
    public record AccountResponseDto(int id, string email, DateTime createdDate, RoleResponseDto role);
    public record RoleResponseDto(int id, string roleName);
    public record ManagerResponseDto(int id, string displayName, byte[] avatar, string phone, string email, AccountResponseDto account);
    public record EaterResponseDto(int id, string displayName, byte[] avatar, string phone, string email, AccountResponseDto account);
    public record CategoryResponseDto(int id, string categoryName, byte[] categoryImage);
    public record VehicleTypeResponseDto(int id, string typeName, byte[] icon);
    public record OrderStatusResponseDto(int id, string orderStatusName, int step);
    public record PaymentMethodResponseDto(int id, string methodName, byte[] methodImage);
    public record MerchantResponseDto(int id, string displayName, byte[] avatar, string phone,
    string email, string openingTime, string closingTime, string coordinator,
    bool status, AccountResponseDto account, CategoryResponseDto category);
    public record MerchantAndDistanceResponseDto(MerchantResponseDto merchant, double distanceToMerchant) : IDistance
    {
        public double Distance => distanceToMerchant;
    }

    public record ShipperResponseDto(int id, string displayName, byte[] avatar, string phone,
    string email, string vehicleName, string momoPayment, string coordinator,
    bool status, AccountResponseDto account, VehicleTypeResponseDto vehicleType);
    public record LocationResponseDto(int id, string locationName, string phone, string coordinator, bool defaultLocation, EaterResponseDto eater);
    public record FoodResponseDto(int id, string foodName, byte[] foodImage, string foodDescribe,
    double price, int status, MerchantResponseDto merchant);
    public record OrderResponseDto(int id, DateTime orderedDate, double shipmentFee, double totalPay, string? coordinator, string? phone,
    OrderStatusResponseDto status, MerchantResponseDto merchant,
    EaterResponseDto eater, ShipperResponseDto? shipper, PaymentMethodResponseDto? paymentMethod);
    public record OrderDetailResponseDto(int id, int orderId, FoodResponseDto food, double price, int quantity);
    public record OrderAndDistanceResponseDto(OrderResponseDto Order, double distanceToMerchant) : IDistance
    {
        public double Distance => distanceToMerchant;
    };
    public record FoodRevenueDto(int foodId, string foodName, double revenue);
}