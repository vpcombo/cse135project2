<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
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
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
%>
<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">

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
		SQL="select p.name, c.quantity, p.price from products p, users u, sales c where c.uid=u.id and c.pid=p.id and c.uid="+userID;
		rs=stmt.executeQuery(SQL);
		out.println("<table width=\"80%\"  border=\"1px\" align=\"center\">");
		out.println("<tr align=\"center\"><td width=\"30%\"><B>Product Name</B></td><td width=\"25%\"><B>Price</B></td><td width=\"25%\"><B>Quantity</B></td><td width=\"20%\"><B>Amount Price</B></td></tr>");
		String name=null;
		int quantity=0;
		float price=0, amount_price=0, total_price=0;
		while(rs.next())
		{
			name=rs.getString(1);
			 quantity=rs.getInt(2);
			 price=rs.getFloat(3);
			 amount_price=quantity*price;
			 total_price+=amount_price;
			 out.println("<tr align=\"center\"><td width=\"30%\">"+name+"</td><td width=\"25%\">"+price+"</td><td width=\"25%\">"+quantity+"</td><td width=\"20%\">$"+amount_price+"</td></tr>");
		}
		
		out.println("<tr><td colspan=\"3\" align=\"left\">The total amount for your order is: <font color='#ff0000'>$"+total_price+"</font></td><td align=\"right\"><a href=\"purchase.jsp\" target=\"_self\"><img src=\"images/purchase.jpg\" width=\"130\" height=\"43\"></a></td></tr>");
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

</div>
</body>
</html>