

using MyApp.Models;

namespace MyApp.Dtos.Response
{
    public record AccountResponseDto(int id, string email, RoleResponseDto role);
    public record RoleResponseDto(int id, string roleName);
    public record ManagerResponseDto(int id, string displayName, byte[] avatar, string phone, string email, AccountResponseDto account);
    public record EaterResponseDto(int id, string displayName, byte[] avatar, string phone, string email, AccountResponseDto account);
    public record CategoryResponseDto(int id, string categoryName, byte[] categoryImage);
    public record VehicleTypeResponseDto(int id, string typeName, byte[] icon);
    public record OrderStatusResponseDto(int id, string orderStatusName, int step);
    public record PaymentMethodResponseDto(int id, string methodName, byte[]methodImage);
    public record MerchantResponseDto(int id, string displayName, byte[] avatar, string phone, 
    string email, string openingTime, string closingTime, string coordinator, 
    bool stauts, AccountResponseDto account, CategoryResponseDto category);
    public record ShipperResponseDto(int id, string displayName, byte[] avatar, string phone, 
    string email, string openingTime, string closingTime, string coordinator, 
    bool stauts, AccountResponseDto account, VehicleTypeResponseDto vehicleType);
    public record LocationResponseDto(int id, string locationName, string coordinator, bool defaultLocation, EaterResponseDto eater);
    public record FoodResponseDto(int id, string foodName, byte[] foodImage, string foodDescribe, 
    double price, int status, MerchantResponseDto merchant);
    public record OrderResponseDto(int id, DateTime orderedDate, double shipmentFee,
    OrderStatusResponseDto status, MerchantResponseDto merchant,
    EaterResponseDto eater, ShipperResponseDto shipper, PaymentMethodResponseDto paymentMethod);
    public record OrderDetailResponseDto(int id, int orderId, FoodResponseDto food, double price, int quantity);
}