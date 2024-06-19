<%@ Page Title="Git Repository Search" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="git_repository_search.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" >

    <link rel="stylesheet" href="/css/styles.css?v=1" />
    <script type="text/javascript">
        var reposList = {};

        function getRepositoriesByNameResponse(data, status) {
            $.get("https://api.github.com/search/repositories?q=consist_task1",)
        }

        function getRepositoriesByName() {
            console.info("getRepositoriesByName");
            var requiredRepo = document.getElementById("repo_name").value;
            $.get("https://api.github.com/search/repositories?q=" + requiredRepo, function (data, status) {
                console.info(data);
                var { items } = data;
                console.info(items);
                if (status === "success") {
                    items.forEach(item => {
                        var itemId = item.id;
                        console.info(itemId);
                        reposList[itemId] = item;
                        console.info(reposList[itemId]);
                        drawItem(item);
                    });
                }

                else
                    alert("error");


            });
        }

        function displayRepoResults() {
            // get repos
            $("#reposListItems").empty();
            reposList = {};
            getRepositoriesByName()
        }

        function drawItem(item) {
            var $list = $("#reposListItems");

            //var $li = $("<li>").attr("id", "item_" + item.id);
            var $div = $("<div class='box zone'></div>").attr("id", "item_" + item.id);
            var $repoName = $("<p>").html(item.full_name).appendTo($div);
            var $avatar = $("<img>").attr("src", item.owner.avatar_url).appendTo($div);
            var $bookmarkBtn = $("<button onclick='bookmarkItem(" + item.id + ")'>Bookmark</button>").appendTo($div);
            var $sendMailBtn = $("<button onclick='sendMail(" + item.id + ")'>Send Mail</button>").appendTo($div);

            $div.appendTo($list);
        }

        $(document).ready(function () {
            console.info("ready");
            $("#repo_name").focus();
            $("#repo_name").keyup(function (event) {
                if (event.keyCode == 13) {
                    displayRepoResults();
                }
            });
        });

        function bookmarkItem(itemId) {
            var pageId = '<%=  Page.ClientID %>';
            __doPostBack(pageId, JSON.stringify({ command: "bookmark", repoId: itemId, repoInfo: reposList[itemId] }));
            console.info("bookmarkItem", reposList[itemId]);
        }

        function sendMail(itemId) {
            let targetMail = prompt("Please enter your target mail", "");
            var pageId = '<%=  Page.ClientID %>';
            __doPostBack(pageId, JSON.stringify({ command: "sendmail", repoId: itemId, repoInfo: reposList[itemId], targetMail }));
            console.info("sendMail");
        }
    </script>



    <h2><%: Title %>.</h2>
    <div >
        <label for="repo_name">Repository Name:</label>
        <input type="text" id="repo_name" name="repo_name">
        <asp:Button id="SearchRepoButton" Text="Find" runat="server"  OnClientClick ="displayRepoResults(); return false;"/>
    </div>

    <div id="reposListItems" class="grid-wrapper zone blue">

    </div>

    
</asp:Content>
