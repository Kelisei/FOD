program ej6;
{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas
}
type
    datoMae = record
        cod:integer;
        descripccion:string;
        colores:string;
        tipo:string;
        stock:integer;
        precio:real;
    end;
    maestro = file of datoMae;
    detalle = file of Integer;
procedure generarMaestro(var mae:maestro);
var
    txt:text; reg:datoMae;
begin
    Assign(mae, 'mae');
    Rewrite(mae);
    Assign(txt, 'mae.txt');
    Reset(txt);
    while(not eof (txt)) do begin
        ReadLn(txt, reg.cod);
        Readln(txt, reg.descripccion);
        Readln(txt, reg.colores);
        Readln(txt, reg.tipo);
        Readln(txt, reg.stock);
        Readln(txt, reg.precio);
        Write(mae, reg);
    end;
    Close(mae);
    Close(txt);
    WriteLn('Generado el maestro');
end;
procedure generarDetalle(var det:detalle);
var
    i:Integer;
begin
    Assign(det, 'det');
    Rewrite(det);
    for i:= 1 to 10 do begin
        if (i mod 2 = 0) then 
            write(det, i);
    end;
    Close(det);
    WriteLn('Generado el detalle');
end;
procedure leer(var det:detalle; var aux:Integer);
begin
    if not eof(det) then
      read(det, aux)
    else aux:=9999;
end;
procedure bajaLogica(var mae:maestro; var det:detalle);
var
    reg:datoMae; aux:integer;
begin   
    Reset(mae); Reset(det);
    leer(det, aux);
    while(aux <> 9999) do begin
        read(mae, reg);
        while(aux <> reg.cod) do read(mae, reg);
        Seek(mae, FilePos(mae)-1);
        reg.cod:= reg.cod * -1;
        Write(mae, reg); 
        Seek(mae, 0);
        leer(det, aux);        
    end;
    Close(mae); Close(det);
    WriteLn('Baja logica realizada');
end;
procedure compactacion(var mae:maestro; var reemplazo:maestro);
var
    aux:datoMae;
begin
    Assign(reemplazo, 'maestro');
    Reset(mae); Rewrite(reemplazo);
    while (not eof (mae)) do begin
        read(mae, aux);
        if(aux.cod > 0) then
            write(reemplazo, aux);
    end;
    Close(mae);
    Erase(mae); Close(reemplazo);
end;
procedure listar(var mae:maestro);
var
    aux:datoMae;
begin
    Reset(mae);
    while not eof(mae) do begin
        Read(mae,aux);
        WriteLn(aux.cod, ' ', aux.descripccion);
    end;
    Close(mae);
end;
var
    det:detalle; mae, compactao:maestro;
begin
    generarMaestro(mae);
    generarDetalle(det);
    listar(mae);
    bajaLogica(mae, det);
    listar(mae);
    compactacion(mae, compactao);
    listar(compactao);
end.