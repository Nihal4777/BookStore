<%@page import="dev.nihal.User"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" isELIgnored="false"%>
<%

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store","root","");
PreparedStatement ps=con.prepareStatement("select * from books left join cart on books.id=cart.book_id where books.id=?;");
ps.setInt(1,Integer.parseInt(request.getParameter("bookID")));
ResultSet rs=ps.executeQuery();
rs.next();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

	<section id="main">
		<div>
			<img id='big' src="cover_images/<%=rs.getString("image")%>" width="200">
		</div>
		<table border="0">
			<tr>
				<td colspan=3>
					<h2>
						<?php echo $book['title'] ?>
					</h2>
				</td>
			</tr>
			<tr>
				<td><span id="auth"> Author: <%=rs.getString("author")%></span>
				</td>
				<td colspan="2"><span>Rating: &#x2605; &#x2605; &#x2605;
						&#x2605; &#x2606;</span></td>
			</tr>
			<tr>
				<td><span id="pub">Publisher: <%=rs.getString("publisher")%></span></td>
				<td colspan="3"><span id="amt">&#x20B9;<%=rs.getString("price")%></span></td>
			</tr>
			<tr>
				<td>
					<%=rs.getInt("cart.user_id")==0?"<a href='addToCart.jsp?bookID="+rs.getInt("books.id")+"' id='btn'>Add Cart<//a>":
						"<a href='cart.jsp' id='btn'>Go to Cart<//a>" %>
					
				
				</td>
				<td><span><a href="" id="btn">Free
							Sample</a></span></td>
				<td><span><a href="javascript:void(0)" id="btn">Purchase</a></span>
				</td>
			</tr>
		</table>
		<p id="desc">
		 <%=rs.getString("name")%>
		</p>
	</section>
	<aside>
		<h3>Also View</h3>
	<%
	
		
	 %>
	</aside>


</body>
</html>