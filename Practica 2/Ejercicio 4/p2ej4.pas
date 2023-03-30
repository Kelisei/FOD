{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program p2ej4;
const
  valor_alto = 32767;
type
  informeDet = record
    cod_usuario : integer;
    fecha : LongInt; 
    tiempo_sesion : integer;
  end;
  informeMae = record
    cod_usuario : integer;
    fecha : LongInt;
    tiempo_total_de_sesiones_abiertas: integer;
  end;
  detalle = file of informeDet;
  maestro = file of informeMae;
  arrDetalle = array [1..5] of detalle;
  arrInforme = array [1..5] of informeDet;

procedure leer(var det : detalle; var aux: informeDet);
begin
  if not eof (det)then 
    read(det,aux)
  else aux.cod_usuario:= valor_alto;  
end;

{Debemos recibir 5 archivos, y generar un maestro que reuna todo acumulamos en todos los archivos}
procedure merge (vDetalles: arrDetalle; var mae : maestro);
  procedure minimo(var detalles:arrDetalle; var regInformes: arrInforme; var min:informeDet);
    var
      i:integer; pos:integer;
    begin
      min.cod_usuario:=valor_alto;
      min.fecha:= 99999999;
      for i:=1 to 5 do begin
        if ((regInformes[i].cod_usuario <= min.cod_usuario)and(regInformes[i].fecha <= min.fecha)) then begin
            min:=regInformes[i];
            pos:=i;
        end;
      end;
      if (min.cod_usuario <> valor_alto) then begin
        Leer(detalles[pos], regInformes[pos]);
      end;
    end;
var
    min: informeDet;
    actual: informeMae;
    regInformes: arrInforme;
    i:integer;
    ind:String[3];
begin
    Assign(mae, 'maestro');
    Rewrite(mae);
    for i:=1 to 5 do begin
        str(i,ind); 
        assign(vDetalles[i], ('detalle('+ind+')'));
        reset(vDetalles[i]);
        Leer(vDetalles[i],regInformes[i]);
    end;
    minimo(vDetalles,regInformes, min);
    while (min.cod_usuario <> valor_alto) do begin
      actual.cod_usuario:= min.cod_usuario;
      while (actual.cod_usuario = min.cod_usuario) do begin
        actual.fecha:= min.fecha;
        actual.tiempo_total_de_sesiones_abiertas := 0;
        while (actual.fecha = min.fecha) do begin
            actual.tiempo_total_de_sesiones_abiertas:= actual.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
            minimo(vDetalles,regInformes, min);
        end;
      Write(mae,actual);  
      end;
    end;
   Close(mae);close(vDetalles[1]); close(vDetalles[2]);close(vDetalles[3]);close(vDetalles[4]);close(vDetalles[5]);
   writeln('Terminado el merge')
end;

procedure crearDetalles(Var vectorDetalle: arrDetalle);
var
  aux : informeDet;
  txt : text;
  ind:string[3];
  det1,det2,det3,det4,det5: detalle;
  i:integer;
  nombre:string;
begin
    assign(det1,'detalle(1)');
    assign(det2,'detalle(2)');
    assign(det3,'detalle(3)');
    assign(det4,'detalle(4)');
    assign(det5,'detalle(5)');
    rewrite(det1);
    rewrite(det2);
    rewrite(det3);
    rewrite(det4);
    rewrite(det5);
  for i:=1 to 5 do begin
    str(i,ind);
    nombre:= 'detalle('+ind+').txt';
    assign(txt,nombre);
    Reset(txt);
    while not eof (txt) do begin
      readln(txt, aux.cod_usuario, aux.tiempo_sesion, aux.fecha);
      case i of
        1: Write(det1,aux);
        2: Write(det2,aux);
        3: Write(det3,aux);
        4: Write(det4,aux);
        5: Write(det5,aux);
      end;
    end;
    close(txt);
  end;
  vectorDetalle[1]:=det1; vectorDetalle[2]:=det2; vectorDetalle[3]:=det3; vectorDetalle[4]:=det4; vectorDetalle[5]:=det5;
  close(det1);close(det2);close(det3);close(det4);close(det5);
  WriteLn('Detalles creados con exito');
end;
procedure verMae(var mae:maestro);
var
 actual:informeMae;
begin
  Assign(mae, 'maestro');
  reset(mae);
  while not eof (mae) do begin
    read(mae,actual);
    writeln('----------------------------------------------------------------------------------------------------------');
    WriteLn(actual.cod_usuario, ' ', actual.fecha, ' ', actual.tiempo_total_de_sesiones_abiertas);
  end;
  close(mae);
end;

var
  vectorDetalle:arrDetalle; 
  mae:maestro;
begin
  crearDetalles(vectorDetalle);
  merge(vectorDetalle, mae);
  verMae(mae);
end.