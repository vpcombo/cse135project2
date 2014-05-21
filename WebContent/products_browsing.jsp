<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>
<%@include file="welcome.jsp" %>
<table width="100%"><tr><td align="right"><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr></table>
<%
if(session.getAttribute("name")!=null)
{
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
%>
<div style="width:20%; position:absolute; top:55px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	
	<table width="100%">
		<tr><td><a href="products_browsing.jsp?cid=-1" target="_self">All Categories</a></td></tr>
		<%
		Connection conn=null;
		Statement stmt;
		String SQL=null;
		try
		{
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://127.0.0.1:5432/P1";
			String user="postgres";
			String password="880210";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			ResultSet rs=null;
			rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
			String c_name=null;
			int c_id=0;
			while(rs.next())
			{
				c_id=rs.getInt(1);
				c_name=rs.getString(2);
				out.println("<tr><td><a href=\"products_browsing.jsp?cid="+c_id+"\" target=\"_self\">"+c_name+"</a></td></tr>");
			}
		%>
	</table>	
</div>

<div style="width:79%; position:absolute; top:55px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<%
	   String c_id_str=null,key=null;
	   int c_id_int=-1;
	   try {c_id_str=request.getParameter("cid"); c_id_int=Integer.parseInt(c_id_str);}catch(Exception e){c_id_str=null;c_id_int=-1;}
	   try {key=request.getParameter("key");}catch(Exception e){key=null;}

		
		if(c_id_int==-1 && key==null)
		{
			SQL="SELECT p.id, p.name,SKU,c.name, price FROM products p, categories c where p.cid=c.id  order by p.id desc limit 20;";
		}
		else
		{
			if(c_id_int==-1 && key!=null)
			{
				SQL="SELECT p.id, p.name,SKU,c.name, price FROM  products p, categories c where p.cid=c.id  and p.name LIKE '"+key+"%' order by p.id desc limit 20;";
			}
			else if(c_id_int!=-1 && key!=null)
			{
				SQL="SELECT p.id, p.name,SKU, c.name,price FROM  products p, categories c where p.cid=c.id  and cid="+c_id_int+" and p.name LIKE '"+key+"%' order by p.id desc limit 20;";
			}
			else if(c_id_int!=-1 && key==null)
			{
				SQL="SELECT p.id, p.name,SKU,c.name, price FROM products p, categories c where p.cid=c.id and cid="+c_id_int+" order by p.id desc limit 20;";
			}
		}
%>
<form action="products_browsing.jsp" method="post">
Search for products: 
<input type="text" name="cid" id="cid" value="<%=c_id_int%>" style="display:none">
<input type="text" id="key" name="key" size="50"><input type="submit" value="Search">
</form>
<br>


<%		
		rs=stmt.executeQuery(SQL);
		out.println("<table width=\"100%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"20%\"><B>Product Name</B></td><td width=\"20%\"><B>SKU number</B></td><td width=\"20%\"><B>Categgory</B></td><td width=\"20%\"><B>Price</B></td><td width=\"20%\"><B>Operations</B></td></tr>");
		int id=0;
		String name="", SKU="",category=null;
		int price=0;
		while(rs.next())
		{
			id=rs.getInt(1);
			name=rs.getString(2);
			 SKU=rs.getString(3);
			 category=rs.getString(4);
			 price=rs.getInt(5);
			 out.println("<tr align=\"center\"><td width=\"20%\">"+name+"</td><td width=\"20%\">"+SKU+"</td><td width=\"20%\">"+category+"</td><td width=\"20%\">"+price+"</td><td width=\"20%\"><a href=\"product_order.jsp?id="+id+"\">Buy it</a></td></tr>");
		}
		out.println("</table>");
	}
	catch(Exception e)
	{
		out.println(SQL);
		out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");

	
	}
	finally
	{
		conn.close();
	}
}
else
{
	out.println("Please go to <a href=\"login.jsp\" target=\"_self\">home page</a> to login first.");
}
%>
</div>
</body>
</html>