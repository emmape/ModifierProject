using System;
using System.Collections.Generic;

namespace ModifieR.Models
{
    public partial class Customers
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public string AccountNr { get; set; }
        public string PersonalNumber { get; set; }
    }
}
