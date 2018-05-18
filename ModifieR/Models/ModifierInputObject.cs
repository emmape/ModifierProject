using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ModifieR.Models
{
    public class ModifierInputObject
    {
        public string expressionMatrixContent { get; set; }
        public string probeMapContent { get; set; }
        public string group1Label { get; set; }
        public string group2Label { get; set; }
        public List<string> sampleGroup1 { get; set; }
        public List<string> sampleGroup2 { get; set; }
        public string email { get; set; }
        public string networkContent { get; set; }
    }
}
