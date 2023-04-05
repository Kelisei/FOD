program generadorDetalle;
type
  venta = record
    codigo: integer;
    cantVendida: integer;
  end;

var
  ventasFile: file of venta;
  ventasTextFile: text;
  v: venta;

begin
  // Abrir el archivo de texto para lectura
  assign(ventasTextFile, 'ventas.txt');
  reset(ventasTextFile);
  
  // Abrir el archivo binario para escritura
  assign(ventasFile, 'detalle.bin');
  rewrite(ventasFile);
  
  // Leer los datos del archivo de texto y guardarlos en el archivo binario
  while not eof(ventasTextFile) do begin
    readln(ventasTextFile, v.codigo, v.cantVendida);
    write(ventasFile, v);
  end;
  
  // Cerrar los archivos
  close(ventasTextFile);
  close(ventasFile);
end.
