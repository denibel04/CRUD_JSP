package matricula;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class MatriculaService {
    Connection conn;
    public MatriculaService(Connection conn) {
        this.conn = conn;
    }

    public String requestGrupo(int idAlumno) throws SQLException{
        Statement statement = null;
        String result = null;
        statement = this.conn.createStatement();    
        String sql = String.format("SELECT nombreGrupo FROM alumnos al JOIN grupos gr ON al.idGrupo=gr.idGrupo WHERE al.id = %d", idAlumno);
        // Ejecución de la consulta
        ResultSet querySet = statement.executeQuery(sql);
        // Recorrido del resultado de la consulta
        if(querySet.next()) {
            String nombreGrupo = querySet.getString("nombreGrupo");
            result = nombreGrupo;
        } else if (result==null){
            result = "null";
        }
        statement.close();    
        return result;
    }

    public int addToGroup(int id, int idGrupo) throws SQLException{
        Statement statement = null;
        statement = this.conn.createStatement();    
        String sql = String.format("UPDATE alumnos SET idGrupo = %d WHERE id = %d", idGrupo, id);
        // Ejecución de la consulta
        int affectedRows = statement.executeUpdate(sql);
        statement.close();
        if (affectedRows == 0)
            throw new SQLException("Assigning group failed, no rows affected.");
        else
            return affectedRows;
    
    }

    public int deleteGroup(int id) throws SQLException{
        Statement statement = null;
        statement = this.conn.createStatement();    
        String sql = String.format("UPDATE alumnos SET idGrupo = NULL WHERE id = %d", id);
        // Ejecución de la consulta
        int affectedRows = statement.executeUpdate(sql);
        statement.close();
        if (affectedRows == 0)
            throw new SQLException("Assigning group failed, no rows affected.");
        else
            return affectedRows;
    
    }

}
