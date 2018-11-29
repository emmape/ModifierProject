using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using ModifieR.Models;
using ModifieR.RCode;
using ModifieR.Services;


namespace ModifieR.Controllers
{
    [AllowAnonymous]
    [Route("api/analysis")]
    public class AnalysisController : Controller
    {
        private readonly IOptions<Config> config;
        private readonly ILogger logger;

        public AnalysisController(IOptions<Config> config, ILogger<AnalysisController> logger)
        {
            this.config = config;
            this.logger = logger;
        }

        MailService mailService = new MailService();
        [HttpPost("diamond")]
        public async Task<IActionResult> analyseDiamond([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "diamond"); 
        }

        [HttpPost("cliqueSum")]
        public async Task<IActionResult> analyseCliqueSum([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "cliqueSum");
           
        }
        [HttpPost("correlationclique")]
        public async Task<IActionResult> analysecorrelationClique([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "correlationClique");
           
        }
        [HttpPost("diffcoex")]
        public async Task<IActionResult> analysediffCoEx([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "diffCoEx");
           
        }
        [HttpPost("dime")]
        public async Task<IActionResult> analyseDime([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "dime");
           
        }
        [HttpPost("moda")]
        public async Task<IActionResult> analyseModa([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "moda");
           
        }
        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "mcode");
        }
        [HttpPost("modulediscoverer")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            return await runAnalysis(input, "moduleDiscoverer");
           
        }
        [HttpPost("results")]
        public async Task<IActionResult> results([FromBody] List<String> id)
        {
                IFileProvider provider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage"));
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
            try { 
            string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "combo", input.id);
            return Ok("got results");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
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

        private async Task<IActionResult> runAnalysis(ModifierInputObject input, String algorithm)
        {
            try
            {
                logger.LogInformation("Recieved request to "+ algorithm);
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, algorithm, input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(config.Value, input.email, input.id, algorithm);
                return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }

        }
    }
}
