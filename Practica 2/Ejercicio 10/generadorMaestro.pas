program generadorMaestro;

type
  empleado = record
    departamento: string;
    division: integer;
    numero: integer;
    categoria: integer;
    cantHorasExtras: integer;
  end;

var
  archivoTxt: text;
  archivoBin: file of empleado;
  emp: empleado;

begin
  // Abrir el archivo de texto para lectura
  assign(archivoTxt, 'empleados.txt');
  reset(archivoTxt);

  // Abrir el archivo binario para escritura
  assign(archivoBin, 'empleados.bin');
  rewrite(archivoBin);

  // Leer datos del archivo de texto y guardarlos en el archivo binario
  while not eof(archivoTxt) do
  begin
    readln(archivoTxt, emp.departamento);
    readln(archivoTxt, emp.division);
    readln(archivoTxt, emp.numero);
    readln(archivoTxt, emp.categoria);
    readln(archivoTxt, emp.cantHorasExtras);
    write(archivoBin, emp);
  end;

  // Cerrar los archivos
  close(archivoTxt);
  close(archivoBin);

  writeln('Datos guardados en archivo binario.');
end.
