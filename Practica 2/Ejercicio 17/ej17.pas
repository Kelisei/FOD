program ej17;
{17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles}
const 
    valorAlto = 9999;
    df = 10;
type
    datMae = record
        cod:integer;
        nombre:string;
        descripccion:string;
        modelo: string;
        marca: string;
        stock: integer;
    end;
    datDet = record
        cod:integer;
        precio:real;
        fecha:longint;
    end;
    det = file of datDet;
    mae = file of datMae;
    arrDet = array [1..df] of det;
    arrReg = array [1..df] of datDet;
procedure CrearMaestro(var m:mae);
var
    aux:datMae; txt:text;
begin
    Assign(m, 'maestro');
    Rewrite(m);
    Assign(txt, 'maestro.txt');
    Reset(txt);
    while (not eof(txt)) do begin
        ReadLn(txt, aux.cod);
        ReadLn(txt, aux.nombre);
        ReadLn(txt, aux.modelo);
        ReadLn(txt, aux.descripccion);
        ReadLn(txt, aux.marca);
        ReadLn(txt, aux.stock);
        Write(m, aux);
    end;
    Close(m);
    Close(txt);
    WriteLn('Maestro creados con exito');
end;
procedure CrearDetalle(var dets:arrDet);
var
    i:integer; iStr: string; aux:datDet; txt:text;
begin
    for i:= 1 to df do begin
        Str(i, iStr);
        Assign(dets[i], ('detalle'+iStr));
        Rewrite(dets[i]);
    end;
    Assign(txt, 'detalle.txt');
    Reset(txt);
    while (not eof(txt)) do begin
        ReadLn(txt, aux.cod);
        ReadLn(txt, aux.precio);
        Readln(txt, aux.fecha);
        for i:= 1 to df do
            Write(dets[i], aux);
    end;
    for i:= 1 to df do 
        Close(dets[i]);
    Close(txt);
    WriteLn('Detalles creados con exito');
end;
procedure Leer(var d:det; var reg:datDet);
begin
    if (not eof(d)) then read(d, reg)
    else reg.cod:=valorAlto;
end;
procedure Minimo(var regs:arrReg; var dets: arrDet; var min: datDet);
var
    i:integer; pos:integer;
begin
    min.cod:=valorAlto;
    for i:= 1 to df do
        if (regs[i].cod < min.cod) then begin
          min:=regs[i];
          pos:=i;
        end;
    if (min.cod <> valorAlto) then
        Leer(dets[pos], regs[pos]);
end;
procedure ActualizarMaestro(var m: mae; var dets:arrDet);
var
    i:integer; regs:arrReg;  actual:datMae; min:datDet;
    maxVentas:integer; maxMoto:String; totalVentas:integer;
begin
    for i:= 1 to df do begin
        Reset(dets[i]);
        Leer(dets[i], regs[i]);
    end;    
    Reset(m); 
    Minimo(regs, dets, min); Read(m, actual);
    maxVentas:= -1;
    while(min.cod <> valorAlto) do begin
        while(min.cod <> actual.cod) do read(m, actual);
        totalVentas:=0;
        while(min.cod = actual.cod) do begin
            totalVentas:=totalVentas+1;
            Minimo(regs, dets, min); 
        end;
        actual.stock:= actual.stock - totalVentas;
        if(totalVentas > maxVentas) then begin
            maxVentas:=totalVentas;
            maxMoto:=actual.nombre;
        end;
        Seek(m, FilePos(m)-1);
        Write(m,  actual);
    end;
    Writeln('Moto mas vendida', maxMoto);
    for i:= 1 to df do Close(dets[i]);
    Close(m);
    Writeln('Actualizacion realizada con exito');
    
end;
var
    dets:arrDet; m:mae; aux:datMae;
begin
    CrearMaestro(m); CrearDetalle(dets);
    Reset(m);
    ActualizarMaestro(m, dets);
    Reset(m);
end.