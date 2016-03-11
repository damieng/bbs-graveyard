unit NvNxsPushButton;

{ Envy Technologies

  NextStep/OpenStep Controls for Delphi 32

  TNvNxsPushButton - Push Button control v0.2

  Amendment Log
  =============
  23/Jul/1998  DamienG    New control

  Notes
  =====
  1. Check the down/pushed state with NextStep
  2. Add the Return-symbol for Default buttons? (Was removed in NS 4.2)
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, NvNxsRoutines;

type
  TNvNxsPushButton = class(TButton)
  private
    FCanvas: TCanvas;
    FUseSystemColors: Boolean;
    IsFocused: Boolean;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure CreateHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;
    procedure SetUseSystemColors(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Cancel;
    property Caption;
    property Enabled;
    property Font;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseSystemColors: Boolean read FUseSystemColors write SetUseSystemColors;
    property Visible;
    property OnEnter;
    property OnExit;
  end;

implementation

constructor TNvNxsPushButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FUseSystemColors := False;
  ControlStyle := ControlStyle + [csReflector] - [csDoubleClicks];
  Width := 58+6;
  Height := 20+6;
end;

destructor TNvNxsPushButton.Destroy;
begin
  inherited Destroy;
  FCanvas.Free;
end;

procedure TNvNxsPushButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

procedure TNvNxsPushButton.CreateHandle;
var
  State: TButtonState;
begin
  if Enabled then
    State := bsUp
  else
    State := bsDisabled;
  inherited CreateHandle;
end;

procedure TNvNxsPushButton.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TNvNxsPushButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNvNxsPushButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNvNxsPushButton.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown, IsDefault: Boolean;
  State: TButtonState;
  Rec: TRect;
  Flags: LongInt;
  High, Shad1, Shad2, Face: TColor;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  Rec := ClientRect;

  { Decode the state of the button }
  with DrawItemStruct do
    begin
      IsDown := itemState and ODS_SELECTED <> 0;
      IsDefault := itemState and ODS_FOCUS <> 0;
      if not Enabled then State := bsDisabled
       else
        if IsDown then
           State := bsDown
         else
           State := bsUp;
    end;
  Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
  if IsDown then Flags := Flags or DFCS_PUSHED;
  if DrawItemStruct.itemState and ODS_DISABLED <> 0 then
     Flags := Flags or DFCS_INACTIVE;

  FCanvas.Font := Font;

  { Setup the colors }
  if FUseSystemColors then
     begin
       High := clBtnHighlight;
       Shad1 := clBtnShadow;
       Shad2 := cl3DDkShadow;
       Face := clBtnFace;
     end
   else
     begin
       High := clWhite;
       Shad1 := $00818181;
       Shad2 := clBlack;
       Face := $00C9C9C9;
     end;

  with FCanvas do
    begin
      dec(Rec.Bottom);
      dec(Rec.Right);
      DrawNextFrame(FCanvas, Rec, not IsDown, High, Shad1, Shad2, Face);
      InflateRect(Rec, -3, -3);
      Font.Color := Self.Font.Color;
      DrawText(Handle, PChar(Caption), Length(Caption), Rec,
                    DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;

  FCanvas.Handle := 0;
end;

{ Essential routine to allow ownerdraw TButton }
procedure TNvNxsPushButton.SetButtonStyle(ADefault: Boolean);
begin
  if (ADefault <> IsFocused) then
     begin
       IsFocused := ADefault;
       Invalidate;
     end;
end;

procedure TNvNxsPushButton.SetUseSystemColors(Value: Boolean);
begin
  if (FUseSystemColors <> Value) then
     begin
       FUseSystemColors := Value;
       Repaint;
     end;
end;

end.
