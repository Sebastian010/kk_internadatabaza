unit Unit1;                                                                     //verzie + kontrolovat nazov

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,LCLType;
const
  n=100;
type
  zoznam = record
    kod,nazov,kodkontrola,nazovkontrola:string;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  subor2:textfile;
  i,j,porovnaj1,porovnaj2,koniec,pocetriadkovT:integer;
  A:array[0..n-1]of zoznam;
  zaklad:array[0..n-1]of string;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);     //nacitanie
var pom,pom2,pom3,pom4:boolean;
    subor,subor6,subor8:textfile;
    slovo,triedenie,triedenie2:string;
    poz,riadky,riadky1:integer;
    F:Longint;
begin
       pom:=false;
       while pom = false do
             Begin
               if not fileexists('sklad_LOCK.txt') then
                  Begin
                     pom:=true;
                     F:=FileCreate('sklad_LOCK.txt');
                     assignfile(subor,'sklad.txt');
                     reset(subor);
                     readln(subor,riadky);
                     for i:=0 to riadky-1 do
                         Begin
                            readln(subor,slovo);
                            poz:=Pos(';',slovo);
                            zaklad[i]:=(Copy(slovo,1,poz-1));
                         end;

                     for i:=0 to riadky-2 do
                         Begin
                           for j:=riadky-1 downto i+1 do
                               Begin
                                 if zaklad[j-1] > zaklad[j] then
                                    Begin
                                      triedenie:=zaklad[j];
                                      zaklad[j]:=zaklad[j-1];
                                      zaklad[j-1]:=triedenie;
                                    end;
                               end;
                         end;

                     for i:=0 to riadky-1 do
                            Listbox1.items.add(zaklad[i]);
                     closefile(subor);
                     FileClose(F);
                     deletefile('sklad_LOCK.txt');
                  end;
             end;

       pom2:=false;
       while pom2 = false do
             Begin
               if not fileexists('tovar_LOCK.txt') then
                  Begin
                     pom2:=true;
                     F:=FileCreate('tovar_LOCK.txt');
                     assignfile(subor2,'tovar.txt');
                     reset(subor2);
                     readln(subor2,riadky1);
                     for i:=0 to riadky1-1 do
                         Begin
                            readln(subor2,slovo);
                            poz:=Pos(';',slovo);
                            A[i].kod:=(Copy(slovo,1,poz-1));
                            A[i].nazov:=(Copy(slovo,poz+1,length(slovo)));
                         end;
                     koniec:=riadky1-1;
                     closefile(subor2);
                     FileClose(F);
                     deletefile('tovar_LOCK.txt');
                  end;
             end;

       for i:=0 to riadky1-2 do
                Begin
                     for j:=riadky1-1 downto i+1 do
                         Begin
                              if A[j-1].kod < A[j].kod then
                                 Begin
                                   triedenie:=A[j].kod;
                                   triedenie2:=A[j].nazov;
                                   A[j].kod:=A[j-1].kod;
                                   A[j].nazov:=A[j-1].nazov;
                                   A[j-1].kod:=triedenie;
                                   A[j-1].nazov:=triedenie2;
                                 end;
                         end;
                end;
       for i:=0 to riadky1-1 do
           Listbox2.items.add(A[i].kod+' '+A[i].nazov);
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  QueryResult: Boolean;
  UserString,nazov,kod,triedenie,triedenie2: string;
  pomoc,pom:boolean;
  F:Longint;
  subor8:textfile;
  BoxStyle,odpoved,riadky:integer;
