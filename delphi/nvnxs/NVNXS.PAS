unit NvNxs;

{ Envy Technologies

  NextStep/OpenStep Controls for Delphi 32

  Registration unit

  v0.1}

interface

uses Classes, NvNxsPushButton, NvNxsCheckbox, NvNxsRadioButton;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Envy NextStep', [TNvNxsPushButton,
                                      TNvNxsCheckbox,
                                      TNvNxsRadioButton]);
end;

end.
