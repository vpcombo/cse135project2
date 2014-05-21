<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%
if(session.getAttribute("name")!=null)
{
  String name=(String) session.getAttribute("name");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>
<body>
<table width="100%">
<tr><td><a href="login.jsp">Home</a></td><td align="right"> Hello <font color="#FF0000"><%=name%></font></td></tr>
</table>
</div>
</body>
</html>
<%
}
%>