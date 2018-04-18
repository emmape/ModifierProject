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
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "diamond");
            return Ok("ResultFrom R-script: " + result);
        }

        [HttpPost("cliquesum")]
        public async Task<IActionResult> analyseCliquesum([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "cliqueSum");
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("correlationclique")]
        public async Task<IActionResult> analysecorrelationClique([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "correlationClique");
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("diffcoex")]
        public async Task<IActionResult> analysediffCoEx([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "diffCoEx");
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("dime")]
        public async Task<IActionResult> analyseDime([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "dime");
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("moda")]
        public async Task<IActionResult> analyseModa([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "moda");
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "mcode");
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("modulediscoverer")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "moduleDiscoverer");
            return Ok("ResultFrom R-script: " + result);
        }
    }
}
