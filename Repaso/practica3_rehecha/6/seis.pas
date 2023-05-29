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
que no fueron borradas, una vez realizadas todas las bajas físicas}
program seis; 
type
    prenda = record
        cod_prenda:integer;
        descripcion:string;
        colores:string;
        tipo_prenda:string;
        stock:integer;
        precio_unitario:real;
    end;
    archivo = file of prenda;
    bajas = file of integer;
procedure Eliminacion(var arch:archivo;var archBajas:bajas);
var
    codigo:integer; actual:prenda; encontre:Boolean;
begin
    Reset(arch); Reset(archBajas);
    while not eof(archBajas) do begin
        read(archBajas, codigo);
        encontre:=False;
        while((not eof (arch)) and (not encontre)) do begin
            read(arch, actual);
            encontre := (actual.cod_prenda = codigo);
        end;
        actual.cod_prenda := -1;
        Seek(arch, FilePos(arch)-1);
        Write(arch, actual);
        Seek(arch, 0);
    end;
    Close(arch); Close(archBajas);
end;
procedure Compactacion(var arch:archivo; var nuevo:archivo);
var
    actual:prenda;
begin
    Reset(arch); Rewrite(nuevo);    
    while(not eof (arch)) do begin
        read(arch, actual);
        if(actual.cod_prenda > 0) then write(nuevo, actual);
    end;
    Close(arch); Close(nuevo); 
    Erase(arch); Rename(nuevo, 'maestro.dat');
end;
var
    maestro, nuevo:archivo; detalle:bajas;
begin
    Assign(maestro, 'maestro.dat'); Assign(detalle, 'bajas.dat'); Assign(nuevo, 'compactado.dat');
    Eliminacion(maestro, detalle);
    Compactacion(maestro, nuevo);
end.