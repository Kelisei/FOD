program Ej7;
{7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
    a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
        ● Ambos archivos están ordenados por código de producto.
        ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
        archivo detalle.
        ● El archivo detalle sólo contiene registros que están en el archivo maestro.
    b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
    stock actual esté por debajo del stock mínimo permitido.}
const
    valorAlto = 9999;
type
    //Registros:
    producto = record
        codigo:integer;
        nombre:string;
        precio:integer;
        stockActual:integer;
        stockMinimo:integer;
    end;
    venta = record
        codigo:integer;
        cantVendida: integer;
    end;
    //Archivos:
    maestro = record
        nombre : string;
        archivo: file of producto;
    end;
    detalle = record
        nombre : string;
        archivo: file of venta;
    end;
procedure asignar(var mae:maestro; var det:detalle);
begin
    mae.nombre := 'maestro.bin';
    det.nombre := 'detalle.bin';
    Assign(mae.archivo, mae.nombre);
    Assign(det.archivo, det.nombre);
end;
procedure abrir(var mae:maestro; var det:detalle);
begin
    Reset(mae.archivo);
    Reset(det.archivo);
end;
procedure cerrar(var mae:maestro; var det:detalle);
begin
    Close(mae.archivo);
    Close(det.archivo);
end;
procedure leer(var det:detalle; var dato:venta);
begin
    if(not eof(det.archivo)) then 
        read(det.archivo, dato)
    else dato.codigo:=valorAlto;
end;

procedure actualizarMaestro(var mae:maestro; var det:detalle);
var
    dato: venta; actual: producto;
begin
    abrir(mae, det);
    leer(det, dato);
    while (dato.codigo <> valorAlto) do begin
        read(mae.archivo, actual);
        while(actual.codigo <> dato.codigo) do
            read(mae.archivo, actual);
        while (dato.codigo = actual.codigo) do
        begin
            actual.stockActual:= actual.stockActual - dato.cantVendida;
            leer(det, dato);
        end;
        seek(mae.archivo, filepos(mae.archivo)-1);
        write(mae.archivo, actual);
    end;
    cerrar(mae, det);
end;

procedure listarTxt(var mae:maestro);
var
    P:producto; texto:Text;
begin
    Reset(mae.archivo);
    Assign(texto, 'stock_minimo.txt');
    Rewrite(texto);
    while(not eof(mae.archivo)) do
    begin
        read(mae.archivo, P);
        if (P.stockActual < P.stockMinimo) then
        begin
            writeln(texto, 'Nombre del producto:', P.nombre);
            writeln(texto, 'Codigo del producto:', P.codigo);
            writeln(texto, 'Precio del producto:', P.precio);
            writeln(texto, 'Stock Actual del producto:', P.stockActual);
            writeln(texto, 'Stock Minimo del producto:', P.stockMinimo);
            writeln(texto, ' ');
        end;
    end;
    Close(texto);
    Close(mae.archivo);
end;
VAR
    mae:maestro; det:detalle;
BEGIN 
    asignar(mae, det);
    actualizarMaestro(mae, det);
    listarTxt(mae);
END.