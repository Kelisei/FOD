program generadorMaestro;

type
    cliente = record
        codigo: integer;
        nombre: string;
        apellido: string;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: double;
    end;

var
    archivoTxt: text;
    archivoBin: file of cliente;
    registro: cliente;

begin
    // Abrir el archivo de texto para leer
    assign(archivoTxt, 'datos.txt');
    reset(archivoTxt);

    // Abrir el archivo binario para escribir
    assign(archivoBin, 'maestro.bin');
    rewrite(archivoBin);

    // Leer los datos del archivo de texto y escribirlos en el archivo binario
    while not eof(archivoTxt) do
    begin
        // Leer los datos del archivo de texto
        readln(archivoTxt, registro.codigo, registro.nombre);
        readln(archivoTxt, registro.apellido);
        readln(archivoTxt, registro.anio, registro.mes, registro.dia, registro.monto);
        // Escribir los datos en el archivo binario
        write(archivoBin, registro);
    end;

    // Cerrar los archivos
    close(archivoTxt);
    close(archivoBin);
end.
