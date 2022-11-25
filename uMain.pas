﻿unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Themes,
  Vcl.Dialogs, Vcl.StdCtrls, System.StrUtils, System.RegularExpressions, uConst,
  Vcl.CheckLst, SynEdit, DosCommand, Vcl.WinXCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.ComCtrls, uFrameUpgrade2, uFrameBase, uFrameList, uFrameSearch, System.ImageList, Vcl.ImgList, utestcomponents, CustomButton1,
  System.Actions,
  Vcl.ActnList;

type
  TArg<T> = reference to procedure(const Arg: T);

  TfMain = class(TForm)
    AI1: TActivityIndicator;
    DosCommand1: TDosCommand;
    pnlToolbar: TPanel;
    pnlFooter: TPanel;
    pnlMain: TPanel;
    btn1: TButton;
    lblWingetVersion: TLabel;
    pnlF1: TPanel;
    btnSearch: TButton;
    pnlf2: TPanel;
    btnList: TButton;
    pnlF3: TPanel;
    btnUpgrade: TButton;
    btnQuit: TButton;
    pnlEsc: TPanel;
    actlst1: TActionList;
    actSearch: TAction;
    actList: TAction;
    actUpgrade: TAction;
    actQuit: TAction;
    procedure DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure btnQuitClick(Sender: TObject);
    function DosCommand1CharDecoding(ASender: TObject; ABuf: TStream): string;
    procedure DosCommand1ExecuteError(ASender: TObject; AE: Exception; var AHandled: Boolean);
    procedure btnSearchClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ygBtnSearchClick(Sender: TObject);
    procedure ygBtnQuitClick(Sender: TObject);
    procedure ygBtnListClick(Sender: TObject);
    procedure ygBtnUpgradeClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure btnUpgradeClick(Sender: TObject);
    procedure actQuitExecute(Sender: TObject);
    procedure actUpgradeExecute(Sender: TObject);
    procedure actListExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
  private
    { Private declarations }
    function makeUpgList: tStrings;
    procedure GetVersion(var m: tMessage); message WM_GETWINGETVERSION;
    procedure StartSearch(var m: tMessage); message WM_STARTSEARCH;
    procedure StartList(var m: tMessage); message WM_STARTLIST;
    procedure taskSearch(Sender: TObject);
    procedure taskList(Sender: TObject);
    procedure taskUpgrade(Sender: TObject);
  public
    { Public declarations }
    lOutPut: tStrings;
    aFrame: TfrmBase;
    procedure upgradeTerminated(Sender: TObject);
    procedure versionTerminated(Sender: TObject);
    procedure listTerminated(Sender: TObject);
    procedure LVSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.actListExecute(Sender: TObject);
begin
  taskList(Sender);
end;

procedure TfMain.actQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfMain.actSearchExecute(Sender: TObject);
begin
  taskSearch(Sender);
end;

procedure TfMain.actUpgradeExecute(Sender: TObject);
begin
  taskUpgrade(Sender);
end;

procedure TfMain.btn1Click(Sender: TObject);
begin
  TStyleManager.TrySetStyle('Windows');
end;

procedure TfMain.btnListClick(Sender: TObject);
begin
  taskList(Sender);
end;

procedure TfMain.btnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfMain.btnSearchClick(Sender: TObject);
begin
  taskSearch(Sender);
end;

procedure TfMain.btnUpgradeClick(Sender: TObject);
begin
  taskUpgrade(Sender);
end;

function TfMain.DosCommand1CharDecoding(ASender: TObject; ABuf: TStream): string;
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
      result := tEncoding.UTF8.GetString(pBytes);
    except
      result := '';
    end;
  end
  else
    result := '';
end;

procedure TfMain.DosCommand1ExecuteError(ASender: TObject; AE: Exception; var AHandled: Boolean);
begin
  AHandled := True;
end;

procedure TfMain.DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  if ANewLine.IndexOf(Chr(08)) = -1 then
    lOutPut.Add(ANewLine);
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  aComponent: TComponent;
begin
  //
  if ssAlt in Shift then
    if Key = 80 then
    begin
      removekey;
      if (aFrame <> Nil) then
      begin
        if aFrame is TfrmSearch then
        begin
          TfrmSearch(aFrame).edtPackageName.SetFocus;
        end;
      end;
    end;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  lOutPut := tStringList.Create;
  PostMessage(handle, WM_GETWINGETVERSION, 0, 0);
end;

procedure TfMain.GetVersion(var m: tMessage);
begin
  DosCommand1.CommandLine := tWingetcommand.version;
  DosCommand1.OnTerminated := versionTerminated;
  DosCommand1.Execute;
end;

