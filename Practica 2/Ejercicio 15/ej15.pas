program ej15;
{15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios. 
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad. 
Para la actualización se debe proceder de la siguiente manera: 
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de  provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}
const
    df = 2; //10;
    valorAlto = 9999;
type
    datoMaestro = record
        codPcia: integer;
        codLoc: integer;
        nombreLoc: string;
        sinLuz: integer;
        sinGas: integer;
        deChapa: integer;
        sinAgua: integer;
        sinSanitario:integer;
    end;
    maestro = file of datoMaestro;
    datoDetalle = record
        codPcia: integer;
        codLoc:integer;
        conLuz:integer;
        construidas:integer;  //Resta a las de chapas
        conAgua:integer;
        conGas:integer;
        conSanitario:integer;
    end;
    detalle = file of datoDetalle;
    arrDet = array [1..df] of detalle;
    arrReg = array [1..df] of datoDetalle;
procedure Leer(var det: detalle; var reg:datoDetalle);
begin
    if not eof(det) then
        read(det, reg)
    else begin
        reg.codPcia:=valorAlto;
        reg.codLoc:=valorAlto;
    end;
end;
procedure Minimo(var detalles:arrDet; var registros: arrReg; var min: datoDetalle);
var
    pos, i:integer;
begin
    pos:=-1; min.codPcia:=valorAlto; min.codLoc:=valorAlto;
    for i:= 1 to df do begin
        if(registros[i].codPcia  < min.codPcia) or ((min.codPcia = registros[i].codPcia) and (registros[i].codLoc <  min.codLoc)) then begin
            pos:= i;
            min:=registros[i];
        end;
    end;
    if (min.codPcia <> valorAlto) then
        Leer(detalles[pos], registros[pos]);
end;
procedure Actualizacion(var mae:maestro; var detalles:arrDet);
var
    registros: arrReg; min:datoDetalle; actual:datoMaestro; i:Integer;
begin
    Writeln('Actualizacion comenzada');
    for i:= 1 to df do begin
        Reset(detalles[i]);
        Leer(detalles[i], registros[i]);
    end;
    Reset(mae);
    Minimo(detalles, registros, min);
    while (min.codPcia <> valorAlto) do begin
        Read(mae, actual);
        while((min.codPcia <> actual.codPcia) or (min.codLoc <> actual.codLoc)) do begin
            Read(mae, actual);
        end;
        while(min.codPcia = actual.codPcia) and (min.codLoc = actual.codLoc) do begin
            actual.sinLuz := actual.sinLuz - min.conLuz;
            actual.sinGas := actual.sinGas - min.conGas;
            actual.deChapa := actual.deChapa - min.construidas;
            actual.sinAgua := actual.sinAgua - min.conAgua;
            actual.sinSanitario := actual.sinSanitario - min.conSanitario;
            Minimo(detalles, registros, min);
        end;
        Seek(mae, FilePos(mae)-1);
        Write(mae, actual);
    end;
    Close(mae);
    for i:= 1 to df do begin
        Close(detalles[i]);
    end;
    Writeln('Actualizacion terminada con exito');
end;
procedure MostrarDatos(var mae:maestro);
var
    registro:datoMaestro;
begin
    Reset(mae);
    while not eof(mae) do begin
        read(mae, registro);
        writeln('Codigo provincia',registro.codPcia);
        WriteLn('Codigo localidad',registro.codLoc);
        WriteLn('Gente sin luz: ', registro.sinLuz);
        WriteLn('--------------------------------------')
    end;
    Close(mae);
end; 
var
    mae:maestro; detalles: arrDet; i:integer; iString:string;
begin
    Assign(mae, 'maestro.dat');
    MostrarDatos(mae);
    Assign(detalles[1], 'detalle.dat');
    Assign(detalles[2], 'detalle copy.dat');
    {
    for i:= 1 to df do begin
        Str(i, iString);
        Assign(detalles[i], ('detalle'+iString+'.dat'));
    end;
    }
    Actualizacion(mae, detalles);
    MostrarDatos(mae);
end.