unit NvMenuBtn;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvMenuBtn
  Type:     Component
  Contains: TNvMenuBtn         "SpeedButton capable of showing a popup menu"
  Version:  v1.0

  Changes:  03-Mar-1997   DPG   Created from existing EnvyDCP.
            17-Mar-1997   DPG   New MenuPosition property for below/right.
            01-Apr-1997   DPG   Final code tidy.
            11-Apr-1997   DPG   Fix problem with PopupMenu deleted in design mode.
            21-May-1997   DPG   New Delphi 2/Delphi 2 compatible version.
            04-Aug-1997   DPG   New 'Auto Glyph' property to show drop down image.
                                Added defaults to Menu Position property.
            05-Aug-1997   DPG   Renamed to TNvMenuBtn, source tidy.

  Future:   Sort out lack of default caption
            Descend from TButton instead
*******************************************************************************}

interface

uses Buttons, Classes, Forms, Menus;

type
  TNvMenuPosition = (mpBelow, mpRight);

  TNvMenuBtn = class(TSpeedButton)
  private
    FAutoGlyph: Boolean;
    FPopupMenu: TPopupMenu;
    FMenuPosition: TNvMenuPosition;
    procedure SetAutoGlyph(Value: Boolean);
    procedure SetMenuPosition(Value: TNvMenuPosition);
  protected
    procedure Notification(AComponent: TComponent;
              Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property AutoGlyph: Boolean read FAutoGlyph write SetAutoGlyph
             default False;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property MenuPosition: TNvMenuPosition read FMenuPosition
             write SetMenuPosition default mpBelow;
  end;

implementation

{$R NvMenuBtn.res }

{ Create object, assign defaults }
constructor TNvMenuBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GroupIndex := 1;
  AllowAllUp := True;
  FAutoGlyph := False;
  FMenuPosition := mpBelow;
  Width := 74;
  Height := 22;
end;

{ Set bitmap & defaults for standard arrow }
procedure TNvMenuBtn.SetAutoGlyph(Value: Boolean);
begin
  FAutoGlyph := Value;
  if FAutoGlyph then
     begin
       if (MenuPosition = mpBelow) then
          Glyph.LoadFromResourceName(HInstance, 'ARROWDOWN')
        else
          Glyph.LoadFromResourceName(HInstance, 'ARROWRIGHT');
       Layout := blGlyphRight;
       Margin := -1;
       Spacing := -1;
     end;
end;

{ If drop-down changes, change auto-arrow }
procedure TNvMenuBtn.SetMenuPosition(Value: TNvMenuPosition);
begin
  if (Value <> FMenuPosition) then
     begin
       FMenuPosition := Value;
       SetAutoGlyph(FAutoGlyph);
     end;
end;

{ Override click handler to display menu }
procedure TNvMenuBtn.Click;
begin
  inherited Click;
  if (Assigned(FPopupMenu)) then
     begin
       FPopupMenu.PopupComponent := Self;
       if (FMenuPosition = mpBelow) then
          FPopupMenu.Popup(Self.ClientOrigin.X, Self.ClientOrigin.Y+Self.Height)
        else
          FPopupMenu.Popup(Self.ClientOrigin.X+Self.Width, Self.ClientOrigin.Y);
       Self.Down := False;
     end;
end;

{ Inform us if the PopupMenu has been deleted }
procedure TNvMenuBtn.Notification(AComponent: TComponent;
          Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FPopupMenu) and (Operation = opRemove) then
     FPopupMenu := nil;
end;

end.
