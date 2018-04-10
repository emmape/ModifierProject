using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ModifieR.Models;
using ModifieR.RCode;

namespace ModifieR.Controllers
{
    //[Produces("application/json")]
    [AllowAnonymous]
    [Route("api/analysis")]
    public class AnalysisController : Controller
    {
        [HttpPost("diamond")]
        public async Task<IActionResult> analyseDiamond([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input);
            return Ok("ResultFrom R-script: " + result);
        }

        [HttpPost("barrenas")]
        public async Task<IActionResult> analyseBarrenas([FromBody] ModifierInputObject input)
        {
            return Ok("Got some input!: " + input.group1Label);
        }

        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            return Ok("Got some input!: " + input.group1Label);
        }

        [HttpPost("md")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            return Ok("Got some input!: " + input.group1Label);
        }
    }
}
