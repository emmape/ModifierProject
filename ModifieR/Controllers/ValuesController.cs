//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
//using Microsoft.AspNetCore.Mvc;
////using SecuritiesGiftCard.Models;
//using Microsoft.EntityFrameworkCore;
////using SecuritiesGiftCard.Services;
//using System.Security.Claims;
//using Microsoft.AspNetCore.Http;
////using ModifieR.Models;
//using Microsoft.AspNetCore.Authorization;

//// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

//namespace ModifieR
//{
//    [AllowAnonymous]
//    [Route("api/GiftCard")]
//    public class ValuesController : Controller
//    {
//        private readonly SecuritiesGiftCardContext _context;
//        private string _user;

//        public ValuesController(SecuritiesGiftCardContext context)
//        {
//            _context = context;
//        }
//        // GET: api/values
//        [HttpGet("data")]

//        public IEnumerable<GiftCards> GetSustainability()
//        {
//            System.Security.Claims.ClaimsPrincipal currentUser = this.User;
//            string user = currentUser.Identity.Name.Substring(currentUser.Identity.Name.IndexOf("\\")+1);
//            if (_context.Users.Where(c => c.UserId.Equals(user)).FirstOrDefault() != null)
//            {
//                IQueryable<GiftCards> q = _context.Set<GiftCards>();

//                return q;
//            }
//            else
//            {
//                return null;
//            }

//        }

//        // GET: api/values
//        [HttpGet("{valueCode}")]

//        public IActionResult GetGiftCard(string valueCode)
//        {
//            System.Security.Claims.ClaimsPrincipal currentUser = this.User;
//            string user = currentUser.Identity.Name.Substring(currentUser.Identity.Name.IndexOf("\\") + 1);
//            if (_context.Users.Where(c => c.UserId.Equals(user)).FirstOrDefault() != null)
//            {
//                //return Ok(User.Identity);
//                return Ok(_context.GiftCards.Where(c => c.ValueCode.Equals(valueCode)).FirstOrDefault());
//            }
//            else
//            {
//                return null;
//            }
//        }

//        [HttpPost("redeem/{valueCode}")]
//        //[HttpPost]
//        public async Task<IActionResult> SetRedeemed(string valueCode)
//        {
//            System.Security.Claims.ClaimsPrincipal currentUser = this.User;
//            string user = currentUser.Identity.Name.Substring(currentUser.Identity.Name.IndexOf("\\") + 1);
//            if (_context.Users.Where(c => c.UserId.Equals(user)).FirstOrDefault() != null)
//            {
//                GiftCards gc = _context.GiftCards.Where(c => c.ValueCode.Equals(valueCode)).FirstOrDefault();
//                gc.Redeemed = true;
//                gc.RedeemingDate = DateTime.Now;
//                await _context.SaveChangesAsync();
//                return Ok(_context.GiftCards.Where(c => c.ValueCode.Equals(valueCode)).FirstOrDefault());
//            }
//            else
//            {
//                return null;
//            }


//        }


//        //[HttpPost]
//        //public async Task<IActionResult> AddNewGiftCard([FromBody] GiftCards giftCard)
//        //{
//        //    System.Security.Claims.ClaimsPrincipal currentUser = this.User;
//        //    string user = currentUser.Identity.Name.Substring(currentUser.Identity.Name.IndexOf("\\") + 1);
//        //    if (_context.Users.Where(c => c.UserId.Equals(user)).FirstOrDefault() != null)
//        //    {
//        //        giftCard.BuyingDate = DateTime.Now;
//        //        giftCard.ValueCode = GetValueCode();
//        //        _context.GiftCards.Add(giftCard);
//        //        await _context.SaveChangesAsync();
//        //        return Ok(_context.GiftCards.Where(c => c.ValueCode.Equals(giftCard.ValueCode)).FirstOrDefault());
//        //    }
//        //    else
//        //    {
//        //        return null;
//        //    }


//        //}

//        public string GetValueCode()
//        {
//            Random random = new Random();
//            string chars = "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789";
//            string code = new string(Enumerable.Repeat(chars, 8).Select(s => s[random.Next(s.Length)]).ToArray());

//            while (_context.GiftCards.Where(c => c.ValueCode.Equals(code)).FirstOrDefault() != null)
//            {
//                random = new Random();
//                chars = "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789";
//                code = new string(Enumerable.Repeat(chars, 8).Select(s => s[random.Next(s.Length)]).ToArray());
//            }

//            return code;

//        }

//        [HttpGet("user")]

//        public string GetUser()
//        {
//            string user = _user;
//            System.Security.Claims.ClaimsPrincipal currentUser = this.User;
//            user = currentUser.Identity.Name.Substring(currentUser.Identity.Name.IndexOf("\\")+1);
//            return "User: " + user;

//        }


//        //// GET api/values/5
//        //[HttpGet("{id}")]
//        //public string Get(int id)
//        //{
//        //    return "value";
//        //}

//        //// POST api/values
//        //[HttpPost]
//        //public void Post([FromBody]string value)
//        //{
//        //}

//        //// PUT api/values/5
//        //[HttpPut("{id}")]
//        //public void Put(int id, [FromBody]string value)
//        //{
//        //}

//        //// DELETE api/values/5
//        //[HttpDelete("{id}")]
//        //public void Delete(int id)
//        //{
//        //}
//    }
//}
