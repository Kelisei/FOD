program GenerarMaestro;

type
    producto = record
        codigo: integer;
        nombre: string;
        precio: integer;
        stockActual: integer;
        stockMinimo: integer;
    end;

var
    archivoTexto: text;
    archivoBinario: file of producto;
    p: producto;

begin
    assign(archivoTexto, 'productos.txt');
    reset(archivoTexto);
    assign(archivoBinario, 'maestro.bin');
    rewrite(archivoBinario);

    while not eof(archivoTexto) do
    begin
        readln(archivoTexto, p.codigo, p.nombre);
        readln(archivoTexto, p.precio, p.stockActual, p.stockMinimo);
        write(archivoBinario, p);
    end;

    close(archivoTexto);
    close(archivoBinario);
end.
