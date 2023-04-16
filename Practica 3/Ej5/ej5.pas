program ej5;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;
    tArchFlores = file of reg_flor;
{Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente}
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
    cabecera, reg:reg_flor; encontrado:Boolean;
begin
    Reset(a);
    encontrado := False;
    read(a, cabecera);
    while (not eof(a)) and (not encontrado)do begin
        read(a, reg);
        if(reg.codigo = flor.codigo) and (reg.nombre = flor.nombre) then encontrado:=True;
    end;
    if (encontrado) then begin
        Seek(a, FilePos(a)-1);
        reg.codigo:=FilePos(a)*-1;
        Write(a, cabecera);
        Seek(a, 0);
        Write(a, reg);
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
        Writeln('FLOR, nombre:', aux.nombre, ' codigo:', aux.codigo);
    end;
    Close(mae);
end;
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
    end;
    Close(mae);
    Close(txt);
end;
var
    mae:tArchFlores;
    flor: reg_flor;
begin
    generarMaestro(mae);
    listar(mae);
    ReadLn(flor.nombre);
    ReadLn(flor.codigo);
    eliminarFlor(mae, flor);
    ReadLn(flor.nombre);
    ReadLn(flor.codigo);
    eliminarFlor(mae, flor);
    listar(mae);
end.