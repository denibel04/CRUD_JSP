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
    <title>Gestión alumos</title>
</head>
<body>
    <%
    // Configuración de la conexión a la base de datos
    String url = "jdbc:mysql://localhost:3306/alumnos";
    String usuario = "deni";
    String clave = "12345";

    ConnectionPool pool = new ConnectionPool(url, usuario, clave);

    // Conexión a la base de datos
    AlumnosService aservice = new AlumnosService(pool.getConnection());
    MatriculaService mservice = new MatriculaService(pool.getConnection());
    GruposService gservice = new GruposService(pool.getConnection());

    // Definicion de variables:
    Boolean agregar = false;
    Boolean borrar = false;
    String opcion = "1";

    

    // Borrar un alumno
    if (request.getParameter("idalu") != null) {
        Long idAlumno = Long.parseLong(request.getParameter("idalu"));
        aservice.delete(idAlumno);
    }

    // Cambia el nombre 
    if (request.getParameter("nombremod")!=null && !request.getParameter("nombremod").equalsIgnoreCase("")) {
        String nombre = request.getParameter("nombremod");
        Integer id = Integer.parseInt(request.getParameter("idmod"));
        aservice.update(id, nombre, "nombre");
    }

    // Cambia el apellido
    if (request.getParameter("apellidomod")!=null && !request.getParameter("apellidomod").equalsIgnoreCase("")) {
        String apellido = request.getParameter("apellidomod");
        Integer id = Integer.parseInt(request.getParameter("idmod"));
        aservice.update(id, apellido, "apellidos");
    } 

    // Matricula o cambia de grupo a un alumno 
    if (request.getParameter("idalumno")!=null && request.getParameter("matricula")!=null) {
        Integer idalumn = Integer.parseInt(request.getParameter("idalumno"));
        if (!request.getParameter("matricula").equalsIgnoreCase("null")) {
            Integer idGrupo = Integer.parseInt(request.getParameter("matricula"));
            mservice.addToGroup(idalumn, idGrupo);
        } else if (request.getParameter("matricula").equalsIgnoreCase("null")) {
            mservice.deleteGroup(idalumn);
        }
    }

    %>
    <div class="pagina">
        <div class="new"> <!-- Agregar un nuevo alumno -->
            <div class="imagen"> <img src="assets/img/estudiante.png"> </div>
            <div class="new-botones"> 
                <form method="post" action="alumnos.jsp">
                    <label for="nombre">Nombre:</label>
                    <input type="text" id="nombre" name="nombre">
                    <br>
                    <label for="apellidos">Apellidos:</label>
                    <input type="text" id="apellidos" name="apellidos">
                    <br>
                    <input type="hidden" id="agregarb" name="agregarb" value="true">
                    <button type="submit" id="agregar">Añadir alumno</button><br>
                </form>
                <%
                // Agregar un alumno
                agregar = Boolean.parseBoolean(request.getParameter("agregarb"));
                if (agregar) {
                    String nombre = request.getParameter("nombre");
                    String apellidos = request.getParameter("apellidos");
                    if (nombre == null || apellidos == null || nombre.equalsIgnoreCase("") || apellidos.equalsIgnoreCase("") ) {
                        out.println("No puedes crear un alumno con campos vacíos");
                    } else {
                        aservice.create(nombre, apellidos);
                    }
                }
                %>
                <!-- Matricular / desmatricular un alumno -->
                <details> 
                    <summary>Gestión de matricula</summary>
                    <br>
                    <form method="post" action="alumnos.jsp" >
                        <label for="idalumno">Introduzca el id:</label>
                        <input type="text" id="idalumno" name="idalumno">
                        <%
                        ArrayList<Grupo> grupos = gservice.requestAll();
                        if(grupos.size()==0){
                            out.println("No hay grupos");
                        } else{
                            int i = 1;
                            for(Grupo g : grupos){ 
                                out.print(String.format("<label for=\"grupo\"><input type=\"radio\" id=\"opcion%d\" name=\"matricula\" value=\"%s\">%s</label><br>", i, g.getId(), g.getNombre()));
                            i++;
                            }
                        }
                        %>
                        <label for="desmatricular"><input type="radio" id="opcion2" name="matricula" value="null">Desmatricular</label> 
                        <br><br>
                        <button type="submit">Enviar</button>
                    </form>
                </details>
            </div>
        </div>
        <div class="table">
            <div class="redireccionar"> 
                <form method="post" action="index.jsp">
                    <button type="submit"> volver </button>    
                </form>
                <form method="post" action="grupos.jsp">
                    <button type="submit"> grupos </button>    
                </form>
            </div> 
            <div class="titulo">
                <h1>GESTIÓN DE ALUMNOS</h1>
            </div>
            <form method="post" action="alumnos.jsp">
                <label for="buscar">Buscar ... </label>
                <input type="text" id="buscar" name="buscar" placeholder="Introduzca nombre o apellido">
                <button type="submit">Enviar</button>
            </form>
            <details> <!-- Muestra las opciones para filtrar por grupo -->
                <summary>Filtrar por grupo</summary>
                <br>
                <form method="post" action="alumnos.jsp" >
                    <label for="todos"><input type="radio" id="opcion1" name="opcion" value="1">Todos</label><br>
                    <label for="sinasignar"><input type="radio" id="opcion2" name="opcion" value="2">Sin asignar</label><br>
                    <%
                    grupos = gservice.requestAll();
                    if(grupos.size()==0){
                        out.println("No hay grupos");
                    } else{
                        int i = 2;
                        for(Grupo g : grupos){ 
                            out.print(String.format("<label for=\"grupo\"><input type=\"radio\" id=\"opcion%d\" name=\"opcion\" value=\"%s\">%s</label><br>", i, g.getNombre(), g.getNombre()));
                        }
                    }
                    %><br>
                    <button type="submit">Enviar</button>
                </form>
            </details>
            <br>
            <div class="table-container"> <!-- Muestra la tabla de los alumnos -->
                <table class="">
                <tr>
                    <th> ID </th>
                    <th> NOMBRE </th>
                    <th> APELLIDOS </th>
                    <th> GRUPO </th>
                </tr>
                <% 
                String busqueda = request.getParameter("buscar");
                opcion = request.getParameter("opcion");
                if ( opcion == null && busqueda == null) {
                    opcion = "1";
                } else if (opcion == null && busqueda!=null){
                    opcion= "busqueda";
                } else if (opcion != null) {
                    opcion = request.getParameter("opcion");
                }
                ArrayList<Alumno> alumnos = aservice.requestAll();
                if(alumnos.size()==0){
                    out.println("No hay alumnos registrados");
                } else if ( !opcion.equalsIgnoreCase("busqueda")) { // filtrar alumnos por grupos
                    for(Alumno a : alumnos) {
                        %><tr> <% 
                        if (opcion == null  || opcion.equalsIgnoreCase("1")) { // muestra todos los alumnos
                            out.print(a);
                                if (!mservice.requestGrupo((int)(a.getId())).equalsIgnoreCase("null")) {
                                    out.print(String.format("<td>%s</td>", mservice.requestGrupo((int)(a.getId()))));
                                } else {
                                    out.print("<td>Sin asignar</td>");
                                }%>
                                <td>
                                    <div id="botones">  <!-- Botones para borrar y modificar -->
                                        <form method="post" action="modificacion.jsp" id="borrar-form"> <!-- modificar alumno -->
                                            <input type="hidden" id="idalum" name="idalum" value="<%= a.getId() %>">
                                            <input type="hidden" id="alumno" name="alumno" value="true">
                                            <button type="submit" id="modificar">
                                            <div class="boton-img"><img src="assets/img/edit.png" > </div>
                                            </button>
                                        </form>
                                        <form method="post" action="alumnos.jsp" id="borrar-form"> <!-- borrar alumno -->
                                            <input type="hidden" id="idalu" name="idalu" value="<%= a.getId() %>">
                                            <button type="submit" id="borrar">
                                            <div class="boton-img"><img src="assets/img/trash-can.png" > </div>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr><%
                        } else if (opcion.equalsIgnoreCase("2") && (mservice.requestGrupo((int)(a.getId())).equalsIgnoreCase("null"))) { // muestra los alumnos sin grupo
                            out.print(a);
                            out.print("<td>Sin asignar</td>");%>
                                    <td>
                                        <div id="botones">  <!-- Botones para borrar y modificar -->
                                            <form method="post" action="modificacion.jsp" id="borrar-form"> <!-- modificar alumno -->
                                                <input type="hidden" id="idalum" name="idalum" value="<%= a.getId() %>">
                                                <input type="hidden" id="alumno" name="alumno" value="true">
                                                <button type="submit" id="modificar">
                                                <div class="boton-img"><img src="assets/img/edit.png" > </div>
                                                </button>
                                            </form>
                                            <form method="post" action="alumnos.jsp" id="borrar-form"> <!-- borrar alumno -->
                                                <input type="hidden" id="idalu" name="idalu" value="<%= a.getId() %>">
                                                <button type="submit" id="borrar">
                                                <div class="boton-img"><img src="assets/img/trash-can.png" > </div>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                    </tr><%
                        } else if(mservice.requestGrupo((int)(a.getId())).equalsIgnoreCase(opcion)) {
                            out.print(a);
                            out.print(String.format("<td>%s</td>", mservice.requestGrupo((int)(a.getId()))));
                            %>
                                <td>
                                    <div id="botones">  <!-- Botones para borrar y modificar -->
                                        <form method="post" action="modificacion.jsp" id="borrar-form"> <!-- modificar alumno -->
                                            <input type="hidden" id="idalum" name="idalum" value="<%= a.getId() %>">
                                            <input type="hidden" id="alumno" name="alumno" value="true">
                                            <button type="submit" id="modificar">
                                                <div class="boton-img"><img src="assets/img/edit.png" > </div>
                                            </button>
                                        </form>
                                        <form method="post" action="alumnos.jsp" id="borrar-form"> <!-- borrar alumno -->
                                            <input type="hidden" id="idalu" name="idalu" value="<%= a.getId() %>">
                                            <button type="submit" id="borrar">
                                                <div class="boton-img"><img src="assets/img/trash-can.png" > </div>
                                            </button>
                                        </form>
                                    </div>
                                    </td>
                                    </tr><%
                            }
                        } 
                } else if (opcion.equalsIgnoreCase("busqueda")) {
                            ArrayList<Alumno> buscados = aservice.buscarAlumnos(busqueda);
                            if (buscados.size()==0) {
                                out.print("No hay alumnos con ese nombre o apellido :(");
                            } else {
                                for (Alumno a : buscados) {
                                    out.print(a);
                                        if (!mservice.requestGrupo((int)(a.getId())).equalsIgnoreCase("null")) {
                                            out.print(String.format("<td>%s</td>", mservice.requestGrupo((int)(a.getId()))));
                                        } else {
                                            out.print("<td>Sin asignar</td>");
                                        }
                                        %>
                                        <td>
                                            <div id="botones">  <!-- Botones para borrar y modificar -->
                                                <form method="post" action="modificacion.jsp" id="borrar-form"> <!-- modificar alumno -->
                                                    <input type="hidden" id="idalum" name="idalum" value="<%= a.getId() %>">
                                                    <input type="hidden" id="alumno" name="alumno" value="true">
                                                    <button type="submit" id="modificar">
                                                    <div class="boton-img"><img src="assets/img/edit.png" >
                                                    </button>
                                                </form>
                                                <form method="post" action="alumnos.jsp" id="borrar-form"> <!-- borrar alumno -->
                                                    <input type="hidden" id="idalu" name="idalu" value="<%= a.getId() %>">
                                                    <button type="submit" id="borrar">
                                                    <div class="boton-img"><img src="assets/img/trash-can.png" >
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr> <%
                        }  
                    } // cierre if else
                } 
                
                %>
                </table>
            </div> <!-- table-container -->
        </div> <!-- list-alu -->
    </div> <!-- pagina -->
    <%
        pool.closeAll();
    %>

</body>
</html>