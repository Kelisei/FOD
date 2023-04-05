program ej6;
{6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa. 
Para la actualización se debe proceder de la siguiente manera: 
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

const 
    valorAlto = 9999;
    dimF = 10;
type
    datoMunicipal = record
        codLocalidad: integer;
        codCepa:integer;
        casosActivos:integer;
        casosNuevos:integer;
        casosRecuperados:integer;
        fallecidos:integer;
    end;
    datoMaestro = record
        nombreLocalidad:string;
        codLocalidad: integer;
        codCepa:integer;
        casosActivos:integer;
        casosNuevos:integer;
        casosRecuperados:integer;
        fallecidos:integer;
    end;
    maestro = record
        nombre:string;
        archivo: file of datoMaestro;
    end;
    detalle = record
        nombre:string;
        archivo: file of datoMunicipal;
    end;
    arrayDetalles = array [1..dimF] of detalle;
    arrayDatos = array [1..dimF] of datoMunicipal;
procedure leer(var arch: detalle; var dato: datoMunicipal);
begin
    if(not eof(arch.archivo)) then begin
        read(arch.archivo, dato);
    end
    else begin
        dato.codLocalidad := valorAlto;
        dato.codCepa := valorAlto;
    end;
end;
procedure minimo(var detalles:arrayDetalles; var datos:arrayDatos; var min:datoMunicipal);
var
    i:integer; pos:integer;
begin
    min.codLocalidad:= valorAlto;
    min.codCepa:=valorAlto;
    for i:= 1 to dimF do 
        if ((datos[i].codLocalidad <  min.codLocalidad)) or ((datos[i].codLocalidad =  min.codLocalidad) and (datos[i].codCepa < min.codCepa)) then begin
            min:=datos[i];
            pos:=i;
        end;
    if(min.codLocalidad <> valorAlto) then
        leer(detalles[pos], datos[pos]);
end;
procedure verMaestro (var mae: maestro);
var
  regMae: datoMaestro;
begin
    WriteLn('-------------');
    reset(mae.archivo);
    While (Not eof(mae.archivo)) Do Begin
        read(mae.archivo,regMae);
        writeln('nombreLocalidad: ', regMae.codLocalidad, ' codigoCepa: ',regMae.codCepa);
        writeln('Nuevos: ', regMae.casosNuevos, ' Fallecidos: ', regMae.fallecidos);
        writeln('Recuperados: ', regMae.casosRecuperados, ' Activos: ',regMae.casosActivos);
    End;
    close(mae.archivo);
end;
procedure actualizarMaestro(var mae:maestro);
var
    detalles: arrayDetalles; datos: arrayDatos; i:integer; iString:string; actual:datoMaestro; min:datoMunicipal;
begin
    for i:= 1 to dimF do begin
        Str(i, iString);
        detalles[i].nombre := ('detalle' + iString);
        Assign(detalles[i].archivo, detalles[i].nombre);
        Reset(detalles[i].archivo);
        leer(detalles[i], datos[i]);
    end;
    verMaestro(mae);
    minimo(detalles, datos, min);
    Reset(mae.archivo);
    while(min.codLocalidad <> valorAlto) do begin
        read(mae.archivo, actual);
        while not (min.codLocalidad = actual.codLocalidad) and not (min.codCepa = actual.codCepa) do begin
            read(mae.archivo, actual);
        end;
        while(actual.codLocalidad = min.codLocalidad) and (actual.codCepa = min.codCepa) do begin
            actual.fallecidos := actual.fallecidos + min.fallecidos;
            actual.casosRecuperados := actual.casosRecuperados + min.casosRecuperados;
            actual.casosActivos := min.casosActivos;
            actual.casosNuevos := min.casosNuevos;
            minimo(detalles, datos, min);
        end;
        seek(mae.archivo, filepos(mae.archivo)-1);
        write(mae.archivo, actual);
    end;
    Close(mae.archivo);
    for i:= 1 to dimF do
        Close(detalles[i].archivo);
    verMaestro(mae);
end;
var
    mae: maestro;
begin
    mae.nombre := 'maestro';
    Assign(mae.archivo, mae.nombre);
    actualizarMaestro(mae);
end.