unit RegisterNvDB;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     RegisterNvDB        "Register all DB aware components"
  Type:     Registration
  Contains: Code to register components in the Delphi IDE
  Version:  v1.5

  Changes:  05-Aug-1997   DPG   New registration unit for NvDBLabel.

  Licence:   MUST BE REGISTERED BEFORE DISTRIBUTING ANY SOFTWARE CONTAINING
             THESE COMPONENTS INCLUDING FREEWARE, SHAREWARE, COMMERCIAL AND
             IN-HOUSE DEVELOPMENTS.

             Component source provided on registration.

  Email:     envy@guernsey.net
  Web:       http://www.guernsey.net/~envy

  Copyright: Copyright © 1996, 1997 Envy Technologies.
  Warranty:  No warranty expressed or implied.  Use at your own risk.
*******************************************************************************}

interface

uses Classes;

procedure Register;

implementation

uses NvDBLabel;

{ Modify if you wish to use only selected components instead of whole package }
procedure Register;
begin
  RegisterComponents('Envy DB',
          [TNvDBLabel]);             { Database aware TNvLabel control }
end;

end.

