unit CoolColorPick;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolColorPickBtn v0.9 - Color pick button as found in IE3

  Change Log
  ----------
  05-May-1997   DPG   Created from Delphi 2.0 version.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
*******************************************************************************}

interface

uses Buttons, Classes, Dialogs, Controls, Graphics, Messages, StdCtrls, Windows;

type
  TCoolColorPickBtn = class(TButton)
  private
    FCanvas: TCanvas;
    FSelectedColor: TColor;
    IsFocused: Boolean;
    procedure SetSelectedColor(Value: TColor);
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure CreateHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Enabled;
    property ParentShowHint;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clBlack;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnEnter;
    property OnExit;
  end;

procedure DrawSmartFrame(Canvas: TCanvas; R: TRect; IsDown: Boolean; IsFocused: Boolean);

implementation

{ Create the component }
constructor TCoolColorPickBtn.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FSelectedColor := clBlack;
  Caption := '';
end;

{ Release canvas and destroy component }
destructor TCoolColorPickBtn.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

{ Create a handle }
procedure TCoolColorPickBtn.CreateHandle;
var
  State: TButtonState;
begin
  if Enabled then
    State := bsUp
  else
    State := bsDisabled;
  inherited CreateHandle;
end;

{ Set owner-draw button style }
procedure TCoolColorPickBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

{ Draw the button item }
procedure TCoolColorPickBtn.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown, IsDefault: Boolean;
  State: TButtonState;
  R: TRect;
  Flags: Longint;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  R := ClientRect;

  with DrawItemStruct do
  begin
    IsDown := itemState and ODS_SELECTED <> 0;
    IsDefault := itemState and ODS_FOCUS <> 0;
    if not Enabled then State := bsDisabled
    else if IsDown then State := bsDown
    else State := bsUp;
  end;

  Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
  if IsDown then Flags := Flags or DFCS_PUSHED;
  if DrawItemStruct.itemState and ODS_DISABLED <> 0 then
    Flags := Flags or DFCS_INACTIVE;

  DrawSmartFrame(FCanvas,ClientRect,IsDown,IsFocused);

  if Enabled then
     begin
       R := ClientRect;
       if IsDown then OffsetRect(R, 1, 1);
       InflateRect(R,-4,-4);
       FCanvas.Pen.Color := clBlack;
       FCanvas.Pen.Style := psSolid;
       Fcanvas.Brush.Color := FSelectedColor;
       FCanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
       if IsFocused then
          begin
            InflateRect(R,1,1);
            FCanvas.Pen.Color := clWindowFrame;
            FCanvas.Brush.Color := clBtnFace;
            DrawFocusRect(FCanvas.Handle, R);
          end;
     end;

  FCanvas.Handle := 0;
end;

{ Component recieved VCL message to draw }
procedure TCoolColorPickBtn.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

{ Set the selected button color }
procedure TCoolColorPickBtn.SetSelectedColor(Value: TColor);
begin
  if (Value <> FSelectedColor) then
     begin
       FSelectedColor := Value;
       Invalidate;
     end;
end;

{ Essential routine to allow ownerdraw TButton }
procedure TCoolColorPickBtn.SetButtonStyle(ADefault: Boolean);
begin
  if (ADefault <> IsFocused) then
     begin
       IsFocused := ADefault;
       Invalidate;
     end;
end;

{ Enabled status changed }
procedure TCoolColorPickBtn.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

{ Click event dialog-popup handler }
procedure TCoolColorPickBtn.Click;
var
  ColorDialog: TColorDialog;
begin
  ColorDialog := TColorDialog.Create(Self);
  try
    if (ColorDialog.Execute) then
       begin
         FSelectedColor := ColorDialog.Color;
         Invalidate;
       end;
  finally
    ColorDialog.Free;
  end;
end;

{ Custom routine for drawing a button frame (New style only) }
procedure DrawSmartFrame(Canvas: TCanvas; R: TRect; IsDown: Boolean; IsFocused: Boolean);
var
  High1, High2, Shad1, Shad2 : TColor;
begin
  with Canvas do
    begin
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      Pen.Style := psClear;
      Rectangle(R.Left,R.Top,R.Right,R.Bottom);
      dec(R.Bottom);
      dec(R.Right);
      Brush.Style := bsClear;
      Pen.Style := psSolid;
      if IsDown then
         begin
           High1 := clBtnShadow;
           High2 := cl3DDkShadow;
           Shad1 := cl3DLight;
           Shad2 := clBtnHighlight;
         end
       else
         begin
           High1 := clBtnHighlight;
           High2 := cl3DLight;
           Shad1 := clBtnShadow;
           Shad2 := cl3DDkShadow;
         end;
      Pen.Color := High1;
      MoveTo(R.Left,R.Bottom);
      LineTo(R.Left,R.Top);
      LineTo(R.Right,R.Top);
      Pen.Color := High2;
      MoveTo(R.Left+1,R.Bottom-1);
      LineTo(R.Left+1,R.Top+1);
      LineTo(R.Right-1,R.Top+1);
      Pen.Color := Shad1;
      MoveTo(R.Left+1,R.Bottom-1);
      LineTo(R.Right-1,R.Bottom-1);
      LineTo(R.Right-1,R.Top);
      Pen.Color := Shad2;
      MoveTo(R.Left,R.Bottom);
      LineTo(R.Right,R.Bottom);
      LineTo(R.Right,R.Top-1);
    end;
end;

end.
