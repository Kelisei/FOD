program ej7;
{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}
type
    datoMae = record
        codigo:LongInt;
        nombre:string;
        familia: string;
        descripccion:string;
        zonaGeografica: string;
    end;
    maestro = file of datoMae;   
const
    valorAlto = 50;
procedure crearArchivo(var mae: maestro);
var
    aux:datoMae; carga:text;
begin
    Assign(mae, 'mae'); Assign(carga, 'mae.txt');
    Rewrite(mae); Reset(carga);
    while not eof(carga) do begin
        with aux do begin
            ReadLn(carga, codigo);
            ReadLn(carga, nombre);
            ReadLn(carga, familia);
            ReadLn(carga, descripccion);
            ReadLn(carga, zonaGeografica);
        end;
        write(mae, aux);
    end;
    Close(mae); Close(carga);
end;
procedure eliminar(var mae:maestro);
var
    reg:datoMae; cod:LongInt; encontrado:Boolean;
begin
    Reset(mae);
    WriteLn('Introduzca un codigo a eliminar | Termina con 500000');
    Readln(cod);
    while(cod <> valorAlto) do begin
        encontrado := False;
        while (not Eof(mae)) and (not encontrado) do begin
            read(mae, reg);
            encontrado :=  (reg.codigo = cod);
        end;
        if (encontrado) then begin
            Seek(mae, FilePos(mae)-1);
            reg.codigo:= -1;
            Write(mae, reg);
        end;
        Seek(mae, 0);
        WriteLn('Introduzca un codigo a eliminar | Termina con 500000');
        Readln(cod);
    end;
    Close(mae);
end;
procedure leer(var mae:maestro; var aux:datoMae); 
begin
    if (not eof(mae)) then read(mae, aux)
    else aux.codigo:=valorAlto;
end;
procedure compactar(var mae:maestro);
var
    pos, ultimo:integer; aux, reemplazo:datoMae;
begin
    Reset(mae);
    ultimo:=FileSize(mae)-1; //Posicion del ultimo registro antes del eof
    leer(mae,aux);
    while (aux.codigo <> valorAlto) do begin
        if (aux.codigo = -1) then begin
            //Agarrar el ultimo registro disponible y pisar el actual
            pos:=FilePos(mae)-1;
            Seek(mae, ultimo);          //Me en el ultimo registro disponbile
            read(mae, reemplazo);             //Leo en el siguiente
            while (reemplazo.codigo = -1)  and (ultimo > 0) do begin   //Si esta eliminado, hay que leer el anterior
                Seek(mae, ultimo-1);
                ultimo:=FilePos(mae);
                read(mae, reemplazo);
            end;
            ultimo:=ultimo-1;//Si ya reemplazamos por uno, ya no lo podemos usar más
            Seek(mae, pos);
            Write(mae,reemplazo);
        end;
        leer(mae, aux);
    end;
    writeln('Posicion a partir de la cual truncar:',ultimo+1);
    Seek(mae, ultimo+1);
    Truncate(mae);
    Close(mae);
    Writeln('Compactacion realizada con exito');
end;
procedure listar(var mae:maestro); 
var
    aux:datoMae;
begin
    Reset(mae);
    leer(mae, aux);
    while (aux.codigo <> valorAlto) do begin
        WriteLn(aux.codigo, ' | ', aux.nombre, ' | ',aux.descripccion);
        WriteLn('---------------------------------------------');
        leer(mae, aux);
    end;
    Close(mae);
end;
var
    mae:maestro;
begin
    crearArchivo(mae);
    writeln('Archivo creado:');
    listar(mae);
    eliminar(mae);
    writeln('Eliminados logicamente:');
    listar(mae);
    compactar(mae);
    writeln('Eliminados fisicamente:');
    listar(mae);
end.