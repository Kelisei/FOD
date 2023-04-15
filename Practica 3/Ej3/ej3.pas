program ej3;
{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de  ́enlace ́ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}
type
    datoMae = record
        cod:integer;
        genero:string;
        nombre:string;
        duracion:integer;
        director:string;
        precio:real;
    end;
    maestro = file of datoMae;

procedure mostrar(var mae:maestro);
var
    reg:datoMae;
begin
    Reset(mae);
    while not eof(mae) do begin
      read(mae, reg);
      Writeln('--------------------------------------');
      Writeln('Codigo:',reg.cod, ' Nombre', reg.nombre);
    end;
    Close(mae);
end;
procedure leerNovela(var reg: datoMae);
begin
    Writeln('Introduzca los datos de la novela');
    Writeln('CODIGO: (MAYOR QUE 0)');
    Readln(reg.cod);
    if(reg.cod > 0) then begin
        Writeln('GENERO:');
        Readln(reg.genero);
        Writeln('NOMBRE:');
        Readln(reg.nombre);
        Writeln('DURACION:');
        ReadLn(reg.duracion);
        Writeln('DIRECTOR:');
        Readln(reg.director);
        Writeln('PRECIO:');
        ReadLn(reg.precio);
    end;
end;
procedure crearArchivo(var mae:maestro);
var
    nombre:string; reg:datoMae;
begin
    WriteLn('Cual es el nombre del archivo?');
    Readln(nombre);
    Assign(mae, nombre);
    Rewrite(mae);
    reg.cod:=0;
    Write(mae, reg);
    leerNovela(reg);
    while (reg.cod > 0) do begin
        Write(mae, reg);
        leerNovela(reg);
    end;
    Close(mae);
    Writeln('Creacion de archivo realizado con exito');
    mostrar(mae);
end;
procedure darDeAlta(var mae:maestro);
var
    aux, cabecera:datoMae; pos:integer;
begin
    Reset(mae);
    Read(mae, cabecera);
    leerNovela(aux);
    if (cabecera.cod = 0) then begin
        WriteLn('No hay espacio vacio');
        Seek(mae, FileSize(mae));
        Write(mae, aux);
    end
    else begin
        pos:= cabecera.cod * -1;
        Seek(mae, pos);
        Read(mae, cabecera);
        Seek(mae, FilePos(mae)-1);
        Write(mae, aux);
        Seek(mae, 0);
        Write(mae, cabecera);
    end;
    Close(mae);
    WriteLn('Alta realizada con exito');
    mostrar(mae);
end;
procedure modificar(var mae:maestro);
var
    encontrado:boolean; cod:integer; reg:datoMae;
begin
    WriteLn('Introduzca un codigo a buscar');
    Readln(cod);
    Reset(mae);
    encontrado:=False;
    while (not eof(mae)) and (not encontrado) do begin
        read(mae,reg);
        encontrado:= (reg.cod = cod);
    end;
    if (encontrado) then begin
        Writeln('Introduzca los datos de la novela');
        Writeln('GENERO:');
        Readln(reg.genero);
        Writeln('NOMBRE:');
        Readln(reg.nombre);
        Writeln('DURACION:');
        ReadLn(reg.duracion);
        Writeln('DIRECTOR:');
        Readln(reg.director);
        Writeln('PRECIO:');
        ReadLn(reg.precio);
        Seek(mae, FilePos(mae)-1);
        Write(mae, reg);
    end;
    Close(mae);
    mostrar(mae);
end;
procedure eliminar(var mae:maestro);
var
    cabecera, reg:datoMae; cod, pos:integer; encontrado:Boolean;
begin
    Reset(mae);
    Writeln('Introduzca un codigo a buscar');
    Readln(cod);
    encontrado:=False;
    read(mae, cabecera);
    while (not eof(mae)) and (not encontrado) do begin
        read(mae,reg);
        encontrado:= (reg.cod = cod);
    end;
    if (encontrado) then begin
        Seek(mae, FilePos(mae)-1);
        pos:= (FilePos(mae) * -1);
        Write(mae, cabecera); //Sobreescribo con los datos de la cabecera
        Seek(mae, 0);
        reg.cod:= pos;
        Write(mae, reg);     //Escribo el puntero actual en la cabecera
    end;
    Close(mae);
    mostrar(mae);
end;
procedure listarATxt(var mae:maestro);
var
    txt:text; reg:datoMae; nombre:string;
begin
    WriteLn('Cual es el nombre del archivo?');
    Readln(nombre);
    Assign(mae, nombre);
    Reset(mae);
    Assign(txt, 'novelas.txt');
    Rewrite(txt);
    read(mae, reg);
    while not eof (mae) do begin
        read(mae, reg);
        if(reg.cod < 1) then Writeln(txt, 'Eliminada:');
        WriteLn(txt, 'Codigo:', reg.cod, ' Genero:', reg.genero);
        WriteLn(txt, 'Nombre:',reg.nombre);
        WriteLn(txt, 'Duracion:', reg.duracion, ' Director:', reg.director);
        WriteLn(txt, 'Precio: ', reg.precio:2:2);
        Writeln(txt, '----------------------------------------------');
    end;
    Close(mae); Close(txt);
end;
procedure menu(var mae:maestro);
var
    opcion: char; nombre:String; opcion2:integer; noSalir1, noSalir2: Boolean;
begin
    WriteLn('Que quiere hacer?:');
    WriteLn('A: Crear archivo | B: Mantenimiento de archivo | C: Listar a txt | Otro: Salir');
    Readln(opcion);
    noSalir1:=True;
    while (noSalir1) do begin
        if ((opcion = 'A') or (opcion = 'a')) then begin
            crearArchivo(mae);
            WriteLn('Que quiere hacer?:');
            WriteLn('A: Crear archivo | B: Mantenimiento de archivo | Otro: Salir');
            Readln(opcion);
        end
        else if ((opcion = 'B') or (opcion = 'b')) then begin
            WriteLn('Cual es el nombre del archivo?');
            Readln(nombre);
            Assign(mae, nombre);
            noSalir2:=True;
            while (noSalir2) do begin
                Writeln('Que quieres hacer?:');
                WriteLn('1: Agregar una novela en un espacio vacio');
                WriteLn('2: Modificar una novela');
                WriteLn('3: Eliminar novela');
                Writeln('Otro: Salir');
                Readln(opcion2);
                if (opcion2 = 1) then
                    darDeAlta(mae)
                else if (opcion2 = 2 ) then
                    modificar(mae)
                else if (opcion2 = 3) then
                    eliminar(mae)
                else begin 
                    noSalir2:=False;
                    WriteLn('No era una opcion');
                end;
            end;
            WriteLn('Que quiere hacer?:');
            WriteLn('A: Crear archivo | B: Mantenimiento de archivo | Otro: Salir');
            Readln(opcion);
        end 
        else if ((opcion = 'C') or (opcion = 'c')) then begin 
            listarATxt(mae);
            WriteLn('Que quiere hacer?:');
            WriteLn('A: Crear archivo | B: Mantenimiento de archivo | Otro: Salir');
            Readln(opcion);
        end
        else begin 
            noSalir1:=False;
            WriteLn('Saliste');
        end;
    end;
end;
var
    mae:maestro;
begin
    menu(mae);
end.