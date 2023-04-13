program generadorMaestro;

type
  datoMaestro = record
    codPcia: integer;
    codLoc: integer;
    nombreLoc: string; // Se asume que el nombre de la localidad tiene un máximo de 50 caracteres
    sinLuz: integer;
    sinGas: integer;
    deChapa: integer;
    sinAgua: integer;
    sinSanitario: integer;
  end;

var
  archivoTexto: text;
  archivoBinario: file of datoMaestro;
  registro: datoMaestro;

begin
  // Abrir archivo de texto en modo lectura
  assign(archivoTexto, 'maestro.txt');
  reset(archivoTexto);
  
  // Crear archivo binario en modo escritura
  assign(archivoBinario, 'maestro.dat');
  rewrite(archivoBinario);
  
  // Leer datos del archivo de texto y escribirlos en el archivo binario
  while not eof(archivoTexto) do
  begin
    // Leer datos del archivo de texto
    readln(archivoTexto, registro.codPcia);
    readln(archivoTexto, registro.codLoc);
    readln(archivoTexto, registro.nombreLoc);
    readln(archivoTexto, registro.sinLuz);
    readln(archivoTexto, registro.sinGas);
    readln(archivoTexto, registro.deChapa);
    readln(archivoTexto, registro.sinAgua);
    readln(archivoTexto, registro.sinSanitario);
    
    // Escribir datos en el archivo binario
    write(archivoBinario, registro);
  end;
  
  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);
  
  writeln('Datos convertidos a binario exitosamente.');
end.
