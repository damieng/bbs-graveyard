program keymaker;

uses
  Forms,
  keygen in 'keygen.pas' {frmMain},
  Crc32c in '..\CRC32c.PAS',
  VtraCfg in '..\vtracfg.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
