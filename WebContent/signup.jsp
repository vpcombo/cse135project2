<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>
<body>
<%
session.removeAttribute("name");
session.removeAttribute("userID");

%>
<table width="100%" align="center"><tr><td align="left"><a href="login.jsp">Home</a></td></tr></table>
<form action="signup.jsp" method="post">
<table align="center">
	<tr><td>Name:</td><td><input type="text" id="name" name="name"></td></tr>
	<tr>
		<td>Role:</td>
		<td>
			<select id="role" name="role">
				<option>owner</option>
				<option>customer</option>
			</select>
		</td>
	</tr>
	<tr><td>Age:</td><td><input type="text" id="age" name="age"></td></tr>
	<tr><td>State:</td>
		<td>
			<select id="state" name="state">
				<option>Alabama</option> 
				<option>Alaska</option>
				<option>Arizona</option>
				<option>Arkansas</option>
				<option>California</option>
				<option>Colorado</option>
				<option>Connecticut</option>
				<option>Delaware</option>
				<option>Florida</option>
				<option>Georgia</option>
				<option>Hawaii</option>
				<option>Idaho</option>
				<option>Illinois</option>
				<option>Indiana</option>
				<option>Iowa</option>
				<option>Kansas</option>
				<option>Kentucky</option>
				<option>Louisiana</option>
				<option>Maine</option>
				<option>Maryland</option>
				<option>Massachusetts</option>
				<option>Michigan</option>
				<option>Minnesota</option>
				<option>Mississippi</option>
				<option>Missouri</option>
				<option>Montana</option>
				<option>Nebraska</option>
				<option>Nevada</option>
				<option>New Hampshire</option>
				<option>New Jersey</option>
				<option>New Mexico</option>
				<option>New York</option>
				<option>North Carolina</option>
				<option>North Dakota</option>
				<option>Ohio</option>
				<option>Oklahoma</option>
				<option>Oregon</option>
				<option>Pennsylvania</option>
				<option>Rhode Island</option>
				<option>South Carolina</option>
				<option>South Dakota</option>
				<option>Tennessee</option>
				<option>Texas</option>
				<option>Utah</option>
				<option>Vermont</option>
				<option>Virginia</option>
				<option>Washington</option>
				<option>West Virginia</option>
				<option>Wisconsin</option>
				<option>Wyoming</option>

			</select>
		</td>
	</tr>
	<tr><td><input type="submit" value="Signup"></td><td><input type="button" value="Reset"></td></tr>
</table>
</form>
<%
String name=null, role=null, age=null, state=null;
try { name=request.getParameter("name"); }catch(Exception e) { name=null; }
try { role=request.getParameter("role"); }catch(Exception e) { role=null; }
try { age=request.getParameter("age"); }catch(Exception e) { age=null; }
try { state=request.getParameter("state"); }catch(Exception e) { state=null; }


if(name!=null && age!=null && role!=null && state!=null)
{
	Connection conn=null;
	Statement stmt;
	
	try
	{
		String  SQL="INSERT INTO users (name, role, age, state) VALUES('"+name+"','"+role+"',"+age+",'"+state+"');";
		try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
		String url="jdbc:postgresql://127.0.0.1:5432/P1";
		String user="postgres";
		String password="880210";
		conn =DriverManager.getConnection(url, user, password);
		stmt =conn.createStatement();
		try{
			conn.setAutoCommit(false);
			stmt.execute(SQL);
			conn.commit();
			conn.setAutoCommit(true);
			out.println("Register successfully. <br>");
			out.println("<table><tr><td>Name:</td><td>"+name+"</td></tr><tr><td>Role:</td><td>"+role+"</td></tr><tr><td>Age:</td><td>"+age+"</td></tr><tr><td>State:</td><td>"+state+"</td></tr></table>");
			out.println("Please go back to <a href='login.jsp' target='_self'>login</a>.");
		}
		catch(SQLException e)
		{
			out.println("Fail, can not access the database, please check the database status first! Please <a href='signup.jsp' target='_self'>register</a> again.");
		}
		
	}
	catch(Exception e)
	{
			out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
	}
	finally
	{
		conn.close();
	}
}
%>

</body>
</html>
