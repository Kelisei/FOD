program siete;
type
    ave = record
        codigo:integer;
        nombre:String;
        familia:String;
        descripcion:String;
        zonaGeografica:String;
    end;
    archivo = file of ave;
procedure MarcarEliminados(var arch:archivo);
var
    codigo:Int32; encontre:Boolean; aux:ave;
begin
    Reset(arch);
    readln(codigo);
    while(codigo <> 50000) do begin
        encontre:=False;
        while((not encontre) and (not eof (arch))) do begin
            Read(arch, aux);
            encontre := (aux.codigo = codigo);
        end;
        if(encontre) then begin
            Seek(arch, FilePos(arch)-1);
            aux.codigo:=-1;
            Write(arch, aux);
        end;
        Seek(arch, 0);
        Readln(codigo);
    end;
    Close(arch);
end;
procedure EliminarMarcados(var arch:archivo);
var 
    pos:Integer; actual, intercambio:ave;
begin
    Reset(arch);
    while(not eof (arch)) do begin
        Read(arch, actual);
        if (actual.codigo < -1) then begin
            pos:=FilePos(arch)-1;
            Seek(arch, FileSize(arch)-1);
            Read(arch, intercambio);
            Seek(arch, pos);
            Write(arch, intercambio);
            Seek(arch, FileSize(arch)-1);
            Truncate(arch);
            Seek(arch, pos);
        end;
    end;
    Close(arch);
end;
begin
    
end.