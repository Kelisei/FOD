program Ej11;
{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}
type
    datoProvincia = record
        nombre:string;
        alfabetizados: integer;
        encuestados: integer;
    end;
    datoAgencia = record
        nombre:string;
        codLocalidad:integer;
        alfabetizados: integer;
        encuestados: integer;      
    end;
    detalle = file of datoAgencia;
    maestro = file of datoProvincia;

procedure leer(var det:detalle; var dato:datoAgencia);
begin
    if(not eof(det)) then
        read(det, dato)
    else dato.nombre:= 'ZZZ';
end;
procedure minimo(var det1, det2:detalle; var datoDet1, datoDet2, min:datoAgencia);
begin
    if(datoDet1.nombre < datoDet2.nombre) then begin
        min:=datoDet1;
        leer(det1, datoDet1);
    end else begin
        min:=datoDet2;
        leer(det2, datoDet2);
    end;
end;
procedure actualizarMaestro(var mae:maestro);
var
    datoMaestro: datoProvincia; minDetalle: datoAgencia;
    det1, det2: detalle; 
    datoDet1: datoAgencia; datoDet2: datoAgencia;
    totalEncuestados, totalAlfabetizados:integer; 
begin
    Assign(mae, 'maestro.bin'); Reset(mae);
    Assign(det1, 'det'); Assign(det2, 'det copy');
    Reset(det1); Reset(det2);
    leer(det1, datoDet1); leer(det2, datoDet2);
    minimo(det1, det2, datoDet1, datoDet2, minDetalle);
    while(minDetalle.nombre <> 'ZZZ') do begin
        read(mae, datoMaestro);
        writeln(minDetalle.nombre);
        writeln(datoMaestro.nombre);
        while(minDetalle.nombre <> datoMaestro.nombre) do read (mae, datoMaestro);
        totalEncuestados:=0; totalAlfabetizados:=0;
        while(minDetalle.nombre = datoMaestro.nombre) do begin
            totalEncuestados:= totalEncuestados + minDetalle.encuestados;
            totalAlfabetizados:= totalAlfabetizados + minDetalle.alfabetizados;
            minimo(det1, det2, datoDet1, datoDet2, minDetalle);
        end;
        datoMaestro.alfabetizados := datoMaestro.alfabetizados + totalAlfabetizados;
        datoMaestro.encuestados := datoMaestro.encuestados + totalEncuestados;
        Seek(mae, FilePos(mae)-1);
        Write(mae, datoMaestro);
    end;
    Close(mae); Close(det1); Close(det2);
    Writeln('Terminamos');
    Reset(mae);
    while not eof(mae) do begin
        read(mae, datoMaestro);
        writeln('Provincia: ',datoMaestro.nombre,'| Alfabetizados: ', datoMaestro.alfabetizados,'| Encuestados: ', datoMaestro.encuestados);
    end;
end;
var
    mae:maestro;
begin 
    actualizarMaestro(mae);
end.