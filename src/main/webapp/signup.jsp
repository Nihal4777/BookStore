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
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	String cpwd = request.getParameter("cpwd");
	if(!pwd.equals(cpwd)){
		response.sendRedirect("signup.jsp?er=Confirm Does'nt Match");
		return ;
	}
	checkFirst(pageContext);
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store", "root", "");
	Statement stmt = con.createStatement();
	PreparedStatement ps = con.prepareStatement("select * from users where email=?");
	ps.setString(1, username);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		response.sendRedirect("signup.jsp?er=User Exists");
	}else{
		ps = con.prepareStatement("insert into users(name,email,password,is_admin)values(?,?,?,false);");
		ps.setString(1, name);
		ps.setString(2, username);
		ps.setString(3, stringToHash(pwd));
		ps.executeUpdate();
		response.sendRedirect("./login.jsp");
	}
		
		
}
%>
<%!
void checkFirst(PageContext pageContext) throws Exception {
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
<title>Sign Up</title>
</head>

<body>
	<section class="main">
		<h1>Sign Up</h1>
		<form method="POST">
		<label for="name">Name:</label><br> <input type="text"
				name="name" placeholder="Enter your username" required><br>
			<label for="uname">Email:</label><br> <input type="text"
				name="uname" placeholder="Enter your username" required><br>
			<label for="pwd">Password:</label><br> <input type="password"
				name="pwd" placeholder="Enter your password" required><br>
				<label for="cpwd">Confirm Password:</label><br> <input type="password"
				name="cpwd" placeholder="Confirm your password" required><br>
			<!-- <div id="rm">
				<input type="checkbox" name="remember"> Remember me<br>
			</div> --><p>Already an user?</p> <a href="login.jsp">Login</a>
			<input type="submit" name="login" value="Login">
		</form>
	</section>
</body>
</html>