using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace ModifieR.RCode
{
    public class RScriptRunner
    {
        public static string RunFromCmd()
        {
            string result = string.Empty;
            try
            {
                var info = new ProcessStartInfo();
                info.FileName = @"C:\Program Files\R\R-3.4.1\bin\Rscript.exe";
                info.WorkingDirectory = @"C:\Program Files\R\R-3.4.1\bin";
                info.Arguments = Directory.GetCurrentDirectory() + @"\RCode\runModifieR.R inputinputinput! secondInput";

                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();
                    result = proc.StandardOutput.ReadToEnd();
                }

                return result;
            }
            catch (Exception ex)
            {
                throw new Exception("R Script failed: " + result, ex);
            }
        }
    }
}
