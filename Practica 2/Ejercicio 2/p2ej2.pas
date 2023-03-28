{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}

program p2ej2;
const 
  valorAlto= 9999;
type
  nombres = String[30];
  alumno = record
    cod_alumno : Integer;
    apellido: nombres;
    nombre : nombres;
    mat_sf :Integer;
    mat_cf :Integer;
  end;
  alumno_detalle = record
    cod_alumno: integer;
    aprobadoFinal: integer;
  end;
  maestro = file of alumno;  
  detalle = file of alumno_detalle;

 Procedure crearArchivoMaestro(Var arch:maestro);
  Var 
    carga: text;
    alu:alumno;
  Begin
    assign(arch, 'maestro');
    assign(carga, 'maestro.txt');
    rewrite(arch);
    reset(carga);
    While (Not  eof(carga)) Do
      Begin
        readln(carga, alu.cod_alumno);
        readln(carga, alu.apellido);
        readln(carga, alu.nombre);
        readln(carga, alu.mat_sf);
        readln(carga, alu.mat_cf);
        write(arch, alu);
      End;
    writeln('Archivo Maestro cargado.');
    close(arch);
  End;
    Procedure crearArchivoDetalle(Var arch_logico:detalle);
    Var 
        carga: text;
        alumno: alumno_detalle;
    Begin
        assign(arch_logico, 'detalle');
        assign(carga, 'detalle.txt');
        rewrite(arch_logico);
        reset(carga);
        While (Not  eof(carga)) Do Begin
            readln(carga, alumno.cod_alumno, alumno.aprobadoFinal);
            {writeln('Alumno detalle: ','Codigo: ', alumno.cod_alumno, ' Aprobo:', alumno.aprobadoFinal);}
            write(arch_logico, alumno);
        End;
        writeln('Archivo Detalle cargado.');
        close(arch_logico);
    End;

 procedure leer(var det : detalle; var auxD:alumno_detalle);
  begin
    if not eof (det) then
      read (det,auxD)
    else
      auxD.cod_alumno:= valorAlto;
  end;
 

 procedure actualizarMaestro(var mae: maestro; var det : detalle);  //inciso A
 var
   auxD : alumno_detalle;
   auxM : alumno;
 begin
    assign(mae, 'maestro');
    assign(det, 'detalle');
    reset(mae);
    reset(det);
    leer(det, auxD);                        //Lees para saber si el detalle esta vacio
    while (auxD.cod_alumno <> valorAlto) do begin 
        read(mae, auxM);                    
        while(auxM.cod_alumno <> auxD.cod_alumno) do read(mae, auxM); //Lees el maestro hasta que llegue al codigo del alumno detalle que seguro existe
        while (auxM.cod_alumno = auxD.cod_alumno) do begin //Mientras sean el mismo acumulas aprobadas.
            if (auxD.aprobadoFinal = 1) then auxM.mat_cf := auxM.mat_cf +1
            else auxM.mat_sf := auxM.mat_sf +1;
            leer(det, auxD); 
        end;
        seek(mae, filepos(mae)-1);
        write(mae,auxM);
    end;
    close(mae);
    close(det);
 end;

 procedure listarMas4SinFinal(var mae :maestro);  //IncisoB 
  var
    aux : alumno;
  begin
    Assign(mae, 'maestro');
    Reset(mae);
    WriteLn('Listado de alumnos que deben +4 finales: ');
    while not eof (mae) do begin
      read (mae, aux);
      if (aux.mat_sf > 4) then
        with aux do
          WriteLn(' Cod: ',cod_alumno, ', nombre: ',nombre, ', apellido: ', apellido, ', Mat con final: ', mat_cf, ', Mat sin final: ', mat_sf);
    end;
    close(mae);
    WriteLn('----------------------------------------------------------------------------------');
  end;
var 
    mae: maestro; 
    det : detalle;
begin
      crearArchivoMaestro(mae);
      crearArchivoDetalle(det);
      actualizarMaestro(mae,det);
      listarMas4SinFinal(mae);
end.

