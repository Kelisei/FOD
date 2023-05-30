{17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.}
program diecisiete;
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
procedure Leer(var arch:detalle; var aux:motoVenta);
begin
    if(not eof(arch)) then read(arch, aux)
    else aux.codigo:=9999;
end;
procedure Minimo(var arrDetalle:vectorDetalle; var arrRegistros:vectorRegistro; var min:motoVenta);
var
    i, pos:integer; 
begin
    min.codigo:=9999;
    for i:= 1 to 10 do begin
        if(arrRegistros[i].codigo < min.codigo) then begin
            min:=arrRegistros[i];
            pos:=i;
        end;
    end;
    if(min.codigo <> 9999) then Leer(arrDetalle[pos], arrRegistros[pos]);
end;
procedure Resolucion();
var 
    arrRegistros:vectorRegistro; arrDetalle:vectorDetalle; mae:maestro; 
    i:Integer; iString:string; min:motoVenta; actual, masVendida:moto; ventasTotales, maxVentas:integer;
begin
    Assign(mae, 'maestro'); Reset(mae);
    for i:= 1 to 10 do begin
        Str(i,iString);
        Assign(arrDetalle[i],('detalle'+iString));
        Reset(arrDetalle[i]);
        Leer(arrDetalle[i], arrRegistros[i]);
    end;
    Minimo(arrDetalle, arrRegistros, min);
    maxVentas:=-1;
    writeln(min.codigo);
    while(min.codigo <> 9999) do begin
        Read(mae, actual);
        while(actual.codigo <> min.codigo) do Read(mae, actual);
        ventasTotales:=0;
        writeln('ACTUAL');
        writeln(actual.codigo);
        writeln(actual.nombre);
        while(actual.codigo = min.codigo) do begin
            ventasTotales:=ventasTotales+1;
            Minimo(arrDetalle, arrRegistros, min);
        end;
        if(ventasTotales > maxVentas) then begin
            maxVentas:=ventasTotales;
            masVendida:=actual;
        end;
        actual.stock:=ventasTotales;
        Seek(mae, FilePos(mae)-1);
        Write(mae, actual);
        writeln('en while');
    end;
    Writeln('La moto mas vendida fue:', masVendida.codigo, ' ',masVendida.nombre);
end;
begin
    Resolucion();
end.