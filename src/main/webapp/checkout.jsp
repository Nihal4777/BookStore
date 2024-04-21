<%@page import="org.apache.catalina.core.ApplicationContext"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.razorpay.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
ServletContext context=pageContext.getServletContext();
RazorpayClient razorpay = new RazorpayClient(context.getInitParameter("RAZORPAY_KEY"),context.getInitParameter("RAZORPAY_SECRET") );
JSONObject orderRequest = new JSONObject();
orderRequest.put("amount",(Double)session.getAttribute("totalAmount")*100);
orderRequest.put("currency","INR");
JSONObject notes = new JSONObject();
notes.put("notes_key_1","Tea, Earl Grey, Hot");
orderRequest.put("notes",notes);
Order order = razorpay.orders.create(orderRequest);
session.setAttribute("order", order);
response.sendRedirect(request.getContextPath()+"/cart.jsp?order_id="+order.get("id").toString());

%>
