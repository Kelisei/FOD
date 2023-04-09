program Ej13;
{13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: """"/var/log/logmail.dat""""" se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX..............cantidadMensajesEnviados
.............
nro_usuarioX+n...........cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema.
}
const
    valorAlto = 9999;
type
    log = record
        nroUsuario:integer;
        nombreUsuario:String;
        nombre:string;
        apellido:string;
        cantMailEnviados:integer;
    end;
    mensaje = record
        nroUsuario:integer;
        cuentaDestino:integer;
        cuerpoMensaje:string;
    end;
    maestro = file of log;
    detalle = file of mensaje;
procedure leer(var det: detalle; var aux:mensaje);
begin
    //writeln(FilePos(det));
    if (not eof(det)) then 
        read(det, aux) 
    else aux.nroUsuario:=valorAlto;
   //Writeln('Terminamos de leer');
end;
procedure actualizarLogs(var mae:maestro; var det:detalle);
var
    aux:mensaje; actual:log; totalMensajes:integer;
begin
    Assign(det, 'logmail.dat');
    Assign(mae, 'logs.bin');
    Reset(mae); Reset(det);
    leer(det, aux);
    WriteLn('FileSize del maestro (logs)',FileSize(mae));
    while(aux.nroUsuario <> valorAlto) do begin
        read(mae, actual);
        while(actual.nroUsuario <> aux.nroUsuario) do read(mae, actual);
        totalMensajes:=0;
        while(actual.nroUsuario = aux.nroUsuario) do begin
            totalMensajes:= totalMensajes + 1;
            leer(det, aux);
        end;
        actual.cantMailEnviados:=actual.cantMailEnviados + totalMensajes;
        Seek(mae, FilePos(mae)-1);
        write(mae, actual);
    end;
    WriteLn('Actualizacion realizada con exito');
    Close(mae); Close(det);
end;
procedure generarTxt(var det:detalle);
var 
    txt:text; aux: mensaje; actual: mensaje; totalMensajes:integer;
begin
    Assign(txt, 'txt.txt'); Rewrite(txt); Reset(det);
    leer(det, aux);
    while (aux.nroUsuario <> valorAlto)do begin
        actual:=aux; totalMensajes:=0;
        while(actual.nroUsuario = aux.nroUsuario) do begin
            totalMensajes:= totalMensajes + 1;
            leer(det,aux)
        end;
        write(txt, 'Numero de usuario:', actual.nroUsuario, ' Total mensajes:', totalMensajes);
    end;
    Close(det); Close(txt);
    WriteLn('Generacion realizada con exito');
end;
var
    mae:maestro; det:detalle;
begin

    actualizarLogs(mae, det);
    generarTxt(det);
end.