{
    ⣿⣿⠿⠿⠿⠿⣿⣷⣂⠄⠄⠄⠄⠄⠄⠈⢷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣷⡾⠯⠉⠉⠉⠉⠚⠑⠄⡀⠄⠄⠄⠄⠄⠈⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡀⠄⠄⠄⠄⠄⠄⠄⠄⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⠎⠄⠄⣀⡀⠄⠄⠄⠄⠄⠄⠄⠘⠋⠉⠉⠉⠉⠭⠿⣿
    ⡀⠄⠄⠄⠄⠄⠄⠄⠄⡇⠄⣠⣾⣳⠁⠄⠄⢺⡆⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
    ⣿⣷⡦⠄⠄⠄⠄⠄⢠⠃⢰⣿⣯⣿⡁⢔⡒⣶⣯⡄⢀⢄⡄⠄⠄⠄⠄⠄⣀⣤⣶
    ⠓⠄⠄⠄⠄⠄⠸⠄⢀⣤⢘⣿⣿⣷⣷⣿⠛⣾⣿⣿⣆⠾⣷⠄⠄⠄⠄⢀⣀⣼⣿
    ⠄⠄⠄⠄⠄⠄⠄⠑⢘⣿⢰⡟⣿⣿⣷⣫⣭⣿⣾⣿⣿⣴⠏⠄⠄⢀⣺⣿⣿⣿⣿
    ⣿⣿⣿⣿⣷⠶⠄⠄⠄⠹⣮⣹⡘⠛⠿⣫⣾⣿⣿⣿⡇⠑⢤⣶⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣯⣤⣤⣤⣤⣀⣀⡹⣿⣿⣷⣯⣽⣿⣿⡿⣋⣴⡀⠈⣿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣝⡻⢿⣿⡿⠋⡒⣾⣿⣧⢰⢿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⣏⣟⣼⢋⡾⣿⣿⣿⣘⣔⠙⠿⠿⠿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⣛⡵⣻⠿⠟⠁⠛⠰⠿⢿⠿⡛⠉⠄⠄⢀⠄⠉⠉⢉
    ⣿⣿⣿⣿⡿⢟⠩⠉⣠⣴⣶⢆⣴⡶⠿⠟⠛⠋⠉⠩⠄⠉⢀⠠⠂⠈⠄⠐⠄⠄⠄


    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⢠⣶⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⡿⠋⣿⣿⣿⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⠁⠀⣿⣿⣿⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⡏⠀⠀⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⠁⠀⠀⠻⠛⠛⠛⠛⠛⠛⠻⠿⠿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⡿⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⣿⡻⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⠱⠆⠀⠀⢀⡀⠀⠀⠀⣀⣤⣤⣤⣤⣴⣼⣽⣯⣻⣿⣿⣷⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡇⠀⠀⠀⢀⣾⣿⣿⣿⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣷⣦⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠃⠀⠀⠀⣼⣿⣿⠏⢹⡀⠀⠀⠀⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣷⠀
⠀⠀⠀⣀⣤⣶⣶⣾⣿⣿⣿⣿⣿⡀⠀⠀⢠⣿⣿⣿⠀⠈⣷⡀⠀⠀⠈⠙⠒⠒⠒⠂⠀⠀⠀⠀⠀⠀⠈⣿⣿⡇
⠀⢠⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⡇⠀⠀⠘⢿⣿⣿⡀⠀⠈⠳⣦⣀⡀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠴⠞⣿⣿⡿
⠀⣾⣿⣿⠋⠀⠀⢀⣿⣿⣿⣿⣿⡇⠀⠀⠁⠸⣿⣿⣷⠀⠀⠀⠀⠉⠉⠙⠛⠛⠛⠛⠋⠉⠁⠀⠀⢀⣼⣿⣿⠃
⢠⣿⣿⣿⣤⣤⣶⣾⣿⣿⣿⣿⣿⡇⠀⠀⠀⢹⠻⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣿⣿⣿⠏⠀
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀
⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠈⠿⣽⣻⣿⣿⣿⣿⣿⣿⣿⣿⣻⣉⡉⣿⣿⣿⠄⠀⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣩⣿⣿⡿⠟⣿⣿⡏⢻⣿⣮⣹⢧⣿⣿⣿⡃⠀⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⡀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣹⣿⣿⣿⡇⠀⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣀⠀⠀⠀⠀⠀⠀⣿⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀
⢿⣿⣿⣿⣿⣿⣿⣏⠁⠉⢉⣹⡏⠉⠉⠉⡙⣿⠀⠀⠀⠀⠸⠉⣹⣿⣌⣩⣿⡏⠉⣽⠝⢻⣿⠿⠿⠿⠿⣿⣷⠀
⢸⣿⣿⣿⣿⣿⣿⣿⠀⠀⢸⣿⡇⢀⡀⠀⣿⡿⠷⠶⠶⠶⣶⠟⠉⢉⢉⠙⠙⠻⣾⣦⣴⣿⣿⠀⠀⠀⠀⣿⣿⠀
⠈⣿⣿⣿⣿⣿⣿⡿⠉⠉⠙⢻⡇⠀⠶⠤⡏⡇⠀⢤⠀⠀⣯⠠⠄⢈⣉⣁⣀⠷⢸⡏⠉⠀⢹⠀⠀⠀⠁⣿⡏⠀
⠀⢻⣿⣿⣿⣿⣿⣷⣀⣀⣀⣸⡇⠀⠀⠀⠈⣿⣶⣾⣷⣶⣿⣦⣤⣀⣀⣀⣠⣤⣿⣤⣬⣤⣼⠀⠀⠀⠀⣿⡇⠀
⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣾⣿⠃⠀
⠀⠀⠀⠈⠙⠛⠛⠛⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠈⠛⠛⠿⠿⠿⠿⠛⠛⠋⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠻⠿⠿⠿⠿⠿⠛⠉⠀⠀
}