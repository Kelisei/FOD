program ej16;
{16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
ejemplares y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}
const
    df = 2;
    valorAlto = 9999;
type
    datoMaestro = record
        fecha:LongInt;
        codigo:Integer;
        nombre:String;
        descripccion:String;
        precio:Real;
        cantEjemplares:Integer;
    end;
    maestro = file of datoMaestro;
    datoDetalle = record
        fecha:LongInt;
        codigo: Integer;
        cantEjemplares:Integer;
    end;
    detalle = file of datoDetalle;
    arrDet = array [1..df] of detalle;
    arrReg = array [1..df] of datoDetalle;
procedure Leer(var det:detalle; var registro: datoDetalle);
begin
    if(not eof(det)) then
        read(det, registro)
    else begin
        registro.fecha:=valorAlto;
        registro.codigo:=valorAlto;
    end;
end;
procedure Minimo (var detalles:arrDet; var registros:arrReg; var min:datoDetalle);
var
    i, pos:integer;
begin
    min.fecha:=valorAlto; min.codigo:=valorAlto;
    for i:= 1 to df do
        if(registros[i].fecha < min.fecha) or ((registros[i].fecha = min.fecha) and (registros[i].codigo < min.codigo)) then begin
            min:=registros[i];
            pos:=i;
        end;
    if(min.fecha <> valorAlto) then
      Leer(detalles[pos], registros[pos]);
end;
procedure ActualizarMaestro(var mae:maestro; var detalles:arrDet);
var
    registros:arrReg; min:datoDetalle; actual:datoMaestro; i:integer; max:datoDetalle;
begin
    max.cantEjemplares:=-1;
    for i:= 1 to df do begin
        Reset(detalles[i]);
        Leer(detalles[i], registros[i]);
    end;
    Reset(mae);
    Minimo(detalles, registros, min);
    while(min.fecha <> valorAlto) do begin
        read(mae, actual);
        while (actual.fecha <> min.fecha) or (actual.codigo <> min.codigo) do read(mae, actual);
        while((actual.fecha = min.fecha) and (actual.codigo = min.codigo)) do begin
            actual.cantEjemplares:=actual.cantEjemplares+min.cantEjemplares;
            Minimo(detalles, registros, min);
        end;    
        if(actual.cantEjemplares > max.cantEjemplares) then begin
            max.fecha:=actual.fecha;
            max.codigo:=actual.codigo;
            max.cantEjemplares:=actual.cantEjemplares;
        end;
        Seek(mae, FilePos(mae)-1);
        write(mae, actual);
    end;
    Close(mae);
    for i:= 1 to df do
        Close(detalles[i]);
    Writeln('Actualizacion terminada con exito');
    WriteLn('Fecha y codigo de semanario mas vendido:', max.fecha, ' ', max.codigo);
end;
var
    i:Integer; iString:String; 
    detalles:arrDet; mae:maestro;
begin
    for i:= 1 to df do begin
        Str(i, iString);
        Assign(detalles[i], ('detalle'+iString));
    end;
    Assign(mae, 'maestro');
    ActualizarMaestro(mae, detalles);
end.