# Resumen de temas

[Archivos](#archivos)
[Arboles](#arboles)
[Hashing](#hashing)

## Archivos

### Declaración de tipos

```Pascal
type
    archivo = file of integer;
```

```Pascal
type
    alumno = record 
        dni: string;
        nombre: string;
        apellido: string;
    end;
    archivo = file of alumno;
```

### Funciones

```Pascal
var
    arch:archivo; alum:alumno;
begin
    Assign(arch, 'archivo.bin');
    Rewrite(arch);
    Reset(arch);
    Seek(a , 32);
    Read(a, alum);
    Write(a, alum);
    Truncate(a);
    Close(arch);
end.
```
### Algoritmos


## Arboles

```Pascal
writeln("Hello World");
```

## Hashing

```Pascal
writeln("Hello World");
```
