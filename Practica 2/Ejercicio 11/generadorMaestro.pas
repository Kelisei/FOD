program generadorMaestro;
type
  TRegistro = record
    nombre: string;
    alfabetizados: integer;
    encuestados: integer;
  end;

var
  archivoTxt: TextFile;
  archivoBinario: file of TRegistro;
  registro: TRegistro;

begin
  // Abrir archivo de texto para lectura
  Assign(archivoTxt, 'maestro.txt');
  Reset(archivoTxt);

  // Crear archivo binario para escritura
  Assign(archivoBinario, 'maestro.bin');
  Rewrite(archivoBinario);

  // Leer y convertir cada línea del archivo de texto a formato binario
  while not Eof(archivoTxt) do
  begin
    // Leer campos del archivo de texto
    ReadLn(archivoTxt, registro.nombre);
    ReadLn(archivoTxt, registro.alfabetizados);
    ReadLn(archivoTxt, registro.encuestados);

    // Escribir registro en archivo binario
    Write(archivoBinario, registro);
  end;

  // Cerrar archivos
  Close(archivoTxt);
  Close(archivoBinario);

  WriteLn('Archivo binario generado exitosamente.');
end.
