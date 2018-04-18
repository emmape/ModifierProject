using ModifieR.Models;
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
        public static string RunFromCmd(string filename, ModifierInputObject modifierInputObject, string methodOfAnalysis, string id)
        {
            string sampleGroup1="";
            string sampleGroup2="";
            foreach(string s1 in modifierInputObject.sampleGroup1) { sampleGroup1 = sampleGroup1 +";"+ s1; }
            foreach (string s2 in modifierInputObject.sampleGroup2) { sampleGroup2 = sampleGroup2 + ";" + s2; }

            string result = string.Empty;
            try
            {
                var info = new ProcessStartInfo();
                info.FileName = @"C:\Program Files\R\R-3.4.1\bin\Rscript.exe";
                info.WorkingDirectory = @"C:\Program Files\R\R-3.4.1\bin";
                info.Arguments = 
                    Directory.GetCurrentDirectory() + @"\RCode\"+filename+" "
                    + sampleGroup1 + " " + sampleGroup2 + " "
                    + modifierInputObject.group1Label + " " + modifierInputObject.group2Label + " " 
                    + methodOfAnalysis + " "
                    + Directory.GetCurrentDirectory() + @"\RCode\"
                    + " " + id;

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
        public static string saveFiles(string expressionMatrixContent, string probeMapContent)
        {
            string fileID = Guid.NewGuid().ToString();
            File.WriteAllText(Directory.GetCurrentDirectory() + @"\RCode\tmpFilestorage\expressionMatrix" + fileID+".txt", expressionMatrixContent);
            File.WriteAllText(Directory.GetCurrentDirectory() + @"\RCode\tmpFilestorage\probeMap" + fileID + ".txt", probeMapContent);
            return fileID;
        }
        public static void deleteFiles(string id)
        {
            File.Delete(Directory.GetCurrentDirectory() + @"\RCode\tmpFilestorage\expressionMatrix" + id + ".txt");
            File.Delete(Directory.GetCurrentDirectory() + @"\RCode\tmpFilestorage\probeMap" + id + ".txt");
        }
    }
}
