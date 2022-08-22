﻿unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.StrUtils, System.RegularExpressions, uConst, Vcl.CheckLst, SynEdit, DosCommand,
  Vcl.WinXCtrls;

type
  TArg<T> = reference to procedure(const Arg: T);

  TForm1 = class(TForm)
    Button1: TButton;
    DosCommand1: TDosCommand;
    Button2: TButton;
    ActivityIndicator1: TActivityIndicator;
    procedure Button1Click(Sender: TObject);
    procedure DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure Button2Click(Sender: TObject);
    procedure DosCommand1NewChar(ASender: TObject; ANewChar: Char);
    procedure DosCommand1Terminated(Sender: TObject);
  private
    { Private declarations }
    procedure CaptureConsoleOutput(const ACommand, AParameters: String; CallBack: TArg<PAnsiChar>);
  public
    { Public declarations }
    lOutPut : tStrings;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  sCmd: String;
  CallBack: TArg<PAnsiChar>;
  bClean : boolean;
begin

  CallBack := procedure(const Line: PAnsiChar)
  var
    s, ligne : String;
    list : TStringDynArray;
    i : Integer;
  begin
      s := String(Line);
      //SplitString(s,chr(13)+chr(10),list);
      i := 0;
      while i < length(list)-3 do
      begin
        if Trim(list[i])<>'' then
        begin
          ligne := list[i];
          if TRegEx.IsMatch(Ligne,'----') then begin
            bClean := True;
            makeUpgradeDictonary(list[i-2]);
          end
          else
          if bClean then
            lOutput.Add(list[i]);
        end;
        inc(i);
      end;
  end;
  bClean := False;
  sCmd := 'winget upgrade';
  CaptureConsoleOutput(sCmd, '', CallBack);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ActivityIndicator1.Animate := True;
  DosCommand1.Execute;
  //ActivityIndicator1.Animate := False;
end;

procedure TForm1.CaptureConsoleOutput(const ACommand, AParameters: String; CallBack: TArg<PAnsiChar>);
const
  CReadBuffer = 2400;
var
  saSecurity: TSecurityAttributes;
  hRead: THandle;
  hWrite: THandle;
  suiStartup: TStartupInfo;
  piProcess: TProcessInformation;
  pBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dRead: DWORD;
  dRunning: DWORD;
  dAvailable: DWORD;
begin
  saSecurity.nLength := SizeOf(TSecurityAttributes);
  saSecurity.bInheritHandle := True;
  saSecurity.lpSecurityDescriptor := nil;
  if CreatePipe(hRead, hWrite, @saSecurity, 0) then
    try
      FillChar(suiStartup, SizeOf(TStartupInfo), #0);
      suiStartup.cb := SizeOf(TStartupInfo);
      suiStartup.hStdInput := hRead;
      suiStartup.hStdOutput := hWrite;
      suiStartup.hStdError := hWrite;
      suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      suiStartup.wShowWindow := SW_HIDE;
      if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity, @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil,
        suiStartup, piProcess) then
        try
          repeat
            dRunning := WaitForSingleObject(piProcess.hProcess, 100);
            PeekNamedPipe(hRead, nil, 0, nil, @dAvailable, nil);
            if (dAvailable > 0) then
              repeat
                dRead := 0;
                ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
                pBuffer[dRead] := #0;
                OemToCharA(pBuffer, dBuffer);
                CallBack(dBuffer);
              until (dRead < CReadBuffer);
              Application.ProcessMessages;
          until (dRunning <> WAIT_TIMEOUT);
        finally
          CloseHandle(piProcess.hProcess);
          CloseHandle(piProcess.hThread);
        end;
    finally
      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;
end;

procedure TForm1.DosCommand1NewChar(ASender: TObject; ANewChar: Char);
begin
  Application.ProcessMessages;
end;

procedure TForm1.DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  //Memo1.Lines.Add(aNewLine);
end;

procedure TForm1.DosCommand1Terminated(Sender: TObject);
begin
  ActivityIndicator1.Animate := False;
end;

end.
