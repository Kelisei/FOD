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
program ocho;
type
    distribucion = record
        nombre:string;
        anio:integer;
        numKernel:integer;
        cantDevs:integer;
        descripcion:string;
    end;
    archivo = file of distribucion;
function ExisteDistribucion(nombre:String): Boolean;
var
    arch:archivo; encontre:Boolean; actual:distribucion;
begin
    Assign(arch, 'archivo.dat');
    Reset(arch);
    encontre:=False;
    while((not encontre) and (not eof(arch))) do begin
        read(arch, actual);
        encontre:=(actual.nombre = nombre);
    end;
    Close(arch);
    ExisteDistribucion:=encontre;
end;
procedure AltaDistribucion();
    procedure LeerDistribucion(var nuevo:distribucion);
    begin
        Readln(nuevo.nombre);
        Readln(nuevo.anio);
        Readln(nuevo.numKernel);
        Readln(nuevo.cantDevs);
        Readln(nuevo.descripcion);
    end;
var
    arch:archivo; nuevo, cabecera:distribucion;
begin
    LeerDistribucion(nuevo);
    if(ExisteDistribucion(nuevo.nombre)) then
      WriteLn('Existe distribución')
    else begin
        Assign(arch, 'archivo.dat');
        Reset(arch);
        Read(arch, cabecera);
        if(cabecera.cantDevs < 0) then begin
            Seek(arch, cabecera.cantDevs *-1);
            Read(arch, cabecera);
            Seek(arch, FilePos(arch)-1);
            Write(arch, nuevo);
            Seek(arch, 0);
            Write(arch, cabecera);
        end else begin
            Seek(arch, FileSize(arch));
            Write(arch, nuevo);
        end;
        Close(arch);
    end;
end;
procedure BajaDistribucion();
var
    arch:archivo; aux, cabecera:distribucion; nombre:String; pos:Integer; encontre:Boolean;
begin
    Readln(nombre);
    if(ExisteDistribucion(nombre)) then begin
        Assign(arch, 'archivo.dat');
        Reset(arch);
        Read(arch, cabecera);
        encontre:=False;
        while((Not encontre) and (not eof(arch))) do begin
            Read(arch, aux);
            encontre:=(aux.nombre = nombre);
        end;
        pos:=FilePos(arch)-1;
        Seek(arch, pos);
        Write(arch, cabecera);
        cabecera.cantDevs:=pos*-1;
        Seek(arch, 0);
        Write(arch, cabecera);
        Close(arch);
    end else WriteLn('Distribucion no existente');
end;
begin

end.