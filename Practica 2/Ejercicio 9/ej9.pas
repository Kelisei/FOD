program ej9;
{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
......................................................
......................................................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
......................................................
Total de Votos Provincia: ___
....................................................................
Total General de Votos: ___
NOTA: La información se encuentra ordenada por código de provincia y código de
localidad}
type
    mesa = record
        codProvincia:integer;
        codLocalidad:integer;
        mesa:integer;
        votos:integer;
    end;
    maestro = record
        nombre:String;
        archivo: file of mesa;
    end;
const
    valorAlto = 9999;
procedure Leer(var mae:maestro;var dato: mesa);
begin
    if(not eof(mae.archivo)) then   
        read(mae.archivo, dato)
    else begin
        dato.codProvincia:= valorAlto;
        dato.codLocalidad:= valorAlto;
    end;
end;
VAR
    mae:maestro;
    regMae:mesa;
    provinciaActual, localidadActual:integer;
    totalLocalidad, totalProvincia:integer;
BEGIN
    mae.nombre:= 'maestro.bin';
    assign(mae.archivo, mae.nombre);
    reset(mae.archivo);
    Leer(mae, regMae);
    while (regMae.codProvincia <> valorAlto) do
    begin
        provinciaActual:= regMae.codProvincia;
        totalProvincia:= 0;
        while(provinciaActual = regMae.codProvincia) do
        begin
            writeln('PROVINCIA: ', provinciaActual);
            localidadActual:= regMae.codLocalidad;
            totalLocalidad:= 0;
            while(localidadActual = regMae.codLocalidad) and (provinciaActual = regMae.codProvincia) do 
            begin
                totalLocalidad:= totalLocalidad + regMae.votos;
                leer(mae, regMae);
            end;
            writeln('LOCALIDAD: ', localidadActual);
            writeln('TOTAL LOCALIDAD: ', totalLocalidad);
            writeln('');
            totalProvincia:= totalProvincia + totalLocalidad;
        end;
        writeln('TOTAL PROVINCIA: ', totalProvincia);
        writeln('');
    end;

END.
{
     ⠀⠀⠀⢠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠀⠀
⠀⠀⠀⠀⠀⠀⡠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠂⠀
⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄
⠀⠀⠀⠀⢠⣣⠀⠀⠀⠀⠀⠀⠀⢀⡠⣖⣂⣀⡀⠀⠀⠀⠀⠀⠀⠀⠸⢧
⠀⢀⢾⠟⣯⡇⠀⠀⠀⠀⠀⠀⠀⠁⠈⣁⣀⠘⢷⣦⣄⡀⢀⢀⠀⣀⣀⣹
⠀⢸⢸⠀⠈⠃⠀⠀⠀⠀⠀⠀⣰⣾⡻⣭⣭⣽⣿⣾⡽⣿⡟⣼⣾⣿⣿⡟
⠀⠈⠹⣿⡏⠄⠀⠀⠀⠀⠀⠀⠁⠙⢜⠿⣿⣿⣿⣿⡧⠈⣸⣿⣿⣿⣿⡇
⠀⠀⣇⠘⣃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣸⠿⠛⠋⠀⠀⢻⣿⣿⣿⡿⠀
⠀⠀⠘⠤⠴⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠠⠂⠀⠀⢸⣿⣿⣿⡇⠀
⠀⠀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⢿⡄⠀⠰⠄⠀⠀⠻⣿⣿⠇⠀
⠀⠀⠀⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠈⣇⣤⡤⢄⠀⣴⣶⣿⠟⠀⠀
⠀⠀⢀⠃⠀⠀⠀⠀⠀⠀⠀⠀⡔⠁⠀⡀⠀⠈⢹⣷⣿⣾⣿⣿⠏⠀⠀⠀
⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠈⢀⣠⣶⣦⣤⣤⣬⣿⣿⣿⣿⡟⠀⠀⠀⠀
⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⣍⣛⣿⣿⣿⣿⡟⠠⣀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⢙⣿⣿⣿⣿⣷⣤⡀⠉⡢⠀
}