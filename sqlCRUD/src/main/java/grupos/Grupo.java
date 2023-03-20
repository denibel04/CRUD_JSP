package grupos;

public class Grupo {
    long idGrupo;
    String nombreGrupo;
    String profesor;

    public Grupo(){
        this(0,"", "");
    }

    public Grupo (long id, String nombre, String profesor) {
        this.idGrupo = id;
        this.nombreGrupo = nombre;
        this.profesor = profesor;
    }

    public Grupo (int id, String nombre, String profesor) {
        this.idGrupo = id;
        this.nombreGrupo = nombre;
        this.profesor = profesor;
    }

    public long getId() {
        return idGrupo;
    }

    public void setId(long id) {
        this.idGrupo = id;
    }

    public String getNombre() {
        return nombreGrupo;
    }

    public void setNombre(String nombre) {
        this.nombreGrupo = nombre;
    }

    public String getProfesor() {
        return profesor;
    }

    public void setProfesor(String profesor) {
        this.profesor = profesor;
    }

    @Override
    public String toString() {
        return String.format("<td>%s</td><td>%s</td><td>%s</td>", this.idGrupo, this.nombreGrupo, this.profesor);
    }
}
