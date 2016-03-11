unit NvOS8Checkbox;

{ Envy Technologies

  Apple Macintosh OS 8 Platium Controls for Delphi 32

  TNvOS8Checkbox - Checkbox Control v0.3

  Amendment Log
  =============
  17/Feb/1998  DamienG    Opt: Added double-buffering to stop flickering
                          Opt: Optimized painting
                          Fix: Count double-click as two-clicks
  16/Feb/1998  DamienG    Fix: Deleted Ctl3D properties as they are redundant
                          Cos: Reordered methods and properties alphabetically
  10/Feb/1998  DamienG    New: Colors shade-offsets from base of $00777777
                          New: Property base-color to allow colored buttons
  20/Jul/1998  DamienG    New: New csYeSNo style to go between X and Tick!
  24/Jul/1998  DamienG    Removed inherited change call to work with Delphi 2
                          Fixed stray pixel on 'X' marked checkboxes
  20/May/1999  DamienG    Changed to use colour server

  Notes
  =====
  1. I can not get this control to become transparent!
     Windows seems to be providing a colored canvas before I paint.
  2. Use bitmaps and forego colour-shades?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NvOS8ColorServer;

type
  TNvOS8CheckStyle = (csYes, csNo, csYesNo);
  TNvOS8Checkbox = class(TButtonControl)
  private
    FAllowGrayed: Boolean;
    FBuffer: TBitmap;
    FCanvas: TCanvas;
    FCheckStyle: TNvOS8CheckStyle;
    FColorServer: TNvOS8ColorServer;
    FState: TCheckBoxState;
    Shade: TShade;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    function GetChecked: Boolean;
    procedure SetChecked(Value: Boolean);
    procedure SetCheckStyle(Value: TNvOS8CheckStyle);
    procedure SetColorServer(Value: TNvOS8ColorServer);
    procedure SetState(Value: TCheckBoxState);
    procedure WMSize(var Message: TMessage); message WM_SIZE;
  protected
    procedure Click; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Toggle; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Caption;
    property Checked: Boolean read GetChecked write SetChecked stored False;
    property CheckStyle: TNvOS8CheckStyle read FCheckStyle write SetCheckStyle default csYes;
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
    property State: TCheckBoxState read FState write SetState default cbUnchecked;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
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

{ Create instance of this control }
constructor TNvOS8Checkbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FBuffer := TBitmap.Create;
  FBuffer.Width := Width;
  FBuffer.Height := Height;
  FState := cbUnchecked;
  ControlStyle := [csSetCaption, csOpaque];
  Width := 140;
  Height := 16;
  TabStop := True;
end;

{ Tidy up behind us }
destructor TNvOS8Checkbox.Destroy;
begin
  inherited Destroy;
  FBuffer.Free;
  FCanvas.Free;
end;

{ Routine to toggle between states }
procedure TNvOS8Checkbox.Toggle;
begin
  case State of
    cbUnchecked:
      if AllowGrayed then
         State := cbGrayed
      else
         State := cbChecked;
    cbChecked: State := cbUnchecked;
    cbGrayed: State := cbChecked;
  end;
  Repaint;
end;

{ Cause click to do changed too }
procedure TNvOS8Checkbox.Click;
begin
{  inherited Changed;}
  inherited Click;
end;

{ Return checked status }
function TNvOS8Checkbox.GetChecked: Boolean;
begin
  Result := State = cbChecked;
end;

{ Set checked status }
procedure TNvOS8Checkbox.SetChecked(Value: Boolean);
begin
  if Value then
     State := cbChecked
  else
     State := cbUnchecked;
  Repaint;
end;

{ Set state }
procedure TNvOS8Checkbox.SetState(Value: TCheckBoxState);
begin
  if (FState <> Value) then
     begin
       FState := Value;
       Repaint;
       if HandleAllocated then
          SendMessage(Handle, BM_SETCHECK, Integer(FState), 0);
       Click;
     end;
end;

{ Create owner-draw control }
procedure TNvOS8Checkbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'BUTTON');
  with Params do
    begin
      Style := Style or BS_OWNERDRAW;
      WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    end;
end;

{ Create windows control }
procedure TNvOS8Checkbox.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, BM_SETCHECK, Integer(FState), 0);
end;

{ Redraw on resize - control may be able to display more }
procedure TNvOS8Checkbox.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

{ Handle window accelerated keys }
procedure TNvOS8Checkbox.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      if Focused then Toggle;
      Result := 1;
    end
  else
    inherited;
end;

{ Component notification of click }
procedure TNvOS8Checkbox.CNCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = BN_CLICKED) then Toggle;
end;

{ Component notification to draw }
procedure TNvOS8Checkbox.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

{ Component message that enabled state has changed - redraw }
procedure TNvOS8Checkbox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Repaint;
end;

{ Set the checkbox style }
procedure TNvOS8Checkbox.SetCheckStyle(Value: TNvOS8CheckStyle);
begin
  if (Value <> FCheckStyle) then
     begin
       FCheckStyle := Value;
       Repaint;
     end;
end;

