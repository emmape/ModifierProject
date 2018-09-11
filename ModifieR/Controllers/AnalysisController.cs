using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;
using ModifieR.Models;
using ModifieR.RCode;
using ModifieR.Services;


namespace ModifieR.Controllers
{
    [AllowAnonymous]
    [Route("api/analysis")]
    public class AnalysisController : Controller
    {
        MailService mailService = new MailService();
        [HttpPost("diamond")]
        public async Task<IActionResult> analyseDiamond([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "diamond", input.id);
            IFileProvider provider = new PhysicalFileProvider(Directory.GetCurrentDirectory() + "\\RCode\\tmpFilestorage");
            IFileInfo fileInfo = provider.GetFileInfo("outputdiamond" + input.id + ".csv");
            var readStream = fileInfo.CreateReadStream();
            var mimeType = "application/vnd.ms-excel";
            return File(readStream, mimeType, "outputdiamond" + input.id + ".csv");
        }

        [HttpPost("cliquesum")]
        public async Task<IActionResult> analyseCliquesum([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "cliqueSum", input.id);
            mailService.sendEmail(input.email, input.id, "cliquesum");
            return Ok("An email containing your results has been sent!");
        }
        [HttpPost("correlationclique")]
        public async Task<IActionResult> analysecorrelationClique([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "correlationClique", input.id);
            mailService.sendEmail(input.email, input.id, "correlationClique");
            return Ok("An email containing your results has been sent!");
        }
        [HttpPost("diffcoex")]
        public async Task<IActionResult> analysediffCoEx([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "diffCoEx", input.id);
            mailService.sendEmail(input.email, input.id, "diffCoEx");
            return Ok("An email containing your results has been sent!");
        }
        [HttpPost("dime")]
        public async Task<IActionResult> analyseDime([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "dime", input.id);
            mailService.sendEmail(input.email, input.id, "dime");
            return Ok("An email containing your results has been sent!");
        }
        [HttpPost("moda")]
        public async Task<IActionResult> analyseModa([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "moda", input.id);
            mailService.sendEmail(input.email, input.id, "moda");
            return Ok("An email containing your results has been sent!");
        }
        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "mcode", input.id);
            IFileProvider provider = new PhysicalFileProvider(Directory.GetCurrentDirectory() + "\\RCode\\tmpFilestorage");
            IFileInfo fileInfo = provider.GetFileInfo("outputmcode" + input.id + ".csv");
            var readStream = fileInfo.CreateReadStream();
            var mimeType = "application/vnd.ms-excel";
            return File(readStream, mimeType, "outputmcode" + input.id + ".csv");
        }
        [HttpPost("modulediscoverer")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "moduleDiscoverer", input.id);
            mailService.sendEmail(input.email, input.id, "moduleDiscoverer");
            return Ok("An email containing your results has been sent!");
        }
        [HttpPost("results")]
        public async Task<IActionResult> results([FromBody] List<String> id)
        {
                IFileProvider provider = new PhysicalFileProvider(Directory.GetCurrentDirectory() + "\\RCode\\tmpFilestorage");

                IFileInfo fileInfo = provider.GetFileInfo("output" + id[0] + id[1] + ".csv");
            if (fileInfo.Exists)
            {
                var readStream = fileInfo.CreateReadStream();
                var mimeType = "application/vnd.ms-excel";
                return File(readStream, mimeType, "output" + id[0] + id[1] + ".csv");
            }
            else
            {
                return Ok("");
            }
        }

        [HttpPost("comboResults")]
        public async Task<IActionResult> comboResults([FromBody] ModifierInputObject input)
        {
            string result = await RScriptRunner.RunFromCmd("runModifieR.R", input, "combo", input.id);
            return Ok("got results");
        }

        [HttpPost("saveFiles")]
        public async Task<IActionResult> saveFiles([FromBody] ModifierInputObject input)
        {
            string id = RScriptRunner.saveFiles(input.expressionMatrixContent, input.probeMapContent, input.networkContent);
            return Ok(id);          
        }
        [HttpPost("deleteFiles")]
        public async Task<IActionResult> deleteFiles([FromBody] ModifierInputObject input)
        {
           RScriptRunner.deleteFiles(input.id);
           return Ok(input.id);
        }
    }
}
