
{ 3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}
Program p2ej3;
Const 
  valor_alto = 9999;
  sucu = 30;
Type 
  producto = Record
    cod : Integer;
    nombre: string[30];
    descripcion : String [50];
    stockDis : integer;
    stockMin : integer;
    precio : double;
  End;
  producto_detalle =record
    cod : Integer;
    cantVendida : integer;
  end;
  maestro = file of producto;
  detalle = file of producto_detalle;
  sucursales = array [1..sucu] of detalle;
  registros = array [1..sucu] of  producto_detalle;
   
procedure informarB (var mae: maestro);
var
  auxMaestro: producto;
begin
  writeln('========================================[Informe]========================================');
  Reset(mae);
  while not eof(mae) do begin
    read(mae, auxMaestro);
    if (auxMaestro.stockMin > auxMaestro.stockDis) then begin
      with auxMaestro do begin
        writeln('----------------------------------------------------------------------------------------------------------');
        writeln('Codigo: ', cod , ' Nombre: ', nombre, ' Descripccion:', ' Stock Disponible: ', stockDis, ' Stock Minimo ', stockMin, ' Precio', precio:2:2);
        writeln('----------------------------------------------------------------------------------------------------------');
      end;
    end;
  end;
  Close(mae);
end;

procedure leer (var det : detalle; var aux : producto_detalle);
begin
  if not eof (det) then begin
    read(det, aux);
  end else
    aux.cod:= valor_alto;
end;

procedure minimo (var datos: registros; var min:producto_detalle; var archDet: sucursales);
var
  i, pos:integer;
begin
  min.cod := valor_alto;
  for i:= 1 to 30 do begin
    if(datos[i].cod < min.cod) then begin
      pos:=i;
      min:= datos[i];
    end;
  end;
  if (min.cod <> valor_alto) THEN 
    leer(archDet[pos], datos[pos]);
end;


procedure actualizarMaestro(Var mae: maestro; var vectorSucursales: sucursales);
var
  auxMaestro: producto;
  min: producto_detalle;
  vectorDetalles: registros;
  nombre: string;
  iString:string[10];
  i: Integer;
begin
  for i:= 1 to 30 do begin
    str(i,iString);
    nombre := ('detalle1 - copia ('+ iString+')');
    Assign(vectorSucursales[i], nombre);
    Reset(vectorSucursales[i]);
    Leer(vectorSucursales[i] , vectorDetalles[i]);
  end;
  Reset(mae);
  minimo(vectorDetalles, min, vectorSucursales);
  while (min.cod <> valor_alto) do begin
    read(mae, auxMaestro);
    while (auxMaestro.cod <> min.cod) do read(mae, auxMaestro);
    while (auxMaestro.cod = min.cod) do begin
      auxMaestro.stockDis := auxMaestro.stockDis - min.cantVendida;
      minimo(vectorDetalles, min, vectorSucursales);
    end;
    //WRITELN('Datos aux a escribir:',auxMaestro.nombre, auxMaestro.stockDis);
    seek(mae, filepos(mae) -1 );
    write(mae,auxMaestro);
  end;
  close(mae);
  for i:= 1 to 30 do close(vectorSucursales[i]);
  Writeln('Actualizacion realizada con exito');
end;

PROCEDURE creoMaestro(var mae:maestro);
var
  auxM: producto;
  txt : text;
begin
  Assign(txt,'maestro.txt');
  Assign(mae,'maestro');
  reset(txt);
  Rewrite(mae);
  while not eof(txt) do begin
    with auxM do begin
      readln(txt, cod, nombre);
      readln(txt, stockDis, stockMin, descripcion);
      readln(txt, precio);
    end;
    write(mae, auxM);
  end;
  WriteLn('Maestro creado con exito');
end;
procedure crearDetalle(); 
  var
    txt: text;
    det: detalle;
    auxD: producto_detalle;
    nombre: String[30]; 
    iString: String[30]; 
  begin
      assign(txt, 'detalle.txt');
      reset(txt);
      nombre := ('detalle1 - copia (1)');
      assign(det,nombre);
      Rewrite(det);
      while not eof (txt)do begin
        read(txt, auxD.cod, auxD.cantVendida);
        write(det,auxD);
      end;
      close(det);
    close(txt);
    WriteLn('detalle creado con exito');
  end;
//para que ande el programa luego de crearel archivo detalle copiarlo 30 veces y cambiar los numeros de 1..30
var
  mae:maestro;
  arrayDet: sucursales;
Begin
  creoMaestro(mae);
  //crearArrayDetalles(arrayDet);
  actualizarMaestro(mae,arrayDet);
  informarB(mae);
End.