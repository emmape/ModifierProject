using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Threading.Tasks;

namespace ModifieR.Services
{
    public class MailService
    {

        public async void sendEmail(string email, string id, string algorithm)
        {
            SmtpClient client = new SmtpClient("smtp.gmail.com", 587);
            client.UseDefaultCredentials = false;
            client.Credentials = new NetworkCredential("modifiermail@gmail.com", "modifier123");

            MailMessage mailMessage = new MailMessage();
            mailMessage.From = new MailAddress("modifiermail@gmail.com");
            mailMessage.To.Add(email);

            string file = "RCode/tmpFilestorage/output"+algorithm+ id+".csv";
            Attachment data = new Attachment(file, MediaTypeNames.Application.Octet);
            ContentDisposition disposition = data.ContentDisposition;
            disposition.CreationDate = System.IO.File.GetCreationTime(file);
            disposition.ModificationDate = System.IO.File.GetLastWriteTime(file);
            disposition.ReadDate = System.IO.File.GetLastAccessTime(file);
            // Add the file attachment to this e-mail message.
            mailMessage.Attachments.Add(data);

            mailMessage.Body = "Hi, \n \n Your Modifier analysis using "+algorithm+"-algorithm is now done! " +
                "\n Please find attatched a file containing your results. " +
                "\n You can find all results as soon as they are done, on the following link: \n " +
                "http://localhost:62421/#/result/"+id +
                "\n \n Best Regards \n Modifier Web";
            mailMessage.Subject = "Your ModifieR "+algorithm+" Analysis is done!";
            //client.Send(mailMessage);
            using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
            {
                smtp.Credentials = new NetworkCredential("modifiermail@gmail.com", "modifier123");
                smtp.EnableSsl = true;
                await smtp.SendMailAsync(mailMessage);
            }
        }
    }
}
