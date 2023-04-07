program generarDetalle;

type
  TRegistro = record
    nombre: string;
    codLocalidad: integer;
    alfabetizados: integer;
    encuestados: integer;
  end;
    
var
    archivoTxt: TextFile;
    registro: TRegistro;
    detalle: file of TRegistro;
begin
    // Abrir archivo de texto para lectura
    Assign(archivoTxt, 'det.txt');
    Reset(archivoTxt);
    Assign(detalle, 'det');
    Rewrite(detalle);
    // Leer y procesar cada línea del archivo de texto
    while not Eof(archivoTxt) do
    begin
        // Leer campos del archivo de texto
        ReadLn(archivoTxt, registro.nombre);
        ReadLn(archivoTxt, registro.codLocalidad);
        ReadLn(archivoTxt, registro.alfabetizados);
        ReadLn(archivoTxt, registro.encuestados);

        // Realizar el procesamiento deseado con los datos leídos
        // En este ejemplo, simplemente se muestra en pantalla
        WriteLn('Nombre: ', registro.nombre);
        WriteLn('CodLocalidad: ', registro.codLocalidad);
        WriteLn('Alfabetizados: ', registro.alfabetizados);
        WriteLn('Encuestados: ', registro.encuestados);
        WriteLn('------------------------');
        Write(detalle, registro)
    end;

    // Cerrar archivo
    Close(archivoTxt);
    end.
