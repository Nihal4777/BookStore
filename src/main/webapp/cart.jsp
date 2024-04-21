<%@page import="com.razorpay.Order"%>
<%@page import="dev.nihal.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page language="java" isELIgnored="false" import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Cart Page</title>
<link rel="stylesheet" href="common.css">
<style>
a {
    text-decoration: none;
    color: inherit;
    background: beige;
    padding: 6px 8px;
    border-radius: 4px;
	box-shadow: 1px 1px 1px grey;
}
a:hover{
    box-shadow: 2px 2px 4px grey;
}

</style>
</head>
<body>
	<div style="display: flex">
		<div style="flex:1">
			<%
			Double totalPrice=0.0;
			User user = (User) request.getSession().getAttribute("user");
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store", "root", "");
			ResultSet rs = con.createStatement()
					.executeQuery("select * from books inner join cart on books.id=cart.book_id where user_id=" + user.getId());
			while (rs.next()) {
				totalPrice+=Double.parseDouble(rs.getString("Price"));
			%>
			<div class="app">
				<div class='block'>
					<img src='./cover_images/<%=rs.getString("image")%>' width='150px'
						alt='No image available'>
					<div class="detailsDiv">
						<p>
							<span class="bold">Name:</span>
							<%=rs.getString("name")%></p>
						<p>
							<span class="bold">Author:</span>
							<%=rs.getString("author")%></p>
						<p>
							<span class="bold">Publisher:</span>
							<%=rs.getString("publisher")%></p>
						<p>
							<span class="bold">Price:</span> &#x20B9;<%=rs.getString("Price")%></p>
						<p>
							<span class="bold">Rating:</span> <span> &#x2605; &#x2605;
								&#x2605; &#x2605; &#x2606;</span>
						</p>
						<p class="deleteBtn">
							<a href="addToCart.jsp?delId=<%=rs.getString("books.id")%>">Remove
								From Cart</a>
						</p>
					</div>
				</div>
			</div>
			<%
			}
			Double shipping=Double.parseDouble(pageContext.getServletContext().getInitParameter("shipping"));
			session.setAttribute("totalAmount", totalPrice+shipping);
			%>
		</div>
		<div class="app">
			<a href="checkout.jsp">Checkout Now</a>
			<div>
			<h2>Order Summary</h2>
				<table>
					<tr>
						<td>Items:</td>
						<td>&#x20B9;<%=totalPrice %>/-</td>
					</tr>
					<tr>
						<td>Shipping Charges:</td>
						<td>&#x20B9;<%=shipping %>/-</td>
					</tr>
					<tr>
						<td>Order Total:</td>
						<td>&#x20B9;<%=totalPrice+shipping %>/-</td>
					</tr>
				</table>
				   
			</div>		
		</div>
	</div>
	<%
	if(session.getAttribute("order")!=null){
		Order order=(Order)session.getAttribute("order");
		session.removeAttribute("order");
	%>
		<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
		<script>
var options = {
    "key": "<%=pageContext.getServletContext().getInitParameter("RAZORPAY_KEY") %>", // Enter the Key ID generated from the Dashboard
    "amount": "<%=order.get("amount").toString()%>", // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
    "currency": "INR",
    "name": "Acme Corp",
    "description": "Test Transaction",
    "image": "https://example.com/your_logo",
    "order_id": "<%=order.get("id").toString()%>", //This is a sample Order ID. Pass the `id` obtained in the response of Step 1
    "callback_url": "https://eneqd3r9zrjok.x.pipedream.net/",
    "prefill": {
        "name": "<%=user.getName() %>",
        "email": "<%=user.getEmail() %>",
    },
    "notes": {
        "address": "Purchasing Books"
    },
    "theme": {
        "color": "#3399cc"
    }
};
var rzp1 = new Razorpay(options);
    rzp1.open();
</script>
	<%	
	}	
	%>
</body>
</html>