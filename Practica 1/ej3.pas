{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

Program p1ej3;

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

{ PREGUNTAR POR QUE NO ANDA EL MODULO ESTE}
Procedure denominarArchivo(Var arch: archivo);
  Var 
  name: String[20];
 Begin
  writeln('Elija el nombre del archivo :');
  readln(name);
  assign(arch,name);
End;
procedure menu_1();
begin
  Writeln('buenas tardes que tarea desea hacer: ');
  Writeln('1-Crear Archivo');
  Writeln('2-listar');
  Writeln('3-salir');
end;
procedure menu_2();
begin
  Writeln('buenas tardes que tarea desea hacer: ');
  Writeln('1-Buscar por nombre o apellido');
  Writeln('2-Listar todos');
  Writeln('3-Buscar mayores de 70');
end;

Procedure menu(Var arch: archivo);
Var 
  num,num1: integer;
Begin
    { arrancamos con el menu }
  menu_1();
  readln(num);
  while (num <>3) do begin
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
            Else writeln('No es una opcion, fin');
            end; {End del case}
            close(arch);
            menu_2();
            readln(num1);
          end; {end del while}
        end; {end del 2}
    Else writeln('No es una opcion, fin');
    end; {END del case grande}
    menu_1();
    readln(num);
  end; {End while grande}    
  writeln('Saliste');
End;

Var 
  arch: archivo;
Begin
  Randomize;
  menu(arch);
end.