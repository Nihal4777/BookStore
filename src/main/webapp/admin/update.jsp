<%@page import="java.util.HashMap"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.*"%>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>

<%!  
	HashMap<String,String> reqHashMap;
	ResultSet rs=null;
%>


<%
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/book_store","root","");
	if(request.getMethod().equalsIgnoreCase("POST")){
		reqHashMap=new HashMap();
		String file_name=fileUpload(request,pageContext);
		System.out.println(reqHashMap.get("stored"));
		if (reqHashMap.get("stored")!=null)
		{
			PreparedStatement ps=con.prepareStatement("update books set name=?, price=? ,publisher=? ,author=?,image=? where id=?");
			ps.setString(1,reqHashMap.get("name"));
			ps.setString(3,reqHashMap.get("publisher"));
			ps.setString(4,reqHashMap.get("author"));
			ps.setString(5,reqHashMap.get("stored"));
			ps.setString(6,reqHashMap.get("bookID"));
			ps.setDouble(2,Double.parseDouble(reqHashMap.get("price")));
			ps.execute();
		}
		else{
			PreparedStatement ps=con.prepareStatement("update books set name=?, price=? ,publisher=? ,author=? where id=?");
			ps.setString(1,reqHashMap.get("name"));
			ps.setString(3,reqHashMap.get("publisher"));
			ps.setString(4,reqHashMap.get("author"));
			ps.setString(5,reqHashMap.get("bookID"));
			ps.setDouble(2,Double.parseDouble(reqHashMap.get("price")));
			ps.execute();
		}
		
		response.sendRedirect("modify.jsp");
	}else{
		PreparedStatement ps=con.prepareStatement("select * from books where id=?");
		ps.setInt(1,Integer.parseInt(request.getParameter("bookID")));
		rs=ps.executeQuery();
		rs.next();
	}
%>
<%! public String fileUpload(HttpServletRequest request,PageContext pageContext) throws Exception{
	File file ;
	   int maxFileSize = 5000 * 1024;
	   int maxMemSize = 5000 * 1024;
	   ServletContext context = pageContext.getServletContext();
	   String salt=getSaltString(6);
	   String filePath = "C:\\Users\\Nihal\\Documents\\JEE\\BookStore\\src\\main\\webapp\\cover_images\\"+salt+"_";
	   // Verify the content type
	   String contentType = request.getContentType();
	   
	   if ((contentType.indexOf("multipart/form-data") >= 0)) {
	      DiskFileItemFactory factory = new DiskFileItemFactory();
	      // maximum size that will be stored in memory
	      factory.setSizeThreshold(maxMemSize);
	      
	      // Location to save data that is larger than maxMemSize.
	      factory.setRepository(new File("."));

	      // Create a new file upload handler
	      ServletFileUpload upload = new ServletFileUpload(factory);
	      
	      // maximum file size to be uploaded.
	      upload.setSizeMax( maxFileSize );
	         // Parse the request to get file items.
	         List fileItems = upload.parseRequest(request);

	         // Process the uploaded file items
	         Iterator i = fileItems.iterator();
	         reqHashMap.put("stored",null);
	         while ( i.hasNext () ) {
	            FileItem fi = (FileItem)i.next();
	            if ( !fi.isFormField () ) {
	               // Get the uploaded file parameters
	               String fieldName = fi.getFieldName();
	               String fileName = fi.getName();
	               boolean isInMemory = fi.isInMemory();
	               long sizeInBytes = fi.getSize();
	               System.out.println(fi.getName());
	            	if(fi.getName()=="") continue;
	               // Write the file
	               if( fileName.lastIndexOf("\\") >= 0 ) {
	                  file = new File( filePath + 
	                  fileName.substring( fileName.lastIndexOf("\\"))) ;
	               } else {
	                  file = new File( filePath + 
	                  fileName.substring(fileName.lastIndexOf("\\")+1)) ;
	               }
	               fi.write( file ) ;
	               reqHashMap.put("stored",salt+"_"+fi.getName());
	            }
	            else{
	            	reqHashMap.put(fi.getFieldName(), fi.getString());
	            }
	         }
	        
	   }
	   return "";
	            

} 

protected String getSaltString(int len) {
    String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    StringBuilder salt = new StringBuilder();
    Random rnd = new Random();
    while (salt.length() < len) { // length of the random string.
        int index = (int) (rnd.nextFloat() * SALTCHARS.length());
        salt.append(SALTCHARS.charAt(index));
    }
    String saltStr = salt.toString();
    return saltStr;

}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Practical - 32</title>
	<link rel="stylesheet" href="../insert.css">
</head>

<body>
	<nav>
		<a href="login.php?logout=1" id="logout">Logout</a>
		<a href="modify.jsp" id="logout" style="margin-right:2px;">Modify Records</a>
	</nav>
	<section class="main" id="insert">
		<form method="post" enctype="multipart/form-data">
		<input type="hidden" name="bookID" value="<%=rs.getString("id")%>"/>
			<table border=0>
				<tr>
					<td><label>Book title: </label></td>
					<td><input name="name" type="text" required value="<%=rs.getString("name")%>"></td>
				</tr>
				<tr>
					<td><label>Author: </label></td>
					<td><input type="text" name="author" value="<%=rs.getString("author")%>" required></td>
				</tr>
				<tr>
					<td><label>Publisher: </label></td>
					<td>
						<input type="text" name="publisher" value="<%=rs.getString("publisher")%>" required></td>
					</td>
				</tr>
				<tr>
					<td><label>Price: </label></td>
					<td><input type="number" name="price"  value="<%=rs.getString("price")%>" requried min='1'></td>
				</tr>
				<tr>
					<td><label>Description: </label></td>
					<td>
						<div id="ta"><textarea name="description"  rows="10"><%=rs.getString("name")%></textarea></div>
					</td>
				</tr>
				<tr>
					<td><label>Choose image: </label></td>
					<td><input type="file" name="image" accept="image/*"></td>
				</tr>
				<tr>
					<td colspan='2'><input type="submit" name="insert" value="Insert"></td>
				</tr>
				
			</table>
		</form>
	</section>
</body>
</html>
