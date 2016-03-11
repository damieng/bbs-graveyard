unit CoolColorCombo;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolColorCombo v0.9 - Drop-down color list box

  Change Log
  ----------
  05-May-1997   DPG   Created from Delphi 2 version.
  05-May-1997   DPG   Removed properties MaxLength & Sorted.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
*******************************************************************************}

interface

uses Classes, Controls, Graphics, Messages, StdCtrls, Windows, SysUtils;

type
  TCoolColorCombo = class(TCustomComboBox)
  private
    FSelectedColor: TColor;
    FCanvas: TCanvas;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure ResetItemHeight;
    procedure SetSelectedColor(Value: TColor);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
  protected
    procedure Click; override;
    procedure CreateWnd; override;
    procedure BuildList; virtual;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clBlack;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
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

const SysColor: array [0..15] of TColor =
       (clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
        clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clWhite);

function GetItemHeight(Font: TFont): Integer;

implementation

{ Create component }
constructor TCoolColorCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csOwnerDrawFixed;
  ResetItemHeight;
  FSelectedColor := clBlack;
end;

{ Create Windows handle + setup }
procedure TCoolColorCombo.CreateWnd;
begin
  inherited CreateWnd;
  ItemHeight := 18;
  BuildList;
  SetSelectedColor(FSelectedColor);
end;

{ Override the default DrawItem handler }
procedure TCoolColorCombo.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
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
{    if odFocused in State then DrawFocusRect(hDC, rcItem);}
{ Uncomment above line for a focus rectangle }
    Canvas.Handle := 0;
  end;
end;

{ Build the list of available colors }
procedure TCoolColorCombo.BuildList;
begin
  Clear;
  Items.CommaText := 'Black, Maroon, Green, Olive, Navy, Purple, Teal, Gray, ' +
                     'Silver, Red, Lime, Yellow, Blue, Fuschia, Aqua, White';
end;

{ Draw individual items }
procedure TCoolColorCombo.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  BrushColor: TColor;
begin
  with Canvas do
    begin
      BrushColor := Brush.Color;
      FillRect(Rect);
      Brush.Color := SysColor[Index];
      Pen.Color := clBlack;
      Rectangle(Rect.Left+1, Rect.Top+1, Rect.Left+23, Rect.Top+13);
      Brush.Color := BrushColor;
      Pen.Style := psSolid;
    end;
  Rect.Left := Rect.Left + 26;
  DrawText(Canvas.Handle, PChar(Items[Index]), -1, Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

{ Reset the item height }
procedure TCoolColorCombo.ResetItemHeight;
var
  NewHeight: Integer;
begin
  NewHeight :=  GetItemHeight(Font);
  if (NewHeight < 14) then NewHeight := 14;
  ItemHeight := NewHeight;
end;

{ If the font changes, adjust to minimum height }
procedure TCoolColorCombo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResetItemHeight;
  RecreateWnd;
end;

{ Click event to return the selected color }
procedure TCoolColorCombo.Click;
begin
  inherited Click;
  if (ItemIndex >= 0) then FSelectedColor := SysColor[ItemIndex];
end;

{ Set the selected color }
procedure TCoolColorCombo.SetSelectedColor(Value: TColor);
var
  Index: Integer;
begin
  ItemIndex := 0;
  for Index := 0 to 15 do
     if (Value = SysColor[Index]) then ItemIndex := Index;
  FSelectedColor := SysColor[ItemIndex];
end;

{ Get minimum item height for this font }
function GetItemHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;

end.
