using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;
using ModifieR.Models;
using ModifieR.RCode;
using ModifieR.Services;
using System.IO;

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
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "diamond", id);
            RScriptRunner.deleteFiles(id);
            mailService.sendEmail(input.email, id);
            //return Ok("ResultFrom R-script: " + result);
            return Ok("An email containing your results has been sent!");
        }

        [HttpPost("cliquesum")]
        public async Task<IActionResult> analyseCliquesum([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "cliqueSum", id);
            RScriptRunner.deleteFiles(id);
            
            IFileProvider provider = new PhysicalFileProvider(Directory.GetCurrentDirectory()+"\\RCode\\tmpFilestorage");
            IFileInfo fileInfo = provider.GetFileInfo("output"+id+".csv");
            var readStream = fileInfo.CreateReadStream();
            var mimeType = "application/vnd.ms-excel";
            return File(readStream, mimeType, "output" + id + ".csv");
            //return File(stream, "tmpFilestorage\\probeMap409bc0ad-6c33-4bba-a480-2b36149c370d.txt");
            //return Ok("tmpFilestorage\\probeMap409bc0ad-6c33-4bba-a480-2b36149c370d.txt");
        }
        [HttpPost("correlationclique")]
        public async Task<IActionResult> analysecorrelationClique([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "correlationClique", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("diffcoex")]
        public async Task<IActionResult> analysediffCoEx([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "diffCoEx", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("dime")]
        public async Task<IActionResult> analyseDime([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "dime", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("moda")]
        public async Task<IActionResult> analyseModa([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "moda", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "mcode", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
        [HttpPost("modulediscoverer")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent);
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "moduleDiscoverer", id);
            RScriptRunner.deleteFiles(id);
            return Ok("ResultFrom R-script: " + result);
        }
    }
}
