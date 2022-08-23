﻿unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.StrUtils, System.RegularExpressions, uConst, Vcl.CheckLst, SynEdit, DosCommand,
  Vcl.WinXCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
  TArg<T> = reference to procedure(const Arg: T);

  TForm1 = class(TForm)
    ActivityIndicator1: TActivityIndicator;
    DosCommand1: TDosCommand;
    pnlToolbar: TPanel;
    pnlFooter: TPanel;
    pnlMain: TPanel;
    btnQuit: TBitBtn;
    btnOptions: TBitBtn;
    btn1: TBitBtn;
    PageControl1: TPageControl;
    tsList: TTabSheet;
    tsSearch: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    procedure DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure DosCommand1Terminated(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    function DosCommand1CharDecoding(ASender: TObject; ABuf: TStream): string;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    lOutPut: tStrings;
    bClean: Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.btn1Click(Sender: TObject);
begin
  var i := 0;
  while i <= lListColumn.Count -1 do
  begin
    Memo1.Lines.Add(tColumnClass(lListColumn.Objects[i]).sLabel);
    inc(i);
  end;

end;

procedure TForm1.btnOptionsClick(Sender: TObject);
begin
  bClean := False;
  lOutPut := tStringList.Create;
  Memo1.Clear;
  ActivityIndicator1.Animate := True;
  DosCommand1.CommandLine := 'winget list';
  DosCommand1.Execute;
end;

procedure TForm1.btnQuitClick(Sender: TObject);
begin
  Close;
end;


function TForm1.DosCommand1CharDecoding(ASender: TObject;
  ABuf: TStream): string;
var
  pBytes: TBytes;
  iLength: Integer;
begin
  iLength := ABuf.Size;
  if iLength > 0 then
  begin
    SetLength(pBytes, iLength);
    ABuf.Read(pBytes, iLength);
    try
      result := tEncoding.UTF8.GetString(pBytes)
    except
      result := '';
    end;
  end
  else
    result := '';

end;

procedure TForm1.DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
var
  list: TStringDynArray;
  sHeaders: string;
begin

  lOutPut.Add(ANewLine);
  if TRegEx.IsMatch(ANewLine, '----') then
  begin
    bClean := True;
    sHeaders := lOutPut[lOutPut.Count - 2];
    makeUpgradeDictonary(sHeaders);
  end
  else
    if bClean then
      Memo1.Lines.Add(ANewLine);

end;

procedure TForm1.DosCommand1Terminated(Sender: TObject);
begin
  ActivityIndicator1.Animate := False;
end;

end.