begin
  inc(koniec);
  pomoc:=true;
  j:=Listbox1.itemindex;
  A[koniec].kod:=listbox1.items[j];
  if InputQuery('Oznam', 'Prosim zadajte nazov tovaru',UserString) then
      Begin
         for i:=0 to koniec-1 do
             Begin
                if Userstring = A[i].nazov then
                   Begin
                     pomoc:=false;
                     dec(koniec);
                     BoxStyle:= MB_ICONQUESTION + MB_OK;
                     odpoved:= Application.MessageBox('Zadany nazov sa uz nachadza v databaze, skuste este raz', 'Upozornenie', BoxStyle);
                   end;
             end;
         if pomoc = true then
             Begin
               Listbox1.items.delete(j);
               A[koniec].nazov:=UserString;
                 for i:=0 to n-2 do
                     Begin
                          for j:=n-1 downto i+1 do
                              Begin
                                   if A[j-1].kod < A[j].kod then
                                      Begin
                                          triedenie:=A[j].kod;
                                          triedenie2:=A[j].nazov;
                                          A[j].kod:=A[j-1].kod;
                                          A[j].nazov:=A[j-1].nazov;
                                          A[j-1].kod:=triedenie;
                                          a[j-1].nazov:=triedenie2;
                                      end;
                              end;
                     end;
           Listbox2.items.clear();
           for i:=0 to koniec do
               Listbox2.items.add(A[i].kod+' '+A[i].nazov);
            end;

  pom:=false;
        while pom = false do
             Begin
               if not fileexists('tovar_LOCK.txt') then
                  Begin
                     pom:=true;
                     F:=FileCreate('tovar_LOCK.txt');
                     assignfile(subor8,'tovar.txt');
                     rewrite(subor8);
                     writeln(subor8,koniec+1);
                     pocetriadkovT:=koniec+1;
                     for i:=0 to koniec do
                         writeln(subor8,A[i].kod+';'+A[i].nazov);
                     closefile(subor8);
                     FileClose(F);
                     deletefile('tovar_LOCK.txt');
                  end;
             end;
end;
end;
procedure TForm1.Timer1Timer(Sender: TObject);
var pom,pom1,pom3:boolean;
    porovnaj,porovnaj1,porovnaj2,porovnaj3,poz,riadky:integer;
    subor,subor1,subor2,subor3:textfile;
    F,G:longint;
    slovo:string;
begin
  pom:=false;
        while pom = false do
             Begin
               if not fileexists('tovarVERZIA_LOCK.txt') then
                  Begin
                     pom:=true;
                     F:=FileCreate('tovarVERZIA_LOCK.txt');
                     assignfile(subor,'tovar_VERZIA.txt');
                     Reset(subor);
                     read(subor,porovnaj);
                     closefile(subor);
                     FileClose(F);
                     deletefile('tovarVERZIA_LOCK.txt');
                  end;
              end;
                     pom1:=false;
                     while pom1 = false do
                           Begin
                                if not fileexists('tovar_LOCK.txt') then
                                   Begin
                                        pom1:=true;
                                        G:=FileCreate('tovar_LOCK.txt');
                                        assignfile(subor1,'tovar.txt');
                                        Reset(subor1);
                                        readln(subor1,riadky);

                                        if riadky <> pocetriadkovT then
                                           Begin
                                             inc(porovnaj);
                                             assignfile(subor,'tovar_VERZIA.txt');
                                             Rewrite(subor);
                                             writeln(porovnaj);
                                             closefile(subor);
                                           End
                                                                   else
                                           Begin
                                                for i:=0 to riadky-1 do
                                                    Begin
                                                         poz:=Pos(';',slovo);
                                                         A[i].kodkontrola:=Copy(slovo,1,poz-1);
                                                         A[i].nazovkontrola:=Copy(slovo,poz,length(slovo));
                                                    end;
                                                for i:=0 to riadky-1 do
                                                    Begin
                                                         if (A[i].kodkontrola <> A[i].kod) or (A[i].nazovkontrola <> A[i].nazov) then
                                                            Begin
                                                               inc(porovnaj);
                                                               assignfile(subor,'tovar_VERZIA.txt');
                                                               Rewrite(subor);
                                                               writeln(porovnaj);
                                                               closefile(subor);
                                                            end;
                                                    end;
                                           end;

                                        closefile(subor1);
                                        FileClose(G);
                                        deletefile('tovar_LOCK.txt');
                                   end;
                           end;

end;

procedure TForm1.Button1Click(Sender: TObject);  //pridat tovar
var pom,pom2,pomoc,pomoc1,pomoc2,pomoc3,QueryResult:boolean;
    UserString,triedenie,triedenie2:string;
    subor8,subor1,subor2:textfile;
    BoxStyle,odpoved:integer;
    intNum,F,G,H:longint;
    strList,strList1:TStringList;
