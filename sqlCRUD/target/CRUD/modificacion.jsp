<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="grupos.Grupo" %>
<%@ page import="grupos.GruposService" %>
<%@ page import="alumnos.Alumno" %>
<%@ page import="alumnos.AlumnosService" %>
<%@ page import="java.sql.*" %>
<%@ page import="connection.ConnectionPool" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="assets/css/alustyle.css" type="text/css">
        <title>Gestión modificacion</title>
    </head>
    <body>
        <div class="paginamod">
            <h1>PÁGINA MODIFICACIÓN</h1> <br>
        
        <%
    // Configuración de la conexión a la base de datos
        String url = "jdbc:mysql://localhost:3306/alumnos";
        String usuario = "deni";
        String clave = "12345";

        ConnectionPool pool = new ConnectionPool(url, usuario, clave);

        // Conexión a la base de datos
        
            AlumnosService aservice = new AlumnosService(pool.getConnection());
            GruposService gservice = new GruposService(pool.getConnection());
        
        if (Boolean.parseBoolean(request.getParameter("alumno"))) { // si se llega desde alumnos.jsp
        %>
        
        <form method="post" action="alumnos.jsp"> 
                <input type="hidden" id="idmod" name="idmod" value="<%=request.getParameter("idalum")  %>">
                <label for="nombre">Nuevo nombre:</label>
                <input type="text" id="nombremod" name="nombremod">
                <br>
                <label for="apellidos">Nuevos apellidos:</label>
                <input type="text" id="apellidomod" name="apellidomod">
                <br>
                <button type="submit" id="agregar">Modificar</button>
            </form>

        <% } else {  // si se llega desde grupos.jsp
        %>

        <form method="post" action="grupos.jsp"> 
                <input type="hidden" id="idmod" name="idmod" value="<%=request.getParameter("idgrupo")  %>">
                <label for="nombre">Nuevo nombre:</label>
                <input type="text" id="nombremod" name="nombremod">
                <br>
                <label for="apellidos">Nuevo tutor:</label>
                <input type="text" id="profesormod" name="profesormod">
                <br>
                <button type="submit" id="profesormod">Modificar</button>
            </form>
        <% } %>
    </div> 
    </body>
</html>