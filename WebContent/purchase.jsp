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
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
%>
<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">Purchase Order</font></td><td align="right"><font size="+3"><font size="+2">Computer Science &  Engineering</font> </font></td></tr>
</table>
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td width="20%"><font size="+1">Product Name</font></td><td width="20%"><font size="+1">Product Price</font></td><td width="20%"><font size="+1">Quantity</font></td><td width="20%"><font size="+1">Amount Price</font></td></tr>
</table>
<%
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
		String SQL="select p.name, c.quantity, p.price from products p, users u, sales c where c.uid=u.id and c.pid=p.id and c.uid="+userID;
		rs=stmt.executeQuery(SQL);
		out.println("<table width=\"80%\"  align=\"center\">");
		String name=null;
		int quantity=0;
		int price=0, amount_price=0, total_price=0;
		while(rs.next())
		{
			name=rs.getString(1);
			 quantity=rs.getInt(2);
			 price=rs.getInt(3);
			 amount_price=quantity*price;
			 total_price+=amount_price;
			 out.println("<tr><td width=\"30%\">"+name+"</td><td width=\"25%\">"+price+"</td><td width=\"25%\">"+quantity+"</td><td width=\"20%\">$"+amount_price+"</td></tr>");
		}
		out.println("<tr><td align=\"right\" colspan=\"3\"><font size=\"+2\">Purchase Order Total</font></td><td align=\"right\"><font size=\"+2\" color='#ff0000'>$"+total_price+"</font></td></tr>");
		out.println("</table>");
	}
	catch(Exception e)
	{
		out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
		e.printStackTrace(response.getWriter());
	
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

%><p>
<table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td><font size="+1">Please input your credit card number and confirm payment</font></td></tr>
</table>
<form action="do_purchase.jsp" method="post">
<table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td><font size="+1"><img src="images/visa.png" width="280" height="48"><br>Credit Card Number:</font><input type="text" size="40" width="30" id="card" name="card"><input type="submit" value="Purchase"></td></tr>
</table>
</form>

</div>
</body>
</html>