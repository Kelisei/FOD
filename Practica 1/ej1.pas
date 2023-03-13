{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y
permita
incorporar datos al archivo. Los números son ingresados desde teclado. El
nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}
program ej1;
type
    archivo = file of integer;

procedure leerInts(var arch);
var
    aux: Integer;
begin
    read('ingrese un numero (salimos con 30k)');
    read(aux);
    while (aux <> 30000) do begin
        write(arch, aux);
        read(aux);
    end;
end;

var
    arch: archivo;
    nombre: String;
begin
    write('ingresar el nombre del archivo: ');
    read(nombre);
    assign(arch, nombre);
    rewrite(arch);
    leerInts(arch);
    close(arch);
end.