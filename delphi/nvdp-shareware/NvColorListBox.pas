unit NvColorListBox;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvColorListBox
  Type:     Component
  Contains: TNvColorListBox     "Drop-down color list box"
  Version:  v1.0

  Changes:  07-Aug-1997   DPG   Created from TNvColorCombo.

  Future:   Colors property and property editor to define colors
*******************************************************************************}

interface

uses Classes, Controls, Graphics, Messages, StdCtrls, Windows, SysUtils,
     NvRoutines;

type
  TNvColorListBox = class(TCustomListBox)
  private
    FCanvas: TCanvas;
    FFocusRectangle: Boolean;
    FSelectedColor: TColor;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure ResetItemHeight;
    procedure SetSelectedColor(Value: TColor);
  protected
    procedure BuildList; virtual;
    procedure Click; override;
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect;
              State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
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
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor
             default clBlack;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
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

implementation

{ Create object, assign defaults }
constructor TNvColorListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := lbOwnerDrawFixed;
  ResetItemHeight;
  FFocusRectangle := False;
  FSelectedColor := clBlack;
  Height := 102;
end;

{ Create Windows handle + setup }
procedure TNvColorListBox.CreateWnd;
begin
  inherited CreateWnd;
  BuildList;
  SetSelectedColor(FSelectedColor);
end;

{ Override the default DrawItem handler }
procedure TNvColorListBox.CNDrawItem(var Message: TWMDrawItem);
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

{ Build the list of available colors }
procedure TNvColorListBox.BuildList;
begin
  Clear;
  Items.CommaText := 'Black, Maroon, Green, Olive, Navy, Purple, Teal, Gray, ' +
                     'Silver, Red, Lime, Yellow, Blue, Fucshia, Aqua, White';
end;

{ Draw individual items }
procedure TNvColorListBox.DrawItem(Index: Integer; Rect: TRect;
          State: TOwnerDrawState);
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
  DrawText(Canvas.Handle, PChar(Items[Index]), -1, Rect,
           DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

{ Reset the item height }
procedure TNvColorListBox.ResetItemHeight;
var
  NewHeight: Integer;
begin
  NewHeight :=  GetItemHeight(Font);
  if (NewHeight < 14) then NewHeight := 14;
  ItemHeight := NewHeight;
end;

{ If the font changes, adjust to minimum height }
procedure TNvColorListBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResetItemHeight;
  RecreateWnd;
end;

{ Click event to return the selected color }
procedure TNvColorListBox.Click;
begin
  inherited Click;
  if (ItemIndex >= 0) then FSelectedColor := SysColor[ItemIndex];
end;

{ Set the selected color }
procedure TNvColorListBox.SetSelectedColor(Value: TColor);
var
  Index: Integer;
begin
  ItemIndex := 0;
  for Index := 0 to 15 do
     if (Value = SysColor[Index]) then ItemIndex := Index;
  FSelectedColor := SysColor[ItemIndex];
end;

end.
