{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar edad a uno o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.
}
program p1ej4;
Type 
  empleado = Record
    num: integer;
    apellido: string;
    nombre: string;
    edad: integer;
    dni: LongInt;
  End;
  archivo = file Of empleado;
procedure leerEmplead(var emp: empleado);
begin
  Writeln('apellido: ');
  readln(emp.apellido); 
  if (emp.apellido <> 'fin') then begin
    Writeln('nombre: ');
    readln(emp.nombre);
    emp.num := random(10000);
    emp.edad := random(82)+18;
    emp.dni := random(50000);
  end;
end;
procedure leerEmpleado2(var emp: empleado);
begin
  Writeln('apellido: ');
  readln(emp.apellido); 
  Writeln('nombre: ');
  readln(emp.nombre);
  writeln('numero de empleado: ');
  readln(emp.num);
  emp.edad := random(82)+18;
  WriteLn('ingresar dni: ');
  readln(emp.dni);
end;
      
Procedure cargarEmpleado(Var arch: archivo);
 Var 
  emp: empleado;
 Begin
  leerEmplead(emp);
  While (emp.apellido <> 'fin') Do
    Begin
      write(arch,emp);
      leerEmplead(emp);
    End;
End;

Procedure listarEmpleado(emp: empleado);
 Begin
  write('num:',emp.num);
  write(' nombre:',emp.nombre);
  write(' apellido:',emp.apellido);
  Write(' edad:',emp.edad);
  Write(' dni:',emp.dni);
  writeln('');
End;

Procedure buscar(Var arch: archivo);
    Var 
      nombre, apellido : String[200];
      aux: empleado;
      ok:boolean;
    Begin
      ok:=False;
      Writeln('ingresar apellido a buscar: ');
      readln(apellido);
      Writeln('ingresar nombre a buscar : ');
      readln(nombre);
      While Not eof (arch) Do
        Begin
          read (arch, aux);
          If (aux.nombre = nombre) Or (aux.apellido = apellido)Then
            Begin
              listarEmpleado(aux);
              ok:= True
            End;
        End;
      if not ok then writeln('No encontro al broski');
End;

Procedure procesamiento(Var arch: archivo);
 Var 
  aux: empleado;
 Begin
  While Not eof (arch) Do
    Begin
      read(arch, aux);
      listarEmpleado(aux);
    End;
End;

Procedure porJubilarse(Var arch: archivo);
 Var 
  aux: empleado;
 Begin
  While Not eof (arch) Do
    Begin
      read(arch, aux);
      If (aux.edad > 70)Then
        listarEmpleado(aux);
    End;
End;
Procedure denominarArchivo(Var arch: archivo);
  Var 
  name: String[20];
 Begin
  writeln('Elija el nombre del archivo :');
  readln(name);
  assign(arch,name);
End;
procedure exportarEmpleados(var arch: archivo); {exporta toda la lista de empleados}
var 
  nuevo: text; aux:empleado;
begin
  Assign(nuevo, 'todos_empleados.txt');
  Rewrite(nuevo);
  denominarArchivo(arch);
  Reset(arch);
  while not eof(arch) do begin
    read(arch, aux);
    with aux do
      writeln(nuevo,' ',apellido,' ',nombre,' ',edad,' ',dni,' ',num);
  end;
  writeln('Terminamos de pasar a texto');
  Close(nuevo); Close(arch);
end;
procedure exportarEmpleadosSinDni(var arch: archivo); {exporta lista de empleados cuyo dni =00}
var 
  nuevo: text; aux:empleado;
begin
  Assign(nuevo, 'faltaDNIEmpleado.txt');
  Rewrite(nuevo);
  denominarArchivo(arch);
  Reset(arch);
  while not eof(arch) do begin
    read(arch, aux);
    if (aux.dni = 00) then
      with aux do
        writeln(nuevo,' ',apellido,' ',nombre,' ',edad,' ',dni,' ',num);
  end;
  writeln('Terminamos de pasar a texto');
  Close(nuevo); Close(arch);
end;
procedure menu_1();
begin
  Writeln('buenas tardes que tarea desea hacer: ');
  Writeln('1-Crear Archivo');
  Writeln('2-listar');
  Writeln('3-agregar Empleados');
  Writeln('4-modificar edad Empleados');
  Writeln('5-Exportar Archivo todos_empleados.txt');
  Writeln('6-Exportar Archivo faltaDNIempleado.txt');
  Writeln('7-salir');
