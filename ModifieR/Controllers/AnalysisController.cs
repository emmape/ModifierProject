using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ModifieR.Models;
using ModifieR.RCode;
using ModifieR.Services;

namespace ModifieR.Controllers
{
    //[Produces("application/json")]
    [AllowAnonymous]
    [Route("api/analysis")]
    public class AnalysisController : Controller
    {
        MailService mailService = new MailService();
        [HttpPost("diamond")]
        public async Task<IActionResult> analyseDiamond([FromBody] ModifierInputObject input)
        {
            //string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            //string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "diamond", id);
            //RScriptRunner.deleteFiles(id);
            mailService.sendEmail();
            //return Ok("ResultFrom R-script: " + result);
            return Ok("Email Sent! ");
        }

        [HttpPost("cliquesum")]
        public async Task<IActionResult> analyseCliquesum([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "cliqueSum", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("correlationclique")]
        public async Task<IActionResult> analysecorrelationClique([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "correlationClique", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("diffcoex")]
        public async Task<IActionResult> analysediffCoEx([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "diffCoEx", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("dime")]
        public async Task<IActionResult> analyseDime([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "dime", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("moda")]
        public async Task<IActionResult> analyseModa([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "moda", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "mcode", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("modulediscoverer")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = RScriptRunner.RunFromCmd("runModifieR.R", input, "moduleDiscoverer", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
    }
}
