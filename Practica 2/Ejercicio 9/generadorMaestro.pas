program generadorMaestro;

type
  TVoto = record
    codProvincia: integer;
    codLocalidad: integer;
    mesa: integer;
    votos: integer;
  end;

var
  archivoTexto: Text;
  archivoBinario: file of TVoto;
  voto: TVoto;

begin
  // Abrir archivos
  assign(archivoTexto, 'datos.txt');
  reset(archivoTexto);
  assign(archivoBinario, 'maestro.bin');
  rewrite(archivoBinario);

  // Leer datos desde el archivo de texto y escribirlos en el archivo binario
  while not eof(archivoTexto) do
  begin
    read(archivoTexto, voto.codProvincia, voto.codLocalidad, voto.mesa, voto.votos);
    write(archivoBinario, voto);
  end;

  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);
end.
