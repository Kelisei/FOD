{1. Se desea modelar un sistema para manejar la cantidad de bebidas consumidas en un festival de folklore realizado en la ciudad de Laprida.
 El festival cuenta con 3 puestos de bebidas. Al finalizar el festival cada puesto genera un archivo binario de ventas con la
  siguiente información: cod_bebida, nombre, cantidad_vendida y cod_vendedor.
 Cada bebida puede no venderse o aparecer en una o varias ventas y todos los archivos están ordenados por cod_bebida.
Escriba un programa (Programa principal, estructuras y módulos) que dados los archivos detalle de cada puesto,
 genere un nuevo archivo binario llamado total.dat con la suma de ventas de cada bebida en todos los puestos. El nuevo archivo deberá tener
  el siguiente formato: cod_bebida, nombre y cantidad_total_vendida. 
Nota: los archivos deben recorrerse solo una vez.  --> el que me tomaron de archivos}

program ej1;
Const 
  valorAlto = 9999;
  df = 3;
type
    venta = record
        cod_bebida:integer;
        nombre:string;
        cantidad_vendida:integer;
        cod_vendedor:integer;
    end;
    total = record
        cod_bebida : integer;
        nombre : string;
        cantidad_total_vendida : integer;
    end;
    detalle = file of venta; 
    puestos = array [1..df] of detalle;
    maestro = file of total;
    ventas = array [1..df] of venta;
    
procedure leer(var det:detalle; var aux:venta);
begin
    If (Not eof(det)) Then
        read(det, aux)
    Else
        aux.cod_bebida := valorAlto;
End;

procedure minimo(var arrDetalle:puestos; var arrVentas:ventas;var min: venta);
var
    i,pos:integer;
begin
    min.cod_bebida := valorAlto;
    for i:=1 to df do
        if (arrVentas[i].cod_bebida<min.cod_bebida) then begin
          pos:= i;
          min:= arrVentas[i];
        end;  
    if (min.cod_bebida <> valorAlto) then
        leer(arrDetalle[pos], arrVentas[pos]);
end;

procedure verMaestro(var mae : maestro);
var
    aux:total;
begin
  reset(mae);
  while not eof(mae) do begin
    read (mae,aux);
    writeln('cod bebida: ', aux.cod_bebida ,', Nombre: ', aux.nombre , ', cantVemdida: ',aux.cantidad_total_vendida);
  end;
  close(mae);
end;

procedure merge();
var
    mae:maestro; arrDetalle:puestos; arrVentas:ventas; min:venta; iString:string; i:integer; actual:total;
begin
    for i:=1 to df do begin
        Str(i, iString);
        Assign(arrDetalle[i], ('det'+iString));
        Reset(arrDetalle[i]);
        leer(arrDetalle[i], arrVentas[i]);
    end;
    Assign(mae, 'total.dat');
    Rewrite(mae);
    minimo(arrDetalle, arrVentas, min);
    while (min.cod_bebida <> valorAlto) do begin
      actual.cantidad_total_vendida:=0;  
      actual.cod_bebida:= min.cod_bebida;
      actual.nombre:= min.nombre;
      while (min.cod_bebida = actual.cod_bebida) do begin
        actual.cantidad_total_vendida:= actual.cantidad_total_vendida + min.cantidad_vendida;
        minimo(arrDetalle, arrVentas, min);
      end;
        Write(mae, actual);
    end;
    close(mae);
    
    for i:=1 to df do
      close(arrDetalle[i]);
    verMaestro(mae);
end;

///////////////////////////////////////////////////////////////////////////////////////fin ejercicio

procedure crearDetalles();
var
    arrDet:puestos; detalle:text; i:integer; iString:string; vent:venta;
begin
    Assign(detalle, 'det.txt');
    for i:= 1 to df do begin
        Str(i, iString);
        Assign(arrDet[i], ('det'+iString));
        Rewrite(arrDet[i]);
        Reset(detalle);
        while(not eof(detalle)) do begin
            readln(detalle, vent.cod_bebida);
            readln(detalle, vent.nombre);
            readln(detalle, vent.cantidad_vendida);
            readln(detalle, vent.cod_vendedor);
            write(arrDet[i], vent);
        end;
        Close(arrDet[i]);
        Close(detalle);
    end;
end;

begin
    crearDetalles();
    merge();
end.