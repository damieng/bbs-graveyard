program softcidd;

uses
  Forms,
  softmain in 'softmain.pas' {MainForm},
  about in 'about.pas' {FormAbout},
  options in 'options.pas' {OptionsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SoftCIDD';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
