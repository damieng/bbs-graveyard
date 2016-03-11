unit NvColorPick;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvColorPickBtn
  Type:     Component
  Contains: TNvColorPickBtn     "Color pick button"
                                Inspired by Internet Explorer 3 properties.
  Version:  v1.0

  Changes:  05-May-1997   DPG   Created from Delphi 2.0 version.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            22-Jul-1997   DPG   Moved DrawSmartFrame to CoolRoutines unit.
            05-Aug-1997   DPG   Renamed to TNvColorCombo, source tidy.

  Future:
*******************************************************************************}

interface

uses Buttons, Classes, Dialogs, Controls, Graphics, Messages, StdCtrls, Windows,
     NvRoutines;

type
  TNvColorPickBtn = class(TButton)
  private
    FCanvas: TCanvas;
    FSelectedColor: TColor;
    IsFocused: Boolean;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure SetSelectedColor(Value: TColor);
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
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor
             default clBlack;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnEnter;
    property OnExit;
  end;

implementation

{ Create the object, assign defaults, create canvas }
constructor TNvColorPickBtn.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FSelectedColor := clBlack;
  Caption := '';
end;

{ Release canvas and destroy object }
destructor TNvColorPickBtn.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

{ Create a handle }
procedure TNvColorPickBtn.CreateHandle;
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
procedure TNvColorPickBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

{ Draw the button item }
procedure TNvColorPickBtn.DrawItem(const DrawItemStruct: TDrawItemStruct);
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
      if not Enabled then
         State := bsDisabled
       else
         if IsDown then
            State := bsDown
          else
            State := bsUp;
    end;

  Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
  if IsDown then Flags := Flags or DFCS_PUSHED;
  if (DrawItemStruct.itemState and ODS_DISABLED <> 0) then
      Flags := Flags or DFCS_INACTIVE;

  DrawSmartFrame(FCanvas,ClientRect,IsDown,IsFocused);

  if Enabled then
     begin
       R := ClientRect;
       if IsDown then OffsetRect(R, 1, 1);
       InflateRect(R,-4,-4);
       FCanvas.Pen.Color := clBlack;
       FCanvas.Pen.Style := psSolid;
       FCanvas.Brush.Color := FSelectedColor;
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

{ Component received VCL message to draw }
procedure TNvColorPickBtn.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

{ Set the selected button color }
procedure TNvColorPickBtn.SetSelectedColor(Value: TColor);
begin
  if (Value <> FSelectedColor) then
     begin
       FSelectedColor := Value;
       Invalidate;
     end;
end;

{ Essential routine to allow ownerdraw TButton }
procedure TNvColorPickBtn.SetButtonStyle(ADefault: Boolean);
begin
  if (ADefault <> IsFocused) then
     begin
       IsFocused := ADefault;
       Invalidate;
     end;
end;

{ Enabled status changed }
procedure TNvColorPickBtn.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

{ Click event dialog-popup handler }
procedure TNvColorPickBtn.Click;
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

end.
