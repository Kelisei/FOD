program toTxt;
type
    acceso = record
        anio:integer;
        mes:integer;
        dia:integer;
        idUsuario: integer;
        tiempoAcceso:integer;
    end;
    archivo = file of acceso;
var 
    arch:archivo; txt:text; actual:acceso;
begin
    Assign(arch, 'accesos.dat'); Assign(txt, 'accesos.txt');
    Rewrite(arch); Reset(txt);
    while not eof(txt) do begin
        readln(txt, actual.anio);
        readln(txt, actual.mes);
        readln(txt, actual.dia);
        readln(txt, actual.idUsuario);
        readln(txt, actual.tiempoAcceso);
        Write(arch, actual);
    end;
    Close(arch);
end.