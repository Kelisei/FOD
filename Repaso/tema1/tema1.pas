{Se cuenta con un archivo que almacena información sobre los tipos de dinosaurios que habitaron durante la era mesozoica,
de cada tipo se almacena: código, tipo de dinosaurio, altura y peso promedio, descripción y zona geográfica. 
El archivo no está ordenado por ningún criterio. Realice un programa que elimine tipos  de dinosaurios que estuvieron
en el periodo jurásico de la era mesozoica. Para ello se recibe por teclado los códigos de los tipos a eliminar.
Las bajas se realizan apilando registros borrados y las altas reutilizando registros borrados. 
El registro 0 se usa como cabecera de la pila de registros borrados: el número 0 en el campo código implica que
no hay registros borrados y -N indica que el próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido. 

Dada la estructura planteada en el ejercicio, implemente los siguientes módulos:

Abre el archivo y agrega un tipo de dinosaurios, recibido como parámetro manteniendo la política descripta anteriormente
a. procedure agregarDinosaurios (var a: tArchDinos ; registro: recordDinos);
b. Liste el contenido del archivo en un archivo de texto, omitiendo los tipos de dinosaurios eliminados. Modifique lo que
 considere necesario para obtener el listado.
}
program tema1;
const 
    valor_alto = 9999;
type 
    recordDinos = record
        codigo:integer;
        tipo:string;
        altura:real;
        peso:real;
        descripcion:string;
        zona:string;
    end;
    archivo = file of recordDinos;

procedure leer(var a:archivo;var reg:recordDinos);
begin
    if(not eof(a))then
        read(a,reg)
    else 
        reg.codigo:=valor_alto;
end;

procedure eliminarDinosaurios(var a:archivo);
var 
    cod,pos:integer;
    reg:recordDinos;
begin
    reset(a);
    writeln('Ingresar dinosaurio a eliminar:');
    readln(cod);
    while(cod>0)do begin
        seek(a,1);
        leer(a,reg);
        while(reg.codigo<>valor_alto)and(reg.codigo<>cod)do
            leer(a,reg);
        if(reg.codigo=cod)then begin
            pos:=FilePos(a)-1;
            seek(a,0);
            read(a,reg);
            seek(a,pos);
            write(a,reg);
            reg.codigo:=pos*-1;
            seek(a,0);
            write(a,reg);
        end
        else 
            writeln('No existe el dinosaurio ingresado');
        writeln('Ingresar dinosaurio a eliminar:');
        readln(cod);
    end;
    close(a);
end;

procedure agregarDinosaurios (var a: tArchDinos ; registro: recordDinos);    
    procedure noExisteDino(var a:archivo; dino:integer);
    var
        aux: recordDinos;
    begin
        reset(a);
        while (not eof(a))and(aux.codigo<>dino) do read(a,aux);
        close(a);
        return(aux.codigo<>dino);

    end;
var
    cabecera:recordDinos
begin
    if (noExisteDino(a,registro.codigo)) then begin
        reset(a);
        read(a, cabecera);
        if(cabecera.codigo<0)then begin
            pos := abs(cabecera.codigo);
            seek (a, pos);
            read(a,cabecera);
            seek(a,pos);
            write(a,registro);
            seek(a,0); 
            write(a, cabecera);
        end else begin
            seek(a, filesize(a));
            write(a,registro);      
        end;
        close(a);
    end else WriteLn('dino ya existe');
end;

procedure leerDino(var reg:recordDinos);
begin
    writeln('Introduzca codigo de dinosaurio');
    readln(reg.codigo);
    writeln('Introduzca tipo de dinosaurio');
    readln(reg.tipo);
    writeln('Introduzca altura de dinosaurio');
    readln(reg.altura);
    writeln('Introduzca peso de dinosaurio');
    readln(reg.peso);
    writeln('Introduzca descripcion de dinosaurio');
    readln(reg.descripcion);
    writeln('Introduzca zona de dinosaurio');
    readln(reg.zona);
end;

procedure listar(var arch:archivo);
var
    reg:recordDinos; txt:text;
begin
    Assign(txt, 'listado.txt');
    Rewrite(txt);
    while not eof(arch) do begin
        read(arch, reg);
        if(reg.codigo > 0) then begin
            writeln(txt ,reg.codigo, ' ', reg.tipo);
            writeln(txt ,reg.altura, ' ', reg.peso, ' ',reg.descripcion);
            writeln(txt ,reg.zona);  
        end;       
    end;
    Close(txt);
end;

var
    arch:archivo; reg:recordDinos;
begin
    Assign(arch, 'archivoDinos.xd');
    eliminarDinosaurios(arch);
    leerDino(reg);
    agregarDinosaurios(arch, reg);
    listar(arch);
end.