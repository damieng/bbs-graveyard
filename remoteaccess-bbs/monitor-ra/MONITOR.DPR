program Monitor;

uses
  Forms,
  Main in 'main.pas' {frmMain},
  RA250 in 'Ra250.pas',
  Config in 'config.pas' {frmConfig},
  VtraCfg in 'vtracfg.pas',
  SendNote in 'sendnote.pas' {frmSendNote},
  Routines in 'routines.pas',
  CRC32c in 'CRC32c.PAS',
  locale in 'locale.pas',
  userprp in 'USERPRP.PAS' {frmUser},
  custerr in 'custerr.pas' {frmCustomErr},
  NodeProp in 'nodeprop.pas' {frmProperties};

{$R *.RES}
{$R TRAYICON.RES}

begin
  Application.Initialize;
  Application.Title := 'Monitor/RA';
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
