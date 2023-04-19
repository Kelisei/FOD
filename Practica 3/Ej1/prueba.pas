Program prueba;

{ Program to demonstrate the Truncate function. }

Var F : File of longint;
    I,L : Longint;

begin
  Assign (F,'test.tmp');
  Rewrite (F);
  For I:=1 to 10 Do
    Write (F,I);
  Writeln ('Filesize before Truncate : ',FileSize(F));
  Close (f);
  Reset (F);
  Seek(f, 5);
  Truncate (F);
  Writeln(I);
  Writeln ('Filesize after Truncate  : ',Filesize(F));
  Close (f);
  Reset(F);
  while not eof(F) do begin
      read(F, I);
      WriteLn(I);
  end;
  Close(F);
end.

