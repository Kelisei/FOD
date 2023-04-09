program generadorMaestro;
type
  datoMaestro = record
    destino: string;
    fecha: string;
    horaDeSalida: integer;
    asientosDisponibles: integer;
  end;

var
  archivoTexto: Text;
  archivoBinario: file of datoMaestro;
  registro: datoMaestro;

begin
  // Abrir el archivo de texto en modo lectura
  assign(archivoTexto, 'maestro.txt');
  reset(archivoTexto);

  // Crear el archivo binario en modo escritura
  assign(archivoBinario, 'maestro');
  rewrite(archivoBinario);

  while not eof(archivoTexto) do
  begin
    // Leer los campos desde el archivo de texto
    readln(archivoTexto, registro.destino);
    readln(archivoTexto, registro.fecha);
    readln(archivoTexto, registro.horaDeSalida);
    readln(archivoTexto, registro.asientosDisponibles);

    // Escribir el registro en el archivo binario
    write(archivoBinario, registro);
  end;

  // Cerrar los archivos
  close(archivoTexto);
  close(archivoBinario);

  writeln('Archivo binario generado exitosamente.');

end.