{2. Realizar un algoritmo, que utilizando el archivo de números enteros no
ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a
1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá
listar el
contenido del archivo en pantalla.}
program p1ej2;
Type 
  archivo = file Of integer;

Procedure mas1500(Var arch : archivo);
Var 
    aux, total, cant: Integer;
Begin
    total:=0;
    cant:=0;
    while not eof(arch) do begin
        read(arch, aux);
        writeln(aux);
        if (aux<1500) then begin
            cant:= cant+1;
        end;
        total:=aux+total;
    end;
    writeln('el promedio es: ', (total / FileSize(arch)):0:2);
    Writeln(total);
    Writeln(FileSize(arch));
    writeln('cantidad de numeros menores a 1500: ',cant);
End;

Var 
  arch: archivo;
  nombre: String;
Begin
  write('ingrese el nombre del archivo');
  read(nombre);
  Assign(arch,nombre);
  reset(arch);
  mas1500(arch);
  close(arch);
End.