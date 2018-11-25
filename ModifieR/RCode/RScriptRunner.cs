using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
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
       
        public static async Task<string> RunFromCmd(RConfig rconfig, string filename, ModifierInputObject modifierInputObject, string methodOfAnalysis, string id)
        {
            string sampleGroup1="";
            string sampleGroup2="";
            foreach(string s1 in modifierInputObject.sampleGroup1) { sampleGroup1 = sampleGroup1 +";"+ s1; }
            foreach (string s2 in modifierInputObject.sampleGroup2) { sampleGroup2 = sampleGroup2 + ";" + s2; }

            string result = string.Empty;
            string error = string.Empty;
            try
            {
                var info = new ProcessStartInfo();
                info.FileName = rconfig.rExePath; // @"C:\Program Files\R\R-3.4.1\bin\Rscript.exe";
                info.WorkingDirectory = rconfig.rLibPath; //@"C:\Program Files\R\R-3.4.1\bin";
                info.Arguments =
                    Directory.GetCurrentDirectory() + @"\RCode\"+filename+" "
                    + sampleGroup1 + " " + sampleGroup2 + " "
                    + modifierInputObject.group1Label + " " + modifierInputObject.group2Label + " " 
                    + methodOfAnalysis + " "
                    + Directory.GetCurrentDirectory() + @"\RCode\"
                    + " " + id;

                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.RedirectStandardError = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();

                    error = proc.StandardError.ReadToEnd();
                    result = proc.StandardOutput.ReadToEnd();
                }
                if (error!="" || result.Contains("Error"))
                {
                    
                    throw new Exception("Error in R script: "+ error);
                }
                return result;
            }
            catch (Exception ex)
            {
                throw new Exception("R Script failed: " + error, ex);
            }
        }
        public static async Task<string> RunFromCmdGeneral(RConfig rconfig, string filename, string id)
        {
            string result = string.Empty;
            try
            {
                var info = new ProcessStartInfo();
                info.FileName = rconfig.rExePath; ;
                info.WorkingDirectory = rconfig.rLibPath;
                info.Arguments =
                    Directory.GetCurrentDirectory() + @"\RCode\" + filename + " "
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
        public static string saveFiles(string expressionMatrixContent, string probeMapContent, string networkContent)
        {
            string fileID = Guid.NewGuid().ToString();
            String path = Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "expressionMatrix" + fileID + ".txt");
            File.WriteAllText(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "expressionMatrix" + fileID +".txt"), expressionMatrixContent);// @"\RCode\tmpFilestorage\expressionMatrix" + fileID+".txt", expressionMatrixContent);
            File.WriteAllText(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "probeMap" + fileID + ".txt"), probeMapContent); // @"\RCode\tmpFilestorage\probeMap" + fileID + ".txt", probeMapContent);
            if (networkContent !="")
            {
                File.WriteAllText(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "network" + fileID + ".txt"), networkContent); // @"\RCode\tmpFilestorage\network" + fileID + ".txt", networkContent);
            }
            return fileID;
        }
        public static void deleteFiles(string id)
        {
            if (File.Exists(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "expressionMatrix" + id + ".txt")));// @"\RCode\tmpFilestorage\expressionMatrix" + id + ".txt"))
            {
                File.Delete(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "expressionMatrix" + id + ".txt")); //@"\RCode\tmpFilestorage\expressionMatrix" + id + ".txt");
            }
            if (File.Exists(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "probeMap" + id + ".txt"))); //@"\RCode\tmpFilestorage\probeMap" + id + ".txt"))
            {
                File.Delete(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "probeMap" + id + ".txt")); //@"\RCode\tmpFilestorage\probeMap" + id + ".txt");
                }

                if (File.Exists(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "network" + id + ".txt")));// @"\RCode\tmpFilestorage\network" + id + ".txt"))
            {
                File.Delete(Path.Combine(Directory.GetCurrentDirectory(), "RCode", "tmpFilestorage", "network" + id + ".txt"));// @"\RCode\tmpFilestorage\network" + id + ".txt");
            }
        }
    }
}
