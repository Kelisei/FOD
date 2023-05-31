program parcial2019;
const
    valorAlto = 9999;
    df = 30;
type
    fechas = record
        dia: integer;
        mes: integer;
        anio: integer;
    end;
    sucursal = record
        cod_farmaco: integer;
        nombre: string;
        fecha: fechas;
        cantidad_vendida: integer;
        forma_pago : string;
    end;
    archivo = file of sucursal;
    v_detalle = array [1..df] of archivo;
    v_registro = array [1..df] of sucursal;
    v_contador = array [1..df] of integer;

procedure leer (var a:archivo ; var r:sucursal);
begin
    if (not eof(a))then
        read(a,r)
    else
        r.cod_farmaco := valorAlto;
end;

procedure inicializarVcontador(var v : v_contador);
var
    i: integer;
begin
    for i:=1 to df do
      v[i]:=0;
end;

procedure asignar(var v_det: v_detalle; var v_reg: v_registro);
var 
    iString:string;
    i:integer;
begin
    for i:= 1 to df do begin
        str(i, iString);
        assign(v_det[i], 'det'+iString);
        reset(v_det[i]);
        leer(v_det[i],v_reg[i]);
    end;
end;

procedure minimo(var v_det: v_detalle; var v_reg: v_registro ; var min: sucursal);
var
    i,pos:integer;
begin
    min.cod_farmaco:= valorAlto;
    for i:= 1 to df do begin
        if ((v_reg[i].cod_farmaco<min.cod_farmaco) or ((v_reg[i].cod_farmaco = min.cod_farmaco)and (v_reg[i].fecha < min.fecha))) then begin
            min:= v_reg[i];
            pos:= i
        end;
    end;
    if (min.cod_farmaco <> valorAlto)then
        leer (v_det[pos],v_reg[pos]);
end;

procedure recorrido(var v_det: v_detalle;var  v_reg: v_registro);
    procedure pagosContado(v:v_contador);
    var
        i, max,pos: Integer;
    begin
        max:= -999;
        for i:=1 to df do 
            if (v[i]>max)then begin
                max:= v[i];
                pos:= i;              
            end;
        WriteLn('El dia de mayor ventas al contado fue el: ',pos, ' con ',max,' ventas.')
    end;
var
    min, actual: sucursal;
    max_cod,max_cant,cantidad_vendida_total:integer;
    v_cont: v_contador;
    texto: Text;
begin
    max_cant = -1;
    assign(texto,'texto.txt');
    rewrite(texto);
    inicializarVcontador(v_cont);
    minimo(v_det,v_reg,min);
    while (min<> valorAlto) do begin
        actual.cod_farmaco := min.cod_farmaco;
        cantidad_vendida_total = 0;
        actual.nombre:=min.nombre;
        while (actual.cod_farmaco = min.cod_farmaco) do begin
            actual.fecha := min.fecha;
            actual.cantidad_vendida:=0;
            while (actual.cod_farmaco = min.cod_farmaco) and (actual.fecha = min.fecha ) do begin                
                actual.cantidad_vendida = actual.cantidad_vendida + min.cantidad_vendida;
                cantidad_vendida_total:=cantidad_vendida_total + min.cantidad_vendida;
                if (min.forma_pago = 'contado') then
                    v_cont[min.fecha.dia]:= v_cont[min.cod_farmaco.dia]+1;
                minimo(v_det,v_reg,min);
            end;
            with actual do
                write(texto,cod_farmaco,' ',fecha.dia,' ',fecha.mes,' ',fecha.anio,' ',cantidad_vendida,' ',nombre);
        end;
        if(cantidad_vendida_total>max_cant)then begin
            max_cant:=cantidad_vendida_total;
            max_cod:=actual.cod_farmaco;
        end;
    end;
    WriteLn('Farmaco mayor vendido ', max_cod,', con ',max_cant,' ventas.');
    pagosContado(v_cont);
    close(texto);
    for i:= 1 to df do
        close(det) 
end;

var 
    v_det : v_detalle;
    v_reg : v_registro;
begin
    asignar(v_det,v_reg);
end.