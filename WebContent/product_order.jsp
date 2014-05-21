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
%>
<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">

	<table width="100%">
		<tr><td><a href="products_customer.jsp?cid=-1" target="_self">All Categories</a></td></tr>
		<%
		String id_str=null;
		int id=0;
		try {id_str=request.getParameter("id"); id=Integer.parseInt(id_str);}catch(Exception e){id_str=null;}

		Connection conn=null;
		Statement stmt=null;
		ResultSet rs=null;
		String c_name=null;
		int c_id=0;
		try
		{
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://127.0.0.1:5432/P1";
			String user="postgres";
			String password="880210";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			
			rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
			c_name=null;
			c_id=0;
			while(rs.next())
			{
				c_id=rs.getInt(1);
				c_name=rs.getString(2);
				out.println("<tr><td><a href=\"products_browsing.jsp?cid="+c_id+"\" target=\"_self\">"+c_name+"</a></td></tr>");
			}
		}
		catch(Exception e)
		{
			out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
			e.printStackTrace(response.getWriter());
		
		}
	%>
	</table>		
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">

<%
	rs=stmt.executeQuery("SELECT * FROM products where id="+id+";");
	c_name=null;
	int price=0;
	if(rs.next())
	{
		c_name=rs.getString(3);
		price=rs.getInt(5);
	}
%>
<form action="do_product_order.jsp" method="post">
<table width="70%"  border="1px" align="center">
	<input type="text" style="display:none" id="id" name="id" value="<%=id%>">
	<input type="text" style="display:none" name="name" id="name" value="<%=c_name%>">
	<input type="text" style="display:none" name="price" id="price" value="<%=price%>">
	<tr align="center"><td width="20%"><B>Name:</B></td><td align='left'><input type="text"  disabled="disabled" value="<%=c_name%>"></td></tr>
	<tr align="center"><td width="20%"><B>Price:</B></td><td align='left'><input type="text" disabled="disabled" value="<%=price%>"></td></tr>
	<tr align="center"><td width="20%"><B>Quantity:</B></td><td align='left'>
	<input type="text" name="quantity" id="quantity" value="1">
	</td></tr>
	<tr align="center"><td colspan="2"><input type="submit" value="Submit"></td></tr>
</table>
</form>
<%
}
%>
</div>
</body>
</html>