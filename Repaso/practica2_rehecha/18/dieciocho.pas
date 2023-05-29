program dieciocho;
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

type
    datoHospital = record
        cod_localidad: integer;
        nombre_localidad:string;
        cod_municipio:integer;
        nombre_municipio:string;
        cod_hospital:integer;
        nombre_hospital:string;
        fecha:LongInt;
        cant_casos:integer;
    end;
    arch = file of datoHospital;

procedure leer(var mae:arch; var dato:datoHospital);
begin
    if not eof(mae) then
        read(mae, dato)
    else begin 
        dato.cod_localidad:=9999;
        dato.cod_municipio:=9999;
        dato.cod_hospital:=9999;
    end;
end;
procedure exportar(var text:text; nom_loc_actual:string; nom_mun_actual:string; cant_por_mun:integer);
begin
    Append(text);
    WriteLn(text, cant_por_mun, nom_mun_actual);
    WriteLn(text, nom_loc_actual);
    Close(text);
end;
procedure resolucion();
var
    mae:arch; dato:datoHospital; cod_loc_actual, cod_mun_actual, cod_hos_actual:integer; cant_por_hos, cant_por_mun, cant_por_loc, cant_pcia:integer;
    nom_hos_actual, nom_mun_actual, nom_loc_actual:string;
    txt:text;
begin
    Assign(txt, 'exportado.txt');
    Rewrite(txt);
    Close(txt);
    Assign(mae, 'mae');
    Reset(mae);
    leer(mae, dato);
    cant_pcia:=0;
    while(dato.cod_localidad <> 9999) do begin
        cod_loc_actual:=dato.cod_localidad;
        nom_loc_actual:=dato.nombre_localidad;
        WriteLn('Localidad:',nom_loc_actual);
        cant_por_loc:=0;
        while(cod_loc_actual = dato.cod_localidad) do begin
            cod_mun_actual := dato.cod_municipio;
            nom_mun_actual:=dato.nombre_municipio;
            WriteLn('Municipio:',nom_mun_actual);
            cant_por_mun:=0;
            while((cod_loc_actual = dato.cod_localidad) and (dato.cod_municipio = cod_mun_actual)) do begin
                cod_hos_actual:=dato.cod_hospital;
                nom_hos_actual:=dato.nombre_hospital;
                WriteLn('Hospital:',nom_hos_actual);
                cant_por_hos:=0;
                while((cod_loc_actual = dato.cod_localidad) and (dato.cod_municipio = cod_mun_actual) and (dato.cod_hospital = cod_hos_actual)) do begin
                    cant_por_hos:=cant_por_hos+dato.cod_hospital;
                    cant_por_mun:=cant_por_mun+dato.cod_hospital;
                    cant_por_loc:=cod_loc_actual+dato.cod_hospital;
                    cant_pcia:=cant_pcia+dato.cod_hospital;
                    leer(mae, dato);
                end;
                writeln('Cantidad de casos',nom_hos_actual ,':',cant_por_hos);
            end;
            Writeln('Cantidad de casos',nom_mun_actual ,':',cant_por_mun);
            if(cant_por_mun >= 1500) then 
                exportar(txt, nom_loc_actual, nom_mun_actual, cant_por_mun);
        end;
        WriteLn('Cantidad de casos',nom_loc_actual ,':',cant_por_loc);
    end;
    WriteLn(cant_pcia);
    Close(mae);
end;
begin  
    resolucion();
end.