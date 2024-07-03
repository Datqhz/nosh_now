

using MyApp.Models;

namespace MyApp.Dtos.Response
{
    public record AccountResponseDto(int id, string email, RoleResponseDto role);
    public record RoleResponseDto(int id, string roleName);
    public record ManagerResponseDto(int id, string displayName, byte[] avatar, string phone, string email, AccountResponseDto account);
    public record EaterResponseDto(int id, string displayName, byte[] avatar, string phone, string email, AccountResponseDto account);
    public record CategoryResponseDto(int id, string categoryName, byte[] categoryImage);
    public record VehicleTypeResponseDto(int id, string typeName, byte[] icon);
    public record MerchantResponseDto(int id, string displayName, byte[] avatar, string phone, 
    string email, string openingTime, string closingTime, string coordinator, 
    bool stauts, AccountResponseDto account, CategoryResponseDto category);
    public record ShipperResponseDto(int id, string displayName, byte[] avatar, string phone, 
    string email, string openingTime, string closingTime, string coordinator, 
    bool stauts, AccountResponseDto account, VehicleTypeResponseDto vehicleType);

}