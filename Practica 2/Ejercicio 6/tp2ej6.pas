Program tp2ej6;
Const 
  valorAlto = 9999;
  df = 2;
Type 
  reporteD = Record
    codigoLocalidad: integer;
    codigoCepa: integer;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  End;
  reporteM = Record
    codigoLocalidad: integer;
    nombreLocalidad: string[30];
    codigoCepa: integer;
    nombreCepa: string[30];
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  End;
  detalle = file Of reporteD;
  maestro = file Of reporteM;
  vDetalle = array [1..df] Of detalle;
  vRegistro = array [1..df] Of reporteD;

Procedure leer (Var det: detalle; Var aux : reporteD);
Begin
  If (Not eof(det)) Then
    read(det, aux)
  Else
  begin
    aux.codigoLocalidad := valorAlto;
    aux.codigoCepa:= valorAlto;
  end;
End;
Procedure minimo( Var vDet: vDetalle ; Var vReg : vRegistro ; Var min: reporteD);
Var 
  i,pos: integer;
Begin
  min.codigoLocalidad := valorAlto;
  min.codigoCepa := valorAlto;
  pos := 0;
  For i:= 1 To df Do
    Begin
      If (vReg[i].codigoLocalidad < min.codigoLocalidad) and (vReg[i].codigoCepa <= min.codigoCepa) Then
        Begin
          min := vReg[i];
          pos := i;
        End;
      If (min.codigoLocalidad <> valorAlto) and (min.codigoCepa <> valorAlto) Then
      begin
        leer(vDet[pos],vReg[pos]);
      end;

    End;
End;


procedure verMaestro (var mae: maestro);
var
  regMae: reporteM;
begin
  writeln('');
  writeln('');
  assign(mae, 'maestro');
  reset(mae);
  While (Not eof(mae)) Do
    Begin
      read(mae,regMae);
      writeln('nombreLocalidad: ', regMae.codigoLocalidad, ' codigoCepa: ',
              regMae.codigoCepa);
      writeln('Nuevos: ', regMae.cantNuevos, ' Fallecidos: ', regMae.
              cantFallecidos);
      writeln('Recuperados: ', regMae.cantRecuperados, ' Activos: ',regMae.
              cantActivos);
    End;
  close(mae);
end;
  //ASIGNAR MAESTRO Y DETALLES
  procedure asignarMyD(var mae: maestro; var vDet:vDetalle; var vReg:vRegistro);
  var 
    i:integer;
    iString:string[30];
  begin  
  For i:= 1 To df Do
    Begin
      Str(i, iString);
      assign(vDet[i], 'detalle'+iString);
      reset(vDet[i]);
      leer(vDet[i], vReg[i]);
    End;
  assign(mae,'maestro');
  reset(mae);
  end;

Var 
  vDet: vDetalle;
  vReg: vRegistro;
  mae: maestro;
  min: reporteD;
  regMae: reporteM;
  i,j: integer;
Begin
  verMaestro(mae);
  asignarMyD(mae,vDet,vReg);
  
  //ACTUALIZAR MAESTRO
  minimo(vDet, vReg, min);

  While (min.codigoLocalidad <> valorAlto) Do Begin
    //Writeln('Dato del min', min.codigoLocalidad, min.codigoCepa, min.cantActivos, min.cantNuevos, min.cantRecuperados, min.cantFallecidos);
    read(mae, regMae);
    While not (regMae.codigoLocalidad = min.codigoLocalidad) and not (regMae.codigoCepa = min.codigoCepa) Do begin
      read(mae,regMae);
    end;
    regMae.cantActivos := min.cantActivos;
    regMae.cantNuevos := min.cantNuevos;
    While (regMae.codigoLocalidad = min.codigoLocalidad) and (regMae.codigoCepa = min.codigoCepa) do begin
        regMae.cantFallecidos := regMae.cantFallecidos + min.cantFallecidos;
        regMae.cantRecuperados := regMae.cantRecuperados + min.cantRecuperados;
        minimo(vDet, vReg, min);
       // Writeln('Dato del min', min.codigoLocalidad, min.codigoCepa, ' ' ,min.cantActivos,  ' ' ,min.cantNuevos,  ' ' ,min.cantRecuperados,  ' ' ,min.cantFallecidos);
    end;
    writeln('');
    seek(mae, filePos(mae)-1);
    write(mae, regMae);
    Writeln('Dato del regMae', regMae.codigoLocalidad, regMae.codigoCepa,  ' ' ,regMae.cantActivos,  ' ' ,regMae.cantNuevos, regMae.cantRecuperados,  ' ' ,regMae.cantFallecidos);
    writeln('Reg agregado en ', filePos(mae)-1);
    //minimo(vDet, vReg, min);
  End;    

    
  //CLOSE DE MAESTRO Y DETALLES
  For i:=1 To df Do
    close(vDet[i]);
  close(mae);


writeln('');
    writeln('');
  verMaestro(mae);
End.
