<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="java.util.*" errorPage="" %>
<%
String flag_str=null,need_to_connect_db=null;
int flag=0, role_flag=-1;
try {flag_str=request.getParameter("flag"); flag=Integer.parseInt(flag_str);}catch(Exception e){flag_str=null;flag=0;}
try {need_to_connect_db=request.getParameter("need");}catch(Exception e){need_to_connect_db=null;}
/**if flag==-1, it needs to change one user**/
String name=null;
try {name=request.getParameter("name");}catch(Exception e){ name=null;}
if(("Y").equals(need_to_connect_db))
{
 		 Connection conn=null;
		Statement stmt;
		try
		{
		
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://127.0.0.1:5432/P1";
			String user="postgres";
			String password="880210";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			ResultSet rs=null;
			rs=stmt.executeQuery("SELECT * FROM  users where name='"+name+"';");
		
			String role=null;
			int userID=0;
			int t=0;
			if(rs.next())
			{
				userID=rs.getInt(1);
				role=rs.getString(3);	
				session.setAttribute("name",name);
				session.setAttribute("userID",userID);
				session.setAttribute("role",role);
				if(role.equals("owner"))
				{		
					role_flag=1;
				}
				else
				{
					role_flag=2;
				}
				t++;
			}
			if(t==0)
			{
				role_flag=0;
			}
		}
		catch(Exception e)
		{
				out.println("<font color='#ff0000'>Error, can not access the database, please check the database connection.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
				//e.printStackTrace(response.getWriter());
		}
		finally
		{
			conn.close();
		}
}
else
{
	if(flag!=-1)
	{
		if(session.getAttribute("name")!=null)
		{
			name=(String)session.getAttribute("name");
			String role=(String)session.getAttribute("role");
			if(role.equals("owner"))
			{		
				role_flag=1;
			}
			else
			{
				role_flag=2;
			}
		}
	}
}

%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>CSE135</title>
</head>
<body>
<form action="login.jsp" method="post">
<input type="text" name="need" id="need" value="Y" style="display:none">
<table align="center" width="500px" border="1">
	<tr  align="center">
		<td colspan="2"><font size="+2" color="#0000FF">Demo for CSE135 project 1</font></td>
	</tr>
<%
	if(role_flag==-1 || role_flag==0)
	{
		out.println("<tr  align=\"center\"><td width=\"100px\" align=\"right\"><font size=\"+1\">Name:</font></td><td width=\"400px\" align=\"left\"><input type=\"text\" name=\"name\" id=\"name\" style=\"width:300; height:30; font-size:22\"></td></tr>");
	
	}
	if(role_flag==0)
	{
		out.print("<tr align=\"center\"><td colspan=\"2\">The provided name <font color=\"#FF0000\">\""+name+"\"</font> is not known.<br>Please <a href=\"signup.jsp\" target=\"_self\">sign up</a> first!</td></tr>");	
	
	}
	if(role_flag==-1 || role_flag==0)
	{
	   out.print("<tr align=\"center\"><td colspan=\"2\"><input type=\"submit\" value=\"Please Login\" style=\"width:150; height:30; font-size:20px\" ></td></tr>");
	}
	
	if(role_flag==1)
	{
	    out.print("<tr align=\"center\"><td colspan=\"2\"><font color=\"#FF0000\">Welcome owner \""+name+"\"</font><br>");
		out.print("<a href=\"categories.jsp\">Manage Categories</a><br>");
		out.print("<a href=\"products.jsp\">Manage Products</a><br>");
		out.print("<a href=\"login.jsp?flag=-1\"> Change an account</a><br>");
		out.print("</td></tr>");
	}
	else if(role_flag==2)
	{
	   	out.print("<tr align=\"center\"><td colspan=\"2\"><font color=\"#FF0000\">Welcome customer \""+name+"\"</font><br>");
		out.print("<a href=\"products_browsing.jsp\"> Start Browsing Products</a><br>");
		out.print("<a href=\"login.jsp?flag=-1\"> Change an account</a><br>");
		out.print("</td></tr>");
	}

%>
</table>
</form>
</body>
</html>
