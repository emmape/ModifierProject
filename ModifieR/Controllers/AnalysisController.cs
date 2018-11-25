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
        private readonly IOptions<RConfig> config;
        private readonly ILogger logger;

        public AnalysisController(IOptions<RConfig> config, ILogger<AnalysisController> logger)
        {
            this.config = config;
            this.logger = logger;
        }

        MailService mailService = new MailService();
        [HttpPost("diamond")]
        public async Task<IActionResult> analyseDiamond([FromBody] ModifierInputObject input)
        {
            try
            {
                logger.LogInformation("Recieved request to Diamond");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "diamond", input.id);
                logger.LogInformation("Got Result: "+result);
                await mailService.sendEmail(input.email, input.id, "diamond");
                return Ok("An email containing your results has been sent!");
            }catch(Exception e)
            {
                logger.LogError("Error in R-script"+e.Message, e);
                return StatusCode(500, e.Message);
            }
           
        }

        [HttpPost("cliqueSum")]
        public async Task<IActionResult> analyseCliqueSum([FromBody] ModifierInputObject input)
        {
            try {
            logger.LogInformation("Recieved request to CliqueSum");
            string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "cliqueSum", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "cliqueSum");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("correlationclique")]
        public async Task<IActionResult> analysecorrelationClique([FromBody] ModifierInputObject input)
        {
            try {
                logger.LogInformation("Recieved request to correlationClique");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "correlationClique", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "correlationClique");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("diffcoex")]
        public async Task<IActionResult> analysediffCoEx([FromBody] ModifierInputObject input)
        {
            try {
                logger.LogInformation("Recieved request to diffcoex");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "diffCoEx", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "diffCoEx");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("dime")]
        public async Task<IActionResult> analyseDime([FromBody] ModifierInputObject input)
        {
            try {
                logger.LogInformation("Recieved request to dime");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "dime", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "dime");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("moda")]
        public async Task<IActionResult> analyseModa([FromBody] ModifierInputObject input)
        {
            try {
                logger.LogInformation("Recieved request to moda");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "moda", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "moda");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("mcode")]
        public async Task<IActionResult> analyseMcode([FromBody] ModifierInputObject input)
        {
            try {
                logger.LogInformation("Recieved request to mcode");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "mcode", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "mcode");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("modulediscoverer")]
        public async Task<IActionResult> analyseMd([FromBody] ModifierInputObject input)
        {
            try {
                logger.LogInformation("Recieved request to modulediscoverer");
                string result = await RScriptRunner.RunFromCmd(config.Value, "runModifieR.R", input, "moduleDiscoverer", input.id);
                logger.LogInformation("Got Result: " + result);
                await mailService.sendEmail(input.email, input.id, "moduleDiscoverer");
            return Ok("An email containing your results has been sent!");
            }
            catch (Exception e)
            {
                logger.LogError("Error in R-script" + e.Message, e);
                return StatusCode(500, e.Message);
            }
        }
        [HttpPost("results")]
        public async Task<IActionResult> results([FromBody] List<String> id)
        {
                IFileProvider provider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage")); //"\\RCode\\tmpFilestorage");

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
    }
}
