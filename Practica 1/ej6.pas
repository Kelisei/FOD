
{ 6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular. 
}
Program ej6;

Type 
  celular = Record
    cod : Integer;
    nombre : String[30];
    descripcion : string[30];
    marca : string[30];
    precio : Double;
    stock_min : Integer;
    stock_disponible : integer;
  End;
  archivo = file Of celular;
Procedure asignar(Var arch: archivo);

Var 
  nombre: string;
Begin
  WriteLn('Escriba el nombre del nuevo archivo .dat');
  Readln(nombre);
  Assign(arch, nombre);
End;
Procedure crearArchivo(Var arch: archivo); {1-a}

Var 
  arch_precargado: text;
  aux : celular;
Begin
  Assign(arch_precargado,'celulares.txt');
  reset(arch_precargado);
  asignar(arch);
  WriteLn('termine asignar');
  rewrite(arch);
  While Not eof (arch_precargado) Do
    Begin
      With aux Do
        Begin
          readln(arch_precargado, cod, precio, marca);
          readln(arch_precargado, stock_disponible, stock_min, descripcion);
          readln(arch_precargado,nombre);
        End;
      write(arch, aux);
    End;
  close(arch_precargado);
  close(arch);
  WriteLn('archivo creado con exito');
End;
Procedure listarMinimos(Var arch: archivo); {2-b}

Var 
  aux: celular;
Begin
  asignar(arch);
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch, aux);
      If (aux.stock_disponible < aux.stock_min) Then
        With aux Do
          writeln('codigo: ', cod,
                  ' nombre: ', nombre,
                  ' precio: ', precio,
                  ' descripcion: ', descripcion,
                  ' marca: ', marca,
                  ' stock disponible: ', stock_disponible,
                  ' stock minimo: ', stock_min
          )
    End;
  close(arch);
End;
Procedure buscarPorDescripcion(Var arch: archivo); {3-c}

Var 
  texto: string;
  aux: celular;
Begin
  asignar(arch);
  reset(arch);
  writeln('Ingrese el dato que desea buscar en la descripcion');
  readln(texto);
  While Not eof(arch) Do
    Begin
      read(arch, aux);
      If (pos(texto, aux.descripcion)<>0) Then
        With aux Do
          writeln('codigo: ', cod,
                  ' nombre: ', nombre,
                  ' precio: ', precio,
                  ' descripcion: ', descripcion,
                  ' marca: ', marca,
                  ' stock disponible: ', stock_disponible,
                  ' stock minimo: ', stock_min)
    End;
  close(arch);
End;
Procedure crearTxt(Var arch: archivo); {4-d}

Var 
  nuevo: text;
  aux: celular;
Begin
  asignar(arch);
  Reset(arch);
  assign(nuevo,'celulares.txt');
  Rewrite(nuevo);
  While Not eof(arch) Do
    Begin
      read(arch, aux);
      With aux Do
        Begin
          WriteLn(nuevo,cod,' ', precio:2:2,' ', marca);
          WriteLn(nuevo,stock_disponible,' ', stock_min,' ', descripcion);
          WriteLn(nuevo,nombre);
        End;
    End;
  close(arch);
  close(nuevo);
End;

Procedure cargarCelular(Var aux: celular);
Function randomString(): String;

Var 
  s : string[15];
  i : integer;
Begin
  For i := 1 To 15 Do
    s[i] := chr(random (127-32)+32);
  randomString := s;
End;
Begin
  WriteLn('inserte codigo de celular');
  readln(aux.cod);
  If (aux.cod <> 999) Then
    Begin
      WriteLn('inserte descripcion del celular');
      readln(aux.descripcion);
      aux.stock_min := random(1000);
      aux.stock_disponible := random(1000);
      aux.marca := randomString();
      aux.nombre := randomString();
    End;
End;
//-----------------
Procedure agregarCelulares(Var arch: archivo);

Var 
  i, cant: integer;
  aux: celular;
Begin
  asignar(arch);
  writeln('Introduzca la cantidad de celulares a agregar:');
  readln(cant);
  reset(arch);
  seek(arch, filesize(arch));
  For i:= 1 To cant Do
    Begin
      cargarCelular(aux);
      If (aux.cod <> 999) Then
        write(arch, aux);
    End;
  close(arch);
End;

Procedure modificarCelular(Var arch: archivo);

Var 
  modificador,codigo: integer;
  aux: celular;
  ok: boolean;
Begin
  ok := True;
  writeln('Introduzca el codigo del celular a modificar');
  readln(codigo);
  asignar(arch);
  reset(arch);
  While (Not eof(arch)) And (ok) Do
    Begin
      read(arch, aux);
      If (aux.cod = codigo) Then
        ok := false;
    End;
  If Not ok Then
    Begin
      seek(arch, FilePos(arch)-1);
      writeln('Introduzca la cantidad a modificar');
      readln(modificador);
      aux.stock_disponible := modificador;
      write(arch, aux);
    End
  Else
    Write('No se encontro el codigo \n No se generan cambios');
  close(arch);
End;
//-----------------
Procedure crearCelularesTxt();
Var 
  aux: celular;
  txt: text;
Begin
  Assign(txt,'celulares.txt');
  Rewrite(txt);
  cargarCelular(aux);
  While (aux.cod<>999) Do
    Begin
      With aux Do
        Begin
          WriteLn(txt,cod,' ', precio,' ', marca);
          WriteLn(txt,stock_disponible,' ', stock_min,' ', descripcion);
          WriteLn(txt,nombre);
        End;
      cargarCelular(aux);
    End;
  close(txt);
  WriteLn('archivo creado con exito.');
End;
Procedure crearSinStockTxt(Var arch: archivo);

Var 
  aux: celular;
  txt: text;
Begin
  Assign(txt,'sinStock.txt');
  Rewrite(txt);
  asignar(arch);
  reset(arch);
  While (Not eof (arch)) Do
    Begin
      read(arch, aux);
      if (aux.stock_disponible = 0) then 
        With aux Do
          Begin
            WriteLn(txt,cod,' ', precio,' ', marca);
            WriteLn(txt,stock_disponible,' ', stock_min,' ', descripcion);
            WriteLn(txt,nombre);
          End;
    End;
  close(txt);
  close(arch);
  WriteLn('archivo creado con exito.');
End;
Procedure menu1();
Begin
  writeln('Que tarea desea realizar: ');
  writeln('0- Crear archivo celulares.txt');
  writeln('1- Crear archivo de celulares.da');
  writeln('2- Mostrar en pantalla los celulares con menor stock que el minimo.');
  writeln('3- Buscar celulares por descripcion.');
  writeln('4- Exportar listado de celulares.');
  writeln('5- Agregar uno o mas celulares.');
  writeln('6- Modificar el stock de un cel dado.');
  writeln('7- Exportar "sinStock.txt".');
  writeln('8- Salir.');
End;
Procedure menu();

Var 
  arch: archivo;
  opcion: Integer;
Begin
  Repeat
    menu1();
    readln(opcion);
    Case (opcion) Of 
      0: crearCelularesTxt(); {PRUEBITA}
      1: crearArchivo(arch);
      2: listarMinimos(arch);
      3: buscarPorDescripcion(arch);
      4: crearTxt(arch);
      5: agregarCelulares(arch);
      6: modificarCelular(arch);
      7: crearSinStockTxt(arch);
      8: WriteLn('saliste');
      Else writeln('opcion ingresada incorrecta')
    End;
  Until (opcion = 8);
End;
Begin
  randomize();
  menu();
End.
