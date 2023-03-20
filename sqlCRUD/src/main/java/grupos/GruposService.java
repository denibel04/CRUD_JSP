package grupos;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class GruposService {
    Connection conn;
    public GruposService(Connection conn) {
        this.conn = conn;
    }

    public ArrayList<Grupo> requestAll() throws SQLException{
        Statement statement = null;
        ArrayList<Grupo> result = new ArrayList<Grupo>();
        statement = this.conn.createStatement();   
        String sql = "SELECT idGrupo, nombreGrupo, profesor FROM grupos";
        // Ejecución de la consulta
        ResultSet querySet = statement.executeQuery(sql);
        // Recorrido del resultado de la consulta
        while(querySet.next()) {
            int idGrupo = querySet.getInt("idGrupo");
            String nombreGrupo = querySet.getString("nombreGrupo");
            String profesor = querySet.getString("profesor");
            result.add(new Grupo(idGrupo, nombreGrupo, profesor));
        } 
        statement.close();    
        return result;
    }

    public Grupo requestById(int id) throws SQLException{
        Statement statement = null;
        Grupo result = null;
        statement = this.conn.createStatement();    
        String sql = String.format("SELECT idGrupo, nombreGrupo, profesor FROM grupos WHERE id=%d", id);
        // Ejecución de la consulta
        ResultSet querySet = statement.executeQuery(sql);
        // Recorrido del resultado de la consulta
        if(querySet.next()) {
            String nombreGrupo = querySet.getString("nombreGrupo");
            String profesor = querySet.getString("profesor");
            result = new Grupo(id, nombreGrupo, profesor);
        }
        statement.close();    
        return result;
    }

    public long create(String nombre, String profesor) throws SQLException{
        Statement statement = null;
        statement = this.conn.createStatement();
        String sql = String.format("INSERT INTO grupos (nombreGrupo, profesor) VALUES ('%s', '%s')", nombre,profesor);
        // Ejecución de la consulta
        int affectedRows = statement.executeUpdate(sql,Statement.RETURN_GENERATED_KEYS);
        if (affectedRows == 0) {
            throw new SQLException("Creating user failed, no rows affected.");
        }
        try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                long id = generatedKeys.getLong(1);
                statement.close();
                return id;
            }
            else {
                statement.close();
                throw new SQLException("Creating user failed, no ID obtained.");
            }
        }
    }
    
    public int update(int id, String cambio, String opcion) throws SQLException{
        Statement statement = null;
        statement = this.conn.createStatement();    
        String sql = String.format("UPDATE grupos SET %s = '%s' WHERE idGrupo=%d", opcion, cambio, id);
        // Ejecución de la consulta
        int affectedRows = statement.executeUpdate(sql);
        statement.close();
        if (affectedRows == 0)
            throw new SQLException("Creating user failed, no rows affected.");
        else
            return affectedRows;
    }

    public boolean delete(long id) throws SQLException{
        Statement statement = null;
        statement = this.conn.createStatement();    
        String sql = String.format("DELETE FROM grupos WHERE idGrupo=%d", id);
        // Ejecución de la consulta
        int result = statement.executeUpdate(sql);
        statement.close();
        return result==1;
    }

    public ArrayList<Grupo> buscarGrupos(String busqueda) throws SQLException {
        Statement statement = null;
        statement = this.conn.createStatement();  
        ArrayList<Grupo> result = new ArrayList<Grupo>();
        String sql = String.format("SELECT idGrupo, nombreGrupo, profesor FROM grupos WHERE nombreGrupo LIKE '%%%s%%' OR profesor LIKE '%%%s%%'", busqueda, busqueda);
        // Ejecución de la consulta
        ResultSet querySet = statement.executeQuery(sql);
        // Recorrido del resultado de la consulta
        while(querySet.next()) {
            int idGrupo = querySet.getInt("idGrupo");
            String nombreGrupo = querySet.getString("nombreGrupo");
            String profesor = querySet.getString("profesor");
            result.add(new Grupo(idGrupo, nombreGrupo, profesor));
        } 
        statement.close();    
        return result;
    }

}
