unit NvOS8RadioButton;

{ Envy Technologies

  Apple Macintosh OS 8 Platium Controls for Delphi 32

  TNvOS8RadioButton - RadioButton Control v0.2

  Amendment Log
  =============
  16/Feb/1998  DamienG    New: New component
  19/Jul/1998  DamienG    Fix: Sorted out painting & redraw problems
                          New: Actually coded painting routine
                          (First release with v0.3 package)
  24/Jul/1998  DamienG    Removed inherited Changed call for Delphi 2 compatibility
                          Currently selected radiobutton should stay down
                          Removed csReflector for Delphi 2 compatibility
                          (was only for me testing as ActiveX component anyway)
  26/Jul/1998  DamienG    Fixed memory leak (not freeing Canvas)
                          Optimized drawing routine a bit

  Notes
  =====
  1. Should I just use bitmaps and forego the colour-shading facility for speed?
  2. Vertical center control to go with text?
  3. Double-buffer control to reduce flicker?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NvOS8ColorServer;

type
  TNvOS8RadioButton = class(TButtonControl)
  private
    FCanvas: TCanvas;
    FChecked: Boolean;
    FColorServer: TNvOS8ColorServer;
    Shade: TShade;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure SetColorServer(Value: TNvOS8ColorServer);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure SetChecked(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Color;
    property ColorServer: TNvOS8ColorServer read FColorServer write SetColorServer;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

constructor TNvOS8RadioButton.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TCanvas.Create;
  Width := 140;
  Height := 16;
  TabStop := True;
  ControlStyle := [csSetCaption, csDoubleClicks, csOpaque];
end;

destructor TNvOS8RadioButton.Destroy;
begin
  inherited;
  FCanvas.Free;
end;

procedure TNvOS8RadioButton.SetChecked(Value: Boolean);

  procedure TurnSiblingsOff;
  var
    I: Integer;
    Sibling: TControl;
  begin
    if (Parent <> nil) then
      with Parent do
        for I := 0 to (ControlCount - 1) do
          begin
            Sibling := Controls[I];
            if (Sibling <> Self) and (Sibling is TNvOS8RadioButton) then
               TNvOS8RadioButton(Sibling).SetChecked(False);
          end;
  end;

begin
  if (FChecked <> Value) then
     begin
       FChecked := Value;
       TabStop := Value;
       if HandleAllocated then
          SendMessage(Handle, BM_SETCHECK, Integer(Checked), 0);
       if Value then
          begin
            TurnSiblingsOff;
            Click;
          end;
       Repaint;
     end;
end;

procedure TNvOS8RadioButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'BUTTON');
  with Params do
    begin
      Style := Style or BS_OWNERDRAW;
      WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    end;
end;

procedure TNvOS8RadioButton.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, BM_SETCHECK, Integer(FChecked), 0);
end;

procedure TNvOS8RadioButton.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
end;

procedure TNvOS8RadioButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(Message.CharCode, Caption) and CanFocus then
       begin
        SetFocus;
        Result := 1;
       end
    else
       inherited;
end;

procedure TNvOS8RadioButton.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    BN_CLICKED: SetChecked(True);
    BN_DOUBLECLICKED: DblClick;
  end;
end;

procedure TNvOS8RadioButton.SetColorServer(Value: TNvOS8ColorServer);
begin
  if (Value <> FColorServer) then
     begin
       FColorServer := Value;
       Shade := FColorServer.BaseShade;
       Repaint;
     end;
end;

