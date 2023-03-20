<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión principal</title>
        <link rel="stylesheet" href="assets/css/indexstyle.css" type="text/css">
    </head>
    <body>
        <div class="pagina">
            <div class="titulo">
                <h1>PÁGINA PRINCIPAL</h1>
            </div>
            <div class="botones">
                <form method="post" action="alumnos.jsp">
                    <button type="submit">
                        <div class="imagen"><img src="assets/img/estudiante.png"></div>
                        <p>Ir a gestión de alumnos</p>
                    </button>    
                </form>
                <br>
                <form method="post" action="grupos.jsp">
                    <button type="submit">
                        <div class="imagen"><img src="assets/img/grupo.png"></div>
                        <p>Ir a gestión de grupos</p>
                    </button>    
                </form>
            </div>
        </div> 
    </body>
</html>