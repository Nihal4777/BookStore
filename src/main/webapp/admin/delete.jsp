<%@page language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
	url="jdbc:mysql://localhost:3306/book_store" user="root" password="" />
<sql:update dataSource="${db}" var="rs">delete from books where id=?
<sql:param value="${param.bookID}"></sql:param>
</sql:update>

<%
response.sendRedirect("modify.jsp");
%>