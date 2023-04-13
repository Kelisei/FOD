program generadorDetalle;

type
  datoDetalle = record
    codPcia: integer;
    codLoc: integer;
    conLuz: integer;
    construidas: integer;  // Resta a las de chapas
    conAgua: integer;
    conGas: integer;
    conSanitario: integer;
  end;

var
  archivoTexto: Text;
  archivoBinario: file of datoDetalle;
  detalle: datoDetalle;

begin
  // Asignar archivo de texto para lectura
  Assign(archivoTexto, 'detalle.txt');
  Reset(archivoTexto);

  // Asignar archivo binario para escritura
  Assign(archivoBinario, 'detalle.dat');
  Rewrite(archivoBinario);

  // Leer datos del archivo de texto y guardarlos en el archivo binario
  while not Eof(archivoTexto) do
  begin
    Read(archivoTexto, detalle.codPcia, detalle.codLoc, detalle.conLuz, detalle.construidas, detalle.conAgua, detalle.conGas, detalle.conSanitario);
    Write(archivoBinario, detalle);
  end;

  // Cerrar archivos
  Close(archivoTexto);
  Close(archivoBinario);

  // Mostrar mensaje de finalización
  WriteLn('El archivo se ha convertido a binario exitosamente.');

end.
