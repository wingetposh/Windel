program pWinDel;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  uConst in 'uConst.pas',
  uOptions in 'uOptions.pas' {frmOptions};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.Run;
end.
