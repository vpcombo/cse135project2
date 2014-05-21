<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>
<%@include file="welcome.jsp" %>
<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products.jsp?cid=-1" target="_self">All Categories</a></td></tr>
<%
if(session.getAttribute("name")!=null)
{
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	
	Connection conn=null;
	Statement stmt;
	ResultSet rs=null;
	String SQL=null;
	try
	{
		try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
		String url="jdbc:postgresql://127.0.0.1:5432/P1";
		String user="postgres";
		String password="880210";
		conn =DriverManager.getConnection(url, user, password);
		stmt =conn.createStatement();
		rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
		String c_name=null;
		int c_id=0;
		while(rs.next())
		{
			c_id=rs.getInt(1);
			c_name=rs.getString(2);
			out.println("<tr><td><a href=\"products.jsp?cid="+c_id+"\" target=\"_self\">"+c_name+"</a></td></tr>");
		}
		%>
	</table>	
</div>
<%
		String action=null,name=null, SKU=null, category=null, price_str=null, id_str=null;
		int price=0;
		try { action	  = request.getParameter("action");}catch(Exception e){action  = null;}
		try {id_str	  = request.getParameter("id");}catch(Exception e){id_str =	null;}
		try{
			name	  =	request.getParameter("name"); 
			SKU		  =	request.getParameter("SKU"); 
			price_str =	request.getParameter("price"); 
			price     = Integer.parseInt(price_str);
		}
		catch(Exception e) 
		{ 
			name	  = null; 
			SKU		  =	null; 
			price_str =	null; 
			price     = 0;
		}
		try{
			category  =	request.getParameter("category"); 
		}
		catch(Exception e) 
		{ 
			category  =	null; 
		}
		if(("insert").equals(action))
		{
			rs=stmt.executeQuery("SELECT * FROM categories where name='"+category+"';");
			int cid=0;
			if(rs.next())
			{
				cid=rs.getInt(1);
			}
			String  SQL_1="INSERT INTO products (cid, name, SKU, price) VALUES("+cid+",'"+name+"','"+SKU+"', "+price+");";
			try{
			conn.setAutoCommit(false);
			stmt.execute(SQL_1);
			conn.commit();
			conn.setAutoCommit(true);
			}
			catch(Exception e)
			{
				out.println("Fail! Please <a href=\"products.jsp\" target=\"_self\">insert it</a> again.");
			}
		}
		else if(("update").equals(action))
		{
			String  SQL_2="update products set name='"+name+"' , SKU='"+SKU+"'  , price='"+price+"' where id="+id_str+";";
			try{
				conn.setAutoCommit(false);
				stmt.execute(SQL_2);
				conn.commit();
				conn.setAutoCommit(true);
			//	response.sendRedirect("products.jsp?cid=-1");
			}
			catch(Exception e)
			{
				out.println("Fail! Please <a href=\"products.jsp\" target=\"_self\">update it</a> again.");
			}
		}
		if(("delete").equals(action))
		{
		 	String  SQL_3="delete from products where id="+id_str+";";
			try{
			conn.setAutoCommit(false);
			stmt.execute(SQL_3);
			conn.commit();
			conn.setAutoCommit(true);
			}
			catch(Exception e)
			{
				out.println("Fail! Please try again in the <a href=\"products.jsp\" target=\"_self\">products page</a>.<br><br>");
			}
		}
%>

<div style="width:79%; position:absolute; top:50px; right:0px; height:90%;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
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
<form action="products.jsp" method="post">
Search for products: 
<input type="text" name="cid" id="cid" value="<%=c_id_int%>" style="display:none">
<input type="text" id="key" name="key" size="50"><input type="submit" value="Search">
</form>
<br>

<table width="100%"  border="1px" align="center">
	<tr align="center">
		<td width="20%"><B>Product Name</B></td>
		<td width="20%"><B>SKU number</B></td>
		<td width="20%"><B>Categgory</B></td>
		<td width="20%"><B>Price</B></td>
		<td width="20%" colspan="2"><B>Operations</B></td>
	</tr>
	<form action="products.jsp" method="post">
	<tr align="center">
		<input type="text" name="action" id="action" value="insert"  style="display:none">
		<td width="20%"><input type="text" name="name" id="name"></td>
		<td width="20%"><input type="text" name="SKU" id="SKU"></td>
		<td width="20%">
		<select id="category" name="category">
			<%
				rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
				while(rs.next())
				{
					c_id=rs.getInt(1);
					c_name=rs.getString(2);
					out.println("<option id=\""+c_id+"\">"+c_name+"</option>");
				}
			%>
		</select>
		</td>
		<td width="20%"><input type="text" name="price" id="price" ></td>
		<td width="20%" colspan="2"><input type="submit"  value="Insert"></td>
	</tr>
</form>
<%		
		rs=stmt.executeQuery(SQL);
		int id=0;
		name=""; SKU="";category=null;
		price=0;
		while(rs.next())
		{
			id=rs.getInt(1);
			name=rs.getString(2);
			 SKU=rs.getString(3);
			 category=rs.getString(4);
			 price=rs.getInt(5);
%>			 
		
		<tr align="center">
		<form action="products.jsp" method="post">
			<input type="text" name="action" id="action" value="update" style="display:none">
			<input type="text" name="id" id="id" value="<%=id%>" style="display:none">
			<td width="20%"><input type="text" name="name" id="name" value="<%=name%>"></td>
			<td width="20%"><input type="text" name="SKU" id="SKU" value="<%=SKU%>"></td>
			<td width="20%"><input type="text" name="category" id="category" disabled="disabled" value="<%=category%>"></td>
			<td width="10%"><input type="text" name="price" id="price" value="<%=price%>"></td>
			<td width="10%"><input type="submit" value="Update"></td>
		</form>
		<form action="products.jsp" method="post">
			<input type="text" name="action" id="action" value="delete" width="3" style="display:none"><input type="text" name="id" id="id" value="<%=id%>" width="3"  style="display:none">
			<td width="10%"><input type="submit" value="Delete"></td>
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
	out.println("Please go to <a href=\"login.jsp\" target=\"_self\">home page</a> to login first.");
}
%>
</div>
</body>
</html>