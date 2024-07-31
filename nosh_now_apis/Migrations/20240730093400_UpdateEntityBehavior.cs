using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace nosh_now_apis.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEntityBehavior : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Account_Role_RoleId",
                table: "Account");

            migrationBuilder.DropForeignKey(
                name: "FK_Eater_Account_AccountId",
                table: "Eater");

            migrationBuilder.DropForeignKey(
                name: "FK_Food_Merchant_MerchantId",
                table: "Food");

            migrationBuilder.DropForeignKey(
                name: "FK_Location_Eater_EaterId",
                table: "Location");

            migrationBuilder.DropForeignKey(
                name: "FK_Manager_Account_AccountId",
                table: "Manager");

            migrationBuilder.DropForeignKey(
                name: "FK_Merchant_Account_AccountId",
                table: "Merchant");

            migrationBuilder.DropForeignKey(
                name: "FK_Merchant_Category_CategoryId",
                table: "Merchant");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_Eater_EaterId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_Merchant_MerchantId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_OrderStatus_StatusId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_PaymentMethod_MethodId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_Shipper_ShipperId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetail_Food_FoodId",
                table: "OrderDetail");

            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetail_Order_OrderId",
                table: "OrderDetail");

            migrationBuilder.DropForeignKey(
                name: "FK_Shipper_Account_AccountId",
                table: "Shipper");

            migrationBuilder.DropForeignKey(
                name: "FK_Shipper_VehicleType_VehicleTypeId",
                table: "Shipper");

            migrationBuilder.AlterColumn<int>(
                name: "ShipperId",
                table: "Order",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Account_Role_RoleId",
                table: "Account",
                column: "RoleId",
                principalTable: "Role",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Eater_Account_AccountId",
                table: "Eater",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Food_Merchant_MerchantId",
                table: "Food",
                column: "MerchantId",
                principalTable: "Merchant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Location_Eater_EaterId",
                table: "Location",
                column: "EaterId",
                principalTable: "Eater",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Manager_Account_AccountId",
                table: "Manager",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Merchant_Account_AccountId",
                table: "Merchant",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Merchant_Category_CategoryId",
                table: "Merchant",
                column: "CategoryId",
                principalTable: "Category",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_Eater_EaterId",
                table: "Order",
                column: "EaterId",
                principalTable: "Eater",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_Merchant_MerchantId",
                table: "Order",
                column: "MerchantId",
                principalTable: "Merchant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_OrderStatus_StatusId",
                table: "Order",
                column: "StatusId",
                principalTable: "OrderStatus",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_PaymentMethod_MethodId",
                table: "Order",
                column: "MethodId",
                principalTable: "PaymentMethod",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_Shipper_ShipperId",
                table: "Order",
                column: "ShipperId",
                principalTable: "Shipper",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetail_Food_FoodId",
                table: "OrderDetail",
                column: "FoodId",
                principalTable: "Food",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetail_Order_OrderId",
                table: "OrderDetail",
                column: "OrderId",
                principalTable: "Order",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Shipper_Account_AccountId",
                table: "Shipper",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Shipper_VehicleType_VehicleTypeId",
                table: "Shipper",
                column: "VehicleTypeId",
                principalTable: "VehicleType",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Account_Role_RoleId",
                table: "Account");

            migrationBuilder.DropForeignKey(
                name: "FK_Eater_Account_AccountId",
                table: "Eater");

            migrationBuilder.DropForeignKey(
                name: "FK_Food_Merchant_MerchantId",
                table: "Food");

            migrationBuilder.DropForeignKey(
                name: "FK_Location_Eater_EaterId",
                table: "Location");

            migrationBuilder.DropForeignKey(
                name: "FK_Manager_Account_AccountId",
                table: "Manager");

            migrationBuilder.DropForeignKey(
                name: "FK_Merchant_Account_AccountId",
                table: "Merchant");

            migrationBuilder.DropForeignKey(
                name: "FK_Merchant_Category_CategoryId",
                table: "Merchant");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_Eater_EaterId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_Merchant_MerchantId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_OrderStatus_StatusId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_PaymentMethod_MethodId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_Order_Shipper_ShipperId",
                table: "Order");

            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetail_Food_FoodId",
                table: "OrderDetail");

            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetail_Order_OrderId",
                table: "OrderDetail");

            migrationBuilder.DropForeignKey(
                name: "FK_Shipper_Account_AccountId",
                table: "Shipper");

            migrationBuilder.DropForeignKey(
                name: "FK_Shipper_VehicleType_VehicleTypeId",
                table: "Shipper");

            migrationBuilder.AlterColumn<int>(
                name: "ShipperId",
                table: "Order",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Account_Role_RoleId",
                table: "Account",
                column: "RoleId",
                principalTable: "Role",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Eater_Account_AccountId",
                table: "Eater",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Food_Merchant_MerchantId",
                table: "Food",
                column: "MerchantId",
                principalTable: "Merchant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Location_Eater_EaterId",
                table: "Location",
                column: "EaterId",
                principalTable: "Eater",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Manager_Account_AccountId",
                table: "Manager",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Merchant_Account_AccountId",
                table: "Merchant",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Merchant_Category_CategoryId",
                table: "Merchant",
                column: "CategoryId",
                principalTable: "Category",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_Eater_EaterId",
                table: "Order",
                column: "EaterId",
                principalTable: "Eater",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_Merchant_MerchantId",
                table: "Order",
                column: "MerchantId",
                principalTable: "Merchant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_OrderStatus_StatusId",
                table: "Order",
                column: "StatusId",
                principalTable: "OrderStatus",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Order_PaymentMethod_MethodId",
                table: "Order",
                column: "MethodId",
                principalTable: "PaymentMethod",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Order_Shipper_ShipperId",
                table: "Order",
                column: "ShipperId",
                principalTable: "Shipper",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetail_Food_FoodId",
                table: "OrderDetail",
                column: "FoodId",
                principalTable: "Food",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetail_Order_OrderId",
                table: "OrderDetail",
                column: "OrderId",
                principalTable: "Order",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Shipper_Account_AccountId",
                table: "Shipper",
                column: "AccountId",
                principalTable: "Account",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Shipper_VehicleType_VehicleTypeId",
                table: "Shipper",
                column: "VehicleTypeId",
                principalTable: "VehicleType",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
