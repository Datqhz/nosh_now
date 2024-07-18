namespace MyApp.Dtos.Request
{
    public record CreateCategory(string categoryName, string image);
    public record UpdateCategory(int id, string categoryName, string image);
    public record CreateRole(string roleName);
    public record UpdateRole(int id, string roleName);
    public record CreatePaymentMethod(string methodName, string image);
    public record UpdatePaymentMethod(int id, string methodName, string image);
    public record CreateOrderStatus(string statusName, int step);
    public record UpdateOrderStatus(int id, string statusName, int step);
        public record CreateVehicleType(string typeName, string image);
    public record UpdateVehicleType(int id, string typeName, string image);
    public record CreateAccount(string email, string password, int roleId);
    public record UpdateAccount(int id, string email, string password, int roleId);
    public record CreateEaterOrManager(string displayName, string avatar, string email, string phone, int accountId);
    public record UpdateEaterOrManager(int id, string displayName, string avatar, string phone);
    public record CreateMerchant(string displayName, string avatar, string email,
                                string phone, string openingTime, string closingTime, 
                                string coordinator, int accountId, int categoryId);
    public record UpdateMerchant(int id, string displayName, string avatar,
                                string phone, string openingTime, string closingTime, int categoryId ,
                                string coordinator);
    public record CreateShipper(string displayName, string avatar, string email,
                                string phone, string vehicleName, string momoPayment, 
                                string coordinator, int accountId, int vehicleTypeId);
    public record UpdateShipper(int id, string displayName, string avatar,
                                string phone, string vehicleName, string momoPayment, 
                                string coordinator, int vehicleTypeId);


    public record LoginRequest(string email, string password);
    public record CreateLocation(string locationName, string phone, string coordinator, bool defaultLocation, int eaterId);
    public record UpdateLocation(int id, string locationName, string phone, string coordinator, bool defaultLocation);
    public record CreateOrder(int merchantId, int eaterId);
    public record UpdateOrder(int id, double shipmentFee, string coordinator, string phone, int statusId, int shipperId, int methodId);
    public record CreateOrderDetail(int foodId, int orderId, double price, int quantity);
    public record UpdateOrderDetail(int id, double price, int quantity);
    public record CreateFood(string foodName, string foodImage, string foodDescribe, double price, int status, int merchantId);
    public record UpdateFood(int id, string foodName, string foodImage, string foodDescribe, double price, int status);

}