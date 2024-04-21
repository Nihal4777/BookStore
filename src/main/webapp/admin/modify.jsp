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
<title>Practical - 32</title>
<link rel="stylesheet" href="../stylemodify.css">
</head>

<body>
	<nav>
		<a href="login.php?logout=1" id="logout">Logout</a> <a
			href="index.php" id="logout" style="margin-right: 2px;">Insert
			New Records</a>
	</nav>

	<section class="main">

		<table border='1'>
			<tr>
				<th>Image</th>
				<th>Book No.</th>
				<th>Title</th>
				<th>Author</th>
				<th>Publisher</th>
				<th>Rating</th>
				<th>Amount</th>
				<th>Modify</th>
			</tr>
			<c:forEach var="table" items="${rs.rows}">
				<tr>
					<td><img src=' ../cover_images/${table.image}' width='150'
						alt='No image available'></td>
					<td>${table.id }</td>
					<td>${table.name }</td>
					<td>${table.author }</td>
					<td>${table.rating }</td>
					<td>${table.publisher }</td>
					<td>${table.price}</td>
					<td><a id='edit' href='./update.jsp?bookID=${table.id }'>Edit</a><a
						id='del' href='./delete.jsp?bookID=${table.id }'>Delete</a></td>
				</tr>
			</c:forEach>
		</table>


	</section>
</body>
</html>