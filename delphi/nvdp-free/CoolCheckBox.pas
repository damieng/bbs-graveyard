unit CoolCheckBox;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolCheckBox v0.9 - Checkbox with ReadOnly support

  Change Log
  ----------
  05-May-1997   DPG   Created from Delphi 2 version.
  05-May-1997   DPG   Added additional events.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
*******************************************************************************}

interface

uses Classes, StdCtrls;

type
  TCoolCheckBox = class(TCheckBox)
  private
    FReadOnly: Boolean;
    FOnClickIgnored: TNotifyEvent;
  protected
    procedure Toggle; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnClickIgnored: TNotifyEvent read FOnClickIgnored write FOnClickIgnored;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
  end;

implementation

{ TCoolCheckBox creation }
constructor TCoolCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReadOnly := False;
  FOnClickIgnored := nil;
end;

{ If Read Only proected do not allow user-click toggle }
procedure TCoolCheckBox.Toggle;
begin
  if (not FReadOnly) then inherited Toggle
     else if Assigned(FOnClickIgnored) then FOnClickIgnored(Self);
end;

end.
