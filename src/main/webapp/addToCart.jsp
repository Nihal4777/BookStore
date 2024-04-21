<%@page import="dev.nihal.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page language="java" isELIgnored="false" import="java.sql.*"%>
<% 
	User user=(User)request.getSession().getAttribute("user");
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store", "root", "");
	
	if(request.getParameter("bookID")!=null){
	PreparedStatement ps=con.prepareStatement("insert into cart(book_id,user_id)value(?,?)");
	ps.setInt(1, Integer.parseInt(request.getParameter("bookID")));
	ps.setInt(2, user.getId());
	ps.executeUpdate();
	response.sendRedirect(request.getContextPath()+"/view.jsp"+"?"+ request.getQueryString());
	}
	else if(request.getParameter("delId")!=null){
		PreparedStatement ps=con.prepareStatement("delete from cart where book_id=? and user_id=?");
		ps.setInt(1, Integer.parseInt(request.getParameter("delId")));
		ps.setInt(2, user.getId());
		ps.executeUpdate();
		response.sendRedirect(request.getContextPath()+"/cart.jsp");
	}
	
%>
