unit uRunWinget;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, system.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DosCommand, SynEdit, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, uconst, sMemo;

type
  TfRunWinget = class(TForm)
    dcRun: TDosCommand;
    pnltop: TPanel;
    AI1: TActivityIndicator;
    mmo1: TsMemo;
    function dcRunCharDecoding(ASender: TObject; ABuf: TStream): string;
    procedure dcRunNewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure dcRunTerminated(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { D�clarations priv�es }
    lIDs : TStrings;
    procedure runNext(var msg : tMessage); message WM_RUNNEXT;
  public
    { D�clarations publiques }
    typeRun : tPackagetype;
    Procedure addId(sID : String);
  end;

var
  fRunWinget: TfRunWinget;

implementation

{$R *.dfm}

procedure TfRunWinget.addId(sID: String);
begin
    //mmo1.Lines.Add(DosCommand);
   lIDs.add(Trim(sID));
end;

function TfRunWinget.dcRunCharDecoding(ASender: TObject; ABuf: TStream): string;
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

procedure TfRunWinget.dcRunNewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  if ANewLine.IndexOf(Chr(08)) = -1 then
  mmo1.Lines.Add(aNewLine);
end;

procedure TfRunWinget.dcRunTerminated(Sender: TObject);
begin
  if dcRun.ExitCode = 0 then
  begin
    mmo1.Lines.Add('r�ussi');
  end
  else
  begin
    mmo1.Lines.Add('rat�');
  end;
    PostMessage(Self.Handle, WM_RUNNEXT,0,0);
end;

procedure TfRunWinget.FormCreate(Sender: TObject);
begin
  lIDs := tStringList.Create;
end;

procedure TfRunWinget.FormShow(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_RUNNEXT,0,0);
end;

procedure TfRunWinget.runNext(var msg: tMessage);
begin
  if lIds.Count > 0 then
  begin
      case typeRun of
        ptInstall: begin
          dcRun.CommandLine := tWingetcommand.Install(lIDs[lIds.count -1]);
        end;
        ptUninstall : begin
          dcRun.CommandLine := tWingetcommand.unInstall(lIDs[lIds.count -1]);
        end;
      end;
      lIds.delete(lIds.count -1);
    dcRun.Execute;
  end;

end;

end.
