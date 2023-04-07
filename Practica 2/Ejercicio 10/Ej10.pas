program Ej10;
{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados. 
Presentar en pantalla un listado con el siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría}
type
    empleado = record
        departamento: string;
        division: integer;
        numero:integer;
        categoria:integer;
        cantHorasExtras: integer;
    end;
    valorHora = array [1..15] of double;
    maestro = file of empleado;

procedure leer(var mae: maestro; var regMae: empleado);
begin
    if(not eof(mae)) then
      read(mae, regMae)
    else begin
        regMae.departamento := 'ZZZZ';
        regMae.division := 9999;
        regMae.numero := 9999;
    end;
end;
procedure procesar();
var
    mae: maestro;
    regMae: empleado;
    departamentoActual: string;
    horasDivision, horasEmpleado, numeroActual, divisionActual:integer;
    valoresPorHora: valorHora;
    i:integer;
begin
    for i:= 1 to 15 do 
        valoresPorHora[i]:=i;
    Assign(mae, 'empleados.bin');
    Reset(mae);
    leer(mae, regMae);
    writeln(regMae.departamento);
    while (regMae.departamento <> 'ZZZZ') do begin
        departamentoActual := regMae.departamento;
        WriteLn('Departamento:', departamentoActual);
        while(regMae.departamento = departamentoActual) do begin
            divisionActual := regMae.division;
            WriteLn('Division:', divisionActual);
            horasDivision:=0;
            while((regMae.departamento = departamentoActual) and (regMae.division = divisionActual)) do begin
                numeroActual:= regMae.numero;
                horasEmpleado:= 0;
                while((regMae.departamento = departamentoActual) and (regMae.division = divisionActual) and (regMae.numero = numeroActual)) do begin 
                    horasDivision:= horasDivision + regMae.cantHorasExtras;
                    horasEmpleado:= horasEmpleado + regMae.cantHorasExtras;
                    leer(mae, regMae);
                end;
                Writeln('Numero de Empleado Total de Hs.: ', horasEmpleado, ' Importe a cobrar: ', (horasEmpleado * valoresPorHora[divisionActual]):2:2);
            end;
            WriteLn('Total de horas division: ', horasDivision);
            WriteLn('Monto total por division: ', (horasDivision * valoresPorHora[divisionActual]):2:2);
         end;
    end;
    writeln('Datos procesados exitosamente');
end;
begin
    procesar();
end.