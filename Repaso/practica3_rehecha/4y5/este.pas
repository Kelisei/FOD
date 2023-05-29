program este;
//   4. Dada la siguiente estructura:
//   type
//   reg_flor = record
//   nombre: String[45];
//   codigo:integer;
//   tArchFlores = file of reg_flor;
//   Las bajas se realizan apilando registros borrados y las altas reutilizando registros
//   borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
//   número 0 en el campo código implica que no hay registros borrados y -N indica que el
//   próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
//   a. Implemente el siguiente módulo:
//   {Abre el archivo y agrega una flor, recibida como parámetro
//   manteniendo la política descripta anteriormente}
//   procedure agregarFlor (var a: tArchFlores ; nombre: string;
//   codigo:integer);
//   b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
//   considere necesario para obtener el listado.
//   5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
//   {Abre el archivo y elimina la flor recibida como parámetro manteniendo
//   la política descripta anteriormente}
//   procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
type
    reg_flor = record  
        nombre: String[45];
        codigo:integer;
    end;
    tArchFlores = file of reg_flor;
procedure agregarFlor(var a:tArchFlores; nombre:String; codigo:integer);
var 
    nuevo, cabecera: reg_flor; 
begin
    Reset(a);
    Read(a, cabecera);
    if(cabecera.codigo < 0) then begin
        Seek(a, cabecera.codigo * -1);
        Read(a, cabecera);
        Seek(a, FilePos(a)-1);
        nuevo.nombre:=nombre;
        nuevo.codigo:=codigo;
        Write(a, nuevo);
        Seek(a, 0);
        Write(a, cabecera);
    end else WriteLn('No hay espacio mas capito');
    Close(a);
end;
procedure listar(var a:tArchFlores);
var
    actual:reg_flor;
begin
    Reset(a);
    while (not eof(a)) do begin
        read(a, actual);
        if(actual.codigo > 0) then
            WriteLn(actual.nombre,' ',actual.codigo);
    end;
    Close(a);
end;
procedure eliminarFlor(var a:tArchFlores; flor:reg_flor);
var
    actual, cabecera:reg_flor; encontre: Boolean;
begin
    Reset(a);
    read(a, cabecera);
    encontre:=False;
    while ((not eof(a)) and (not encontre)) do begin
        read(a, actual);
        if (actual.codigo = flor.codigo) then begin
            encontre:=True;
            Seek(a, FilePos(a)-1);
            Write(a, cabecera);
            cabecera.codigo:=actual.codigo*-1;
            Seek(a, 0);
            Write(a, cabecera);
        end;
    end;
    Close(a);
end;
begin

end.