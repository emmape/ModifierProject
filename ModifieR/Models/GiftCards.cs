using System;
using System.Collections.Generic;

namespace ModifieR.Models
{
    public partial class GiftCards
    {
        public int Id { get; set; }
        public string ValueCode { get; set; }
        public int? Amount { get; set; }
        public string RecommendedShare { get; set; }
        public long? BuyerId { get; set; }
        public DateTime? BuyingDate { get; set; }
        public int? RedeemerId { get; set; }
        public DateTime? RedeemingDate { get; set; }
        public bool? Redeemed { get; set; }
        public bool? NonRedeemable { get; set; }
    }
}
