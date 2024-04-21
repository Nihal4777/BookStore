<%@page language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
	url="jdbc:mysql://localhost:3306/book_store" user="root" password="" />
<sql:query dataSource="${db}" var="rs">select * from books</sql:query>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Book Store</title>
<style>
div#error {
	padding: 15px;
	text-align: center;
	background-color: #EE6352;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	color: white;
	box-shadow: 1px 1px 1px 1px grey;
}
</style>
<link rel="stylesheet" href="stylehome.css">
</head>
<body>
	<a href="./admin/" id="login">Admin Login</a>
	<div id="content">
		<c:forEach var="table" items="${rs.rows}">
			<a href='./view.jsp?bookID=${table.id}'><div id='block'>
					<img src='./cover_images/${table.image}'width='150px'
						alt='No image available'>
					<p>${table.name}</p>
				</div></a>
		</c:forEach>
	</div>
</body>
</html>
