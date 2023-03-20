package matricula;

import alumnos.Alumno;
import grupos.Grupo;

public class Matricula {
    Alumno alu;
    Grupo grupo;
    public Matricula(Alumno alu, Grupo grupo) {
        this.alu = alu;
        this.grupo = grupo;
    }

    public Alumno getAlu() {
        return alu;
    }

    public void setAlu(Alumno alu) {
        this.alu = alu;
    }

    public Grupo getGrupo() {
        return grupo;
    }
    
    public void setGrupo(Grupo grupo) {
        this.grupo = grupo;
    }
}