begin
  strList:=TStringList.Create;
  strList1:=TStringList.Create;

  if InputQuery('Oznam', 'Prosim zadajte kod tovaru', UserString)
      then
         Begin
           pomoc:=true;
           pomoc1:=true;
           pomoc2:=true;
           pomoc3:=true;
           inc(koniec);

           if not TryStrToInt(Userstring,intNum) then
              Begin
                BoxStyle:= MB_ICONQUESTION + MB_OK;
                odpoved:= Application.MessageBox('Zadajte prosim ciselnu hodnotu', 'Upozornenie', BoxStyle);
                dec(koniec);
                pomoc2:=false;
              end
                                                 else
              Begin
                if pomoc2 = true then
                   Begin
                if (intNum < 100) or (intNum > 999) then
                   Begin
                        pomoc1:=false;
                        BoxStyle:= MB_ICONQUESTION + MB_OK;
                        odpoved:= Application.MessageBox('Vase cislo nie je 3-ciferne', 'Upozornenie', BoxStyle);
                        dec(koniec);
                   end;
                if pomoc1 = true then
                   Begin
                        for i:=0 to koniec-1 do
                            Begin
                                 if userstring = (A[i].kod)  then
                                    Begin
                                    pomoc:=false;
                                    BoxStyle:= MB_ICONQUESTION + MB_OK;
                                    odpoved:= Application.MessageBox('Zadany kod sa uz nachadza v databaze, skuste este raz', 'Upozornenie', BoxStyle);
                                    dec(koniec);
                                    End;
                            end;
                   end;
                   end;
              end;
             if (pomoc = true) and (pomoc1 = true) and (pomoc2 = true) then A[koniec].kod:=inttostr(intNum);
         end;


   if (pomoc = true) and (pomoc1 = true) and (pomoc2 = true) then
   Begin
   if InputQuery('Oznam', 'Prosim zadajte nazov tovaru', UserString)
      then
         Begin
           for i:=0 to koniec-1 do
             Begin
                if Userstring = A[i].nazov then
                   Begin
                     pomoc3:=false;
                     dec(koniec);
                     BoxStyle:= MB_ICONQUESTION + MB_OK;
                     odpoved:= Application.MessageBox('Zadany nazov sa uz nachadza v databaze, skuste este raz', 'Upozornenie', BoxStyle);
                   end;
             end;
           if pomoc3 = true then
           Begin
           A[koniec].nazov:=UserString;
           for i:=0 to n-2 do
                     Begin
                          for j:=n-1 downto i+1 do
                              Begin
                                   if A[j-1].kod < A[j].kod then
                                      Begin
                                          triedenie:=A[j].kod;
                                          triedenie2:=A[j].nazov;
                                          A[j].kod:=A[j-1].kod;
                                          A[j].nazov:=A[j-1].nazov;
                                          A[j-1].kod:=triedenie;
                                          a[j-1].nazov:=triedenie2;
                                      end;
                              end;
                     end;
           Listbox2.items.clear();
           for i:=0 to koniec do
               Listbox2.items.add(A[i].kod+' '+A[i].nazov);
          end;
          end;
   end;

   pom:=false;
        while pom = false do
             Begin
               if (not fileexists('tovar_LOCK.txt')) and (not fileexists('cennik_LOCK.txt')) and (not fileexists('sklad_LOCK.txt')) then
                  Begin
                     pom:=true;

                     F:=FileCreate('tovar_LOCK.txt');
                     assignfile(subor8,'tovar.txt');
                     rewrite(subor8);
                     writeln(subor8,koniec+1);
                     pocetriadkovT:=koniec+1;
                     for i:=0 to koniec do
                         writeln(subor8,A[i].kod+';'+A[i].nazov);
                     closefile(subor8);
                     FileClose(F);
                     deletefile('tovar_LOCK.txt');

                     G:=FileCreate('cennik_LOCK.txt');
                     strList.LoadFromFile('cennik.txt');
                     strList.Add(A[koniec].kod+';');
                     strList[0]:=
                     FileClose(G);
                     deletefile('cennik_LOCK.txt');

                     H:=FileCreate('sklad_LOCK.txt');
                     assignfile(subor2,'sklad.txt');
                     append(subor2);
                     writeln(subor2,A[koniec].kod+';0');
                     closefile(subor2);
                     FileClose(H);
                     deletefile('sklad_LOCK.txt');
                  end;
             end;
