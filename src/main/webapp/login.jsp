<%@page import="dev.nihal.User"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="org.apache.tomcat.util.net.ApplicationBufferHandler"%>
<%@page import="java.security.MessageDigest"%>
<%@page language="java" isELIgnored="false" import="java.sql.*"%>
<%
if (request.getMethod().equalsIgnoreCase("POST")) {
	// Retrieving username and password from the request
	String username = request.getParameter("uname");
	String password = request.getParameter("pwd");
	checkFirst(pageContext);
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store", "root", "");
	Statement stmt = con.createStatement();
	PreparedStatement ps = con.prepareStatement("select * from users where email=? and password=?");
	ps.setString(1, username);
	ps.setString(2,stringToHash(password));
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		User user=new User();
		user.setId(rs.getInt("id"));
		user.setName(rs.getString("name"));
		user.setEmail(rs.getString("email"));
		user.setIs_admin(rs.getBoolean("is_admin"));
		session.setAttribute("user", user);
		if(user.getIs_admin()){
			response.sendRedirect("admin/");
			return ;
		}
		response.sendRedirect("./");
		
	} else {
		response.sendRedirect("login.jsp");

	}
}
%>
<%!void checkFirst(PageContext pageContext) throws Exception {
		ResultSet r;
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store", "root", "");
		Statement stmt = con.createStatement();
		r = stmt.executeQuery("select count(*) from users where is_admin=true");
		r.next();
		if (r.getInt(1) < 1) {
			String admin_hash = stringToHash(pageContext.getServletContext().getInitParameter("admin_password"));
			stmt.executeUpdate("insert into users(name,email,password,is_admin) values('Admin','"
					+ pageContext.getServletContext().getInitParameter("admin_username") + "','" + admin_hash + "',true"
					+ ")");
		}

	}
	
private String stringToHash(String str) throws Exception{
	
	MessageDigest md=MessageDigest.getInstance("SHA-256");
	BigInteger number = new BigInteger(1, md.digest(str.getBytes(StandardCharsets.UTF_8)));

	// Convert message digest into hex value
	StringBuilder hexString = new StringBuilder(number.toString(16));

	// Pad with leading zeros
	while (hexString.length() < 64) {
		hexString.insert(0, '0');
	}
	return hexString.toString();
}
	
	%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="stylelogin.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@300&display=swap"
	rel="stylesheet">
<title>Login</title>
</head>

<body>
	<section class="main">
		<h1>Login</h1>
		<form method="POST">
			<label for="uname">Username:</label><br> <input type="text"
				name="uname" placeholder="Enter your username" required><br>
			<label for="pwd">Password:</label><br> <input type="password"
				name="pwd" placeholder="Enter your password" required><br>
			<!-- <div id="rm">
				<input type="checkbox" name="remember"> Remember me<br>
			</div> -->
			<p>New user?</p> <a href="signup.jsp">Sign Up Now</a>
			<input type="submit" name="login" value="Login">
		</form>
	</section>
</body>
</html>