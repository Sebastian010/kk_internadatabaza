unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,LCLType;
const
  n=15;
type
  zoznam = record
    kod:string;
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
    //procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  subor2:textfile;
  i,j,porovnaj1,porovnaj2:integer;
  A:array[0..n-1]of zoznam;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);     //nacitanie
var pom,pom2,pom3:boolean;
    subor,subor6,subor8:textfile;
    slovo:string;
    poz,riadky:integer;
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
                            A[i].kod:=(Copy(slovo,1,poz-1));
                         end;
                     for i:=0 to riadky-1 do
                            Listbox1.items.add(A[i].kod);
                     closefile(subor);
                     FileClose(F);
                     deletefile('sklad_LOCK.txt');
                  end;
             end;

       {pom2:=false;
        while pom2 = false do
             Begin
               if not fileexists('skladVERZIA_LOCK.txt') then
                  Begin
                     pom2:=true;
                     F:=FileCreate('skladVERZIA_LOCK.txt');
                     assignfile(subor6,'sklad_VERZIA.txt');
                     reset(subor6);
                     read(subor6,porovnaj1);
                     closefile(subor6);
                     FileClose(F);
                     deletefile('skladVERZIA_LOCK.txt');
                  end;
             end;

        pom3:=false;
        while pom3 = false do
             Begin
               if not fileexists('tovarVERZIA_LOCK.txt') then
                  Begin
                     pom3:=true;
                     F:=FileCreate('tovarVERZIA_LOCK.txt');
                     assignfile(subor8,'tovar_VERZIA.txt');
                     reset(subor8);
                     read(subor8,porovnaj2);
                     closefile(subor8);
                     FileClose(F);
                     deletefile('tovarVERZIA_LOCK.txt');
                  end;
             end;}
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  QueryResult: Boolean;
  UserString,nazov,kod: string;
begin
  j:=Listbox1.itemindex;
  kod:=listbox1.items[j];
  if InputQuery('Oznam', 'Prosim zadajte nazov kodu', UserString) then
      Begin
        ShowMessage(UserString);
        nazov:=UserString;
        Listbox2.items.add(kod+' '+nazov);
      end;
end;

{procedure TForm1.Timer1Timer(Sender: TObject);
var pom2,pom3:boolean;
    porovnaj1,porovnaj2,porovnaj3,porovnaj4:integer;
    subor5,subor6,subor7,subor8:textfile;
begin
  pom2:=false;
        while pom2 = false do
             Begin
               if not fileexists('skladVERZIA_LOCK.txt') then
                  Begin
                     pom2:=true;
                     assignfile(subor5,'skladVERZIA_LOCK.txt');
                     rewrite(subor5);
                     assignfile(subor6,'sklad_VERZIA.txt');
                     reset(subor6);
                     read(subor6,porovnaj3);
                     closefile(subor6);
                     deletefile('skladVERZIA_LOCK.txt');
                  end;
             end;

        pom3:=false;
        while pom3 = false do
             Begin
               if not fileexists('tovarVERZIA_LOCK.txt') then
                  Begin
                     pom3:=true;
                     assignfile(subor7,'tovarVERZIA_LOCK.txt');
                     rewrite(subor7);
                     assignfile(subor8,'tovar_VERZIA.txt');
                     reset(subor8);
                     read(subor8,porovnaj4);

                     closefile(subor8);
                     deletefile('tovarVERZIA_LOCK.txt');
                  end;
             end;
end;}

procedure TForm1.Button1Click(Sender: TObject);  //pridat tovar
var pom,pom2:boolean;
    nazov,kod:string;
    subor4,subor2:textfile;
    QueryResult: Boolean;
    UserString: string;
begin
   if InputQuery('Oznam', 'Prosim zadajte kod tovaru', UserString)
  then
         Begin
           ShowMessage(UserString);
           kod:=UserString;
         end;
  if InputQuery('Oznam', 'Prosim zadajte nazov tovaru', UserString)
  then
         Begin
           ShowMessage(UserString);
           nazov:=UserString;
           Listbox2.items.add(kod+' '+nazov);
         end
    {pom:=false;
    while pom = false do
          Begin
             if not fileexists('tovar_LOCK.txt') then
                  Begin
                     pom:=true;
                     assignfile(subor4,'tovar_LOCK.txt');
                     rewrite(subor4);
                     assignfile(subor2,'tovar.txt');
                     Append(subor2);
                     writeln(kod+';'+nazov);
                     closefile(subor2);
                     deletefile('tovar_LOCK.txt');
                     {while pom = false do
                           Begin
                                if not fileexists('tovar_LOCK.txt') then
                                   Begin

                                   end;
                           end;}
                  end;
          end;}

    {pom:=false;
    while pom = false do
          Begin
             if not fileexists('tovar_LOCK.txt') then
                  Begin
                     pom:=true;
                     assignfile(subor4,'tovar_LOCK.txt');
                     rewrite(subor4);
                     assignfile(subor2,'tovar.txt');
                     Append(subor2);
                     writeln(kod+';'+nazov);
                     closefile(subor2);
                     deletefile('tovar_LOCK.txt');
                  end;
          end;}
end;

procedure TForm1.Button2Click(Sender: TObject);  //odstranit
var odpoved,BoxStyle:Integer;
begin
  BoxStyle:= MB_ICONQUESTION + MB_YESNO;
  odpoved:= Application.MessageBox('Naozaj chcete odstranit tovar', 'Upozornenie', BoxStyle);
  if odpoved = IDYES then
         Begin
           j:=Listbox2.itemindex;
           Listbox2.items.delete(j);
         end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  QueryResult: Boolean;
  UserString,nazov,nazov1,kod: string;
  poz:integer;
begin
  j:=Listbox2.itemindex;
  nazov1:=listbox2.items[j];
  poz:=POS(' ',nazov1);
  kod:=COPY(nazov1,1,poz-1);
  if InputQuery('Ziadost o zmenu nazvu kodu', 'Prosim zadajte nazov kodu', UserString) then
      Begin
        ShowMessage(UserString);
        nazov:=UserString;
        Listbox2.items.delete(j);
        Listbox2.items.add(kod+' '+nazov);
      end
end;

end.

