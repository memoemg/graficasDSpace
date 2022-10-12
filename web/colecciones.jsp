<%-- 
    Document   : colecciones
    Created on : 23/06/2020, 03:35:28 PM
    Author     : guies
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>

        <%
            if (request.getParameter("id") != null) {
                String community_id = request.getParameter("id");

		 String dburl = "jdbc:postgresql://localhost/unarai";
                 String dbusername = "repousr";
                 String dbpassword = "desa_6479";


                try {
                    Class.forName("org.postgresql.Driver");
                    Connection con = DriverManager.getConnection(dburl, dbusername, dbpassword);
                    PreparedStatement pstmt = null;
                    pstmt = con.prepareStatement("SELECT collection_id as id, text_value as nombre FROM metadatavalue, community, community2collection WHERE community.uuid ='" + community_id + "' AND community.uuid = community2collection.community_id and metadatavalue.metadata_field_id = 64 AND metadatavalue.dspace_object_id = community2collection.collection_id;");
                    ResultSet rs = pstmt.executeQuery();
        %>
    <option selected="selected" value="-1"> - Elija una colección - </option>
    <%
        while (rs.next()) {
    %>
    <option value="<%=rs.getString("id")%>"><%=rs.getString("nombre")%></option>
    <%
                }

                con.close();
            } catch (Exception e) {
                e.printStackTrace();

            }
        } else {
            System.out.println("community_id vacío");
        }
    %>

</body>
</html>
