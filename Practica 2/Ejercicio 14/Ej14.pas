program Ej14;
{14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez}
const 
    valorAlto = 9999;
    valorAltoS = 'ZZZZ';
type
    datoMaestro = record
        destino: string;
        fecha: string;
        horaDeSalida: integer;
        asientosDisponibles: integer;
    end;
    maestro = file of datoMaestro;

    datoDetalle = record
        destino: string;
        fecha: string;
        horaDeSalida: integer;
        asientosComprados: integer;
    end;
    detalle = file of datoDetalle;
    lista = ^nodo;
    nodo = record
        destino: string;
        fecha:string;
        horaDeSalida:integer;
        sig: lista;
    end;
procedure agregarInicio(var pri: lista; regMae:datoMaestro);
var
    nuevo:lista;
begin
    new(nuevo);
    nuevo^.sig:=nil;
    nuevo^.destino:= regMae.destino;
    nuevo^.fecha:= regMae.fecha;
    nuevo^.horaDeSalida:= regMae.horaDeSalida;
    if(pri = nil) then
      pri:=nuevo
    else begin
        nuevo^.sig:=pri;
        pri:=nuevo;
    end;
end;
procedure leer(var det: detalle; var aux:datoDetalle);
begin
    if(not eof(det)) then
        read(det, aux)
    else begin 
        aux.destino:=valorAltoS;
        aux.fecha:=valorAltoS;
        aux.horaDeSalida:=valorAlto
    end;
end;
procedure minimo(var det1, det2:detalle; var aux1, aux2, min: datoDetalle);
begin
    if(aux1.destino < aux2.destino) or 
    ((aux1.destino = aux2.destino) and (aux1.fecha < aux2.fecha)) or 
    ((aux1.destino = aux2.destino) and (aux1.fecha = aux2.fecha) and (aux1.horaDeSalida < aux2.horaDeSalida)) then begin
        min:=aux1;
        leer(det1, aux1);
    end else begin
        min:=aux2;
        leer(det2, aux2);
    end;
end;
procedure recorrerLista(list:lista);
begin
    if(list <> nil) then begin
        recorrerLista(list^.sig);
        writeln(list^.horaDeSalida);
    end;
end;
procedure modificarMaestro(var mae:maestro; var list: lista);
var
    det1: detalle; det2: detalle; aux1, aux2, min: datoDetalle; regMae:datoMaestro; valor:integer;
begin
    if(list = nil) then WriteLn('nil');
    WriteLn('Introduzca un valor');
    ReadLn(valor);
    Assign(mae, 'maestro');
    Reset(mae);
    Assign(det1,'det'); Assign(det2, 'det copy');
    reset(det1); Reset(det2);
    read(det1, aux1);
    read(det2, aux2);
    minimo(det1, det2, aux1, aux2, min);
    while(min.destino <> valorAltoS) do begin
        read(mae, regMae);
        while(regMae.destino <> min.destino) or (regMae.fecha <> min.fecha) or (regMae.horaDeSalida <> min.horaDeSalida) do 
            read(mae , regMae);
        while((regMae.destino = min.destino )and (regMae.fecha = min.fecha) and (regMae.horaDeSalida = min.horaDeSalida)) do begin
            regMae.asientosDisponibles := regMae.asientosDisponibles - min.asientosComprados;
            minimo(det1, det2, aux1, aux2, min);
        end;
        Seek(mae, FilePos(mae)-1);
        write(mae, regMae);
        if(valor > regMae.asientosDisponibles) then
            agregarInicio(list, regMae);
    end;
    Close(mae);
    Close(det1); Close(det2);
    {
    Reset(mae);
    while not eof(mae) do begin
        read(mae, regMae);
        writeln(regMae.destino, ' ', regMae.asientosDisponibles);      
    end;
    recorrerLista(list);
    }
end;
var
    mae:maestro; list:lista;
begin
    list:=NIL;
    modificarMaestro(mae, list);
end.