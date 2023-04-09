program generarMensajes;
type
  mensaje = record
    nroUsuario: integer;
    cuentaDestino: integer;
    cuerpoMensaje: string;
  end;

var
  archivoTexto: text;
  archivoBinario: file of mensaje;
  registro: mensaje;

begin
  // Abrir archivo de texto en modo de lectura
  assign(archivoTexto, 'mensajes.txt');
  reset(archivoTexto);

  // Abrir archivo binario en modo de escritura
  assign(archivoBinario, 'logmail.dat');
  rewrite(archivoBinario);

  // Leer datos del archivo de texto y escribirlos en el archivo binario
  while not eof(archivoTexto) do
  begin
    readln(archivoTexto, registro.nroUsuario);
    readln(archivoTexto, registro.cuentaDestino);
    readln(archivoTexto, registro.cuerpoMensaje);
    write(archivoBinario, registro);
  end;

  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);

  writeln('Los mensajes se han convertido de txt a binario correctamente.');

end.