procedure TNvOS8RadioButton.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TNvOS8RadioButton.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown: Boolean;
  Rec: TRect;
  FilCol, BorCol, CapCol: TColor;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  Rec := ClientRect;

  { Decode the state of the button }
  with DrawItemStruct do
      IsDown := itemState and ODS_SELECTED <> 0;

  { Setup the colors }
  if Enabled then
     begin
       BorCol := Shade.C[0];
       if IsDown or Checked then
          begin
            FilCol := Shade.C[7];
            CapCol := Font.Color;
          end
        else
          begin
            FilCol := Shade.C[13];
            CapCol := Font.Color;
          end
     end
   else
     begin
       BorCol := Shade.C[8];
       CapCol := Shade.C[8];
       FilCol := Shade.C[13];
     end;

  with FCanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(Rect(Rec.Left+4, Rec.Top, Rec.Left+19, Rec.Bottom));
      Brush.Color := FilCol;
      Pen.Style := psSolid;
      Pen.Color := BorCol;
      Ellipse(Rec.Left+1, Rec.Top+1, Rec.Left+13, Rec.Top+13);
      Pixels[Rec.Left+5, Rec.Top+1] := BorCol;
      Pixels[Rec.Left+8, Rec.Top+1] := BorCol;
      Pixels[Rec.Left+5, Rec.Top+2] := FilCol;
      Pixels[Rec.Left+8, Rec.Top+2] := FilCol;
      Pixels[Rec.Left+5, Rec.Top+12] := BorCol;
      Pixels[Rec.Left+8, Rec.Top+12] := BorCol;
      Pixels[Rec.Left+5, Rec.Top+11] := FilCol;
      Pixels[Rec.Left+8, Rec.Top+11] := FilCol;
      Pixels[Rec.Left+1, Rec.Top+5] := BorCol;
      Pixels[Rec.Left+1, Rec.Top+8] := BorCol;
      Pixels[Rec.Left+2, Rec.Top+5] := FilCol;
      Pixels[Rec.Left+2, Rec.Top+8] := FilCol;
      Pixels[Rec.Left+12, Rec.Top+5] := BorCol;
      Pixels[Rec.Left+12, Rec.Top+8] := BorCol;
      Pixels[Rec.Left+11, Rec.Top+5] := FilCol;
      Pixels[Rec.Left+11, Rec.Top+8] := FilCol;

      { Draw shadey background }
      if Enabled then
         if IsDown or Checked then
            begin
              Pen.Color := Shade.C[4];
              MoveTo(Rec.Left+2, Rec.Top+8);
              LineTo(Rec.Left+2, Rec.Top+5);
              LineTo(Rec.Left+5, Rec.Top+2);
              LineTo(Rec.Left+9, Rec.Top+2);
              Pixels[3,3] := Shade.C[4];
              Pen.Color := Shade.C[5];
              MoveTo(Rec.Left+3, Rec.Top+5);
              LineTo(Rec.Left+6, Rec.Top+2);
              MoveTo(Rec.Left+3, Rec.Top+6);
              LineTo(Rec.Left+7, Rec.Top+2);
              Pen.Color := Shade.C[6];
              MoveTo(Rec.Left+3, Rec.Top+9);
              LineTo(Rec.Left+3, Rec.Top+7);
              LineTo(Rec.Left+7, Rec.Top+3);
              LineTo(Rec.Left+10, Rec.Top+3);
              MoveTo(Rec.Left+4, Rec.Top+7);
              LineTo(Rec.Left+8, Rec.Top+3);
              Pen.Color := Shade.C[8];
              MoveTo(Rec.Left+5, Rec.Top+10);
              LineTo(Rec.Left+11, Rec.Top+4);
              MoveTo(Rec.Left+6, Rec.Top+10);
              LineTo(Rec.Left+11, Rec.Top+5);
              Pen.Color := Shade.C[9];
              MoveTo(Rec.Left+5, Rec.Top+11);
              LineTo(Rec.Left+6, Rec.Top+11);
              LineTo(Rec.Left+11, Rec.Top+6);
              LineTo(Rec.Left+11, Rec.Top+4);
              MoveTo(Rec.Left+7, Rec.Top+11);
              LineTo(Rec.Left+12, Rec.Top+6);
              Pen.Color := Shade.C[10];
              MoveTo(Rec.Left+8, Rec.Top+11);
              LineTo(Rec.Left+12, Rec.Top+7);
              Pixels[10,10] := Shade.C[10];
            end
         else
            begin
              Pixels[Rec.Left+8, Rec.Top+2] := Shade.C[11];
              Pixels[Rec.Left+3, Rec.Top+3] := Shade.C[11];
              Pixels[Rec.Left+2, Rec.Top+8] := Shade.C[11];
              Pixels[Rec.Left+3, Rec.Top+5] := Shade.C[14];
              Pixels[Rec.Left+4, Rec.Top+4] := Shade.C[14];
              Pixels[Rec.Left+5, Rec.Top+3] := Shade.C[14];
              Pen.Color := Shade.C[15];
              MoveTo(Rec.Left+3, Rec.Top+6);
              LineTo(Rec.Left+6, Rec.Top+3);
              LineTo(Rec.Left+9, Rec.Top+3);
              MoveTo(Rec.Left+6, Rec.Top+4);
              LineTo(Rec.Left+3, Rec.Top+7);
              LineTo(Rec.Left+3, Rec.Top+9);
              Pen.Color := Shade.C[14];
              MoveTo(Rec.Left+4, Rec.Top+7);
              LineTo(Rec.Left+8, Rec.Top+3);
              MoveTo(Rec.Left+4, Rec.Top+8);
              LineTo(Rec.Left+9, Rec.Top+3);
              Pixels[4,10] := Shade.C[11];
              Pixels[3,10] := Shade.C[8];
              Pixels[10,3] := Shade.C[8];
              Pen.Color := Shade.C[11];
              MoveTo(Rec.Left+5, Rec.Top+10);
              LineTo(Rec.Left+10, Rec.Top+5);
              LineTo(Rec.Left+10, Rec.Top+3);
              MoveTo(Rec.Left+6, Rec.Top+10);
              LineTo(Rec.Left+11,Rec.Top+5);
              Pen.Color := Shade.C[10];
              MoveTo(Rec.Left+7, Rec.Top+10);
              LineTo(Rec.Left+11, Rec.Top+6);
              Pixels[8,10] := Shade.C[10];
              Pixels[9,9] := Shade.C[10];
              Pixels[10,8] := Shade.C[10];
              Pen.Color := Shade.C[8];
              MoveTo(Rec.Left+5, Rec.Top+11);
              LineTo(Rec.Left+8, Rec.Top+11);
              LineTo(Rec.Left+11, Rec.Top+8);
              LineTo(Rec.Left+11, Rec.Top+4);
              Pixels[9,10] := Shade.C[8];
              Pixels[10,10] := Shade.C[8];
              Pixels[10,9] := Shade.C[8];
            end;

    { Actual draw of status }
    Pen.Color := BorCol;
    if FChecked then
       begin
         Brush.Color := BorCol;
         RoundRect(Rec.Left+4, Rec.Top+4, Rec.Left+10, Rec.Top+10, 2, 2);
       end;

    { Caption }
    Font := Self.Font;
    Font.Color := CapCol;
    Brush.Color := Self.Color;
    Brush.Style := bsSolid;
    Rec.Left := Rec.Left + 19;
    FillRect(Rec);
    DrawText(Handle, PChar(Caption), Length(Caption), Rec, DT_VCENTER or DT_SINGLELINE);
  end;

  FCanvas.Handle := 0;
end;

procedure TNvOS8RadioButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TNvOS8RadioButton.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

end.
