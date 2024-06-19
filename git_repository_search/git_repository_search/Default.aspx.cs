using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace git_repository_search
{
    public partial class About : Page, IPostBackEventHandler
    {
        public class BookmarkInfo
        {
            public string command { get; set; }
            public string repoId { get; set; }
            public object repoInfo { get; set; }
            public string targetMail { get; set; }
        }

        public void RaisePostBackEvent(string eventArgument)
        {
            BookmarkInfo deserializedArgs = JsonConvert.DeserializeObject<BookmarkInfo>(eventArgument);
            var command = deserializedArgs.command;

            switch (command)
            {
                case "bookmark":
                    bookmarkRepoToSession(deserializedArgs.repoId, deserializedArgs.repoInfo);
                    break;
                case "sendmail":
                    sendMailWithRepoInfo(deserializedArgs.targetMail, deserializedArgs.repoInfo);
                    break;
                default:
                    throw new NotImplementedException("unknown command " + command);
            }
        }
        public void sendMailWithRepoInfo(string targetMail, object repoInfo)
        {
            using (var client = new SmtpClient())
            {
                client.Host = "smtp.gmail.com";
                client.Port = 587;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.EnableSsl = true;
                // because of some problem in goggle enabeling 2 validation steps i could not use this mail for sending messages
                client.Credentials = new NetworkCredential("adoptfighter@gmail.com", "password");
                using (var message = new MailMessage(
                    from: new MailAddress("adoptfighter@gmail.com", "Search Repo App"),
                    to: new MailAddress(targetMail, string.Empty)
                    ))
                {

                    message.Subject = "your selected repository info";
                    message.Body = repoInfo.ToString();

                    client.Send(message);
                }
            }
        }
            public void bookmarkRepoToSession(string repoId, object repoInfo)
        {
            if (Session != null)
            {
                if (Session["bookmarks"] == null)
                    Session["bookmarks"] = new Dictionary<string, object>();

                Dictionary<string, object> bookmarks = Session["bookmarks"] as Dictionary<string, object>;
                if (bookmarks.ContainsKey(repoId) == false)
                    bookmarks.Add(repoId, repoInfo);
                Console.WriteLine("Session success");
            }
            else
            {
                Console.WriteLine("Session is not working");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ShowBookmarks_Click(object sender, EventArgs e)
        {
            Dictionary<string, object> bookmarks = null;
            if (Session["bookmarks"] != null)
                bookmarks = Session["bookmarks"] as Dictionary<string, object>;


        }
    }

}