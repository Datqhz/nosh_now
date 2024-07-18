using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace nosh_now_apis.Migrations
{
    /// <inheritdoc />
    public partial class UpdateLocationEntity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Phone",
                table: "Location",
                type: "longtext",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Phone",
                table: "Location");
        }
    }
}
