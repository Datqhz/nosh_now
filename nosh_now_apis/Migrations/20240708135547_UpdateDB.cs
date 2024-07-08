using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace nosh_now_apis.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDB : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Coordinator",
                table: "Order",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Phone",
                table: "Order",
                type: "longtext",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Coordinator",
                table: "Order");

            migrationBuilder.DropColumn(
                name: "Phone",
                table: "Order");
        }
    }
}
