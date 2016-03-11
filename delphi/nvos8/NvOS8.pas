unit NvOS8;

{ Envy Technologies

  Apple Macintosh OS 8 Platium Controls for Delphi 32

  Registration unit

  v0.3}

interface

uses Classes, NvOS8PushButton, NvOS8Checkbox, NvOS8Progress, NvOS8RadioButton, NvOS8ColorServer;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Envy OS8', [TNvOS8PushButton,
                                  TNvOS8Checkbox,
                                  TNvOS8Progress,
                                  TNvOS8RadioButton,
                                  TNvOS8ColorServer]);
end;

end.
