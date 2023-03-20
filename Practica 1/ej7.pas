
{ 7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la informción almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}

Program ej7;

Type 
  novela = Record
    codigo: integer;
    nombre: string[50];
    genero: string[30];
    precio: double;
  End;
  archivo = file Of novela;

Procedure listarDat(Var arch: archivo);

Var 
  aux : novela;
Begin
  Assign(arch, 'novelas');
  Reset(arch);
  While Not eof (arch) Do
    Begin
      read(arch, aux);
      With aux Do
        Begin
          writeln('nombre: ', nombre, ' codigo: ', codigo, ' precio: ', precio:2
                  :2, ' genero: ', genero);
        End;
    End;
  close(arch);
End;

Procedure cargarNovela(Var aux:novela);
Begin
  Writeln('Introduzca el codigo de la novela');
  Readln(aux.codigo);
  Writeln('Introduzca el nombre de la novela');
  Readln(aux.nombre);
  Writeln('Introduzca el precio de la novela');
  Readln(aux.precio);
  Writeln('Introduzca el genero de la novela');
  Readln(aux.genero);
  Writeln('Lectura completada');
End;
Procedure modificarNovela(Var arch: archivo);

Var 
  aux: novela;
  cod: Integer;
  ok: Boolean;
Begin
  ok := true;
  Assign(arch, 'novelas');
  reset(arch);
  Write('ingrese el codigo de la novela a modificar: ');
  readln(cod);
  While Not eof (arch) And ok Do
    Begin
      read(arch, aux);
      If cod = aux.codigo Then
        Begin
          With aux Do
            Begin
              writeln('nombre: ', nombre, ' codigo: ', codigo, ' precio: ',
                      precio:2:2, ' genero: ', genero);
            End;
          WriteLn('Ingrese los datos de la novela');
          cargarNovela(aux);
          seek (arch, filepos(arch)-1);
          write(arch, aux);
          ok := False;
        End;
    End;
  If Not ok Then
    WriteLn('se realizo la tarea con exito')
  Else WriteLn('no se encontro la novela indicada');
  close(arch);
End;


Procedure parsearTxt(Var arch: archivo);

Var 
  aux: novela;
  novelas: text;
Begin
  Assign(arch, 'novelas');
  Rewrite(arch);
  Assign(novelas, 'novelas.txt');
  reset(novelas);
  While Not eof (novelas) Do
    Begin
      readln(novelas, aux.codigo, aux.precio, aux.genero);
      readln(novelas, aux.nombre);
      write(arch, aux);
    End;
  close(novelas);
  close(arch);
  Writeln('Paso a .dat completado exitosamente');
  listarDat(arch);
End;

Procedure menu1();
Begin
  writeln('Que tarea desea realizar: ');
  writeln('0- Extraer de archivo de novelas.txt');
  writeln('1- Modificar archivo de novelas.dat');
  writeln('2- Salir');
End;


Procedure agregarNovela(Var arch: archivo);

Var 
  aux: novela;
Begin
  cargarNovela(aux);
  Assign(arch, 'novelas');
  Reset(arch);
  Seek(arch, FileSize(arch));
  Write(arch, aux);
  Close(arch);
  Writeln('Adicion completada con exito');
End;

Procedure menu2();
Begin
  writeln('Que tarea desea realizar: ');
  writeln('0- Agregar una novela');
  writeln('1- Modificar una novela');
  writeln('2- Listar');
  writeln('3- Salir');
End;

Procedure menu();

Var 
  arch: archivo;
  opcion, opcion1: Integer;
Begin
  Repeat
    menu1();
    readln(opcion);
    Case (opcion) Of 
      0: parsearTxt(arch);
      1:
         Begin
           Repeat
             menu2();
             read(opcion1);
             Case (opcion1) Of 
               0: agregarNovela(arch);
               1: modificarNovela(arch);
               2: listarDat(arch);
               3: WriteLn('Menu principal: ');
               Else writeln('opcion ingresada incorrecta')
             End;
           Until (opcion1 = 3);
         End;
      2: writeln('Saliste');
      Else writeln('opcion ingresada incorrecta')
    End;
  Until (opcion = 2);
End;

//  MAIN

Begin
  randomize();
  menu();
End.