procedure TfMain.listTerminated(Sender: TObject);
var
  i, iCol: Integer;
  liste: TListItems;
  Item: TListItem;
  sLine: string;
  sString: string;
  aColumn: tColumnClass;
  lOutClean: tStrings;
  aWingetPackage: tWingetPackage;
begin
  i := 0;
  aFrame := TfrmList.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  TfrmList(aFrame).Init;
  lOutClean := makeUpgList;
  liste := TfrmList(aFrame).ListView1.Items;
  while i <= lOutClean.Count - 1 do
  begin
    sLine := lOutClean[i];
    aWingetPackage := tWingetPackage.Create(sLine, ptList);
    TfrmList(aFrame).addItem(aWingetPackage);
    TfrmList(aFrame).AddFilterCB(aWingetPackage.getField('source'));
    inc(i);
  end;
  TfrmList(aFrame).setupColumnHeaders;
  TfrmList(aFrame).ApplyFilter;
  TfrmList(aFrame).ListView1.OnSelectItem := LVSelectItem;
  AI1.Animate := False;
end;

procedure TfMain.LVSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  aWingetPackage: tWingetPackage;
begin
  if Selected then
    if (Item.Data <> Nil) then
    begin
      aWingetPackage := tWingetPackage(Item.Data);
    end;
end;

function TfMain.makeUpgList: tStrings;
var
  sHeaders: string;
  ANewLine: string;
  iLine: Integer;
  bClean: Boolean;
begin
  result := tStringList.Create;
  iLine := 0;
  bClean := False;
  while iLine <= lOutPut.Count - 1 do
  begin
    ANewLine := lOutPut[iLine];
    if TRegEx.IsMatch(ANewLine, '----') then
    begin
      bClean := True;
      sHeaders := lOutPut[iLine - 1];
      makeUpgradeDictonary(sHeaders);
    end
    else if bClean then
      result.Add(ANewLine);
    inc(iLine);
  end;
end;

procedure TfMain.StartList(var m: tMessage);
begin
  taskList(Nil);
end;

procedure TfMain.StartSearch(var m: tMessage);
begin
  btnSearchClick(Nil);
end;

procedure TfMain.taskList(Sender: TObject);
begin
  AI1.Animate := True;
  if aFrame <> Nil then
    aFrame.Free;

  lOutPut.clear;
  DosCommand1.OnTerminated := listTerminated;
  DosCommand1.CommandLine := tWingetcommand.List;
  DosCommand1.Execute;
end;

procedure TfMain.taskSearch(Sender: TObject);
begin
  if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmSearch.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  TfrmSearch(aFrame).Init;
end;

procedure TfMain.taskUpgrade(Sender: TObject);
begin
  AI1.Animate := True;
  if aFrame <> Nil then
    aFrame.Free;

  lOutPut.clear;

  aFrame := TfrmHeritee.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  TfrmHeritee(aFrame).ListView1.OnSelectItem := LVSelectItem;

  DosCommand1.OnTerminated := upgradeTerminated;
  DosCommand1.CommandLine := tWingetcommand.Upgrade;
  DosCommand1.Execute;
end;

procedure TfMain.upgradeTerminated(Sender: TObject);
var
  i, iCol: Integer;
  liste: TListItems;
  Item: TListItem;
  sLine: string;
  sString: string;
  aColumn: tColumnClass;
  lOutClean: tStrings;
  aWingetPackage: tWingetPackage;
begin
  i := 0;
  lOutClean := makeUpgList;
  TfrmHeritee(aFrame).setupColumnHeaders;
  liste := TfrmHeritee(aFrame).ListView1.Items;
  while i < lOutClean.Count - 1 do
  begin
    sLine := lOutClean[i];
    aWingetPackage := tWingetPackage.Create(sLine, ptUpgrade);
    Item := liste.Add;
    Item.Data := aWingetPackage;
    iCol := 0;
    while iCol <= length(aUpgFields) - 1 do
    begin
      if (iCol = 0) then
      begin
        Item.Caption := aWingetPackage.getField(aUpgFields[iCol]);
      end
      else
      begin
        Item.SubItems.Add(aWingetPackage.getField(aUpgFields[iCol]));
      end;
      inc(iCol);
    end;
    inc(i);
  end;
  AI1.Animate := False;
end;

procedure TfMain.versionTerminated(Sender: TObject);
begin
  lblWingetVersion.Caption := Format('Winget version %s', [lOutPut[0]]);
  PostMessage(handle, WM_STARTLIST, 0, 0);
end;

procedure TfMain.ygBtnListClick(Sender: TObject);
begin
  taskList(Sender);
end;

procedure TfMain.ygBtnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfMain.ygBtnSearchClick(Sender: TObject);
begin
  taskSearch(Sender);
end;

procedure TfMain.ygBtnUpgradeClick(Sender: TObject);
begin
  taskUpgrade(Sender);
end;

end.
