<?php
	session_start();
	if(isset($_GET['logout']))
	{
		session_unset();
		session_destroy();
		setcookie("username","",time()-120);
		setcookie("password","",time()-120);
		header("location: ./login.php");
		exit();
	}
	if(isset($_SESSION['uname']))
	{
		header('location: index.php');
		exit();
	}
	if(isset($_COOKIE['uname']) && isset($_COOKIE['pwd']))
	{
		if($_COOKIE['uname']==='student' && $_COOKIE['pwd']===sha1('student'))
		{
			$_SESSION['uname']='student';
			header('location: ./index.php');
			exit();
		}
	}
		if(isset($_POST['login']))
		{
			if(isset($_POST['uname']) && isset($_POST['pwd']))
			{
				if($_POST['uname']==='student' && $_POST['pwd']==='student')
				{
					if(isset($_POST['remember']))
					{
						if($_POST['remember']==='on')
						{
							$t=time()+172800;
							setcookie('uname','student',$t,'/');
							setcookie('pwd',sha1('student'),$t,'/');
						}
					}
					$_SESSION['uname']='student';
					header('location: ./');
					exit();
				}
				else
				{
					$_SESSION['error']="Invalid Credentials";
					header("location: ./login.php");
				}
			}
		}
?>
<%@page language="java" isELIgnored="false" import="java.sql.*"%>
<%
    // Retrieving username and password from the request
    String username = request.getParameter("uname");
    String password = request.getParameter("pwd");

    Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store","root","");
	PreparedStatement ps=con.prepareStatement("update books set name=?, price=? ,publisher=? ,author=?,image=? where id=?");
	ps.setString(1,reqHashMap.get("name"));
    // Check if the username and password are valid (You should have your own validation logic here)
    if(username != null && password != null && username.equals("your_username") && password.equals("your_password")) {
        // If the username and password are correct, create a session and redirect to a welcome page
        HttpSession session = request.getSession(true);
        session.setAttribute("username", username);
        response.sendRedirect("welcome.jsp");
    } else {
        // If the username and password are incorrect, redirect back to the login page with an error message
        response.sendRedirect("login.jsp?error=invalid_credentials");
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
<link href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@300&display=swap" rel="stylesheet">
    <title>Login</title>
</head>

<body>
<?php
	if(isset($_SESSION['error']) && !isset($_POST['login']))
	{
		print_r($_SESSION);
		echo "<div id='error'>".$_SESSION['error']."</div>";
		unset($_SESSION['error']);
	}
?>
    <section class="main">
		<h1>Login</h1>
        <form method="POST">
            <label for="uname">Username:</label><br>
            <input type="text" name="uname" placeholder="Enter your username" required><br>
            <label for="pwd">Password:</label><br>
            <input type="password" name="pwd" placeholder="Enter your password" required><br>
            <div id="rm">
                <input type="checkbox" name="remember"> Remember me<br>
            </div>
            <input type="submit" name="login" value="Login">
        </form>
    </section>
    <p>Username: student & Password: student</p>
</body>
</html>