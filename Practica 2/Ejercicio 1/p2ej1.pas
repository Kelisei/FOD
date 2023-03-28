
{ 1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

Program p2ej1;

Const valoralto = 9999;
Type 
  nombres = String[30];
  empleado = Record
    cod_empleado : Integer;
    nombre : nombres;
    monto : Double;
  End;
  archivo = file Of empleado;

Procedure crearArchivoMaestro(Var arch_logico:archivo);
Var 
  carga: text;
  emp: empleado;
Begin
  assign(arch_logico, 'maestro_uno');
  assign(carga, 'empleados.txt');
  rewrite(arch_logico);
  reset(carga);
  While (Not  eof(carga)) Do
    Begin
      readln(carga, emp.cod_empleado);
      readln(carga, emp.nombre);
      readln(carga, emp.monto);
      write(arch_logico, emp);
    End;
  writeln('Archivo cargado.');
  close(arch_logico);
End;

Procedure leer( Var arch: archivo; Var aux: empleado);
 Begin
  If (Not eof (arch)) Then
    read (arch, aux)
  Else
    aux.cod_empleado := valoralto;
 End;

  procedure verBinarios(var arch : archivo ; var arch_nuevo : archivo);
   procedure bin(var arch: archivo);
   var
      aux:empleado;
    begin
      while not eof(arch) do begin
        read(arch,aux);
        WriteLn('COD: ', aux.cod_empleado , ', NOMBRE: ', aux.nombre, ', Monto $$', aux.monto:2:2);
      end;
    end;
    begin
      assign(arch, 'maestro_uno');
      Assign(arch_nuevo, 'maestro_compacto');
      Reset(arch);
      Reset(arch_nuevo);
      WriteLn('TABLA ORIGINAL: ');
      bin(arch);
      WriteLn('----------------------------------------------------------------');
      WriteLn('TABLA COMPACTA: ');
      bin(arch_nuevo);
      WriteLn('----------------------------------------------------------------');
      Close(arch);
      Close(arch_nuevo);
    end;
procedure compactarBin(var arch : archivo ; var arch_nuevo : archivo);
 var
   aux, aux2 : empleado;
 begin
   assign(arch, 'maestro_uno');
   Assign(arch_nuevo, 'maestro_compacto');
   Reset(arch);
   Rewrite(arch_nuevo);
   leer(arch, aux);  {leo el dato, si esta vacio el archivo aux.cod:=9999}
   while (aux.cod_empleado <> valoralto) do begin
     aux2:=aux;
     aux2.monto:=0;
     while (aux2.cod_empleado = aux.cod_empleado) do begin
       aux2.monto:= aux2.monto + aux.monto;
       leer(arch,aux);
     end;
     Write(arch_nuevo, aux2);
   end;
   WriteLn(' Archivo creado con exito');
   close(arch);
   close(arch_nuevo);
 end;

procedure menu();
 var
    opcion: integer;
    arch, arch_nuevo: archivo;
 begin
  repeat
    WriteLn('Bienvenido que desea realizar? :');
    WriteLn('0-Crear archivo MAestro con "empleado.txt" ');
    WriteLn('1-compactar archivo BIN + crea archivo nuevo');
    WriteLn('2-visualizar arhivos BIN(TEST de funcionamiento )');
    WriteLn('3-Salir');
    ReadLn(opcion);
    case (opcion) of 
      0: crearArchivoMaestro(arch);
      1: compactarBin(arch, arch_nuevo);
      2: verBinarios(arch, arch_nuevo);
      3: WriteLn('saliste')
      else WriteLn('opcion no valida, intente nuevamente')
    end;
  until (opcion = 3);
end;

Begin
    menu();
End.
