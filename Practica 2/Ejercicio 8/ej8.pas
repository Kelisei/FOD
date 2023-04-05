program ej8;
{El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.}
type
    cliente = record
        codigo:integer;
        nombre: string;
        apellido: string;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: double;
    end;
    maestro = record
        nombre : string;
        archivo: file of cliente;
    end;
const 
    valorAlto = 9999;
procedure Leer(var mae: maestro; var actual: cliente);
begin
    if(not(eof(mae.archivo))) then
      read(mae.archivo, actual)
    else begin
        actual.codigo   :=valorAlto;
        actual.anio     :=valorAlto;
        actual.mes      :=valorAlto;
    end;
end;
VAR
    regMae:cliente; mae:maestro;
    codigoActual, anioActual, mesActual:integer;
    totalMes:double;
    totalAnio:double;
BEGIN
    mae.nombre := 'maestro.bin';
    assign(mae.archivo, mae.nombre);
    reset(mae.archivo);
    
    Leer(mae, regMae);
    while(regMae.codigo <> valorAlto) do
    begin
        codigoActual:= regMae.codigo;
        while(codigoActual = regMae.codigo) do                     
        begin
            writeln('NOMBRE: ', regMae.nombre);
            anioActual:= regMae.anio;
            totalAnio:= 0;
            while (codigoActual = regMae.codigo) and (anioActual = regMae.anio) do
            begin
                mesActual:= regMae.mes;
                totalMes:= 0;
                while(mesActual = regMae.mes) and (codigoActual = regMae.codigo) and (anioActual = regMae.anio)do
                begin 
                    totalMes:= totalMes + regMae.monto;
                    Leer(mae, regMae);
                end;
                writeln('MES: ', mesActual);
                writeln(totalMes:2:2);
                totalAnio:= totalAnio + totalMes;
            end;
            writeln('ANIO: ', anioActual);
            writeln(totalAnio:2:2);
            writeln('');
        end;
    end;
END.

{ Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras}