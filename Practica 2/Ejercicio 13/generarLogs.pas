program generarLogs;

type
  log = record
    nroUsuario: integer;
    nombreUsuario: string;
    nombre: string;
    apellido: string;
    cantMailEnviados: integer;
  end;

var
  archivoTexto: text;
  archivoBinario: file of log;
  registro: log;

begin
  // Abrir archivo de texto en modo de lectura
  assign(archivoTexto, 'logs.txt');
  reset(archivoTexto);

  // Abrir archivo binario en modo de escritura
  assign(archivoBinario, 'logs.bin');
  rewrite(archivoBinario);

  // Leer datos del archivo de texto y escribirlos en el archivo binario
  while not eof(archivoTexto) do
  begin
    readln(archivoTexto, registro.nroUsuario);
    readln(archivoTexto, registro.nombreUsuario);
    readln(archivoTexto, registro.nombre);
    readln(archivoTexto, registro.apellido);
    readln(archivoTexto, registro.cantMailEnviados);
    writeln(registro.nroUsuario);
    write(archivoBinario, registro);
  end;
    WriteLn(FileSize(archivoBinario));
  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);

  writeln('Los datos se han convertido de txt a binario correctamente.');

end.
