using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authorization;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using ModifieR.Models;

namespace ModifieR
{
    [AllowAnonymous]
    [Route("api/input")]
    public class ValuesController : Controller
    {
        // Input variables
        ModifierInputObject modifierInputObject = new ModifierInputObject();

        //Input expression matrix, returns sample names
        [HttpPost("expressionMatrix")]
        public async Task<IActionResult> InputExpressionMatrix(IFormFile file)
        {
            string filename = file.FileName;
            using (var reader = new StreamReader(file.OpenReadStream()))
            {
                modifierInputObject.expressionMatrixContent = reader.ReadToEnd();
            }
            string sampleNames = modifierInputObject.expressionMatrixContent.Split(Environment.NewLine.ToCharArray())[0];
            return Ok(sampleNames);
        }
        [HttpPost("probeMap")]
        public async Task<IActionResult> InputProbeMap(IFormFile file)
        {
            string filename = file.FileName;
            using (var reader = new StreamReader(file.OpenReadStream()))
            {
                modifierInputObject.probeMapContent = reader.ReadToEnd();
            }
            return Ok("ProbeMap uploaded");
        }

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


        //[HttpPost]
        //public async Task<IActionResult> InputExpressionMatrix(IFormFile file)
        //{
        //    string filename = file.FileName;
        //    string fileContent = "";
        //    using (var reader = new StreamReader(file.OpenReadStream()))
        //    {
        //        fileContent = reader.ReadToEnd();
        //    }

        //    string columnNames = fileContent.Split(Environment.NewLine.ToCharArray())[0];
        //    //return Ok(fileContent.Substring(0, 10));
        //    return Ok(columnNames);


        //    //System.Security.Claims.ClaimsPrincipal currentUser = this.User;
        //    //string user = currentUser.Identity.Name.Substring(currentUser.Identity.Name.IndexOf("\\") + 1);
        //    //if (_context.Users.Where(c => c.UserId.Equals(user)).FirstOrDefault() != null)
        //    //{
        //    //giftCard.BuyingDate = DateTime.Now;
        //    //    giftCard.ValueCode = GetValueCode();
        //    //    _context.GiftCards.Add(giftCard);
        //    //    await _context.SaveChangesAsync();

        //    //return Ok(_context.GiftCards.Where(c => c.ValueCode.Equals(giftCard.ValueCode)).FirstOrDefault());
        //    //}
        //    //else
        //    //{
        //    //    return null;
        //    //}


        //}

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
    }
}