end;

procedure TForm1.Button2Click(Sender: TObject);  //odstranit
var odpoved,BoxStyle:Integer;
    pom,pomoc:boolean;
    F:longint;
    subor8:textfile;
begin
  pomoc:=true;
  if Listbox2.itemindex < 0 then
     Begin
       BoxStyle:= MB_ICONQUESTION + MB_OK;
       odpoved:= Application.MessageBox('Prosim zadajte co chcete odstranit', 'Upozornenie', BoxStyle);
       pomoc:=false;
     end;
  if pomoc = true then
     Begin
  BoxStyle:= MB_ICONQUESTION + MB_YESNO;
  odpoved:= Application.MessageBox('Naozaj chcete odstranit tovar', 'Upozornenie', BoxStyle);
  if odpoved = IDYES then
         Begin
           j:=Listbox2.itemindex;
           for i:=j to koniec-1 do
               Begin
                 A[i].kod:=A[i+1].kod;
                 A[i].nazov:=A[i+1].nazov;
               end;
           //koniec:=koniec-1;
           Listbox2.items.delete(j);
         end;
      end;

  pom:=false;
        while pom = false do
             Begin
               if not fileexists('tovar_LOCK.txt') then
                  Begin
                     pom:=true;
                     F:=FileCreate('tovar_LOCK.txt');
                     assignfile(subor8,'tovar.txt');
                     rewrite(subor8);
                     writeln(subor8,koniec);
                     pocetriadkovT:=koniec;
                     for i:=0 to koniec-1 do
                         writeln(subor8,A[i].kod+';'+A[i].nazov);
                     closefile(subor8);
                     FileClose(F);
                     deletefile('tovar_LOCK.txt');
                  end;
             end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  QueryResult: Boolean;
  UserString,nazov,nazov1,kod: string;
  poz,BoxStyle,odpoved:integer;
  pom,pomoc,pomoc1:boolean;
  F:longint;
  subor8:textfile;
begin
  pomoc:=true;
  pomoc1:=true;
  if Listbox2.itemindex < 0 then
     Begin
       BoxStyle:= MB_ICONQUESTION + MB_OK;
       odpoved:= Application.MessageBox('Prosim zadajte co chcete editovat', 'Upozornenie', BoxStyle);
       pomoc:=false;
     end;
  if pomoc = true then
     Begin
          j:=Listbox2.itemindex;
          nazov1:=listbox2.items[j];
          poz:=POS(' ',nazov1);
          A[j].kod:=COPY(nazov1,1,poz-1);
          if InputQuery('Ziadost o zmenu nazvu tovaru', 'Prosim zadajte nazov tovaru', UserString) then
             Begin
                  for i:=0 to koniec-1 do
                            Begin
                                 if userstring = (A[i].nazov)  then
                                    Begin
                                    pomoc1:=false;
                                    BoxStyle:= MB_ICONQUESTION + MB_OK;
                                    odpoved:= Application.MessageBox('Zadany nazov sa uz nachadza v databaze, skuste este raz', 'Upozornenie', BoxStyle);
                                    dec(koniec);
                                    End;
                            end;
                  if pomoc1 = true then
                     Begin
                  A[j].nazov:=UserString;
                  Listbox2.items[j]:=(A[j].kod+' '+A[j].nazov);
                     end;
             end;
      end;

  if (pomoc = true) and (pomoc1 = true) then
     Begin
  pom:=false;
        while pom = false do
             Begin
               if not fileexists('tovar_LOCK.txt') then
                  Begin
                     pom:=true;
                     F:=FileCreate('tovar_LOCK.txt');
                     assignfile(subor8,'tovar.txt');
                     rewrite(subor8);
                     writeln(subor8,koniec+1);
                     pocetriadkovT:=koniec+1;
                     for i:=0 to koniec do
                         writeln(subor8,A[i].kod+';'+A[i].nazov);
                     closefile(subor8);
                     FileClose(F);
                     deletefile('tovar_LOCK.txt');
                  end;
             end;
      end;

end;
end.

