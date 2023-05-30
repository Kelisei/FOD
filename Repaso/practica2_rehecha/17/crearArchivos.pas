program crearArchivos;
type
    moto = record
        codigo:integer;
        nombre:string;
        descripcion:string;
        modelo:string;
        marca:string;
        stock:integer;
    end;
    motoVenta = record
        codigo:Integer;
        precio:real;
        fecha:string;
    end;
    detalle = file of motoVenta;
    maestro = file of moto;
    vectorDetalle = array [1..10] of detalle;
    vectorRegistro = array [1..10] of motoVenta;
procedure CrearMaestro();
var
    aux:moto; txt:text; m:maestro;
begin
    Assign(m, 'maestro');
    Rewrite(m);
    Assign(txt, 'maestro.txt');
    Reset(txt);
    while (not eof(txt)) do begin
        ReadLn(txt, aux.codigo);
        ReadLn(txt, aux.nombre);
        ReadLn(txt, aux.modelo);
        ReadLn(txt, aux.descripcion);
        ReadLn(txt, aux.marca);
        ReadLn(txt, aux.stock);
        Write(m, aux);
    end;
    Close(m);
    Close(txt);
    WriteLn('Maestro creados con exito');
end;
procedure CrearDetalle();
var
    i:integer; iStr: string; aux:motoVenta; txt:text; dets:vectorDetalle;
begin
    for i:= 1 to 10 do begin
        Str(i, iStr);
        Assign(dets[i], ('detalle'+iStr));
        Rewrite(dets[i]);
    end;
    Assign(txt, 'detalle.txt');
    Reset(txt);
    while (not eof(txt)) do begin
        ReadLn(txt, aux.codigo);
        ReadLn(txt, aux.precio);
        Readln(txt, aux.fecha);
        for i:= 1 to 10 do
            Write(dets[i], aux);
    end;
    for i:= 1 to 10 do 
        Close(dets[i]);
    Close(txt);
    WriteLn('Detalles creados con exito');
end;
begin
    CrearDetalle();
    CrearMaestro();
end.