{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”
}
PROGRAM p1ej5;
type
  celular = record
    cod : Integer;
    nombre : String[30];
    descripcion : string[30];
    marca : string[30];
    precio : Double;
    stock_min : Integer;
    stock_disponible : integer;
  end;
 archivo = file of celular;
procedure asignar(var arch: archivo);
 var
 nombre:string;
 begin
  WriteLn('Escriba el nombre del nuevo archivo .dat');
  Readln(nombre);
  Assign(arch, nombre);
 end;
procedure crearArchivo(var arch: archivo); {1-a}
 var
  arch_precargado:text;
  aux : celular;
 begin
  Assign(arch_precargado,'celulares.txt');
  reset(arch_precargado);
  asignar(arch);
  WriteLn('termine asignar');
  rewrite(arch);
  while not eof (arch_precargado) do begin
    {  
    readln(arch_precargado, aux.cod, aux.precio, aux.marca);
    readln(arch_precargado, aux.stock_disponible, aux.stock_min, aux.descripcion);
    readln(arch_precargado, aux.nombre);
    }
    with aux do begin
      readln(arch_precargado, cod, precio, marca);
      readln(arch_precargado, stock_disponible, stock_min, descripcion);
      readln(arch_precargado,nombre);
    end;
    write(arch, aux);
  end;
  close(arch_precargado); 
  close(arch);
  WriteLn('archivo creado con exito');
 end;
procedure listarMinimos(var arch: archivo); {2-b}
 var 
  aux:celular;
 begin
  asignar(arch);
  reset(arch);
  while not eof(arch) do begin
    read(arch, aux);
    if (aux.stock_disponible < aux.stock_min) then
      with aux do 
        writeln('codigo: ', cod,
                ' nombre: ', nombre,
                ' precio: ', precio, 
                ' descripcion: ', descripcion,
                ' marca: ', marca,
                ' stock disponible: ', stock_disponible, 
                ' stock minimo: ', stock_min
        )
  end;
  close(arch);
 end;
procedure buscarPorDescripcion(var arch: archivo); {3-c}
 var
  texto:string;
  aux: celular;
 begin
  asignar(arch);
  reset(arch);
  writeln('Ingrese el dato que desea buscar en la descripcion');
  readln(texto);
  while not eof(arch) do begin
    read(arch, aux);
    if (pos(texto, aux.descripcion)<>0) then
      With aux Do
        writeln('codigo: ', cod,
            ' nombre: ', nombre,
            ' precio: ', precio,
            ' descripcion: ', descripcion,
            ' marca: ', marca,
            ' stock disponible: ', stock_disponible,
            ' stock minimo: ', stock_min)
  end;
  close(arch);
 end;
procedure crearTxt(var arch: archivo); {4-d}
 var
  nuevo: text; aux:celular;
 begin
   asignar(arch);
   Reset(arch);
   assign(nuevo,'celulares.txt');
   Rewrite(nuevo);
   while not eof(arch) do begin
    read(arch, aux);
    With aux Do Begin
        WriteLn(nuevo,cod,' ', precio,' ', marca);
        WriteLn(nuevo,stock_disponible,' ', stock_min,' ', descripcion);
        WriteLn(nuevo,nombre);
    End;
   end;
   close(arch);
   close(nuevo);
 end;

procedure cargarCelular(var aux: celular);
  function randomString():String;
  var 
    s :string[15];
    i :integer;
  begin
    for i := 1 to 15 do
      s[i] := chr(random (127-32)+32);
    randomString:= s;
  end;
begin
  WriteLn('inserte codigo de celular');
  readln(aux.cod);
  if (aux.cod <> 999) then begin
    WriteLn('inserte descripcion del celular');
    readln(aux.descripcion);
    aux.stock_min := random(1000);
    aux.stock_disponible := random(1000);
    aux.marca := randomString();
    aux.nombre := randomString();
  end;
end;
procedure crearCelularesTxt();
var
  aux:celular;
  txt: text;
begin
  Assign(txt,'celulares.txt');
  Rewrite(txt);
  cargarCelular(aux);
  while (aux.cod<>999) do begin
    With aux Do Begin
        WriteLn(txt,cod,' ', precio,' ', marca);
        WriteLn(txt,stock_disponible,' ', stock_min,' ', descripcion);
        WriteLn(txt,nombre);
    End;
    cargarCelular(aux);
  end;
  close(txt);
  WriteLn('archivo creado con exito.');
end;
procedure menu1(); 
 begin
  writeln('Que tarea desea realizar: ');
  writeln('0- Crear archivo celulares.txt');
  writeln('1- Crear archivo de celulares.da');
  writeln('2- Mostrar en pantalla los celulares con menor stock que el minimo.');
  writeln('3- Buscar celulares por descripcion.');
  writeln('4- Exportar listado de celulares.');
  writeln('5- Salir.');
 end;
procedure menu();
 var
 arch: archivo;
 opcion:Integer;
 begin
 repeat
 menu1();
 readln(opcion);
    case (opcion) of
      0:crearCelularesTxt(); {PRUEBITA}
      1: crearArchivo(arch); 
      2: listarMinimos(arch);
      3: buscarPorDescripcion(arch);
      4: crearTxt(arch);     
      5: WriteLn('saliste');     
      else writeln('opcion ingresada incorrecta')
    end; 
 until (opcion = 5);
 end;
BEGIN
  randomize();
  menu();
END.