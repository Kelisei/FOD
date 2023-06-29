program Ej12;
{12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idusuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idusuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idusuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idusuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
- El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
- El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
- Debe definir las estructuras de datos necesarias.
- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}
const 
    valorAlto = 9999;
type
    acceso = record
        anio,mes,dia,idUsuario,tiempoDeAcceso:integer;
    end;
    maestro = file of acceso;
procedure leer(var mae:maestro; var aux: acceso);
begin
    if(not eof(mae)) then 
        read(mae, aux)
    else begin 
        aux.anio:=valorAlto;
        aux.mes:=valorAlto;
        aux.dia:=valorAlto;
        aux.idUsuario:=valorAlto;
    end;
end;
procedure corteDeControl(var mae:maestro);
var
    aux:acceso;
    anioAct, mesAct, diaAct, idAct:integer;
    anioEncontrado:Boolean;
    anioBuscado:integer;
    tiempoTotalDia, tiempoTotalMes, tiempoTotalAnio :integer;
begin
    Reset(mae);
    Writeln('Introduzca el año que buscar');
    ReadLn(anioBuscado);
    anioEncontrado:=False;
    leer(mae, aux);
    while((aux.anio <> valorAlto) and (aux.anio <= anioBuscado)) do begin
        anioAct:= aux.anio;
        if (anioAct = anioBuscado) then begin
            WriteLn('Anio:', anioAct);
            anioEncontrado:=True;
            tiempoTotalAnio:=0;
        end;
        while((anioAct = aux.anio) and (anioAct <= anioBuscado)) do begin
            mesAct:= aux.mes;
            if (anioEncontrado) then begin 
                WriteLn('Mes:', mesAct);
                tiempoTotalMes:=0;
            end;
            while ((anioAct = aux.anio)  and (anioAct <= anioBuscado) and (mesAct = aux.mes)) do begin
                diaAct := aux.dia;
                if (anioEncontrado) then begin 
                    WriteLn('Dia:', diaAct);
                    tiempoTotalDia:=0;
                end;
                while((anioAct = aux.anio)  and (anioAct <= anioBuscado) and (mesAct = aux.mes) and (diaAct = aux.dia)) do begin
                    idAct:= aux.idUsuario;
                    while ((anioAct = aux.anio)  and (anioAct <= anioBuscado) and (mesAct = aux.mes) and (diaAct = aux.dia) and (idAct = aux.idUsuario)) 
                    do begin
                        if (anioEncontrado) then begin 
                            WriteLn('Id de usuario:', idAct, ' Tiempo total accedido ese dia:', aux.tiempoDeAcceso);
                            tiempoTotalDia:= tiempoTotalDia+aux.tiempoDeAcceso;
                            tiempoTotalAnio:= tiempoTotalAnio+aux.tiempoDeAcceso;
                            tiempoTotalMes:= tiempoTotalMes+aux.tiempoDeAcceso;
                        end;
                        leer(mae, aux);
                    end;
                end;
                if (anioEncontrado) then
                    WriteLn('Total del dia:', tiempoTotalDia);
            end;
            if (anioEncontrado) then
                WriteLn('Total del mes:', tiempoTotalMes);
        end;
        if (anioEncontrado) then
            WriteLn('Total del anio:', tiempoTotalAnio);
    end;
    if(not anioEncontrado) then WriteLn('Anio no encontrado');
    Close(mae);
    WriteLn('Corte de control realizado con exito');
end;
var
   mae:maestro; 
begin
    Assign(mae, 'maestro.bin');
    corteDeControl(mae);
end.