<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="alumnos.Alumno" %>
<%@ page import="alumnos.AlumnosService" %>
<%@ page import="matricula.Matricula" %>
<%@ page import="matricula.MatriculaService" %>
<%@ page import="grupos.Grupo" %>
<%@ page import="grupos.GruposService" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="connection.ConnectionPool" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="assets/css/alustyle.css" type="text/css">
    <title>Gestión grupos</title>
</head>
<body>
    <%
    // Configuración de la conexión a la base de datos
    String url = "jdbc:mysql://localhost:3306/alumnos";
    String usuario = "deni";
    String clave = "12345";

    ConnectionPool pool = new ConnectionPool(url, usuario, clave);

    // Conexión a la base de datos
    GruposService gservice = new GruposService(pool.getConnection());
    AlumnosService aservice = new AlumnosService(pool.getConnection());
    MatriculaService mservice = new MatriculaService(pool.getConnection());

    // Definicion de variables:
    Boolean agregar = false;
    Boolean borrar = false;
    String opcion = "1";

    

    // Vaciar un grupo
    if (request.getParameter("idgr") != null) {
        Integer idGrupo = Integer.parseInt(request.getParameter("idgr"));
        ArrayList<Alumno> alumnos = aservice.requestAlumnos(idGrupo);
        for (Alumno a : alumnos) {
            mservice.deleteGroup((int)(a.getId()));
        }
    }

    // Borrar un grupo
    if (request.getParameter("idg") != null) {
        Long idGrupo = Long.parseLong(request.getParameter("idg"));
        gservice.delete(idGrupo);
    }

    // Cambia el nombre 
    if (request.getParameter("nombremod")!=null && !request.getParameter("nombremod").equalsIgnoreCase("")) {
        String nombre = request.getParameter("nombremod");
        Integer id = Integer.parseInt(request.getParameter("idmod"));
        gservice.update(id, nombre, "nombreGrupo");
    }

    // Cambia el tutor
    if (request.getParameter("profesormod")!=null && !request.getParameter("profesormod").equalsIgnoreCase("")) {
        String profesor = request.getParameter("profesormod");
        Integer id = Integer.parseInt(request.getParameter("idmod"));
        gservice.update(id, profesor, "profesor");
    } 
    %>

    <div class="pagina">
        <div class="new"> <!-- Agregar un nuevo grupo -->
        <div class="imagen"> <img src="assets/img/grupo.png"> </div>
            <form method="post" action="grupos.jsp">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre">
                <br>
                <label for="apellidos">Profesor:</label>
                <input type="text" id="profesor" name="profesor">
                <br>
                <input type="hidden" id="agregarb" name="agregarb" value="true">
                <button type="submit" id="agregar">Añadir Grupo</button>
            </form>
            <%// Agregar un grupo
            agregar = Boolean.parseBoolean(request.getParameter("agregarb"));
            if (agregar) {
                String nombre = request.getParameter("nombre");
                String profesor = request.getParameter("profesor");
                if (nombre == null || profesor == null || nombre.equalsIgnoreCase("") || profesor.equalsIgnoreCase("") ) {
                    out.println("No puedes crear un grupo con campos vacíos");
                } else {
                    try {
                        gservice.create(nombre, profesor);
                    } catch (SQLException e) {
                        if(e.getErrorCode() == 1062){
                            out.println("El grupo ya existe con ese nombre");
                        } else { e.printStackTrace(); }
                    }
                }
            } %>
        </div>
        <div class="table">
            <div class="redireccionar"> 
                <form method="post" action="index.jsp">
                    <button type="submit"> volver </button>    
                </form>
                <form method="post" action="alumnos.jsp">
                    <button type="submit"> alumnos </button>    
                </form>
            </div> 
            <div class="titulo">
                <h1>GESTIÓN DE GRUPOS</h1>
            </div>
            <form method="post" action="grupos.jsp">
                <label for="buscar">Buscar ... </label>
                <input type="text" id="buscar" name="buscar" placeholder="Introduzca nombre del grupo o el tutor">
                <button type="submit">Enviar</button> <br>
            <div class="table-container"> <!-- Muestra la tabla de los grupos -->
                <table class="">
                    <tr>
                        <th> ID </th>
                        <th> NOMBRE </th>
                        <th> TUTOR </th>
                        <th> Nº ALUMNOS </th>
                    </tr>
                    <%
                        String busqueda = request.getParameter("buscar");
                        if (busqueda == null) {
                            ArrayList<Grupo> grupos = gservice.requestAll();
                            if(grupos.size()==0){
                                out.println("No hay grupos registrados");
                            } else {
                                for(Grupo g : grupos){
                                %> <tr> <% 
                                out.print(g);
                                ArrayList<Alumno> alumnos = aservice.requestAlumnos((int)(g.getId()));
                                out.print("<td>"+ alumnos.size() +"</td>");
                                %> <td>
                                    <div id="botones">  <!-- Botones para vaciar, borrar y modificar -->
                                        <form method="post" action="modificacion.jsp" id="borrar-form"> <!-- modificar grupo -->
                                            <input type="hidden" id="idgrupo" name="idgrupo" value="<%= g.getId() %>">
                                            <input type="hidden" id="alumno" name="alumno" value="false">
                                            <button type="submit" id="modificar">
                                                <div class="boton-img"><img src="assets/img/edit.png" > </div>
                                            </button>
                                        </form>
                                    <% if (alumnos.size() == 0) { %>
                                        <form method="post" action="grupos.jsp" id="borrar-form"> <!-- borrar grupo -->
                                            <input type="hidden" id="idg" name="idg" value="<%= g.getId() %>">
                                            <button type="submit" id="borrar">
                                                <div class="boton-img"><img src="assets/img/trash-can.png" > </div>
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <form method="post" action="grupos.jsp" id="borrar-form"> <!-- borrar grupo -->
                                            <input type="hidden" id="idgr" name="idgr" value="<%= g.getId() %>">
                                            <button type="submit" id="vaxiar">
                                                <div class="boton-img"><img src="assets/img/empty-trash-can.png" > </div>
                                            </button>
                                        </form>
                                    <% } %>
                                    </div>
                                    </td>
                                </tr><%
                                }
                            }
                        } else if (busqueda!=null) {
                            ArrayList<Grupo> buscados = gservice.buscarGrupos(busqueda);
                            if(buscados.size()==0){
                                out.println("No hay grupos con ese nombre o tutor");
                            } else {
                                for(Grupo g : buscados) {
                                    %> <tr> <% 
                                    out.print(g);
                                    ArrayList<Alumno> alumnos = aservice.requestAlumnos((int)(g.getId()));
                                    out.print("<td>"+ alumnos.size() +"</td>");
                                    %> <td>
                                        <div id="botones">  <!-- Botones para vaciar, borrar y modificar -->
                                            <form method="post" action="modificacion.jsp" id="borrar-form"> <!-- modificar grupo -->
                                                <input type="hidden" id="idgrupo" name="idgrupo" value="<%= g.getId() %>">
                                                <input type="hidden" id="alumno" name="alumno" value="false">
                                                <button type="submit" id="modificar">
                                                    <div class="boton-img"><img src="assets/img/edit.png" > </div>
                                                </button>
                                            </form>
                                        <% if (alumnos.size() == 0) { %>
                                            <form method="post" action="grupos.jsp" id="borrar-form"> <!-- borrar grupo -->
                                                <input type="hidden" id="idg" name="idg" value="<%= g.getId() %>">
                                                <button type="submit" id="borrar">
                                                    <div class="boton-img"><img src="assets/img/trash-can.png" > </div>
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <form method="post" action="grupos.jsp" id="borrar-form"> <!-- borrar grupo -->
                                                <input type="hidden" id="idgr" name="idgr" value="<%= g.getId() %>">
                                                <button type="submit" id="vaxiar">
                                                    <div class="boton-img"><img src="assets/img/empty-trash-can.png" > </div>
                                                </button>
                                            </form>
                                        <% } %>
                                        </div>
                                        </td>
                                    </tr><%
                                }
                            } 
                        }
                    %>
                </table>
            </div> <!-- table-container -->
        </div> <!-- list-gru -->
    </div> <!-- pagina -->
    <%
        pool.closeAll();
    %>
</body>
</html>