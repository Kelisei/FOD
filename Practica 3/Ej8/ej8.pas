program ej8;
{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”}
type
    distribucion = record
        nombre:string;
        lanzamiento:integer;
        version:integer;
        cantDevs: integer;
        descripccion:string;
    end;
    archivo = file of distribucion;

procedure crearArchivo(var a:archivo); 
var
    carga:text; aux:distribucion;
begin
    Assign(carga, 'archivo.txt');
    Reset(carga);
    Rewrite(a);
    aux.lanzamiento:=0;
    Write(a, aux);
    while not eof (carga) do begin
        with aux do begin
            ReadLn(carga, nombre);
            ReadLn(carga, lanzamiento);
            Readln(carga, version);
            Readln(carga, cantDevs);
            Readln(carga, descripccion);
        end;
        write(a, aux);
    end;
    Close(carga); Close(a);
    Writeln('Archivo creado con exito');
end;
function ExisteDistribucion(var a:archivo; nombre:string):Boolean;
var
    encontre:Boolean; aux:distribucion;
begin
    encontre:=False;
    Reset(a);
    while (not eof (a)) and (not encontre) do begin
        read(a, aux);
        encontre:= (aux.nombre = nombre);
    end;
    Close(a);
    ExisteDistribucion:= encontre;
end;
procedure AltaDistribucion(var a:archivo);
    procedure LeemeEsta(var aux:distribucion);
    begin
        WriteLn('Introduzca el nombre de la distribucion:');
        Readln(aux.nombre);
        WriteLn('Introduzca el año de lanzamiento:');
        Readln(aux.lanzamiento);
        WriteLn('Introduzca el numero de version:');
        Readln(aux.version);
        WriteLn('Introduzca la cantidad de desarrolladores:');
        Readln(aux.cantDevs);
        WriteLn('Introduzca la descripccion:');
        Readln(aux.descripccion);
    end;
var
    aux, cabecera:distribucion; 
begin   
    Reset(a);
    Read(a,cabecera);
    LeemeEsta(aux);
    if(cabecera.cantDevs = 0) then begin
        Seek(a, FileSize(a));
        Write(a, aux);
    end else begin
        Seek(a, (cabecera.cantDevs * -1));
        Read(a, cabecera);
        Seek(a, FilePos(a)-1);
        Write(a, aux);
        Seek(a, 0);
        Write(a, cabecera);
    end;
    WriteLn('Alta realizada con exito');
    Close(a);
end;
procedure BajaDistribucion(var a:archivo);
var
    aux, cabecera: distribucion; nombre:string; encontre:Boolean;
begin
    Writeln('Introduzca un nombre');
    Readln(nombre);
    if(ExisteDistribucion(a,nombre)) then begin
        Reset(a);
        Read(a, cabecera);
        encontre:=False;
        while (not Eof(a)) and (not encontre) do begin
            Read(a, aux);
            if(aux.nombre = nombre) then begin
                encontre:=True;
                Seek(a, FilePos(a)-1);
            end;
        end;
        Write(a, cabecera);
        cabecera.cantDevs:=(FilePos(a)-1)*-1;
        Seek(a, 0);
        Write(a, cabecera);
        Close(a);
        Writeln('Terminamos la baja');
    end else Writeln('No esta ese pa');
end;
procedure listar(var a:archivo); 
var
    aux:distribucion;
begin
    Reset(a);
    while (not eof(a)) do begin
        Read(a, aux);
        WriteLn(aux.lanzamiento, ' | ', aux.nombre, ' | ',aux.descripccion, ' | ', aux.cantDevs);
        WriteLn('-------------------------------------------------------------------------------------');
    end;
    Close(a);
end;
var
    a:archivo;
begin
    Assign(a, 'archivo');
    crearArchivo(a);
    listar(a);
    BajaDistribucion(a);
    BajaDistribucion(a);
    Writeln('Existe la distribucion: ', ExisteDistribucion(a, 'Vanilla Ice'));
    AltaDistribucion(a);
    listar(a);
end.