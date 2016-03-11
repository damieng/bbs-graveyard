unit NvFontCombo;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvFontCombo
  Type:     Component
  Contains: TNvFontCombo        "Drop-down combo box containing font names"
                                Inspired by Internet Explorer.
  Version:  v1.0

  Changes:  16-Mar-1997   DPG   New component.
            27-Mar-1997   DPG   Corrected SelectedFont property reading.
                                Removed Text property.
            01-Apr-1997   DPG   Final code tidy.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvFontCombo, source tidy.
            05-Aug-1997   DPG   New 'FocusRectangle' property.

  Future:   Remove TT for selected entry.
            Allow filtering of fixed/true-type/printer/screen fonts.
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NvRoutines;

type
  TNvFontCombo = class(TCustomComboBox)
  private
    FFocusRectangle: Boolean;
    FSelectedFont: TFontName;
    FShowTTLogo: Boolean;
    FTrueTypeBmp: TBitmap;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure ResetItemHeight;
    procedure SetSelectedFont(Value: TFontName);
    procedure SetShowTTLogo(Value: Boolean);
    property Sorted;
  protected
    procedure BuildList; virtual;
    procedure Click; override;
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect;
              State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Items;
    procedure Requery;
  published
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property FocusRectangle: Boolean read FFocusRectangle write FFocusRectangle
             default False;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedFont: TFontName read FSelectedFont write SetSelectedFont;
    property ShowHint;
    property ShowTTLogo: Boolean read FShowTTLogo write SetShowTTLogo
             default True;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
  end;

function FontCallback(var LOGFONT: TLogFont; var TextMetric: TTextMetric;
         FontType: Integer; Data: pointer) : Integer; stdcall;

implementation

{$R NvFontCombo.res }

{ Create object, assign defaults and load truetype logo }
constructor TNvFontCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csOwnerDrawFixed;
  Sorted := True;
  FFocusRectangle := False;
  FSelectedFont := '';
  FShowTTLogo := True;
  FTrueTypeBmp := TBitmap.Create;
  FTrueTypeBmp.Handle := LoadBitmap(HInstance, 'TRUETYPE');
  ResetItemHeight;
end;

{ Destroy object, free bitmap }
destructor TNvFontCombo.Destroy;
begin
  FTrueTypeBmp.Free;
  inherited Destroy;
end;

{ Build the list of available fonts }
procedure TNvFontCombo.BuildList;
var
  DC: HDC;
  Index: Integer;
begin
  Clear;
  DC := GetDC(0);
  EnumFonts(DC, nil, @FontCallback, Pointer(Items));
  ReleaseDC(0, DC);
end;

{ Create Windows handle + setup }
procedure TNvFontCombo.CreateWnd;
begin
  inherited CreateWnd;
  Requery;
end;

{ Draw individual items }
procedure TNvFontCombo.DrawItem(Index: Integer; Rect: TRect;
          State: TOwnerDrawState);
var
  Bitmap: TBitmap;
begin
  Canvas.FillRect(Rect);
  if (FShowTTLogo) then
     begin
       Bitmap := FTrueTypeBmp;
       with Canvas do
         if (Items.Objects[Index] = TObject(1)) then
            BrushCopy(Bounds(Rect.Left + 2,
                            (Rect.Top + Rect.Bottom - Bitmap.Height) div 2,
                            Bitmap.Width, Bitmap.Height), Bitmap,
                            Bounds(0, 0, Bitmap.Width, Bitmap.Height),
                            Bitmap.Canvas.Pixels[0, Bitmap.Height - 1]);
       Rect.Left := Rect.Left + 16;
     end;
  Rect.Left := Rect.Left + 2;
  DrawText(Canvas.Handle, PChar(Items[Index]), -1, Rect, DT_SINGLELINE or
           DT_VCENTER or DT_NOPREFIX);
end;

{ Reset the item height }
procedure TNvFontCombo.ResetItemHeight;
var
  NewHeight: Integer;
begin
  NewHeight :=  GetItemHeight(Font) + 1;
  if (NewHeight < FTrueTypeBmp.Height) then NewHeight := FTrueTypeBmp.Height;
  ItemHeight := NewHeight;
end;

{ If the font changes, adjust to minimum height }
procedure TNvFontCombo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResetItemHeight;
  RecreateWnd;
end;

{ Click event to return the selected color }
procedure TNvFontCombo.Click;
begin
  inherited Click;
  if (ItemIndex >= 0) then FSelectedFont := Items[ItemIndex];
end;

{ Set the selected color }
procedure TNvFontCombo.SetSelectedFont(Value: TFontName);
var
  Index: Integer;
begin
  ItemIndex := 0;
  for Index := 0 to Items.Count do
     if (Items[Index] = Value) then ItemIndex := Index;
  FSelectedFont := Items[ItemIndex];
end;

{ Set the TT logo visibility }
procedure TNvFontCombo.SetShowTTLogo(Value: Boolean);
begin
  if (Value <> FShowTTLogo) then
     begin
       FShowTTLogo := Value;
       Invalidate;
     end;
end;

{ Override the default DrawItem handler }
procedure TNvFontCombo.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
    begin
      //State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
      Canvas.Handle := hDC;
      Canvas.Font := Font;
      Canvas.Brush := Brush;
      if (Integer(itemID) >= 0) and (odSelected in State) then
         begin
           Canvas.Brush.Color := clHighlight;
           Canvas.Font.Color := clHighlightText
         end;
      if Integer(itemID) >= 0 then
         DrawItem(itemID, rcItem, State)
       else
        Canvas.FillRect(rcItem);
      if FocusRectangle then
         if (odFocused in State) then DrawFocusRect(hDC, rcItem);
    Canvas.Handle := 0;
  end;
end;

{ Reload the font list as required }
procedure TNvFontCombo.Requery;
begin
  BuildList;
  SetSelectedFont(FSelectedFont);
end;

{ Font callback function }
function FontCallback(var LOGFONT: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: pointer) : Integer; stdcall;
begin
  if (TextMetric.tmPitchAndFamily and TMPF_TRUETYPE = 0) then
     TStrings(Data).Add(LogFont.lfFaceName)
   else
     TStrings(Data).AddObject(LogFont.lfFaceName, TObject(1));
end;

end.
