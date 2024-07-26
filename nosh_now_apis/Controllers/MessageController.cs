using System.Transactions;
using FirebaseTest.Mobile.Helpers;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/message")]
    public class MessageController : ControllerBase
    {
        public MessageController()
        {
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            string token = GoogleOAuthUtility.CreateJwtForFirebaseMessaging();
            return Ok(new {
                token = token
            });
        }
    }
}