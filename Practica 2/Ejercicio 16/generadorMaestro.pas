program generadorMaestro;
type
  datoMaestro = record
    fecha: LongInt;
    codigo: Integer;
    nombre: String;
    descripccion: String;
    precio: Real;
    cantEjemplares: Integer;
  end;

var
  archivoTxt: TextFile;
  archivoBin: file of datoMaestro;
  dato: datoMaestro;

begin
  Assign(archivoTxt, 'maestro.txt'); // Cambiar el nombre del archivo de texto a procesar
  Assign(archivoBin, 'maestro'); // Nombre del archivo binario de salida
  Reset(archivoTxt);
  Rewrite(archivoBin);

  while not EOF(archivoTxt) do
  begin
    // Leer los campos del archivo de texto
    ReadLn(archivoTxt, dato.fecha);
    ReadLn(archivoTxt, dato.codigo);
    ReadLn(archivoTxt, dato.nombre);
    ReadLn(archivoTxt, dato.descripccion);
    ReadLn(archivoTxt, dato.precio);
    ReadLn(archivoTxt, dato.cantEjemplares);

    // Escribir el registro en el archivo binario
    Write(archivoBin, dato);
  end;

  Close(archivoTxt);
  Close(archivoBin);

  Writeln('Archivo binario creado exitosamente.');
end.
