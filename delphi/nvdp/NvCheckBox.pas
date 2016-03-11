unit NvCheckBox;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvCheckBox
  Type:     Component
  Contains: TNvCheckBox         "Checkbox with read-only support & event"
  Version:  v1.0

  Changes:  05-May-1997   DPG   Created from Delphi 2 version.
            05-May-1997   DPG   Added additional event.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvCheckBox, source tidy + comment.
            07-Aug-1997   DPG   Added WordWrap property.
                                Added Layout property.

  Future:
*******************************************************************************}

interface

uses Classes, StdCtrls, Windows, Controls;

type
  TNvCheckBox = class(TCheckBox)
  private
    FLayout: TTextLayout;
    FOnClickIgnored: TNotifyEvent;
    FReadOnly: Boolean;
    FWordWrap: Boolean;
    procedure SetLayout(Value: TTextLayout);
    procedure SetWordWrap(Value: Boolean);
  protected
    procedure Toggle; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Layout: TTextLayout read FLayout write SetLayout default tlCenter;
    property OnClickIgnored: TNotifyEvent read FOnClickIgnored
             write FOnClickIgnored;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
  end;

implementation

{ Create object, assign defaults }
constructor TNvCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLayout := tlCenter;
  FOnClickIgnored := nil;
  FReadOnly := False;
  FWordWrap := False;
end;

{ Add control parameters }
procedure TNvCheckBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  case FLayout of
    tlTop: Params.Style := Params.Style or BS_TOP;
    tlCenter: Params.Style := Params.Style or BS_VCENTER;
    tlBottom: Params.Style := Params.Style or BS_BOTTOM;
  end;
  if FWordWrap then
     Params.Style:= Params.Style or bs_MultiLine;
end;

{ Recreate control if layout changes }
procedure TNvCheckBox.SetLayout(Value: TTextLayout);
begin
  if (Value <> FLayout) then
     begin
       FLayout := Value;
       RecreateWnd;
     end;
end;

{ Recreate control if word wrap changes }
procedure TNvCheckBox.SetWordWrap(Value: Boolean);
begin
  if (Value <> FWordWrap) then
     begin
       FWordWrap := Value;
       RecreateWnd;
     end;
end;

{ If ReadOnly protected do not allow user-click toggle, raised event instead }
procedure TNvCheckBox.Toggle;
begin
  if (not FReadOnly) then
     inherited Toggle
   else
     if Assigned(FOnClickIgnored) then FOnClickIgnored(Self);
end;

end.
