<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    if (signedRequest == null) {%>
        This App must be invoked via a signed request!<%
        return;
    }
    String yourConsumerSecret=System.getenv("CANVAS_CONSUMER_SECRET");
    //String yourConsumerSecret="1818663124211010887";
    String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

    <title>Hello World Canvas Example</title>

    <link rel="stylesheet" type="text/css" href="/sdk/css/canvas.css" />

    <!-- Include all the canvas JS dependencies in one file -->
    <script type="text/javascript" src="/sdk/js/canvas-all.js"></script>
    <!-- Third part libraries, substitute with your own -->
    <script type="text/javascript" src="/scripts/json2.js"></script>

    <script>
        if (self === top) {
            // Not in Iframe
            alert("This canvas app must be included within an iframe");
        }

        Sfdc.canvas(function() {
            var sr = JSON.parse('<%=signedRequestJson%>');
            // Save the token
            Sfdc.canvas.oauth.token(sr.oauthToken);
            Sfdc.canvas.byId('username').innerHTML = sr.context.user.fullName;
            Sfdc.canvas.byId('email').innerHTML = sr.context.user.email;
            Sfdc.canvas.byId('userName').innerHTML = sr.context.user.userName;
            Sfdc.canvas.byId('sObjectName').innerHTML = sr.context.environment.parameters.sObjectName;
            Sfdc.canvas.byId('recordId').innerHTML = sr.context.environment.parameters.recordId;
            Sfdc.canvas.byId('recordName').innerHTML = sr.context.environment.parameters.recordName;
            console.log(sr.context);
        });

    </script>
</head>
<body>
    <br/>
    <h1>Hello <span id='username'></span></h1>
    <h2>Additional attributes </h2>
    <span id='email'></span>
    <br/>
    <span id='userName'></span>
    <br/>
    <span id='sObjectName'></span>    
    <br/>    
    <span id='recordId'></span>
    <br/>    
    <span id='recordName'></span>
    <br/>    
</body>
</html>
