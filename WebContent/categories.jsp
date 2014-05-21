<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>
<%@include file="welcome.jsp" %>
<%
if(session.getAttribute("name")!=null)
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
		String name="", des="";

		String action=null, id_str=null;
		try { action	  = request.getParameter("action");}catch(Exception e){action  = null;}
		try {id_str	  = request.getParameter("id");}catch(Exception e){id_str =	null;}
		name=null; des=null;
		try { 
			name	=	request.getParameter("name"); 
			des		=	request.getParameter("des"); 
		}
		catch(Exception e) 
		{ 
			name	=	null; 
			des		=	null; 
		}
		if(("insert").equals(action))
		{
			String  SQL_1="INSERT INTO categories (name, description) VALUES('"+name+"','"+des+"');";
			try{
			conn.setAutoCommit(false);
			stmt.execute(SQL_1);
			conn.commit();
			conn.setAutoCommit(true);
			}
			catch(Exception e)
			{
				out.println("Fail! Please <a href=\"categories.jsp\" target=\"_self\">insert it</a> again.");
			}
		}
		else if(("update").equals(action))
		{
			 String  SQL_2="update categories set name='"+name+"' , description='"+des+"' where id="+id_str+";";
			try{
				conn.setAutoCommit(false);
				stmt.execute(SQL_2);
				conn.commit();
				conn.setAutoCommit(true);
			}
			catch(Exception e)
			{
				out.println(SQL_2);
				out.println("Fail! Please <a href=\"categories.jsp\" target=\"_self\">update it</a> again.");
			}
		}
		if(("delete").equals(action))
		{
		 	 String  SQL_1="select count(*) from products where cid="+id_str+";";
			String  SQL_2="delete from categories where id="+id_str+";";
			try{
				rs=stmt.executeQuery(SQL_1);
				int count=-1;
				while(rs.next())
				{
					 count=rs.getInt(1);
				} 
				
				if(count<=0)
				{
					conn.setAutoCommit(false);
					stmt.execute(SQL_2);
					conn.commit();
					conn.setAutoCommit(true);
				}
			}
			catch(Exception e)
			{
				out.println("Fail! Please try again in the <a href=\"categories.jsp\" target=\"_self\">categories page</a>.<br><br>");
			}
		}
%>
	<table width="100%"  border="1px" align="center">
	<tr align="center"><td width="20%"><B>Category Name</B></td><td width="60%"><B>Category Description</B></td><td width="5%"><B>Count</B></td><td width="15%" colspan="2"><B>Operations</B></td></tr>
	<form action="categories.jsp" method="post">
	<input type="text" name="action" id="action" value="insert" style="display:none">
	<tr align="center"><td width="20%"><input type="text" name="name" id="name" size="30" ></td><td width="60%"><textarea cols="90" rows="4" name="des" id="des"></textarea></td><td width="5%">0</td><td width="15%" colspan="2"><input type="submit"  value="Insert"></td></tr>
    </form>
<%		
	    int id=0,count=0;
		rs=stmt.executeQuery("select c.id, c.name, c.description, count(p.id) as number from categories c, products p where c.id=p.cid group by c.id, c.name, c.description order by c.id asc;");
		while(rs.next())
		{
			id=rs.getInt(1);
			 name=rs.getString(2);
			 des=rs.getString(3);
			 count=rs.getInt(4);
%>
			<tr align="center">
				<form action="categories.jsp" method="post">
					<input type="text" name="action" id="action" value="update" style="display:none">
					<input type="text" name="id" id="id" value="<%=id%>" style="display:none">
					<td width="20%"><input type="text" name="name" id="name" value="<%=name%>" size="30"></td>
					<td width="60%"><textarea cols="90" rows="4" name="des" id="des"><%=des%></textarea></td>
					<td width="5%"><%=count%></td>
					<td width="7%"><input type="submit" value="Update"></td>
				</form>
<%			 
			 if(count<=0)
			 {
%>			 
				
				<form action="categories.jsp" method="post">
					<input type="text" name="action" id="action" value="delete" style="display:none">
					<input type="text" name="id" id="id" value="<%=id%>" style="display:none">
					<td width="8%"><input type="submit" value="Delete"></td>
				</form>
				</tr>
<%				
			}
			else
			{
%>			
				<td width="8%"><input type="button" value="Delete" disabled="disabled"></td>	
<%
			}
			out.println("</tr>");
		}
		rs=stmt.executeQuery("select * from categories where id not in (select cid from products);");
		while(rs.next())
		{
			id=rs.getInt(1);
			name=rs.getString(2);
			des=rs.getString(3);
%>			
	<tr align="center">
			<form action="categories.jsp" method="post">
				<input type="text" name="action" id="action" value="update" style="display:none">
				<input type="text" name="id" id="id" value="<%=id%>" style="display:none">
				<td width="20%"><input type="text" name="name" id="name" value="<%=name%>" size="30"></td>
				<td width="60%"><textarea cols="90" rows="4" name="des" id="des"><%=des%></textarea></td>
				<td width="5%">0</td>
				<td width="7%"><input type="submit" value="Update"></td>
			</form>
			<form action="categories.jsp" method="post">
				<input type="text" name="action" id="action" value="delete" style="display:none">
				<input type="text" name="id" id="id" value="<%=id%>" style="display:none">
				<td width="8%"><input type="submit" value="Delete"></td>
			</form>
		</tr>
<%			
		}
		out.println("</table>");
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
else
{
	out.println("Please go to home page to login first.");
}
%>

</body>
</html>