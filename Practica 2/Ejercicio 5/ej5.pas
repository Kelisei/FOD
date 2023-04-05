program ej5;
const 
    ARRAYLENGTH = 3;
    VALORALTO = 17000;
Type
    direccionSujeto = record
        calle:String;
        numero:integer;
        piso:integer;
        dpto:String;
        ciudad:String;
    end;
    nacimiento = record
        numeroDeNacimiento: integer;
        nombre: string;
        apellido: string;
        direccion: direccionSujeto;
        matriculaDelMedico: string;
        nombreApellidoMadre: string;
        dniMadre: string;
        nombreApellidoPadre: string;
        dniPadre:string;
    end;
    fallecimiento = record
        numeroDeNacimiento: integer;
        dni: string;
        nombre: string;
        apellido: string;
        matriculaDelMedico: string;
        nombreDelMedico: string;
        fecha: string;
        hora: double;
        lugar: string;
    end;
    registroMaestro = record
        concepcion:nacimiento;
        fallecio: boolean;
        muerte:fallecimiento;
    end;

    detalleNac = file of nacimiento;
    vDetalleNac = array [1..ARRAYLENGTH] of detalleNac;
    vRegistroNac = array [1..ARRAYLENGTH] of nacimiento;
    
    detalleFal = file of fallecimiento;
    vDetalleFal = array [1..ARRAYLENGTH] of detalleFal;
    vRegistroFal = array [1..ARRAYLENGTH] of fallecimiento;

    maestro = file of registroMaestro;

procedure leer(var detalle:detalleNac ; var N:nacimiento);
begin
    if (not eof(detalle)) then
        read(detalle, N)
    else 
        N.numeroDeNacimiento:= VALORALTO; 
end;

procedure generarNacimientos(var vDet:vDetalleNac);
var
    aux: nacimiento;
    txt:Text;
    iString:String;
    i:integer;
begin
    for i:= 1 to ARRAYLENGTH do begin
        Str(i, iString);
        assign(txt, 'nacimientos'+iString+'.txt');
        reset(txt);
        assign(vDet[i], ('detNac'+iString));
        rewrite(vDet[i]);
        while(not eof(txt)) do begin
            readln(txt, aux.numeroDeNacimiento, aux.nombre);
            readln(txt, aux.apellido);
            readln(txt, aux.direccion.calle);
            readln(txt, aux.direccion.numero, aux.direccion.piso, aux.direccion.dpto);   
            readln(txt, aux.direccion.ciudad);
            readln(txt, aux.matriculaDelMedico);
            readln(txt, aux.nombreApellidoMadre);
            readln(txt, aux.dniMadre);
            readln(txt, aux.nombreApellidoPadre);
            readln(txt, aux.dniPadre);
            write(vDet[i], aux);
        end;
    end;
end;
procedure generarFallecimientos(var vDet:vDetalleFal);
var
    aux: fallecimiento;
    txt:Text;
    iString:String;
    i:integer;
begin
    for i:= 1 to ARRAYLENGTH do begin
        Str(i, iString);
        assign(txt, ('fallecimientos'+iString+'.txt'));
        reset(txt);
        assign(vDet[i], ('detFal'+iString));
        rewrite(vDet[i]);
        while(not eof(txt)) do begin
            readln(txt, aux.numeroDeNacimiento, aux.dni);
            readln(txt, aux.nombre);
            readln(txt, aux.apellido);
            readln(txt, aux.matriculaDelMedico);
            readln(txt, aux.nombreDelMedico);
            readln(txt, aux.fecha);
            readln(txt, aux.hora);
            readln(txt, aux.lugar);
            write(vDet[i], aux);
        end;
    end;
end;
//-----------------
procedure minimoNac(var vNacimientos: vDetalleNac; var vReg: vRegistroNac ; var min: nacimiento);
var
    i, pos:integer;
begin
    pos:= -1;
    min.numeroDeNacimiento := VALORALTO;
    for i:= 1 to ARRAYLENGTH do begin
        if (vReg[i].numeroDeNacimiento <= min.numeroDeNacimiento) then begin
            pos:= i;
            min:= vReg[i];
        end;
    end;
    if (pos <> -1) then
        leer(vNacimientos[pos], vReg[pos]);
end;
procedure minimoFal(var vFallecimientos: vDetalleFal; var vReg: vRegistroFal ; var min: fallecimiento);
var
    i, pos:integer;
begin
    pos:= -1;
    min.numeroDeNacimiento := VALORALTO;
    for i:= 1 to ARRAYLENGTH do begin
        if (vReg[i].numeroDeNacimiento <= min.numeroDeNacimiento) then begin
            pos:= i;
            min:= vReg[i];
        end;
    end;
    if (pos <> -1) then
        if (not eof(vFallecimientos[pos])) then
            read(vFallecimientos[pos], vReg[pos])
        else 
            vReg[pos].numeroDeNacimiento:=VALORALTO;
end;




VAR
    vDetNac:vDetalleNac;
    vRegNac:vRegistroNac;
    vDetFal:vDetalleFal;
    vRegFal:vRegistroFal;
    mae:maestro;
    minNac:nacimiento;
    minFal:fallecimiento;
    i:integer;
    regMae: registroMaestro;
BEGIN
    generarNacimientos(vDetNac);
    generarFallecimientos(vDetFal);

    for i:=1 to ARRAYLENGTH do
    begin
        reset(vDetNac[i]);
        leer(vDetNac[i], vRegNac[i]);
        reset(vDetFal[i]);
        read(vDetFal[i], vRegFal[i]);
    end;

    assign(mae, 'maestro.dat');
    rewrite(mae);

    minimoNac(vDetNac, vRegNac, minNac);
    minimoFal(vDetFal, vRegFal, minFal);

    while (minNac.numeroDeNacimiento <> VALORALTO) do
    begin
        if (minNac.numeroDeNacimiento <> minFal.numeroDeNacimiento) then
        begin
            regMae.concepcion:= minNac;
            regMae.fallecio:= False;
        end
        else
        begin
            regMae.concepcion:= minNac;
            regMae.fallecio:= True;
            regMae.muerte:= minFal;
            minimoFal(vDetFal, vRegFal, minFal);
        end;
        write(mae, regMae);
        minimoNac(vDetNac, vRegNac, minNac);
    end;

    for i:= 1 to ARRAYLENGTH do begin
        close(vDetNac[i]);
        close(vDetFal[i]);
    end;
    //close(mae);
    reset(mae);
    while (not eof(mae)) do
    begin
        read(mae, regMae);
        if (regMae.fallecio) then
        begin
            writeln('DATOS VIVO ', 'numero:', regMae.concepcion.numeroDeNacimiento,' nombre:', regMae.concepcion.nombre,' apellido:', regMae.concepcion.apellido,' ciudad:', regMae.concepcion.direccion.ciudad,' matricula:', regMae.concepcion.matriculaDelMedico);
            writeln('DATOS MUERTE ', 'nombreMedico:', regMae.muerte.nombreDelMedico,' Lugar:', regMae.muerte.lugar);
            writeln('');
        end
        else
        begin
            writeln('DATOS VIVO ', 'numero:', regMae.concepcion.numeroDeNacimiento,' nombre:', regMae.concepcion.nombre,' apellido:', regMae.concepcion.apellido,' ciudad:', regMae.concepcion.direccion.ciudad,' matricula:', regMae.concepcion.matriculaDelMedico);
            writeln('');
        end;
        
    end;
END.