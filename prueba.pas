program prueba;
const
    df = 15;
type
    alumno = record
        nombre:string;
        apellido:string;
        legajo:string;
        dni:string;
        promedio:real;
    end;
    alumnos = array [1..df] of alumno;
var
    i:integer; vector:alumnos;
begin
    for i:= 1 to df do
        vector[i].promedio:=0;
end.