unit CoolMenuBtn;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolMenuBtn v0.8 - SpeedButton capable of showing a menu

  Change Log
  ----------
  03-Mar-1997   DPG   Created from existing EnvyDCP.
  17-Mar-1997   DPG   New MenuPosition property for below/right.
  01-Apr-1997   DPG   Final code tidy.
  11-Apr-1997   DPG   Fix problem with PopupMenu deleted in design mode.
  21-May-1997   DPG   New Delphi 2/Delphi 2 compatible version.

  Future Ideas
  ------------
  Sort out lack of default caption
  Descend from TButton instead
*******************************************************************************}

interface

uses Buttons, Classes, Menus;

type
  TCoolMenuPos = (mpBelow, mpRight);
  TCoolMenuBtn = class(TSpeedButton)
  private
    FPopupMenu: TPopupMenu;
    FMenuPosition: TCoolMenuPos;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property MenuPosition: TCoolMenuPos read FMenuPosition write FMenuPosition;
  end;

implementation

{ TCoolMenuBtn component }
constructor TCoolMenuBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GroupIndex := 1;
  AllowAllUp := True;
  Width := 74;
  Height := 22;
end;

{ Override click handler to display menu }
procedure TCoolMenuBtn.Click;
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
procedure TCoolMenuBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FPopupMenu) and (Operation = opRemove) then FPopupMenu := nil;
end;

end.
