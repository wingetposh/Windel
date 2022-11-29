program pWinDel;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uConst in 'uConst.pas',
  uOptions in 'uOptions.pas' {frmOptions},
  uFrameBase in 'uFrameBase.pas' {frmBase: TFrame},
  uFrameUpgrade in 'uFrameUpgrade.pas' {frameUpgrade: TFrame},
  uFrameUpgrade2 in 'uFrameUpgrade2.pas' {frmHeritee: TFrame},
  uFrameList in 'uFrameList.pas' {frmList: TFrame},
  uFrameSearch in 'uFrameSearch.pas' {frmSearch: TFrame},
  uRunWinget in 'uRunWinget.pas' {fRunWinget};

{$R *.res}

begin

  Application.Initialize;
  pPArams.loadParams;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
