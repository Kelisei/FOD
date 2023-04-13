program ej2;
{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}
type
    asistente = record
        nro:Integer;
        apellido:String;
        nombre: String;
        email: String;
        tel: String;
        dni: String;
    end;
    maestro = file of asistente;

procedure LeerAsistente(var registro: asistente);
begin
    with registro do begin
        WriteLn('Numero de asistente:');
        {nro := random(1100) - 100;
        WriteLn(nro);}
        ReadLn(nro);
        if(nro >= 0) then begin
            WriteLn('Apellido de asistente:');
            ReadLn(apellido);
            WriteLn('Nombre de asistente:');
            ReadLn(nombre);
            WriteLn('Email de asistente:');
            ReadLn(email); email:= email + '@gmail.com';
            WriteLn('Telefono de asistente:');
            Readln(tel);
            WriteLn('DNI de asistente:');
            ReadLn(dni);
        end;
    end;
end;
procedure GenerarDatos(var mae: maestro);
var
    registro:asistente;
begin
    Rewrite(mae);
    LeerAsistente(registro);
    while(registro.nro >= 0) do begin
        Write(mae, registro);
        LeerAsistente(registro);
    end;
    Close(mae);
    WriteLn('Generacion completada');
end;
procedure MostrarDatos(var mae:maestro);
var
    registro:asistente;
begin
    Reset(mae);
    while not eof(mae) do begin
        read(mae, registro);
        writeln('Numero de asistente:',registro.nro);
        WriteLn('Nombre del asistente', registro.nombre);
        WriteLn('Dni del asistente: ', registro.dni);
        WriteLn('--------------------------------------')
    end;
    Close(mae);
end;
procedure EliminacionLogica(var mae:maestro);
var
    aux:asistente;
begin
    Reset(mae);
    while not eof(mae) do begin
        read(mae, aux);
        if(aux.nro < 1000) then begin
            aux.dni:= '@Saldaño';
            Seek(mae, FilePos(mae)-1);
            write(mae, aux);
        end;
    end;
    Close(mae);
end;
procedure Generar(var mae:maestro);
var 
    opcion: Char;
begin
    // Voy a dar la opción de crear el binario o no, para probar cosas más fácil:
    Writeln('Quiere crear el maestro devuelta? S/N');
    Readln(opcion);
    if(opcion = 'S') or (opcion = 's') then
        GenerarDatos(mae);
end;
var
    mae: maestro; 
begin
    Randomize;
    Assign(mae, 'maestro.dat');
    Generar(mae);
    MostrarDatos(mae);
    EliminacionLogica(mae);
    MostrarDatos(mae);
end.