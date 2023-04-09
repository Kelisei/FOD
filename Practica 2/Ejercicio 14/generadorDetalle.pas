program generadorDetalle;

type
  datoDetalle = record
    destino: string;
    fecha: string;
    horaDeSalida: integer;
    asientosComprados: integer;
  end;

var
  archivoTexto: Text;
  archivoBinario: file of datoDetalle;
  registro: datoDetalle;

begin
  // Abrir el archivo de texto en modo lectura
  assign(archivoTexto, 'det.txt');
  reset(archivoTexto);

  // Crear el archivo binario en modo escritura
  assign(archivoBinario, 'det');
  rewrite(archivoBinario);

  while not eof(archivoTexto) do
  begin
    // Leer los campos desde el archivo de texto
    readln(archivoTexto, registro.destino);
    readln(archivoTexto, registro.fecha);
    readln(archivoTexto, registro.horaDeSalida);
    readln(archivoTexto, registro.asientosComprados);

    // Escribir el registro en el archivo binario
    write(archivoBinario, registro);
  end;

  // Cerrar los archivos
  close(archivoTexto);
  close(archivoBinario);

  writeln('Archivo binario generado exitosamente.');

end.