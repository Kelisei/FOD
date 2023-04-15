program ej18;
{18 . Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
nombre_hospital, fecha y cantidad de casos positivos detectados.
El archivo está ordenado por localidad, luego por municipio y luego por hospital.
a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
un listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
Nombre Hospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio 1
...............................................................................
Nombre Municipio N
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
NombreHospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
Nombre Hospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio 1
...............................................................................
Nombre Municipio N
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
Nombre Hospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
b. Exportar a un archivo de texto la siguiente información nombre_localidad,
nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
adecuado para recuperar la información con la menor cantidad de lecturas posibles.
NOTA: El archivo debe recorrerse solo una vez.
IMPORTANTE: Se recomienda implementar los ejercicios prácticos en Dev-Pascal. El
ejecutable puede descargarse desde la plataforma moodle.}
const 
    valorAlto = 9999;
type    
    datoMae = record
        codLoc: Integer;
        nomLoc: String;
        codMun: Integer;
        nomMun: String;
        codHosp: Integer;
        nomHosp: String;
        fecha: LongInt;
        casos: Integer;
    end;
    mae = file of datoMae;
    {Dicho archivo contiene:
    cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
    nombre_hospital, fecha y cantidad de casos positivos detectados.}
procedure ConvertirTxtABinario(var m:mae);
var
  archivoTexto: TextFile;
  registro: datoMae;
begin
  Assign(archivoTexto, 'mae.txt');
  Assign(m, 'mae');

    Reset(archivoTexto); // Abrir archivo de texto en modo lectura
    Rewrite(m); // Crear archivo binario en modo escritura
    
    while not Eof(archivoTexto) do
    begin
      // Leer campos del archivo de texto
      ReadLn(archivoTexto, registro.codLoc);
      ReadLn(archivoTexto, registro.nomLoc);
      ReadLn(archivoTexto, registro.codMun);
      ReadLn(archivoTexto, registro.nomMun);
      ReadLn(archivoTexto, registro.codHosp);
      ReadLn(archivoTexto, registro.nomHosp);
      ReadLn(archivoTexto, registro.fecha);
      ReadLn(archivoTexto, registro.casos);
      
      Write(m, registro); // Escribir registro en archivo binario
    end;
    
    Writeln('Archivo binario creado exitosamente.');
    Close(archivoTexto); // Cerrar archivo de texto
    Close(m); // Cerrar archivo binario
end;
procedure Leer(var m:mae; var reg: datoMae);
begin
    if(not eof(m)) then read(m, reg)
    else begin
        reg.codLoc:=valorAlto;
        reg.codMun:=valorAlto;
        reg.codHosp:=valorAlto;
    end;
end;
procedure agregarTxt(var txt: text; nombreLoc:String; nombreMun:String; casos:Integer);
begin
    Writeln(txt, casos,' ',nombreLoc);
    Writeln(txt, nombreMun);
end;
procedure CorteDeControl(var m:mae);
var
    reg, actual:datoMae; totalMun, totalLoc, totalPcia, totalHosp:integer; txt:text;
begin
    Reset(m); Assign(txt, 'municipios+1500.txt'); Rewrite(txt);
    Leer(m, reg);
    {Cantidad de casos Municipio N
    Cantidad de casos Localidad N
    Cantidad de casos Totales en la Provincia}
    totalPcia:=0;
    while(reg.codLoc <> valorAlto) do begin
        actual.codLoc:=reg.codLoc;
        actual.nomLoc:=reg.nomLoc;
        totalLoc:=0;
        while(reg.codLoc = actual.codLoc) do begin
            Writeln('Localidad:', reg.nomMun, ' ', reg.codLoc);
            actual.codMun:=reg.codMun;
            actual.nomMun:=reg.nomMun;
            totalMun:=0;
            while((reg.codLoc = actual.codLoc) and (reg.codMun = actual.codMun)) do begin
                Writeln('Municipio:', reg.nomMun, ' ', reg.codMun);
                actual.codHosp:=reg.codHosp;
                actual.nomHosp:=reg.nomHosp;
                totalHosp:=0;
                while((reg.codLoc = actual.codLoc) and (reg.codMun = actual.codMun) and (reg.codHosp = actual.codHosp)) do begin
                    totalHosp:= totalHosp + reg.casos;
                    Leer(m, reg);
                end;
                totalMun:=totalMun + totalHosp;
            end;
            totalLoc:= totalLoc + totalMun;
            Writeln('Total del municipio:', totalMun);
            if(totalMun > 1500) then
                agregarTxt(txt, actual.nomLoc, actual.nomMun, totalMun);
        end;
        totalPcia:= totalPcia + totalLoc;
        Writeln('Total de la localidad:', totalLoc);
    end;
    Writeln('Total de la provincia:', totalPcia);
    Close(m);  
    Close(txt);
end;
var
    m:mae;
begin
  ConvertirTxtABinario(m);
  CorteDeControl(m);
end.