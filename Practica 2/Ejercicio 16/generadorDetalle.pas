program generadorDetalle;

type
  datoDetalle = record
    fecha: LongInt;
    codigo: Integer;
    cantEjemplares: Integer;
  end;

var
  archivoTxt: Text;
  archivoBin: file of datoDetalle;
  dato: datoDetalle;

begin
  // Abrir archivo de texto en modo lectura
  Assign(archivoTxt, 'detalle.txt');
  Reset(archivoTxt);

  // Crear archivo binario en modo escritura
  Assign(archivoBin, 'detalle');
  Rewrite(archivoBin);

  // Leer datos del archivo de texto y escribir en el archivo binario
  while not Eof(archivoTxt) do
  begin
    ReadLn(archivoTxt, dato.fecha, dato.codigo, dato.cantEjemplares);
    Write(archivoBin, dato);
  end;

  // Cerrar archivos
  Close(archivoTxt);
  Close(archivoBin);

  // Mostrar mensaje de éxito
  WriteLn('Archivo convertido a binario correctamente.');
end.
