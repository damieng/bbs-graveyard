program rausr2db;

uses
  Forms,
  main in 'main.pas' {frmMain},
  SQL in 'C:\ODBC\SQL.PAS',
  SQLext in 'C:\ODBC\SQLEXT.PAS',
  RA250 in '\PROJECTS\VT-RA\RA250.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'RAUsr2DB';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
