program generarMaestro;

type
  acceso = record
    anio: integer;
    mes: integer;
    dia: integer;
    idUsuario: integer;
    tiempoDeAcceso: integer;
  end;

var
  archivoTxt: Text;
  archivoBinario: file of acceso;
  registro: acceso;

begin
  // Abrir el archivo de texto en modo lectura
  Assign(archivoTxt, 'archivo.txt');
  Reset(archivoTxt);

  // Crear el archivo binario en modo escritura
  Assign(archivoBinario, 'maestro.bin');
  Rewrite(archivoBinario);

  // Leer registros del archivo de texto y escribirlos en el archivo binario
  while not EOF(archivoTxt) do
  begin
    // Leer campos del registro desde el archivo de texto
    ReadLn(archivoTxt, registro.anio);
    ReadLn(archivoTxt, registro.mes);
    ReadLn(archivoTxt, registro.dia);
    ReadLn(archivoTxt, registro.idUsuario);
    ReadLn(archivoTxt, registro.tiempoDeAcceso);

    // Escribir el registro en el archivo binario
    Write(archivoBinario, registro);
  end;

  // Cerrar los archivos
  Close(archivoTxt);
  Close(archivoBinario);

  WriteLn('Archivo convertido a binario.');

end.