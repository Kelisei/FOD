program generadorMaestro;
const 
    dimF = 10;
type
    datoMunicipal = record
        codLocalidad: integer;
        codCepa:integer;
        casosActivos:integer;
        casosNuevos:integer;
        casosRecuperados:integer;
        fallecidos:integer;
    end;
    datoMaestro = record
        nombreLocalidad:string;
        codLocalidad: integer;
        codCepa:integer;
        casosActivos:integer;
        casosNuevos:integer;
        casosRecuperados:integer;
        fallecidos:integer;
    end;
    maestro = record
        nombre:string;
        archivo: file of datoMaestro;
    end;
    detalle = record
        nombre:string;
        archivo: file of datoMunicipal;
    end;
    arrayDetalles = array [1..dimF] of detalle;
    arrayDatos = array [1..dimF] of datoMunicipal;

procedure crearDetalles();
var
    i:integer; txt:text; aux: datoMunicipal;  iString:string; det:detalle;
begin
    assign(txt, 'detalle.txt');
    reset(txt);
    for i:=1 to 10 do begin
        Str(i, iString);
        Assign(det.archivo, ('detalle'+iString));
        Rewrite(det.archivo);
        while(not eof(txt)) do begin
            readln(txt, aux.codLocalidad, aux.codCepa, aux.casosActivos, aux.casosNuevos, aux.casosRecuperados, aux.fallecidos);
            write(det.archivo, aux);
        end;
        reset(txt);
        Close(det.archivo);
    end;
    Close(txt);
    Writeln('Creacion de binarios detalles hecha con exito');
end;
procedure verMaestro (var mae: maestro);
var
  regMae: datoMaestro;
begin
    WriteLn('-------------');
    reset(mae.archivo);
    While (Not eof(mae.archivo)) Do Begin
        read(mae.archivo,regMae);
        writeln('nombreLocalidad: ', regMae.codLocalidad, ' codigoCepa: ',regMae.codCepa);
        writeln('Nuevos: ', regMae.casosNuevos, ' Fallecidos: ', regMae.fallecidos);
        writeln('Recuperados: ', regMae.casosRecuperados, ' Activos: ',regMae.casosActivos);
    End;
    close(mae.archivo);
end;
var 
    m:maestro;
    i,j:integer;
    r:datoMaestro;
    loc,cep:string;
begin
    assign(m.archivo,'maestro');
    rewrite(m.archivo);
    for i:=1 to 8 do begin
        str(i,loc);
        for j:=1 to 4 do begin
            str(j,cep);
            r.codLocalidad:=i;
            r.nombreLocalidad:=('localidad ' + loc);
            r.codCepa:=j;
            r.casosActivos:=random(500);
            r.casosNuevos:=random(500);
            r.casosRecuperados:=random(500);
            r.fallecidos:=random(500);
            write(m.archivo,r);
        end;
    end;
    close(m.archivo);
    crearDetalles();
    verMaestro(m);
end.