end;
procedure menu_2();
begin
  Writeln('buenas tardes que tarea desea hacer: ');
  Writeln('1-buscar empleado');
  Writeln('2-listar');
  Writeln('3-BUSCAR JUBILADO');
  writeln('4-salir');
end;
procedure menu_3();
begin
  Writeln('a quien le deseas agregar edad: ');
  Writeln('1- a todos');
  Writeln('2- a uno');
  writeln('3-salir');
end;
procedure chekeo(var arch:archivo ; num: integer; var ok:boolean);
var
  aux: empleado;
begin
    ok:= True;
    seek(arch, 0); {nos posicionamos en el comienzo del archivo}
    while not eof (arch) and ok do begin
        read(arch,aux);
        if (num = aux.num) then
            ok:= False; 
    end;
end;
procedure agregarEmpleados(var arch:archivo);
var
  num,i:Integer; emp:empleado;ok: boolean;
begin
    ok:=True;
    denominarArchivo(arch);
    WriteLn('Cuantos empleados quiere agregar??');
    readln(num);
    Reset(arch);

    if (num > 0) then begin
        for i := 1 to num do begin
            leerEmpleado2(emp);
            chekeo(arch,emp.num,ok);
            if ok then begin Write(arch, emp); writeln('agregado con exito!') end else writeln('el numero: ', emp.num, ' ,ya existe en la base de datos, no se agrega.');
        end;
        close(arch);
    end else WriteLn('operacion invalida, no se puede agregar menos de 1 empleado');       
end;
procedure aumentarEdadTodos(var arch: archivo);
var
  aux:empleado;
begin
  while not eof(arch) do begin
    read(arch, aux);
    aux.edad:= aux.edad + 1;
    Seek(arch, FilePos(arch) - 1);
    write(arch, aux);
  end;
  WriteLn('Edades de todo el personal cambiada con exito');
end;

procedure aumentarEdadUno (var arch:archivo);  
var
  fin: boolean; num: integer; aux:empleado;
begin
  writeln('Introduzca un numero de empleado');
  readln(num);
  fin:=false;
  while (not eof(arch)) and (not fin) do begin
    read(arch, aux);
    if (aux.num = num) then begin
      seek(arch, FilePos(arch) -1);
      aux.edad:= aux.edad +1;
      write(arch, aux);
      fin:=true;
    end;
  end;
  WRITELN('CARTELITO DE FINALIZACIÓN CON ÉXITO');
end;
Procedure menu(Var arch: archivo);
Var 
  num,num1: integer;
Begin
    { arrancamos con el menu }
  menu_1();
  readln(num);
  while (num <>7) do begin
    Case (num) Of 
      1:Begin
          denominarArchivo(arch);
          Rewrite(arch);
          cargarEmpleado(arch);
          close(arch);
        End;
      2:Begin
          denominarArchivo(arch);
          menu_2();
          readln(num1);
          while (num1 <> 4) do begin
            reset(arch);
            Case num1 Of 
              1: buscar(arch);
              2: procesamiento(arch);
              3: porJubilarse(arch);
            Else writeln('No es una opcion valida, intente nuevamente!...');
            end; {End del case}
            close(arch);
            menu_2();
            readln(num1);
          end; {end del while}
        end; {end del 2}
      3: begin  agregarEmpleados(arch); end; {ACA AGREGAMOS EMPLEADOS}  
      4: Begin  {aca cambiamos la edad de los empleados}
          denominarArchivo(arch);
          menu_3();
          readln(num1); 
          while (num1 <> 3) do begin
            reset(arch);
            Case num1 Of 
              1: aumentarEdadTodos(arch);
              2: aumentarEdadUno(arch);
            Else writeln('No es una opcion valida, intente nuevamente!...');
            end; {End del case}
            close(arch);
            menu_3();
            readln(num1);
          end; {end del while} 
        end;
      5: begin WriteLn('Exportar empleados a .txt'); exportarEmpleados(arch); end; {Exportar Archivo todos_empleados.txt}  
      6: begin WriteLn('Exportar empleados sin dni a .txt'); exportarEmpleadosSinDni(arch); end; {Exportar Archivo faltaDNIempleado.txt}  
    Else writeln('No es una opcion valida, intente nuevamente!...');
    end; {END del case grande}
    menu_1();
    readln(num);
  end; {End while grande}    
  writeln('Saliste');
End;

{Programa PPal}
Var 
  arch: archivo;
BEGIN
  Randomize;
  menu(arch);
END.