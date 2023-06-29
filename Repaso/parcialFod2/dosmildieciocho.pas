program dosmildieciocho;
type
    acceso = record
        anio:integer;
        mes:integer;
        dia:integer;
        idUsuario: integer;
        tiempoAcceso:integer;
    end;
    archivo = file of acceso;
const
    valorAlto=9999;
procedure Leer(var arch:archivo; var actual:acceso);
begin
    if(not eof(arch)) then read(arch, actual)
    else actual.anio:=valorAlto;
end;
procedure Informe(var arch:archivo);
var
    anioElegido, mes, dia, usuario:integer; actual:acceso; totalMes, totalDia, totalAnio, totalUsuario:integer;
begin
    Readln(anioElegido);
    Reset(arch);
    Leer(arch, actual);
    while((actual.anio <> valorAlto) and (actual.anio < anioElegido)) do begin
        Leer(arch, actual)
    end;
    if(actual.anio = anioElegido) then begin
        Writeln('Anio ', actual.anio);
        totalAnio:=0;
        while(actual.anio = anioElegido) do begin
            mes := actual.mes;
            totalMes:=0;
            Writeln('    Mes ', actual.mes);
            while((actual.anio = anioElegido) and (actual.mes = mes)) do begin
                dia := actual.dia;
                totalDia:=0;
                Writeln('        dia ', actual.dia);
                while((actual.anio = anioElegido) and (actual.mes = mes) and (actual.dia = dia)) do begin
                    usuario:=actual.idUsuario;
                    totalUsuario:=0;
                    Writeln('          Usuario:', usuario,' Tiempo Total de acceso en el dia ', dia,' mes ',mes);
                    while((actual.anio = anioElegido) and (actual.mes = mes) and (actual.dia = dia) and (actual.idUsuario = usuario)) do begin
                        totalUsuario:=totalUsuario+actual.tiempoAcceso;
                        Leer(arch, actual);
                    end;
                    Writeln('          ', totalUsuario);
                    totalDia:=totalUsuario+totalDia;
                end;
                Writeln('        Tiempo Total de acceso dia ', dia, ' mes ', mes);
                Writeln('        ',totalDia);
                totalMes:=totalDia+totalMes;
            end;
            Writeln('    Tiempo Total de acceso mes ', mes);
            Writeln('    ',totalMes);
            totalAnio:=totalMes+totalAnio;
        end;
        Writeln('Tiempo total de acceso anio ', anioElegido);
        Writeln(totalAnio);
    end else Writeln('Anio no encontrado');
    Close(arch);
end;
var
    arch: archivo;
begin
    Assign(arch, 'accesos.dat');
    Informe(arch);
end.