{ Actually draw the control }
procedure TNvOS8Checkbox.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown: Boolean;
  Rec: TRect;
  FilCol, BorCol, CapCol, T1, B1, S1, S2: TColor;
begin
  { Assign image and canvas }
  FBuffer.Width := Self.Width;
  FBuffer.Height := Self.Height;
  FCanvas.Handle := DrawItemStruct.hDC;
  Rec := ClientRect;

  { Decode the state of the button }
  with DrawItemStruct do
    begin
      IsDown := itemState and ODS_SELECTED <> 0;
    end;

  { Setup the colors }
  if Enabled then
     begin
       BorCol := Shade.C[0];
       CapCol := Font.Color;
       if IsDown then
          begin
            T1 := Shade.C[5];
            B1 := Shade.C[9];
            FilCol := Shade.C[7];
            S1 := Shade.C[4];
            S2 := Shade.C[5];
          end
        else
          begin
            T1 := Shade.C[15];
            B1 := Shade.C[8];
            FilCol := Shade.C[13];
            S1 := Shade.C[7];
            S2 := Shade.C[10];
          end
     end
   else
     begin
       BorCol := Shade.C[8];
       CapCol := Shade.C[8];
       FilCol := Shade.C[13];
       T1 := Shade.C[8];
       B1 := Shade.C[8];
       S1 := Shade.C[0];
       S2 := Shade.C[0];
     end;

  with FBuffer.Canvas do
    begin
      Font := Self.Font;
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(ClientRect);
{      FillRect(Rect(Rec.Left+4, Rec.Top, Rec.Left+19, Rec.Bottom)); - Future use}
      Brush.Style := bsSolid;
      Brush.Color := FilCol;
      Pen.Style := psSolid;
      Pen.Color := BorCol;
      Rectangle(Rec.Left+2, Rec.Top+2, Rec.Left+14, Rec.Top+14);
      if Enabled then
         begin
           Pen.Color := T1;
           MoveTo(Rec.Left+3, Rec.Top+11);
           LineTo(Rec.Left+3, Rec.Top+3);
           LineTo(Rec.Left+12, Rec.Top+3);
           Pen.Color := B1;
           MoveTo(Rec.Left+4, Rec.Top+12);
           LineTo(Rec.Left+12, Rec.Top+12);
           LineTo(Rec.Left+12, Rec.Top+3);
         end;

    { Actual draw of status }
    Pen.Color := BorCol;
    { Draw a No check }
    If ((Self.State=cbChecked) and (CheckStyle=csNo)) or
       ((Self.State=cbUnchecked) and (CheckStyle=csYesNo)) then
       begin
         MoveTo(5,4);
         LineTo(11,10);
         MoveTo(5,5);
         LineTo(11,11);
         MoveTo(5,10);
         LineTo(11,4);
         MoveTo(5,9);
         LineTo(11,3);
         if Enabled then
            begin
              Pixels[6,10] := S1;
              Pixels[7,9] := S1;
              Pixels[9,7] := S1;
              Pixels[10,6] := S1;
              Pixels[11,5] := S1;
              Pixels[11,10] := S1;
              Pixels[6,11] := S2;
              Pixels[7,10] := S2;
              Pixels[8,9] := S2;
              Pixels[10,7] := S2;
              Pixels[11,6] := S2;
              Pixels[11,11] := S2;
            end;
       end;
    { Draw a Yes tick }
    If (Self.State=cbChecked) and ((CheckStyle=csYes) or (CheckStyle=csYesNo)) then
       begin
         MoveTo(4,7);
         LineTo(7,10);
         LineTo(15,2);
         MoveTo(5,7);
         LineTo(7,9);
         LineTo(14,2);
         if Enabled then
           begin
             Pixels[5,9] := S2;
             Pixels[6,10] := S2;
             Pen.Color := S1;
             MoveTo(7,11);
             LineTo(13,5);
             Pen.Color := S2;
             MoveTo(8,11);
             LineTo(12,7);
             Pixels[14,4] := Shade.C[7];
             Pixels[15,4] := Shade.C[10];
             Pixels[14,5] := Shade.C[10];
           end;
       end;

    If (Self.State = cbGrayed) then
       begin
         Rectangle(5,7,11,9);
         if Enabled then
            begin
              Pen.Color := S2;
              MoveTo(6,9);
              LineTo(11,9);
              LineTo(11,6);
            end;
       end;

    { Caption }
    Font.Color := CapCol;
    Brush.Color := Self.Color;
    Brush.Style := bsSolid;
    Rec.Left := Rec.Left + 19;
    DrawText(Handle, PChar(Caption), Length(Caption), Rec, DT_VCENTER or DT_SINGLELINE);
  end;

  { Paint completed image & release }
  FCanvas.Draw(0, 0, FBuffer);
  FCanvas.Handle := 0;
end;

{ If base-color changes, reload shades table and redraw }
procedure TNvOS8Checkbox.SetColorServer(Value: TNvOS8ColorServer);
begin
  if (Value <> FColorServer) then
     begin
       FColorServer := Value;
       Shade := FColorServer.BaseShade;
       Repaint;
     end;
end;

end.
