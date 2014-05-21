<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body >
<%
if(session.getAttribute("name")!=null)
{
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String  name=null, price_str=null, quantity_str=null, pid_str=null;
	int pid=0, quantity=0;
	int price=0;
	try { 
			name =	request.getParameter("name"); 
			price_str		  =	request.getParameter("price"); 
			quantity_str  =	request.getParameter("quantity"); 
			pid_str =	request.getParameter("id"); 
			 price    = Integer.parseInt(price_str);
			 pid=Integer.parseInt(pid_str);
			
	}
	catch(Exception e) 
	{ 
		 name=null; price_str=null; quantity_str=null; pid_str=null;
	      pid=0; quantity=0; price=0;
	
	}

	try { 		
			 quantity=Integer.parseInt(quantity_str);
			if(quantity>0)
			{
				 Connection conn=null;
				Statement stmt;
				try
				{
					
					
				
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					conn = DriverManager.getConnection(
							"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
							"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
					stmt =conn.createStatement();
					String  SQL="INSERT INTO sales (uid, pid, quantity,price) VALUES("+userID+", "+pid+", "+quantity+","+price+" );";
					
					try{
						conn.setAutoCommit(false);
						stmt.execute(SQL);
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("buyShoppingCart.jsp");
					}
					catch(Exception e)
					{
						out.println("Fail! Please <a href=\"product_order.jsp?id="+pid+"\" target=\"_self\">buy it</a> again.");
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
			else
			{
			out.println("Fail! Only a postive integer is allowed for  <font color='#ff0000'>quantity</font><br> Please <a href=\"product_order.jsp?id="+pid+"\" target=\"_self\">buy it</a> again.");
			}
		}
		catch(Exception e) 
		{ 
			out.println("Fail, <font color='#ff0000'>quantity</font> should be an integer, please check your input. <a href=\"product_order.jsp?id="+pid+"\" target=\"_self\">Try again</a>");
		
		}
}
%>

</body>
</html>