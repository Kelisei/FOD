program ej4;
// 4. Dada la siguiente estructura:
// type
// reg_flor = record
// nombre: String[45];
// codigo:integer;
// tArchFlores = file of reg_flor;
// Las bajas se realizan apilando registros borrados y las altas reutilizando registros
// borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
// número 0 en el campo código implica que no hay registros borrados y -N indica que el
// próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
// a. Implemente el siguiente módulo:
// {Abre el archivo y agrega una flor, recibida como parámetro
// manteniendo la política descripta anteriormente}
// procedure agregarFlor (var a: tArchFlores ; nombre: string;
// codigo:integer);
// b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
// considere necesario para obtener el listado.
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;
    tArchFlores = file of reg_flor;
procedure generarMaestro(var mae:tArchFlores);
var
    txt:text; reg:reg_flor;
begin
    Assign(mae, 'mae');
    Rewrite(mae);
    Assign(txt, 'mae.txt');
    Reset(txt);
    while(not eof (txt)) do begin
        ReadLn(txt, reg.nombre);
        Readln(txt, reg.codigo);
        Write(mae, reg);
        Writeln('Flor:', reg.nombre,' ', reg.codigo);
    end;
    Close(mae);
    Close(txt);
end;
procedure agregarFlor(var a:tArchFlores; nombre:string; codigo:integer);
var
    cabecera, flor:reg_flor;
begin
    flor.nombre:=nombre; flor.codigo:=codigo;
    Reset(a);
    WriteLn(FileSize(a));
    Read(a, cabecera);
    if(cabecera.codigo = 0) then begin
        Writeln('No hay espacio vacio, agregando al final');
        Seek(a, FileSize(a));
        Write(a, flor);
    end else begin
        Writeln('Añadiendo en un espacio vacio');
        Seek(a, (cabecera.codigo * -1));
        Read(a, cabecera);
        Seek(a, FilePos(a)-1);
        Write(a, flor);
        Seek(a, 0);
        Write(a, cabecera);
        Writeln('Agregado con exito en un espacio vacio');
    end;
    Close(a);
end;
procedure listar(var mae:tArchFlores);
var
    aux:reg_flor;
begin
    Reset(mae);
    While not eof(mae) do begin
        Read(mae, aux);
        if(aux.codigo > 0) then
            Writeln('FLOR, nombre:', aux.nombre, ' codigo:', aux.codigo);
    end;
    Close(mae);
end;
var
    mae:tArchFlores; nombre:string; codigo:integer;
begin
    generarMaestro(mae);
    Writeln('Introduzca un codigo de flor:');
    Readln(nombre); 
    Writeln('Introduzca un nombre de flor:');
    Readln(codigo);
    agregarFlor(mae, nombre, codigo);
    listar(mae);
end.